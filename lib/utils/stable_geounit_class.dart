import 'package:flutter/material.dart';

import '../helpers/static_data.dart' as Statics;
import '../models/response_model/dropdown_level_responsemodel.dart';
import '../providers/bals.dart';
import 'globals.dart';

enum GeoLevel {
  Mahaanagar,
  Vibhaag,
  Bhaag,
  // shahar,
  Nagar,
  upnagarUpkhanda,
  Mandal,
  Graam,
  Vasti,
  Shaakhaa,
}

enum GeoHierarchyFetchMode {
  all,
  mandalOnly,
  vastiOnly,
  upnagarOnly,
}

///////////////////////////////////////////////////////////////////////////////////////////////

class GeoHierarchyState {
  /// DROPDOWN ITEMS
  final Map<GeoLevel, List<GeoUnitMasterBAL>> items = {};

  /// SELECTED VALUES
  final Map<GeoLevel, String?> selectedValues = {};

  final Map<GeoLevel, String?> selectedNames = {};
}

class GeoHierarchyTrail {
  final String? mahaanagarId;
  final String? vibhaagId;
  final String? bhaagId;
  final String? nagarId;
  final String? upnagarId;
  final String? mandalId;
  final String? graamId;
  final String? vastiId;
  final String? shakhaaId;

  const GeoHierarchyTrail({
    this.mahaanagarId,
    this.vibhaagId,
    this.bhaagId,
    this.nagarId,
    this.upnagarId,
    this.mandalId,
    this.graamId,
    this.vastiId,
    this.shakhaaId,
  });

  Map<String, dynamic> toJson() {
    return {
      'mahaanagarId': mahaanagarId,
      'vibhaagId': vibhaagId,
      'bhaagId': bhaagId,
      'nagarId': nagarId,
      'upnagarId': upnagarId,
      'mandalId': mandalId,
      'graamId': graamId,
      'vastiId': vastiId,
      'shakhaaId': shakhaaId,
    };
  }
}

class GeoHierarchyNameTrail {
  final String? mahaanagarName;
  final String? vibhaagName;
  final String? bhaagName;
  final String? nagarName;
  final String? upnagarName;
  final String? mandalName;
  final String? graamName;
  final String? vastiName;
  final String? shakhaaName;

  const GeoHierarchyNameTrail({
    this.mahaanagarName,
    this.vibhaagName,
    this.bhaagName,
    this.nagarName,
    this.upnagarName,
    this.mandalName,
    this.graamName,
    this.vastiName,
    this.shakhaaName,
  });

  Map<String, dynamic> toJson() {
    return {
      'mahaanagarName': mahaanagarName,
      'vibhaagName': vibhaagName,
      'bhaagName': bhaagName,
      'nagarName': nagarName,
      'upnagarName': upnagarName,
      'mandalName': mandalName,
      'graamName': graamName,
      'vastiName': vastiName,
      'shakhaaName': shakhaaName,
    };
  }
}

final Map<GeoLevel, int> geoLevelIds = {
  GeoLevel.Mahaanagar: 9,
  GeoLevel.Vibhaag: 8,
  GeoLevel.Bhaag: 7,
  GeoLevel.Nagar: 6,
  GeoLevel.upnagarUpkhanda: 13,
  GeoLevel.Mandal: 4,
  GeoLevel.Graam: 3,
  GeoLevel.Vasti: 2,
  GeoLevel.Shaakhaa: 1,
};

///////////////////////////////////////////////// NODE ////////////////////////////////////////////////

class GeoHierarchyNode {
  final GeoLevel level;
  final String levelName;
  final String levelIdKey;
  final GeoLevel? Function(GeoHierarchyState state)? parentResolver;

  const GeoHierarchyNode({
    required this.level,
    required this.levelName,
    required this.levelIdKey,
    this.parentResolver,
  });
}

