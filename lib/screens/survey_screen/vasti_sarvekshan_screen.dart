import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:excel/excel.dart' as exc;
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../helpers/static_data.dart' as Statics;
import '../../models/response_model/dropdown_level_responsemodel.dart';
import '../../models/response_model/vasti_sarvekshan_resp_model.dart';
import '../../providers/bals.dart';
import '../../utils/globals.dart';

class VastiSarvekshanScreen extends StatefulWidget {
  static const String routeName = '/vasti-sarvekshan-view';

  const VastiSarvekshanScreen({super.key});

  @override
  State<VastiSarvekshanScreen> createState() => _VastiSarvekshanScreenState();
}

class _VastiSarvekshanScreenState extends State<VastiSarvekshanScreen> {
  bool _isExpanded = true;
  bool _searched = false;
  bool fromVasti = false;

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
  String? _linkedNagarValuePopup = '';
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
  String? selectedType;

  VastiSarvekshanRespModel? data;

  List<String> typeList = [
    "vasahat",
    "sajjan",
    "anya",
    "mahatvacesana",
    "samajikkaryakram",
    "mothevyavasayi",
    "motherugnalaya",
    "school",
    "maidan",
    "karyakram",
    "dhaarmik",
    "durjan",
    "hinduvirayadi",
  ];

