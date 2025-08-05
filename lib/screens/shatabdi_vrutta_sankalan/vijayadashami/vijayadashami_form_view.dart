import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:niyojak_prod/screens/shatabdi_vrutta_sankalan/vijayadashami/vijaya_dashami_report.dart';
import 'package:niyojak_prod/widgets/app_drawer.dart';

import '../../../helpers/static_data.dart' as Statics;
import '../../../models/request_model/pat_gan_anya_vijaya_dashami_model.dart';
import '../../../models/request_model/sanchalan_list_model.dart';
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

  bool _isSearching = false;
  bool _isExpanded = false;
  bool isVastiSearch = false;

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
  String? _linkedmandalValue = "";
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
    maleController.addListener(_updateTotal);
    femaleController.addListener(_updateTotal);
  }

  int total = 0;
  void _updateTotal() {
    final int male = int.tryParse(maleController.text) ?? 0;
    final int female = int.tryParse(femaleController.text) ?? 0;
    setState(() {
      total = male + female;
    });
  }

  void clearForm() async {
    setState(() {
      programNirdharitVed = 2;
      vaiyaktikGitKantashtha = 2;
      programHishobh24Hour = 2;
      maleController.clear();
      femaleController.clear();
      sanchalanZaleKa = 2;
      savedsanchalanZaleKaEntries = [];
      savedPatGanAnyaEntries = [];
      presentMatrushaktiController.clear();
      presentMaleController.clear();
      _isExpanded = false;
      // Reset selected values
      _linkedMahaanagarValue = null;
      _linkedVibhaagValue = null;
      _linkedBhaagValue = null;
      _linkedShaharValue = null;
      _linkedNagarValue = null;
      _linkedmandalValue = null;
      _linkedgraamValue = null;
      _linkedvastiValue = null;

      // Clear data lists
      // _linkedVibhaag = null;
      _linkedBhaag = null;
      _linkedShahar = null;
      _linkedNagar = null;
      _linkedmandal = null;
      _linkedgraam = null;
      _linkedvasti = null;

      // Reset level tracking variables
      selctedLevel = '';
      selctedLevelName = '';
      selctedLevelId = null;
      populatelinkedVibhaagDropdown('');
    });
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

  String? selctedLevel = 'praant';
  String? selctedLevelName = '';
  String? selctedLevelId = '';
  String? selctedSanchalanLevelId = '';
  String? selctedSanchalanLevelName = '';

  int? programNirdharitVed = 2;
  int? vaiyaktikGitKantashtha = 2;
  int? programHishobh24Hour = 2;
  int? sanchalanZaleKa = 2;
  int? sanchalanSadandaZalKa = 2;
  int? sanchalanGhoshVadanZalKa = 2;

  final TextEditingController maleController = TextEditingController();
  final TextEditingController femaleController = TextEditingController();
  final TextEditingController presentMaleController = TextEditingController();
  final TextEditingController presentMatrushaktiController =
      TextEditingController();

  @override
  void dispose() {
    femaleController.clear();
    maleController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int total = (int.tryParse(maleController.text) ?? 0) +
        (int.tryParse(femaleController.text) ?? 0);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${Statics.getLabel('vijayaDashamiUtsav')}",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(VijayadashamiFormReport.routeName);
              },
              icon: Icon(Icons.document_scanner_outlined))
        ],
      ),
      drawer: AppDrawer(),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
