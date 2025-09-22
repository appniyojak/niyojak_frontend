import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';

import '../../../../helpers/static_data.dart' as Statics;
import '../../../models/response_model/get_vasti_data_by_id_model.dart';
import '../../../models/response_model/vasti_sarvekshan_dropdown_model.dart';
import '../../../models/response_model/vasti_up_data_model.dart';
import '../../../providers/bals.dart';

class AddVishisthaAtithi extends StatefulWidget {
  static const String routeName = '/add-vishishtha-atithi';

  const AddVishisthaAtithi({Key? key}) : super(key: key);

  @override
  State<AddVishisthaAtithi> createState() => _AddVishisthaAtithiState();
}

class _AddVishisthaAtithiState extends State<AddVishisthaAtithi> {
  int? isVastiOrGraam;
  List<Vastisarsajjanshakti> sajjanShaktiDataList = [];
  int? selectedsajjanShaktiRowIndex;

  // All your variables here
  int? sajjanShaktiShreniId;
  String? sajjanShaktiShreniName;
  int? sajjanShaktiShreniEditId;
  Masterdata? sajjanShaktiShreniEditDataId;

  int? sajjanShaktiSamparkStithiId;
  String? sajjanShaktiSamparkStithiName;
  int? sajjanShaktiSamparkStithiEditId;
  Masterdata? sajjanShaktiSamparkStithiEditDataId;

  int? sajjanShaktiPrabhavKeshtraId;
  String? sajjanShaktiPrabhavKeshtraName;
  int? sajjanShaktiPrabhavKeshtraEditId;
  Masterdata? sajjanShaktiPrabhavKeshtraEditDataId;

  int? sajjanShaktiVisheshId;
  String? sajjanShaktiVisheshName;
  int? sajjanShaktiVisheshEditId;
  Masterdata? sajjanShaktiVisheshEditDataId;

  TextEditingController sajjanShaktiNameController = TextEditingController();
  TextEditingController sajjanShaktiAddressController = TextEditingController();
  TextEditingController sajjanShaktiPhoneController = TextEditingController();
  TextEditingController sajjanShaktiContactPersonNameController = TextEditingController();
  TextEditingController sajjanShaktiContactPersonDoorbhashController = TextEditingController();
  TextEditingController sajjanShaktiSansthecheNaavController = TextEditingController();
  TextEditingController sajjanShaktiSansthKuthalyaPadavarController = TextEditingController();
  TextEditingController sajjanShaktiAnyaShreniNameController = TextEditingController();
  TextEditingController sajjanShaktiAnyaVisheshNameController = TextEditingController();

  VastisarvekshanDropDownDataModel? vastisarvekshanDropDownDataModel;

  @override
  void initState() {
    super.initState();
    fetchVastiSurveyDropdownData();
  }

  List<Upnagarmandallist> vastimandallist = [];
  Upnagarmandallist? vastimandalData;

  String? selctedLevel = 'Nagar';
  String? selctedLevelName = '';
  String? selctedLevelId = '';
  String? _linkedNagarValue = '';
  String? _linkedgraamValue = "";
  String? _linkedmandalValue = "";
  String? _linkedvastiValue = "";
  List<GeoUnitMasterBAL>? _linkedNagar;
  List<GeoUnitMasterBAL>? _linkedmandal;
  List<GeoUnitMasterBAL>? _linkedgraam;
  List<GeoUnitMasterBAL>? _linkedvasti;

  Future<List<GeoUnitMasterBAL>> populatelinkedMandalDropdown(String nagarIDStr) async {
    _linkedgraamValue = null;
    _linkedmandal = _linkedgraam = null;
    var mnDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['MandalLevelID'].toString(), nagarIDStr, 'Nagar', '');
    setState(() {
      _linkedmandal = (mnDD.length > 0 ? mnDD : null);
    });
    return mnDD;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedGraamDropdown(String mandalIDStr) async {
    _linkedgraamValue = null;
    var gmDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['GraamLevelID'].toString(), mandalIDStr, 'Mandal', '');
    setState(() {
      _linkedgraam = (gmDD.length > 0 ? gmDD : null);
    });
    return gmDD;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedVastiDropdown(String nagarIDStr) async {
    _linkedvastiValue = null;
    var vsDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['VastiLevelID'].toString(), nagarIDStr, 'Nagar', '');
    setState(() {
      _linkedvasti = (vsDD.length > 0 ? vsDD : null);
    });
    return vsDD;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // 👇 Receive the arguments properly
    final args = ModalRoute.of(context)!.settings.arguments as List<GeoUnitMasterBAL>?;

