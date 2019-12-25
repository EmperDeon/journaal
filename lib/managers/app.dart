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

class AppManagerImpl extends BaseManager
    implements AppManager {
  Storage storage = sl<Storage>();
  SettingsModel settings = sl<SettingsModel>();
  bool locked = true;

  AppManagerImpl() {
    updateSubjects();

    settings.itemsStream.listen((_) => updateSubjects());

    lockingStream
        .listen((data) => logger.d('Updated lockingStream with $data'));
    uiStream.listen((data) => logger.d('Updated uiStream with $data'));
  }

  @override
  void dispose() {
    _lockingSubject.close();
    super.dispose();
  }

  //
  // Streams
  //

  BehaviorSubject<bool> _lockingSubject = BehaviorSubject();

  void updateSubjects() {
    _lockingSubject.add(locked);
  }

  @override
  Stream<Map<String, dynamic>> get lockingStream => _lockingSubject
      .map(
        (v) => {'locked': v, 'lockingEnabled': settings.lockingEnabled()},
      )
      .distinct();

  @override
  Stream<Map<String, dynamic>> get uiStream => settings.itemsStream
      .map((items) => selectKeys(items, ['locale', 'theme']))
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
