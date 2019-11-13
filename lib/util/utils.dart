// Returns true, if calling lambda on each item returns true
bool allTrue(list, lambda) {
  for (var item in list) {
    if (!lambda(item)) {
      return false;
    }
  }

  return true;
}

Map<K, V> selectKeys<K, V>(Map<K, V> map, List<K> keys) {
  Map<K, V> copy = {};

  for (K key in keys) {
    copy[key] = map[key];
  }

  return copy;
}