final baseHierarchy = [
  GeoHierarchyNode(
    level: GeoLevel.Mahaanagar,
    levelName: 'Mahaanagar',
    levelIdKey: 'MahaanagarLevelID',
  ),

  GeoHierarchyNode(
    level: GeoLevel.Vibhaag,
    levelName: 'Vibhaag',
    levelIdKey: 'VibhaagLevelID',
    parentResolver: (state) {
      final mahaanagar = state.selectedValues[GeoLevel.Mahaanagar];

      /// NO MAHAANAGAR SELECTED
      /// LOAD ROOT VIBHAAG

      if (mahaanagar == null || mahaanagar.isEmpty) {
        return null;
      }

      return GeoLevel.Mahaanagar;
    },
  ),

  GeoHierarchyNode(
    level: GeoLevel.Bhaag,
    levelName: 'Bhaag',
    levelIdKey: 'BhaagLevelID',
    parentResolver: (_) => GeoLevel.Vibhaag,
  ),

  GeoHierarchyNode(
    level: GeoLevel.Nagar,
    levelName: 'Nagar',
    levelIdKey: 'NagarLevelID',
    parentResolver: (_) => GeoLevel.Bhaag,
  ),

  GeoHierarchyNode(
    level: GeoLevel.upnagarUpkhanda,
    levelName: 'Upnagar',
    levelIdKey: 'UpaNagarLevelID',
    parentResolver: (_) => GeoLevel.Nagar,
  ),

  /// DYNAMIC PARENT
  GeoHierarchyNode(
    level: GeoLevel.Mandal,
    levelName: 'Mandal',
    levelIdKey: 'MandalLevelID',
    parentResolver: (state) {
      final upnagar = state.selectedValues[GeoLevel.upnagarUpkhanda];

      if (upnagar != null && upnagar.isNotEmpty) {
        return GeoLevel.upnagarUpkhanda;
      }

      return GeoLevel.Nagar;
    },
  ),

  /// DYNAMIC PARENT
  GeoHierarchyNode(
    level: GeoLevel.Vasti,
    levelName: 'Vasti',
    levelIdKey: 'VastiLevelID',
    parentResolver: (state) {
      final upnagar = state.selectedValues[GeoLevel.upnagarUpkhanda];

      if (upnagar != null && upnagar.isNotEmpty) {
        return GeoLevel.upnagarUpkhanda;
      }

      return GeoLevel.Nagar;
    },
  ),

  GeoHierarchyNode(
    level: GeoLevel.Graam,
    levelName: 'Graam',
    levelIdKey: 'GraamLevelID',
    parentResolver: (_) => GeoLevel.Mandal,
  ),
];

final shakhaaNode = GeoHierarchyNode(
  level: GeoLevel.Shaakhaa,
  levelName: 'Shaakhaa',
  levelIdKey: 'ShaakhaaLevelID',
  parentResolver: (state) {
    /// PRIORITY TO VASTI

    if (state.selectedValues[GeoLevel.Vasti] != null) {
      return GeoLevel.Vasti;
    }

    /// OTHERWISE GRAAM

    if (state.selectedValues[GeoLevel.Graam] != null) {
      return GeoLevel.Graam;
    }

    return null;
  },
);

GeoHierarchyController createGeoController() {
  return GeoHierarchyController(
    hierarchy: [
      ...baseHierarchy,
      shakhaaNode,
    ],
  );
}

////////////////////////////////////////////// CONTROLLER /////////////////////////////////////////////

class GeoHierarchyController extends ChangeNotifier {
  final List<GeoHierarchyNode> hierarchy;

  GeoHierarchyController({required this.hierarchy});

  final GeoHierarchyState state = GeoHierarchyState();

  DropDownModel? ctrlUserData;

  int? ctrlUserLevelId;

  String? userGeoUnitId;

  ////////////////////////////////////////////

  Future<void> initialize(DropDownModel dm, {GeoHierarchyFetchMode fetchMode = GeoHierarchyFetchMode.all}) async {
    ctrlUserData = dm;

    ctrlUserLevelId = dm.levelID;

    userGeoUnitId = (dm.geoUnitID ?? 0).toString();

    await loadHierarchyForUser(fetchMode: fetchMode);
  }

  ////////////////////////////////////////////

  void setSelectedValue({
    required GeoLevel level,
    required String? id,
    String? name,
  }) {
    state.selectedValues[level] = id;

    state.selectedNames[level] = name;
  }

  GeoLevel? _mapLevelIdToGeoLevel(int? levelId) {
    switch (levelId) {
      case 9:
        return GeoLevel.Mahaanagar;

      case 8:
        return GeoLevel.Vibhaag;

      case 7:
        return GeoLevel.Bhaag;

      case 6:
        return GeoLevel.Nagar;

      case 13:
        return GeoLevel.upnagarUpkhanda;

      case 4:
        return GeoLevel.Mandal;

      case 3:
        return GeoLevel.Graam;

      case 2:
        return GeoLevel.Vasti;

      case 1:
        return GeoLevel.Shaakhaa;

      default:
        return null;
    }
  }

