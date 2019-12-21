import 'package:journal/models/note.dart';
import 'package:journal/models/base.dart';
import 'package:uuid/uuid.dart';

/// Notes model, loaded from Storage
///
/// stored value:
/// [
///   Note
/// ]
///
abstract class NotesModel {
  // Streams
  Stream<Map<String, Note>> get itemsStream;

  // CRUD
  String create();
  void destroy(String id);
  Note operator [](String id);
  Note at(String id);
  void setNoteAt(String id, Note value);
}

class NotesModelImpl extends BaseModel<Map<String, Note>>
    implements NotesModel {
  Map<String, Note> _items = {
    'key1': Note('Заметка 1', ''),
    'key2': Note('Заметка 2', '')
  };

  NotesModelImpl() : super('notes', skeletonValue: {});

  //
  // CRUD
  //

  @override
  String create() {
    String key = Uuid().v4();
    Note item = Note('Untitled note', '');

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
  Note operator [](String id) {
    return _items[id];
  }

  @override
  Note at(String id) {
    return _items[id];
  }

  @override
  void setNoteAt(String id, Note value) {
    _items[id] = value;
    updateSubject();
  }

  //
  // Saving/Loading
  //

  @override
  Map<String, Note> toSubjectData() => _items;

  @override
  void load(dynamic object) {
    if (object is Map<String, dynamic> && object.length > 0) {
      _items = object.map((k, item) => MapEntry(k, Note.from(item)));
    } else if (object != null) {
      var type = object.runtimeType;
      logger.w('Unsupported type for Notes: $object, $type');
    }

    updateSubject();
  }

  @override
  dynamic save() {
    return _items.map((k, item) => MapEntry(k, item.save()));
  }
}
