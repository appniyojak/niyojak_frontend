import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';

import '../../../../helpers/static_data.dart' as Statics;
import '../../../models/response_model/dropdown_level_responsemodel.dart';
import '../../../models/response_model/get_vasti_data_by_id_model.dart';
import '../../../models/response_model/vasti_sarvekshan_dropdown_model.dart';
import '../../../models/response_model/vasti_up_data_model.dart';
import '../../../providers/bals.dart';
import '../../../utils/globals.dart';

class AddPresentMahanubhavScreen extends StatefulWidget {
  static const String routeName = '/add-present-mahanubhav';

  const AddPresentMahanubhavScreen({Key? key}) : super(key: key);

  @override
  State<AddPresentMahanubhavScreen> createState() => _AddPresentMahanubhavScreenState();
}

class _AddPresentMahanubhavScreenState extends State<AddPresentMahanubhavScreen> {
  List<Vastisarsajjanshakti> sajjanShaktiDataList = [];
  int? isVastiOrGraam;

  // All your variables here
  int? sajjanShaktiShreniId = 356;
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
    populateDropdown();
    print("abcd>>>>>>>>>>>>>>>>> 22222222222222222");
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => fetchVastiSurveyDropdownData());
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => initData());
  }

  Future<void> initData() async {
    DropDownModel dm = await MyAppGlobals.getLevelLDB();

    setState(() {
      userLevelId = dm.levelID;
      userGeoUnitId = dm.geoUnitID;
      ddm = dm;
    });
    await populateDropdown();
  }

  Future<void> populateAllGeoDropdowns(int level, DropDownModel dm) async {
    setState(() {
      _selectedGeoUnitId =
          _linkedMahaanagarValue = _linkedbhaagValue = _linkedshaharValue = _linkednagarValue = _linkedupnagarValue = _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = null;
    });
    final selection = prepareSelection(dm);

    // Step 1: Mahaanagar
    await populatelinkedMahaanagarDropdown();
    _linkedMahaanagarValue = (level == 9 ? (dm.geoUnitID ?? "").toString() : selection.mahaanagar) ?? '';
    if (level == 9) {
      _selectedGeoUnitId = (dm.geoUnitID ?? selection.mahaanagar).toString();
      _selctedLevel = 'Mahaanagar';
    }

    // Step 2: Vibhaag
    await populatelinkedVibhaagDropdown(_linkedMahaanagarValue!);
    _linkedVibhaagValue = (level == 8 ? (dm.geoUnitID ?? "").toString() : selection.vibhaag) ?? '';
    if (level == 8) {
      _selectedGeoUnitId = (dm.geoUnitID ?? selection.vibhaag).toString();
      _selctedLevel = 'Vibhaag';
    }

    // Step 3: Bhaag
    await populatelinkedBhaagDropdown(_linkedVibhaagValue!);
    _linkedbhaagValue = (level == 7 ? (dm.geoUnitID ?? "").toString() : selection.bhaag) ?? '';
    if (level == 7) {
      _selectedGeoUnitId = (dm.geoUnitID ?? selection.bhaag).toString();
      _selctedLevel = 'Bhaag';
    }

    // Step 4: Nagar
    await populatelinkedNagarDropdown(_linkedbhaagValue);
    _linkednagarValue = (level == 6 ? (dm.geoUnitID ?? "").toString() : selection.nagar) ?? '';
    if (level == 6) {
      _selectedGeoUnitId = (dm.geoUnitID ?? selection.nagar).toString();
      _selctedLevel = 'Nagar';
    }

    // Step 5: Upnagar (conditional)
    await populatelinkedUpnagarDropdown(_linkednagarValue);
    if (selection.upnagar != null && selection.upnagar!.isNotEmpty) {
      _linkedupnagarValue = (level == 13 ? (dm.geoUnitID ?? "").toString() : selection.upnagar) ?? '';
      if (level == 13) {
        _selectedGeoUnitId = (dm.geoUnitID ?? selection.upnagar).toString();
        _selctedLevel = 'Upnagar';
      }
    }

    // Step 6: Mandal
    await populatelinkedMandalDropdown(
      (selection.upnagar != null && selection.upnagar!.isNotEmpty),
      (selection.upnagar != null && selection.upnagar!.isNotEmpty) ? (_linkedupnagarValue) : _linkednagarValue,
    );
    _linkedmandalValue = (level == 4 ? (dm.geoUnitID ?? "").toString() : selection.mandal) ?? '';
    if (level == 4) {
      _selectedGeoUnitId = (dm.geoUnitID ?? selection.mandal).toString();
      _selctedLevel = 'Mandal';
    }
    // Step 7: Graam
    await populatelinkedGraamDropdown(_linkedmandalValue);
    _linkedgraamValue = (level == 3 ? (dm.geoUnitID ?? "").toString() : selection.graam) ?? '';
    if (level == 3) {
      _selectedGeoUnitId = (dm.geoUnitID ?? selection.graam).toString();
      _selctedLevel = 'Graam';
    }
    // Step 8: Vasti
    await populatelinkedVastiDropdown(
      (selection.upnagar != null && selection.upnagar!.isNotEmpty),
      (selection.upnagar != null && selection.upnagar!.isNotEmpty) ? (_linkedupnagarValue) : _linkednagarValue,
    );
    _linkedvastiValue = (level == 2 ? (dm.geoUnitID ?? "").toString() : selection.vasti) ?? '';
    if (level == 2) {
      _selectedGeoUnitId = (dm.geoUnitID ?? selection.vasti).toString();
      _selctedLevel = 'Vasti';
    }
    if (level == 1) {
      _selectedGeoUnitId = (selection.vasti ?? selection.graam).toString();
    }
    // if (_linkedVibhaag != null && _linkedVibhaag!.isNotEmpty) _linkedVibhaagName = _linkedVibhaag!.firstWhere((bg) => bg.geoUnitID.toString() == _linkedbhaagValue).name;
    // if (_linkedbhaag != null && _linkedbhaag!.isNotEmpty) _linkedbhaagName = _linkedbhaag!.firstWhere((bg) => bg.geoUnitID.toString() == _linkedbhaagValue).name;
    // if (_linkednagar != null && _linkednagar!.isNotEmpty) _linkednagarName = _linkednagar!.firstWhere((bg) => bg.geoUnitID.toString() == _linkedbhaagValue).name;

    setState(() {});
  }

  Future<void> fetchVastiSurveyDropdownData() async {
    // await ();
    try {
      vastisarvekshanDropDownDataModel = await Statics.getVastiSurveyDropDownList(Statics.userDetails["userID"]);
      setState(() {});
    } catch (e) {
      print('Error fetching notification data: $e');
    }
  }

  List<Upnagarmandallist> vastimandallist = [];
  Upnagarmandallist? vastimandalData;

  List<GeoUnitMasterBAL>? _linkedMahaanagar;
  List<GeoUnitMasterBAL>? _linkedVibhaag;
  List<GeoUnitMasterBAL>? _linkedbhaag;
  List<GeoUnitMasterBAL>? _linkedshahar;
  List<GeoUnitMasterBAL>? _linkednagar;
  List<GeoUnitMasterBAL>? _linkedupnagar;
  List<GeoUnitMasterBAL>? _linkedmandal;
  List<GeoUnitMasterBAL>? _linkedgraam;
  List<GeoUnitMasterBAL>? _linkedvasti;

  String? _linkedMahaanagarValue = '';
  String? _linkedVibhaagValue = '';
  String? _linkedbhaagValue = "";
  String? _linkedshaharValue = "";
  String? _linkednagarValue = "";
  String? _linkedupnagarValue = "";
  String? _linkedmandalValue = "";
  String? _linkedgraamValue = "";
  String? _linkedvastiValue = "";

  // String? _linkedMahaanagarName = '';
  // String? _linkedVibhaagName = '';
  String? _linkedbhaagName = "";
  String? _linkedshaharName = "";
  String? _linkednagarName = "";
  String? _linkedupnagarName = "";
  String? _linkedmandalName = "";
  String? _linkedgraamName = "";
  String? _linkedvastiName = "";

  String? _selctedLevel = 'praant';
  String? _selctedLevelName = '';
  String _selctedLevelNames = '';
  List<String?> _selctedLevelNameList = [];
  String? _selectedGeoUnitId;

  //////////////////////////////////////////////////////////////////////////////////////

  Future<void> populateDropdown({bool fromClear = false}) async {
    setState(() {
      _linkedMahaanagarValue = _linkedbhaagValue = _linkedshaharValue = _linkednagarValue = _linkedupnagarValue = _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = null;
      _linkedMahaanagar = _linkedVibhaag = _linkedbhaag = _linkednagar = _linkedupnagar = _linkedmandal = null;
      _selctedLevelName = _selectedGeoUnitId = null;
      _selctedLevel = "praant";
    });
    await populatelinkedMahaanagarDropdown();
    await populatelinkedVibhaagDropdown('');
    if (fromClear || userLevelId == null || ddm == null) {
      return;
    }
    setState(() {
      _linkedMahaanagarValue = _linkedbhaagValue = _linkedshaharValue = _linkednagarValue = _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = null;
    });
    await populateAllGeoDropdowns(userLevelId!, ddm!);
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedMahaanagarDropdown() async {
    _linkedVibhaagValue = _linkedbhaagValue = _linkednagarValue = _linkedupnagarValue = _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = null;
    List<GeoUnitMasterBAL> data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['MahaanagarLevelID'].toString(), '', '', '');
    setState(() {
      _linkedMahaanagar = data;
    });
    return data;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedVibhaagDropdown(String mahaanagarIDStr) async {
    _linkedbhaagValue = _linkednagarValue = _linkedupnagarValue = _linkedupnagarValue = _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = null;
    _linkedbhaagName = _linkednagarName = _linkedupnagar = _linkedupnagar = _linkedmandalName = _linkedgraamName = _linkedvastiName = null;
    print("populatelinkedVibhaagDropdown $mahaanagarIDStr");
    var data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['VibhaagLevelID'].toString(), mahaanagarIDStr, (mahaanagarIDStr.isEmpty ? '' : 'Mahaanagar'), '');

    setState(() {
      _linkedVibhaag = data;
    });
    return data;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedBhaagDropdown(String vibhaagIDStr) async {
    _linkedbhaagValue = _linkednagarValue = _linkedupnagarValue = _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = null;
    _linkedbhaagName = _linkednagarName = _linkedupnagar = _linkedmandalName = _linkedgraamName = _linkedvastiName = null;
    _linkedbhaag = _linkednagar = _linkedmandal = _linkedgraam = _linkedvasti = [];

    var data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['BhaagLevelID'].toString(), vibhaagIDStr, 'Vibhaag', '');

    setState(() {
      _linkedbhaag = data;
    });
    return data;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedShaharDropdown(String bhaagIDStr) async {
    _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = null;
    _linkedmandalName = _linkedgraamName = _linkedvastiName = null;
    var shDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['ShaharLevelID'].toString(), bhaagIDStr, 'Bhaag', '');

    setState(() {
      _linkedshahar = (shDD.length > 0 ? shDD : null);
    });
    return shDD;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedNagarDropdown(String? bhaagIDStr) async {
    var ngDD;
// print("populatelinkedNagarDropdown ${bhaagIDStr} == ${shaharIDStr}  ");
    _linkednagarValue = _linkedupnagarValue = _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = null;
    _linkednagarName = _linkedupnagar = _linkedmandalName = _linkedgraamName = _linkedvastiName = null;
    _linkednagar = _linkedmandal = _linkedgraam = _linkedvasti = null;
    print("print LevelID > ${Statics.userDetails["LevelID"]}");

    ngDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['NagarLevelID'].toString(), bhaagIDStr!, 'Bhaag', '');
    setState(() {
      _linkednagar = (ngDD.length > 0 ? ngDD : null);
    });

    return ngDD;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedUpnagarDropdown(String? nagarIDStr) async {
    _linkedupnagarValue = _linkedmandalValue = _linkedgraamValue = null;
    _linkedupnagarName = _linkedmandalName = _linkedgraamName = null;
    _linkedupnagar = _linkedmandal = _linkedgraam = null;
    var mnDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['UpaNagarLevelID'].toString(), nagarIDStr!, 'Nagar', '');

    setState(() {
      _linkedupnagar = (mnDD.length > 0 ? mnDD : null);
    });
    return mnDD;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedMandalDropdown(bool haveParentUp, String? nagarIDStr) async {
    _linkedmandalValue = _linkedgraamValue = null;
    _linkedmandalName = _linkedgraamName = null;
    _linkedmandal = _linkedgraam = null;
    var mnDD;
    if (haveParentUp) {
      print("i am in parents upnagar");
      mnDD = await Statics.getGeoUnitsByLevelAndParentForUpnagar(Statics.levels['MandalLevelID'].toString(), nagarIDStr!, "Upnagar", '');
      print("${mnDD}");
    } else {
      mnDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['MandalLevelID'].toString(), nagarIDStr!, "Nagar", '');
    }

    setState(() {
      _linkedmandal = (mnDD.length > 0 ? mnDD : null);
    });
    if (_linkedmandal != null) {}

    return mnDD;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedGraamDropdown(String? mandalIDStr) async {
    _linkedgraamValue = null;
    _linkedgraamName = null;
    var gmDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['GraamLevelID'].toString(), mandalIDStr!, 'Mandal', '');
    setState(() {
      _linkedgraam = (gmDD.length > 0 ? gmDD : null);
    });
    return gmDD;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedVastiDropdown(bool haveParentUp, String? nagarIDStr) async {
    _linkedvastiValue = null;
    _linkedvastiName = null;
    var data;
    if (haveParentUp) {
      print("i am in parents upnagar vasti");
      data = await Statics.getGeoUnitsByLevelAndParentForUpnagar(Statics.levels['VastiLevelID'].toString(), nagarIDStr!, "Upnagar", '');
      // print("${mnDD}");
    } else {
      data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['VastiLevelID'].toString(), nagarIDStr!, "Nagar", '');
    }
    setState(() => _linkedvasti = data.isNotEmpty ? data : null);
    return data;
  }

  //////////////////////////////////////////////////////////////////////////////////////

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
  int? anyaPrabhaviLokShreniId = 127;
  int? anyaPrabhaviLokShreniIdEdit;
  String? anyaPrabhaviLokShreniName;
  int? anyaPrabhaviLokUpShreniId = 128;
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
      "GeoUnitID": int.tryParse(_selectedGeoUnitId ?? "0") ?? 0,
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
        title: Text(Statics.getLabel('addPresentMahanubhav'), style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(16),
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
                  nagarDropdown(),
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
                            sajjanShaktiShreniId = 356;
                            print("id = $id --- Name = $value");
                          },
                          isDisable: true,
                          selectedValue: vastisarvekshanDropDownDataModel?.masterdata?.firstWhere((e) => e.id == 356),
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
                                      anyaPrabhaviLokShreniId: 127,
                                      anyaPrabhaviLokUpShreniId: 128,
                                      ignoreFirst: true,
                                      ignoreSecond: true,
                                      anyaPrabhaviLokUpShreni1Id: anyaPrabhaviLokUpShreni1IdEdit,
                                      onValueSelected: (id, name, value) {
                                        anyaPrabhaviLokShreniId = 127;
                                        anyaPrabhaviLokShreniName = name;
                                        setState(() {
                                          selectedShreni = value;
                                          selectedUpShreni = null;
                                          selectedUpShreni2 = null;
                                        });
                                        print("id = $id --- Name = $value");
                                      },
                                      onDependentValueSelected: (id, name, value) {
                                        anyaPrabhaviLokUpShreniId = 128;
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
                              shreneeid: sajjanShaktiShreniId ?? 356,
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
                              vastiid: int.tryParse(_selectedGeoUnitId ?? "0") ?? 0,
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
                              shreneeid: anyaPrabhaviLokShreniId ?? 127,
                              selectedDropdownValueName: anyaPrabhaviLokShreniName,
                              upshreneeid: anyaPrabhaviLokUpShreniId ?? 128,
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
                              vastiid: int.tryParse(_selectedGeoUnitId ?? "0") ?? 0,
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

  Widget nagarDropdown() {
    return Container(
      child: Column(
        children: [
          if (_linkedMahaanagar != null)
            buildDropdownField(
              label: Statics.getLabel('Mahaanagar'),
              value: _linkedMahaanagarValue,
              items: _linkedMahaanagar!
                  .map((bg) => DropdownMenuItem(
                        value: bg.geoUnitID.toString(),
                        child: Text(bg.name!),
                      ))
                  .toList(),
              onChanged: (value) async {
                final selectedItem = _linkedMahaanagar!.firstWhere((bg) => bg.geoUnitID.toString() == value);
                setState(() {
                  _linkedMahaanagarValue = value;
                  _linkedVibhaagValue = null;
                  _selctedLevel = Statics.getLabel('Mahaanagar');
                  _selctedLevelName = selectedItem.name ?? "";
                  _selectedGeoUnitId = value;
                  // _linkedMahaanagarName = selectedItem.name ?? "";
                  // _resetLinkedValues();
                });
                populatelinkedVibhaagDropdown(value!);
                populatelinkedBhaagDropdown("");
              },
              isDisabled: ((userLevelId ?? 0) < 9 || userLevelId == 13),
            ),
          if (_linkedVibhaag != null)
            buildDropdownField(
              label: Statics.getLabel('Vibhaag'),
              value: _linkedVibhaagValue,
              items: _linkedVibhaag!
                  .map((bg) => DropdownMenuItem(
                        value: bg.geoUnitID.toString(),
                        child: Text(bg.name!),
                      ))
                  .toList(),
              onChanged: (value) {
                final selectedItem = _linkedVibhaag!.firstWhere((bg) => bg.geoUnitID.toString() == value);
                setState(() {
                  _linkedVibhaagValue = value;
                  _selctedLevel = Statics.getLabel('Vibhaag');
                  _selctedLevelName = selectedItem.name ?? "";
                  _selectedGeoUnitId = value;
                  // _linkedVibhaagName = selectedItem.name ?? "";
                });
                populatelinkedBhaagDropdown(value!);
              },
              isDisabled: ((userLevelId ?? 0) < 8 || userLevelId == 13),
            ),
          if (_linkedbhaag != null && _linkedbhaag!.isNotEmpty)
            buildDropdownField(
              label: Statics.getLabel('Bhaag'),
              value: _linkedbhaagValue,
              items: _linkedbhaag!
                  .map((bg) => DropdownMenuItem(
                        value: bg.geoUnitID.toString(),
                        child: Text(bg.name!),
                      ))
                  .toList(),
              onChanged: (value) {
                final selectedItem = _linkedbhaag!.firstWhere((bg) => bg.geoUnitID.toString() == value);
                setState(() {
                  _linkedbhaagValue = value;
                  _selctedLevel = Statics.getLabel('Bhaag');
                  _selctedLevelName = selectedItem.name ?? "";
                  _linkedbhaagName = selectedItem.name ?? "";
                  _selectedGeoUnitId = value;
                  populatelinkedShaharDropdown(value!);
                  populatelinkedNagarDropdown(value);
                });
              },
              isDisabled: ((userLevelId ?? 0) < 7 || userLevelId == 13),
            ),
          if (_linkednagar != null && _linkednagar!.isNotEmpty)
            buildDropdownField(
              label: Statics.getLabel('Nagar'),
              value: _linkednagarValue,
              items: _linkednagar!
                  .map((bg) => DropdownMenuItem(
                        value: bg.geoUnitID.toString(),
                        child: Text(bg.name!),
                      ))
                  .toList(),
              onChanged: (value) {
                final selectedItem = _linkednagar!.firstWhere((bg) => bg.geoUnitID.toString() == value);
                setState(() {
                  _linkednagarValue = value;
                  _selectedGeoUnitId = value;
                  _selctedLevel = Statics.getLabel('Nagar');
                  _selctedLevelName = selectedItem.name ?? "";
                  _linkednagarName = selectedItem.name ?? "";
                  populatelinkedUpnagarDropdown(value);
                  populatelinkedMandalDropdown(false, value);
                  populatelinkedVastiDropdown(false, value);
                });
              },
              isDisabled: ((userLevelId ?? 0) < 6 || userLevelId == 13),
            ),
          if (_linkedupnagar != null && _linkedupnagar!.isNotEmpty)
            buildDropdownField(
              label: Statics.getLabel('upnagarUpkhanda'),
              value: _linkedupnagarValue,
              items: _linkedupnagar!
                  .map((bg) => DropdownMenuItem(
                        value: bg.geoUnitID.toString(),
                        child: Text(bg.name!),
                      ))
                  .toList(),
              onChanged: (value) {
                final selectedItem = _linkedupnagar!.firstWhere((bg) => bg.geoUnitID.toString() == value);
                setState(() {
                  _linkedupnagarValue = value;
                  _selectedGeoUnitId = value;
                  _selctedLevel = Statics.getLabel('upnagarUpkhanda');
                  _selctedLevelName = selectedItem.name ?? "";
                  _linkedupnagarName = selectedItem.name ?? "";
                  populatelinkedMandalDropdown(true, value);
                  populatelinkedVastiDropdown(true, value);
                });
              },
              isDisabled: ((userLevelId ?? 0) < 6 || userLevelId == 13),
            ),
          if (_linkedmandal != null && _linkedmandal!.isNotEmpty)
            buildDropdownField(
              label: Statics.getLabel('Mandal'),
              value: _linkedmandalValue,
              items: _linkedmandal!
                  .map((bg) => DropdownMenuItem(
                        value: bg.geoUnitID.toString(),
                        child: Text(bg.name!),
                      ))
                  .toList(),
              onChanged: (value) {
                final selectedItem = _linkedmandal!.firstWhere((bg) => bg.geoUnitID.toString() == value);
                setState(() {
                  _linkedmandalValue = value;
                  _selectedGeoUnitId = value.toString();
                  _selctedLevel = Statics.getLabel('Mandal');
                  _selctedLevelName = selectedItem.name ?? "";
                  _linkedmandalName = selectedItem.name ?? "";
                  populatelinkedGraamDropdown(value);
                });
              },
              isDisabled: ((userLevelId ?? 0) < 4),
            ),
          if (_linkedgraam != null && _linkedgraam!.isNotEmpty)
            buildDropdownField(
              label: Statics.getLabel('Graam'),
              value: _linkedgraamValue,
              items: _linkedgraam!
                  .map((bg) => DropdownMenuItem(
                        value: bg.geoUnitID.toString(),
                        child: Text(bg.name!),
                      ))
                  .toList(),
              onChanged: (value) {
                final selectedItem = _linkedgraam!.firstWhere((bg) => bg.geoUnitID.toString() == value);
                setState(() {
                  _linkedgraamValue = value;
                  _selectedGeoUnitId = value.toString();
                  _selctedLevel = 'Graam';
                  _selctedLevelName = selectedItem.name ?? "";
                  _linkedgraamName = selectedItem.name ?? "";
                  isVastiOrGraam = 0;
                  showTypeOfForm = true;
                });
              },
              isDisabled: ((userLevelId ?? 0) < 3),
            ),
          if (_linkedvasti != null && _linkedvasti!.isNotEmpty)
            buildDropdownField(
              label: Statics.getLabel('Vasti'),
              value: _linkedvastiValue,
              items: _linkedvasti!
                  .map((bg) => DropdownMenuItem(
                        value: bg.geoUnitID.toString(),
                        child: Text(bg.name!),
                      ))
                  .toList(),
              onChanged: (value) {
                final selectedItem = _linkedvasti!.firstWhere((bg) => bg.geoUnitID.toString() == value);
                setState(() {
                  _linkedvastiValue = value;
                  _selectedGeoUnitId = value.toString();
                  _selctedLevel = 'Vasti';
                  _selctedLevelName = selectedItem.name ?? "";
                  _linkedvastiName = selectedItem.name ?? "";
                  isVastiOrGraam = 1;
                  showTypeOfForm = true;
                });
              },
              isDisabled: ((userLevelId ?? 0) < 2),
            ),
          SizedBox(height: 15),
        ],
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
    bool isDisable = false,
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
            child: IgnorePointer(
              ignoring: isDisable,
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
    bool ignoreFirst = false,
    bool ignoreSecond = false,
    bool ignoreThird = false,
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
          IgnorePointer(
            ignoring: ignoreFirst,
            child: _buildDropdown2(
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
          ),
        if (dependentItems.isNotEmpty) SizedBox(height: 10),
        if (dependentItems.isNotEmpty)
          IgnorePointer(
            ignoring: ignoreSecond,
            child: _buildDropdown2(
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
          ),
        if (thirdLevelItems.isNotEmpty) SizedBox(height: 10),
        if (thirdLevelItems.isNotEmpty)
          IgnorePointer(
            ignoring: ignoreThird,
            child: _buildDropdown2(
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
