import 'package:flutter/material.dart';
import 'package:journal/screens/components/i18n/builder.dart';
import 'package:journal/services/i18n.dart';

/// I18n Wrapper for IconButton
class IconButtonTr extends I18nBuilder {
  final String tooltip;
  final Map<String, String> args;
  final int plural;

  IconButtonTr({
    @required this.tooltip,
    Key key,
    this.args,
    this.plural,

    // IconButton
    Icon icon,
    Function onPressed,
  }) : super(
          builder: (_) => IconButton(
            tooltip: I18n.t(tooltip, args: args, plural: plural),
            icon: icon,
            onPressed: onPressed,
          ),
          key: key,
        );
}
