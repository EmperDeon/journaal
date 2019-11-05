import 'package:flutter/widgets.dart';
import 'package:journal/util/storage.dart';

abstract class StorableModel extends ChangeNotifier {
  final Storage _storage = Storage.instance;
  final String _storableKey;

  StorableModel(this._storableKey) {
    _storage.addReloadTarget(_storableKey, this);
  }

  void reload() {
    load(_storage.get(_storableKey));
  }

  void saveToStorage() {
    _storage.set(_storableKey, save());
    _storage.saveToStorage();
  }

  @override
  void notifyListeners() {
    super.notifyListeners();

    saveToStorage();
  }

  void load(dynamic object);

  dynamic save();
}
