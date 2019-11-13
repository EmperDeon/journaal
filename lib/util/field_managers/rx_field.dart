import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';

typedef RxFieldManagerOnChanged = Function(String);
typedef RxFieldManagerValidate = String Function(String);

// Mode
enum ValidateMode { none, onChanged }

// State manager for TextField
// Provides:
//  - stream of value and error messages
//  - validator
//  - changed callback
//
// TODO: Next focus node
class RxTextFieldManager {
  TextEditingController controller = TextEditingController();
  FocusNode focus = FocusNode();
  ValidateMode mode;

  RxFieldManagerOnChanged _onChangedCallback;
  RxFieldManagerValidate _validateWith;

  RxTextFieldManager(
      {String initialValue,
      RxFieldManagerOnChanged onChangedCallback,
      RxFieldManagerValidate validateWith,
      this.mode = ValidateMode.onChanged}) {
    text = initialValue;
    _validateWith = validateWith ?? ((_) => null);
    _onChangedCallback = onChangedCallback ?? ((_) => null);

    controller.addListener(_onChanged);
  }

  void dispose() {
    _valueSubject.close();
    _errorSubject.close();
  }

  //
  // Values
  //

  String get text => controller.text;
  set text(String v) => controller.text = v;

  //
  // Changed
  //

  BehaviorSubject<String> _valueSubject = BehaviorSubject<String>();

  Stream<String> get valueStream => _valueSubject.stream
      .debounce((_) => TimerStream(true, const Duration(milliseconds: 100)))
      .distinct();

  void _onChanged() {
    _onChangedCallback(text);

    if (mode == ValidateMode.onChanged) {
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
