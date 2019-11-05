abstract class Storable {
  Storable();

  Storable.from(dynamic object) {
    load(object);
  }

  void load(dynamic object);

  dynamic save();
}
