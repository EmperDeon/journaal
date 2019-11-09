import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:journal/util/storage.dart';

class UnlockScreen extends StatefulWidget {
  Widget build(BuildContext context, onTryUnlock, formKey, passController, validator) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Unlock'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(64.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Form(
              key: formKey,
              child: TextFormField(
                decoration: InputDecoration(labelText: 'Password'),
                controller: passController,
                onFieldSubmitted: (_) => onTryUnlock(silent: false),
                validator: validator,
                obscureText: true,
              ),
            ),
            Padding(padding: EdgeInsets.all(25.0)),
            RaisedButton(
              color: Colors.blue,
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Text('Unlock', style: TextStyle(fontSize: 20, color: Colors.white)),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(40.0)
              ),
              onPressed: () => onTryUnlock(silent: false),
            )
          ],
        )
      )
    );
  }

  @override
  State<StatefulWidget> createState() => _UnlockScreenState();
}

class _UnlockScreenState extends State<UnlockScreen> {
  final _formKey = GlobalKey<FormState>();
  final Storage storage = GetIt.I<Storage>();

  bool firstBuild = true;
  TextEditingController passController = TextEditingController();

  //
  // State
  //

  String validateField(String pass) {
    if (!storage.isCorrectPassword(passController.text)) {
      return 'Incorrect password';
    }

    return null;
  }

  void onTryUnlock({bool silent = false}) {
    bool valid = false;

    if (!silent) {
      valid = _formKey.currentState.validate();
    } else {
      valid = storage.isCorrectPassword(passController.text);
    }

    if (valid)
      storage.unlock();
  }

  @override
  void dispose() {
    passController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (firstBuild) {
      firstBuild = false;

      passController.addListener(() => onTryUnlock(silent: true));
    }

    return widget.build(context, onTryUnlock, _formKey, passController, validateField);
  }
}
