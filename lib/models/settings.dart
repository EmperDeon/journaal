import 'package:journal/models/base.dart';

/// Settings model
///
/// stored value:
/// {
///   password: string,
///   passwordHash: string,
///   passwordMode: string,
///   locale: string,
/// }
///
abstract class SettingsModel {
  // Streams
  Stream<Map<String, dynamic>> get itemsStream;

  // Common
  String password, passwordMode, locale;

  bool lockingEnabled();
  bool checkPassword(String pass);

  dynamic save();
}

class SettingsModelImpl extends BaseModel<Map<String, dynamic>>
    implements SettingsModel {
  String _password = '', _passwordMode = 'none', _passwordHash = '';
  String _locale;

  SettingsModelImpl() : super('settings', skeletonValue: {});

  //
  // Field methods
  //

  @override
  bool lockingEnabled() => _passwordMode != null && _passwordMode != 'none';

  @override
  bool checkPassword(String pass) => _password == pass;

  @override
  String get password => _password;

  @override
  set password(String pass) {
    _password = pass;
    updateSubject();
  }

  @override
  String get locale => _locale;

  @override
  set locale(String locale) {
    _locale = locale;
    updateSubject();
  }

  @override
  String get passwordMode => _passwordMode;

  @override
  set passwordMode(String mode) {
    _passwordMode = mode;
    updateSubject();
  }

  //
  // Load/Save
  //

  @override
  Map<String, dynamic> toSubjectData() => {
        'lockingEnabled': lockingEnabled(),
        'passwordMode': _passwordMode,
        'locale': _locale
      };

  @override
  void load(dynamic object) {
    if (object is Map<String, dynamic> && object.length > 0) {
      _password = object['password'] ?? '';
      _passwordHash = object['password_hash'] ?? '';
      _passwordMode = object['passwordMode'];
      _locale = object['locale'];

      if (_locale == null || _locale == '') _locale = 'en';
      if (_passwordMode == null || _passwordMode == '') _passwordMode = 'none';
    } else if (object != null) {
      var type = object.runtimeType;
      print('Unsupported type for Notes: $object, $type');
    }

    print("Loaded Settings: ${toSubjectData()}");
    updateSubject();
  }

  @override
  dynamic save() {
    return {
      'password': _password,
      'passwordMode': _passwordMode,
      'password_hash': _passwordHash,
      'locale': _locale
    };
  }
}
