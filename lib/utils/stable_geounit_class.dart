import 'package:flutter/material.dart';

import '../helpers/static_data.dart' as Statics;
import '../models/response_model/dropdown_level_responsemodel.dart';
import '../providers/bals.dart';
import 'globals.dart';

enum GeoLevel {
  mahaanagar,
  vibhaag,
  bhaag,
  // shahar,
  nagar,
  upnagar,
  mandal,
  graam,
  vasti,
  shakhaa,
}

///////////////////////////////////////////////////////////////////////////////////////////////

class GeoHierarchyState {
  /// DROPDOWN ITEMS
  final Map<GeoLevel, List<GeoUnitMasterBAL>> items = {};

  /// SELECTED VALUES
  final Map<GeoLevel, String?> selectedValues = {};
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

final Map<GeoLevel, int> geoLevelIds = {
  GeoLevel.mahaanagar: 9,
  GeoLevel.vibhaag: 8,
  GeoLevel.bhaag: 7,
  GeoLevel.nagar: 6,
  GeoLevel.upnagar: 13,
  GeoLevel.mandal: 4,
  GeoLevel.graam: 3,
  GeoLevel.vasti: 2,
  GeoLevel.shakhaa: 1,
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
    level: GeoLevel.mahaanagar,
    levelName: 'Mahaanagar',
    levelIdKey: 'MahaanagarLevelID',
  ),

  GeoHierarchyNode(
    level: GeoLevel.vibhaag,
    levelName: 'Vibhaag',
    levelIdKey: 'VibhaagLevelID',
    parentResolver: (state) {
      final mahaanagar = state.selectedValues[GeoLevel.mahaanagar];

      /// NO MAHAANAGAR SELECTED
      /// LOAD ROOT VIBHAAG

      if (mahaanagar == null || mahaanagar.isEmpty) {
        return null;
      }

      return GeoLevel.mahaanagar;
    },
  ),

  GeoHierarchyNode(
    level: GeoLevel.bhaag,
    levelName: 'Bhaag',
    levelIdKey: 'BhaagLevelID',
    parentResolver: (_) => GeoLevel.vibhaag,
  ),

  GeoHierarchyNode(
    level: GeoLevel.nagar,
    levelName: 'Nagar',
    levelIdKey: 'NagarLevelID',
    parentResolver: (_) => GeoLevel.bhaag,
  ),

  GeoHierarchyNode(
    level: GeoLevel.upnagar,
    levelName: 'Upnagar',
    levelIdKey: 'UpaNagarLevelID',
    parentResolver: (_) => GeoLevel.nagar,
  ),

  /// DYNAMIC PARENT
  GeoHierarchyNode(
    level: GeoLevel.mandal,
    levelName: 'Mandal',
    levelIdKey: 'MandalLevelID',
    parentResolver: (state) {
      if (state.selectedValues[GeoLevel.upnagar] != null) {
        return GeoLevel.upnagar;
      }

      return GeoLevel.nagar;
    },
  ),

  /// DYNAMIC PARENT
  GeoHierarchyNode(
    level: GeoLevel.vasti,
    levelName: 'Vasti',
    levelIdKey: 'VastiLevelID',
    parentResolver: (state) {
      if (state.selectedValues[GeoLevel.upnagar] != null) {
        return GeoLevel.upnagar;
      }

      return GeoLevel.nagar;
    },
  ),

  GeoHierarchyNode(
    level: GeoLevel.graam,
    levelName: 'Graam',
    levelIdKey: 'GraamLevelID',
    parentResolver: (_) => GeoLevel.mandal,
  ),
];

final shakhaaNode = GeoHierarchyNode(
  level: GeoLevel.shakhaa,
  levelName: 'Shaakhaa',
  levelIdKey: 'ShaakhaaLevelID',
  parentResolver: (state) {
    /// PRIORITY TO VASTI

    if (state.selectedValues[GeoLevel.vasti] != null) {
      return GeoLevel.vasti;
    }

    /// OTHERWISE GRAAM

    if (state.selectedValues[GeoLevel.graam] != null) {
      return GeoLevel.graam;
    }

    return null;
  },
);

////////////////////////////////////////////// CONTROLLER /////////////////////////////////////////////

class GeoHierarchyController extends ChangeNotifier {
  final List<GeoHierarchyNode> hierarchy;

  GeoHierarchyController({
    required this.hierarchy,
  });

  final GeoHierarchyState state = GeoHierarchyState();

  DropDownModel? userData;

  int? userLevelId;

  String? userGeoUnitId;

  ////////////////////////////////////////////

  Future<void> initialize(DropDownModel dm) async {
    userData = dm;

    userLevelId = dm.levelID;

    userGeoUnitId = (dm.geoUnitID ?? 0).toString();

    await loadHierarchyForUser();
  }

  ////////////////////////////////////////////

