import 'package:flutter/material.dart';
import 'package:journal/services/i18n.dart';

/// I18n Wrapper for IconButton
class IconButtonTr extends Builder {
  IconButtonTr({
    @required String tooltip,
    Key key,
    Map<String, String> args,
    int plural,

    // IconButton
    Icon icon,
    Function onPressed,
  }) : super(
          builder: (c) => IconButton(
            tooltip: I18n.t(c, tooltip, args: args, plural: plural),
            icon: icon,
            onPressed: onPressed,
          ),
          key: key,
        );
}
