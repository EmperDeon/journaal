import 'package:journal/managers/base.dart';
import 'package:journal/models/notes.dart';
import 'package:journal/models/note.dart';
import 'package:journal/presenters/snackbar.dart';
import 'package:journal/services.dart';
import 'package:journal/services/navigation_service.dart';
import 'package:journal/managers/fields/rx_field.dart';

abstract class NoteManager extends BaseManager {
  RxTextFieldManager title, body;

  // Methods
  void save();
  void destroy();
}

class NoteManagerImpl extends BaseManager implements NoteManager {
  NavigationService navigator = sl<NavigationService>();
  NotesModel model = sl<NotesModel>();
  Note note;
  String noteId;

  @override
  RxTextFieldManager title, body;

  NoteManagerImpl(this.noteId) {
    note = model.at(noteId);

    title = RxTextFieldManager(initialValue: note.title);
    body = RxTextFieldManager(initialValue: note.body);

    title.nextFocus = body.focus;
  }

  //
  // Methods
  //

  @override
  void save() {
    note.title = title.text;
    note.body = body.text;

    model.setNoteAt(noteId, note);

    navigator.pop();
  }

  @override
  void destroy() {
    presentToScaffold(SnackbarPresenter.removeWarning(() {
      model.destroy(noteId);
      navigator.pop();
    }));
  }
}
