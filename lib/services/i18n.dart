import 'package:flutter/widgets.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:journal/models/settings.dart';
import 'package:journal/services.dart';
import 'package:rxdart/rxdart.dart';

class I18n {
  static I18n get instance => sl<I18n>();

  Map<dynamic, dynamic> decodedMap;

  // Translate key, and replace with placeholders
  static String t(String key, {Map<String, String> args, int plural}) {
    String translation = instance._translateWithKeyFallback(key);

    if (args != null) {
      translation = _replaceParams(translation, args);
    } else if (plural != null) {
      final Map<dynamic, dynamic> decodedSubMap =
          _calculateSubmap(instance.decodedMap, key);
      final String correctKey = _findCorrectKey(decodedSubMap, key, plural);
      final String parameterName =
          _findParameterName(decodedSubMap[correctKey.split(".").last]);

      translation = _replaceParams(
          translation, Map.fromIterables([parameterName], [plural.toString()]));
    }

    return translation;
  }

  //
  // Reloading
  //

  BehaviorSubject<String> _localeSubject = BehaviorSubject.seeded('en');

  // Stream for changed locale
  Stream<String> get localeStream => _localeSubject.stream.distinct();

  // Actions after initialization
  //   Subscription to locale change in settings
  void postInit() {
    SettingsModel settings = sl<SettingsModel>();
    Stream<String> localeStream =
        settings.itemsStream.map((v) => v['locale'] as String).distinct();

    localeStream.listen(reload);
  }

  // Reload translations
  void reload(String locale) async {
    locale ??= 'en';

    print('Updated locale with $locale');
    FlutterI18n tr = FlutterI18n(false, 'en', 'assets/i18n', Locale(locale));

    await tr.load();

    decodedMap = tr.decodedMap;

    _localeSubject.add(locale);
  }

  void dispose() {
    _localeSubject.close();
  }

  //
  // Flutter18n methods
  //

  static RegExp _parameterRegexp = new RegExp("{(.+)}");

  String _translateWithKeyFallback(final String key) {
    String translation = _decodeFromMap(decodedMap, key);
    if (translation == null) {
      // print("**$key** not found");
      translation = key;
    }
    return translation;
  }

  static String _replaceParams(
      String translation, final Map<String, String> translationParams) {
    for (final String paramKey in translationParams.keys) {
      translation = translation.replaceAll(
          new RegExp('{$paramKey}'), translationParams[paramKey]);
    }
    return translation;
  }

  static String _decodeFromMap(
      Map<dynamic, dynamic> decodedStrings, final String key) {
    final Map<dynamic, dynamic> subMap = _calculateSubmap(decodedStrings, key);
    final String lastKeyPart = key.split(".").last;
    return subMap[lastKeyPart];
  }

  static Map<dynamic, dynamic> _calculateSubmap(
      Map<dynamic, dynamic> decodedMap, final String translationKey) {
    final List<String> translationKeySplitted = translationKey.split(".");
    translationKeySplitted.removeLast();
    translationKeySplitted.forEach((listKey) => decodedMap =
        decodedMap != null && decodedMap[listKey] != null
            ? decodedMap[listKey]
            : new Map());
    return decodedMap;
  }

  static String _findCorrectKey(Map<dynamic, dynamic> decodedSubMap,
      String translationKey, final int pluralValue) {
    final List<String> splittedKey = translationKey.split(".");
    translationKey = splittedKey.removeLast();
    List<int> possiblePluralValues = decodedSubMap.keys
        .where((mapKey) => mapKey.startsWith(translationKey))
        .where((mapKey) => mapKey.split("-").length == 2)
        .map((mapKey) => int.tryParse(mapKey.split("-")[1]))
        .where((mapKeyPluralValue) => mapKeyPluralValue != null)
        .where((mapKeyPluralValue) => mapKeyPluralValue <= pluralValue)
        .toList();
    possiblePluralValues.sort();
    String lastKeyPart = "$translationKey-";

    if (possiblePluralValues.length > 0)
      lastKeyPart += possiblePluralValues.last.toString();

    splittedKey.add(lastKeyPart);
    return splittedKey.join(".");
  }

  static String _findParameterName(final String translation) {
    String parameterName = "";
    if (translation != null && _parameterRegexp.hasMatch(translation)) {
      final Match match = _parameterRegexp.firstMatch(translation);
      parameterName = match.groupCount > 0 ? match.group(1) : "";
    }
    return parameterName;
  }
}
