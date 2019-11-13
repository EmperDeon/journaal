import 'package:journal/managers/base.dart';
import 'package:journal/services.dart';
import 'package:journal/util/field_managers/rx_field.dart';
import 'package:journal/util/storage.dart';
import 'package:rxdart/rxdart.dart';

abstract class UnlockManager extends BaseManager {
  // Streams
  Stream<bool> get lockingStream;

  // Fields
  RxTextFieldManager password;

  // Methods
  void submit({String value});
  void lock();
  bool unlockWith(String pass);
}

class UnlockManagerImpl implements UnlockManager {
  final Storage storage = sl<Storage>();
  bool locked;

  UnlockManagerImpl() {
    locked = storage.isPasswordSet();
    updateSubjects();

    password = RxTextFieldManager(
        mode: ValidateMode.none,
        onChangedCallback: passwordChanged,
        validateWith: passwordValidator);

    reset(null);
  }

  @override
  void reset(dynamic object) {
    password.text = '';
  }

  //
  // Fields
  //

  RxTextFieldManager password;

  String passwordValidator(String pass) =>
      storage.isCorrectPassword(pass) ? null : 'Incorrect password';

  void passwordChanged(String pass) {
    if (storage.isCorrectPassword(pass)) {
      unlockWith(pass);
    }
  }

  //
  // Streams
  //

  BehaviorSubject<bool> _lockingSubject = BehaviorSubject();

  @override
  Stream<bool> get lockingStream => _lockingSubject.distinct();

  void updateSubjects() {
    _lockingSubject.add(storage.isPasswordSet() && locked);
  }

  //
  // Methods
  //

  @override
  void submit({String value}) {
    bool result = password.validate();

    if (result) unlockWith(password.text);

    reset(null);
  }

  @override
  void lock() {
    locked = true;

    updateSubjects();
  }

  @override
  bool unlockWith(String pass) {
    bool result = storage.isCorrectPassword(pass);

    if (result) locked = false;

    updateSubjects();
    return result;
  }
}
