import 'package:flutter/cupertino.dart';
import 'package:journal/services/i18n.dart';

/// I18n wrapper for Text
class TextTr extends Builder {
  TextTr(
    String trKey, {
    Key key,
    Map<String, String> args,
    int plural,

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
          builder: (c) => Text(
            I18n.t(c, trKey, args: args, plural: plural),
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
