import 'package:journal/managers/base.dart';
import 'package:journal/models/journals.dart';
import 'package:journal/models/journal.dart';
import 'package:journal/services/navigation_service.dart';
import 'package:journal/services.dart';
import 'package:journal/util/scoped_logger.dart';
import 'package:journal/util/utils.dart';

abstract class JournalsManager extends BaseManager {
  Stream<List<String>> get itemKeysStream;
  Stream<Journal> itemById(String id);

  // CRUD
  void create();
  Journal operator [](String id);

  void openJournal(String id);
}

class JournalsManagerImpl extends BaseManager
    with ScopedLogger
    implements JournalsManager {
  JournalsModel model = sl<JournalsModel>();
  NavigationService navigator = sl<NavigationService>();

  JournalsManagerImpl() {
    itemKeysStream
        .listen((data) => logger.v('Updated itemKeysStream with: $data'));
  }

  //
  // Streams
  //

  @override
  Stream<List<String>> get itemKeysStream => model.itemsStream
      .map((v) => orderedKeys<String, Journal>(v, dateComparator))
      .distinct();

  @override
  Stream<Journal> itemById(String id) =>
      model.itemsStream.map((v) => v[id]).distinct();

  // Compares two journal keys to have reverse order
  int dateComparator(Map<String, Journal> map, Journal val1, Journal val2) =>
      val1.date.compareTo(val2.date);

  //
  // Methods
  //

  @override
  void create() {
    String key = model.create();

    navigator.navigateTo('/journal', arguments: key);
  }

  @override
  Journal operator [](String id) => model[id];

  @override
  void openJournal(String id) =>
      navigator.navigateTo('/journal', arguments: id);
}
