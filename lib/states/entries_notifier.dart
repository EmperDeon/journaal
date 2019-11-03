import 'dart:collection';
import 'package:flutter/widgets.dart';

class EntriesModel extends ChangeNotifier {
  final List<Entry> _items = [Entry('Заметка 1', ''), Entry('Заметка 2', '')];

  /// An unmodifiable view of the items in the cart.
  UnmodifiableListView<Entry> get items => UnmodifiableListView(_items);

  get length => _items.length;


  int add() {
    Entry item = Entry('', '');
    _items.add(item);
    // This call tells the widgets that are listening to this model to rebuild.
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
  }
}

class Entry {
  String title, body;

  Entry(this.title, this.body);

  Entry copy() {
    return Entry(title, body);
  }
}
