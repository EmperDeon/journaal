import 'package:journal/models/journal.dart';
import 'package:journal/models/base.dart';
import 'package:journal/util/utils.dart';
import 'package:uuid/uuid.dart';

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
  String create([DateTime date]);
  void destroy(String id);
  Journal operator [](String id);
  Journal at(String id);
  String keyAtDate(DateTime date);
  void setJournalAt(String id, Journal value);

  bool hasDate(DateTime value);
}

class JournalsModelImpl extends BaseModel<Map<String, Journal>>
    implements JournalsModel {
  Map<String, Journal> _items = {};

  JournalsModelImpl() : super('journals', skeletonValue: {});

  //
  // CRUD
  //

  @override
  String create([DateTime date]) {
    String key = Uuid().v4();
    Journal item = Journal(date ?? DateTime.now());

    _items[key] = item;
    updateSubject();

    return key;
  }

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
  String keyAtDate(DateTime date) => findFirstBy(_items, (v) => v.date == date);

  @override
  void setJournalAt(String id, Journal value) {
    _items[id] = value;
    updateSubject();
  }

  @override
  bool hasDate(DateTime value) => !allTrue(_items.values, (Journal val) => value != val.date);

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
      logger.w('Unsupported type for Journals: $object, $type');
    }

    updateSubject();
  }

  @override
  dynamic save() {
    return _items.map((k, item) => MapEntry(k, item.save()));
  }
}
