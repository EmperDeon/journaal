import 'package:journal/models/base.dart';

/// Settings model
///
/// stored value:
/// {
///   password: string,
///   passwordHash: string,
///   passwordMode: string,
///   autoUnlock: bool,
///   locale: string,
/// }
///
abstract class SettingsModel {
  // Streams
  Stream<Map<String, dynamic>> get itemsStream;

  // Common
  String password, passwordMode, locale;
  bool autoUnlock;

  bool lockingEnabled();
  bool checkPassword(String pass);

  dynamic save();
  void updateSubject();
}

class SettingsModelImpl extends BaseModel<Map<String, dynamic>>
    implements SettingsModel {
  String password = '', passwordMode = 'none', _passwordHash = '';
  String locale;
  bool autoUnlock = false;

  SettingsModelImpl() : super('settings', skeletonValue: {});

  //
  // Field methods
  //

  @override
  bool lockingEnabled() => passwordMode != null && passwordMode != 'none';

  @override
  bool checkPassword(String pass) => password == pass;

  //
  // Load/Save
  //

  @override
  Map<String, dynamic> toSubjectData() => {
        'lockingEnabled': lockingEnabled(),
        'passwordMode': passwordMode,
        'autoUnlock': autoUnlock,
        'locale': locale
      };

  @override
  void load(dynamic object) {
    if (object is Map<String, dynamic> && object.length > 0) {
      password = object['password'] ?? '';
      _passwordHash = object['password_hash'] ?? '';
      passwordMode = object['passwordMode'];
      autoUnlock = object['autoUnlock'] ?? false;
      locale = object['locale'];

      if (locale == null || locale == '') locale = 'en';
      if (passwordMode == null || passwordMode == '') passwordMode = 'none';
    } else if (object != null) {
      var type = object.runtimeType;
      logger.w('Unsupported type for Notes: $object, $type');
    }

    updateSubject();
  }

  @override
  dynamic save() {
    return {
      'password': password,
      'passwordMode': passwordMode,
      'password_hash': _passwordHash,
      'autoUnlock': autoUnlock,
      'locale': locale
    };
  }
}