  @override
  void initState() {
    super.initState();
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

  Future<void> populateAllDropdowns(int level, DropDownModel dm) async {
    setState(() {
      _selectedGeoUnitId = _linkedMahaanagarValue = _linkedbhaagValue = _linkednagarValue = _linkedupnagarValue = _linkedvastiValue = null;
    });
    final selection = prepareSelection(dm);

    // Step 1: Mahaanagar
    await populatelinkedMahaanagarDropdown();
    _linkedMahaanagarValue = (level == 9 ? (dm.geoUnitID ?? "").toString() : selection.mahaanagar) ?? '';
    if (level == 9) {
      _selectedGeoUnitId = (dm.geoUnitID ?? selection.mahaanagar).toString();
      _selctedLevel = 'Mahaanagar';
      final selectedItem = _linkedMahaanagar!.firstWhere((bg) => bg.geoUnitID.toString() == _selectedGeoUnitId);
      _selctedLevelName = selectedItem.name;
    }

    // Step 2: Vibhaag
    await populatelinkedVibhaagDropdown(_linkedMahaanagarValue!);
    _linkedVibhaagValue = (level == 8 ? (dm.geoUnitID ?? "").toString() : selection.vibhaag) ?? '';
    if (level == 8) {
      _selectedGeoUnitId = (dm.geoUnitID ?? selection.vibhaag).toString();
      _selctedLevel = 'Vibhaag';
      final selectedItem = _linkedVibhaag!.firstWhere((bg) => bg.geoUnitID.toString() == _selectedGeoUnitId);
      _selctedLevelName = selectedItem.name;
    }

    // Step 3: Bhaag
    await populatelinkedBhaagDropdown(_linkedVibhaagValue!);
    _linkedbhaagValue = (level == 7 ? (dm.geoUnitID ?? "").toString() : selection.bhaag) ?? '';
    if (level == 7) {
      _selectedGeoUnitId = (dm.geoUnitID ?? selection.bhaag).toString();
      _selctedLevel = 'Bhaag';
      final selectedItem = _linkedbhaag!.firstWhere((bg) => bg.geoUnitID.toString() == _selectedGeoUnitId);
      _selctedLevelName = selectedItem.name;
    }

    // Step 4: Nagar
    await populatelinkedNagarDropdown(_linkedbhaagValue, null);
    _linkednagarValue = (level == 6 ? (dm.geoUnitID ?? "").toString() : selection.nagar) ?? '';
    if (level == 6) {
      _selectedGeoUnitId = (dm.geoUnitID ?? selection.nagar).toString();
      _selctedLevel = 'Nagar';
      final selectedItem = _linkednagar!.firstWhere((bg) => bg.geoUnitID.toString() == _selectedGeoUnitId);
      _selctedLevelName = selectedItem.name;
      // getMyDetailsColumnsAndRows();
    }

    // Step 5: Upnagar (conditional)
    await populatelinkedUpnagarDropdown(_linkednagarValue);
    if (selection.upnagar != null && selection.upnagar!.isNotEmpty) {
      _linkedupnagarValue = (level == 13 ? (dm.geoUnitID ?? "").toString() : selection.upnagar) ?? '';
      if (level == 13) {
        _selectedGeoUnitId = (dm.geoUnitID ?? selection.upnagar).toString();
        _selctedLevel = 'Upnagar';
        final selectedItem = _linkedupnagar!.firstWhere((bg) => bg.geoUnitID.toString() == _selectedGeoUnitId);
        _selctedLevelName = selectedItem.name;
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
      (selection.upnagar != null && selection.upnagar!.isNotEmpty) ? _linkedupnagarValue! : _linkednagarValue!,
    );
    _linkedvastiValue = (level == 2 ? (dm.geoUnitID ?? "").toString() : selection.vasti) ?? '';
    if (level == 2) {
      _selectedGeoUnitId = (dm.geoUnitID ?? selection.vasti).toString();
      _selctedLevel = 'Vasti';
      // _getForm();
    }
    // if (_linkedVibhaag != null && _linkedVibhaag!.isNotEmpty) _linkedVibhaagName = _linkedVibhaag!.firstWhere((bg) => bg.geoUnitID.toString() == _linkedbhaagValue).name;
    // if (_linkedbhaag != null && _linkedbhaag!.isNotEmpty) _linkedbhaagName = _linkedbhaag!.firstWhere((bg) => bg.geoUnitID.toString() == _linkedbhaagValue).name;
    // if (_linkednagar != null && _linkednagar!.isNotEmpty) _linkednagarName = _linkednagar!.firstWhere((bg) => bg.geoUnitID.toString() == _linkedbhaagValue).name;

    setState(() {});
  }

  clearForm() async {
    setState(() {
      _selectedGeoUnitId = null;
      selectedType = null;
    });
    await populateDropdown();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fromVasti = ModalRoute.of(context)?.settings.arguments as bool? ?? false;

    print("fromVasti :----$fromVasti");
  }

  //////////////////////////////////////////////////////////////////////////////////////

  Future<void> populateDropdown({bool fromClear = false}) async {
    setState(() {
      _linkedMahaanagarValue = _linkedbhaagValue = _linkedshaharValue = _linkednagarValue = _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = null;
    });
    await populatelinkedMahaanagarDropdown();
    await populatelinkedVibhaagDropdown('');
    setState(() {});
    if (fromClear || userLevelId == null || ddm == null) {
      return;
    }
    setState(() {
      _linkedMahaanagarValue = _linkedbhaagValue = _linkednagarValue = _linkedupnagarValue = _linkedgraamValue = _linkedvastiValue = null;
    });
    await populateAllDropdowns(userLevelId!, ddm!);
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedMahaanagarDropdown() async {
    _linkedVibhaagValue = _linkedbhaagValue = _linkednagarValue = _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = null;
    List<GeoUnitMasterBAL> data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['MahaanagarLevelID'].toString(), '', '', '', isAbhiyaan: false);
    setState(() {
      _linkedMahaanagar = data;
    });
    return data;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedVibhaagDropdown(String mahaanagarIDStr) async {
    _linkedbhaagValue = _linkednagarValue = _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = null;
    _linkedbhaagName = _linkednagarName = _linkedmandalName = _linkedgraamName = _linkedvastiName = null;
    print("populatelinkedVibhaagDropdown $mahaanagarIDStr");
    var data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['VibhaagLevelID'].toString(), mahaanagarIDStr, (mahaanagarIDStr.isEmpty ? '' : 'Mahaanagar'), '', isAbhiyaan: false);
    setState(() {
      _linkedVibhaag = data;
    });
    return data;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedBhaagDropdown(String vibhaagIDStr) async {
    _linkedbhaagValue = _linkednagarValue = _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = null;
    _linkedbhaagName = _linkednagarName = _linkedmandalName = _linkedgraamName = _linkedvastiName = null;
    _linkedbhaag = _linkednagar = _linkedmandal = _linkedgraam = _linkedvasti = [];
    var data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['BhaagLevelID'].toString(), vibhaagIDStr, 'Vibhaag', '', isAbhiyaan: false);
    setState(() {
      _linkedbhaag = data;
    });
    return data;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedShaharDropdown(String bhaagIDStr) async {
    _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = null;
    _linkedmandalName = _linkedgraamName = _linkedvastiName = null;
    var shDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['ShaharLevelID'].toString(), bhaagIDStr, 'Bhaag', '', isAbhiyaan: false);
    setState(() {
      _linkedshahar = (shDD.length > 0 ? shDD : null);
    });
    return shDD;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedNagarDropdown(String? bhaagIDStr, String? shaharIDStr) async {
// print("populatelinkedNagarDropdown ${bhaagIDStr} == ${shaharIDStr}  ");
    _linkednagarValue = _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = null;
    _linkednagarName = _linkedmandalName = _linkedgraamName = _linkedvastiName = null;
    _linkednagar = _linkedmandal = _linkedgraam = _linkedvasti = null;
    print("print LevelID > ${Statics.userDetails["LevelID"]}");
    print("shaharIDStr shaharIDStr $shaharIDStr");
    if (shaharIDStr != null) {
      var ngDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['NagarLevelID'].toString(), shaharIDStr!, 'Shahar', '', isAbhiyaan: false);
      setState(() {
        _linkednagar = (ngDD.length > 0 ? ngDD : null);
      });
      return ngDD;
    } else {
      var ngDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['NagarLevelID'].toString(), bhaagIDStr!, 'Bhaag', '', isAbhiyaan: false);
      setState(() {
        _linkednagar = (ngDD.length > 0 ? ngDD : null);
      });
      return ngDD;
    }
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedUpnagarDropdown(String? nagarIDStr) async {
    _linkedupnagarValue = _linkedvastiValue = null;
    _linkedupnagar = _linkedvasti = null;
    var mnDD;

    mnDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['UpaNagarLevelID'].toString(), nagarIDStr!, 'Nagar', '');

    setState(() {
      _linkedupnagar = (mnDD.length > 0 ? mnDD : null);
      //_linkedupnagarValue = (userparentUpanagarid ?? userGeoUnitId).toString();
    });

    return mnDD;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedMandalDropdown(bool haveParentUp, String? nagarIDStr) async {
    _linkedmandalValue = _linkedgraamValue = null;
    _linkedmandalName = _linkedgraamName = null;
    _linkedmandal = _linkedgraam = null;
    var mnDD;
    if (haveParentUp) {
      mnDD = await Statics.getGeoUnitsByLevelAndParentForUpnagar(Statics.levels['MandalLevelID'].toString(), nagarIDStr!, "Upnagar", '');
    } else {
      mnDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['MandalLevelID'].toString(), nagarIDStr!, "Nagar", '');
    }
    setState(() {
      _linkedmandal = (mnDD.length > 0 ? mnDD : null);
    });
    return mnDD;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedGraamDropdown(String? mandalIDStr) async {
    _linkedgraamValue = null;
    _linkedgraamName = null;
    var gmDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['GraamLevelID'].toString(), mandalIDStr!, 'Mandal', '', isAbhiyaan: false);
    setState(() {
      _linkedgraam = (gmDD.length > 0 ? gmDD : null);
    });
    return gmDD;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedVastiDropdown(bool haveParentUp, String? nagarIDStr) async {
    _linkedvastiValue = null;
    _linkedvastiName = null;
    var vsDD;
    if (haveParentUp) {
      print("i am in parents upnagar");
      vsDD = await Statics.getGeoUnitsByLevelAndParentForUpnagar(Statics.levels['VastiLevelID'].toString(), nagarIDStr!, "Upnagar", '');
      // print("${mnDD}");
    } else {
      vsDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['VastiLevelID'].toString(), nagarIDStr!, "Nagar", '');
    }
    setState(() => _linkedvasti = (vsDD.length > 0 ? vsDD : null));
    return vsDD;
  }

  //////////////////////////////////////////////////////////////////////////////////////

  getReportDataFun() async {
    setState(() {
      data = null;
      // _isLoading = true;
    });
    Map<String, dynamic> formData = {
      "GeoUnitID": int.tryParse(_selectedGeoUnitId ?? "0") ?? 0,
      "type": selectedType,
      "AppUserID": int.tryParse(Statics.userDetails['userID']) ?? null,
    };

    String formattedJson = const JsonEncoder.withIndent('  ').convert(formData);
    log("Form Data (JSON):\n$formattedJson");
    data = await Statics.getVastiSarvekshanDataDump(context, formData);
    // log("vijayadashamiReport >>>>>>>>>>>>>>>>> ${jsonDecode(jsonEncode(vijayadashamiReport))}");
    setState(() {
      data;
    });
  }

  List<dynamic> getSelectedList() {
    if (data == null || selectedType == null) return [];

    switch (selectedType) {
      case "vasahat":
        return data?.vasahatList ?? [];
      case "sajjan":
        return data?.sajjanList ?? [];
      case "anya":
        return data?.anyaList ?? [];
      case "mahatvacesana":
        return data?.mahatvaCesanaList ?? [];
      case "samajikkaryakram":
        return data?.samajikKaryakramList ?? [];
      case "mothevyavasayi":
        return data?.motheVyavasayiList ?? [];
      case "motherugnalaya":
        return data?.motherUgnalayaList ?? [];
      case "school":
        return data?.schoolList ?? [];
      case "maidan":
        return data?.maidanList ?? [];
      case "karyakram":
        return data?.karyakramList ?? [];
      case "dhaarmik":
        return data?.dharmikList ?? [];
      case "durjan":
        return data?.durjanList ?? [];
      case "hinduvirayadi":
        return data?.hinduVirayadiList ?? [];
      default:
        return [];
    }
  }

  List<dynamic> selectedList = [];

  Future<void> exportSelectedTypeToExcel() async {
    final list = getSelectedList();

    if (list.isEmpty) {
      print("No data to export");
      return;
    }

    // Ask storage permission
    await Permission.storage.request();

    var excel = exc.Excel.createExcel();
    exc.Sheet sheet = excel['Report'];

    // Original keys
    final keys = list.first.toJson().keys.toList();

    // Formatted headers
    final translatedHeader = keys.map((k) => Statics.getLabel(k.toString().toLowerCase(), returnKey: true)).toList();

    // 🔹 Header row
    sheet.appendRow(translatedHeader);

    // 🔹 Blank row (space between header & data)
    sheet.appendRow(List.filled(translatedHeader.length, ""));

    // Generate headers
    final headers = list.first.toJson().keys.toList();

    // Data rows
    for (var item in list) {
      final json = item.toJson();
      sheet.appendRow(headers.map((h) => json[h]?.toString() ?? "").toList());
    }

    // Save file
    Directory directory;

    if (Platform.isAndroid) {
      directory = (await getExternalStorageDirectory())!;
    } else {
      directory = await getApplicationDocumentsDirectory();
    }

    final filePath = "${directory.path}/${selectedType}_${DateTime.now().millisecondsSinceEpoch}.xlsx";

    final fileBytes = excel.encode();
    final file = File(filePath);
    await file.writeAsBytes(fileBytes!);

    print("Excel Exported: $filePath");

    // 🔹 Open the file using OpenFilex
    await OpenFilex.open(filePath);
  }

  /////////////////////////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          Statics.getLabel(fromVasti ? 'vastiSurveyReport' : 'mandalSurveyReport'),
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      // drawer: AppDrawer(),
      floatingActionButton: _searched && selectedList.isNotEmpty
          ? FloatingActionButton(
              tooltip: Statics.getLabel("ExportToExcel"),
              onPressed: exportSelectedTypeToExcel,
              child: Icon(Icons.download_sharp),
              backgroundColor: Colors.green,
            )
          : null,
      body: Column(
        children: [
          vastiMandalDropdown(),
          if (_searched) ...[
            SizedBox(height: 18),
            if (_selctedLevel != "" && _selctedLevelName != "")
              Container(
                height: 40,
                margin: EdgeInsets.symmetric(horizontal: 16),
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
                      "${Statics.getLabel(_selctedLevel ?? "Mahaanagar")}  ->  ",
                      style: TextStyle(color: Colors.purpleAccent, fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(
                      " $_selctedLevelName",
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 17),
                    ),
                  ],
                ),
              ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Divider(color: Colors.black),
            ),
            SizedBox(height: 18),
            Expanded(
              child: selectedList.isEmpty
                  ? Center(
                      child: Text("No Data Found"),
                    )
                  : Scrollbar(
                      thumbVisibility: true,
                      child: ListView.builder(
                        padding: EdgeInsets.only(right: 16, left: 16, top: 8, bottom: 90),
                        itemCount: selectedList.length,
                        itemBuilder: (context, index) {
                          final item = selectedList[index];

                          return commonInfoCard(
                            item,
                            () => showPersonDetailsPopup(context, item, index + 1),
                          );
                        },
                      ),
                    ),
            )
          ]
        ],
      ),
    );
  }

  Widget vastiMandalDropdown() {
    return Container(
      // margin: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(width: 0.7, color: Colors.grey.shade700),
      ),
      margin: EdgeInsets.only(left: 16, right: 16, top: 24),
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
                  "${Statics.getLabel('selectVastiMandal')}",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              );
            },
            body: Container(
              margin: EdgeInsets.all(10),
              child: Column(
                children: [
                  if (_linkedMahaanagar != null)
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
                          _selctedLevel = 'Mahanagar';
                          _selctedLevelName = selectedItem.name ?? "";
                          _selectedGeoUnitId = value;
                          // _linkedMahaanagarName = selectedItem.name ?? "";
                          // _resetLinkedValues();
                        });
                        populatelinkedVibhaagDropdown(value!);
                        populatelinkedBhaagDropdown("");
                      },
                      isDisabled: ((userLevelId ?? 0) < 9 || (userLevelId ?? 0) == 13),
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
                          _selctedLevel = 'Vibhaag';
                          _selctedLevelName = selectedItem.name ?? "";
                          _selectedGeoUnitId = value;
                          // _linkedVibhaagName = selectedItem.name ?? "";
                        });
                        populatelinkedBhaagDropdown(value!);
                      },
                      isDisabled: ((userLevelId ?? 0) < 8 || (userLevelId ?? 0) == 13),
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
                          _selctedLevel = 'Bhaag';
                          _selctedLevelName = selectedItem.name ?? "";
                          _linkedbhaagName = selectedItem.name ?? "";
                          _selectedGeoUnitId = value;
                        });
                        populatelinkedShaharDropdown(value!);
                        populatelinkedNagarDropdown(value, null);
                      },
                      isDisabled: ((userLevelId ?? 0) < 7 || (userLevelId ?? 0) == 13),
                    ),
                  /*if (_linkedshahar != null && _linkedshahar!.isNotEmpty)
                    _buildDropdownField(
                      label: Statics.getLabel('Shahar'),
                      value: _linkedshaharValue,
                      items: _linkedshahar!
                          .map((bg) => DropdownMenuItem(
                                value: bg.geoUnitID.toString(),
                                child: Text(bg.name!),
                              ))
                          .toList(),
                      onChanged: (value) {
                        final selectedItem = _linkedshahar!.firstWhere((bg) => bg.geoUnitID.toString() == value);
                        setState(() {
                          _linkedshaharValue = value;
                          _selectedGeoUnitId = value;
                          _selctedLevel = 'Shahar';
                          _selctedLevelName = selectedItem.name ?? "";
                          _linkedshaharName = selectedItem.name ?? "";
                          populatelinkedNagarDropdown(null, value);
                        });
                      },
                      isDisabled: ((userLevelId ?? 0) < 7 || (userLevelId ?? 0) == 13),
                    ),*/
                  if (_linkednagar != null && _linkednagar!.isNotEmpty)
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
                          _selctedLevel = 'Nagar';
                          _selctedLevelName = selectedItem.name ?? "";
                          _linkednagarName = selectedItem.name ?? "";
                        });
                        populatelinkedUpnagarDropdown(value);
                        populatelinkedVastiDropdown(false, value);
                      },
                      isDisabled: ((userLevelId ?? 0) < 6 || (userLevelId ?? 0) == 13),
                    ),

                  if (_linkedupnagar != null && _linkedupnagar!.isNotEmpty)
                    buildDropdownField(
                      isDisabled: ((userLevelId ?? 0) < 6 || (userLevelId ?? 0) == 13),
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
                          _selctedLevel = 'Nagar';
                          _selctedLevelName = selectedItem.name ?? "";
                          _linkedupnagarName = selectedItem.name ?? "";
                        });
                        populatelinkedVastiDropdown(true, value);
                      },
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
                  if (_linkedvasti != null && _linkedvasti!.isNotEmpty)
                    _buildDropdownField(
                      isDisabled: ((userLevelId ?? 0) < 2),
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
                        });
                      },
                    ),
                  SizedBox(height: 15),
                  _buildDropdownField(
                    label: Statics.getLabel('SelectFrequency'),
                    value: selectedType,
                    items: typeList
                        .map((v) => DropdownMenuItem(
                              value: v.toString(),
                              child: Text(Statics.getLabel(v)),
                            ))
                        .toList(),
                    onChanged: (value) => setState(() => selectedType = value),
                    isDisabled: false,
                  ),
                  SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // if ( selectedType != null)
                      MaterialButton(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                        padding: EdgeInsets.symmetric(
                          horizontal: 35,
                          vertical: 5,
                        ),
                        color: Theme.of(context).primaryColor,
                        textColor: Theme.of(context).primaryTextTheme.labelMedium?.color,
                        onPressed: () async {
                          if (selectedType == null) {
                            Statics.showToast("please select type");
                            return;
                          }
                          _selctedLevelNameList = [];
                          setState(() {});
                          // _selctedLevelNameList.add(_linkedMahaanagarName);
                          // _selctedLevelNameList.add(_linkedVibhaagName);
                          _selctedLevelNameList.add(_linkedbhaagName);
                          _selctedLevelNameList.add(_linkedshaharName);
                          _selctedLevelNameList.add(_linkednagarName);
                          _selctedLevelNameList.add(_linkedmandalName);
                          _selctedLevelNameList.add(_linkedgraamName);
                          _selctedLevelNameList.add(_linkedvastiName);
                          setState(() {});

                          await getReportDataFun();

                          setState(() {
                            selectedList = getSelectedList();
                            _selctedLevelNames = _selctedLevelNameList
                                .where((e) => e != null && e.isNotEmpty) // remove null or empty strings
                                .cast<String>() // convert from String? to String
                                .join(' -> ');
                            _searched = true;
                            _isExpanded = false;
                          });
                        },
                        child: Text(
                          "${Statics.getLabel('search')}",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      MaterialButton(
                          onPressed: () async {
                            setState(() {
                              _searched = false;
                              _selectedGeoUnitId = null;
                              _linkedMahaanagarValue = _linkedbhaagValue = _linkedshaharValue = _linkednagarValue = _linkedmandalValue = _linkedvastiValue = _linkedgraamValue = null;
                              _linkedVibhaagValue = _linkedbhaag = _linkedshahar = _linkedgraam = _linkedmandal = _linkedvasti = _linkednagar = null;
                              _selctedLevel = "praant";
                              selectedType = null;
                            });
                            await clearForm();
                          },
                          child: Text(Statics.getLabel('clear'))),
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

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<DropdownMenuItem<String>> items,
    required ValueChanged<String?> onChanged,
    required bool isDisabled,
  }) {
    return IgnorePointer(
      ignoring: isDisabled,
      child: DropdownButtonFormField(
        decoration: InputDecoration(labelText: label),
        isExpanded: true,
        value: value == "" ? null : value,
        items: items,
        onChanged: onChanged,
      ),
    );
  }

  Widget commonInfoCard(dynamic item, VoidCallback onView) {
    final json = item.toJson();

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        title: Text(
          MyAppGlobals.checkTextNullEmpty(json["Name"] ?? json["BhavanacheNav"] ?? json["Saan"] ?? json["ShaikshanikSansthaan"]),
        ),
        subtitle: Text(json["VastigramName"] ?? ""),
        trailing: IconButton(
          icon: const Icon(Icons.remove_red_eye, color: Colors.purple),
          onPressed: onView,
        ),
      ),
    );
  }

  List<Map<String, String>> buildDetails(dynamic item) {
    final Map<String, dynamic> jsonMap = item.toJson();

    return jsonMap.entries.map((entry) {
      return {entry.key: entry.value?.toString() ?? "--"};
    }).toList();
  }

  Future<void> showPersonDetailsPopup(BuildContext context, dynamic item, int srNo) {
    List<Map<String, String>> details = buildDetails(item);

    return showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          insetPadding: const EdgeInsets.all(16),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.purple, Colors.purpleAccent],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${Statics.getLabel('moreInfo')}",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),

                // Details
                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: details.map((e) {
                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 5,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            spacing: 8,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 3,
                                child: Text(
                                  Statics.getLabel(e.keys.first.toLowerCase(), returnKey: true),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 5,
                                child: Text(
                                  e.values.first.isEmpty ? "--" : e.values.first,
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                Padding(
                  padding: const EdgeInsets.all(12),
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purpleAccent,
                      minimumSize: const Size.fromHeight(45),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.check_circle, color: Colors.white),
                    label: Text(
                      "${Statics.getLabel('bandKara')}",
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
