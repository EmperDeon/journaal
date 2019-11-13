import 'package:flutter/material.dart';
import 'package:journal/managers/settings.dart';
import 'package:journal/screens/components/managed_widget.dart';
import 'package:journal/screens/components/rx_text_field.dart';
import 'package:journal/services.dart';

class SettingsScreen extends ManagedWidget<SettingsManager> {
  SettingsScreen({Key key}) : super(sl<SettingsManager>(), key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Settings'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.save),
            tooltip: 'Save',
            onPressed: manager.save,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: ListView(
          children: <Widget>[
            Text(
              'Security',
              style: theme.textTheme.display1,
            ),
            RxTextField(
              manager.passwordField,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            )
          ],
        ),
      ),
    );
  }
}