//=======================================   SEARCH FILTERS ==========================================================================================
            ExpansionPanelList(
              expansionCallback: (int index, bool isExpanded) {
                setState(() {
                  _isExpanded = isExpanded;
                });
              },
              children: [
                ExpansionPanel(
                  headerBuilder: (BuildContext context, bool isExpanded) {
                    return ListTile(
                      title: Text(
                        Statics.getLabel('selectStar'),
                        style: TextStyle(
                            color: Colors.purpleAccent,
                            fontWeight: FontWeight.bold),
                      ),
                      trailing: IconButton(
                          onPressed: () {
                            clearForm();
                          },
                          icon: Icon(Icons.refresh),
                          color: Colors.purpleAccent),
                      iconColor: Colors.purpleAccent,
                    );
                  },
                  body: Container(
                    margin: EdgeInsets.all(20),
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
                              final selectedItem = _linkedMahaanagar!
                                  .firstWhere(
                                      (bg) => bg.geoUnitID.toString() == value);
                              print(value);
                              setState(() {
                                _linkedMahaanagarValue = value;
                                _linkedVibhaagValue = null;
                                _linkedBhaagValue = null;
                                _linkedShaharValue = null;
                                _linkedNagarValue = null;
                                populatelinkedVibhaagDropdown(value!);
                                mahanagarId = value;
                                selctedLevelName = selectedItem.name ?? "";
                                selctedLevel = 'Mahanagar';
                                selctedLevelId = value;
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
                              final selectedItem = _linkedVibhaag!.firstWhere(
                                  (bg) => bg.geoUnitID.toString() == value);
                              print(value);
                              setState(() {
                                _linkedVibhaagValue = value;
                                populatelinkedBhaagDropdown(value!);
                                vibhagId = value;
                                _linkedBhaagValue = _linkedNagarValue = null;
                                _linkedBhaag = _linkedNagar = null;
                                selctedLevelName = selectedItem.name ?? "";
                                selctedLevel = 'Vibhaag';
                                selctedLevelId = value;
                              });
                            },
                          ),
                        SizedBox(
                          height: 10,
                        ),
                        if (_linkedBhaag != null)
                          DropdownButtonFormField(
                            decoration: InputDecoration(
                                labelText: Statics.getLabel('Bhaag')),
                            isExpanded: true,
                            value: _linkedBhaagValue == ""
                                ? null
                                : _linkedBhaagValue,
                            items: _linkedBhaag!
                                .map((bg) => DropdownMenuItem(
                                    value: bg.geoUnitID.toString(),
                                    child: Text(bg.name!)))
                                .toList(),
                            onChanged: (value) {
                              final selectedItem = _linkedBhaag!.firstWhere(
                                  (bg) => bg.geoUnitID.toString() == value);
                              setState(() {
                                _linkedBhaagValue = value;
                                // populatelinkedShaharDropdown(value!);
                                populatelinkedNagarDropdown(value, null);
                                selctedLevelName = selectedItem.name ?? "";
                                selctedLevel = 'Bhaag';
                                selctedLevelId = value;
                              });
                            },
                          ),
                        if (_linkedNagar != null && _linkedNagar!.length > 0)
                          DropdownButtonFormField(
                            decoration: InputDecoration(
                                labelText: Statics.getLabel('Nagar')),
                            isExpanded: true,
                            value: _linkedNagarValue == ""
                                ? null
                                : _linkedNagarValue,
                            items: _linkedNagar!
                                .map((bg) => DropdownMenuItem(
                                    value: bg.geoUnitID.toString(),
                                    child: Text(bg.name!)))
                                .toList(),
                            onChanged: (value) {
                              final selectedItem = _linkedNagar!.firstWhere(
                                  (bg) => bg.geoUnitID.toString() == value);
                              populatelinkedMandalDropdown(value!);
                              populatelinkedVastiDropdown(value);
                              setState(() {
                                selctedLevelName = selectedItem.name ?? "";
                                selctedLevel = 'Nagar';
                                selctedLevelId = value;

                                _linkedNagarValue = value;
                              });
                            },
                          ),
                        // if (_linkedNagar != null && _linkedNagar!.length > 0)
                        //   SizedBox(
                        //     height: 10,
                        //   ),
                        // if (_linkedmandal != null && _linkedmandal!.length > 0)
                        //   DropdownButtonFormField(
                        //     decoration: InputDecoration(
                        //         labelText: Statics.getLabel('Mandal')),
                        //     isExpanded: true,
                        //     value: _linkedmandalValue == ""
                        //         ? null
                        //         : _linkedmandalValue,
                        //     items: _linkedmandal!
                        //         .map((bg) => DropdownMenuItem(
                        //             value: bg.geoUnitID.toString(),
                        //             child: Text(bg.name!)))
                        //         .toList(),
                        //     onChanged: (value) {
                        //       final selectedItem = _linkedmandal!.firstWhere(
                        //           (bg) => bg.geoUnitID.toString() == value);
                        //       setState(() {
                        //         selctedLevelName = selectedItem.name ?? "";
                        //         selctedLevel = 'Mandal';
                        //         selctedLevelId = value;
                        //
                        //         _linkedmandalValue = value;
                        //         populatelinkedGraamDropdown(value!);
                        //       });
                        //     },
                        //   ),
                        // if (_linkedmandal != null && _linkedmandal!.length > 0)
                        //   SizedBox(
                        //     height: 10,
                        //   ),
                        // if (_linkedgraam != null && _linkedgraam!.length > 0)
                        //   DropdownButtonFormField(
                        //     decoration: InputDecoration(
                        //         labelText: Statics.getLabel('Graam')),
                        //     isExpanded: true,
                        //     value: _linkedgraamValue == ""
                        //         ? null
                        //         : _linkedgraamValue,
                        //     items: _linkedgraam!
                        //         .map((bg) => DropdownMenuItem(
                        //             value: bg.geoUnitID.toString(),
                        //             child: Text(bg.name!)))
                        //         .toList(),
                        //     onChanged: (value) {
                        //       final selectedItem = _linkedgraam!.firstWhere(
                        //           (bg) => bg.geoUnitID.toString() == value);
                        //       setState(() {
                        //         _linkedgraamValue = value;
                        //         selctedLevelName = selectedItem.name ?? "";
                        //         selctedLevel = 'Graam';
                        //         selctedLevelId = value;
                        //       });
                        //     },
                        //   ),
                        // if (_linkedvasti != null && _linkedvasti!.length > 0)

                        // DropdownButtonFormField(
                        //   decoration: InputDecoration(
                        //       labelText: Statics.getLabel('Vasti')),
                        //   isExpanded: true,
                        //   value: _linkedvastiValue == ""
                        //       ? null
                        //       : _linkedvastiValue,
                        //   items: _linkedvasti!
                        //       .map((bg) => DropdownMenuItem(
                        //           value: bg.geoUnitID.toString(),
                        //           child: Text(bg.name!)))
                        //       .toList(),
                        //   onChanged: (value) {
                        //     final selectedItem = _linkedvasti!.firstWhere(
                        //         (bg) => bg.geoUnitID.toString() == value);
                        //     setState(() {
                        //       _linkedvastiValue = value;
                        //       selctedLevelName = selectedItem.name ?? "";
                        //       selctedLevel = 'Vasti';
                        //       selctedLevelId = value;
                        //     });
                        //   },
                        // ),
                        SizedBox(
                          height: 15,
                        ),
                        if (selctedLevel == 'Nagar')
                          Align(
                            alignment: Alignment.center,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor: MaterialStatePropertyAll(
                                      Colors.purpleAccent)),
                              onPressed: () {
                                setState(() {
                                  _isExpanded = false;
                                  isVastiSearch = true;
                                });
                              },
                              child: Text("${Statics.getLabel('Filters')}",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                            ),
                          )
                      ],
                    ),
                  ),
                  isExpanded: _isExpanded,
                ),
              ],
            ),

            SizedBox(
              height: 20,
            ),
            if (isVastiSearch == false)
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    // ""
                    // "${Statics.getLabel('Note')} :- "
                    "${Statics.getLabel('NagarSelectionImportant')}",
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 2),
                  Container(
                    height: 2,
                    width: double.infinity,
                    color: Colors.red,
                  ),
                ],
              ),
            if (selctedLevel != "" &&
                selctedLevelName != "" &&
                isVastiSearch == true)
              Container(
                  height: 40,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.purpleAccent, width: 1),
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "${selctedLevel}  ->  ",
                        style: TextStyle(
                            color: Colors.purpleAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                      Text(
                        " $selctedLevelName",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 17),
                      ),
                    ],
                  )),
            SizedBox(
              height: 10,
            ),
