import 'package:journal/util/scoped_logger.dart';
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
class Journal with ScopedLogger implements Storable {
  String name = '';
  DateTime date;
  List<JournalEntry> entries = [];
  List<String> tags = [];

  Journal(this.date);

  Journal.from(dynamic object) {
    load(object);
  }

  @override
  void load(dynamic object) {
    if (object == null) return;

    if (object is Map<String, dynamic>) {
      name = object['name'] ?? '';
      date = DateTime.fromMillisecondsSinceEpoch(object['date'] ?? 0);
      entries = JournalEntry.castFromList(object['entries']) ?? [];
      tags = List.castFrom<dynamic, String>(object['tags'] ?? []);
    } else if (object != null) {
      logger.w('Unsupported type for Journal: $object');
    }
  }

  @override
  save() {
    return {
      'name': name,
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
class JournalEntry with ScopedLogger implements Storable {
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
      logger.w('Unsupported type for JournalEntry: $object');
    }
  }

  @override
  save() {
    return {'title': title, 'body': body, 'rating': rating};
  }
}
