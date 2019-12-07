import 'package:journal/managers/base.dart';
import 'package:journal/models/notes.dart';
import 'package:journal/models/note.dart';
import 'package:journal/services/navigation_service.dart';
import 'package:journal/services.dart';
import 'package:uuid/uuid.dart';

abstract class NotesManager extends BaseManager {
  Stream<List<String>> get itemKeysStream;
  Stream<Note> itemById(String id);

  // CRUD
  void create();
  Note operator [](String id);

  void openNote(String id);
}

class NotesManagerImpl extends BaseManager implements NotesManager {
  NotesModel model = sl<NotesModel>();
  NavigationService navigator = sl<NavigationService>();

  //
  // Streams
  //

  @override
  Stream<List<String>> get itemKeysStream =>
      model.itemsStream.map((v) => v.keys.toList()).distinct();

  @override
  Stream<Note> itemById(String id) =>
      model.itemsStream.map((v) => v[id]).distinct();

  //
  // Methods
  //

  @override
  void create() {
    String key = Uuid().v4();
    Note item = Note('Untitled note', '');

    model.setNoteAt(key, item);

    navigator.navigateTo('/note', arguments: key);
  }

  @override
  Note operator [](String id) => model[id];

  @override
  void openNote(String id) => navigator.navigateTo('/note', arguments: id);
}