// ================================== 1 QUESTIONS Box ==================================================================================================================================================================================================================================================================================================================================================
            mainContainer(
              "${Statics.getLabel('utsavLable')}  ${Statics.getLabel('Information')}",
              Column(
                children: [
                  yesNoRadioButton(
                    question: "${Statics.getLabel('ProgramNirdharitTime')}",
                    selectedOption: programNirdharitVed ?? 2,
                    onChanged: (value) {
                      setState(() {
                        programNirdharitVed = value;
                      });
                    },
                  ),
                  yesNoRadioButton(
                    question: "${Statics.getLabel('vaiyaktikGitKantashtha')}",
                    selectedOption: vaiyaktikGitKantashtha ?? 2,
                    onChanged: (value) {
                      setState(() {
                        vaiyaktikGitKantashtha = value;
                      });
                    },
                  ),
                  yesNoRadioButton(
                    question: "${Statics.getLabel('programHishobh24Hour')}",
                    selectedOption: programHishobh24Hour ?? 2,
                    onChanged: (value) {
                      setState(() {
                        programHishobh24Hour = value;
                      });
                    },
                  ),
                ],
              ),
            ),
// ================================== 2 QUESTIONS Box ==================================================================================================================================================================================================================================================================================================================================================
            mainContainer(
              "${Statics.getLabel('mukhyaAtithi')}",
              Column(
                children: [],
              ),
            ),
// ================================== 3 QUESTIONS Box ==================================================================================================================================================================================================================================================================================================================================================
            mainContainer(
              "${Statics.getLabel('specialAtithi')}",
              Column(
                children: [],
              ),
            ),
