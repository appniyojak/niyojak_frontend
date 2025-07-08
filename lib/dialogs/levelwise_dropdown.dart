import 'package:flutter/material.dart';

import '../helpers/static_data.dart' as Statics;
import '../helpers/static_data.dart';

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

  List<dynamic>? _linkedMandal;
  List<dynamic>? _linkedGraam;
  List<dynamic>? _linkedVasti;

  String? _linkedMandalValue;
  String? _linkedGraamValue;
  String? _linkedVastiValue;

  bool _showMandalGraam = false;

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

  void _onDropdownChange(String level, String? value) {
    setState(() {
      selectedValues[level] = value;

      bool reset = false;
      dropdownData.forEach((key, _) {
        if (reset) dropdownData[key] = null;
        if (key == level) reset = true;
      });
      selectedValues.forEach((key, _) {
        if (reset) selectedValues[key] = null;
        if (key == level) reset = true;
      });

      String? nextLevel = _getNextLevel(level);
      if (nextLevel != null && value != null) {
        _populateDropdown(nextLevel, value);
      }

      widget.onFinalSelection(level, value);

      if (level == 'Nagar' && value != null) {
        _checkIfMandalGraamOrVasti(value);
      }
    });
  }

  Future<void> _checkIfMandalGraamOrVasti(String nagarId) async {
    bool hasMandal = await checkIfNagarHasMandal(nagarId);

    setState(() {
      _showMandalGraam = hasMandal;

      _linkedMandal = _linkedGraam = _linkedVasti = null;
      _linkedMandalValue = _linkedGraamValue = _linkedVastiValue = null;

      if (_showMandalGraam) {
        _populateMandalDropdown(nagarId);
      } else {
        _populateVastiDropdown(nagarId);
      }
    });
  }

  void _populateMandalDropdown(String parentID) async {
    var data = await Statics.getGeoUnitsByLevelAndParent(
      Statics.levels['MandalLevelID'].toString(),
      parentID,
      'Nagar',
      '',
    );
    setState(() {
      _linkedMandal = data;
    });
  }

  void _populateGraamDropdown(String parentID) async {
    var data = await Statics.getGeoUnitsByLevelAndParent(
      Statics.levels['GraamLevelID'].toString(),
      parentID,
      'Mandal',
      '',
    );
    setState(() {
      _linkedGraam = data;
    });
  }

  void _populateVastiDropdown(String parentID) async {
    var data = await Statics.getGeoUnitsByLevelAndParent(
      Statics.levels['VastiLevelID'].toString(),
      parentID,
      'Nagar',
      '',
    );
    setState(() {
      _linkedVasti = data;
    });
  }

  void clearSelections() {
    setState(() {
      selectedValues.updateAll((key, value) => null);
      dropdownData.updateAll((key, value) => null);

      _linkedMandal = _linkedGraam = _linkedVasti = null;
      _linkedMandalValue = _linkedGraamValue = _linkedVastiValue = null;
      _showMandalGraam = false;

      _populateDropdown('Mahaanagar', '');
      _populateDropdown('Vibhaag', '');
    });

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
                      decoration:
                          InputDecoration(labelText: Statics.getLabel(level)),
                      isExpanded: true,
                      value: selectedValues[level],
                      items: data
                          .map((bg) => DropdownMenuItem(
                              value: bg.geoUnitID.toString(),
                              child: Text(bg.name!)))
                          .toList(),
                      onChanged: (value) => _onDropdownChange(level, value),
                    ),
                    SizedBox(height: 10),
                  ],
                )
              : SizedBox.shrink();
        }).toList(),
        if (_showMandalGraam && _linkedMandal != null)
          DropdownButtonFormField<String>(
            decoration: InputDecoration(labelText: Statics.getLabel('Mandal')),
            isExpanded: true,
            value: _linkedMandalValue,
            items: _linkedMandal!
                .map((bg) => DropdownMenuItem(
                    value: bg.geoUnitID.toString(), child: Text(bg.name!)))
                .toList(),
            onChanged: (value) {
              setState(() {
                _linkedMandalValue = value;
                widget.onFinalSelection('Mandal', value);
                _populateGraamDropdown(value!);
              });
            },
          ),
        if (_showMandalGraam && _linkedGraam != null)
          DropdownButtonFormField<String>(
            decoration: InputDecoration(labelText: Statics.getLabel('Graam')),
            isExpanded: true,
            value: _linkedGraamValue,
            items: _linkedGraam!
                .map((bg) => DropdownMenuItem(
                    value: bg.geoUnitID.toString(), child: Text(bg.name!)))
                .toList(),
            onChanged: (value) {
              setState(() {
                _linkedGraamValue = value;
                widget.onFinalSelection('Graam', value);
              });
            },
          ),
        if (!_showMandalGraam && _linkedVasti != null)
          DropdownButtonFormField<String>(
            decoration: InputDecoration(labelText: Statics.getLabel('Vasti')),
            isExpanded: true,
            value: _linkedVastiValue,
            items: _linkedVasti!
                .map((bg) => DropdownMenuItem(
                    value: bg.geoUnitID.toString(), child: Text(bg.name!)))
                .toList(),
            onChanged: (value) {
              setState(() {
                _linkedVastiValue = value;
                widget.onFinalSelection('Vasti', value);
              });
            },
          ),
      ],
    );
  }

  static Future<bool> checkIfNagarHasMandal(String nagarId) async {
    var mandalList = await getGeoUnitsByLevelAndParent(
      levels['MandalLevelID'].toString(),
      nagarId,
      'Nagar',
      '',
    );
    return mandalList.isNotEmpty;
  }
}
