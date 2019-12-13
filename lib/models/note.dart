import 'package:journal/util/storable.dart';

/// Note model
///
/// stored value:
/// {
///   title: string,
///   body: string
/// }
///
class Note implements Storable {
  String title, body;

  Note(this.title, this.body);

  Note.from(dynamic object) {
    load(object);
  }

  Note copy() {
    return Note(title, body);
  }

  @override
  void load(dynamic object) {
    if (object == null) return;

    if (object is Map<String, dynamic>) {
      title = object['title'];
      body = object['body'];
    } else {
      print('Unsupported type for Note: $object');
    }
  }

  @override
  save() {
    return {'title': title, 'body': body};
  }
}
