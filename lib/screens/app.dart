import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:journal/managers/app.dart';
import 'package:journal/screens/notes.dart';
import 'package:journal/screens/note.dart';
import 'package:journal/screens/settings.dart';
import 'package:journal/screens/unlock.dart';
import 'package:journal/services/navigation_service.dart';
import 'package:journal/services.dart';
import 'package:journal/util/build_env.dart';

class App extends StatefulWidget {
  Widget build(BuildContext context, _AppState state) {
    return StreamBuilder(
      stream: state.manager.lockingStream,
      initialData: {},
      builder: (_, snap) {
        bool locked = snap.data['locked'] ?? true;
        locked = locked && (snap.data['lockingEnabled'] ?? true);

        return locked ? state.lockApp : state.mainApp;
      },
    );
  }

  ThemeData buildTheme() {
    return ThemeData(
      primarySwatch: Colors.blue,
    );
  }

  Widget buildMaterialApp(
    _AppState state, {
    Function generateRoute,
    navigatorKey,
    routes = const <String, WidgetBuilder>{},
  }) {
    return StreamBuilder(
      stream: state.manager.uiStream,
      initialData: {},
      builder: (_, snap) {
        return MaterialApp(
          // Theme
          title: 'Notes',
          theme: buildTheme(),

          // Navigation
          initialRoute: '/',
          navigatorKey: navigatorKey,
          routes: routes,
          onGenerateRoute: generateRoute,
        );
      },
    );
  }

  Widget buildLock(_AppState state) {
    return buildMaterialApp(
      state,
      routes: {'/': (context) => UnlockScreen()},
    );
  }

  Widget buildApp(_AppState state) {
    return buildMaterialApp(
      state,
      navigatorKey: sl<NavigationService>().navigatorKey,
      generateRoute: state.appGenerateRoute,
    );
  }

  @override
  State<StatefulWidget> createState() => _AppState();
}

class _AppState extends State<App> with WidgetsBindingObserver {
  AppManager manager = sl<AppManager>();

  bool firstBuild = true;
  Widget lockApp, mainApp; // Cache

  @override
  Widget build(BuildContext context) {
    if (firstBuild || sl<BuildEnv>().debug) {
      // No need to rebuild apps on each state change
      lockApp = widget.buildLock(this);
      mainApp = widget.buildApp(this);

      firstBuild = false;
    }

    return widget.build(context, this);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // App state - Lock when app is hidden
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) manager.lock();
  }

  // Routes
  Route<dynamic> appGenerateRoute(RouteSettings settings) {
    Function builder = (_) => NotesScreen();

    switch (settings.name) {
      case NotesScreen.routeName:
        builder = (_) => NotesScreen();
        break;
      case NoteScreen.routeName:
        builder = (_) => NoteScreen(settings.arguments);
        break;

      case SettingsScreen.routeName:
        builder = (_) => SettingsScreen();
        break;
    }

    return MaterialPageRoute(builder: builder);
  }
}