  GeoLevel? _mapLevelIdToGeoLevel(int? levelId) {
    switch (levelId) {
      case 9:
        return GeoLevel.mahaanagar;

      case 8:
        return GeoLevel.vibhaag;

      case 7:
        return GeoLevel.bhaag;

      case 6:
        return GeoLevel.nagar;

      case 13:
        return GeoLevel.upnagar;

      case 4:
        return GeoLevel.mandal;

      case 3:
        return GeoLevel.graam;

      case 2:
        return GeoLevel.vasti;

      default:
        return null;
    }
  }

  bool isLevelLocked(GeoLevel level) {
    final restrictedLevel = _mapLevelIdToGeoLevel(userLevelId);

    if (restrictedLevel == null) {
      return false;
    }

    final lockedLevels = {
      GeoLevel.mahaanagar: [
        GeoLevel.mahaanagar,
      ],
      GeoLevel.vibhaag: [
        GeoLevel.mahaanagar,
        GeoLevel.vibhaag,
      ],
      GeoLevel.bhaag: [
        GeoLevel.mahaanagar,
        GeoLevel.vibhaag,
        GeoLevel.bhaag,
      ],
      GeoLevel.nagar: [
        GeoLevel.mahaanagar,
        GeoLevel.vibhaag,
        GeoLevel.bhaag,
        GeoLevel.nagar,
      ],
      GeoLevel.upnagar: [
        GeoLevel.mahaanagar,
        GeoLevel.vibhaag,
        GeoLevel.bhaag,
        GeoLevel.nagar,
        GeoLevel.upnagar,
      ],
      GeoLevel.mandal: [
        GeoLevel.mahaanagar,
        GeoLevel.vibhaag,
        GeoLevel.bhaag,
        GeoLevel.nagar,
        GeoLevel.upnagar,
        GeoLevel.mandal,
      ],
      GeoLevel.graam: [
        GeoLevel.mahaanagar,
        GeoLevel.vibhaag,
        GeoLevel.bhaag,
        GeoLevel.nagar,
        GeoLevel.upnagar,
        GeoLevel.mandal,
        GeoLevel.graam,
      ],
      GeoLevel.vasti: [
        GeoLevel.mahaanagar,
        GeoLevel.vibhaag,
        GeoLevel.bhaag,
        GeoLevel.nagar,
        GeoLevel.upnagar,
        GeoLevel.vasti,
      ],
    };

    return lockedLevels[restrictedLevel]?.contains(level) ?? false;
  }

  Future<void> loadHierarchyForUser() async {
    try {
      final selection = prepareSelection(userData!);

      /// STEP 1
      await loadLevel(GeoLevel.mahaanagar);

      state.selectedValues[GeoLevel.mahaanagar] = selection.mahaanagar;

      // // if (_isRestrictedAt(9)) return;

      /// STEP 2
      await loadLevel(GeoLevel.vibhaag);

      state.selectedValues[GeoLevel.vibhaag] = selection.vibhaag;

      // if (_isRestrictedAt(9)) return;

      /// STEP 3
      await loadLevel(GeoLevel.bhaag);

      state.selectedValues[GeoLevel.bhaag] = selection.bhaag;

      // if (_isRestrictedAt(8)) return;

      /// STEP 4
      await loadLevel(GeoLevel.nagar);

      state.selectedValues[GeoLevel.nagar] = selection.nagar;

      // if (_isRestrictedAt(7)) return;

      ////////////////////////////////////////
      /// LOAD UPNAGAR
      ////////////////////////////////////////

      await loadLevel(GeoLevel.upnagar);

      final hasUpnagar = state.items[GeoLevel.upnagar]?.isNotEmpty ?? false;

      ////////////////////////////////////////
      /// IF UPNAGAR EXISTS
      ////////////////////////////////////////

      if (hasUpnagar) {
        state.selectedValues[GeoLevel.upnagar] = selection.upnagar;

        // if (_isRestrictedAt(6)) return;
      }

      ////////////////////////////////////////
      /// LOAD MANDAL
      ////////////////////////////////////////

      await loadLevel(GeoLevel.mandal);

      state.selectedValues[GeoLevel.mandal] = selection.mandal;

      // if (_isRestrictedAt(6) || _isRestrictedAt(13)) return;

      ////////////////////////////////////////
      /// LOAD GRAAM
      ////////////////////////////////////////

      await loadLevel(GeoLevel.graam);

      state.selectedValues[GeoLevel.graam] = selection.graam;

      // if (_isRestrictedAt(4)) return;

      ////////////////////////////////////////
      /// LOAD VASTI
      ////////////////////////////////////////

      await loadLevel(GeoLevel.vasti);

      state.selectedValues[GeoLevel.vasti] = selection.vasti;
      // if (_isRestrictedAt(2)) return;

      ////////////////////////////////////////
      /// LOAD VASTI
      ////////////////////////////////////////

      await loadLevel(GeoLevel.shakhaa);

      state.selectedValues[GeoLevel.shakhaa] = selection.shakhaa;
      // if (_isRestrictedAt(2)) return;

      notifyListeners();
    } finally {
      notifyListeners();
    }
  }

