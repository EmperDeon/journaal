import 'package:journal/managers/base.dart';
import 'package:journal/models/entries_model.dart';
import 'package:journal/models/entry.dart';
import 'package:journal/services/navigation_service.dart';
import 'package:journal/services.dart';
import 'package:uuid/uuid.dart';

abstract class EntriesManager extends BaseManager {
  Stream<List<String>> get itemKeysStream;
  Stream<Entry> itemById(String id);

  // CRUD
  void create();
  Entry operator [](String id);
}

class EntriesManagerImpl implements EntriesManager {
  EntriesModel model = sl<EntriesModel>();

  @override
  void reset(dynamic object) {}

  //
  // Streams
  //

  @override
  Stream<List<String>> get itemKeysStream =>
      model.itemsStream.map((v) => v.keys.toList()).distinct();

  @override
  Stream<Entry> itemById(String id) =>
      model.itemsStream.map((v) => v[id]).distinct();

  //
  // Methods
  //

  @override
  void create() {
    String key = Uuid().v4();
    Entry item = Entry('Untitled note', '');

    model.setEntryAt(key, item);

    sl<NavigationService>().navigateTo('/entry', arguments: key);
  }

  @override
  Entry operator [](String id) => model[id];
}
