import 'package:niyojak_prod/utils/stable_geounit_class.dart';

import '../providers/bals.dart';

class GeoUnitMemoryCache {
  GeoUnitMemoryCache._();

  static final GeoUnitMemoryCache instance = GeoUnitMemoryCache._();

  final Map<String, List<GeoUnitMasterBAL>> _cache = {};

  Map<String, List<GeoUnitMasterBAL>> get cache => _cache;

  bool isLoaded(DynamicDropdownFeature namespace) => _cache.containsKey(namespace.name);

  bool isAnyaExist() => _cache.values.any((list) => list.any((item) => item.isanya == 1));

  /// Call once per screen-open. No-op if this namespace is already loaded this app-run.
  Future<void> ensureLoaded({
    required DynamicDropdownFeature namespace,
    required Future<List<GeoUnitMasterBAL>?> Function() fetcher,
  }) async {
    if (_cache.containsKey(namespace.name)) return;
    final result = await fetcher();
    _cache[namespace.name] = result ?? [];
  }

  List<GeoUnitMasterBAL> filterByLevelAndParent({
    required DynamicDropdownFeature namespace,
    required String levelID,
    required String parentID,
    required String parentType,
  }) {
    final data = _cache[namespace.name];
    if (data == null) return [];

    final lvl = int.tryParse(levelID);
    final pid = int.tryParse(parentID.isEmpty ? '0' : parentID) ?? 0;

    return data.where((e) {
      if (e.levelID != lvl) return false;
      if (parentType.isEmpty) return true;

      switch (parentType) {
        case "Praant":
          return e.parentPraantID == pid;
        case "Mahaanagar":
          return e.parentMahaanagarID == pid;
        case "Vibhaag":
          return e.parentVibhaagID == pid;
        case "Bhaag":
          return e.parentBhaagID == pid;
        case "Shahar":
          return e.parentShaharID == pid;
        case "Nagar":
          return e.parentNagarID == pid;
        case "Upnagar":
          return e.parentUpaNagarID == pid;
        case "Mandal":
          return e.parentMandalID == pid;
        case "Graam":
          return e.parentGraamID == pid;
        case "Vasti":
          return e.parentVastiID == pid;
        // case "Shaakhaa":
        //   return e.geoUnitID == pid;
        default:
          return true;
      }
    }).toList();
  }

  /// Optional cleanup for a specific feature's data (e.g. on leaving the screen).
  void clear(DynamicDropdownFeature namespace) => _cache.remove(namespace.name);

  /// Optional full reset (e.g. on logout).
  void clearAll() => _cache.clear();
}
