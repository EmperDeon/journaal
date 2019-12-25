import 'package:flutter/material.dart';
import 'package:journal/managers/unlock.dart';
import 'package:journal/screens/components/fields/text.dart';
import 'package:journal/screens/base.dart';

class UnlockScreen extends BaseScreen<UnlockManager> {
  static const String routeName = '/unlock';

  UnlockScreen({Key key}) : super(titleTr: 'screens.unlock', key: key);

  @override
  Widget buildContent(BuildContext c, UnlockManager manager) {
    ThemeData theme = Theme.of(c);

    return Padding(
      padding: const EdgeInsets.all(64.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          RxTextField(
            manager.password,
            onFieldSubmitted: (_) => manager.submit(),
            titleTr: 'unlock.password',
            obscureText: true,
            keyboardType: manager.passwordMode == 'pin'
                ? TextInputType.number
                : TextInputType.visiblePassword,
          ),
          Padding(padding: EdgeInsets.all(25.0)),
          RaisedButton(
            color: theme.primaryColor,
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                t(c, 'actions.unlock'),
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
    );
  }

  @override
  UnlockManager createManager() => UnlockManagerImpl();
}
