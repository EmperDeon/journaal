import 'package:journal/util/storable.dart';

/*
 * Entry model
 *
 * storad value:
 * {
 *   title: string,
 *   body: string
 * }
 */
class Entry extends Storable {
  String title, body;

  Entry(this.title, this.body);

  Entry.from(dynamic object) {
    load(object);
  }

  Entry copy() {
    return Entry(title, body);
  }

  @override
  void load(object) {
    if (object is Map<String, dynamic>) {
      title = object['title'];
      body = object['body'];

    } else {
      print('Unsupported type for Entry: $object');
    }
  }

  @override
  save() {
    return {
      'title': title,
      'body': body
    };
  }
}
