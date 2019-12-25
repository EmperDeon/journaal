import 'package:flutter/material.dart';
import 'package:journal/presenters/base.dart';
import 'package:journal/services/i18n.dart';

enum SnackbarType { Info, Warning, Error }

@immutable
class SnackbarPresentation extends ScaffoldPresentation {
  final SnackbarType type;
  final String contentTr, actionTr;
  final Function() action;

  SnackbarPresentation({
    @required this.type,
    @required this.contentTr,
    this.action,
    this.actionTr,
  });

  Color backgroundColor() {
    switch (type) {
      case SnackbarType.Info:
        return Colors.blueAccent;
      case SnackbarType.Warning:
        return Colors.yellowAccent;
      case SnackbarType.Error:
        return Colors.redAccent;
      default:
        return Colors.black45;
    }
  }

  Color textColor() {
    switch (type) {
      case SnackbarType.Info:
        return Colors.white;
      case SnackbarType.Warning:
        return Colors.black;
      case SnackbarType.Error:
        return Colors.white;
      default:
        return Colors.white;
    }
  }

  Duration duration() => Duration(seconds: type == SnackbarType.Error ? 5 : 2);

  SnackBar toBar(BuildContext c) => SnackBar(
        backgroundColor: backgroundColor(),
        content: Text(I18n.t(c, contentTr)),
        duration: duration(),
        action: action == null
            ? null
            : SnackBarAction(
                textColor: textColor(),
                label: I18n.t(c, actionTr),
                onPressed: action,
              ),
      );
}

class SnackbarPresenter {
  static SnackbarPresentation removeWarning(Function() action) {
    return SnackbarPresentation(
      type: SnackbarType.Error,
      contentTr: 'snackbar.are_you_sure',
      action: action,
      actionTr: 'snackbar.yes',
    );
  }

  static ScaffoldPresentation saved() {
    return SnackbarPresentation(
      type: SnackbarType.Info,
      contentTr: 'snackbar.saved',
      action: null,
    );
  }
}