  bool isLevelLocked(GeoLevel level) {
    final restrictedLevel = _mapLevelIdToGeoLevel(ctrlUserLevelId);

    if (restrictedLevel == null) {
      return false;
    }

    final lockedLevels = {
      GeoLevel.Mahaanagar: [
        GeoLevel.Mahaanagar,
      ],
      GeoLevel.Vibhaag: [
        GeoLevel.Mahaanagar,
        GeoLevel.Vibhaag,
      ],
      GeoLevel.Bhaag: [
        GeoLevel.Mahaanagar,
        GeoLevel.Vibhaag,
        GeoLevel.Bhaag,
      ],
      GeoLevel.Nagar: [
        GeoLevel.Mahaanagar,
        GeoLevel.Vibhaag,
        GeoLevel.Bhaag,
        GeoLevel.Nagar,
      ],
      GeoLevel.upnagarUpkhanda: [
        GeoLevel.Mahaanagar,
        GeoLevel.Vibhaag,
        GeoLevel.Bhaag,
        GeoLevel.Nagar,
        GeoLevel.upnagarUpkhanda,
      ],
      GeoLevel.Mandal: [
        GeoLevel.Mahaanagar,
        GeoLevel.Vibhaag,
        GeoLevel.Bhaag,
        GeoLevel.Nagar,
        GeoLevel.upnagarUpkhanda,
        GeoLevel.Mandal,
      ],
      GeoLevel.Graam: [
        GeoLevel.Mahaanagar,
        GeoLevel.Vibhaag,
        GeoLevel.Bhaag,
        GeoLevel.Nagar,
        GeoLevel.upnagarUpkhanda,
        GeoLevel.Mandal,
        GeoLevel.Graam,
      ],
      GeoLevel.Vasti: [
        GeoLevel.Mahaanagar,
        GeoLevel.Vibhaag,
        GeoLevel.Bhaag,
        GeoLevel.Nagar,
        GeoLevel.upnagarUpkhanda,
        GeoLevel.Vasti,
      ],
      GeoLevel.Shaakhaa: [
        GeoLevel.Mahaanagar,
        GeoLevel.Vibhaag,
        GeoLevel.Bhaag,
        GeoLevel.Nagar,
        GeoLevel.upnagarUpkhanda,
        GeoLevel.Mandal,
        GeoLevel.Graam,
        GeoLevel.Vasti,
        GeoLevel.Shaakhaa,
      ],
    };

    return lockedLevels[restrictedLevel]?.contains(level) ?? false;
  }

  String? _resolveSelectedName({required GeoLevel level, required List<GeoUnitMasterBAL> items, required String? selectedId}) {
    if (selectedId == null) {
      return null;
    }

    try {
      return items.firstWhere((e) => e.geoUnitID.toString() == selectedId).geoUnitName;
    } catch (_) {
      return null;
    }
  }

  String? _resolveSelectedValue({required GeoLevel level, required String? trailValue}) {
    final currentLevel = _mapLevelIdToGeoLevel(ctrlUserLevelId);

    /// CURRENT USER LEVEL
    if (currentLevel == level) {
      return userGeoUnitId;
    }

    /// PARENT LEVELS
    return (trailValue?.isNotEmpty ?? false) ? trailValue : null;
  }

  Future<void> _loadAndSetLevel({
    required GeoLevel level,
    required String? trailValue,
    GeoHierarchyFetchMode fetchMode = GeoHierarchyFetchMode.all,
  }) async {
    /// LOAD ITEMS
    await loadLevel(level, fetchMode: fetchMode);

    /// RESOLVE ID
    final resolvedId = _resolveSelectedValue(level: level, trailValue: trailValue);

    /// RESOLVE NAME
    final resolvedName = _resolveSelectedName(level: level, items: state.items[level] ?? [], selectedId: resolvedId);

    /// SET BOTH
    setSelectedValue(level: level, id: resolvedId, name: resolvedName);
  }

