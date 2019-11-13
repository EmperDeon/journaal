import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:journal/managers/unlock.dart';
import 'package:journal/screens/entries.dart';
import 'package:journal/screens/entry.dart';
import 'package:journal/screens/settings.dart';
import 'package:journal/screens/unlock.dart';
import 'package:journal/services/navigation_service.dart';
import 'package:journal/services.dart';
import 'package:journal/util/build_env.dart';

class App extends StatefulWidget {
  Widget build(BuildContext context, _AppState state) {
    return StreamBuilder(
      stream: state.manager.lockingStream,
      initialData: null,
      builder: (_, snap) {
        bool locked = snap.data ?? true;
        return locked ? state.lockApp : state.mainApp;
      },
    );
  }

  ThemeData buildTheme() {
    return ThemeData(primarySwatch: Colors.blue);
  }

  Widget buildLock(_AppState state) {
    return MaterialApp(
      title: 'Locked app',
      theme: buildTheme(),
      // navigatorKey: sl<NavigationService>().navigatorKey,
      initialRoute: '/',
      routes: {'/': (context) => UnlockScreen()},
    );
  }

  Widget buildApp(_AppState state) {
    return MaterialApp(
      title: 'Notes App',
      theme: buildTheme(),
      navigatorKey: sl<NavigationService>().navigatorKey,
      initialRoute: '/',
      onGenerateRoute: state.appGenerateRoute,
    );
  }

  @override
  State<StatefulWidget> createState() => _AppState();
}

class _AppState extends State<App> with WidgetsBindingObserver {
  UnlockManager manager = sl<UnlockManager>();

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
    Function builder = (_) => EntriesScreen();

    switch (settings.name) {
      case '/':
        builder = (_) => EntriesScreen();
        break;
      case '/entry':
        builder = (_) => EntryScreen(settings.arguments);
        break;

      case '/settings':
        builder = (_) => SettingsScreen();
        break;
    }

    return MaterialPageRoute(builder: builder);
  }
}
