import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:journal/models/entries_model.dart';
import 'package:journal/models/settings_model.dart';
import 'package:journal/screens/entries.dart';
import 'package:journal/screens/entry.dart';
import 'package:journal/screens/settings.dart';
import 'package:journal/screens/unlock.dart';
import 'package:journal/services/navigation_service.dart';
import 'package:journal/services/services.dart';
import 'package:journal/util/crypto.dart';
import 'package:journal/util/storage.dart';
import 'package:provider/provider.dart';

void main() async {
  await DotEnv().load('.env');
  print(DotEnv().env);

  Storage storage = Storage.instance;
  Crypto crypto = Crypto();

  GetIt.I.registerSingleton<Storage>(storage);
  GetIt.I.registerSingleton<Crypto>(crypto);

  storage.loadFromStorage();

  initServices();

  print(crypto.derivePassword('11223344'));
  print(crypto.derivePassword('password'));
  print(crypto.derivePassword('PaSsWoRd'));

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(builder: (_) => EntriesModel()),
        ChangeNotifierProvider(builder: (_) => SettingsModel()),
        ChangeNotifierProvider(builder: (_) => storage),
      ],
      child: App(),
    ),
   );
}

class App extends StatefulWidget {
  Widget build(BuildContext context, bool locked) {
    if (locked) {
      return _buildLock();
    } else {
      return _buildApp();
    }
  }

  Widget _buildLock() {
    return MaterialApp(
      title: 'Locked app',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // navigatorKey: GetIt.I.get<NavigationService>().navigatorKey,
      initialRoute: '/',
      routes: {
        '/': (context) => UnlockScreen()
      },
    );
  }

  Widget _buildApp() {
    return MaterialApp(
      title: 'Notes App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      navigatorKey: GetIt.I.get<NavigationService>().navigatorKey,
      initialRoute: '/',
      routes: {
        '/': (context) => EntriesScreen(),
        '/entry': (context) => EntryScreen(),

        '/settings': (_) => SettingsScreen()
      },
    );
  }

  @override
  State<StatefulWidget> createState() => _AppState();
}

class _AppState extends State<App> with WidgetsBindingObserver {
  Storage storage = GetIt.I<Storage>();

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

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      if (state != AppLifecycleState.resumed)
        storage.lock();
    });
  }

  @override
  Widget build(BuildContext context) {
    storage = Provider.of<Storage>(context);

    return widget.build(context, storage.isLocked());
  }
}
