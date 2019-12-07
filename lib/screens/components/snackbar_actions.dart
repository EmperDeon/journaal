import 'package:flutter/material.dart';
import 'package:journal/screens/components/i18n/text.dart';
import 'package:journal/services/i18n.dart';

class SnackbarActions {
  static SnackBar removeWarning(Function() onAction) {
    return SnackBar(
      backgroundColor: Colors.redAccent,
      content: TextTr('snackbar.are_you_sure'),
      duration: Duration(seconds: 5),
      action: SnackBarAction(
        textColor: Colors.white,
        label: I18n.t('snackbar.yes'),
        onPressed: onAction,
      ),
    );
  }
}
