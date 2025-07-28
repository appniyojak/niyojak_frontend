import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:niyojak_prod/widgets/app_drawer.dart';

import '../../../helpers/static_data.dart' as Statics;
import '../../../models/response_model/get_vasti_data_by_id_model.dart';
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
                        if (_linkedNagar != null && _linkedNagar!.length > 0)
                          SizedBox(
                            height: 10,
                          ),
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
                        if (_linkedmandal != null && _linkedmandal!.length > 0)
                          SizedBox(
                            height: 10,
                          ),
                        if (_linkedgraam != null && _linkedgraam!.length > 0)
                          DropdownButtonFormField(
                            decoration: InputDecoration(
                                labelText: Statics.getLabel('Graam')),
                            isExpanded: true,
                            value: _linkedgraamValue == ""
                                ? null
                                : _linkedgraamValue,
                            items: _linkedgraam!
                                .map((bg) => DropdownMenuItem(
                                    value: bg.geoUnitID.toString(),
                                    child: Text(bg.name!)))
                                .toList(),
                            onChanged: (value) {
                              final selectedItem = _linkedgraam!.firstWhere(
                                  (bg) => bg.geoUnitID.toString() == value);
                              setState(() {
                                _linkedgraamValue = value;
                                selctedLevelName = selectedItem.name ?? "";
                                selctedLevel = 'Graam';
                                selctedLevelId = value;
                              });
                            },
                          ),
                        if (_linkedvasti != null && _linkedvasti!.length > 0)
                          DropdownButtonFormField(
                            decoration: InputDecoration(
                                labelText: Statics.getLabel('Vasti')),
                            isExpanded: true,
                            value: _linkedvastiValue == ""
                                ? null
                                : _linkedvastiValue,
                            items: _linkedvasti!
                                .map((bg) => DropdownMenuItem(
                                    value: bg.geoUnitID.toString(),
                                    child: Text(bg.name!)))
                                .toList(),
                            onChanged: (value) {
                              final selectedItem = _linkedvasti!.firstWhere(
                                  (bg) => bg.geoUnitID.toString() == value);
                              setState(() {
                                _linkedvastiValue = value;
                                selctedLevelName = selectedItem.name ?? "";
                                selctedLevel = 'Vasti';
                                selctedLevelId = value;
                              });
                            },
                          ),
                        SizedBox(
                          height: 15,
                        ),
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
                            showsanchalanZaleKaPopup(context,
                                onDataChanged: () {
                              setState(() {});
                            });
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
                  if (sanchalanZaleKa == 1) SizedBox(height: 20),
                  if (sanchalanZaleKa == 1)
                    Column(
                      children: [
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black54),
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: DataTable(
                                  columnSpacing: 20,
                                  showCheckboxColumn: false,
                                  headingRowColor: MaterialStatePropertyAll(
                                      Colors.purple.shade50),
                                  headingTextStyle: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87),
                                  columns: [
                                    DataColumn(
                                        label: Text(
                                            "${Statics.getLabel('serialNo')}")),
                                    DataColumn(
                                        label: Text(
                                      "${Statics.getLabel('Name')}",
                                    )),
                                  ],
                                  rows: sanchalanZaleKaDataList
                                      .asMap()
                                      .entries
                                      .where(
                                          (entry) => entry.value.isactive == 1)
                                      .map((entry) {
                                    int index = entry.key;
                                    var data = entry.value;
                                    bool isSelected =
                                        selectedsanchalanZaleKaIdIndex == index;
                                    return DataRow(
                                        selected: isSelected,
                                        color: MaterialStateProperty
                                            .resolveWith<Color?>(
                                          (Set<MaterialState> states) {
                                            if (isSelected)
                                              return Colors.yellow.shade100;
                                            return null;
                                          },
                                        ),
                                        onSelectChanged: (bool? selected) {
                                          if (selected != null && selected) {
                                            setState(() {
                                              selectedsanchalanZaleKaIdIndex =
                                                  index;
                                            });
                                          }
                                        },
                                        cells: [
                                          DataCell(Text("${index + 1}")),
                                          DataCell(Text(data.name ?? '')),
                                        ]);
                                  }).toList(),
                                ),
                              )),
                        ),
                        SizedBox(height: 10),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 6,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              InkWell(
                                onTap: () {
                                  if (selectedsanchalanZaleKaIdIndex != null) {
                                    var selectedData = sanchalanZaleKaDataList[
                                        selectedsanchalanZaleKaIdIndex!];
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          backgroundColor: Colors.white,
                                          title: Center(
                                            child: Text(
                                              "${Statics.getLabel('HinduVeer')}",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20,
                                                color: Colors.purpleAccent,
                                              ),
                                            ),
                                          ),
                                          content: SingleChildScrollView(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Divider(
                                                    thickness: 1,
                                                    color: Colors
                                                        .deepPurple.shade100),
                                                SizedBox(height: 12),
                                                _buildInfoRow(
                                                    "${Statics.getLabel('Name')}",
                                                    selectedData.name),
                                              ],
                                            ),
                                          ),
                                          actionsAlignment:
                                              MainAxisAlignment.center,
                                          actions: [
                                            ElevatedButton(
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: Text(
                                                  "${Statics.getLabel('bandKara')}",
                                                  style: TextStyle(
                                                      color: Colors.white)),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    Colors.purpleAccent,
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 24,
                                                    vertical: 12),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  }
                                },
                                child: Icon(Icons.remove_red_eye,
                                    color: Colors.green, size: 20),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              InkWell(
                                onTap: () {
                                  showsanchalanZaleKaPopup(context,
                                      editIndex: selectedsanchalanZaleKaIdIndex,
                                      onDataChanged: () {
                                    setState(() {});
                                  });
                                },
                                child: Icon(Icons.edit,
                                    color: Colors.blue, size: 20),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              InkWell(
                                onTap: () async {
                                  final shouldDelete = await showDialog<bool>(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      backgroundColor: Colors.white,
                                      title: Center(
                                        child: Text(
                                          "${Statics.getLabel('pusthikarn')}",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                            color: Colors.redAccent,
                                          ),
                                        ),
                                      ),
                                      content: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10.0),
                                        child: Text(
                                          "${Statics.getLabel('deleteconfirmText')}",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ),
                                      actionsAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      actions: [
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                Colors.grey.shade300,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                          ),
                                          onPressed: () =>
                                              Navigator.pop(context, false),
                                          child: Text(
                                            "${Statics.getLabel('ConfirmationNo')}",
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                        ),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.redAccent,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                          ),
                                          onPressed: () =>
                                              Navigator.pop(context, true),
                                          child: Text(
                                            "${Statics.getLabel('ConfirmationYes')}",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                  if (shouldDelete == true &&
                                      selectedsanchalanZaleKaIdIndex != null) {
                                    setState(() {
                                      sanchalanZaleKaDataList[
                                              selectedsanchalanZaleKaIdIndex!]
                                          .isactive = 0;
                                      selectedsanchalanZaleKaIdIndex = null;
                                    });
                                  }
                                },
                                child: Icon(Icons.delete,
                                    color: Colors.red, size: 20),
                              ),
                            ],
                          ),
                        ),