  Future<void> loadHierarchyForUser({int? loadFromLevel, GeoHierarchyFetchMode fetchMode = GeoHierarchyFetchMode.all}) async {
    try {
      print("Loading hierarchy for user with level ID: $ctrlUserLevelId and geo unit ID: $userGeoUnitId and fetchMode: $fetchMode");

      clearBelow(GeoLevel.Mahaanagar);

      final selection = prepareSelection(ctrlUserData!);

      await _loadAndSetLevel(
        level: GeoLevel.Mahaanagar,
        trailValue: selection.mahaanagar,
        fetchMode: fetchMode,
      );
      // if (_isRestrictedAt(9)) return;

      await _loadAndSetLevel(
        level: GeoLevel.Vibhaag,
        trailValue: selection.vibhaag,
        fetchMode: fetchMode,
      );
      // if (_isRestrictedAt(9)) return;

      await _loadAndSetLevel(
        level: GeoLevel.Bhaag,
        trailValue: selection.bhaag,
        fetchMode: fetchMode,
      );
      // if (_isRestrictedAt(8)) return;

      // if (shouldLoadLevel(GeoLevel.Nagar)) {
      await _loadAndSetLevel(
        level: GeoLevel.Nagar,
        trailValue: selection.nagar,
        fetchMode: fetchMode,
      );
      // }
      // if (_isRestrictedAt(7)) return;

      /// UPNAGAR

      await loadLevel(GeoLevel.upnagarUpkhanda);

      final hasUpnagar = state.items[GeoLevel.upnagarUpkhanda]?.isNotEmpty ?? false;

      if (hasUpnagar) {
        final resolvedId = _resolveSelectedValue(
          level: GeoLevel.upnagarUpkhanda,
          trailValue: selection.upnagar,
        );

        final resolvedName = _resolveSelectedName(
          level: GeoLevel.upnagarUpkhanda,
          items: state.items[GeoLevel.upnagarUpkhanda] ?? [],
          selectedId: resolvedId,
        );
        // if (shouldLoadLevel(GeoLevel.upnagarUpkhanda)) {
        setSelectedValue(
          level: GeoLevel.upnagarUpkhanda,
          id: resolvedId,
          name: resolvedName,
        );
        // if (_isRestrictedAt(6)) return;
        // }
      }

      /// MANDAL

      // if (shouldLoadLevel(GeoLevel.Mandal)) {
      await _loadAndSetLevel(
        level: GeoLevel.Mandal,
        trailValue: selection.mandal,
      );
      // }
      // if (_isRestrictedAt(6) || _isRestrictedAt(13)) return;

      /// GRAAM

      // if (shouldLoadLevel(GeoLevel.Graam)) {
      await _loadAndSetLevel(
        level: GeoLevel.Graam,
        trailValue: selection.graam,
      );
      // }
      // if (_isRestrictedAt(4)) return;

      /// VASTI

      // if (shouldLoadLevel(GeoLevel.Vasti)) {
      await _loadAndSetLevel(
        level: GeoLevel.Vasti,
        trailValue: selection.vasti,
      );
      // }
      // if (_isRestrictedAt(2)) return;

      /// SHAKHAA

      if (shouldLoadLevel(GeoLevel.Shaakhaa)) {
        await _loadAndSetLevel(
          level: GeoLevel.Shaakhaa,
          trailValue: selection.shakhaa,
        );
      }
      // if (_isRestrictedAt(2)) return;

      notifyListeners();
    } finally {
      notifyListeners();
    }
  }

  ////////////////////////////////////////////

  bool _isRestrictedAt(int level) {
    return ctrlUserLevelId == level;
  }

  ////////////////////////////////////////////

  Future<void> loadLevel(GeoLevel level, {GeoHierarchyFetchMode fetchMode = GeoHierarchyFetchMode.all}) async {
    /// DO NOT LOAD SHAAKHAA
    /// UNTIL GRAAM OR VASTI IS SELECTED

    if (level == GeoLevel.Shaakhaa) {
      final hasGraam = (state.selectedValues[GeoLevel.Graam]?.isNotEmpty ?? false);
      final hasVasti = (state.selectedValues[GeoLevel.Vasti]?.isNotEmpty ?? false);

      if (!hasGraam && !hasVasti) {
        state.items.remove(GeoLevel.Shaakhaa);
        state.selectedValues.remove(GeoLevel.Shaakhaa);
        state.selectedNames.remove(GeoLevel.Shaakhaa);

        notifyListeners();
        return;
      }
    }

    final node = hierarchy.firstWhere((e) => e.level == level);

    String parentId = '';

    String parentType = '';

    GeoLevel? parentLevel = node.parentResolver?.call(state);

    if (parentLevel != null) {
      parentId = state.selectedValues[parentLevel] ?? '';

      parentType = hierarchy.firstWhere((e) => e.level == parentLevel).levelName;
    }

    final data = await _fetchData(
      node,
      parentId,
      parentType,
      fetchMode,
    );

    state.items[level] = data;

    notifyListeners();
  }

