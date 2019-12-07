import 'package:journal/managers/base.dart';
import 'package:journal/models/settings.dart';
import 'package:journal/services.dart';
import 'package:journal/util/storage.dart';
import 'package:journal/util/utils.dart';
import 'package:rxdart/rxdart.dart';

abstract class AppManager extends BaseManager {
  // Streams
  Stream<Map<String, dynamic>> get lockingStream;
  Stream<Map<String, dynamic>> get uiStream;

  // Methods
  bool lockingEnabled();
  void lock();
  bool unlockWith(String pass);
}

class AppManagerImpl extends BaseManager implements AppManager {
  Storage storage = sl<Storage>();
  SettingsModel settings = sl<SettingsModel>();
  bool locked = true;

  AppManagerImpl() {
    updateSubjects();
  }

  //
  // Streams
  //

  BehaviorSubject<bool> _lockingSubject = BehaviorSubject();

  void updateSubjects() {
    _lockingSubject.add(locked);
  }

  @override
  Stream<Map<String, dynamic>> get lockingStream => Observable.combineLatest2(
        settings.itemsStream.map((v) => selectKeys(v, ['lockingEnabled'])),
        _lockingSubject.map(
            (v) => {'locked': v, 'lockingEnabled': settings.lockingEnabled()}),
        (v1, v2) => mergeMaps<String, dynamic>([v1, v2]),
      ).distinct();

  @override
  Stream<Map<String, dynamic>> get uiStream => settings.itemsStream
      .map((items) => selectKeys(items, ['theme']))
      .distinct();

  //
  // Methods
  //

  @override
  bool lockingEnabled() => settings.lockingEnabled();

  @override
  void lock() {
    locked = true;

    updateSubjects();
  }

  @override
  bool unlockWith(String pass) {
    bool result = storage.isCorrectPassword(pass);

    if (result) locked = false;

    updateSubjects();
    return result;
  }
}
