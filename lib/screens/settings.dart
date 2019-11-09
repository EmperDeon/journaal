import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:journal/models/settings_model.dart';
import 'package:journal/services/navigation_service.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  Widget build(BuildContext context, onSave, Map<String, TextEditingController> controllers, Map<String, Function> validators, formKey) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Settings'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.save),
            tooltip: 'Save',
            onPressed: () {
              onSave();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Form(
          key: formKey,
          child: ListView(children: <Widget>[
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Password'
              ),
              controller: controllers['password'],
              validator: validators['password'],
              obscureText: true
            )
          ],)
        )
      )
    );
  }

  @override
  State<StatefulWidget> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  NavigationService navigation = GetIt.I<NavigationService>();

  SettingsModel model;
  bool firstBuild = true;
  Map<String, TextEditingController> _controllers = {};
  Map<String, Function> _validators = {};

  final _formKey = GlobalKey<FormState>();

  _SettingsScreenState() {
    _controllers['password'] = TextEditingController();

    // _validators['password'] = passwordValidator;
  }

  //
  // State
  //

  void onSave() {
    if (!_formKey.currentState.validate()) {
      return;
    }

    model.password = _controllers['password'].text;
    model.saveToStorage();

    navigation.pop();
  }

  @override
  void dispose() {
    for (var key in _controllers.keys) {
      _controllers[key].dispose();
    }

    super.dispose();
  }

  //
  // Validators
  //

  // String passwordValidator(String value) {
  //   if (value.isEmpty) {
  //     return 'Password should be present';
  //   } else {
  //     return null;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    if (firstBuild) {
      model = Provider.of<SettingsModel>(context);

      _controllers['password'].text = model.password;
      firstBuild = false;
    }

    return widget.build(context, onSave, _controllers, _validators, _formKey);
  }
}