//============================================================================================================================================================
                      ],
                    ),
                ],
              ),
            ),
// ================================== 5 QUESTIONS Box ==================================================================================================================================================================================================================================================================================================================================================
            mainContainer(
              "${Statics.getLabel('searchSwayamsevakScreenLabel')}",
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          showswayamsewakPopup(context, onDataChanged: () {
                            setState(() {});
                          });
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
                  Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black54),
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: DataTable(
                                columnSpacing: 20,
                                showCheckboxColumn: false,
                                headingRowColor: MaterialStatePropertyAll(
                                    Colors.purple.shade50),
                                headingTextStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87),
                                columns: [
                                  DataColumn(
                                      label: Text(
                                          "${Statics.getLabel('serialNo')}")),
                                  DataColumn(
                                      label: Text(
                                    "${Statics.getLabel('Name')}",
                                  )),
                                ],
                                rows: sanchalanZaleKaDataList
                                    .asMap()
                                    .entries
                                    .where((entry) => entry.value.isactive == 1)
                                    .map((entry) {
                                  int index = entry.key;
                                  var data = entry.value;
                                  bool isSelected =
                                      selectedsanchalanZaleKaIdIndex == index;
                                  return DataRow(
                                      selected: isSelected,
                                      color: MaterialStateProperty.resolveWith<
                                          Color?>(
                                        (Set<MaterialState> states) {
                                          if (isSelected)
                                            return Colors.yellow.shade100;
                                          return null;
                                        },
                                      ),
                                      onSelectChanged: (bool? selected) {
                                        if (selected != null && selected) {
                                          setState(() {
                                            selectedsanchalanZaleKaIdIndex =
                                                index;
                                          });
                                        }
                                      },
                                      cells: [
                                        DataCell(Text("${index + 1}")),
                                        DataCell(Text(data.name ?? '')),
                                      ]);
                                }).toList(),
                              ),
                            )),
                      ),
                      SizedBox(height: 10),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 6,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () {
                                if (selectedsanchalanZaleKaIdIndex != null) {
                                  var selectedData = sanchalanZaleKaDataList[
                                      selectedsanchalanZaleKaIdIndex!];
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        backgroundColor: Colors.white,
                                        title: Center(
                                          child: Text(
                                            "${Statics.getLabel('HinduVeer')}",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                              color: Colors.purpleAccent,
                                            ),
                                          ),
                                        ),
                                        content: SingleChildScrollView(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Divider(
                                                  thickness: 1,
                                                  color: Colors
                                                      .deepPurple.shade100),
                                              SizedBox(height: 12),
                                              _buildInfoRow(
                                                  "${Statics.getLabel('Name')}",
                                                  selectedData.name),
                                            ],
                                          ),
                                        ),
                                        actionsAlignment:
                                            MainAxisAlignment.center,
                                        actions: [
                                          ElevatedButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child: Text(
                                                "${Statics.getLabel('bandKara')}",
                                                style: TextStyle(
                                                    color: Colors.white)),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  Colors.purpleAccent,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 24, vertical: 12),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }
                              },
                              child: Icon(Icons.remove_red_eye,
                                  color: Colors.green, size: 20),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            InkWell(
                              onTap: () {
                                showswayamsewakPopup(context,
                                    editIndex: selectedsanchalanZaleKaIdIndex,
                                    onDataChanged: () {
                                  setState(() {});
                                });
                              },
                              child: Icon(Icons.edit,
                                  color: Colors.blue, size: 20),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            InkWell(
                              onTap: () async {
                                final shouldDelete = await showDialog<bool>(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    backgroundColor: Colors.white,
                                    title: Center(
                                      child: Text(
                                        "${Statics.getLabel('pusthikarn')}",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                          color: Colors.redAccent,
                                        ),
                                      ),
                                    ),
                                    content: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10.0),
                                      child: Text(
                                        "${Statics.getLabel('deleteconfirmText')}",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ),
                                    actionsAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    actions: [
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.grey.shade300,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                        ),
                                        onPressed: () =>
                                            Navigator.pop(context, false),
                                        child: Text(
                                          "${Statics.getLabel('ConfirmationNo')}",
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.redAccent,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                        ),
                                        onPressed: () =>
                                            Navigator.pop(context, true),
                                        child: Text(
                                          "${Statics.getLabel('ConfirmationYes')}",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                                if (shouldDelete == true &&
                                    selectedsanchalanZaleKaIdIndex != null) {
                                  setState(() {
                                    sanchalanZaleKaDataList[
                                            selectedsanchalanZaleKaIdIndex!]
                                        .isactive = 0;
                                    selectedsanchalanZaleKaIdIndex = null;
                                  });
                                }
                              },
                              child: Icon(Icons.delete,
                                  color: Colors.red, size: 20),
                            ),
                          ],
                        ),
                      ),
