import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:journal/services/i18n.dart';

class Section extends Builder {
  Section({
    String title,
    String titleTr,
    @required Widget child,
    List<Widget> buttons = const [],
    double leftPadding = 0,
    double topPadding = 24,
    Key key,
  })  : assert(title != null || titleTr != null),
        super(
          builder: (c) {
            TextStyle titleStyle = Theme.of(c).textTheme.title;
            return Padding(
              padding: EdgeInsets.fromLTRB(leftPadding, topPadding, 0, 0),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                          Expanded(
                            child: Text(
                              titleTr == null ? title : I18n.t(c, titleTr),
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
