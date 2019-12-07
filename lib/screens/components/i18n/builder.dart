import 'package:flutter/cupertino.dart';
import 'package:journal/services.dart';
import 'package:journal/services/i18n.dart';

/// StreamBuilder for I18n
/// Rebuilds when current locale is changed
class I18nBuilder extends StatelessWidget {
  final Widget Function(BuildContext) builder;

  I18nBuilder({@required this.builder, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: sl<I18n>().localeStream,
      builder: (context, _snap) => builder(context),
    );
  }
}