//============================================================================================================================================================
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

// ================================  SANCHALAN POPUP ==================================================================
  List<VastisarHinduvirayadi> sanchalanZaleKaDataList = [];
  int? selectedsanchalanZaleKaIdIndex;
  void showsanchalanZaleKaPopup(
    BuildContext context, {
    int? editIndex,
    VoidCallback? onDataChanged,
  }) {
    if (editIndex != null) {
      var data = sanchalanZaleKaDataList[editIndex];
      selectedsanchalanZaleKaIdIndex = data.id;
    }
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${Statics.getLabel('sanchalan')}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.purpleAccent,
                ),
              ),
              IconButton(
                icon: Icon(Icons.close, color: Colors.grey),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          ),
          content: StatefulBuilder(
            builder: (context, setState) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    yesNoRadioButton(
                      question: "${Statics.getLabel('sanchalanSadandaZalKa')}",
                      selectedOption: sanchalanSadandaZalKa ?? 2,
                      onChanged: (value) {
                        setState(() {
                          sanchalanSadandaZalKa = value;
                        });
                      },
                    ),
                    yesNoRadioButton(
                      question:
                          "${Statics.getLabel('sanchalanGhoshVadanZalKa')}",
                      selectedOption: sanchalanGhoshVadanZalKa ?? 2,
                      onChanged: (value) {
                        setState(() {
                          sanchalanGhoshVadanZalKa = value;
                        });
                      },
                    ),
                    if (_linkedgraam != null && _linkedgraam!.length > 0)
                      DropdownButtonFormField(
                        decoration: InputDecoration(
                            labelText: Statics.getLabel('Graam')),
                        isExpanded: true,
                        value:
                            _linkedgraamValue == "" ? null : _linkedgraamValue,
                        items: _linkedgraam!
                            .map((bg) => DropdownMenuItem(
                                value: bg.geoUnitID.toString(),
                                child: Text(bg.name!)))
                            .toList(),
                        onChanged: (value) {
                          final selectedItem = _linkedVibhaag!.firstWhere(
                              (bg) => bg.geoUnitID.toString() == value);
                          setState(() {
                            selctedSanchalanLevelName = selectedItem.name ?? "";
                            selctedSanchalanLevelId = value ?? "";
                          });
                        },
                      ),
                    if (_linkedvasti != null && _linkedvasti!.length > 0)
                      DropdownButtonFormField(
                        decoration: InputDecoration(
                            labelText: Statics.getLabel('Vasti')),
                        isExpanded: true,
                        value:
                            _linkedvastiValue == "" ? null : _linkedvastiValue,
                        items: _linkedvasti!
                            .map((bg) => DropdownMenuItem(
                                value: bg.geoUnitID.toString(),
                                child: Text(bg.name!)))
                            .toList(),
                        onChanged: (value) {
                          final selectedItem = _linkedVibhaag!.firstWhere(
                              (bg) => bg.geoUnitID.toString() == value);
                          setState(() {
                            selctedSanchalanLevelName = selectedItem.name ?? "";
                            selctedSanchalanLevelId = value ?? "";
                          });
                        },
                      ),
                  ],
                ),
              );
            },
          ),
          actions: [
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  VastisarHinduvirayadi data = VastisarHinduvirayadi(
                    vastiid: int.parse(selctedLevelId!),
                    id: selectedsanchalanZaleKaIdIndex,
                  );

                  if (editIndex != null) {
                    sanchalanZaleKaDataList[editIndex] = data;
                  } else {
                    sanchalanZaleKaDataList.add(data);
                  }

                  if (onDataChanged != null) {
                    onDataChanged();
                  }

                  Navigator.of(ctx).pop();
                },
                child: Text("${Statics.getLabel('Submit')}",
                    style: TextStyle(color: Colors.white)),
              ),
            )
          ],
        );
      },
    );
  }