  ////////////////////////////////////////////

  Future<List<GeoUnitMasterBAL>> _fetchData(GeoHierarchyNode node, String parentId, String parentType, GeoHierarchyFetchMode fetchMode) async {
    final levelId = Statics.levels[node.levelIdKey].toString();

    switch (fetchMode) {
      //////////////////////////////////////////
      /// ALL NORMAL DATA
      //////////////////////////////////////////

      case GeoHierarchyFetchMode.all:
        return await Statics.getGeoUnitsByLevelAndParent(
          levelId,
          parentId,
          parentType,
          '',
          isAbhiyaan: false,
        );

      //////////////////////////////////////////
      /// MANDAL ONLY TRAIL
      //////////////////////////////////////////

      case GeoHierarchyFetchMode.mandalOnly:
        return await Statics.getGeoUnitsByLevelAndParentForMandal(
          levelId,
          parentId,
          parentType,
          '',
        );

      //////////////////////////////////////////
      /// VASTI ONLY TRAIL
      //////////////////////////////////////////

      case GeoHierarchyFetchMode.vastiOnly:
        return await Statics.getGeoUnitsByLevelAndParentForVasti(
          levelId,
          parentId,
          parentType,
          '',
        );

      //////////////////////////////////////////
      /// UPNAGAR ONLY TRAIL
      //////////////////////////////////////////

      case GeoHierarchyFetchMode.upnagarOnly:
        return await Statics.getGeoUnitsByLevelAndParentForUpnagar(
          levelId,
          parentId,
          parentType,
          '',
        );
    }
  }

  ////////////////////////////////////////////

  Future<void> onDropdownChanged({required GeoLevel level, required String? value, GeoHierarchyFetchMode fetchMode = GeoHierarchyFetchMode.all}) async {
    /// SAVE SELECTION
    final selectedItem = state.items[level]?.firstWhere((e) => e.geoUnitID.toString() == value);

    setSelectedValue(level: level, id: value, name: selectedItem?.geoUnitName);

    /// CLEAR BELOW LEVEL
    clearBelow(level);

    /// SPECIAL CASE

    if (level == GeoLevel.Nagar) {
      /// LOAD UPNAGAR
      await loadLevel(GeoLevel.upnagarUpkhanda, fetchMode: fetchMode);

      // final hasUpnagar = state.items[GeoLevel.upnagar]?.isNotEmpty ?? false;

      // if (!hasUpnagar) {
      await loadLevel(GeoLevel.Mandal);

      await loadLevel(GeoLevel.Vasti);
      // }
    }

    ////////////////////////////////////////

    else if (level == GeoLevel.upnagarUpkhanda) {
      await loadLevel(GeoLevel.Mandal);

      await loadLevel(GeoLevel.Vasti);
    }

    ////////////////////////////////////////

    else if (level == GeoLevel.Mandal) {
      await loadLevel(GeoLevel.Graam);
    }

    ////////////////////////////////////////

    else if (level == GeoLevel.Graam || level == GeoLevel.Vasti) {
      if (_hasLevel(GeoLevel.Shaakhaa)) {
        await loadLevel(GeoLevel.Shaakhaa);
      }
    }
    ////////////////////////////////////////

    else {
      final currentIndex = GeoLevel.values.indexOf(level);

      if (currentIndex + 1 < GeoLevel.values.length) {
        final nextLevel = GeoLevel.values[currentIndex + 1];

        await loadLevel(nextLevel, fetchMode: fetchMode);
      }
    }

    notifyListeners();
  }

  bool _hasLevel(GeoLevel level) {
    return hierarchy.any(
      (e) => e.level == level,
    );
  }

  ////////////////////////////////////////////

  void clearBelow(GeoLevel level) {
    final currentIndex = hierarchy.indexWhere(
      (e) => e.level == level,
    );

    if (currentIndex == -1) {
      return;
    }

    /// CLEAR ALL LOWER LEVELS

    for (int i = currentIndex + 1; i < hierarchy.length; i++) {
      final lvl = hierarchy[i].level;

      state.items.remove(lvl);

      state.selectedValues.remove(lvl);

      state.selectedNames.remove(lvl);
    }

    notifyListeners();
  }

  ////////////////////////////////////////////

  bool hasItems(GeoLevel level) => state.items[level]?.isNotEmpty ?? false;

