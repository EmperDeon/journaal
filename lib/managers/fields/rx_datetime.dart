import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:journal/managers/fields/base.dart';
import 'package:journal/presenters/picker.dart';
import 'package:journal/services/i18n.dart';
import 'package:rxdart/rxdart.dart';

class RxDateTimeFieldManager {
  TextEditingController controller = TextEditingController();

  RxDateTimeMode mode;
  DateTime value;
  String formatTr;

  RxOnChangedDate _onChangedCallback;
  RxValidateDate _validateWith;

  RxDateTimeFieldManager({
    DateTime initialValue,
    RxOnChangedDate onChangedCallback,
    RxValidateDate validateWith,
    this.mode = RxDateTimeMode.datetime,
    this.formatTr,
  }) {
    value = initialValue;
    formatTr ??= defaultForMode();

    _validateWith = validateWith ?? ((_) => null);
    _onChangedCallback = onChangedCallback ?? ((_) => null);
  }

  void dispose() {
    _valueSubject.close();
    _errorSubject.close();
  }

  void reset() {
    _onChanged();

    _errorSubject.add(null);
  }

  String defaultForMode() {
    switch (mode) {
      case RxDateTimeMode.date:
        return 'date';
      case RxDateTimeMode.time:
        return 'time';
      case RxDateTimeMode.datetime:
        return 'datetime';
      default:
        return 'date';
    }
  }

  //
  // Changed
  //

  BehaviorSubject<DateTime> _valueSubject = BehaviorSubject();

  Stream<DateTime> get valueStream => _valueSubject.stream
      .debounce((_) => TimerStream(true, const Duration(milliseconds: 100)))
      .distinct();

  void _onChanged() {
    _onChangedCallback(value);

    validate();
    _valueSubject.add(value);
  }

  // Update value in controller
  void updateController(BuildContext c) {
    controller.text = I18n.l(c, formatTr, value, nullMessage: '');
  }

  // Generate action to open picker
  Function() openPicker(BuildContext c) {
    return () {
      PickerPresenter.date((Picker picker, dynamic newValue) {
        if (mode == RxDateTimeMode.date)
          value = DateTime(PickerPresenter.baseYear + newValue[2],
              newValue[1] + 1, newValue[0] + 1);

        _onChanged();
      }).toPicker().showModal(c);
    };
  }

  //
  // Validation
  //

  BehaviorSubject<String> _errorSubject = BehaviorSubject();

  Stream<String> get errorStream => _errorSubject.stream
      .debounce((_) => TimerStream(true, const Duration(milliseconds: 100)))
      .distinct();

  bool validate() {
    return validateWith(value);
  }

  bool validateWith(DateTime val) {
    String result = _validateWith(val);

    _errorSubject.add(result);

    return result == null;
  }
}
