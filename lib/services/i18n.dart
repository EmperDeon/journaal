import 'package:flutter/widgets.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:intl/intl.dart';

class I18n {
  // Translate key, and replace with placeholders
  static String t(BuildContext c, String key,
      {Map<String, String> args, int plural}) {
    if (plural == null) {
      return FlutterI18n.translate(c, key, args);
    } else {
      return FlutterI18n.plural(c, key, plural);
    }
  }

  static String l(BuildContext c, String key, DateTime dateTime) {
    if (dateTime == null) return 'null datetime';

    DateFormat format = DateFormat(
        t(c, 'datetime.' + key), FlutterI18n.currentLocale(c).toString());

    return format.format(dateTime);
  }
}
