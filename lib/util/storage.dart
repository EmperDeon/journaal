import 'dart:convert';
import 'package:journal/models/base.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Storage {
  Map<String, dynamic> objects = {};
  Map<String, BaseModel> models = {};

  dynamic get(String key) => objects[key];

  void set(String key, dynamic value) => objects[key] = value;

  //
  // Load/Save/Reload
  //

  SharedPreferences preferences;

  void loadFromStorage() async {
    preferences = await SharedPreferences.getInstance();

    objects = jsonDecode(preferences.getString('storage') ?? '{}');
    objects ??= {};

    reload();
  }

  void saveToStorage() async {
    // print('Saving to storage: ${jsonEncode(objects)}');
    await preferences.setString('storage', jsonEncode(objects));
  }

  void reload() {
    for (var key in models.keys) {
      models[key].reload();
    }
  }

  void addReloadTarget(String key, BaseModel model) {
    models[key] = model;
  }

  //
  // Encryption
  //

  bool isPasswordSet() =>
      objects['settings'] != null &&
      objects['settings']['password'] is String &&
      objects['settings']['password'].length > 0;

  bool isCorrectPassword(String text) {
    if (!isPasswordSet()) {
      return true;
    }

    return text == objects['settings']['password'];
  }
}
