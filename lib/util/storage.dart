import 'dart:convert';
import 'package:journal/util/storable_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Storage {
  // Singleton
  static final Storage instance = Storage._privateConstructor();

  Storage._privateConstructor();


  //
  // Object access
  //

  Map<String, dynamic> objects = {};
  Map<String, StorableModel> models = {};

  dynamic get (String key) => objects[key];

  void set(String key, dynamic value) => objects[key] = value;


  //
  // Storage (File, SharedPreferences)
  //

  SharedPreferences preferences;

  void loadFromStorage() async {
    preferences = await SharedPreferences.getInstance();
    print(preferences.getString('storage'));

    objects = jsonDecode(preferences.getString('storage') ?? '{}');
    objects ??= {};

    reload();
  }

  void saveToStorage() async {
    print('Saving to storage:'); print(jsonEncode(objects));
    await preferences.setString('storage', jsonEncode(objects));
  }

  void reload() {
    for (var key in models.keys) {
      models[key].reload();
    }
  }

  void addReloadTarget(String key, StorableModel model) {
    models[key] = model;
  }

  void lock() {
    print('Locked');
  }
}
