import 'package:flutter/cupertino.dart';
import 'package:journal/screens/components/i18n/builder.dart';
import 'package:journal/services/i18n.dart';

/// I18n wrapper for Text
class TextTr extends I18nBuilder {
  final String trKey;
  final Map<String, String> args;
  final int plural;

  TextTr(
    this.trKey, {
    Key key,
    this.args,
    this.plural,

    // Text args
    TextStyle style,
    StrutStyle strutStyle,
    TextAlign textAlign,
    TextDirection textDirection,
    Locale locale,
    bool softWrap,
    TextOverflow overflow,
    double textScaleFactor,
    int maxLines,
    String semanticsLabel,
    TextWidthBasis textWidthBasis,
  }) : super(
          builder: (_) => Text(
            I18n.t(trKey, args: args, plural: plural),
            style: style,
            strutStyle: strutStyle,
            textAlign: textAlign,
            textDirection: textDirection,
            locale: locale,
            softWrap: softWrap,
            overflow: overflow,
            textScaleFactor: textScaleFactor,
            maxLines: maxLines,
            semanticsLabel: semanticsLabel,
            textWidthBasis: textWidthBasis,
          ),
          key: key,
        );
}
