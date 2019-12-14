import 'package:journal/util/storable.dart';

/// Journal model
///
/// stored value:
/// {
///   date: string,
///   entries: List<JournalEntry>,
///   tags: List<String>,
/// }
///
class Journal implements Storable {
  DateTime date;
  List<JournalEntry> entries = [];
  List<String> tags = [];

  Journal();

  Journal.from(dynamic object) {
    load(object);
  }

  @override
  void load(dynamic object) {
    if (object == null) return;

    if (object is Map<String, dynamic>) {
      date = DateTime.fromMillisecondsSinceEpoch(object['date'] ?? 0);
      entries = JournalEntry.castFromList(object['entries']) ?? [];
      tags = List.castFrom<dynamic, String>(object['tags'] ?? []);
    } else if (object != null) {
      print('Unsupported type for Journal: $object');
    }
  }

  @override
  save() {
    return {
      'date': date?.millisecondsSinceEpoch,
      'entries': entries.map((entry) => entry.save()).toList(),
      'tags': tags,
    };
  }
}

/// JournalEntry model
///
/// stored value:
/// {
///   title: string,
///   body: string,
///   rating: int
/// }
///
class JournalEntry implements Storable {
  String title = '', body = '';
  int rating = 0;

  JournalEntry(this.title, this.body, this.rating);

  JournalEntry.from(dynamic object) {
    load(object);
  }

  static List<JournalEntry> castFromList(dynamic object) {
    return List.castFrom<dynamic, JournalEntry>(
        object?.map((item) => JournalEntry.from(item))?.toList());
  }

  @override
  void load(dynamic object) {
    if (object == null) return;

    if (object is Map<String, dynamic>) {
      title = object['title'] ?? '';
      body = object['body'] ?? '';
      rating = object['rating'] ?? 0;
    } else if (object != null) {
      print('Unsupported type for JournalEntry: $object');
    }
  }

  @override
  save() {
    return {'title': title, 'body': body, 'rating': rating};
  }
}
