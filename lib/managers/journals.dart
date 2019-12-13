import 'package:journal/managers/base.dart';
import 'package:journal/models/journals.dart';
import 'package:journal/models/journal.dart';
import 'package:journal/services/navigation_service.dart';
import 'package:journal/services.dart';
import 'package:uuid/uuid.dart';

abstract class JournalsManager extends BaseManager {
  Stream<List<String>> get itemKeysStream;
  Stream<Journal> itemById(String id);

  // CRUD
  void create();
  Journal operator [](String id);

  void openJournal(String id);
}

class JournalsManagerImpl extends BaseManager implements JournalsManager {
  JournalsModel model = sl<JournalsModel>();
  NavigationService navigator = sl<NavigationService>();

  //
  // Streams
  //

  @override
  Stream<List<String>> get itemKeysStream =>
      model.itemsStream.map((v) => v.keys.toList()).distinct();

  @override
  Stream<Journal> itemById(String id) =>
      model.itemsStream.map((v) => v[id]).distinct();

  //
  // Methods
  //

  @override
  void create() {
    String key = Uuid().v4();
    Journal item = Journal();

    model.setJournalAt(key, item);

    navigator.navigateTo('/journal', arguments: key);
  }

  @override
  Journal operator [](String id) => model[id];

  @override
  void openJournal(String id) =>
      navigator.navigateTo('/journal', arguments: id);
}
