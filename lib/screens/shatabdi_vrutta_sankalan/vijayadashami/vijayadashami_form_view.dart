import 'package:flutter/material.dart';
import 'package:niyojak_prod/widgets/app_drawer.dart';

import '../../../helpers/static_data.dart' as Statics;
import '../../../providers/bals.dart';

class VijayadashamiFormView extends StatefulWidget {
  static const String routeName = '/vijayadashami-form-view';

  const VijayadashamiFormView({super.key});

  @override
  State<VijayadashamiFormView> createState() => _VijayadashamiFormViewState();
}

class _VijayadashamiFormViewState extends State<VijayadashamiFormView> {
  final _formKey = GlobalKey<FormState>();

  String? selectedLevel;
  String? programOnTime;
  String? personalSong;
  String? ghoshVadan;

  List<String> levelOptions = ['नगर', 'तालुका', 'उपनगर', 'उपखंड', 'मंडल'];
  List<String> yesNoOptions = ['होय', 'नाही'];

  bool _isSearching = false;
  bool _isExpanded = false;
  List<GeoUnitMasterBAL>? _linkedMahaanagar;
  List<GeoUnitMasterBAL>? _linkedVibhaag;
  List<GeoUnitMasterBAL>? _linkedBhaag;
  List<GeoUnitMasterBAL>? _linkedShahar;
  List<GeoUnitMasterBAL>? _linkedNagar;
  List<GeoUnitMasterBAL>? _linkedmandal;
  List<GeoUnitMasterBAL>? _linkedgraam;
  List<GeoUnitMasterBAL>? _linkedvasti;
  List<StaticMasterBAL>? _baithakTypes;
  String? _linkedMahaanagarValue = '';
  String? _linkedVibhaagValue = '';
  String? _linkedBhaagValue = '';
  String? _linkedShaharValue = '';
  String? _linkedNagarValue = '';
  String? _linkedgraamValue = "";
  String? _linkedvastiValue = "";
  String? _baithakTypeValue = '';
  String? _baithakTypeYear = '';
  int? _baithakType;
  String _selectedNagarAndBaithak = '';
  String? mahanagarId = '';
  String? vibhagId = '';

  @override
  void initState() {
    super.initState();
    populateDropdown();
  }

