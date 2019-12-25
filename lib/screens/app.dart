import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_i18n/flutter_i18n_delegate.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:journal/managers/app.dart';
import 'package:journal/screens/journal.dart';
import 'package:journal/screens/journals.dart';
import 'package:journal/screens/notes.dart';
import 'package:journal/screens/note.dart';
import 'package:journal/screens/settings.dart';
import 'package:journal/screens/unlock.dart';
import 'package:journal/services/navigation_service.dart';
import 'package:journal/services.dart';
import 'package:journal/util/build_env.dart';
import 'package:journal/util/scoped_logger.dart';

class App extends StatefulWidget with ScopedLogger {
  Widget build(BuildContext c, _AppState state) {
    logger.i('Rebuilding App');

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
    initialRoute = '/',
    routes = const <String, WidgetBuilder>{},
  }) =>
      StreamBuilder(
        stream: state.manager.uiStream,
        initialData: {},
        builder: (_, snap) {
          Locale locale = Locale(snap.data['locale'] ?? 'en');

          return MaterialApp(
            // Theme
            title: 'Notes',
            theme: buildTheme(),

            // Navigation
            initialRoute: '/',
            navigatorKey: navigatorKey,
            routes: routes,
            onGenerateRoute: generateRoute,

            // I18n
            locale: locale,
            localizationsDelegates: [
              FlutterI18nDelegate(
                useCountryCode: false,
                fallbackFile: 'en',
                path: "assets/i18n",
                forcedLocale: locale,
              ),
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate
            ],
            supportedLocales: [const Locale('en'), const Locale('ru')],
          );
        },
      );

  Widget buildLock(_AppState state) {
    return buildMaterialApp(
      state,
      routes: {'/': (context) => UnlockScreen()},
    );
  }

  Widget buildApp(_AppState state) {
    return buildMaterialApp(
      state,
      initialRoute: sl<BuildEnv>().initialRoute,
      navigatorKey: sl<NavigationService>().navigatorKey,
      generateRoute: state.appGenerateRoute,
    );
  }

  @override
  State<StatefulWidget> createState() => _AppState();
}

class _AppState extends State<App> with WidgetsBindingObserver, ScopedLogger {
  AppManager manager = sl<AppManager>();

  bool firstBuild = true;
  Widget lockApp, mainApp; // Cache

  @override
  Widget build(BuildContext c) {
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

    logger.i('Navigating to ${settings.name} with ${settings.arguments}');

    switch (settings.name) {
      case NotesScreen.routeName:
        builder = (_) => NotesScreen();
        break;
      case NoteScreen.routeName:
        builder = (_) => NoteScreen(settings.arguments);
        break;

      case JournalsScreen.routeName:
        builder = (_) => JournalsScreen();
        break;
      case JournalScreen.routeName:
        builder = (_) => JournalScreen(settings.arguments);
        break;

      case SettingsScreen.routeName:
        builder = (_) => SettingsScreen();
        break;
    }

    return MaterialPageRoute(builder: builder);
  }
}
