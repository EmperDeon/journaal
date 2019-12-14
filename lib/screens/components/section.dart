import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Section extends Builder {
  Section({
    @required String title,
    @required Widget child,
    List<Widget> buttons = const [],
    double leftPadding = 8,
    Key key,
  }) : super(
          builder: (c) {
            TextStyle titleStyle = Theme.of(c).textTheme.title;
            return Padding(
              padding: EdgeInsets.fromLTRB(leftPadding, 24, 0, 0),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                          Expanded(
                            child: Text(
                              title,
                              style: titleStyle,
                            ),
                          )
                        ] +
                        buttons,
                  ),
                  child,
                ],
              ),
            );
          },
          key: key,
        );
}
