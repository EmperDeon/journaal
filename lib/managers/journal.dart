import 'package:journal/managers/base.dart';
import 'package:journal/models/journals.dart';
import 'package:journal/models/journal.dart';
import 'package:journal/presenters/snackbar.dart';
import 'package:journal/services.dart';
import 'package:journal/services/navigation_service.dart';
import 'package:journal/util/field_managers/rx_field.dart';
import 'package:rxdart/rxdart.dart';

abstract class JournalManager extends BaseManager {
  Stream<List<JournalEntryManager>> get entriesStream;

  // Entries methods
  void appendEntry();
  void moveEntry(int from, int to);
  void destroyEntry(int index);

  // Journal methods
  void save();
  void destroy();
}

class JournalManagerImpl extends BaseManager implements JournalManager {
  NavigationService navigator = sl<NavigationService>();
  JournalsModel model = sl<JournalsModel>();
  Journal journal;
  String journalId;

  JournalManagerImpl(this.journalId) {
    journal = model.at(journalId);

    entries = journal.entries
        .map((item) => JournalEntryManager(item.title, item.body))
        .toList();

    // Should be at least one
    if (entries.length == 0) appendEntry();

    updateSubjects();
  }

  @override
  void dispose() {
    _entriesSubject.close();

    super.dispose();
  }

  //
  // Entries methods
  //

  List<JournalEntryManager> entries;

  BehaviorSubject<List<JournalEntryManager>> _entriesSubject =
      BehaviorSubject();

  Stream<List<JournalEntryManager>> get entriesStream => _entriesSubject.stream;

  void updateSubjects() {
    _entriesSubject.add(entries);
  }

  void appendEntry() {
    entries.add(JournalEntryManager());
    updateSubjects();
  }

  void moveEntry(int from, int to) {
    JournalEntryManager manager = entries.removeAt(from);

    entries.insert(to, manager);
    updateSubjects();
  }

  void destroyEntry(int index) {
    entries.removeAt(index);
    updateSubjects();
  }

  //
  // Journal methods
  //

  @override
  void save() {
    journal.entries =
        entries.map((m) => JournalEntry(m.title.text, m.body.text, 0));
    model.setJournalAt(journalId, journal);

    navigator.pop();
  }

  @override
  void destroy() {
    presentToScaffold(SnackbarPresenter.removeWarning(() {
      model.destroy(journalId);
      navigator.pop();
    }));
  }
}

class JournalEntryManager {
  RxTextFieldManager title, body;

  JournalEntryManager([String initialTitle = '', String initialBody = '']) {
    title = RxTextFieldManager(initialValue: initialTitle);
    body = RxTextFieldManager(initialValue: initialBody);

    title.nextFocus = body.focus;
  }
}
