import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:journal/presenters/base.dart';

enum PickerType { Date }

@immutable
class PickerPresentation extends ScaffoldPresentation {
  final PickerType type;
  final Function(Picker picker, dynamic value) action;

  PickerPresentation({
    @required this.type,
    @required this.action,
  });

  PickerAdapter adapter() {
    switch (type) {
      case PickerType.Date:
        return DateTimePickerAdapter(
          type: PickerDateTimeType.kDMY,
          yearBegin: PickerPresenter.baseYear,
        );

      default:
        return null;
    }
  }

  Picker toPicker() {
    return Picker(adapter: adapter(), onConfirm: action);
  }
}

class PickerPresenter {
  static int baseYear = 2000;

  static PickerPresentation date(
      Function(Picker picker, dynamic value) action) {
    return PickerPresentation(
      type: PickerType.Date,
      action: action,
    );
  }
}