  bool shouldLoadLevel(GeoLevel level) {
    final currentLevel = _mapLevelIdToGeoLevel(ctrlUserLevelId);

    /// NO RESTRICTION

    if (currentLevel == null) {
      return true;
    }

    /// ALWAYS LOAD ROOTS

    if (13 > (ctrlUserLevelId ?? 0) && (ctrlUserLevelId ?? 0) > 7) {
      return true;
    }

    /// LEVEL 6 (NAGAR)

    if (currentLevel == GeoLevel.Nagar) {
      return [
        GeoLevel.Nagar,
        GeoLevel.upnagarUpkhanda,
        GeoLevel.Mandal,
        GeoLevel.Graam,
        GeoLevel.Vasti,
        GeoLevel.Shaakhaa,
      ].contains(level);
    }

    /// LEVEL 4 (MANDAL)

    if (currentLevel == GeoLevel.Mandal) {
      return [
        GeoLevel.Mandal,
        GeoLevel.Graam,
        GeoLevel.Shaakhaa,
      ].contains(level);
    }

    /// LEVEL 2 (VASTI)

    if (currentLevel == GeoLevel.Vasti) {
      return [
        GeoLevel.Vasti,
        GeoLevel.Shaakhaa,
      ].contains(level);
    }

    /// DEFAULT

    return true;
  }

  GeoLevel? get deepestSelectedLevel {
    GeoLevel? deepest;

    for (final level in GeoLevel.values) {
      final value = state.selectedValues[level];

      if (value != null && value.isNotEmpty) {
        deepest = level;
      }
    }

    return deepest;
  }

  int? get deepestSelectedLevelId {
    final deepest = deepestSelectedLevel;

    if (deepest == null) {
      return null;
    }

    return geoLevelIds[deepest];
  }

  String? get deepestSelectedGeoUnitId {
    final level = deepestSelectedLevel;

    if (level == null) {
      return null;
    }

    return state.selectedValues[level];
  }

  GeoUnitMasterBAL? get deepestSelectedGeoUnitBAL {
    final level = deepestSelectedLevel;

    if (level == null) {
      return null;
    }

    final selectedId = state.selectedValues[level];

    final item = state.items[level]?.firstWhere(
      (e) => e.geoUnitID.toString() == selectedId,
      // orElse: () => GeoUnitMasterBAL(),
    );

    return item;
  }

  String? get deepestSelectedGeoUnitName {
    final level = deepestSelectedLevel;

    if (level == null) {
      return null;
    }

    final selectedId = state.selectedValues[level];

    final item = state.items[level]?.firstWhere(
      (e) => e.geoUnitID.toString() == selectedId,
      // orElse: () => GeoUnitMasterBAL(),
    );

    return item?.geoUnitName ?? "--";
  }

  String? get deepestSelectedLevelName => deepestSelectedLevel?.name;

  GeoHierarchyTrail get hierarchyTrail {
    return GeoHierarchyTrail(
      mahaanagarId: state.selectedValues[GeoLevel.Mahaanagar],
      vibhaagId: state.selectedValues[GeoLevel.Vibhaag],
      bhaagId: state.selectedValues[GeoLevel.Bhaag],
      nagarId: state.selectedValues[GeoLevel.Nagar],
      upnagarId: state.selectedValues[GeoLevel.upnagarUpkhanda],
      mandalId: state.selectedValues[GeoLevel.Mandal],
      graamId: state.selectedValues[GeoLevel.Graam],
      vastiId: state.selectedValues[GeoLevel.Vasti],
      shakhaaId: state.selectedValues[GeoLevel.Shaakhaa],
    );
  }

  GeoHierarchyNameTrail get hierarchyNameTrail {
    return GeoHierarchyNameTrail(
      mahaanagarName: state.selectedNames[GeoLevel.Mahaanagar],
      vibhaagName: state.selectedNames[GeoLevel.Vibhaag],
      bhaagName: state.selectedNames[GeoLevel.Bhaag],
      nagarName: state.selectedNames[GeoLevel.Nagar],
      upnagarName: state.selectedNames[GeoLevel.upnagarUpkhanda],
      mandalName: state.selectedNames[GeoLevel.Mandal],
      graamName: state.selectedNames[GeoLevel.Graam],
      vastiName: state.selectedNames[GeoLevel.Vasti],
      shakhaaName: state.selectedNames[GeoLevel.Shaakhaa],
    );
  }

  ////////////////////////////////////////////

