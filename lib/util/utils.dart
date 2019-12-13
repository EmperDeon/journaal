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
