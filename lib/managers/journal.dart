import 'package:flutter/widgets.dart';
import 'package:journal/managers/base.dart';
import 'package:journal/managers/fields/base.dart';
import 'package:journal/managers/fields/rx_datetime.dart';
import 'package:journal/models/journals.dart';
import 'package:journal/models/journal.dart';
import 'package:journal/presenters/snackbar.dart';
import 'package:journal/screens/journals.dart';
import 'package:journal/services.dart';
import 'package:journal/services/navigation_service.dart';
import 'package:journal/util/emoticons_icons.dart';
import 'package:journal/managers/fields/rx_field.dart';
import 'package:rx_command/rx_command.dart';
import 'package:rxdart/rxdart.dart';

abstract class JournalManager extends BaseManager {
  static const Map<int, IconData> ratingIcons = {
    -2: Emoticons.tired,
    -1: Emoticons.frown,
    0: Emoticons.meh,
    1: Emoticons.smile,
    2: Emoticons.laugh_beam
  };

  Stream<List<JournalEntryManager>> get entriesStream;

  RxTextFieldManager name;
  RxDateTimeFieldManager date;
  RxCommand<DateTime, DateTime> updateDate;

  // Entries methods
  void appendEntry();
  void moveEntry(int from, int to);
  void destroyEntry(int index);

  // Journal methods
  void save();
  void destroy();
  void openList();
}

class JournalManagerImpl extends BaseManager
    implements JournalManager {
  NavigationService navigator = sl<NavigationService>();
  JournalsModel model = sl<JournalsModel>();
  Journal journal;
  String journalId;
  RxTextFieldManager name;
  RxDateTimeFieldManager date;

  JournalManagerImpl(this.journalId) {
    if (this.journalId == null) {
      DateTime now = DateTime.now();
      DateTime today = DateTime(now.year, now.month, now.day);

      if (model.hasDate(today))
        journalId = model.keyAtDate(today);
      else
        journalId = model.create(today);
    }

    journal = model.at(journalId);

    name = RxTextFieldManager(initialValue: journal.name);
    date = RxDateTimeFieldManager(
        mode: RxDateTimeMode.date,
        initialValue: journal.date,
        validateWith: dateValidator);

    entries = journal.entries
        .map((item) => JournalEntryManager(item.title, item.body, item.rating))
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

  RxCommand<DateTime, DateTime> updateDate;

  void updateSubjects() {
    _entriesSubject.add(entries);
  }

  String dateValidator(DateTime value) =>
      model.hasDate(value) ? 'errors.journal.date_taken' : null;

  //
  // Entries methods
  //

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
    presentToScaffold(SnackbarPresenter.removeWarning(() {
      entries.removeAt(index);
      updateSubjects();
    }));
  }

  //
  // Journal methods
  //

  @override
  void openList([replace = false]) => replace
      ? navigator.replaceWith(JournalsScreen.routeName)
      : navigator.navigateTo(JournalsScreen.routeName);

  @override
  void save() {
    journal.name = name.text;
    journal.date = date.value;
    journal.entries = entries
        .map((m) => JournalEntry(m.title.text, m.body.text, m.rating))
        .toList();
    model.setJournalAt(journalId, journal);

    presentToScaffold(SnackbarPresenter.saved());
  }

  @override
  void destroy() {
    presentToScaffold(SnackbarPresenter.removeWarning(() {
      model.destroy(journalId);
      openList(true);
    }));
  }
}

class JournalEntryManager {
  int rating;

  RxTextFieldManager title, body;
  RxCommand<int, int> updateRating;

  JournalEntryManager([
    String initialTitle = '',
    String initialBody = '',
    this.rating = 0,
  ]) {
    title = RxTextFieldManager(initialValue: initialTitle);
    body = RxTextFieldManager(initialValue: initialBody);
    updateRating = RxCommand.createSync(_updateRating);

    title.nextFocus = body.focus;
  }

  int _updateRating(int newValue) => rating = newValue;
}
