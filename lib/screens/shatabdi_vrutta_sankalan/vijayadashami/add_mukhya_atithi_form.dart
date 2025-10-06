import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';

import '../../../../helpers/static_data.dart' as Statics;
import '../../../models/response_model/get_vasti_data_by_id_model.dart';
import '../../../models/response_model/vasti_sarvekshan_dropdown_model.dart';
import '../../../models/response_model/vasti_up_data_model.dart';
import '../../../providers/bals.dart';

class AddMukhyaAtithi extends StatefulWidget {
  static const String routeName = '/add-mukhya-atithi';

  const AddMukhyaAtithi({Key? key}) : super(key: key);

  @override
  State<AddMukhyaAtithi> createState() => _AddMukhyaAtithiState();
}

class _AddMukhyaAtithiState extends State<AddMukhyaAtithi> {
  List<Vastisarsajjanshakti> sajjanShaktiDataList = [];
  int? isVastiOrGraam;

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

  int? isFemale = 0;

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

  getDataFromScreen() {
    // 👇 Receive the arguments properly
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    if (args.isNotEmpty) {
      if (args["linkedNagar"] != null) {
        setState(() {
          _linkedNagar = args["linkedNagar"];
        });
      }
      if (args["selectedLevelId"] != null) {
        setState(() {
          final selectedItem = _linkedNagar?.firstWhere((bg) => bg.geoUnitID.toString() == args["selectedLevelId"]);
          populatelinkedMandalDropdown(args["selectedLevelId"]);
          populatelinkedVastiDropdown(args["selectedLevelId"]);
          setState(() {
            selctedLevelName = selectedItem?.name ?? "";
            selctedLevel = 'Nagar';
            selctedLevelId = args["selectedLevelId"];

            _linkedNagarValue = args["selectedLevelId"];
          });
        });
      }
    }
    setState(() {});
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
    getDataFromScreen();
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
  bool? showTypeOfForm = false;
  List<VastisarAnyaprabhavilokam> anyaPrabhaviLokDataList = [];
  int? selectedanyaPrabhaviLokRowIndex;
  int? anyaPrabhaviLokSamparkStithiId;
  String? anyaPrabhaviLokSamparkStithiName;
  int? selectedAnyaPrabhaviLokSamparkStithiIDEdit;
  Masterdata? selectedAnyaPrabhaviLokSamparkStithi;
  int? isActiveAnyaPrabhavilok = 1;
  int? pkidAnyaPrabhaviLok = 0;
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

  resetSajjanShaktiAndAnyaPrabhaviLokData() async {
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
    isFemale = 0;

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
    await resetSajjanShaktiAndAnyaPrabhaviLokData();
    setState(() {});
    if (_result) {
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    resetSajjanShaktiAndAnyaPrabhaviLokData();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(Statics.getLabel('addMukhyaAtithi'), style: TextStyle(fontWeight: FontWeight.bold)),
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
                          showTypeOfForm = true;
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
                          showTypeOfForm = true;
                        });
                      },
                    ),
                  SizedBox(
                    height: 15,
                  ),
                  if (showTypeOfForm == true)
                    DropdownButtonFormField<int>(
                      value: sajjanShaktiType,
                      decoration: InputDecoration(
                        labelText: Statics.getLabel(
                          'SelectPrakar',
                        ),
                        border: UnderlineInputBorder(),
                      ),
                      items: [
                        DropdownMenuItem(
                          value: 1,
                          child: Text("${Statics.getLabel('SajjanShakti')}"),
                        ),
                        DropdownMenuItem(
                          value: 0,
                          child: Text("${Statics.getLabel('anyaPrabhaviLok')}"),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          sajjanShaktiType = value!;
                        });
                      },
                    ),
                  SizedBox(
                    height: 10,
                  ),
                ]),
              ),
              SizedBox(
                height: 15,
              ),
              if (sajjanShaktiType == 1)
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
                      SizedBox(
                        height: 10,
                      ),
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
                      SizedBox(height: 5),
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
                      SizedBox(height: 5),
                      if (vastisarvekshanDropDownDataModel != null)
                        vastisarvekshanDropdown2(
                          question: Statics.getLabel('Category'),
                          dataModel: vastisarvekshanDropDownDataModel!,
                          filterTypeName: "सज्जन शक्ति श्रेणी",
                          hintText: Statics.getLabel('Category'),
                          onItemSelected: (id, value, isOther) {
                            sajjanShaktiShreniName = value;
                            sajjanShaktiShreniId = id;
                            print("id = $id --- Name = $value");
                          },
                          selectedValue: sajjanShaktiShreniEditDataId,
                          onSelectionChanged: (newValue) {
                            setState(() {
                              sajjanShaktiShreniEditDataId = newValue;
                            });
                            print("Selection changes called >>>>>>>>>>");
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
                            print("id = $id --- Name = $value");
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
                            print("id = $id --- Name = $value");
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
                            print("id = $id --- Name = $value");
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
                    ],
                  ),
                ),
              if (sajjanShaktiType == 0)
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
                      textControllerField2(
                        name: "${Statics.getLabel('Name')}",
                        controller: anyaPrabhaviLokNaavController,
                        isRequired: true,
                      ),
                      textControllerField2(
                        name: "${Statics.getLabel('Address')}",
                        controller: anyaPrabhaviLokAddressController,
                      ),
                      textControllerField2(
                        name: "${Statics.getLabel('doorBhash')}",
                        controller: anyaPrabhaviLokMobileNoController,
                        keyboardType: TextInputType.number,
                        maxInput: 10,
                        isRequired: true,
                      ),
                      SizedBox(height: 5),
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
                      SizedBox(height: 5),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// ---- Left side label ----
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "${Statics.getLabel('Category')}/\n${Statics.getLabel('upshreni')}",
                                maxLines: 2,
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(right: 6),
                                child: Text(
                                  "  *",
                                  style: const TextStyle(
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          /// ---- Separator ----
                          Text(
                            ":",
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),

                          /// ---- Right side (Dropdown + conditions) ----
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.only(left: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  /// Dropdown
                                  if (vastisarvekshanDropDownDataModel != null)
                                    vastisarvekshanDropdown3(
                                      filterTypeName: "श्रेणी",
                                      hintText: "${Statics.getLabel('otherUpshreni')}",
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
                                        print("id = $id --- Name = $value");
                                      },
                                      onDependentValueSelected: (id, name, value) {
                                        anyaPrabhaviLokUpShreniId = id;
                                        anyaPrabhaviLokUpShreniName = name;
                                        setState(() {
                                          selectedUpShreni = value;
                                          selectedUpShreni2 = null;
                                        });
                                        print("id = $id --- Name = $value");
                                      },
                                      onThirdLevelValueSelected: (id, name, value) {
                                        anyaPrabhaviLokUpShreni1Id = id;
                                        anyaPrabhaviLokUpShreni1Name = name;
                                        setState(() {
                                          selectedUpShreni2 = value;
                                        });
                                        print("id = $id --- Name = $value");
                                      },
                                      viewName: true,
                                    ),

                                  const SizedBox(height: 10),

                                  /// Other Upshreni (1st level)
                                  if (selectedUpShreni?.isOther == 1)
                                    textControllerField2(
                                      name: "${Statics.getLabel('otherUpshreni')}",
                                      controller: anyaPrabhaviLokAnyaUppshreniController,
                                    ),

                                  if (selectedUpShreni?.isOther == 1) const SizedBox(height: 10),

                                  /// Other Upshreni (2nd level)
                                  if (selectedUpShreni2?.isOther == 1)
                                    textControllerField2(
                                      name: "${Statics.getLabel('otherUpshreni2')}",
                                      controller: anyaPrabhaviLokAnyaUppshreni1Controller,
                                    ),

                                  if (selectedUpShreni2?.isOther == 1) const SizedBox(height: 10),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 5),

                      vastisarvekshanDropDownDataModel != null
                          ? vastisarvekshanDropdown2(
                              hintText: "${Statics.getLabel('selectVishesh')}",
                              filterTypeName: "अन्यप्रभावीलोकंविशेष",
                              onItemSelected: (valueId, valueName, isOther) {
                                anyaPrabhaviLokVisheshId = valueId;
                                anyaPrabhaviLokVisheshName = valueName;
                                print("id = $valueId --- Name = $valueName");
                              },
                              dataModel: vastisarvekshanDropDownDataModel!,
                              question: "${Statics.getLabel('special')}",
                              editId: selectedAnyaPrabhaviLokVisheshIDEdit,
                              selectedValue: selectedAnyaPrabhaviLokVishesh,
                              onSelectionChanged: (newValue) {
                                setState(() {
                                  selectedAnyaPrabhaviLokVishesh = newValue;
                                });
                              },
                            )
                          : Container(),
                      SizedBox(
                        height: 10,
                      ),
                      vastisarvekshanDropDownDataModel != null
                          ? vastisarvekshanDropdown2(
                              hintText: "${Statics.getLabel('prabhavKshetraSelect')}",
                              filterTypeName: "अन्यप्रभावीलोकंप्रभावक्षेत्र",
                              onItemSelected: (valueId, valueName, isOther) {
                                anyaPrabhaviLokPrabhavKshetraId = valueId;
                                anyaPrabhaviLokPrabhavKshetraName = valueName;
                                print("id = $valueId --- Name = $valueName");
                              },
                              dataModel: vastisarvekshanDropDownDataModel!,
                              question: "${Statics.getLabel('prabhavKshetra')}",
                              editId: selectedAnyaPrabhaviLokPrabhavKshetraIDEdit,
                              selectedValue: selectedAnyaPrabhaviLokPrabhavKshetra,
                              onSelectionChanged: (newValue) {
                                setState(() {
                                  selectedAnyaPrabhaviLokPrabhavKshetra = newValue;
                                });
                              },
                            )
                          : Container(),
                      SizedBox(
                        height: 10,
                      ),
                      textControllerField2(
                        name: "${Statics.getLabel('anyaVisheshMahiti')}",
                        controller: anyaPrabhaviLokAnyaVisheshMahitiController,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      vastisarvekshanDropDownDataModel != null
                          ? vastisarvekshanDropdown2(
                              hintText: "${Statics.getLabel('samparkSthitiSelect')}",
                              filterTypeName: "अन्यप्रभावीलोकंसंपर्कस्थिति",
                              onItemSelected: (valueId, valueName, isOther) {
                                anyaPrabhaviLokSamparkStithiId = valueId;
                                anyaPrabhaviLokSamparkStithiName = valueName;
                                print("id = $valueId --- Name = $valueName");
                              },
                              dataModel: vastisarvekshanDropDownDataModel!,
                              question: "${Statics.getLabel('samparkStithi')}",
                              editId: selectedAnyaPrabhaviLokSamparkStithiIDEdit,
                              selectedValue: selectedAnyaPrabhaviLokSamparkStithi,
                              onSelectionChanged: (newValue) {
                                setState(() {
                                  selectedAnyaPrabhaviLokSamparkStithi = newValue;
                                });
                              },
                            )
                          : Container(),
                      SizedBox(
                        height: 10,
                      ),
                      // textControllerField(${Statics.getLabel('anyaVisheshMahiti')}, anyaPrabhaviLokAnyaVisheshMahitiController, context, height: 80),
                      textControllerField2(
                        name: "${Statics.getLabel('samparkSootraNaav')}",
                        controller: anyaPrabhaviLokSamparkSutraNaavController,
                        isRequired: true,
                      ),
                      textControllerField2(
                        name: "${Statics.getLabel('samparakSootraDoorbhash')}",
                        controller: anyaPrabhaviLokSamparkSutraDoorbhashController,
                        keyboardType: TextInputType.number,
                        maxInput: 10,
                        isRequired: true,
                      ),
                    ],
                  ),
                ),
              if (sajjanShaktiType == 0 || sajjanShaktiType == 1)
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
                      // onPressed: () {
                      //   if (sajjanShaktiType ==
                      //       1) if ((sajjanShaktiShreniEditDataId?.isOther == 1 &&
                      //           sajjanShaktiAnyaShreniNameController.text ==
                      //               "") ||
                      //       (sajjanShaktiVisheshEditDataId?.isOther == 1 &&
                      //           sajjanShaktiAnyaVisheshNameController.text ==
                      //               "")) {
                      //     Statics.showToast(
                      //         "${Statics.getLabel('otherInfoValidation')}");
                      //   } else if (sajjanShaktiPhoneController.text.length !=
                      //       10) {
                      //     Statics.showToast(
                      //         "${Statics.getLabel('mobileNumberLimit')}");
                      //   } else {
                      //     Vastisarsajjanshakti newData = Vastisarsajjanshakti(
                      //       name: sajjanShaktiNameController.text.trim(),
                      //       address: sajjanShaktiAddressController.text.trim(),
                      //       doorabhaash: sajjanShaktiPhoneController.text.trim(),
                      //       shreneeid: sajjanShaktiShreniId,
                      //       selectedDropdownValueName: sajjanShaktiShreniName,
                      //       otherShreniName:
                      //           sajjanShaktiAnyaShreniNameController.text.trim(),
                      //       sanstheCheNaav:
                      //           sajjanShaktiSansthecheNaavController.text.trim(),
                      //       sansthechaKuthalaPadavar:
                      //           sajjanShaktiSansthKuthalyaPadavarController.text
                      //               .trim(),
                      //       samparksthitiid: sajjanShaktiSamparkStithiId,
                      //       selectedDropdownValueName1:
                      //           sajjanShaktiSamparkStithiName,
                      //       visheshId: sajjanShaktiVisheshId,
                      //       selectedDropdownValueName2: sajjanShaktiVisheshName,
                      //       otherVisheshName:
                      //           sajjanShaktiAnyaVisheshNameController.text.trim(),
                      //       prabhaavkshetrid: sajjanShaktiPrabhavKeshtraId,
                      //       selectedDropdownValueName3:
                      //           sajjanShaktiPrabhavKeshtraName,
                      //       samparkasutranava:
                      //           sajjanShaktiContactPersonNameController.text
                      //               .trim(),
                      //       samparkasutraMobileNumber:
                      //           sajjanShaktiContactPersonDoorbhashController.text
                      //               .trim(),
                      //       isactive: 1,
                      //       vastiid: int.parse(selctedLevelId!),
                      //       pkid: 0,
                      //     );
                      //     sajjanShaktiDataList.add(newData);
                      //   }
                      //   if (sajjanShaktiType ==
                      //       0) if ((selectedUpShreni?.isOther == 1 &&
                      //           anyaPrabhaviLokAnyaUppshreniController.text ==
                      //               "") ||
                      //       (selectedUpShreni2?.isOther == 1 &&
                      //           anyaPrabhaviLokAnyaUppshreni1Controller.text ==
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
                      //       address: anyaPrabhaviLokAddressController.text,
                      //       doorabhaash: anyaPrabhaviLokMobileNoController.text,
                      //       shreneeid: anyaPrabhaviLokShreniId,
                      //       selectedDropdownValueName: anyaPrabhaviLokShreniName,
                      //       upshreneeid: anyaPrabhaviLokUpShreniId,
                      //       selectedDropdownValueName1:
                      //           anyaPrabhaviLokUpShreniName,
                      //       upshreneeid2: anyaPrabhaviLokUpShreni1Id,
                      //       selectedDropdownValueName2:
                      //           anyaPrabhaviLokUpShreni1Name,
                      //       visheshid: anyaPrabhaviLokVisheshId,
                      //       selectedDropdownValueName3:
                      //           anyaPrabhaviLokVisheshName,
                      //       prabhaavkshetrid: anyaPrabhaviLokPrabhavKshetraId,
                      //       selectedDropdownValueName4:
                      //           anyaPrabhaviLokPrabhavKshetraName,
                      //       othervishesh:
                      //           anyaPrabhaviLokAnyaVisheshMahitiController.text,
                      //       samparksthitiid: anyaPrabhaviLokSamparkStithiId,
                      //       selectedDropdownValueName5:
                      //           anyaPrabhaviLokSamparkStithiName,
                      //       samparkasutranav:
                      //           anyaPrabhaviLokSamparkSutraNaavController.text,
                      //       samparkaSutraDoorbhash:
                      //           anyaPrabhaviLokSamparkSutraDoorbhashController
                      //               .text,
                      //       pkid: 0,
                      //       anyavisesamahiti:
                      //           anyaPrabhaviLokAnyaVisheshMahitiController.text,
                      //       otherupshrenee:
                      //           anyaPrabhaviLokAnyaUppshreniController.text,
                      //       otherupshrenee2:
                      //           anyaPrabhaviLokAnyaUppshreni1Controller.text,
                      //       isactive: 1,
                      //       vastiid: int.parse(selctedLevelId!),
                      //     );
                      //     anyaPrabhaviLokDataList.add(newData);
                      //   }
                      //
                      //   submitForm();
                      // },
                      onPressed: () {
                        bool isValid = true;

                        // Helper function
                        bool isEmpty(String? text) => text == null || text.trim().isEmpty;

                        if (sajjanShaktiType == 1) {
                          // 🔹 Required field checks
                          if (isEmpty(sajjanShaktiNameController.text)) {
                            Statics.showToast("${Statics.getLabel('impInfoRequired')}");
                            isValid = false;
                            // } else if (isEmpty(sajjanShaktiAddressController.text)) {
                            //   Statics.showToast("${Statics.getLabel('allInfoRequired')}");
                            //   isValid = false;
                          } else if (sajjanShaktiPhoneController.text.length != 10) {
                            Statics.showToast("${Statics.getLabel('mobileNumberLimit')}");
                            isValid = false;
                            // } else if (isEmpty(sajjanShaktiSansthecheNaavController.text)) {
                            //   Statics.showToast("${Statics.getLabel('allInfoRequired')}");
                            //   isValid = false;
                            // } else if (isEmpty(sajjanShaktiSansthKuthalyaPadavarController.text)) {
                            //   Statics.showToast("${Statics.getLabel('allInfoRequired')}");
                            //   isValid = false;
                          } else if (isEmpty(sajjanShaktiContactPersonNameController.text)) {
                            Statics.showToast("${Statics.getLabel('impInfoRequired')}");
                            isValid = false;
                          } else if (sajjanShaktiContactPersonDoorbhashController.text.length != 10) {
                            Statics.showToast("${Statics.getLabel('mobileNumberLimit')}");
                            isValid = false;
                          } else if (sajjanShaktiPrabhavKeshtraId == null || sajjanShaktiVisheshId == null || sajjanShaktiSamparkStithiId == null || sajjanShaktiShreniId == null) {
                            Statics.showToast("${Statics.getLabel('impInfoRequired')}");
                            isValid = false;
                          } else if (isEmpty(sajjanShaktiContactPersonNameController.text)) {
                            Statics.showToast("${Statics.getLabel('impInfoRequired')}");
                            isValid = false;
                          } else if (sajjanShaktiContactPersonDoorbhashController.text.length != 10) {
                            Statics.showToast("${Statics.getLabel('mobileNumberLimit')}");
                            isValid = false;
                          }

                          if (isValid) {
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
                              vastiid: int.parse(selctedLevelId!),
                              pkid: 0,
                              isfemale: isFemale,
                            );
                            sajjanShaktiDataList.add(newData);
                          }
                        }

                        if (sajjanShaktiType == 0) {
                          // 🔹 Required field checks
                          if (isEmpty(anyaPrabhaviLokNaavController.text)) {
                            Statics.showToast("${Statics.getLabel('impInfoRequired')}");
                            isValid = false;
                            // } else if (isEmpty(anyaPrabhaviLokAddressController.text)) {
                            //   Statics.showToast("${Statics.getLabel('impInfoRequired')}");
                            //   isValid = false;
                          } else if (anyaPrabhaviLokMobileNoController.text.length != 10) {
                            Statics.showToast("${Statics.getLabel('mobileNumberLimit')}");
                            isValid = false;
                          } else if (anyaPrabhaviLokSamparkStithiId == null ||
                              anyaPrabhaviLokPrabhavKshetraId == null ||
                              anyaPrabhaviLokVisheshId == null ||
                              // anyaPrabhaviLokUpShreni1Id == null ||
                              anyaPrabhaviLokUpShreniId == null ||
                              anyaPrabhaviLokShreniId == null) {
                            Statics.showToast("${Statics.getLabel('impInfoRequired')}");
                            isValid = false;
                          } else if (isEmpty(anyaPrabhaviLokSamparkSutraNaavController.text)) {
                            Statics.showToast("${Statics.getLabel('impInfoRequired')}");
                            isValid = false;
                          } else if (anyaPrabhaviLokSamparkSutraDoorbhashController.text.length != 10) {
                            Statics.showToast("${Statics.getLabel('mobileNumberLimit')}");
                            isValid = false;
                          }

                          if (isValid) {
                            VastisarAnyaprabhavilokam newData = VastisarAnyaprabhavilokam(
                              name: anyaPrabhaviLokNaavController.text,
                              address: anyaPrabhaviLokAddressController.text,
                              doorabhaash: anyaPrabhaviLokMobileNoController.text,
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
                              othervishesh: anyaPrabhaviLokAnyaVisheshMahitiController.text,
                              samparksthitiid: anyaPrabhaviLokSamparkStithiId,
                              selectedDropdownValueName5: anyaPrabhaviLokSamparkStithiName,
                              samparkasutranav: anyaPrabhaviLokSamparkSutraNaavController.text,
                              samparkaSutraDoorbhash: anyaPrabhaviLokSamparkSutraDoorbhashController.text,
                              pkid: 0,
                              anyavisesamahiti: anyaPrabhaviLokAnyaVisheshMahitiController.text,
                              otherupshrenee: anyaPrabhaviLokAnyaUppshreniController.text,
                              otherupshrenee2: anyaPrabhaviLokAnyaUppshreni1Controller.text,
                              isactive: 1,
                              isfemale: isFemale,
                              vastiid: int.parse(selctedLevelId!),
                            );
                            anyaPrabhaviLokDataList.add(newData);
                          }
                        }

                        // ✅ Final form submit
                        if (isValid) {
                          submitForm();
                        }
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

  /// ----------- COMMON FIELD WIDGETS ----------------
  Widget textControllerField2({
    required String name,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    int? maxInput,
    double fieldHeight = 48, // 👈 sirf textfield ke liye height
    int minLines = 1,
    int maxLines = 1,
    int textFlex = 1,
    int valueFlex = 3,
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
              // validator: (value) {
              //   if(isRequired){
              //     if(value == null || value.trim().isEmpty){
              //       return ;
              //     }
              //   }
              //   return null;
              // },
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
              // width: 120, // 👈 label ka fixed width (adjustable)
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Flexible(
                    child: Text(
                      "$question",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  if (isRequired)
                    Flexible(
                      child: Text(
                        "*",
                        maxLines: 2,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
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
    bool isRequired = true,
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