  void populateDropdown() async {
    var data = await Statics.getStaticLDB('AnnualBaithakType');
    populatelinkedMahaanagarDropdown();
    populatelinkedVibhaagDropdown('');
    if (!mounted) return;
    _baithakTypes = data;
    _baithakTypes = _baithakTypes!
        .where((element) => element.showAnnualBaithakkey!.contains('1'))
        .toList();
    print("_baithakTypes :-- ${_baithakTypes}");
    setState(() {});
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedMahaanagarDropdown() async {
    var data = await Statics.getGeoUnitsByLevelAndParent(
        Statics.levels['MahaanagarLevelID'].toString(), '', '', '');
    setState(() {
      _linkedMahaanagar = data;
    });
    return data;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedBhaagDropdown(
      String vibhaagIDStr) async {
    _linkedShaharValue = _linkedNagarValue = null;
    var data = await Statics.getGeoUnitsByLevelAndParent(
        Statics.levels['BhaagLevelID'].toString(), vibhaagIDStr, 'Vibhaag', '');
    setState(() {
      _linkedBhaag = data;
    });
    return data;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedVibhaagDropdown(
      String mahaanagarIDStr) async {
    _linkedBhaagValue = null;
    var data = await Statics.getGeoUnitsByLevelAndParent(
        Statics.levels['VibhaagLevelID'].toString(),
        mahaanagarIDStr,
        (mahaanagarIDStr.isEmpty ? '' : 'Mahaanagar'),
        '');
    setState(() {
      _linkedVibhaag = data;
    });
    return data;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedShaharDropdown(
      String bhaagIDStr) async {
    _linkedShaharValue = _linkedShahar = null;
    var shDD = await Statics.getGeoUnitsByLevelAndParent(
        Statics.levels['ShaharLevelID'].toString(), bhaagIDStr, 'Bhaag', '');
    setState(() {
      _linkedShahar = (shDD.length > 0 ? shDD : null);
    });
    return shDD;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedNagarDropdown(
      String? bhaagIDStr, String? shaharIDStr) async {
    _linkedNagarValue = null;
    _linkedNagar = null;
    if (shaharIDStr != null) {
      var ngDD = await Statics.getGeoUnitsByLevelAndParent(
          Statics.levels['NagarLevelID'].toString(), shaharIDStr, 'Shahar', '');
      setState(() {
        _linkedNagar = (ngDD.length > 0 ? ngDD : null);
      });
      return ngDD;
    } else {
      var ngDD = await Statics.getGeoUnitsByLevelAndParent(
          Statics.levels['NagarLevelID'].toString(), bhaagIDStr!, 'Bhaag', '');
      setState(() {
        _linkedNagar = (ngDD.length > 0 ? ngDD : null);
      });
      return ngDD;
    }
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedMandalDropdown(
      String nagarIDStr) async {
    _linkedgraamValue = null;
    _linkedmandal = _linkedgraam = null;
    var mnDD = await Statics.getGeoUnitsByLevelAndParent(
        Statics.levels['MandalLevelID'].toString(), nagarIDStr, 'Nagar', '');
    setState(() {
      _linkedmandal = (mnDD.length > 0 ? mnDD : null);
    });
    return mnDD;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedGraamDropdown(
      String mandalIDStr) async {
    _linkedgraamValue = null;
    var gmDD = await Statics.getGeoUnitsByLevelAndParent(
        Statics.levels['GraamLevelID'].toString(), mandalIDStr, 'Mandal', '');
    setState(() {
      _linkedgraam = (gmDD.length > 0 ? gmDD : null);
    });
    return gmDD;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedVastiDropdown(
      String nagarIDStr) async {
    _linkedvastiValue = null;
    var vsDD = await Statics.getGeoUnitsByLevelAndParent(
        Statics.levels['VastiLevelID'].toString(), nagarIDStr, 'Nagar', '');
    setState(() {
      _linkedvasti = (vsDD.length > 0 ? vsDD : null);
    });
    return vsDD;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('कार्यक्रम माहिती फॉर्म'),
      ),
      drawer: AppDrawer(),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(border: Border.all()),
              child: Column(
                children: [
                  if (_linkedMahaanagar != null)
                    DropdownButtonFormField(
                      decoration: InputDecoration(
                          labelText: Statics.getLabel('Mahaanagar')),
                      isExpanded: true,
                      value: _linkedMahaanagarValue == ""
                          ? null
                          : _linkedMahaanagarValue,
                      items: _linkedMahaanagar!
                          .map((bg) => DropdownMenuItem(
                              value: bg.geoUnitID.toString(),
                              child: Text(bg.name!)))
                          .toList(),
                      onChanged: (value) {
                        print(value);
                        setState(() {
                          _linkedMahaanagarValue = value;
                          _linkedVibhaagValue = null;
                          _linkedBhaagValue = null;
                          _linkedShaharValue = null;
                          _linkedNagarValue = null;
                          populatelinkedVibhaagDropdown(value!);
                          mahanagarId = value;
                        });
                      },
                    ),
                  SizedBox(
                    height: 10,
                  ),
                  if (_linkedVibhaag != null)
                    DropdownButtonFormField(
                      decoration: InputDecoration(
                          labelText: Statics.getLabel('Vibhaag')),
                      isExpanded: true,
                      value: _linkedVibhaagValue == ""
                          ? null
                          : _linkedVibhaagValue,
                      items: _linkedVibhaag!
                          .map((bg) => DropdownMenuItem(
                              value: bg.geoUnitID.toString(),
                              child: Text(bg.name!)))
                          .toList(),
                      onChanged: (value) {
                        print(value);
                        setState(() {
                          _linkedVibhaagValue = value;
                          populatelinkedBhaagDropdown(value!);
                          vibhagId = value;
                          _linkedBhaagValue = _linkedNagarValue = null;
                          _linkedBhaag = _linkedNagar = null;
                        });
                      },
                    ),
                  SizedBox(
                    height: 10,
                  ),
                  if (_linkedBhaag != null)
                    DropdownButtonFormField(
                      decoration:
                          InputDecoration(labelText: Statics.getLabel('Bhaag')),
                      isExpanded: true,
                      value: _linkedBhaagValue == "" ? null : _linkedBhaagValue,
                      items: _linkedBhaag!
                          .map((bg) => DropdownMenuItem(
                              value: bg.geoUnitID.toString(),
                              child: Text(bg.name!)))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _linkedBhaagValue = value;
                          populatelinkedShaharDropdown(value!);
                          populatelinkedNagarDropdown(value, null);
                        });
                      },
                    ),
                  SizedBox(
                    height: 10,
                  ),
                  if (_linkedShahar != null && _linkedShahar!.length > 0)
                    DropdownButtonFormField(
                      decoration: InputDecoration(
                          labelText: Statics.getLabel('Shahar')),
                      isExpanded: true,
                      value:
                          _linkedShaharValue == "" ? null : _linkedShaharValue,
                      items: _linkedShahar!
                          .map((bg) => DropdownMenuItem(
                              value: bg.geoUnitID.toString(),
                              child: Text(bg.name!)))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _linkedShaharValue = value;
                          populatelinkedNagarDropdown(null, value);
                        });
                      },
                    ),
                  if (_linkedShahar != null && _linkedShahar!.length > 0)
                    SizedBox(
                      height: 10,
                    ),
                  if (_linkedNagar != null && _linkedNagar!.length > 0)
                    DropdownButtonFormField(
                      decoration:
                          InputDecoration(labelText: Statics.getLabel('Nagar')),
                      isExpanded: true,
                      value: _linkedNagarValue == "" ? null : _linkedNagarValue,
                      items: _linkedNagar!
                          .map((bg) => DropdownMenuItem(
                              value: bg.geoUnitID.toString(),
                              child: Text(bg.name!)))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _linkedNagarValue = value;
                        });
                      },
                    ),
                  if (_linkedNagar != null && _linkedNagar!.length > 0)
                    SizedBox(
                      height: 10,
                    ),
                ],
              ),
            ),

