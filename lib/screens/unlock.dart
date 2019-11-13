import 'package:flutter/material.dart';
import 'package:journal/managers/unlock.dart';
import 'package:journal/screens/components/managed_widget.dart';
import 'package:journal/screens/components/rx_text_field.dart';
import 'package:journal/services.dart';

class UnlockScreen extends ManagedWidget<UnlockManager> {
  UnlockScreen({Key key}) : super(sl<UnlockManager>(), key: key);

  Widget build(BuildContext context) {
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
            RxTextField(
              manager.password,
              onFieldSubmitted: (_) => manager.submit(),
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            Padding(padding: EdgeInsets.all(25.0)),
            RaisedButton(
              color: Colors.blue,
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  'Unlock',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(40.0),
              ),
              onPressed: manager.submit,
            ),
          ],
        ),
      ),
    );
  }
}
