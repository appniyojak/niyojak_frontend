import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../helpers/static_data.dart' as Statics;
import '../../../models/response_model/dropdown_level_responsemodel.dart';
import '../../../models/response_model/sadbhav_baithak_resp_model.dart';
import '../../../models/response_model/sadbhav_baithak_vrutta_resp_model.dart';
import '../../../models/response_model/yuva_sangam_model.dart';
import '../../../providers/bals.dart';
import '../../../utils/globals.dart';
import 'add_new_karyakram_screen.dart';
import 'yuva_sangam_form_screen.dart';

class YuvaSangamListTab extends StatefulWidget {
  const YuvaSangamListTab({super.key});

  @override
  State<YuvaSangamListTab> createState() => _YuvaSangamListTabState();
}

class _YuvaSangamListTabState extends State<YuvaSangamListTab> with AutomaticKeepAliveClientMixin {
// This override is what tells Flutter to keep the state alive.
  @override
  bool get wantKeepAlive => true;

  final GlobalKey<FormState> _formKey = GlobalKey();
  SadbhavBaithakVruttaRespModel? vruttaData;

  bool _searched = false;
  bool _isExpanded = true;

  var kendraController = ExpansionTileController();
  var baithakController = ExpansionTileController();

  TextEditingController dateController = TextEditingController();
  TextEditingController txtGivenGroupNameController = TextEditingController();
  TextEditingController txtPramukhNameController = TextEditingController();
  TextEditingController txtPramukhMobileController = TextEditingController();
  TextEditingController txtCentreNameController = TextEditingController();

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
  List<String> _selectedNagarIds = [];

  // int? baithakId;
  bool _isViewOnly = false;
  bool dateWise = false;

  List<Map<String, dynamic>> karyakramLevelsList = [
    {"${Statics.getLabel("Bhaag")}": 1},
    // {"${Statics.getLabel("railwayStation")}": 2},
    // {"${Statics.getLabel("Shahar")}": 3},
    {"${Statics.getLabel("other")}": 4},
    {"${Statics.getLabel("Nagar")}": 5},
    {"${Statics.getLabel("upnagarUpkhanda")}": 6},
    {"${Statics.getLabel("Mandal")}": 7},
  ];
  int? _selectedKaryakramLevelId;

  // int? _selectedKendraId;

  List<Nagardata> nagarList = [];
  List<YuvaSangamData> kendraList = [];

  // List<Bhaitakdata> kendraBaithakList = [];
  SadbhavKendraMasterdata? selectedKendra;

  // AbhiyanSwayamsevakdata? initialData;