// ================================== 4 QUESTIONS Box ==================================================================================================================================================================================================================================================================================================================================================
            mainContainer(
              "${Statics.getLabel('upasthitAnya')}",
              Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "${Statics.getLabel('Population')}",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          TextSpan(
                            text: "",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: maleController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: '${Statics.getLabel('Men')}',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: TextField(
                          controller: femaleController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: '${Statics.getLabel('Women')}',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text(
                    '${Statics.getLabel('ekunLoksankhya')}: $total',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple),
                  ),
                ],
              ),
            ),
// ================================== 5 QUESTIONS Box ==================================================================================================================================================================================================================================================================================================================================================
            mainContainer(
              "${Statics.getLabel('sanchalan')}",
              Column(
                children: [
                  yesNoRadioButton(
                    question: "${Statics.getLabel('sanchalanZaleKa')}",
                    selectedOption: sanchalanZaleKa ?? 2,
                    onChanged: (value) {
                      setState(() {
                        sanchalanZaleKa = value;
                      });
                    },
                  ),
                  if (sanchalanZaleKa == 1)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: () {
                            showsanchalanZaleKaPopup(context);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            width: 100,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.purpleAccent.shade100),
                                color: Colors.purpleAccent.withOpacity(0.7),
                                borderRadius: BorderRadius.circular(15)),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.add,
                                      color: Colors.white, size: 15),
                                  SizedBox(width: 5),
                                  Text(
                                    "${Statics.getLabel('AddButton')}",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  if (sanchalanZaleKa == 1)
                    SizedBox(
                      height: 20,
                    ),
                  if (sanchalanZaleKa == 1)
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        headingRowColor: MaterialStateProperty.all(
                            Colors.purpleAccent.shade100),
                        headingTextStyle: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                        columns: [
                          DataColumn(label: Text(Statics.getLabel('Vasti'))),
                          DataColumn(
                              label:
                                  Text(Statics.getLabel('sanchalanSadanda'))),
                          DataColumn(
                              label: Text(
                                  Statics.getLabel('sanchalanGhoshVadan'))),
                        ],
                        rows: savedsanchalanZaleKaEntries
                            .map(
                              (entry) => DataRow(cells: [
                                DataCell(Text(
                                    entry.selectedSanchalanVastiName ?? "-")),
                                DataCell(Text(
                                  entry.sanchalanSadandaYesNo == 1
                                      ? Statics.getLabel('ConfirmationYes')
                                      : Statics.getLabel('ConfirmationNo'),
                                )),
                                DataCell(Text(
                                  entry.sanchalanGhoshVadanYesNo == 1
                                      ? Statics.getLabel('ConfirmationYes')
                                      : Statics.getLabel('ConfirmationNo'),
                                )),
                              ]),
                            )
                            .toList(),
                      ),
                    ),
                ],
              ),
            ),
// ================================== 6 QUESTIONS Box ==================================================================================================================================================================================================================================================================================================================================================
            mainContainer(
              "${Statics.getLabel('searchSwayamsevakScreenLabel')}",
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          showSwayamsewakPopupDialog(context);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          width: 100,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.purpleAccent.shade100),
                              color: Colors.purpleAccent.withOpacity(0.7),
                              borderRadius: BorderRadius.circular(15)),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add, color: Colors.white, size: 15),
                                SizedBox(width: 5),
                                Text(
                                  "${Statics.getLabel('AddButton')}",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  buildSavedPatGanAnyaTable(savedPatGanAnyaEntries),
                ],
              ),
            ),
// ================================== 7 QUESTIONS Box ==================================================================================================================================================================================================================================================================================================================================================
            mainContainer(
              "${Statics.getLabel('otherInfo')}",
              Column(
                children: [
                  textControllerField2(
                      name: Statics.getLabel("presentMatrushakti"),
                      controller: presentMatrushaktiController,
                      keyboardType: TextInputType.number),
                  textControllerField2(
                      name: Statics.getLabel("presentMale"),
                      controller: presentMaleController,
                      keyboardType: TextInputType.number),
                ],
              ),
            ),
