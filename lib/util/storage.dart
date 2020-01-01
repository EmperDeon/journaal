import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:journal/models/base.dart';
import 'package:journal/models/settings.dart';
import 'package:journal/services.dart';
import 'package:journal/util/scoped_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Storage with ScopedLogger {
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

  bool isCorrectPassword(String text) {
    if (!sl<SettingsModel>().lockingEnabled()) {
      return true;
    }

    return text == objects['settings']['password'];
  }
}