  ////////////////////////////////////////////

  bool _isRestrictedAt(int level) {
    return userLevelId == level;
  }

  ////////////////////////////////////////////

  Future<void> loadLevel(GeoLevel level) async {
    final node = hierarchy.firstWhere((e) => e.level == level);

    String parentId = '';

    String parentType = '';

    GeoLevel? parentLevel = node.parentResolver?.call(state);

    if (parentLevel != null) {
      parentId = state.selectedValues[parentLevel] ?? '';

      parentType = hierarchy
          .firstWhere(
            (e) => e.level == parentLevel,
          )
          .levelName;
    }

    final data = await _fetchData(
      node,
      parentId,
      parentType,
    );

    state.items[level] = data;

    notifyListeners();
  }

  ////////////////////////////////////////////

  Future<List<GeoUnitMasterBAL>> _fetchData(GeoHierarchyNode node, String parentId, String parentType) async {
    final levelId = Statics.levels[node.levelIdKey].toString();

    /// UPNAGAR API
    if (parentType == 'Upnagar') {
      return await Statics.getGeoUnitsByLevelAndParentForUpnagar(
        levelId,
        parentId,
        parentType,
        '',
      );
    }

    return await Statics.getGeoUnitsByLevelAndParent(
      levelId,
      parentId,
      parentType,
      '',
      isAbhiyaan: false,
    );
  }

  ////////////////////////////////////////////

  Future<void> onDropdownChanged({required GeoLevel level, required String? value}) async {
    /// SAVE SELECTION
    state.selectedValues[level] = value;

    /// CLEAR BELOW LEVEL
    clearBelow(level);

    ////////////////////////////////////////
    /// SPECIAL CASE
    ////////////////////////////////////////

    if (level == GeoLevel.nagar) {
      /// LOAD UPNAGAR
      await loadLevel(GeoLevel.upnagar);

      // final hasUpnagar = state.items[GeoLevel.upnagar]?.isNotEmpty ?? false;

      // if (!hasUpnagar) {
      await loadLevel(GeoLevel.mandal);

      await loadLevel(GeoLevel.vasti);
      // }
    }

    ////////////////////////////////////////

    else if (level == GeoLevel.upnagar) {
      await loadLevel(GeoLevel.mandal);

      await loadLevel(GeoLevel.vasti);
    }

    ////////////////////////////////////////

    else if (level == GeoLevel.mandal) {
      await loadLevel(GeoLevel.graam);
    }

    ////////////////////////////////////////

    else if (level == GeoLevel.graam || level == GeoLevel.vasti) {
      if (_hasLevel(GeoLevel.shakhaa)) {
        await loadLevel(GeoLevel.shakhaa);
      }
    }
    ////////////////////////////////////////

    else {
      final currentIndex = GeoLevel.values.indexOf(level);

      if (currentIndex + 1 < GeoLevel.values.length) {
        final nextLevel = GeoLevel.values[currentIndex + 1];

        await loadLevel(nextLevel);
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
    bool shouldClear = false;

    for (final lvl in GeoLevel.values) {
      if (lvl == level) {
        shouldClear = true;
        continue;
      }

      if (shouldClear) {
        state.items.remove(lvl);

        state.selectedValues.remove(lvl);
      }
    }
  }

  ////////////////////////////////////////////

  bool hasItems(GeoLevel level) {
    return state.items[level]?.isNotEmpty ?? false;
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

  String? get deepestSelectedLevelName => deepestSelectedLevel?.name;

  GeoHierarchyTrail get hierarchyTrail {
    return GeoHierarchyTrail(
      mahaanagarId: state.selectedValues[GeoLevel.mahaanagar],
      vibhaagId: state.selectedValues[GeoLevel.vibhaag],
      bhaagId: state.selectedValues[GeoLevel.bhaag],
      nagarId: state.selectedValues[GeoLevel.nagar],
      upnagarId: state.selectedValues[GeoLevel.upnagar],
      mandalId: state.selectedValues[GeoLevel.mandal],
      graamId: state.selectedValues[GeoLevel.graam],
      vastiId: state.selectedValues[GeoLevel.vasti],
      shakhaaId: state.selectedValues[GeoLevel.shakhaa],
    );
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
  final void Function(dynamic)? onSaved;

  const GeoDropdownWidget({
    super.key,
    required this.level,
    required this.title,
    required this.controller,
    this.validator,
    this.onSaved,
  });

  @override
  Widget build(BuildContext context) {
    final items = controller.getItems(level);

    return buildDropdownField(
      isDisabled: controller.isLevelLocked(level),
      value: controller.getSelectedValue(level),
      label: Statics.getLabel(title, returnKey: true),
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
        );
      },
      validator: validator,
      onSaved: onSaved,
    );
  }
}
