import 'package:flutter/cupertino.dart';
import 'package:journal/managers/fields/base.dart';
import 'package:rxdart/rxdart.dart';

// State manager for TextField
// Provides:
//  - stream of value and error messages
//  - validator (should return FlutterI18n translation key)
//  - changed callback
//  - FocusNode to focus next
class RxTextFieldManager {
  TextEditingController controller = TextEditingController();
  FocusNode focus = FocusNode();
  FocusNode nextFocus;
  RxValidateMode mode;

  RxFieldManagerOnChanged _onChangedCallback;
  RxFieldManagerValidate _validateWith;

  RxTextFieldManager({
    String initialValue,
    RxFieldManagerOnChanged onChangedCallback,
    RxFieldManagerValidate validateWith,
    this.mode = RxValidateMode.onChanged,
    this.nextFocus,
  }) {
    text = initialValue;
    _validateWith = validateWith ?? ((_) => null);
    _onChangedCallback = onChangedCallback ?? ((_) => null);

    controller.addListener(_onChanged);
  }

  void dispose() {
    _valueSubject.close();
    _errorSubject.close();
  }

  void reset([resetError = true]) {
    text = '';
    _onChanged();

    if (resetError) _errorSubject.add(null);
  }

  //
  // Values
  //

  String get text => controller.text;
  set text(String v) => controller.text = v;

  //
  // Changed
  //

  BehaviorSubject<String> _valueSubject = BehaviorSubject.seeded('');

  Stream<String> get valueStream => _valueSubject.stream
      .debounce((_) => TimerStream(true, const Duration(milliseconds: 100)))
      .distinct();

  void _onChanged() {
    _onChangedCallback(text);

    if (mode == RxValidateMode.onChanged) {
      validate();
    }

    _valueSubject.add(text);
  }

  //
  // Validation
  //

  BehaviorSubject<String> _errorSubject = BehaviorSubject();

  Stream<String> get errorStream => _errorSubject.stream
      .debounce((_) => TimerStream(true, const Duration(milliseconds: 100)))
      .distinct();

  bool validate() {
    return validateWith(text);
  }

  bool validateWith(String text) {
    String result = _validateWith(text);

    _errorSubject.add(result);

    return result == null;
  }
}
