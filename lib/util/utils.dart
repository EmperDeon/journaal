// Returns true, if calling lambda on each item returns true
bool allTrue(list, lambda) {
  for (var item in list) {
    if (!lambda(item)) {
      return false;
    }
  }

  return true;
}

// Returns map with only keys from keys argument
Map<K, V> selectKeys<K, V>(Map<K, V> map, List<K> keys) {
  if (map == null || keys == null) return {};

  Map<K, V> copy = {};

  for (K key in keys) {
    copy[key] = map[key];
  }

  return copy;
}

// Return first key with that value
K findKey<K, V>(Map<K, V> map, V value) {
  for (K key in map.keys) {
    if (map[key] == value) return key;
  }

  return null;
}

// Merge keys of multiple maps
Map<K, V> mergeMaps<K, V>(List<Map<K, V>> maps) {
  Map<K, V> merged = {};

  for (var map in maps) {
    for (K key in map.keys) {
      merged[key] = map[key];
    }
  }

  return merged;
}

List flattenL(List list) {
  List ret = [];

  list.forEach((item) {
    if (item is List) {
      ret.addAll(item);
    } else {
      ret.add(item);
    }
  });

  return ret;
}

typedef MapComparator<K, V> = int Function(Map<K, V>, V, V);

List<K> orderedKeys<K, V>(Map<K, V> map, MapComparator<K, V> comp) {
  List<K> keys = map.keys.toList();
  keys.sort((k1, k2) => comp(map, map[k1], map[k2]));

  return keys;
}

typedef MapFinder<V> = bool Function(V);

K findFirstBy<K, V>(Map<K, V> map, MapFinder<V> finder) {
  for (K key in map.keys) {
    if (finder(map[key])) return key;
  }

  return null;
}

extension ListCompaction<T> on List<T> {
  List<T> compact() {
    List<T> ret = [];

    for (var val in this) if (val != null) ret.add(val);

    return ret;
  }
}
