import 'package:journal/managers/base.dart';
import 'package:journal/models/entries_model.dart';
import 'package:journal/models/entry.dart';
import 'package:journal/services.dart';
import 'package:journal/services/navigation_service.dart';
import 'package:journal/util/field_managers/rx_field.dart';

abstract class EntryManager extends BaseManager {
  RxTextFieldManager title, body;

  // Methods
  void reset(dynamic id);
  void save();
}

class EntryManagerImpl extends EntryManager {
  EntriesModel model = sl<EntriesModel>();
  Entry entry;
  String entryId;

  @override
  RxTextFieldManager title, body;

  EntryManagerImpl() {
    title = RxTextFieldManager();
    body = RxTextFieldManager();
  }

  //
  // Methods
  //

  @override
  void reset(dynamic id) {
    print('Reset with $id');
    assert(id is String,
        'Reset argument should be a string, but is ${id.runtimeType}');

    entryId = id;
    entry = model.at(entryId);

    title.text = entry.title;
    body.text = entry.body;
  }

  @override
  void save() {
    entry.title = title.text;
    entry.body = body.text;

    model.setEntryAt(entryId, entry);

    sl<NavigationService>().pop();
  }
}
