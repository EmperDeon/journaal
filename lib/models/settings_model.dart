import 'package:journal/models/base.dart';

abstract class SettingsModel {
  // Streams
  Stream<Map<String, dynamic>> get itemsStream;

  // Common
  String get password;
  set password(String pass);

  bool lockingEnabled();
  bool checkPassword(String pass);
}

class SettingsModelImpl extends BaseModel<Map<String, dynamic>>
    implements SettingsModel {
  String _password = '', passwordHash = '';

  SettingsModelImpl() : super('settings');

  //
  // Field methods
  //

  @override
  bool lockingEnabled() => _password.length > 0;

  @override
  bool checkPassword(String pass) => _password == pass;

  @override
  String get password => _password;

  @override
  set password(String pass) {
    _password = pass;
    updateSubject();
  }

  //
  // Load/Save
  //

  @override
  Map<String, dynamic> toSubjectData() => {'lockingEnabled': lockingEnabled()};

  @override
  void load(dynamic object) {
    if (object is Map<String, dynamic> && object.length > 0) {
      password = object['password'] ?? '';
      passwordHash = object['password_hash'] ?? '';
    } else {
      var type = object.runtimeType;
      print('Unsupported type for Entries: $object, $type');
    }

    print("Loaded Settings: $object");
    updateSubject();
  }

  @override
  dynamic save() {
    return {'password': _password, 'password_hash': passwordHash};
  }
}
