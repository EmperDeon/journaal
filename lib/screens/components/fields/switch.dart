import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:journal/services/i18n.dart';
import 'package:rx_command/rx_command.dart';

class RxSwitchField extends Builder {
  // Title of field
  final String title;

  // Key for translation of title
  final String titleTr;

  RxSwitchField({
    Key key,
    bool value,
    RxCommand<bool, bool> valueCommand,
    bool enabled = true,
    this.title,
    this.titleTr,
  }) : super(
          builder: (c) => Row(
            children: [
              Text(titleTr == null ? title : I18n.t(c, titleTr)),
              Spacer(flex: 2),
              StreamBuilder(
                stream: valueCommand,
                initialData: value,
                builder: (_, snap) => Switch(
                  value: snap.data,
                  onChanged: enabled ? valueCommand : null,
                ),
              ),
            ],
          ),
          key: key,
        );
}
