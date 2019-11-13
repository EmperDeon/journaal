import 'package:journal/managers/base.dart';
import 'package:journal/models/settings_model.dart';
import 'package:journal/services/navigation_service.dart';
import 'package:journal/services.dart';
import 'package:journal/util/field_managers/rx_field.dart';
import 'package:journal/util/utils.dart';

abstract class SettingsManager extends BaseManager {
  RxTextFieldManager passwordField;

  Stream<Map<String, dynamic>> get lockingDataStream;

  void save();
}

class SettingsManagerImpl implements SettingsManager {
  SettingsModel model;
  RxTextFieldManager passwordField;

  List<RxTextFieldManager> _fields;

  SettingsManagerImpl() {
    model = sl<SettingsModel>();
    passwordField = RxTextFieldManager(initialValue: model.password);

    _fields = [passwordField];

    reset(null);
  }

  @override
  void reset(dynamic object) {
    passwordField.text = model.password;
  }

  //
  // Streams
  //

  @override
  Stream<Map<String, dynamic>> get lockingDataStream {
    return model.itemsStream
        .map((v) => selectKeys(v, ['lockingEnabled']))
        .distinct();
  }

  //
  // Methods
  //

  @override
  void save() {
    bool valid = allTrue(_fields, (field) => field.validate());

    if (valid) {
      model.password = passwordField.text;

      sl<NavigationService>().pop();
    }
  }
}
