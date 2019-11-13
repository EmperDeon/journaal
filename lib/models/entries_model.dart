import 'package:journal/models/entry.dart';
import 'package:journal/models/base.dart';

/*
 * Entries model, loaded from Storage
 *
 * stored value:
 * [
 *   Entry
 * ]
 */
abstract class EntriesModel {
  // Streams
  Stream<Map<String, Entry>> get itemsStream;

  // CRUD
  void destroy(String id);
  Entry operator [](String id);
  Entry at(String id);
  void setEntryAt(String id, Entry value);
}

class EntriesModelImpl extends BaseModel<Map<String, Entry>>
    implements EntriesModel {
  Map<String, Entry> _items = {
    'key1': Entry('Заметка 1', ''),
    'key2': Entry('Заметка 2', '')
  };

  EntriesModelImpl() : super('entries');

  //
  // CRUD
  //

  @override
  void destroy(String id) {
    _items.remove(id);
    updateSubject();
  }

  @override
  Entry operator [](String id) {
    return _items[id];
  }

  @override
  Entry at(String id) {
    return _items[id];
  }

  @override
  void setEntryAt(String id, Entry value) {
    _items[id] = value;
    updateSubject();
  }

  //
  // Saving/Loading
  //

  @override
  Map<String, Entry> toSubjectData() => _items;

  @override
  void load(dynamic object) {
    if (object is Map<String, dynamic> && object.length > 0) {
      _items = object.map((k, item) => MapEntry(k, Entry.from(item)));
    } else {
      var type = object.runtimeType;
      print('Unsupported type for Entries: $object, $type');
    }

    print("Loaded $_items");
    updateSubject();
  }

  @override
  dynamic save() {
    return _items.map((k, item) => MapEntry(k, item.save()));
  }
}