  List<Map<String, dynamic>> getFilteredKaryakramLevels(int levelId) {
    Map<int, String> levelMap = {
      1: "Bhaag",
      4: "other",
      5: "Nagar",
      6: "upnagarUpkhanda",
      7: "Mandal",
    };

    List<int> allowedIds;

    switch (levelId) {
      case 7:
        allowedIds = [1, 4, 5, 6, 7];
        break;

      case 6:
        allowedIds = [1, 5, 6, 7];
        break;

      case 13:
        allowedIds = [1, 6, 7];
        break;

      case 4:
        allowedIds = [7];
        break;

      default:
        return karyakramLevelsList;
    }

    return allowedIds.map((id) {
      final key = Statics.getLabel(levelMap[id]!);
      return {key: id};
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) => populateDropdown());
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) => getKendraListData());
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => initData());
  }

  Future<void> initData() async {
    DropDownModel dm = await MyAppGlobals.getLevelLDB();

    setState(() {
      userLevelId = dm.levelID;
      userGeoUnitId = dm.geoUnitID;
      ddm = dm;
      _selectedKaryakramLevelId = dm.levelID == 7
          ? 1
          : dm.levelID == 6
              ? 5
              : dm.levelID == 13
                  ? 6
                  : dm.levelID == 4
                      ? 7
                      : null;
      karyakramLevelsList = getFilteredKaryakramLevels(dm.levelID ?? 0);
    });
    await populateDropdown();
    getKendraListData();
  }

  GeoSelection prepareSelection(DropDownModel dm) {
    return GeoSelection(
      mahaanagar: dm.parentMahaanagarID?.toString() ?? '',
      vibhaag: dm.parentVibhaagID?.toString() ?? '',
      bhaag: dm.parentBhaagID?.toString() ?? '',
      nagar: dm.parentNagarID?.toString() ?? '',
      upnagar: dm.parentUpaNagarID?.toString() ?? '',
      mandal: dm.parentMandalID?.toString() ?? '',
      graam: dm.parentGraamID?.toString() ?? '',
      vasti: dm.parentVastiID?.toString() ?? '',
    );
  }

  Future<void> populateAllDropdowns(int level, DropDownModel dm) async {
    setState(() {
      _selectedGeoUnitId = _linkedMahaanagarValue = _linkedbhaagValue = _linkedshaharValue = _linkednagarValue = _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = null;
    });
    final selection = prepareSelection(dm);

    // Step 1: Mahaanagar
    await populatelinkedMahaanagarDropdown();
    _selectedGeoUnitId = _linkedMahaanagarValue = (level == 9 ? (dm.geoUnitID ?? int.tryParse(_linkedVibhaagValue ?? "0") ?? 0).toString() : selection.mahaanagar) ?? '';
    _selctedLevel = 'Mahaanagar';

    // Step 2: Vibhaag
    await populatelinkedVibhaagDropdown(_linkedMahaanagarValue!);
    _selectedGeoUnitId = _linkedVibhaagValue = (level == 8 ? (dm.geoUnitID ?? int.tryParse(_linkedVibhaagValue ?? "0") ?? 0).toString() : selection.vibhaag) ?? '';
    _selctedLevel = 'Vibhaag';

    // Step 3: Bhaag
    await populatelinkedBhaagDropdown(_linkedVibhaagValue!);
    _selectedGeoUnitId = _linkedbhaagValue = (level == 7 ? (dm.geoUnitID ?? int.tryParse(_linkedVibhaagValue ?? "0") ?? 0).toString() : selection.bhaag) ?? '';
    _selctedLevel = 'Bhaag';

    // Step 4: Nagar
    await populatelinkedNagarDropdown(_linkedbhaagValue);
    _selectedGeoUnitId = _linkednagarValue = (level == 6 ? (dm.geoUnitID ?? int.tryParse(_linkedbhaagValue ?? "0") ?? 0).toString() : selection.nagar) ?? _linkedbhaagValue;
    _selctedLevel = 'Nagar';

    // Step 5: Upnagar (conditional)
    if (selection.upnagar != null && selection.upnagar!.isNotEmpty) {
      await populatelinkedUpnagarDropdown(_linkednagarValue);
      _selectedGeoUnitId = _linkedupnagarValue = (level == 13 ? (dm.geoUnitID ?? int.tryParse(_linkedbhaagValue ?? "0") ?? 0).toString() : selection.upnagar) ?? '';
    }

    // Step 6: Mandal
    await populatelinkedMandalDropdown(
      selection.upnagar != null ? "Nagar" : "Upnagar",
      selection.upnagar != null ? _linkednagarValue : _linkedupnagarValue,
    );
    _selectedGeoUnitId = _linkedmandalValue = (level == 4 ? (dm.geoUnitID ?? int.tryParse(_linkedbhaagValue ?? "0") ?? 0).toString() : selection.mandal) ?? '';

    // // Step 7: Graam
    // await populatelinkedGraamDropdown(_linkedmandalValue);
    // _selectedGeoUnitId = _linkedgraamValue = (level == 3 ? (dm.geoUnitID ?? "").toString() : selection.graam) ?? '';
    //
    // // Step 8: Vasti
    // await populatelinkedVastiDropdown(_linkedNagarValue);
    // _selectedGeoUnitId = _linkedvastiValue = (level == 2 ? (dm.geoUnitID ?? "").toString() : selection.vasti) ?? '';

    // if (_linkedVibhaag != null && _linkedVibhaag!.isNotEmpty) _linkedVibhaagName = _linkedVibhaag!.firstWhere((bg) => bg.geoUnitID.toString() == _linkedbhaagValue).name;
    // if (_linkedbhaag != null && _linkedbhaag!.isNotEmpty) _linkedbhaagName = _linkedbhaag!.firstWhere((bg) => bg.geoUnitID.toString() == _linkedbhaagValue).name;
    // if (_linkednagar != null && _linkednagar!.isNotEmpty) _linkednagarName = _linkednagar!.firstWhere((bg) => bg.geoUnitID.toString() == _linkedbhaagValue).name;

    setState(() {});
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
  //   _isViewOnly = args?["viewOnly"] ?? false;
  //   baithakId = args?["id"] ?? 0;
  //   // getData();
  //   // viewType = args!.viewType;
  // }

  getKendraListData() async {
    kendraList = [];
    setState(() {});
    var formData = {
      "levelid": _selectedKaryakramLevelId ?? 0,
      "geounitid": int.tryParse(_selectedGeoUnitId ?? "0") ?? 0,
      "appuserid": int.parse(Statics.userDetails['userID']),
      "isdatewise": dateWise ? 1 : 0,
    };

    final _baithak = await Statics.GetYuvaSangamListData(context: context, inputJson: formData, showLoader: true);
    print("getData api HiTttttt >>>>>>>>>>>>>>>>>");

    kendraList = _baithak ?? [];
    selectedKendra = null;

    setState(() {
      _searched = true;
      _isExpanded = false;
    });
  }

  // createSadbhavBaithakFun() async {
  //   Map<String, dynamic> formData = {
  //     "id": selectedKendra?.pkid ?? 0,
  //     "date": dateController.text,
  //     "appuserid": int.parse(Statics.userDetails['userID']),
  //   };
  //
  //   String formattedJson = const JsonEncoder.withIndent('  ').convert(formData);
  //   log("Form Data (JSON):\n$formattedJson");
  //   final _res = await Statics.CreatePramukhJanData(context: context, inputJson: formData, showLoader: true);
  //   if (_res) {
  //     Statics.showToast(Statics.getLabel('dataSavedSuccessfully'));
  //     Navigator.pop(context);
  //     await getBaithakListData(selectedKendra?.pkid ?? 0);
  //   }
  //   // getFormData();
  // }

  showEditDatePopup(String date, int? id) {
    dateController.text = date;
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, set) {
          return AlertDialog(
            insetPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 24),
            title: Text(Statics.getLabel("changeDate")),
            content: SizedBox(
              width: double.infinity,
              child: TextField(
                controller: dateController,
                style: TextStyle(fontSize: 14),
                autofocus: false,
                onTap: () async {
                  DateTime? date = await showDatePicker(
                    context: context,
                    initialDate: dateController.text.isEmpty ? DateTime.now() : DateFormat("dd/MM/yyyy").parse(dateController.text),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (date != null) {
                    dateController.text = DateFormat("dd/MM/yyyy").format(date);
                    set(() {});
                  }
                },
                readOnly: true,
                decoration: InputDecoration(
                    isDense: true,
                    hintText: "DD/MM/YYYY",
                    contentPadding: EdgeInsets.only(left: 12, right: 12, top: 14, bottom: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    )),
              ),
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // if ((_linkedgraamValue != "" && _linkedgraamValue != null) || (_linkedvastiValue != "" && _linkedvastiValue != null))
                  MaterialButton(
                    minWidth: MediaQuery.sizeOf(context).width * 0.4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    padding: EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    color: Theme.of(context).primaryColor,
                    disabledColor: Colors.grey,
                    textColor: Theme.of(context).primaryTextTheme.labelMedium?.color,
                    onPressed: dateController.text.trim().isEmpty ? null : () => changeDateData(id),
                    child: Text(
                      Statics.getLabel('Submit'),
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  MaterialButton(onPressed: () => Navigator.pop(context), child: Text(Statics.getLabel('clear'))),
                ],
              ),
            ],
          );
        });
      },
    );
  }

  changeDateData(int? id) async {
    Map<String, dynamic> formData = {
      "id": id ?? 0,
      "date": dateController.text,
      "appuserid": int.parse(Statics.userDetails['userID']),
    };

    String formattedJson = const JsonEncoder.withIndent('  ').convert(formData);
    log("Form Data (JSON):\n$formattedJson");
    final _res = await Statics.UpdateYuvaSangamDateData(context: context, inputJson: formData, showLoader: true);
    if (_res) {
      Statics.showToast(Statics.getLabel('dataSavedSuccessfully'));
      Navigator.pop(context);
      // await getBaithakListData(selectedKendra?.pkid ?? 0);
    }
    await getKendraListData();
  }

  deleteYuvaSangam(int id) async {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(Statics.getLabel('AskConfirmation')),
        content: Text(Statics.getLabel('AreyouSureYouWantToDeleteSanmelan')),
        actions: <Widget>[
          MaterialButton(
            child: Text(Statics.getLabel('ConfirmationYes')),
            onPressed: () async {
              Navigator.of(ctx).pop();
              var _res = await Statics.DeleteYuvaSangamData(context: context, inputJson: {"id": id});
              if (_res) {
                Statics.showToast(Statics.getLabel('KendraDeletedSuccessfully'));
                kendraList.removeWhere((e) => e.pkid == id);
                setState(() {});
              } else {
                Statics.showToast(Statics.getLabel('errorOccurred'));
              }
              clearForm();
              // await getKendraListData();
            },
          ),
          MaterialButton(
            child: Text(Statics.getLabel('ConfirmationNo')),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  clearForm() async {
    setState(() {
      _searched = false;
      _selectedGeoUnitId = null;
      nagarList = [];
      selectedKendra = null;
      _selectedKaryakramLevelId = null;
      dateController.clear();
      txtGivenGroupNameController.clear();
      _linkedMahaanagarValue = _linkedbhaagValue = _linkedshaharValue = _linkednagarValue = _linkedmandalValue = _linkedvastiValue = _linkedgraamValue = null;
      _linkedVibhaagValue = _linkedbhaag = _linkedshahar = _linkedgraam = _linkedmandal = _linkedvasti = _linkednagar = null;
    });
    // clearForm();
    await populateDropdown();
    await getKendraListData();
  }

  //////////////////////////////////////////////////////////////////////////////////////

  Future<void> populateDropdown({bool fromClear = false}) async {
    setState(() {
      _linkedMahaanagarValue = _linkedbhaagValue = _linkedshaharValue = _linkednagarValue = _linkedupnagarValue = _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = null;
      _linkedMahaanagar = _linkedVibhaag = _linkedbhaag = _linkednagar = _linkedupnagar = _linkedmandal = null;
      _selctedLevelName = _selectedGeoUnitId = null;
      nagarList = [];
      _selctedLevel = "praant";
    });
    await populatelinkedMahaanagarDropdown();
    await populatelinkedVibhaagDropdown('');

    if (fromClear || userLevelId == null || ddm == null) {
      print("object is null");
      print("object is null ${userLevelId == null}");
      print("object is null ${ddm == null}");
      return;
    }
    print("object is not null >>>>>>>>>>>>>>>>>>>>>>");
    await populateAllDropdowns(userLevelId!, ddm!);
    // if (initialData != null) {
    //   setState(() {
    //     if (initialData!.parentMahaanagarID != null) {
    //       _isExpanded = true;
    //       _linkedMahaanagarDisable = true;
    //       _linkedMahaanagarValue = initialData!.parentMahaanagarID.toString();
    //     }
    //     if (initialData!.parentVibhaagID != null) {
    //       populatelinkedVibhaagDropdown('');
    //       _isExpanded = true;
    //       _linkedVibhaagDisable = true;
    //       _linkedVibhaagValue = initialData!.parentVibhaagID.toString();
    //     }
    //     if (initialData!.parentBhaagID != null) {
    //       _isExpanded = true;
    //       _linkedbhaagDisable = true;
    //       _linkedbhaagValue = initialData!.parentBhaagID.toString();
    //       populatelinkedNagarDropdown(_linkedbhaagValue, null);
    //     }
    //     if (initialData!.parentNagarID != null) {
    //       _isExpanded = true;
    //       _linkednagarDisable = true;
    //       _linkednagarValue = initialData!.parentNagarID.toString();
    //       populatelinkedMandalDropdown(_linkednagarValue);
    //       populatelinkedVastiDropdown(_linkednagarValue);
    //     }
    //     if (initialData!.parentMandalID != null) {
    //       _isExpanded = true;
    //       _linkedmandalDisable = true;
    //       _linkedmandalValue = initialData!.parentMandalID.toString();
    //       populatelinkedGraamDropdown(_linkedmandalValue);
    //     }
    //     if (initialData!.levelName == "Vasti" && initialData!.geoUnitID != null) {
    //       _isExpanded = true;
    //       _linkedvastiDisable = true;
    //       _linkedvastiValue = initialData!.geoUnitID.toString();
    //     } else if (initialData!.levelName == "Graam" && initialData!.geoUnitID != null) {
    //       _isExpanded = true;
    //       _linkedgraamDisable = true;
    //       _linkedgraamValue = initialData!.geoUnitID.toString();
    //     } else if (initialData!.levelName == "Mandal" && initialData!.geoUnitID != null) {
    //       _isExpanded = true;
    //       _linkedmandalDisable = true;
    //       _linkedmandalValue = initialData!.geoUnitID.toString();
    //       populatelinkedGraamDropdown(_linkedmandalValue);
    //     } else if (initialData!.levelName == "Nagar" && initialData!.geoUnitID != null) {
    //       _isExpanded = true;
    //       _linkednagarDisable = true;
    //       _linkednagarValue = initialData!.geoUnitID.toString();
    //       populatelinkedMandalDropdown(_linkednagarValue);
    //       populatelinkedVastiDropdown(_linkednagarValue);
    //     } else if (initialData!.levelName == "Bhaag" && initialData!.geoUnitID != null) {
    //       _isExpanded = true;
    //       _linkedbhaagDisable = true;
    //       _linkedbhaagValue = initialData!.geoUnitID.toString();
    //       populatelinkedNagarDropdown(_linkedbhaagValue, null);
    //     } else {
    //       _isExpanded = false;
    //       // _linkedgraamDisable = true;
    //       _linkedbhaagValue = null;
    //       _linkedshaharValue = null;
    //       _linkednagarValue = null;
    //       _linkedmandalValue = null;
    //       _linkedgraamValue = null;
    //       _linkedvastiValue = null;
    //     }
    //   });
    // }
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedMahaanagarDropdown() async {
    _linkedVibhaagValue = _linkedbhaagValue = _linkednagarValue = _linkedupnagarValue = _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = null;
    nagarList = [];
    List<GeoUnitMasterBAL> data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['MahaanagarLevelID'].toString(), '', '', '');
    setState(() {
      _linkedMahaanagar = data;
    });
    return data;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedVibhaagDropdown(String mahaanagarIDStr) async {
    _linkedbhaagValue = _linkednagarValue = _linkedupnagarValue = _linkedupnagarValue = _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = null;
    _linkedbhaagName = _linkednagarName = _linkedupnagar = _linkedupnagar = _linkedmandalName = _linkedgraamName = _linkedvastiName = null;
    nagarList = [];
    print("populatelinkedVibhaagDropdown $mahaanagarIDStr");
    var data;
    if (_selectedKaryakramLevelId == 7) {
      data = await Statics.getGeoUnitsByLevelAndParentForMandal(Statics.levels['VibhaagLevelID'].toString(), mahaanagarIDStr, (mahaanagarIDStr.isEmpty ? '' : 'Mahaanagar'), '');
    } else if (_selectedKaryakramLevelId == 6) {
      data = await Statics.getGeoUnitsByLevelAndParentForUpnagar(Statics.levels['VibhaagLevelID'].toString(), mahaanagarIDStr, (mahaanagarIDStr.isEmpty ? '' : 'Mahaanagar'), '');
    } else {
      data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['VibhaagLevelID'].toString(), mahaanagarIDStr, (mahaanagarIDStr.isEmpty ? '' : 'Mahaanagar'), '');
    }
    setState(() {
      _linkedVibhaag = data;
    });
    return data;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedBhaagDropdown(String vibhaagIDStr) async {
    _linkedbhaagValue = _linkednagarValue = _linkedupnagarValue = _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = null;
    _linkedbhaagName = _linkednagarName = _linkedupnagar = _linkedmandalName = _linkedgraamName = _linkedvastiName = null;
    _linkedbhaag = _linkednagar = _linkedmandal = _linkedgraam = _linkedvasti = [];
    nagarList = [];
    var data;
    if (_selectedKaryakramLevelId == 7) {
      data = await Statics.getGeoUnitsByLevelAndParentForMandal(Statics.levels['BhaagLevelID'].toString(), vibhaagIDStr, 'Vibhaag', '');
    } else if (_selectedKaryakramLevelId == 6) {
      data = await Statics.getGeoUnitsByLevelAndParentForUpnagar(Statics.levels['BhaagLevelID'].toString(), vibhaagIDStr, 'Vibhaag', '');
    } else {
      data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['BhaagLevelID'].toString(), vibhaagIDStr, 'Vibhaag', '');
    }
    setState(() {
      _linkedbhaag = data;
    });
    return data;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedShaharDropdown(String bhaagIDStr) async {
    _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = null;
    _linkedmandalName = _linkedgraamName = _linkedvastiName = null;
    nagarList = [];
    var shDD;
    if (_selectedKaryakramLevelId == 7) {
      shDD = await Statics.getGeoUnitsByLevelAndParentForMandal(Statics.levels['ShaharLevelID'].toString(), bhaagIDStr, 'Bhaag', '');
    } else if (_selectedKaryakramLevelId == 6) {
      shDD = await Statics.getGeoUnitsByLevelAndParentForUpnagar(Statics.levels['ShaharLevelID'].toString(), bhaagIDStr, 'Bhaag', '');
    } else {
      shDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['ShaharLevelID'].toString(), bhaagIDStr, 'Bhaag', '');
    }
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
    nagarList = [];
    print("print LevelID > ${Statics.userDetails["LevelID"]}");
    if (_selectedKaryakramLevelId == 7) {
      ngDD = await Statics.getGeoUnitsByLevelAndParentForMandal(Statics.levels['NagarLevelID'].toString(), bhaagIDStr!, 'Bhaag', '');
      setState(() {
        _linkednagar = (ngDD.length > 0 ? ngDD : null);
      });
    } else if (_selectedKaryakramLevelId == 6) {
      ngDD = await Statics.getGeoUnitsByLevelAndParentForUpnagar(Statics.levels['NagarLevelID'].toString(), bhaagIDStr!, 'Bhaag', '');
      setState(() {
        _linkednagar = (ngDD.length > 0 ? ngDD : null);
      });
    } else {
      ngDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['NagarLevelID'].toString(), bhaagIDStr!, 'Bhaag', '');
      setState(() {
        _linkednagar = (ngDD.length > 0 ? ngDD : null);
      });
    }
    return ngDD;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedUpnagarDropdown(String? nagarIDStr) async {
    _linkedupnagarValue = _linkedmandalValue = _linkedgraamValue = null;
    _linkedupnagarName = _linkedmandalName = _linkedgraamName = null;
    _linkedupnagar = _linkedmandal = _linkedgraam = null;
    nagarList = [];
    var mnDD;
    if (_selectedKaryakramLevelId == 7) {
      mnDD = await Statics.getGeoUnitsByLevelAndParentForMandal(Statics.levels['UpaNagarLevelID'].toString(), nagarIDStr!, 'Nagar', '');
    } else if (_selectedKaryakramLevelId == 6) {
      mnDD = await Statics.getGeoUnitsByLevelAndParentForUpnagar(Statics.levels['UpaNagarLevelID'].toString(), nagarIDStr!, 'Nagar', '');
    } else {
      mnDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['UpaNagarLevelID'].toString(), nagarIDStr!, 'Nagar', '');
    }
    setState(() {
      _linkedupnagar = (mnDD.length > 0 ? mnDD : null);
    });
    return mnDD;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedMandalDropdown(String parentType, String? nagarIDStr) async {
    _linkedmandalValue = _linkedgraamValue = null;
    _linkedmandalName = _linkedgraamName = null;
    _linkedmandal = _linkedgraam = null;
    nagarList = [];
    var mnDD;
    if (_selectedKaryakramLevelId == 7) {
      mnDD = await Statics.getGeoUnitsByLevelAndParentForMandal(Statics.levels['MandalLevelID'].toString(), nagarIDStr!, parentType, '');
    } else if (_selectedKaryakramLevelId == 6) {
      mnDD = await Statics.getGeoUnitsByLevelAndParentForUpnagar(Statics.levels['MandalLevelID'].toString(), nagarIDStr!, parentType, '');
    } else {
      mnDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['MandalLevelID'].toString(), nagarIDStr!, parentType, '');
    }
    setState(() {
      _linkedmandal = (mnDD.length > 0 ? mnDD : null);
    });
    return mnDD;
  }

  // Future<List<GeoUnitMasterBAL>> populatelinkedGraamDropdown(String? mandalIDStr) async {
  //   _linkedgraamValue = null;
  //   _linkedgraamName = null;
  //   var gmDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['GraamLevelID'].toString(), mandalIDStr!, 'Mandal', '');
  //   setState(() {
  //     _linkedgraam = (gmDD.length > 0 ? gmDD : null);
  //   });
  //   return gmDD;
  // }

  // Future<List<GeoUnitMasterBAL>> populatelinkedVastiDropdown(String parentType, String? nagarIDStr) async {
  //   _linkedvastiValue = null;
  //   _linkedvastiName = null;
  //   var vsDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['VastiLevelID'].toString(), nagarIDStr!, parentType, '');
  //   setState(() {
  //     _linkedvasti = (vsDD.length > 0 ? vsDD : null);
  //   });
  //   return vsDD;
  // }

  //////////////////////////////////////////////////////////////////////////////////////

  // List<LocationCard> _card = [
  //   LocationCard(
  //     district: Statics.getLabel("Bhaag"),
  //     taluka: 'Taluka',
  //     date: '25/03/2026',
  //     locationName: 'मुंबई -> परळ -> मुंबा देवी',
  //   ),
  //   LocationCard(
  //     district: Statics.getLabel("Nagar"),
  //     taluka: 'Taluka',
  //     date: '20/03/2026',
  //     locationName: 'ठाणे -> वसई -> निर्मळ',
  //   ),
  //   LocationCard(
  //     district: Statics.getLabel("Mandal"),
  //     taluka: 'Taluka',
  //     date: '29/03/2026',
  //     locationName: 'पालघर -> वाडा -> मौज',
  //   ),
  //   LocationCard(
  //     district: Statics.getLabel("Bhaag"),
  //     taluka: 'Taluka',
  //     date: '02/04/2026',
  //     locationName: 'मुंबई -> गोरेगाव -> बोरिवली',
  //   )
  // ];

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      // appBar: AppBar(
      //   title: Text(
      //     "${Statics.getLabel('selectKaryakramLevel')}",
      //     style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
      //   ),
      // ),
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: () => Navigator.of(context).pushNamed(SadbhavCenterCreationScreen.routeName),
      //   backgroundColor: Colors.green.shade400,
      //   label: Icon(Icons.add),
      // ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            children: [
              SizedBox(height: 12),
              stharDropdown(),
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  buildFilterChips(),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), side: BorderSide(color: Colors.purple, width: 0.7)),
                    onPressed: () => Navigator.of(context).pushNamed(AddNewKaryakramScreen.routeName).then(
                          (value) => getKendraListData(),
                        ),
                    child: Text("+  " + Statics.getLabel("addKaryakram")),
                  )
                ],
              ),
              SizedBox(height: 24),
              // myAreaReport(),
              kendraList.isEmpty
                  ? SizedBox(
                      height: 270,
                      child: Center(
                        child: Text(
                          Statics.getLabel("NoDataFound"),
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                    )
                  : ListView.separated(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      padding: EdgeInsets.only(bottom: 24, top: 16),
                      itemCount: kendraList.length,
                      separatorBuilder: (context, index) => SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final _item = kendraList[index];
                        return Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // ── Top Row ──────────────────────────────────────────────
                                Row(
                                  children: [
                                    // District tag
                                    Expanded(
                                      child: Wrap(
                                        children: [
                                          _TagChip(label: karyakramLevelsList.firstWhere((e) => e.values.first == _item.shatapdistharlevelid).keys.first),
                                          const SizedBox(width: 6),

                                          // // Taluka tag
                                          // _TagChip(label: _item.taluka),
                                          // const SizedBox(width: 6),

                                          // Date tag
                                          _TagChip(
                                              label: _item.yuvadate ?? "--",
                                              icon: Icons.calendar_today,
                                              iconColor: Colors.grey,
                                              onEditTap: () => showEditDatePopup(_item.yuvadate.toString(), _item.pkid)),
                                        ],
                                      ),
                                    ),

                                    // Fill button
                                    InkWell(
                                      onTap: () => deleteYuvaSangam(_item.pkid ?? 0),
                                      child: Container(
                                        padding: EdgeInsets.all(6),
                                        decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.red.withOpacity(0.4)),
                                        child: Icon(
                                          Icons.delete_forever_outlined,
                                          color: Colors.red,
                                          size: 16,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 12),

                                // ── Location Name Row ─────────────────────────────────────
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.location_on,
                                      color: Color(0xFF3B82F6),
                                      size: 20,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      _item.trailNames ?? _item.name ?? "--",
                                      style: const TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF1E293B),
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 12),

                                // ── Divider ───────────────────────────────────────────────
                                const Divider(height: 1, color: Color(0xFFE2E8F0)),

                                const SizedBox(height: 10),

                                // ── Edit Button ───────────────────────────────────────────
                                Center(
                                  child: GestureDetector(
                                    onTap: () => Navigator.of(context).pushNamed(YuvaSangamFormScreen.routeName, arguments: {
                                      "pkid": _item.pkid,
                                      "type": karyakramLevelsList.firstWhere((e) => e.values.first == _item.shatapdistharlevelid).keys.first,
                                      "date": _item.yuvadate,
                                      "geo": _item.trailNames,
                                    }).then((value) => getKendraListData()),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.edit_outlined,
                                          size: 16,
                                          color: _item.isstarted == 0 ? Color(0xFF008719) : Color(0xFFD37B31),
                                        ),
                                        SizedBox(width: 5),
                                        Text(
                                          Statics.getLabel(_item.isstarted == 0 ? "vruttaFillTitle" : "vruttaEditTitle"),
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: _item.isstarted == 0 ? Color(0xFF008719) : Color(0xFFD37B31),
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
              // SizedBox(height: 18),
              // Row(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   children: [
              //     Text(
              //       "* " + Statics.getLabel('Note') + " : ",
              //       style: TextStyle(color: Colors.red.shade700, fontWeight: FontWeight.w600, decoration: TextDecoration.underline, decorationColor: Colors.red, fontStyle: FontStyle.italic),
              //     ),
              //     Expanded(
              //       child: Text(
              //         Statics.getLabel('sanvaadTip'),
              //         style: TextStyle(color: Colors.grey.shade700, fontWeight: FontWeight.w600, fontStyle: FontStyle.italic),
              //       ),
              //     ),
              //   ],
              // ),
              // SizedBox(height: 12),
              // otherAreaReport(),
              // SizedBox(height: 90),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildFilterChips() {
    return Row(
      children: [
        FilterChip(
          label: Text(Statics.getLabel("Level")),
          selected: !dateWise,
          onSelected: (selected) {
            if (selected) {
              setState(() {
                dateWise = false;
              });
              getKendraListData();
            }
          },
        ),
        const SizedBox(width: 10),
        FilterChip(
          label: Text(Statics.getLabel("date2")),
          selected: dateWise,
          onSelected: (selected) {
            if (selected) {
              setState(() {
                dateWise = true;
              });
              getKendraListData();
            }
          },
        ),
      ],
    );
  }

  Widget stharDropdown() {
    return Container(
      // margin: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(width: 0.7, color: Colors.grey.shade700),
      ),
      child: ExpansionPanelList(
        elevation: 0,
        expandedHeaderPadding: EdgeInsets.zero,
        expansionCallback: (int index, bool isExpanded) {
          setState(() {
            _isExpanded = isExpanded;
          });
        },
        children: [
          ExpansionPanel(
            backgroundColor: Colors.transparent,
            headerBuilder: (BuildContext context, bool isExpanded) {
              return ListTile(
                title: Text(
                  "${Statics.getLabel('selectStar')}",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              );
            },
            body: Container(
              margin: EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildDropdownField(
                    // ignoring: dateController.text.isEmpty || (baithakId != null && baithakId != 0),
                    label: Statics.getLabel('selectStar'),
                    value: _selectedKaryakramLevelId == null ? null : _selectedKaryakramLevelId.toString(),
                    items: karyakramLevelsList
                        .map((bg) => DropdownMenuItem(
                              value: bg.values.first.toString(),
                              child: Text(bg.keys.first),
                            ))
                        .toList(),
                    // onTap: dateController.text.isEmpty ? null : () {},
                    onChanged: (value) async {
                      await populateDropdown();
                      _searched = false;
                      // dateController.clear();
                      setState(() => _selectedKaryakramLevelId = int.tryParse(value.toString()));
                      nagarList = [];
                      // print("baithakId >>>>>>>>>>>>>>>> ${baithakId}");
                      await getKendraListData();
                      await populateDropdown();
                    },
                    isDisabled: false,
                  ),
                  SizedBox(height: 18),
                  nagarDropdown(),
                  SizedBox(height: 18),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (_selectedGeoUnitId != null && _selectedGeoUnitId!.isNotEmpty)
                        MaterialButton(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                          padding: EdgeInsets.symmetric(
                            horizontal: 35,
                            vertical: 5,
                          ),
                          color: Theme.of(context).primaryColor,
                          textColor: Theme.of(context).primaryTextTheme.labelMedium?.color,
                          onPressed: getKendraListData,
                          child: Text(
                            Statics.getLabel('search'),
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      MaterialButton(onPressed: clearForm, child: Text(Statics.getLabel('clear'))),
                    ],
                  ),
                ],
              ),
            ),
            isExpanded: _isExpanded,
          ),
        ],
      ),
    );
  }

  Widget nagarDropdown() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        children: [
          if (![6, 7].contains(_selectedKaryakramLevelId) && _linkedMahaanagar != null)
            _buildDropdownField(
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
              isDisabled: false,
            ),
          if (_linkedVibhaag != null)
            _buildDropdownField(
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
              isDisabled: false,
            ),
          if (_linkedbhaag != null && _linkedbhaag!.isNotEmpty)
            _buildDropdownField(
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
              isDisabled: false,
            ),
          if ([5, 6, 7].contains(_selectedKaryakramLevelId) && _linkednagar != null && _linkednagar!.isNotEmpty)
            _buildDropdownField(
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
                  populatelinkedMandalDropdown('Nagar', value);
                  // populatelinkedVastiDropdown('Nagar', value);
                });
              },
              isDisabled: false,
            ),
          if ([6, 7].contains(_selectedKaryakramLevelId) && _linkedupnagar != null && _linkedupnagar!.isNotEmpty)
            _buildDropdownField(
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
                  populatelinkedMandalDropdown('Upnagar', value);
                  // populatelinkedVastiDropdown('Upnagar', value);
                });
              },
              isDisabled: false,
            ),
          if ([7].contains(_selectedKaryakramLevelId) && _linkedmandal != null && _linkedmandal!.isNotEmpty)
            _buildDropdownField(
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
                  // populatelinkedGraamDropdown(value);
                });
              },
              isDisabled: false,
            ),
          // if (_linkedgraam != null && _linkedgraam!.isNotEmpty)
          //   _buildDropdownField(
          //     label: Statics.getLabel('Graam'),
          //     value: _linkedgraamValue,
          //     items: _linkedgraam!
          //         .map((bg) => DropdownMenuItem(
          //               value: bg.geoUnitID.toString(),
          //               child: Text(bg.name!),
          //             ))
          //         .toList(),
          //     onChanged: (value) {
          //       final selectedItem = _linkedgraam!.firstWhere((bg) => bg.geoUnitID.toString() == value);
          //       setState(() {
          //         _linkedgraamValue = value;
          //         _selectedGeoUnitId = value.toString();
          //         _selctedLevel = 'Graam';
          //         _selctedLevelName = selectedItem.name ?? "";
          //         _linkedgraamName = selectedItem.name ?? "";
          //       });
          //     },
          //     isDisabled: false,
          //   ),
          // if (_linkedvasti != null && _linkedvasti!.isNotEmpty)
          //   _buildDropdownField(
          //     label: Statics.getLabel('Vasti'),
          //     value: _linkedvastiValue,
          //     items: _linkedvasti!
          //         .map((bg) => DropdownMenuItem(
          //               value: bg.geoUnitID.toString(),
          //               child: Text(bg.name!),
          //             ))
          //         .toList(),
          //     onChanged: (value) {
          //       final selectedItem = _linkedvasti!.firstWhere((bg) => bg.geoUnitID.toString() == value);
          //       setState(() {
          //         _linkedvastiValue = value;
          //         _selectedGeoUnitId = value.toString();
          //         _selctedLevel = 'Vasti';
          //         _selctedLevelName = selectedItem.name ?? "";
          //         _linkedvastiName = selectedItem.name ?? "";
          //       });
          //     },
          //     isDisabled: false,
          //   ),
          SizedBox(height: 15),
        ],
      ),
    );
  }

  Widget _buildDropdownField({
    bool? ignoring,
    required String label,
    required String? value,
    required List<DropdownMenuItem<String>>? items,
    required ValueChanged<String?>? onChanged,
    required bool isDisabled,
    void Function()? onTap,
  }) {
    return IgnorePointer(
      ignoring: ignoring ?? _isViewOnly,
      child: DropdownButtonFormField(
        decoration: InputDecoration(labelText: label),
        isExpanded: true,
        value: value == "" ? null : value,
        items: items,
        onTap: onTap,
        onChanged: onChanged,
      ),
    );
  }
}

class LocationCard {
  final String district;
  final String taluka;
  final String date;
  final String locationName;

  const LocationCard({
    required this.district,
    required this.taluka,
    required this.date,
    required this.locationName,
  });
}

// ── Reusable Tag Chip ─────────────────────────────────────────────────────────
class _TagChip extends StatelessWidget {
  final String label;
  final IconData? icon;
  final Color? iconColor;
  final VoidCallback? onEditTap;

  const _TagChip({
    required this.label,
    this.icon,
    this.iconColor,
    this.onEditTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onEditTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Row(
          spacing: 4,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) Icon(icon, size: 11, color: iconColor ?? Colors.grey),
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                color: Color(0xFF475569),
                fontWeight: FontWeight.w500,
              ),
            ),
            if (onEditTap != null) Icon(Icons.edit, size: 11, color: Colors.blueGrey.shade700),
          ],
        ),
      ),
    );
  }
}

// ── Fill Button ───────────────────────────────────────────────────────────────
class _FillButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _FillButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        decoration: BoxDecoration(
          color: const Color(0xFF3B82F6),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
