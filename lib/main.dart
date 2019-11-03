import 'package:flutter/material.dart';
import 'package:journal/screens/entries.dart';
import 'package:journal/screens/entry.dart';
import 'package:journal/states/entries_notifier.dart';
import 'package:provider/provider.dart';

void main() => runApp(
    ChangeNotifierProvider(
      builder: (context) => EntriesModel(),
      child: MyApp(),
    ),
);

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
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
}
