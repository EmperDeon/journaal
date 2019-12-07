import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:journal/screens/components/i18n/builder.dart';
import 'package:journal/services/i18n.dart';
import 'package:rx_command/rx_command.dart';

class RxDropdownField extends StatelessWidget {
  final Widget Function(BuildContext) builder;

  // Title of field
  final String title;

  // Key for translation of title
  final String titleTr;

  RxDropdownField({
    Key key,
    List<String> dataSource,
    String value,
    RxCommand valueCommand,
    this.title,
    this.titleTr,
    String prefixTr,
  })  : builder = ((_) => InputDecorator(
              decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(0, 16, 0, 0),
                labelText: titleTr == null ? title : I18n.t(titleTr),
                filled: false,
              ),
              child: StreamBuilder(
                stream: valueCommand,
                initialData: value,
                builder: (_, snap) {
                  return DropdownButtonHideUnderline(
                    child: DropdownButton<dynamic>(
                      value: snap.data == '' ? null : snap.data,
                      onChanged: valueCommand,
                      items: dataSource.map((item) {
                        return DropdownMenuItem<dynamic>(
                          value: item,
                          child: Text(I18n.t(prefixTr + item)),
                        );
                      }).toList(),
                    ),
                  );
                },
              ),
            )),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return titleTr == null ? builder(context) : I18nBuilder(builder: builder);
  }
}