// ================================  Swayamsewak POPUP ==================================================================
  List<VastisarHinduvirayadi> swayamsewakDataList = [];
  int? selectedswayamsewakIdIndex;
  TextEditingController swayamsewakShishuCountController =
      TextEditingController();
  void showswayamsewakPopup(
    BuildContext context, {
    int? editIndex,
    VoidCallback? onDataChanged,
  }) {
    if (editIndex != null) {
      var data = swayamsewakDataList[editIndex];
      selectedswayamsewakIdIndex = data.id;
    }
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${Statics.getLabel('searchSwayamsevakScreenLabel')}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.purpleAccent,
                ),
              ),
              IconButton(
                icon: Icon(Icons.close, color: Colors.grey),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          ),
          content: StatefulBuilder(
            builder: (context, setState) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "${Statics.getLabel('patSankhyaa')}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Divider(color: Colors.black),
                    textControllerField2(
                      name: "${Statics.getLabel('Shishu')}",
                      controller: swayamsewakShishuCountController,
                      keyboardType: TextInputType.number,
                    ),
                    textControllerField2(
                      name: "${Statics.getLabel('Baal')}",
                      controller: swayamsewakShishuCountController,
                      keyboardType: TextInputType.number,
                    ),
                    textControllerField2(
                      name:
                          "${Statics.getLabel('MahaavidyaalayeenTarunLabel')}",
                      controller: swayamsewakShishuCountController,
                      keyboardType: TextInputType.number,
                    ),
                    textControllerField2(
                      name: "${Statics.getLabel('TarunVyavasaayee')}",
                      controller: swayamsewakShishuCountController,
                      keyboardType: TextInputType.number,
                    ),
                    textControllerField2(
                      name: "${Statics.getLabel('ProudhVyavasaayee')}",
                      controller: swayamsewakShishuCountController,
                      keyboardType: TextInputType.number,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "${Statics.getLabel('ganveshatPresentCount')}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Divider(color: Colors.black),
                    textControllerField2(
                      name: "${Statics.getLabel('Shishu')}",
                      controller: swayamsewakShishuCountController,
                      keyboardType: TextInputType.number,
                    ),
                    textControllerField2(
                      name: "${Statics.getLabel('Baal')}",
                      controller: swayamsewakShishuCountController,
                      keyboardType: TextInputType.number,
                    ),
                    textControllerField2(
                      name:
                          "${Statics.getLabel('MahaavidyaalayeenTarunLabel')}",
                      controller: swayamsewakShishuCountController,
                      keyboardType: TextInputType.number,
                    ),
                    textControllerField2(
                      name: "${Statics.getLabel('TarunVyavasaayee')}",
                      controller: swayamsewakShishuCountController,
                      keyboardType: TextInputType.number,
                    ),
                    textControllerField2(
                      name: "${Statics.getLabel('ProudhVyavasaayee')}",
                      controller: swayamsewakShishuCountController,
                      keyboardType: TextInputType.number,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "${Statics.getLabel('otherSwayamsewakPresentCount')}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Divider(color: Colors.black),
                    textControllerField2(
                      name: "${Statics.getLabel('Shishu')}",
                      controller: swayamsewakShishuCountController,
                      keyboardType: TextInputType.number,
                    ),
                    textControllerField2(
                      name: "${Statics.getLabel('Baal')}",
                      controller: swayamsewakShishuCountController,
                      keyboardType: TextInputType.number,
                    ),
                    textControllerField2(
                      name:
                          "${Statics.getLabel('MahaavidyaalayeenTarunLabel')}",
                      controller: swayamsewakShishuCountController,
                      keyboardType: TextInputType.number,
                    ),
                    textControllerField2(
                      name: "${Statics.getLabel('TarunVyavasaayee')}",
                      controller: swayamsewakShishuCountController,
                      keyboardType: TextInputType.number,
                    ),
                    textControllerField2(
                      name: "${Statics.getLabel('ProudhVyavasaayee')}",
                      controller: swayamsewakShishuCountController,
                      keyboardType: TextInputType.number,
                    ),
                  ],
                ),
              );
            },
          ),
          actions: [
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  VastisarHinduvirayadi data = VastisarHinduvirayadi(
                    vastiid: int.parse(selctedLevelId!),
                    id: selectedswayamsewakIdIndex,
                  );

                  if (editIndex != null) {
                    swayamsewakDataList[editIndex] = data;
                  } else {
                    swayamsewakDataList.add(data);
                  }

                  if (onDataChanged != null) {
                    onDataChanged();
                  }

                  Navigator.of(ctx).pop();
                },
                child: Text("${Statics.getLabel('Submit')}",
                    style: TextStyle(color: Colors.white)),
              ),
            )
          ],
        );
      },
    );
  }

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

  Widget _buildInfoRow(String title, String? value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          "$title : ",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: Colors.purpleAccent,
          ),
        ),
        Expanded(
          child: Text(
            value ?? "—",
            style: TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }
}