// ====================================================================================================================================================================================================================================================================================================================================================================================
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'कार्यक्रम कोणत्या स्तरावर झाले?',
                border: OutlineInputBorder(),
              ),
              items: levelOptions.map((level) {
                return DropdownMenuItem(value: level, child: Text(level));
              }).toList(),
              value: selectedLevel,
              onChanged: (val) => setState(() => selectedLevel = val),
              validator: (value) => value == null ? 'कृपया स्तर निवडा' : null,
            ),
            const SizedBox(height: 16),

            // कार्यक्रम निर्धारित वेळेवर झालं का?
            buildRadioQuestion(
              label: 'कार्यक्रम निर्धारित वेळेवर झालं का?',
              groupValue: programOnTime,
              onChanged: (val) => setState(() => programOnTime = val),
            ),

            // वैयक्तिक गीत कंठस्थ होतं का?
            buildRadioQuestion(
              label: 'वैयक्तिक गीत कंठस्थ होतं का?',
              groupValue: personalSong,
              onChanged: (val) => setState(() => personalSong = val),
            ),

            // कार्यक्रमात घोष वादन झालं का?
            buildRadioQuestion(
              label: 'कार्यक्रमात घोष वादन झालं का?',
              groupValue: ghoshVadan,
              onChanged: (val) => setState(() => ghoshVadan = val),
            ),

            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // Do something with the form data
                  // Get.snackbar("Success", "फॉर्म सबमिट झाला.");
                }
              },
              child: const Text('सबमिट'),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildRadioQuestion({
    required String label,
    required String? groupValue,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        Row(
          children: yesNoOptions.map((option) {
            return Expanded(
              child: RadioListTile(
                title: Text(option),
                value: option,
                groupValue: groupValue,
                onChanged: onChanged,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
