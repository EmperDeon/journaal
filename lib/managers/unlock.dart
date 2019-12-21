import 'package:journal/managers/app.dart';
import 'package:journal/managers/base.dart';
import 'package:journal/managers/fields/base.dart';
import 'package:journal/models/settings.dart';
import 'package:journal/services.dart';
import 'package:journal/managers/fields/rx_field.dart';
import 'package:journal/util/storage.dart';

abstract class UnlockManager extends BaseManager {
  // Fields
  RxTextFieldManager password;
  String get passwordMode;

  // Methods
  void submit({String value});
}

class UnlockManagerImpl extends BaseManager implements UnlockManager {
  final Storage storage = sl<Storage>();
  final SettingsModel settings = sl<SettingsModel>();

  UnlockManagerImpl() {
    password = RxTextFieldManager(
      mode: RxValidateMode.none,
      onChangedCallback: passwordChanged,
      validateWith: passwordValidator,
    );
  }

  //
  // Fields
  //

  RxTextFieldManager password;

  String passwordValidator(String pass) => storage.isCorrectPassword(pass)
      ? null
      : 'errors.unlock.incorrect_password';

  void passwordChanged(String pass) {
    if (storage.isCorrectPassword(pass)) {
      unlockWith(pass);
    }
  }

  String get passwordMode => settings.passwordMode;

  //
  // Methods
  //

  @override
  void submit({String value}) {
    bool result = password.validate();

    if (result) unlockWith(password.text);

    password.reset();
  }

  bool unlockWith(String pass) {
    return sl<AppManager>().unlockWith(pass);
  }
}
