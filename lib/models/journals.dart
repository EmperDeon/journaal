import 'package:journal/models/journal.dart';
import 'package:journal/models/base.dart';

/// Journals model, loaded from Storage
///
/// stored value:
/// [
///   Journal
/// ]
///
abstract class JournalsModel {
  // Streams
  Stream<Map<String, Journal>> get itemsStream;

  // CRUD
  void destroy(String id);
  Journal operator [](String id);
  Journal at(String id);
  void setJournalAt(String id, Journal value);
}

class JournalsModelImpl extends BaseModel<Map<String, Journal>>
    implements JournalsModel {
  Map<String, Journal> _items = {};

  JournalsModelImpl() : super('journals', skeletonValue: {});

  //
  // CRUD
  //

  @override
  void destroy(String id) {
    _items.remove(id);
    updateSubject();
  }

  @override
  Journal operator [](String id) {
    return _items[id];
  }

  @override
  Journal at(String id) {
    return _items[id];
  }

  @override
  void setJournalAt(String id, Journal value) {
    _items[id] = value;
    updateSubject();
  }

  //
  // Saving/Loading
  //

  @override
  Map<String, Journal> toSubjectData() => _items;

  @override
  void load(dynamic object) {
    if (object is Map<String, dynamic> && object.length > 0) {
      _items = object.map((k, item) => MapEntry(k, Journal.from(item)));
    } else if (object != null) {
      var type = object.runtimeType;
      print('Unsupported type for Journals: $object, $type');
    }

    print("Loaded $_items");
    updateSubject();
  }

  @override
  dynamic save() {
    return _items.map((k, item) => MapEntry(k, item.save()));
  }
}