  Future<GeoHierarchyTrail?> getTrailFromGeoUnitId(String geoUnitId) async {
    final data = await Statics.getGeoUnitsByID(geoUnitId);

    if (data == null) {
      return null;
    }

    return GeoHierarchyTrail(
      mahaanagarId: data.levelID == 9 ? data.geoUnitID.toString() : data.parentMahaanagarID?.toString(),
      vibhaagId: data.levelID == 8 ? data.geoUnitID.toString() : data.parentVibhaagID?.toString(),
      bhaagId: data.levelID == 7 ? data.geoUnitID.toString() : data.parentBhaagID?.toString(),
      nagarId: data.levelID == 6 ? data.geoUnitID.toString() : data.parentNagarID?.toString(),
      upnagarId: data.levelID == 13 ? data.geoUnitID.toString() : data.parentUpaNagarID?.toString(),
      mandalId: data.levelID == 4 ? data.geoUnitID.toString() : data.parentMandalID?.toString(),
      graamId: data.levelID == 3 ? data.geoUnitID.toString() : data.parentGraamID?.toString(),
      vastiId: data.levelID == 2 ? data.geoUnitID.toString() : data.parentVastiID?.toString(),
      shakhaaId: data.levelID == 1 ? data.geoUnitID.toString() : null,
    );
  }

  Future<void> setHierarchyFromTrail({required GeoHierarchyTrail trail, GeoHierarchyFetchMode fetchMode = GeoHierarchyFetchMode.all}) async {
    /// CLEAR OLD STATE

    state.items.clear();

    state.selectedValues.clear();

    state.selectedNames.clear();

    notifyListeners();

    /// MAHAANAGAR
    if (trail.mahaanagarId != null && trail.mahaanagarId!.isNotEmpty) {
      await loadLevel(
        GeoLevel.Mahaanagar,
        fetchMode: fetchMode,
      );

      final selectedItem = state.items[GeoLevel.Mahaanagar]?.firstWhere(
        (e) => e.geoUnitID.toString() == trail.mahaanagarId,
      );

      setSelectedValue(
        level: GeoLevel.Mahaanagar,
        id: trail.mahaanagarId,
        name: selectedItem?.geoUnitName,
      );
    }

    /// VIBHAAG
    if (trail.vibhaagId != null && trail.vibhaagId!.isNotEmpty) {
      await loadLevel(
        GeoLevel.Vibhaag,
        fetchMode: fetchMode,
      );

      final selectedItem = state.items[GeoLevel.Vibhaag]?.firstWhere(
        (e) => e.geoUnitID.toString() == trail.vibhaagId,
      );

      setSelectedValue(
        level: GeoLevel.Vibhaag,
        id: trail.vibhaagId,
        name: selectedItem?.geoUnitName,
      );

      ///LOADING NEXT DROPDOWN
      await loadLevel(
        GeoLevel.Bhaag,
        fetchMode: fetchMode,
      );
    }

    /// BHAAG
    if (trail.bhaagId != null && trail.bhaagId!.isNotEmpty) {
      final selectedItem = state.items[GeoLevel.Bhaag]?.firstWhere(
        (e) => e.geoUnitID.toString() == trail.bhaagId,
      );

      setSelectedValue(
        level: GeoLevel.Bhaag,
        id: trail.bhaagId,
        name: selectedItem?.geoUnitName,
      );

      ///LOADING NEXT DROPDOWN
      await loadLevel(
        GeoLevel.Nagar,
        fetchMode: fetchMode,
      );
    }

    /// NAGAR
    if (trail.nagarId != null && trail.nagarId!.isNotEmpty) {
      final selectedItem = state.items[GeoLevel.Nagar]?.firstWhere(
        (e) => e.geoUnitID.toString() == trail.nagarId,
      );

      setSelectedValue(
        level: GeoLevel.Nagar,
        id: trail.nagarId,
        name: selectedItem?.geoUnitName,
      );

      ///LOADING NEXT DROPDOWN
      await loadLevel(
        GeoLevel.upnagarUpkhanda,
        fetchMode: fetchMode,
      );
      await loadLevel(
        GeoLevel.Mandal,
        fetchMode: fetchMode,
      );
      await loadLevel(
        GeoLevel.Vasti,
        fetchMode: fetchMode,
      );
    }

    /// UPNAGAR
    if (trail.upnagarId != null && trail.upnagarId!.isNotEmpty) {
      final selectedItem = state.items[GeoLevel.upnagarUpkhanda]?.firstWhere(
        (e) => e.geoUnitID.toString() == trail.upnagarId,
      );

      setSelectedValue(
        level: GeoLevel.upnagarUpkhanda,
        id: trail.upnagarId,
        name: selectedItem?.geoUnitName,
      );

      ///LOADING NEXT DROPDOWN
      await loadLevel(
        GeoLevel.Mandal,
        fetchMode: fetchMode,
      );
      await loadLevel(
        GeoLevel.Vasti,
        fetchMode: fetchMode,
      );
    }

    /// MANDAL
    if (trail.mandalId != null && trail.mandalId!.isNotEmpty) {
      final selectedItem = state.items[GeoLevel.Mandal]?.firstWhere(
        (e) => e.geoUnitID.toString() == trail.mandalId,
      );

      setSelectedValue(
        level: GeoLevel.Mandal,
        id: trail.mandalId,
        name: selectedItem?.geoUnitName,
      );

      ///LOADING NEXT DROPDOWN
      await loadLevel(
        GeoLevel.Graam,
        fetchMode: fetchMode,
      );
    }

    /// GRAAM
    if (trail.graamId != null && trail.graamId!.isNotEmpty) {
      final selectedItem = state.items[GeoLevel.Graam]?.firstWhere(
        (e) => e.geoUnitID.toString() == trail.graamId,
      );

      setSelectedValue(
        level: GeoLevel.Graam,
        id: trail.graamId,
        name: selectedItem?.geoUnitName,
      );

      ///LOADING NEXT DROPDOWN
      await loadLevel(
        GeoLevel.Shaakhaa,
        fetchMode: fetchMode,
      );
    }

    /// VASTI
    if (trail.vastiId != null && trail.vastiId!.isNotEmpty) {
      final selectedItem = state.items[GeoLevel.Vasti]?.firstWhere(
        (e) => e.geoUnitID.toString() == trail.vastiId,
      );

      setSelectedValue(
        level: GeoLevel.Vasti,
        id: trail.vastiId,
        name: selectedItem?.geoUnitName,
      );

      ///LOADING NEXT DROPDOWN
      await loadLevel(
        GeoLevel.Shaakhaa,
        fetchMode: fetchMode,
      );
    }

    /// SHAAKHAA
    if (trail.shakhaaId != null && trail.shakhaaId!.isNotEmpty) {
      final selectedItem = state.items[GeoLevel.Shaakhaa]?.firstWhere(
        (e) => e.geoUnitID.toString() == trail.shakhaaId,
      );

      setSelectedValue(
        level: GeoLevel.Shaakhaa,
        id: trail.shakhaaId,
        name: selectedItem?.geoUnitName,
      );
    }

    notifyListeners();
  }

