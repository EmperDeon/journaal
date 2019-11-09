import 'package:journal/util/storable_model.dart';

class SettingsModel extends StorableModel {
  String password, passwordHash;

  SettingsModel() : super('settings');

  //
  // Field methods
  //

  bool lockingEnabled() {
    return password.length > 0;
  }

  bool checkPassword(String pass) {
    return password == pass;
  }

  //
  // Load/Save
  //

  @override
  void load(dynamic object) {
    if (object is Map<String, dynamic> && object.length > 0) {
      password = object['password'];
      passwordHash = object['password_hash'];

    } else {
      var type = object.runtimeType;
      print('Unsupported type for Entries: $object, $type');
    }

    notifyListeners();
  }

  @override
  save() {
    return {
      'password': password,
      'password_hash': passwordHash
    };
  }
}
