import 'package:flutter/material.dart';
import 'package:journal/screens/entries.dart';
import 'package:journal/screens/entry.dart';
import 'package:journal/models/entries_model.dart';
import 'package:provider/provider.dart';
import 'util/storage.dart';

void main() {
  Storage storage = Storage.instance;
  storage.loadFromStorage();

  runApp(
    ChangeNotifierProvider(
      builder: (context) => EntriesModel(),
      child: App(),
    ),
   );
}

class App extends StatefulWidget {
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => EntriesScreen(),
        '/entry': (context) => EntryScreen(),
      },
    );
  }

  @override
  State<StatefulWidget> createState() => _AppState();
}

class _AppState extends State<App> with WidgetsBindingObserver {
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
        Storage.instance.lock();
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.build(context);
  }
}
