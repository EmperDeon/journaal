import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rx_command/rx_command.dart';

class RxIconSelector<K> extends Builder {
  RxIconSelector({
    @required Map<K, IconData> icons,
    @required RxCommand command,
    K initial,
    double iconSize = 24,
    Key key,
  }) : super(
          builder: (c) {
            ThemeData theme = Theme.of(c);

            return StreamBuilder(
              stream: command,
              initialData: initial,
              builder: (_, snap) => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: icons
                    .map((value, icon) => MapEntry(
                        value,
                        IconButton(
                          color: snap.data == value
                              ? theme.primaryColor
                              : theme.disabledColor,
                          icon: Icon(icon, size: iconSize),
                          onPressed: () => command(value),
                        )))
                    .values
                    .toList(),
              ),
            );
          },
          key: key,
        );
}
