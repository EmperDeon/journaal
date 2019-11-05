import 'package:journal/models/entry.dart';
import 'package:journal/util/storable_model.dart';

/*
 * Entries model, loaded from Storage
 *
 * stored value:
 * [
 *   Entry
 * ]
 */
class EntriesModel extends StorableModel {
  List<Entry> _items = [Entry('Заметка 1', ''), Entry('Заметка 2', '')];

  EntriesModel() : super('entries');

  /// An unmodifiable view of the items in the cart.
  // UnmodifiableListView<Entry> get items => UnmodifiableListView(_items);

  get length => _items.length;


  int add() {
    Entry item = Entry('Untitled note', '');
    _items.add(item);

    notifyListeners();

    return _items.length - 1;
  }

  void destroy(int id) {

  }

  Entry getByIndex(int index) {
    return _items[index];
  }

  void setEntryAt(int index, Entry value) {
    _items[index] = value;

    notifyListeners();
  }

  @override
  void load(dynamic object) {
    if (object is List<dynamic> && object.length > 0) {
      _items = object.map((item) => Entry.from(item)).toList();

    } else {
      var type = object.runtimeType;
      print('Unsupported type for Entries: $object, $type');
    }

    notifyListeners();
  }

  @override
  dynamic save() {
    return _items.map((item) => item.save()).toList();
  }
}
