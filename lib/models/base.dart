import 'package:journal/services.dart';
import 'package:journal/util/scoped_logger.dart';
import 'package:journal/util/storable.dart';
import 'package:journal/util/storage.dart';
import 'package:rxdart/rxdart.dart';

abstract class BaseModel<T> with ScopedLogger implements Storable {
  final Storage _storage = sl<Storage>();
  final String _storableKey;

  BaseModel(this._storableKey, {T skeletonValue}) {
    _itemsSubject = new BehaviorSubject();
    _itemsSubject.add(skeletonValue);
    _storage.addReloadTarget(_storableKey, this);
  }

  void reload() {
    dynamic loaded = _storage.get(_storableKey);

    logger.v('Loaded from storage: $loaded');

    load(loaded);
  }

  void saveToStorage() {
    dynamic saved = save();

    logger.v('Saving to storage: $saved');
    _storage.set(_storableKey, saved);
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