//==============================  SUBMIT BUTTON =======================================================================
            Container(
              child: MaterialButton(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                color: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50)),
                onPressed: () {
                  submitForm();
                },
                child: Text(
                  Statics.getLabel('Submit'),
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

// ================================  SANCHALAN POPUP ==================================================================
  List<SanchalanDataList> savedsanchalanZaleKaEntries = [];
  String? selctedsanchalanZaleKaLevelName;
  String? selctedsanchalanZaleKaLevelId;
  Future<void> showsanchalanZaleKaPopup(BuildContext context) async {
    String? localSelectedLevelName = selctedsanchalanZaleKaLevelName;
    String? localSelectedLevelId = selctedsanchalanZaleKaLevelId;
    int? localSanchalanSadandaZalKa = sanchalanSadandaZalKa;
    int? localSanchalanGhoshVadanZalKa = sanchalanGhoshVadanZalKa;

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, updateState) {
            return AlertDialog(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    Statics.getLabel('sanchalan'),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.grey[700]),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  )
                ],
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButtonFormField(
                      decoration: InputDecoration(
                        labelText: Statics.getLabel('Vasti'),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(
                            color: Colors.grey.shade400,
                            width: 1.5,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(
                            color: Colors.purpleAccent,
                            width: 2,
                          ),
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                      ),
                      isExpanded: true,
                      value: localSelectedLevelId,
                      items: _linkedvasti!
                          .map((bg) => DropdownMenuItem(
                                value: bg.geoUnitID.toString(),
                                child: Text(bg.name!),
                              ))
                          .toList(),
                      onChanged: (value) {
                        final selectedItem = _linkedvasti!.firstWhere(
                            (bg) => bg.geoUnitID.toString() == value);
                        updateState(() {
                          localSelectedLevelName = selectedItem.name ?? "";
                          localSelectedLevelId = value.toString();
                        });
                      },
                    ),
                    const SizedBox(height: 15),
                    yesNoRadioButton(
                      question: Statics.getLabel('sanchalanSadandaZalKa'),
                      selectedOption: localSanchalanSadandaZalKa ?? 2,
                      onChanged: (value) {
                        updateState(() {
                          localSanchalanSadandaZalKa = value;
                        });
                      },
                    ),
                    yesNoRadioButton(
                      question: Statics.getLabel('sanchalanGhoshVadanZalKa'),
                      selectedOption: localSanchalanGhoshVadanZalKa ?? 2,
                      onChanged: (value) {
                        updateState(() {
                          localSanchalanGhoshVadanZalKa = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purpleAccent,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      try {
                        final entry = SanchalanDataList(
                          selectedSanchalanVastiId:
                              int.tryParse(localSelectedLevelId ?? "0"),
                          selectedSanchalanVastiName: localSelectedLevelName,
                          sanchalanGhoshVadanYesNo:
                              localSanchalanGhoshVadanZalKa,
                          sanchalanSadandaYesNo: localSanchalanSadandaZalKa,
                        );

                        Navigator.pop(context, entry);
                      } catch (e) {
                        print("Error while saving: $e");
                      }
                    },
                    child: Text(Statics.getLabel('Submit')),
                  ),
                ),
              ],
            );
          },
        );
      },
    ).then((result) {
      if (result != null && result is SanchalanDataList) {
        setState(() {
          savedsanchalanZaleKaEntries.add(result);

          selctedsanchalanZaleKaLevelName = null;
          selctedsanchalanZaleKaLevelId = null;
          sanchalanSadandaZalKa = null;
          sanchalanGhoshVadanZalKa = null;
        });
      }
    });
  }

  List<PatGanAnyaDataList> savedPatGanAnyaEntries = [];
  String? selctedPatGanAnyaLevelName;
  String? selctedPatGanAnyaLevelId;
  Future<void> showSwayamsewakPopupDialog(BuildContext context) async {
    List<List<TextEditingController>> matrixControllers = List.generate(
      3,
      (_) => List.generate(5, (_) => TextEditingController()),
    );

    final List<String> columnHeaders = [
      Statics.getLabel('Shishu'),
      Statics.getLabel('Baal'),
      Statics.getLabel('MahaavidyaalayeenTarunLabel'),
      Statics.getLabel('TarunVyavasaayee'),
      Statics.getLabel('ProudhVyavasaayee'),
    ];

    final List<String> rowHeaders = [
      Statics.getLabel('patSankhyaa'),
      Statics.getLabel('ganveshatPresentCount'),
      Statics.getLabel('otherSwayamsewakPresentCount'),
    ];

    int getRowTotal(int rowIndex) {
      int sum = 0;
      for (var ctrl in matrixControllers[rowIndex]) {
        sum += int.tryParse(ctrl.text) ?? 0;
      }
      return sum;
    }

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, updateState) {
            return AlertDialog(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    Statics.getLabel('searchSwayamsevakScreenLabel'),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.grey[700]),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_linkedmandal != null && _linkedmandal!.length > 0)
                      DropdownButtonFormField(
                        decoration: InputDecoration(
                            labelText: Statics.getLabel('Mandal')),
                        isExpanded: true,
                        value: _linkedmandalValue == ""
                            ? null
                            : _linkedmandalValue,
                        items: _linkedmandal!
                            .map((bg) => DropdownMenuItem(
                                value: bg.geoUnitID.toString(),
                                child: Text(bg.name!)))
                            .toList(),
                        onChanged: (value) {
                          final selectedItem = _linkedmandal!.firstWhere(
                              (bg) => bg.geoUnitID.toString() == value);
                          setState(() {
                            selctedLevelName = selectedItem.name ?? "";
                            selctedLevel = 'Mandal';
                            selctedLevelId = value;

                            _linkedmandalValue = value;
                            populatelinkedGraamDropdown(value!);
                          });
                        },
                      ),
                    if (_linkedvasti != null && _linkedvasti!.length > 0)
                      DropdownButtonFormField(
                        decoration: InputDecoration(
                          labelText: Statics.getLabel('Vasti'),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(
                              color: Colors.grey.shade400,
                              width: 1.5,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(
                              color: Colors.purpleAccent,
                              width: 2,
                            ),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 12, vertical: 14),
                        ),
                        isExpanded: true,
                        value:
                            _linkedvastiValue == "" ? null : _linkedvastiValue,
                        items: _linkedvasti!
                            .map((bg) => DropdownMenuItem(
                                  value: bg.geoUnitID.toString(),
                                  child: Text(bg.name!),
                                ))
                            .toList(),
                        onChanged: (value) {
                          final selectedItem = _linkedvasti!.firstWhere(
                              (bg) => bg.geoUnitID.toString() == value);
                          setState(() {
                            selctedPatGanAnyaLevelName =
                                selectedItem.name ?? "";
                            selctedPatGanAnyaLevelId = value;
                          });
                        },
                      ),
                    const SizedBox(height: 12),
                    // SingleChildScrollView(
                    //   scrollDirection: Axis.horizontal,
                    //   child: Column(
                    //     children: [
                    //       // Column Headers
                    //       Row(
                    //         children: [
                    //           SizedBox(width: 100),
                    //           ...columnHeaders.map(
                    //             (col) => Container(
                    //               width: 120,
                    //               alignment: Alignment.center,
                    //               child: Text(col, textAlign: TextAlign.center),
                    //             ),
                    //           ),
                    //         ],
                    //       ),
                    //       const SizedBox(height: 15),
                    //
                    //       // Input Grid
                    //       Column(
                    //         children: List.generate(3, (row) {
                    //           return Row(
                    //             children: [
                    //               SizedBox(
                    //                 width: 100,
                    //                 child: Text(rowHeaders[row]),
                    //               ),
                    //               ...List.generate(5, (col) {
                    //                 return Container(
                    //                   width: 120,
                    //                   padding: const EdgeInsets.all(4),
                    //                   child: TextField(
                    //                     controller: matrixControllers[row][col],
                    //                     keyboardType: TextInputType.number,
                    //                     decoration: InputDecoration(
                    //                       hintText: '0',
                    //                       border: OutlineInputBorder(),
                    //                       contentPadding:
                    //                           const EdgeInsets.symmetric(
                    //                         horizontal: 8,
                    //                         vertical: 4,
                    //                       ),
                    //                     ),
                    //                   ),
                    //                 );
                    //               }),
                    //             ],
                    //           );
                    //         }),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Column(
                        children: [
                          // Header Row
                          Row(
                            children: [
                              buildCell('', isHeader: true),
                              ...columnHeaders
                                  .map((col) => buildCell(col, isHeader: true))
                                  .toList(),
                            ],
                          ),

                          // Table Rows
                          ...List.generate(rowHeaders.length, (row) {
                            return Row(
                              children: [
                                buildCell(rowHeaders[row], isHeader: true),
                                ...List.generate(columnHeaders.length, (col) {
                                  return Container(
                                    width: 100,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.grey.shade400),
                                    ),
                                    padding: EdgeInsets.all(8),
                                    child: Center(
                                      child: TextField(
                                        controller: matrixControllers[row][col],
                                        textAlign: TextAlign.center,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: '0',
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                              ],
                            );
                          }),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Colors.purpleAccent, // Button background color
                      foregroundColor: Colors.white, // Text color
                    ),
                    onPressed: () {
                      try {
                        final entry = PatGanAnyaDataList(
                          shishupatSankhya:
                              int.tryParse(matrixControllers[0][0].text),
                          baalpatSankhya:
                              int.tryParse(matrixControllers[0][1].text),
                          mahaidyalayinpatSankhya:
                              int.tryParse(matrixControllers[0][2].text),
                          tarunpatSankhya:
                              int.tryParse(matrixControllers[0][3].text),
                          proudhpatSankhya:
                              int.tryParse(matrixControllers[0][4].text),
                          totalpatSankhya: getRowTotal(0),
                          shishuGanvesh:
                              int.tryParse(matrixControllers[1][0].text),
                          baalGanvesh:
                              int.tryParse(matrixControllers[1][1].text),
                          mahaidyalayinGanvesh:
                              int.tryParse(matrixControllers[1][2].text),
                          tarunGanvesh:
                              int.tryParse(matrixControllers[1][3].text),
                          proudhGanvesh:
                              int.tryParse(matrixControllers[1][4].text),
                          totalGanvesh: getRowTotal(1),
                          shishuAnyaUpastith:
                              int.tryParse(matrixControllers[2][0].text),
                          baalAnyaUpastith:
                              int.tryParse(matrixControllers[2][1].text),
                          mahaidyalayinAnyaUpastith:
                              int.tryParse(matrixControllers[2][2].text),
                          tarunAnyaUpastith:
                              int.tryParse(matrixControllers[2][3].text),
                          proudhAnyaUpastith:
                              int.tryParse(matrixControllers[2][4].text),
                          totalAnyaUpastith: getRowTotal(2),
                          selectedLevelId:
                              int.tryParse(selctedPatGanAnyaLevelId ?? "0"),
                          selectedLevelName: selctedPatGanAnyaLevelName,
                        );

                        Navigator.pop(context, entry);
                      } catch (e) {
                        print("Error while saving: $e");
                      }
                    },
                    child: Text(
                      Statics.getLabel('Submit'),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    ).then((result) {
      if (result != null && result is PatGanAnyaDataList) {
        setState(() {
          savedPatGanAnyaEntries.add(result);
        });
      }
    });
  }

  Widget buildCell(String text, {bool isHeader = false}) {
    return Container(
      width: 100,
      height: 60,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        color: Colors.transparent,
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget buildSavedPatGanAnyaTable(List<PatGanAnyaDataList> dataList) {
    if (dataList.isEmpty) {
      return Text(Statics.getLabel('NoDataFound'));
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        headingRowColor:
            MaterialStateProperty.all(Colors.purpleAccent.shade100),
        headingTextStyle:
            const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        columns: [
          DataColumn(label: Text(Statics.getLabel('Vasti'))),
          DataColumn(label: Text(Statics.getLabel('Type'))),
          DataColumn(label: Text(Statics.getLabel('Shishu'))),
          DataColumn(label: Text(Statics.getLabel('Baal'))),
          DataColumn(
              label: Text(Statics.getLabel('MahaavidyaalayeenTarunLabel'))),
          DataColumn(label: Text(Statics.getLabel('TarunVyavasaayee'))),
          DataColumn(label: Text(Statics.getLabel('ProudhVyavasaayee'))),
          DataColumn(label: Text(Statics.getLabel('Total'))),
        ],
        rows: [
          for (int i = 0; i < dataList.length; i++) ...[
            // Use alternating colors for each 3-row group
            DataRow(
              color: MaterialStateProperty.all(
                  i.isEven ? Colors.grey.shade100 : Colors.grey.shade300),
              cells: [
                DataCell(Text(dataList[i].selectedLevelName ?? '')),
                DataCell(Text(Statics.getLabel('patSankhyaa'))),
                DataCell(Text('${dataList[i].shishupatSankhya ?? 0}')),
                DataCell(Text('${dataList[i].baalpatSankhya ?? 0}')),
                DataCell(Text('${dataList[i].mahaidyalayinpatSankhya ?? 0}')),
                DataCell(Text('${dataList[i].tarunpatSankhya ?? 0}')),
                DataCell(Text('${dataList[i].proudhpatSankhya ?? 0}')),
                DataCell(Text(
                  '${(dataList[i].shishupatSankhya ?? 0) + (dataList[i].baalpatSankhya ?? 0) + (dataList[i].mahaidyalayinpatSankhya ?? 0) + (dataList[i].tarunpatSankhya ?? 0) + (dataList[i].proudhpatSankhya ?? 0)}',
                )),
              ],
            ),
            DataRow(
              color: MaterialStateProperty.all(
                  i.isEven ? Colors.grey.shade100 : Colors.grey.shade300),
              cells: [
                const DataCell(Text('')),
                DataCell(Text(Statics.getLabel('ganveshatPresentCount'))),
                DataCell(Text('${dataList[i].shishuGanvesh ?? 0}')),
                DataCell(Text('${dataList[i].baalGanvesh ?? 0}')),
                DataCell(Text('${dataList[i].mahaidyalayinGanvesh ?? 0}')),
                DataCell(Text('${dataList[i].tarunGanvesh ?? 0}')),
                DataCell(Text('${dataList[i].proudhGanvesh ?? 0}')),
                DataCell(Text(
                  '${(dataList[i].shishuGanvesh ?? 0) + (dataList[i].baalGanvesh ?? 0) + (dataList[i].mahaidyalayinGanvesh ?? 0) + (dataList[i].tarunGanvesh ?? 0) + (dataList[i].proudhGanvesh ?? 0)}',
                )),
              ],
            ),
            DataRow(
              color: MaterialStateProperty.all(
                  i.isEven ? Colors.grey.shade100 : Colors.grey.shade300),
              cells: [
                const DataCell(Text('')),
                DataCell(
                    Text(Statics.getLabel('otherSwayamsewakPresentCount'))),
                DataCell(Text('${dataList[i].shishuAnyaUpastith ?? 0}')),
                DataCell(Text('${dataList[i].baalAnyaUpastith ?? 0}')),
                DataCell(Text('${dataList[i].mahaidyalayinAnyaUpastith ?? 0}')),
                DataCell(Text('${dataList[i].tarunAnyaUpastith ?? 0}')),
                DataCell(Text('${dataList[i].proudhAnyaUpastith ?? 0}')),
                DataCell(Text(
                  '${(dataList[i].shishuAnyaUpastith ?? 0) + (dataList[i].baalAnyaUpastith ?? 0) + (dataList[i].mahaidyalayinAnyaUpastith ?? 0) + (dataList[i].tarunAnyaUpastith ?? 0) + (dataList[i].proudhAnyaUpastith ?? 0)}',
                )),
              ],
            ),
          ]
        ],
      ),
    );
  }

// ================================ END  Swayamsewak POPUP ==================================================================

  Widget textControllerField2(
      {required String name,
      required TextEditingController controller,
      double height = 50.0,
      TextInputType keyboardType = TextInputType.text,
      bool isEdit = false,
      String? hintTextString,
      String? imp,
      int? maxInput}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: name,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              TextSpan(
                text: imp,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 5),
        Container(
          height: height,
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            inputFormatters: keyboardType == TextInputType.number
                ? [FilteringTextInputFormatter.allow(RegExp(r'^[0-9]*$'))]
                : [],
            decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              filled: true,
              fillColor: Colors.white,
              hintText: hintTextString,
            ),
            // readOnly: isVastiSearch == false ? true : isEdit,
            onTap: () {
              // if (isVastiSearch) {
              // print("Nothing");
              // } else {
              //   showPopupForVastiValidation(context);
              // }
            },
            maxLength: maxInput,
            buildCounter: (context,
                    {int? currentLength, int? maxLength, bool? isFocused}) =>
                null,
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }

  Widget mainContainer(String header, Widget child) {
    Size size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.symmetric(vertical: size.height * 0.01),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            header,
            style: TextStyle(
              color: Colors.purpleAccent,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          Divider(color: Colors.black87, thickness: 1),
          SizedBox(
            height: 10,
          ),
          child,
        ],
      ),
    );
  }

  Widget yesNoRadioButton({
    required String question,
    required Function(int) onChanged,
    required int selectedOption,
    int? questionNumber,
    String? imp,
    bool isDisable = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text:
                    "${questionNumber != null ? "$questionNumber. " : ""}$question",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              TextSpan(
                text: imp,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
        Row(
          children: [
            Radio<int>(
              value: 1,
              groupValue: selectedOption,
              onChanged: isDisable
                  ? null
                  : (value) {
                      if (value != null) onChanged(value);
                    },
              activeColor: Colors.purpleAccent,
            ),
            Text(
              "${Statics.getLabel('ConfirmationYes')}",
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(width: 20),
            Radio<int>(
              value: 0,
              groupValue: selectedOption,
              onChanged: isDisable
                  ? null
                  : (value) {
                      if (value != null) onChanged(value);
                    },
              activeColor: Colors.purpleAccent,
            ),
            Text(
              "${Statics.getLabel('ConfirmationNo')}",
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> submitForm() async {
    Map<String, dynamic> formData = {
      "vastiid": int.parse(selctedLevelId!),
      "cuserid": int.parse(Statics.userDetails['userID']),
      "programNirdharitVed": programNirdharitVed,
      "vaiyaktikGitKantashtha": vaiyaktikGitKantashtha,
      "programHishobh24Hour": programHishobh24Hour,
      "maleCount": maleController.text,
      "femaleCount": femaleController.text,
      "sanchalanZaleKa": sanchalanZaleKa,
      "sanchalanZaleKaEntries": savedsanchalanZaleKaEntries,
      "patGanAnyaEntries": savedPatGanAnyaEntries,
      "presentMatrushakti": presentMatrushaktiController.text,
      "presentMale": presentMaleController.text,
    };
    String formattedJson = const JsonEncoder.withIndent('  ').convert(formData);
    log("Form Data (JSON):\n$formattedJson");
  }
}

//====================================================================================================================================
