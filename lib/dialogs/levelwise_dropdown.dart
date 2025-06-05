// // import 'package:flutter/material.dart';
// // import '../helpers/static_data.dart' as Statics;
// // import '../providers/bals.dart';
// //
// // class LevelWiseDropdown extends StatefulWidget {
// //   final Function(String? geoUnitID) onFinalSelection;
// //
// //   const LevelWiseDropdown({Key? key, required this.onFinalSelection})
// //       : super(key: key);
// //
// //   @override
// //   State<LevelWiseDropdown> createState() => _LevelWiseDropdownState();
// // }
// //
// // class _LevelWiseDropdownState extends State<LevelWiseDropdown> {
// //   final Map<String, List<GeoUnitMasterBAL>?> dropdownData = {
// //     'Mahaanagar': null,
// //     'Vibhaag': null,
// //     'Bhaag': null,
// //     'Nagar': null,
// //   };
// //
// //   final Map<String, String?> selectedValues = {
// //     'Mahaanagar': null,
// //     'Vibhaag': null,
// //     'Bhaag': null,
// //     'Nagar': null,
// //   };
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _populateDropdown('Mahaanagar', '');
// //     _populateDropdown('Vibhaag', '');
// //   }
// //
// //   Future<void> _populateDropdown(String level, String parentID) async {
// //     String? parentLevel = _getParentLevel(level);
// //
// //     if (parentID.isEmpty && level == 'Vibhaag') {
// //       parentLevel = '';
// //     }
// //
// //     var data = await Statics.getGeoUnitsByLevelAndParent(
// //       Statics.levels['${level}LevelID'].toString(),
// //       parentID,
// //       parentLevel ?? '',
// //       '',
// //     );
// //
// //     if (!mounted) return;
// //     setState(() {
// //       dropdownData[level] = data;
// //     });
// //   }
// //
// //   String? _getParentLevel(String level) {
// //     switch (level) {
// //       case 'Vibhaag':
// //         return 'Mahaanagar';
// //       case 'Bhaag':
// //         return 'Vibhaag';
// //       case 'Nagar':
// //         return 'Bhaag';
// //       default:
// //         return null;
// //     }
// //   }
// //
// //   void _onDropdownChange(String level, String? value) {
// //     setState(() {
// //       selectedValues[level] = value;
// //
// //       bool reset = false;
// //       dropdownData.forEach((key, list) {
// //         if (reset) dropdownData[key] = null;
// //         if (key == level) reset = true;
// //       });
// //
// //       selectedValues.forEach((key, val) {
// //         if (reset) selectedValues[key] = null;
// //         if (key == level) reset = true;
// //       });
// //       String? nextLevel = _getNextLevel(level);
// //       if (nextLevel != null && value != null) {
// //         _populateDropdown(nextLevel, value);
// //       }
// //       widget.onFinalSelection(value);
// //     });
// //   }
// //
// //   String? _getNextLevel(String level) {
// //     switch (level) {
// //       case 'Mahaanagar':
// //         return 'Vibhaag';
// //       case 'Vibhaag':
// //         return 'Bhaag';
// //       case 'Bhaag':
// //         return 'Nagar';
// //       default:
// //         return null;
// //     }
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Column(
// //       children: dropdownData.keys.map((level) {
// //         var data = dropdownData[level];
// //         return data != null
// //             ? Column(
// //           children: [
// //             DropdownButtonFormField<String>(
// //               decoration: InputDecoration(labelText: Statics.getLabel(level)),
// //               isExpanded: true,
// //               value: selectedValues[level],
// //               items: data
// //                   .map((bg) => DropdownMenuItem(
// //                 value: bg.geoUnitID.toString(),
// //                 child: Text(bg.name!),
// //               ))
// //                   .toList(),
// //               onChanged: (value) => _onDropdownChange(level, value),
// //             ),
// //             SizedBox(height: 10),
// //           ],
// //         )
// //             : SizedBox.shrink();
// //       }).toList(),
// //     );
// //   }
// // }
//
// import 'package:flutter/material.dart';
// import '../helpers/static_data.dart' as Statics;
// import '../providers/bals.dart';
//
// class LevelWiseDropdown extends StatefulWidget {
//   final Function(String level, String? geoUnitID) onFinalSelection;
//
//   const LevelWiseDropdown({Key? key, required this.onFinalSelection})
//       : super(key: key);
//
//   @override
//   State<LevelWiseDropdown> createState() => _LevelWiseDropdownState();
// }
//
// class _LevelWiseDropdownState extends State<LevelWiseDropdown> {
//   final Map<String, List<GeoUnitMasterBAL>?> dropdownData = {
//     'Mahaanagar': null,
//     'Vibhaag': null,
//     'Bhaag': null,
//     'Nagar': null,
//   };
//
//   final Map<String, String?> selectedValues = {
//     'Mahaanagar': null,
//     'Vibhaag': null,
//     'Bhaag': null,
//     'Nagar': null,
//   };
//
//   @override
//   void initState() {
//     super.initState();
//     _populateDropdown('Mahaanagar', '');
//     _populateDropdown('Vibhaag', '');
//   }
//
//   Future<void> _populateDropdown(String level, String parentID) async {
//     String? parentLevel = _getParentLevel(level);
//
//     if (parentID.isEmpty && level == 'Vibhaag') {
//       parentLevel = '';
//     }
//
//     var data = await Statics.getGeoUnitsByLevelAndParent(
//       Statics.levels['${level}LevelID'].toString(),
//       parentID,
//       parentLevel ?? '',
//       '',
//     );
//
//     if (!mounted) return;
//     setState(() {
//       dropdownData[level] = data;
//     });
//   }
//
//   String? _getParentLevel(String level) {
//     switch (level) {
//       case 'Vibhaag':
//         return 'Mahaanagar';
//       case 'Bhaag':
//         return 'Vibhaag';
//       case 'Nagar':
//         return 'Bhaag';
//       default:
//         return null;
//     }
//   }
//
//   void _onDropdownChange(String level, String? value) {
//     setState(() {
//       selectedValues[level] = value;
//
//       bool reset = false;
//       dropdownData.forEach((key, list) {
//         if (reset) dropdownData[key] = null;
//         if (key == level) reset = true;
//       });
//
//       selectedValues.forEach((key, val) {
//         if (reset) selectedValues[key] = null;
//         if (key == level) reset = true;
//       });
//
//       String? nextLevel = _getNextLevel(level);
//       if (nextLevel != null && value != null) {
//         _populateDropdown(nextLevel, value);
//       }
//
//       widget.onFinalSelection(level, value);
//     });
//   }
//
//   String? _getNextLevel(String level) {
//     switch (level) {
//       case 'Mahaanagar':
//         return 'Vibhaag';
//       case 'Vibhaag':
//         return 'Bhaag';
//       case 'Bhaag':
//         return 'Nagar';
//       default:
//         return null;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: dropdownData.keys.map((level) {
//         var data = dropdownData[level];
//         return data != null
//             ? Column(
//           children: [
//             DropdownButtonFormField<String>(
//               decoration:
//               InputDecoration(labelText: Statics.getLabel(level)),
//               isExpanded: true,
//               value: selectedValues[level],
//               items: data
//                   .map((bg) => DropdownMenuItem(
//                 value: bg.geoUnitID.toString(),
//                 child: Text(bg.name!),
//               ))
//                   .toList(),
//               onChanged: (value) => _onDropdownChange(level, value),
//             ),
//             SizedBox(height: 10),
//           ],
//         )
//             : SizedBox.shrink();
//       }).toList(),
//     );
//   }
// }
//
//
// class CascadingDropdowns extends StatefulWidget {
//   @override
//   _CascadingDropdownsState createState() => _CascadingDropdownsState();
// }
//
// class _CascadingDropdownsState extends State<CascadingDropdowns> {
//   Map<String, List<GeoUnitMasterBAL>?> dropdownData = {
//     'Mahaanagar': null,
//     'Vibhaag': null,
//     'Bhaag': null,
//     'Shahar': null,
//     'Nagar': null,
//     'Mandal': null,
//     'Graam': null,
//     'Vasti': null,
//   };
//
//   Map<String, String?> selectedValues = {
//     'Mahaanagar': null,
//     'Vibhaag': null,
//     'Bhaag': null,
//     'Shahar': null,
//     'Nagar': null,
//     'Mandal': null,
//     'Graam': null,
//     'Vasti': null,
//   };
//
//   @override
//   void initState() {
//     super.initState();
//     _populateDropdown('Mahaanagar');
//   }
//
//   Future<void> _populateDropdown(String level, {String? parentId, String? parentType}) async {
//     var data = await Statics.getGeoUnitsByLevelAndParent(
//       Statics.levels['${level}LevelID'].toString(),
//       parentId ?? '',
//       parentType ?? '',
//       '',
//     );
//     setState(() {
//       dropdownData[level] = data.isNotEmpty ? data : null;
//     });
//   }
//
//   Widget buildDropdown(String label, String level, String? parentLevel, String? parentType) {
//     return dropdownData[level] != null
//         ? DropdownButtonFormField(
//       decoration: InputDecoration(labelText: label),
//       isExpanded: true,
//       value: selectedValues[level],
//       items: dropdownData[level]!
//           .map((item) => DropdownMenuItem(
//         value: item.geoUnitID.toString(),
//         child: Text(item.name!),
//       ))
//           .toList(),
//       onChanged: (value) {
//         setState(() {
//           selectedValues[level] = value as String?;
//           if (parentLevel != null) {
//             selectedValues[parentLevel] = null;
//             dropdownData[parentLevel] = null;
//             _populateDropdown(parentLevel, parentId: value, parentType: parentType);
//           }
//         });
//       },
//     )
//         : SizedBox();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return ListView(
//       padding: const EdgeInsets.all(10),
//       children: [
//         buildDropdown('Mahaanagar', 'Mahaanagar', 'Vibhaag', 'Mahaanagar'),
//         buildDropdown('Vibhaag', 'Vibhaag', 'Bhaag', 'Vibhaag'),
//         buildDropdown('Bhaag', 'Bhaag', 'Shahar', 'Bhaag'),
//         buildDropdown('Shahar', 'Shahar', 'Nagar', 'Shahar'),
//         buildDropdown('Nagar', 'Nagar', 'Mandal', 'Nagar'),
//         buildDropdown('Mandal', 'Mandal', 'Graam', 'Mandal'),
//         buildDropdown('Graam', 'Graam', 'Vasti', 'Graam'),
//         buildDropdown('Vasti', 'Vasti', null, null),
//       ],
//     );
//   }
// }



import 'package:flutter/material.dart';
import '../helpers/static_data.dart' as Statics;

class LevelWiseDropdown extends StatefulWidget {
  final Function(String level, String? geoUnitID) onFinalSelection;

  const LevelWiseDropdown({Key? key, required this.onFinalSelection})
      : super(key: key);

  @override
  State<LevelWiseDropdown> createState() => LevelWiseDropdownState();
}

class LevelWiseDropdownState extends State<LevelWiseDropdown> {
  final Map<String, List<dynamic>?> dropdownData = {
    'Mahaanagar': null,
    'Vibhaag': null,
    'Bhaag': null,
    'Nagar': null,
  };

  final Map<String, String?> selectedValues = {
    'Mahaanagar': null,
    'Vibhaag': null,
    'Bhaag': null,
    'Nagar': null,
  };

  @override
  void initState() {
    super.initState();
    _populateDropdown('Mahaanagar', '');
    _populateDropdown('Vibhaag', '');
  }

  Future<void> _populateDropdown(String level, String parentID) async {
    String? parentLevel = _getParentLevel(level);

    if (parentID.isEmpty && level == 'Vibhaag') {
      parentLevel = '';
    }

    var data = await Statics.getGeoUnitsByLevelAndParent(
      Statics.levels['${level}LevelID'].toString(),
      parentID,
      parentLevel ?? '',
      '',
    );

    if (!mounted) return;
    setState(() {
      dropdownData[level] = data;
    });
  }

  String? _getParentLevel(String level) {
    switch (level) {
      case 'Vibhaag':
        return 'Mahaanagar';
      case 'Bhaag':
        return 'Vibhaag';
      case 'Nagar':
        return 'Bhaag';
      default:
        return null;
    }
  }

  void _onDropdownChange(String level, String? value) {
    setState(() {
      selectedValues[level] = value;

      bool reset = false;
      dropdownData.forEach((key, list) {
        if (reset) dropdownData[key] = null;
        if (key == level) reset = true;
      });

      selectedValues.forEach((key, val) {
        if (reset) selectedValues[key] = null;
        if (key == level) reset = true;
      });

      String? nextLevel = _getNextLevel(level);
      if (nextLevel != null && value != null) {
        _populateDropdown(nextLevel, value);
      }

      widget.onFinalSelection(level, value);
    });
  }

  String? _getNextLevel(String level) {
    switch (level) {
      case 'Mahaanagar':
        return 'Vibhaag';
      case 'Vibhaag':
        return 'Bhaag';
      case 'Bhaag':
        return 'Nagar';
      default:
        return null;
    }
  }

  void clearSelections() {
    setState(() {
      // Reset all selected values, including Mahaanagar and Vibhaag
      selectedValues.forEach((key, value) {
        selectedValues[key] = null;
      });

      // Clear dropdown data only for levels after Vibhaag
      dropdownData.forEach((key, value) {
        if (key == 'Bhaag' || key == 'Nagar') {
          dropdownData[key] = null;
        }
      });

      // Repopulate Mahaanagar and Vibhaag lists (but no selection should be visible)
      _populateDropdown('Mahaanagar', '');
      _populateDropdown('Vibhaag', '');
    });

    // Notify the parent widget about the cleared state
    widget.onFinalSelection('Mahaanagar', null);
  }



  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...dropdownData.keys.map((level) {
          var data = dropdownData[level];
          return data != null
              ? Column(
            children: [
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                    labelText: Statics.getLabel(level)),
                isExpanded: true,
                value: selectedValues[level],
                items: data
                    .map((bg) => DropdownMenuItem(
                  value: bg.geoUnitID.toString(),
                  child: Text(bg.name!),
                ))
                    .toList(),
                onChanged: (value) => _onDropdownChange(level, value),
              ),
              SizedBox(height: 10),
            ],
          )
              : SizedBox.shrink();
        }).toList(),
      ],
    );
  }
}
