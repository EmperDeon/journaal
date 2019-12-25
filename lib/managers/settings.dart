import 'package:journal/managers/app.dart';
import 'package:journal/managers/base.dart';
import 'package:journal/models/settings.dart';
import 'package:journal/services/navigation_service.dart';
import 'package:journal/services.dart';
import 'package:journal/managers/fields/rx_field.dart';
import 'package:journal/util/build_env.dart';
import 'package:journal/util/utils.dart';
import 'package:rx_command/rx_command.dart';

abstract class SettingsManager extends BaseManager {
  RxTextFieldManager passwordField;
  RxCommand<String, String> updateLocale, updatePasswordMode;
  RxCommand<bool, bool> updateAutoUnlock;

  Stream<Map<String, dynamic>> get lockingDataStream;

  String get locale;
  String get passwordMode;
  bool get autoUnlock;

  void save();
}

class SettingsManagerImpl extends BaseManager implements SettingsManager {
  SettingsModel model = sl<SettingsModel>();
  RxTextFieldManager passwordField;
  String _locale, _passwordMode;
  bool _autoUnlock;

  List<RxTextFieldManager> _fields;

  SettingsManagerImpl() {
    passwordField = RxTextFieldManager(
        initialValue: model.password, validateWith: passwordValidator);

    updateLocale = RxCommand.createSync<String, String>(_setLocale);
    updatePasswordMode = RxCommand.createSync<String, String>(_setPasswordMode);
    updateAutoUnlock = RxCommand.createSync<bool, bool>(_setAutoUnlock);

    _fields = [passwordField];

    updateLocale(model.locale);
    updatePasswordMode(model.passwordMode);
    updateAutoUnlock(model.autoUnlock);
  }

  //
  // Streams
  //

  @override
  Stream<Map<String, dynamic>> get lockingDataStream => model.itemsStream
      .map((v) => selectKeys(v, ['lockingEnabled']))
      .distinct();

  //
  // Fields
  //

  @override
  RxCommand<String, String> updateLocale, updatePasswordMode;
  RxCommand<bool, bool> updateAutoUnlock;

  String get locale => _locale;
  String get passwordMode => _passwordMode;
  bool get autoUnlock => _autoUnlock;

  String _setLocale(String l) => _locale = l;
  String _setPasswordMode(String mode) => _passwordMode = mode;
  bool _setAutoUnlock(bool mode) => _autoUnlock = mode;

  String passwordValidator(String pass) =>
      (pass.length == 0 && _passwordMode != 'none')
          ? 'errors.setting.no_password'
          : null;

  //
  // Methods
  //

  @override
  void save() {
    if (_passwordMode == 'none') {
      passwordField.text = '';
    } else if (_passwordMode == 'pin') {
      // Remove all symbols, that are not present on phone keyboard
      passwordField.text =
          passwordField.text.replaceAll(new RegExp(r'[^0-9.,\-+\ ]'), '');
    }

    bool valid = allTrue(_fields, (field) => field.validate());

    if (valid) {
      model.password = passwordField.text;
      model.locale = _locale;
      model.passwordMode = _passwordMode;
      model.autoUnlock = _autoUnlock;

      model.updateSubject();

      sl<AppManager>().unlockWith(model.password);

      sl<NavigationService>().replaceWith(sl<BuildEnv>().initialRoute);
    }
  }
}