    if (args != null && args.isNotEmpty) {
      setState(() {
        _linkedNagar = args;
      });
    }
  }

  Future<void> fetchVastiSurveyDropdownData() async {
    try {
      vastisarvekshanDropDownDataModel = await Statics.getVastiSurveyDropDownList(Statics.userDetails["userID"]);
      setState(() {});
    } catch (e) {
      print('Error fetching notification data: $e');
    }
  }

  int? sajjanShaktiType;
  List<int> selectedTypes = [];
  List<VastisarAnyaprabhavilokam> anyaPrabhaviLokDataList = [];
  int? selectedanyaPrabhaviLokRowIndex;
  int? anyaPrabhaviLokSamparkStithiId;
  String? anyaPrabhaviLokSamparkStithiName;
  int? selectedAnyaPrabhaviLokSamparkStithiIDEdit;
  Masterdata? selectedAnyaPrabhaviLokSamparkStithi;
  int? isActiveAnyaPrabhavilok = 1;
  int? pkidAnyaPrabhaviLok = 0;
  int? isFemale = 0;
  int? anyaPrabhaviLokShreniId;
  int? anyaPrabhaviLokShreniIdEdit;
  String? anyaPrabhaviLokShreniName;
  int? anyaPrabhaviLokUpShreniId;
  int? anyaPrabhaviLokUpShreniIdEdit;
  String? anyaPrabhaviLokUpShreniName;
  int? anyaPrabhaviLokUpShreni1Id;
  int? anyaPrabhaviLokUpShreni1IdEdit;
  String? anyaPrabhaviLokUpShreni1Name;
  Masterdata? selectedShreni;
  Masterdata? selectedUpShreni;
  Masterdata? selectedUpShreni2;
  int? anyaPrabhaviLokVisheshId;
  String? anyaPrabhaviLokVisheshName;
  int? selectedAnyaPrabhaviLokVisheshIDEdit;
  Masterdata? selectedAnyaPrabhaviLokVishesh;
  int? anyaPrabhaviLokPrabhavKshetraId;
  String? anyaPrabhaviLokPrabhavKshetraName;
  int? selectedAnyaPrabhaviLokPrabhavKshetraIDEdit;
  Masterdata? selectedAnyaPrabhaviLokPrabhavKshetra;
  final TextEditingController anyaPrabhaviLokNaavController = TextEditingController();
  final TextEditingController anyaPrabhaviLokAddressController = TextEditingController();
  final TextEditingController anyaPrabhaviLokAnyaVisheshMahitiController = TextEditingController();
  final TextEditingController anyaPrabhaviLokSamparkSutraNaavController = TextEditingController();
  final TextEditingController anyaPrabhaviLokSamparkSutraDoorbhashController = TextEditingController();
  final TextEditingController anyaPrabhaviLokMobileNoController = TextEditingController();
  final TextEditingController anyaPrabhaviLokAnyaUppshreniController = TextEditingController();
  final TextEditingController anyaPrabhaviLokAnyaUppshreni1Controller = TextEditingController();

  void resetSajjanShaktiAndAnyaPrabhaviLokData() {
    // Sajjan Shakti list
    sajjanShaktiDataList.clear();

    // Sajjan Shakti IDs and names reset
    sajjanShaktiShreniId = null;
    sajjanShaktiShreniName = null;
    sajjanShaktiShreniEditId = null;
    sajjanShaktiShreniEditDataId = null;

    sajjanShaktiSamparkStithiId = null;
    sajjanShaktiSamparkStithiName = null;
    sajjanShaktiSamparkStithiEditId = null;
    sajjanShaktiSamparkStithiEditDataId = null;

    sajjanShaktiPrabhavKeshtraId = null;
    sajjanShaktiPrabhavKeshtraName = null;
    sajjanShaktiPrabhavKeshtraEditId = null;
    sajjanShaktiPrabhavKeshtraEditDataId = null;

    sajjanShaktiVisheshId = null;
    sajjanShaktiVisheshName = null;
    sajjanShaktiVisheshEditId = null;
    sajjanShaktiVisheshEditDataId = null;

    // Sajjan Shakti controllers reset
    sajjanShaktiNameController.clear();
    sajjanShaktiAddressController.clear();
    sajjanShaktiPhoneController.clear();
    sajjanShaktiContactPersonNameController.clear();
    sajjanShaktiContactPersonDoorbhashController.clear();
    sajjanShaktiSansthecheNaavController.clear();
    sajjanShaktiSansthKuthalyaPadavarController.clear();
    sajjanShaktiAnyaShreniNameController.clear();
    sajjanShaktiAnyaVisheshNameController.clear();

    // Sajjan Shakti type
    sajjanShaktiType = null;

    // Anya Prabhavi Lok
    anyaPrabhaviLokDataList.clear();
    selectedanyaPrabhaviLokRowIndex = null;
    anyaPrabhaviLokSamparkStithiId = null;
    anyaPrabhaviLokSamparkStithiName = null;
    selectedAnyaPrabhaviLokSamparkStithiIDEdit = null;
    selectedAnyaPrabhaviLokSamparkStithi = null;

    isActiveAnyaPrabhavilok = 1;
    pkidAnyaPrabhaviLok = 0;

    anyaPrabhaviLokShreniId = null;
    anyaPrabhaviLokShreniIdEdit = null;
    anyaPrabhaviLokShreniName = null;

    anyaPrabhaviLokUpShreniId = null;
    anyaPrabhaviLokUpShreniIdEdit = null;
    anyaPrabhaviLokUpShreniName = null;

    anyaPrabhaviLokUpShreni1Id = null;
    anyaPrabhaviLokUpShreni1IdEdit = null;
    anyaPrabhaviLokUpShreni1Name = null;

    selectedShreni = null;
    selectedUpShreni = null;
    selectedUpShreni2 = null;

    anyaPrabhaviLokVisheshId = null;
    anyaPrabhaviLokVisheshName = null;
    selectedAnyaPrabhaviLokVisheshIDEdit = null;
    selectedAnyaPrabhaviLokVishesh = null;

    anyaPrabhaviLokPrabhavKshetraId = null;
    anyaPrabhaviLokPrabhavKshetraName = null;
    selectedAnyaPrabhaviLokPrabhavKshetraIDEdit = null;
    selectedAnyaPrabhaviLokPrabhavKshetra = null;

    // Controllers reset
    anyaPrabhaviLokNaavController.clear();
    anyaPrabhaviLokAddressController.clear();
    anyaPrabhaviLokAnyaVisheshMahitiController.clear();
    anyaPrabhaviLokSamparkSutraNaavController.clear();
    anyaPrabhaviLokSamparkSutraDoorbhashController.clear();
    anyaPrabhaviLokMobileNoController.clear();
    anyaPrabhaviLokAnyaUppshreniController.clear();
    anyaPrabhaviLokAnyaUppshreni1Controller.clear();

    // Dropdown data reset
    vastisarvekshanDropDownDataModel = null;
    fetchVastiSurveyDropdownData();
  }

  Future<void> submitForm() async {
    Map<String, dynamic> formData = {
      "GeoUnitID": int.parse(selctedLevelId!),
      "AppUserID": int.parse(Statics.userDetails['userID']),
      "isnagar": isVastiOrGraam,
      "Vastisarsajjanshakti": sajjanShaktiDataList,
      "VastisarAnyaprabhavilokam": anyaPrabhaviLokDataList,
    };

    String formattedJson = const JsonEncoder.withIndent('  ').convert(formData);
    log("Form Data (JSON):\n$formattedJson");
    final _result = await Statics.saveVishishthaAtithiData(context, formData);
    resetSajjanShaktiAndAnyaPrabhaviLokData();
    setState(() {});
    if (_result) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(Statics.getLabel('addVIshishthaAtithi'), style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)), border: Border.all(color: Colors.purpleAccent)),
                child: Column(children: [
                  Text(
                    "${Statics.getLabel('selectedBhougolikkaryastithi')}",
                    style: TextStyle(color: Colors.purpleAccent, fontWeight: FontWeight.w600, fontSize: 20),
                  ),
                  Divider(
                    color: Colors.grey,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  if (_linkedNagar != null && _linkedNagar!.length > 0)
                    DropdownButtonFormField(
                      decoration: InputDecoration(labelText: Statics.getLabel('Nagar')),
                      isExpanded: true,
                      value: _linkedNagarValue == "" ? null : _linkedNagarValue,
                      items: _linkedNagar!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                      onChanged: (value) {
                        final selectedItem = _linkedNagar!.firstWhere((bg) => bg.geoUnitID.toString() == value);
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
                      decoration: InputDecoration(labelText: Statics.getLabel('Mandal')),
                      isExpanded: true,
                      value: _linkedmandalValue == "" ? null : _linkedmandalValue,
                      items: _linkedmandal!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                      onChanged: (value) {
                        final selectedItem = _linkedmandal!.firstWhere((bg) => bg.geoUnitID.toString() == value);
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
                      decoration: InputDecoration(labelText: Statics.getLabel('Graam')),
                      isExpanded: true,
                      value: _linkedgraamValue == "" ? null : _linkedgraamValue,
                      items: _linkedgraam!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                      onChanged: (value) {
                        final selectedItem = _linkedgraam!.firstWhere((bg) => bg.geoUnitID.toString() == value);
                        setState(() {
                          _linkedgraamValue = value;
                          selctedLevelName = selectedItem.name ?? "";
                          selctedLevel = 'Graam';
                          selctedLevelId = value;
                          isVastiOrGraam = 0;
                        });
                      },
                    ),
                  if (_linkedvasti != null && _linkedvasti!.length > 0)
                    DropdownButtonFormField(
                      decoration: InputDecoration(labelText: Statics.getLabel('Vasti')),
                      isExpanded: true,
                      value: _linkedvastiValue == "" ? null : _linkedvastiValue,
                      items: _linkedvasti!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                      onChanged: (value) {
                        final selectedItem = _linkedvasti!.firstWhere((bg) => bg.geoUnitID.toString() == value);
                        setState(() {
                          _linkedvastiValue = value;
                          selctedLevelName = selectedItem.name ?? "";
                          selctedLevel = 'Vasti';
                          selctedLevelId = value;
                          isVastiOrGraam = 1;
                        });
                      },
                    ),
                  SizedBox(
                    height: 15,
                  ),
                  if (selctedLevel == 'Vasti')
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Sajjan Shakti Button
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                if (selectedTypes.contains(1)) {
                                  selectedTypes.remove(1);
                                } else {
                                  selectedTypes.add(1);
                                }
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: selectedTypes.contains(1) ? Colors.purpleAccent : Colors.transparent,
                                border: Border.all(color: Colors.purpleAccent),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text(
                                  "${Statics.getLabel('SajjanShakti')}",
                                  style: TextStyle(
                                    color: selectedTypes.contains(1) ? Colors.white : Colors.purpleAccent,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 10),

                        // Anya Prabhavi Lok Button
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                if (selectedTypes.contains(0)) {
                                  selectedTypes.remove(0);
                                } else {
                                  selectedTypes.add(0);
                                }
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: selectedTypes.contains(0) ? Colors.purpleAccent : Colors.transparent,
                                border: Border.all(color: Colors.purpleAccent),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text(
                                  "${Statics.getLabel('anyaPrabhaviLok')}",
                                  style: TextStyle(
                                    color: selectedTypes.contains(0) ? Colors.white : Colors.purpleAccent,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  SizedBox(
                    height: 10,
                  ),
                ]),
              ),
              SizedBox(
                height: 15,
              ),
              if (selectedTypes.contains(1))
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)), border: Border.all(color: Colors.purpleAccent)),
                  child: Column(
                    children: [
                      Text(
                        "${Statics.getLabel('SajjanShakti')}",
                        style: TextStyle(color: Colors.purpleAccent, fontWeight: FontWeight.w600, fontSize: 20),
                      ),
                      Divider(
                        color: Colors.grey,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: () async {
                              final newItem = await showSajjanShaktiFormPopup(
                                context,
                              );
                              if (newItem != null) {
                                setState(() {
                                  sajjanShaktiDataList.add(newItem);
                                });
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 5),
                              width: 100,
                              decoration: BoxDecoration(border: Border.all(color: Colors.purpleAccent.shade100), color: Colors.purpleAccent.withOpacity(0.7), borderRadius: BorderRadius.circular(15)),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.add, color: Colors.white, size: 15),
                                    Text(
                                      "${Statics.getLabel('AddButton')}",
                                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 5),
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
                            width: MediaQuery.of(context).size.width * 1,
                            child: DataTable(
                              showCheckboxColumn: false,
                              headingRowColor: MaterialStatePropertyAll(Colors.purple.shade50),
                              columnSpacing: 40,
                              headingTextStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
                              columns: [
                                DataColumn(
                                    label: Text(
                                  "${Statics.getLabel('Name')}",
                                )),
                                DataColumn(
                                    label: Text(
                                  "${Statics.getLabel('Category')}",
                                )),
                                DataColumn(
                                    label: Text(
                                  "${Statics.getLabel('samparkStithi')}",
                                )),
                              ],
                              rows: sajjanShaktiDataList.asMap().entries.where((entry) => entry.value.isactive == 1).map((entry) {
                                int index = entry.key;
                                var data = entry.value;
                                bool isSelected = selectedsajjanShaktiRowIndex == index;
                                return DataRow(
                                    selected: isSelected,
                                    color: MaterialStateProperty.resolveWith<Color?>(
                                      (Set<MaterialState> states) {
                                        if (isSelected) return Colors.yellow.shade100;
                                        return null;
                                      },
                                    ),
                                    onSelectChanged: (bool? selected) {
                                      if (selected != null && selected) {
                                        setState(() {
                                          selectedsajjanShaktiRowIndex = index;
                                        });
                                      }
                                    },
                                    cells: [
                                      DataCell(Text(data.name ?? "")),
                                      DataCell(Text(data.selectedDropdownValueName ?? "")),
                                      DataCell(Text(data.selectedDropdownValueName1 ?? "")),
                                    ]);
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              SizedBox(
                height: 15,
              ),
              if (selectedTypes.contains(0))
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)), border: Border.all(color: Colors.purpleAccent)),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "${Statics.getLabel('anyaPrabhaviLok')}",
                        style: TextStyle(color: Colors.purpleAccent, fontWeight: FontWeight.w600, fontSize: 20),
                      ),
                      Divider(
                        color: Colors.grey,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: () async {
                              final result = await showAnyaPrabhaviLokFormPopup(context);
                              if (result != null) {
                                setState(() {
                                  anyaPrabhaviLokDataList.add(result);
                                });
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 5),
                              width: 100,
                              decoration: BoxDecoration(border: Border.all(color: Colors.purpleAccent.shade100), color: Colors.purpleAccent.withOpacity(0.7), borderRadius: BorderRadius.circular(15)),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.add, color: Colors.white, size: 15),
                                    Text(
                                      "${Statics.getLabel('AddButton')}",
                                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black54),
                          borderRadius: const BorderRadius.all(Radius.circular(15)),
                        ),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 1,
                            child: DataTable(
                              showCheckboxColumn: false,
                              headingRowColor: MaterialStatePropertyAll(Colors.purple.shade50),
                              columnSpacing: 1,
                              headingTextStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
                              columns: [
                                DataColumn(
                                    label: Text(
                                  "${Statics.getLabel('Name')}",
                                )),
                                DataColumn(
                                    label: Text(
                                  "${Statics.getLabel('special')}",
                                )),
                                DataColumn(
                                    label: Text(
                                  "${Statics.getLabel('prabhavKshetra')}",
                                )),
                              ],
                              rows: anyaPrabhaviLokDataList.asMap().entries.where((entry) => entry.value.isactive == 1).map((entry) {
                                int index = entry.key;
                                var data = entry.value;
                                bool isSelected = selectedanyaPrabhaviLokRowIndex == index;
                                return DataRow(
                                    selected: isSelected,
                                    color: MaterialStateProperty.resolveWith<Color?>(
                                      (Set<MaterialState> states) {
                                        if (isSelected) return Colors.yellow.shade100;
                                        return null;
                                      },
                                    ),
                                    onSelectChanged: (bool? selected) {
                                      if (selected != null && selected) {
                                        setState(() {
                                          selectedanyaPrabhaviLokRowIndex = index;
                                        });
                                      }
                                    },
                                    cells: [
                                      DataCell(Text(data.name ?? "")),
                                      DataCell(Text(data.selectedDropdownValueName3 ?? "")),
                                      DataCell(Text(data.selectedDropdownValueName4 ?? "")),
                                    ]);
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              if (sajjanShaktiDataList.isNotEmpty || anyaPrabhaviLokDataList.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 45, // fixed button height
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purpleAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        submitForm();
                      },
                      child: Text(
                        Statics.getLabel('Submit'),
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<Vastisarsajjanshakti?> showSajjanShaktiFormPopup(BuildContext context) async {
    return await showDialog<Vastisarsajjanshakti>(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: StatefulBuilder(
            builder: (context, setState) {
              return Container(
                padding: const EdgeInsets.all(16),
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.8,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        Statics.getLabel("sajjanShaktiInfo"),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.purpleAccent,
                        ),
                      ),
                      const SizedBox(height: 10),

                      /// 📝 Name
                      textControllerField2(
                        name: Statics.getLabel('Name'),
                        controller: sajjanShaktiNameController,
                        fieldHeight: 45,
                        isRequired: true,
                      ),

                      textControllerField2(
                        name: Statics.getLabel('Address'),
                        controller: sajjanShaktiAddressController,
                        maxLines: 4,
                      ),

                      textControllerField2(
                        name: Statics.getLabel('doorBhash'),
                        controller: sajjanShaktiPhoneController,
                        keyboardType: TextInputType.number,
                        maxInput: 10,
                        isRequired: true,
                      ),

                      Row(
                        children: [
                          Expanded(
                            child: RadioListTile<int>(
                              contentPadding: EdgeInsets.zero,
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              title: Text("${Statics.getLabel('Male')}", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                              value: 0,
                              groupValue: isFemale,
                              onChanged: (value) => setState(() {
                                isFemale = value;
                              }),
                            ),
                          ),
                          Expanded(
                            child: RadioListTile<int>(
                              contentPadding: EdgeInsets.zero,
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              title: Text("${Statics.getLabel('Female')}", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                              value: 1,
                              groupValue: isFemale,
                              onChanged: (value) => setState(() {
                                isFemale = value;
                              }),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),

                      if (vastisarvekshanDropDownDataModel != null)
                        vastisarvekshanDropdown2(
                          question: Statics.getLabel('Category'),
                          dataModel: vastisarvekshanDropDownDataModel!,
                          filterTypeName: "सज्जन शक्ति श्रेणी",
                          hintText: Statics.getLabel('Category'),
                          onItemSelected: (id, value, isOther) {
                            sajjanShaktiShreniName = value;
                            sajjanShaktiShreniId = id;
                          },
                          selectedValue: sajjanShaktiShreniEditDataId,
                          onSelectionChanged: (newValue) {
                            setState(() {
                              sajjanShaktiShreniEditDataId = newValue;
                            });
                          },
                          editId: sajjanShaktiShreniEditId,
                        ),

                      if (sajjanShaktiShreniEditDataId?.isOther == 1)
                        textControllerField2(
                          name: Statics.getLabel('OtherCategory'),
                          controller: sajjanShaktiAnyaShreniNameController,
                        ),

                      textControllerField2(
                        name: Statics.getLabel('OrganizationName'),
                        controller: sajjanShaktiSansthecheNaavController,
                      ),

                      textControllerField2(
                        name: Statics.getLabel('sansthetKuthalaPadavar'),
                        controller: sajjanShaktiSansthKuthalyaPadavarController,
                      ),

                      if (vastisarvekshanDropDownDataModel != null)
                        vastisarvekshanDropdown2(
                          question: Statics.getLabel('samparkStithi'),
                          dataModel: vastisarvekshanDropDownDataModel!,
                          filterTypeName: "सज्जन शक्ति संपर्क स्थिति",
                          hintText: Statics.getLabel('samparkStithi'),
                          onItemSelected: (id, value, isOther) {
                            sajjanShaktiSamparkStithiName = value;
                            sajjanShaktiSamparkStithiId = id;
                          },
                          selectedValue: sajjanShaktiSamparkStithiEditDataId,
                          onSelectionChanged: (newValue) {
                            setState(() {
                              sajjanShaktiSamparkStithiEditDataId = newValue;
                            });
                          },
                          editId: sajjanShaktiSamparkStithiEditId,
                        ),

                      if (vastisarvekshanDropDownDataModel != null)
                        vastisarvekshanDropdown2(
                          question: Statics.getLabel('special'),
                          dataModel: vastisarvekshanDropDownDataModel!,
                          filterTypeName: "सज्जन शक्ति विशेष",
                          hintText: Statics.getLabel('special'),
                          onItemSelected: (id, value, isOther) {
                            sajjanShaktiVisheshName = value;
                            sajjanShaktiVisheshId = id;
                          },
                          selectedValue: sajjanShaktiVisheshEditDataId,
                          onSelectionChanged: (newValue) {
                            setState(() {
                              sajjanShaktiVisheshEditDataId = newValue;
                            });
                          },
                          editId: sajjanShaktiVisheshEditId,
                        ),

                      if (sajjanShaktiVisheshEditDataId?.isOther == 1)
                        textControllerField2(
                          name: Statics.getLabel('otherSpecial'),
                          controller: sajjanShaktiAnyaVisheshNameController,
                        ),

                      if (vastisarvekshanDropDownDataModel != null)
                        vastisarvekshanDropdown2(
                          question: Statics.getLabel('prabhavKshetra'),
                          dataModel: vastisarvekshanDropDownDataModel!,
                          filterTypeName: "सज्जन शक्ति प्रभाव क्षेत्र",
                          hintText: Statics.getLabel('prabhavKshetra'),
                          onItemSelected: (id, value, isOther) {
                            sajjanShaktiPrabhavKeshtraName = value;
                            sajjanShaktiPrabhavKeshtraId = id;
                          },
                          selectedValue: sajjanShaktiPrabhavKeshtraEditDataId,
                          onSelectionChanged: (newValue) {
                            setState(() {
                              sajjanShaktiPrabhavKeshtraEditDataId = newValue;
                            });
                          },
                          editId: sajjanShaktiPrabhavKeshtraEditId,
                        ),

                      textControllerField2(
                        name: Statics.getLabel('samparkSootraNaav'),
                        controller: sajjanShaktiContactPersonNameController,
                        isRequired: true,
                      ),

                      textControllerField2(
                        name: Statics.getLabel('samparakSootraDoorbhash'),
                        controller: sajjanShaktiContactPersonDoorbhashController,
                        keyboardType: TextInputType.number,
                        maxInput: 10,
                        isRequired: true,
                      ),

                      const SizedBox(height: 20),

                      // Action Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              side: BorderSide(color: Colors.grey, width: 1.2),
                            ),
                            onPressed: () {
                              clearSajjanShaktiForm();
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.close, size: 18, color: Colors.grey),
                            label: Text(
                              Statics.getLabel('Cancel'),
                              style: const TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.purpleAccent,
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 3,
                              shadowColor: Colors.purpleAccent.withOpacity(0.4),
                            ),
                            // onPressed: () {
                            //   if (sajjanShaktiType == 1) {
                            //     if ((sajjanShaktiShreniEditDataId?.isOther ==
                            //                 1 &&
                            //             sajjanShaktiAnyaShreniNameController
                            //                     .text ==
                            //                 "") ||
                            //         (sajjanShaktiVisheshEditDataId?.isOther ==
                            //                 1 &&
                            //             sajjanShaktiAnyaVisheshNameController
                            //                     .text ==
                            //                 "")) {
                            //       Statics.showToast(
                            //           "${Statics.getLabel('otherInfoValidation')}");
                            //       return;
                            //     } else if (sajjanShaktiPhoneController
                            //             .text.length !=
                            //         10) {
                            //       Statics.showToast(
                            //           "${Statics.getLabel('mobileNumberLimit')}");
                            //       return;
                            //     }
                            //   }
                            //
                            //   Vastisarsajjanshakti newData =
                            //       Vastisarsajjanshakti(
                            //     name: sajjanShaktiNameController.text.trim(),
                            //     address:
                            //         sajjanShaktiAddressController.text.trim(),
                            //     doorabhaash:
                            //         sajjanShaktiPhoneController.text.trim(),
                            //     shreneeid: sajjanShaktiShreniId,
                            //     selectedDropdownValueName:
                            //         sajjanShaktiShreniName,
                            //     otherShreniName:
                            //         sajjanShaktiAnyaShreniNameController.text
                            //             .trim(),
                            //     sanstheCheNaav:
                            //         sajjanShaktiSansthecheNaavController.text
                            //             .trim(),
                            //     sansthechaKuthalaPadavar:
                            //         sajjanShaktiSansthKuthalyaPadavarController
                            //             .text
                            //             .trim(),
                            //     samparksthitiid: sajjanShaktiSamparkStithiId,
                            //     selectedDropdownValueName1:
                            //         sajjanShaktiSamparkStithiName,
                            //     visheshId: sajjanShaktiVisheshId,
                            //     selectedDropdownValueName2:
                            //         sajjanShaktiVisheshName,
                            //     otherVisheshName:
                            //         sajjanShaktiAnyaVisheshNameController.text
                            //             .trim(),
                            //     prabhaavkshetrid: sajjanShaktiPrabhavKeshtraId,
                            //     selectedDropdownValueName3:
                            //         sajjanShaktiPrabhavKeshtraName,
                            //     samparkasutranava:
                            //         sajjanShaktiContactPersonNameController.text
                            //             .trim(),
                            //     samparkasutraMobileNumber:
                            //         sajjanShaktiContactPersonDoorbhashController
                            //             .text
                            //             .trim(),
                            //     isactive: 1,
                            //     vastiid: int.parse(selctedLevelId!),
                            //     pkid: 0,
                            //   );
                            //
                            //   clearSajjanShaktiForm(); // 👈 sab reset
                            //   Navigator.pop(context, newData);
                            // },
                            onPressed: () {
                              // ✅ पहले check करो कि कोई भी field खाली तो नहीं है
                              if (sajjanShaktiNameController.text.trim().isEmpty ||
                                  sajjanShaktiPhoneController.text.trim().isEmpty ||
                                  (sajjanShaktiShreniEditDataId == null) ||
                                  (sajjanShaktiShreniEditDataId?.isOther == 1 && sajjanShaktiAnyaShreniNameController.text.trim().isEmpty) ||
                                  (sajjanShaktiSamparkStithiEditDataId == null) ||
                                  (sajjanShaktiVisheshEditDataId == null) ||
                                  (sajjanShaktiVisheshEditDataId?.isOther == 1 && sajjanShaktiAnyaVisheshNameController.text.trim().isEmpty) ||
                                  (sajjanShaktiPrabhavKeshtraEditDataId == null) ||
                                  sajjanShaktiContactPersonNameController.text.trim().isEmpty ||
                                  sajjanShaktiContactPersonDoorbhashController.text.trim().isEmpty) {
                                Statics.showToast("${Statics.getLabel('impInfoRequired')}");
                                return;
                              }

                              // ✅ Mobile number validation
                              if (sajjanShaktiPhoneController.text.trim().length != 10 || sajjanShaktiContactPersonDoorbhashController.text.trim().length != 10) {
                                Statics.showToast("${Statics.getLabel('mobileNumberLimit')}");
                                return;
                              }

                              // ✅ अगर सब ठीक है तो data बनाओ
                              Vastisarsajjanshakti newData = Vastisarsajjanshakti(
                                name: sajjanShaktiNameController.text.trim(),
                                address: sajjanShaktiAddressController.text.trim(),
                                doorabhaash: sajjanShaktiPhoneController.text.trim(),
                                shreneeid: sajjanShaktiShreniId,
                                selectedDropdownValueName: sajjanShaktiShreniName,
                                otherShreniName: sajjanShaktiAnyaShreniNameController.text.trim(),
                                sanstheCheNaav: sajjanShaktiSansthecheNaavController.text.trim(),
                                sansthechaKuthalaPadavar: sajjanShaktiSansthKuthalyaPadavarController.text.trim(),
                                samparksthitiid: sajjanShaktiSamparkStithiId,
                                selectedDropdownValueName1: sajjanShaktiSamparkStithiName,
                                visheshId: sajjanShaktiVisheshId,
                                selectedDropdownValueName2: sajjanShaktiVisheshName,
                                otherVisheshName: sajjanShaktiAnyaVisheshNameController.text.trim(),
                                prabhaavkshetrid: sajjanShaktiPrabhavKeshtraId,
                                selectedDropdownValueName3: sajjanShaktiPrabhavKeshtraName,
                                samparkasutranava: sajjanShaktiContactPersonNameController.text.trim(),
                                samparkasutraMobileNumber: sajjanShaktiContactPersonDoorbhashController.text.trim(),
                                isactive: 1,
                                vastiid: int.parse(selctedLevelId ?? "0"),
                                pkid: 0,
                                isfemale: isFemale,
                              );

                              clearSajjanShaktiForm(); // reset
                              Navigator.pop(context, newData);
                            },

                            icon: const Icon(Icons.check, size: 18, color: Colors.white),
                            label: Text(
                              Statics.getLabel('Submit'),
                              style: const TextStyle(fontSize: 14, color: Colors.white),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  void clearSajjanShaktiForm() {
    sajjanShaktiNameController.clear();
    sajjanShaktiAddressController.clear();
    sajjanShaktiPhoneController.clear();
    sajjanShaktiAnyaShreniNameController.clear();
    sajjanShaktiSansthecheNaavController.clear();
    sajjanShaktiSansthKuthalyaPadavarController.clear();
    sajjanShaktiAnyaVisheshNameController.clear();
    sajjanShaktiContactPersonNameController.clear();
    sajjanShaktiContactPersonDoorbhashController.clear();

    sajjanShaktiShreniId = null;
    sajjanShaktiShreniName = null;
    sajjanShaktiShreniEditDataId = null;
    sajjanShaktiShreniEditId = null;

    sajjanShaktiSamparkStithiId = null;
    sajjanShaktiSamparkStithiName = null;
    sajjanShaktiSamparkStithiEditDataId = null;
    sajjanShaktiSamparkStithiEditId = null;

    sajjanShaktiVisheshId = null;
    sajjanShaktiVisheshName = null;
    sajjanShaktiVisheshEditDataId = null;
    sajjanShaktiVisheshEditId = null;

    sajjanShaktiPrabhavKeshtraId = null;
    sajjanShaktiPrabhavKeshtraName = null;
    sajjanShaktiPrabhavKeshtraEditDataId = null;
    sajjanShaktiPrabhavKeshtraEditId = null;
  }

  Future<VastisarAnyaprabhavilokam?> showAnyaPrabhaviLokFormPopup(BuildContext context) async {
    return await showDialog<VastisarAnyaprabhavilokam>(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: StatefulBuilder(
            builder: (context, setState) {
              return Container(
                padding: const EdgeInsets.all(16),
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.8,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        Statics.getLabel("anyaPrabhaviLokInfo"),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.purpleAccent,
                        ),
                      ),
                      const SizedBox(height: 10),

                      /// ---- Name ----
                      textControllerField2(
                        name: Statics.getLabel('Name'),
                        controller: anyaPrabhaviLokNaavController,
                        isRequired: true,
                      ),

                      textControllerField2(
                        name: Statics.getLabel('Address'),
                        controller: anyaPrabhaviLokAddressController,
                      ),

                      textControllerField2(
                        name: Statics.getLabel('doorBhash'),
                        controller: anyaPrabhaviLokMobileNoController,
                        keyboardType: TextInputType.number,
                        maxInput: 10,
                        isRequired: true,
                      ),

                      Row(
                        children: [
                          Expanded(
                            child: RadioListTile<int>(
                              contentPadding: EdgeInsets.zero,
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              title: Text("${Statics.getLabel('Male')}", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                              value: 0,
                              groupValue: isFemale,
                              onChanged: (value) => setState(() {
                                isFemale = value;
                              }),
                            ),
                          ),
                          Expanded(
                            child: RadioListTile<int>(
                              contentPadding: EdgeInsets.zero,
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              title: Text("${Statics.getLabel('Female')}", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                              value: 1,
                              groupValue: isFemale,
                              onChanged: (value) => setState(() {
                                isFemale = value;
                              }),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      /// Category / UpShreni
                      vastisarvekshanDropdown3(
                        filterTypeName: "श्रेणी",
                        hintText: Statics.getLabel('otherUpshreni'),
                        anyaPrabhaviLokShreniId: anyaPrabhaviLokShreniIdEdit,
                        anyaPrabhaviLokUpShreniId: anyaPrabhaviLokUpShreniIdEdit,
                        anyaPrabhaviLokUpShreni1Id: anyaPrabhaviLokUpShreni1IdEdit,
                        onValueSelected: (id, name, value) {
                          anyaPrabhaviLokShreniId = id;
                          anyaPrabhaviLokShreniName = name;
                          setState(() {
                            selectedShreni = value;
                            selectedUpShreni = null;
                            selectedUpShreni2 = null;
                          });
                        },
                        onDependentValueSelected: (id, name, value) {
                          anyaPrabhaviLokUpShreniId = id;
                          anyaPrabhaviLokUpShreniName = name;
                          setState(() {
                            selectedUpShreni = value;
                            selectedUpShreni2 = null;
                          });
                        },
                        onThirdLevelValueSelected: (id, name, value) {
                          anyaPrabhaviLokUpShreni1Id = id;
                          anyaPrabhaviLokUpShreni1Name = name;
                          setState(() {
                            selectedUpShreni2 = value;
                          });
                        },
                        viewName: true,
                      ),

                      if (selectedUpShreni?.isOther == 1)
                        textControllerField2(
                          name: Statics.getLabel('otherUpshreni'),
                          controller: anyaPrabhaviLokAnyaUppshreniController,
                        ),
                      if (selectedUpShreni2?.isOther == 1)
                        textControllerField2(
                          name: Statics.getLabel('otherUpshreni2'),
                          controller: anyaPrabhaviLokAnyaUppshreni1Controller,
                        ),

                      const SizedBox(height: 10),

                      /// Vishesh
                      vastisarvekshanDropdown2(
                        hintText: Statics.getLabel('selectVishesh'),
                        filterTypeName: "अन्यप्रभावीलोकंविशेष",
                        dataModel: vastisarvekshanDropDownDataModel!,
                        question: Statics.getLabel('special'),
                        editId: selectedAnyaPrabhaviLokVisheshIDEdit,
                        selectedValue: selectedAnyaPrabhaviLokVishesh,
                        onItemSelected: (id, name, isOther) {
                          anyaPrabhaviLokVisheshId = id;
                          anyaPrabhaviLokVisheshName = name;
                        },
                        onSelectionChanged: (newValue) {
                          setState(() {
                            selectedAnyaPrabhaviLokVishesh = newValue;
                          });
                        },
                      ),

                      const SizedBox(height: 10),

                      /// Prabhav Kshetra
                      vastisarvekshanDropdown2(
                        hintText: Statics.getLabel('prabhavKshetraSelect'),
                        filterTypeName: "अन्यप्रभावीलोकंप्रभावक्षेत्र",
                        dataModel: vastisarvekshanDropDownDataModel!,
                        question: Statics.getLabel('prabhavKshetra'),
                        editId: selectedAnyaPrabhaviLokPrabhavKshetraIDEdit,
                        selectedValue: selectedAnyaPrabhaviLokPrabhavKshetra,
                        onItemSelected: (id, name, isOther) {
                          anyaPrabhaviLokPrabhavKshetraId = id;
                          anyaPrabhaviLokPrabhavKshetraName = name;
                        },
                        onSelectionChanged: (newValue) {
                          setState(() {
                            selectedAnyaPrabhaviLokPrabhavKshetra = newValue;
                          });
                        },
                      ),

                      textControllerField2(
                        name: Statics.getLabel('anyaVisheshMahiti'),
                        controller: anyaPrabhaviLokAnyaVisheshMahitiController,
                      ),

                      vastisarvekshanDropdown2(
                        hintText: Statics.getLabel('samparkSthitiSelect'),
                        filterTypeName: "अन्यप्रभावीलोकंसंपर्कस्थिति",
                        dataModel: vastisarvekshanDropDownDataModel!,
                        question: Statics.getLabel('samparkStithi'),
                        editId: selectedAnyaPrabhaviLokSamparkStithiIDEdit,
                        selectedValue: selectedAnyaPrabhaviLokSamparkStithi,
                        onItemSelected: (id, name, isOther) {
                          anyaPrabhaviLokSamparkStithiId = id;
                          anyaPrabhaviLokSamparkStithiName = name;
                        },
                        onSelectionChanged: (newValue) {
                          setState(() {
                            selectedAnyaPrabhaviLokSamparkStithi = newValue;
                          });
                        },
                      ),

                      textControllerField2(
                        name: Statics.getLabel('samparkSootraNaav'),
                        controller: anyaPrabhaviLokSamparkSutraNaavController,
                        isRequired: true,
                      ),

                      textControllerField2(
                        name: Statics.getLabel('samparakSootraDoorbhash'),
                        controller: anyaPrabhaviLokSamparkSutraDoorbhashController,
                        keyboardType: TextInputType.number,
                        maxInput: 10,
                        isRequired: true,
                      ),

                      const SizedBox(height: 20),

                      /// Action Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          OutlinedButton.icon(
                            onPressed: () {
                              _clearAnyaPrabhaviLokForm();
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.close, size: 18, color: Colors.grey),
                            label: Text(
                              Statics.getLabel('Cancel'),
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.purpleAccent,
                            ),
                            // onPressed: () {
                            //   if ((selectedUpShreni?.isOther == 1 &&
                            //           anyaPrabhaviLokAnyaUppshreniController
                            //                   .text ==
                            //               "") ||
                            //       (selectedUpShreni2?.isOther == 1 &&
                            //           anyaPrabhaviLokAnyaUppshreni1Controller
                            //                   .text ==
                            //               "")) {
                            //     Statics.showToast(
                            //         "${Statics.getLabel('otherInfoValidation')}");
                            //   } else if (anyaPrabhaviLokMobileNoController
                            //           .text.length !=
                            //       10) {
                            //     log("anyaPrabhaviLokMobileNoController.text.length  -->> ${anyaPrabhaviLokMobileNoController.text.length}");
                            //     Statics.showToast(
                            //         "${Statics.getLabel('mobileNumberLimit')}");
                            //   } else if (anyaPrabhaviLokSamparkSutraDoorbhashController
                            //           .text.length !=
                            //       10) {
                            //     log("anyaPrabhaviLokSamparkSutraDoorbhashController.text.length  -->> ${anyaPrabhaviLokSamparkSutraDoorbhashController.text.length}");
                            //     Statics.showToast(
                            //         "${Statics.getLabel('mobileNumberLimit')}");
                            //   } else {
                            //     VastisarAnyaprabhavilokam newData =
                            //         VastisarAnyaprabhavilokam(
                            //       name: anyaPrabhaviLokNaavController.text,
                            //       address:
                            //           anyaPrabhaviLokAddressController.text,
                            //       doorabhaash:
                            //           anyaPrabhaviLokMobileNoController.text,
                            //       shreneeid: anyaPrabhaviLokShreniId,
                            //       selectedDropdownValueName:
                            //           anyaPrabhaviLokShreniName,
                            //       upshreneeid: anyaPrabhaviLokUpShreniId,
                            //       selectedDropdownValueName1:
                            //           anyaPrabhaviLokUpShreniName,
                            //       upshreneeid2: anyaPrabhaviLokUpShreni1Id,
                            //       selectedDropdownValueName2:
                            //           anyaPrabhaviLokUpShreni1Name,
                            //       visheshid: anyaPrabhaviLokVisheshId,
                            //       selectedDropdownValueName3:
                            //           anyaPrabhaviLokVisheshName,
                            //       prabhaavkshetrid:
                            //           anyaPrabhaviLokPrabhavKshetraId,
                            //       selectedDropdownValueName4:
                            //           anyaPrabhaviLokPrabhavKshetraName,
                            //       othervishesh:
                            //           anyaPrabhaviLokAnyaVisheshMahitiController
                            //               .text,
                            //       samparksthitiid:
                            //           anyaPrabhaviLokSamparkStithiId,
                            //       selectedDropdownValueName5:
                            //           anyaPrabhaviLokSamparkStithiName,
                            //       samparkasutranav:
                            //           anyaPrabhaviLokSamparkSutraNaavController
                            //               .text,
                            //       samparkaSutraDoorbhash:
                            //           anyaPrabhaviLokSamparkSutraDoorbhashController
                            //               .text,
                            //       pkid: 0,
                            //       anyavisesamahiti:
                            //           anyaPrabhaviLokAnyaVisheshMahitiController
                            //               .text,
                            //       otherupshrenee:
                            //           anyaPrabhaviLokAnyaUppshreniController
                            //               .text,
                            //       otherupshrenee2:
                            //           anyaPrabhaviLokAnyaUppshreni1Controller
                            //               .text,
                            //       isactive: 1,
                            //       vastiid: int.parse(selctedLevelId!),
                            //     );
                            //     _clearAnyaPrabhaviLokForm(); // clear after submit
                            //     Navigator.pop(context, newData);
                            //   }
                            // },
                            onPressed: () {
                              // ✅ पहले सभी fields required check
                              if (anyaPrabhaviLokNaavController.text.trim().isEmpty ||
                                  anyaPrabhaviLokMobileNoController.text.trim().isEmpty ||
                                  anyaPrabhaviLokShreniId == null ||
                                  anyaPrabhaviLokUpShreniId == null ||
                                  // (selectedUpShreni?.isOther == 1 && anyaPrabhaviLokAnyaUppshreniController.text.trim().isEmpty) ||
                                  // anyaPrabhaviLokUpShreni1Id == null ||
                                  // (selectedUpShreni2?.isOther == 1 && anyaPrabhaviLokAnyaUppshreni1Controller.text.trim().isEmpty) ||
                                  anyaPrabhaviLokVisheshId == null ||
                                  anyaPrabhaviLokPrabhavKshetraId == null ||
                                  anyaPrabhaviLokSamparkStithiId == null ||
                                  anyaPrabhaviLokSamparkSutraNaavController.text.trim().isEmpty ||
                                  anyaPrabhaviLokSamparkSutraDoorbhashController.text.trim().isEmpty) {
                                Statics.showToast("${Statics.getLabel('impInfoRequired')}");
                                return;
                              }

                              // ✅ Mobile number length check
                              if (anyaPrabhaviLokMobileNoController.text.trim().length != 10) {
                                Statics.showToast("${Statics.getLabel('mobileNumberLimit')}");
                                return;
                              }
                              if (anyaPrabhaviLokSamparkSutraDoorbhashController.text.trim().length != 10) {
                                Statics.showToast("${Statics.getLabel('mobileNumberLimit')}");
                                return;
                              }

                              // ✅ सब ठीक है तो data बनाओ
                              VastisarAnyaprabhavilokam newData = VastisarAnyaprabhavilokam(
                                name: anyaPrabhaviLokNaavController.text.trim(),
                                address: anyaPrabhaviLokAddressController.text.trim(),
                                doorabhaash: anyaPrabhaviLokMobileNoController.text.trim(),
                                shreneeid: anyaPrabhaviLokShreniId,
                                selectedDropdownValueName: anyaPrabhaviLokShreniName,
                                upshreneeid: anyaPrabhaviLokUpShreniId,
                                selectedDropdownValueName1: anyaPrabhaviLokUpShreniName,
                                upshreneeid2: anyaPrabhaviLokUpShreni1Id,
                                selectedDropdownValueName2: anyaPrabhaviLokUpShreni1Name,
                                visheshid: anyaPrabhaviLokVisheshId,
                                selectedDropdownValueName3: anyaPrabhaviLokVisheshName,
                                prabhaavkshetrid: anyaPrabhaviLokPrabhavKshetraId,
                                selectedDropdownValueName4: anyaPrabhaviLokPrabhavKshetraName,
                                othervishesh: anyaPrabhaviLokAnyaVisheshMahitiController.text.trim(),
                                samparksthitiid: anyaPrabhaviLokSamparkStithiId,
                                selectedDropdownValueName5: anyaPrabhaviLokSamparkStithiName,
                                samparkasutranav: anyaPrabhaviLokSamparkSutraNaavController.text.trim(),
                                samparkaSutraDoorbhash: anyaPrabhaviLokSamparkSutraDoorbhashController.text.trim(),
                                pkid: 0,
                                anyavisesamahiti: anyaPrabhaviLokAnyaVisheshMahitiController.text.trim(),
                                otherupshrenee: anyaPrabhaviLokAnyaUppshreniController.text.trim(),
                                otherupshrenee2: anyaPrabhaviLokAnyaUppshreni1Controller.text.trim(),
                                isactive: 1,
                                isfemale: isFemale,
                                vastiid: int.parse(selctedLevelId ?? "0"),
                              );

                              _clearAnyaPrabhaviLokForm(); // clear after submit
                              Navigator.pop(context, newData);
                            },

                            icon: const Icon(Icons.check, color: Colors.white),
                            label: Text(Statics.getLabel('Submit'), style: const TextStyle(color: Colors.white)),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  /// Helper function to clear form
  void _clearAnyaPrabhaviLokForm() {
    anyaPrabhaviLokNaavController.clear();
    anyaPrabhaviLokAddressController.clear();
    anyaPrabhaviLokMobileNoController.clear();
    anyaPrabhaviLokAnyaUppshreniController.clear();
    anyaPrabhaviLokAnyaUppshreni1Controller.clear();
    anyaPrabhaviLokAnyaVisheshMahitiController.clear();
    anyaPrabhaviLokSamparkSutraNaavController.clear();
    anyaPrabhaviLokSamparkSutraDoorbhashController.clear();

    // reset selected values
    selectedShreni = null;
    selectedUpShreni = null;
    selectedUpShreni2 = null;
    selectedAnyaPrabhaviLokVishesh = null;
    selectedAnyaPrabhaviLokPrabhavKshetra = null;
    selectedAnyaPrabhaviLokSamparkStithi = null;
  }

  /// ----------- COMMON FIELD WIDGETS ----------------
  Widget textControllerField2({
    required String name,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    int? maxInput,
    double fieldHeight = 48, // 👈 sirf textfield ke liye height
    int minLines = 1,
    int maxLines = 1,
    bool isRequired = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: (name == Statics.getLabel('samparkSootraNaav') || name == Statics.getLabel('samparakSootraDoorbhash') || name == Statics.getLabel('sansthetKuthalaPadavar')) ? 2 : 1,
            // width: 120, // Label width fixed
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Flexible(
                  child: Text(
                    "$name",
                    maxLines: 3,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ),
                if (isRequired)
                  Container(
                    margin: EdgeInsets.only(right: 4),
                    child: Text(
                      "  *",
                      maxLines: 2,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                        color: Colors.red,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Text(
            ":",
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: (name == Statics.getLabel('samparkSootraNaav') || name == Statics.getLabel('samparakSootraDoorbhash') || name == Statics.getLabel('sansthetKuthalaPadavar')) ? 5 : 3,
            child: TextFormField(
              controller: controller,
              keyboardType: keyboardType,
              maxLength: maxInput,
              minLines: minLines,
              maxLines: maxLines,
              decoration: InputDecoration(
                counterText: "",
                filled: true,
                fillColor: Colors.grey.shade50,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: (fieldHeight - 20) / 2,
                  // 👆 fieldHeight ke hisaab se adjust hoga
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade400),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.purpleAccent, width: 1.5),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget vastisarvekshanDropdown2({
    required VastisarvekshanDropDownDataModel dataModel,
    required String filterTypeName,
    required String hintText,
    required Function(int?, String?, int?) onItemSelected,
    String? question,
    int? editId,
    Masterdata? selectedValue,
    Function(Masterdata?)? onSelectionChanged,
    bool isRequired = true,
  }) {
    List<Masterdata> filteredList = dataModel.masterdata!.where((item) => item.typename == filterTypeName).toList();

    Masterdata? selectedItem = selectedValue;
    if (selectedItem == null && editId != null) {
      try {
        selectedItem = filteredList.firstWhere((item) => item.id == editId);
        onItemSelected(selectedItem.id, selectedItem.value, selectedItem.isOther);
        onSelectionChanged?.call(selectedItem);
      } catch (_) {}
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (question != null)
            Expanded(
              flex: 1,
              // width: 120, // Label width fixed
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Flexible(
                    child: Text(
                      "$question",
                      maxLines: 3,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  if (isRequired)
                    Container(
                      margin: EdgeInsets.only(right: 4),
                      child: Text(
                        "  *",
                        maxLines: 2,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w600,
                          color: Colors.red,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          if (question != null)
            Text(
              ":",
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          if (question != null) const SizedBox(width: 12),
          Expanded(
            flex: 3,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<Masterdata>(
                  hint: Text(
                    hintText,
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                  value: selectedItem,
                  isExpanded: true,
                  items: filteredList.map((Masterdata item) {
                    return DropdownMenuItem<Masterdata>(
                      value: item,
                      child: Text(
                        item.value ?? "",
                        style: const TextStyle(color: Colors.black),
                      ),
                    );
                  }).toList(),
                  onChanged: (Masterdata? newValue) {
                    if (newValue != null) {
                      onItemSelected(newValue.id, newValue.value, newValue.isOther);
                      onSelectionChanged?.call(newValue);
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void resetDropdowns() {
    setState(() {
      selectedShreni = null;
      selectedUpShreni = null;
      selectedUpShreni2 = null;
      anyaPrabhaviLokShreniId = null;
      anyaPrabhaviLokUpShreniId = null;
      anyaPrabhaviLokUpShreni1Id = null;
    });
  }

  Widget vastisarvekshanDropdown3({
    required String filterTypeName,
    required String hintText,
    required Function(int, String, Masterdata) onValueSelected,
    Function(int, String, Masterdata)? onDependentValueSelected,
    Function(int, String, Masterdata)? onThirdLevelValueSelected,
    int? anyaPrabhaviLokShreniId,
    int? anyaPrabhaviLokUpShreniId,
    int? anyaPrabhaviLokUpShreni1Id,
    BoxDecoration? decoration,
    Color? textColor,
    Color? borderColor,
    Color? iconColor,
    bool? viewName,
  }) {
    Masterdata? selectedValue = selectedShreni;
    Masterdata? selectedDependentValue = selectedUpShreni;
    Masterdata? selectedThirdLevelValue = selectedUpShreni2;

    List<Masterdata> masterDataList = vastisarvekshanDropDownDataModel?.masterdata ?? [];
    List<Masterdata> filteredItems = masterDataList.where((e) => e.typename == filterTypeName).toList();

    if (anyaPrabhaviLokShreniId != null && selectedValue == null) {
      selectedValue = filteredItems.firstWhere(
        (e) => e.id == anyaPrabhaviLokShreniId,
        orElse: () => filteredItems.isNotEmpty ? filteredItems.first : Masterdata(),
      );
      selectedShreni = selectedValue;
    }

    List<Masterdata> dependentItems = selectedValue != null ? masterDataList.where((e) => e.parentid == selectedValue!.id).toList() : [];

    if (anyaPrabhaviLokUpShreniId != null && selectedDependentValue == null) {
      selectedDependentValue = dependentItems.firstWhere(
        (e) => e.id == anyaPrabhaviLokUpShreniId,
        orElse: () => dependentItems.isNotEmpty ? dependentItems.first : Masterdata(),
      );

      selectedUpShreni = selectedDependentValue;
    }

    List<Masterdata> thirdLevelItems = selectedDependentValue != null ? masterDataList.where((e) => e.parentid == selectedDependentValue!.id).toList() : [];

    if (anyaPrabhaviLokUpShreni1Id != null && selectedThirdLevelValue == null) {
      selectedThirdLevelValue = thirdLevelItems.firstWhere(
        (e) => e.id == anyaPrabhaviLokUpShreni1Id,
        orElse: () => thirdLevelItems.isNotEmpty ? thirdLevelItems.first : Masterdata(),
      );

      selectedUpShreni2 = selectedThirdLevelValue;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (filteredItems.isNotEmpty)
          _buildDropdown2(
            hintText: hintText,
            value: selectedValue,
            items: filteredItems,
            onChanged: (newValue) {
              if (newValue != null) {
                anyaPrabhaviLokShreniId = newValue.id;
                anyaPrabhaviLokShreniName = newValue.value;

                setState(() {
                  selectedShreni = newValue;
                  selectedUpShreni = null;
                  selectedUpShreni2 = null;
                });

                onValueSelected(newValue.id!, newValue.value!, newValue);
              }
            },
            decoration: decoration,
            borderColor: borderColor,
            iconColor: iconColor,
            textColor: textColor,
            viewName: viewName,
          ),
        if (dependentItems.isNotEmpty) SizedBox(height: 10),
        if (dependentItems.isNotEmpty)
          _buildDropdown2(
            hintText: "${Statics.getLabel('selectUpshreni')}",
            value: selectedDependentValue,
            items: dependentItems,
            onChanged: (newValue) {
              if (newValue != null) {
                anyaPrabhaviLokUpShreniId = newValue.id;
                anyaPrabhaviLokUpShreniName = newValue.value;

                setState(() {
                  selectedUpShreni = newValue;
                  selectedUpShreni2 = null;
                });

                if (onDependentValueSelected != null) {
                  onDependentValueSelected(newValue.id!, newValue.value!, newValue);
                }
              }
            },
            decoration: decoration,
            borderColor: borderColor,
            iconColor: iconColor,
            textColor: textColor,
            viewName: viewName,
          ),
        if (thirdLevelItems.isNotEmpty) SizedBox(height: 10),
        if (thirdLevelItems.isNotEmpty)
          _buildDropdown2(
            hintText: "${Statics.getLabel('selectUpshreni2')}",
            value: selectedThirdLevelValue,
            items: thirdLevelItems,
            onChanged: (newValue) {
              if (newValue != null) {
                anyaPrabhaviLokUpShreni1Id = newValue.id;
                anyaPrabhaviLokUpShreni1Name = newValue.value;

                setState(() {
                  selectedUpShreni2 = newValue;
                });

                if (onThirdLevelValueSelected != null) {
                  onThirdLevelValueSelected(newValue.id!, newValue.value!, newValue);
                }
              }
            },
            decoration: decoration,
            borderColor: borderColor,
            iconColor: iconColor,
            textColor: textColor,
            viewName: viewName,
          ),
      ],
    );
  }

  Widget _buildDropdown2<T extends Masterdata>({
    required String hintText,
    required T? value,
    required List<T> items,
    required Function(T?) onChanged,
    BoxDecoration? decoration,
    Color? textColor,
    Color? borderColor,
    Color? iconColor,
    bool? viewName,
  }) {
    return Container(
      height: 50,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: decoration ??
          BoxDecoration(
            color: Colors.white,
            border: Border.all(color: borderColor ?? Colors.black54),
            borderRadius: BorderRadius.circular(8),
          ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          iconEnabledColor: iconColor ?? Colors.black,
          hint: Text(
            value != null && viewName == true ? value.value ?? "" : hintText,
            style: TextStyle(color: textColor ?? Colors.black),
          ),
          value: items.any((e) => e.id == value?.id) ? value : null,
          isExpanded: true,
          items: items
              .map((item) => DropdownMenuItem<T>(
                    value: item,
                    child: Text(
                      item.value ?? "",
                      style: TextStyle(color: textColor ?? Colors.black),
                    ),
                  ))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
