import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:journal/util/field_managers/rx_field.dart';

class RxTextField extends StatelessWidget {
  final RxTextFieldManager manager;
  final Function(String) builder;

  RxTextField(
    this.manager, {
    Key key,
    String initialValue,
    FocusNode focusNode,
    InputDecoration decoration = const InputDecoration(),
    TextInputType keyboardType,
    TextCapitalization textCapitalization = TextCapitalization.none,
    TextInputAction textInputAction,
    TextStyle style,
    StrutStyle strutStyle,
    TextDirection textDirection,
    TextAlign textAlign = TextAlign.start,
    bool autofocus = false,
    bool readOnly = false,
    ToolbarOptions toolbarOptions,
    bool showCursor,
    bool obscureText = false,
    bool autocorrect = true,
    bool autovalidate = false,
    bool maxLengthEnforced = true,
    int maxLines = 1,
    int minLines,
    bool expands = false,
    int maxLength,
    ValueChanged<String> onChanged,
    GestureTapCallback onTap,
    VoidCallback onEditingComplete,
    ValueChanged<String> onFieldSubmitted,
    FormFieldSetter<String> onSaved,
    FormFieldValidator<String> validator,
    List<TextInputFormatter> inputFormatters,
    bool enabled = true,
    double cursorWidth = 2.0,
    Radius cursorRadius,
    Color cursorColor,
    Brightness keyboardAppearance,
    EdgeInsets scrollPadding = const EdgeInsets.all(20.0),
    bool enableInteractiveSelection = true,
    InputCounterWidgetBuilder buildCounter,
  }) : builder = ((error) => TextField(
              decoration: decoration.copyWith(errorText: error),
              controller: manager.controller,
              focusNode: manager.focus,
              // Delegates
              keyboardType: keyboardType,
              textInputAction: textInputAction,
              style: style,
              strutStyle: strutStyle,
              textAlign: textAlign,
              textDirection: textDirection,
              textCapitalization: textCapitalization,
              autofocus: autofocus,
              toolbarOptions: toolbarOptions,
              readOnly: readOnly,
              showCursor: showCursor,
              obscureText: obscureText,
              autocorrect: autocorrect,
              maxLengthEnforced: maxLengthEnforced,
              maxLines: maxLines,
              minLines: minLines,
              expands: expands,
              maxLength: maxLength,
              onTap: onTap,
              onEditingComplete: onEditingComplete,
              onSubmitted: onFieldSubmitted,
              onChanged: onChanged,
              inputFormatters: inputFormatters,
              enabled: enabled,
              cursorWidth: cursorWidth,
              cursorRadius: cursorRadius,
              cursorColor: cursorColor,
              scrollPadding: scrollPadding,
              keyboardAppearance: keyboardAppearance,
              enableInteractiveSelection: enableInteractiveSelection,
              buildCounter: buildCounter,
            ));

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String>(
      stream: manager.errorStream,
      initialData: null,
      builder: (_, snapshot) => builder(snapshot.data),
    );
  }
}