  ////////////////////////////////////////////

  List<GeoUnitMasterBAL> getItems(
    GeoLevel level,
  ) {
    return state.items[level] ?? [];
  }

  ////////////////////////////////////////////

  String? getSelectedValue(
    GeoLevel level,
  ) {
    return state.selectedValues[level];
  }
}

//////////////////////////////////////////////// WIDGET ///////////////////////////////////////////////

class GeoDropdownWidget extends StatelessWidget {
  final GeoLevel level;
  final String title;
  final GeoHierarchyController controller;
  final String? Function(dynamic)? validator;
  final void Function(dynamic)? onChanged;
  final void Function(dynamic)? onSaved;
  final GeoHierarchyFetchMode fetchMode;
  final InputDecoration? decoration;
  final bool? isDisabled;

  const GeoDropdownWidget({
    super.key,
    required this.level,
    required this.title,
    required this.controller,
    this.validator,
    this.onSaved,
    this.onChanged,
    this.isDisabled,
    this.decoration,
    this.fetchMode = GeoHierarchyFetchMode.all,
  });

  @override
  Widget build(BuildContext context) {
    final items = controller.getItems(level);

    return buildDropdownField(
      isDisabled: isDisabled ?? controller.isLevelLocked(level),
      value: controller.getSelectedValue(level),
      label: Statics.getLabel(title, returnKey: true),
      decoration: decoration,
      items: items.map((e) {
        return DropdownMenuItem(
          value: e.geoUnitID.toString(),
          child: Text(e.geoUnitName ?? ''),
        );
      }).toList(),
      onChanged: (value) async {
        await controller.onDropdownChanged(
          level: level,
          value: value,
          fetchMode: fetchMode,
        );
        if (onChanged != null) onChanged!.call(value);
      },
      validator: validator,
      onSaved: onSaved,
    );
  }
}
