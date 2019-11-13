import 'package:journal/services.dart';
import 'package:journal/util/storable.dart';
import 'package:journal/util/storage.dart';
import 'package:rxdart/rxdart.dart';

abstract class BaseModel<T> implements Storable {
  final Storage _storage = sl<Storage>();
  final String _storableKey;
  final T skeletonValue;

  BaseModel(this._storableKey, {this.skeletonValue}) {
    _itemsSubject = new BehaviorSubject.seeded(skeletonValue);
    _storage.addReloadTarget(_storableKey, this);
  }

  void reload() {
    load(_storage.get(_storableKey));
  }

  void saveToStorage() {
    _storage.set(_storableKey, save());
    _storage.saveToStorage();
  }

  //
  // Streams
  //

  BehaviorSubject<T> _itemsSubject;

  Stream<T> get itemsStream => _itemsSubject.stream.distinct();

  T toSubjectData();

  void dispose() {
    _itemsSubject.close();
  }

  void updateSubject() {
    _itemsSubject.add(toSubjectData());
    saveToStorage();
  }
}
