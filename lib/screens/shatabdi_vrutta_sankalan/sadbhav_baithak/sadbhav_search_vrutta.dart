import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../helpers/static_data.dart' as Statics;
import '../../../models/response_model/dropdown_level_responsemodel.dart';
import '../../../models/response_model/sadbhav_baithak_resp_model.dart';
import '../../../providers/bals.dart';
import '../../../providers/sadbhav_provider.dart';
import '../../../utils/globals.dart';

class AllBaithakTableScreen extends StatefulWidget {
  static const routeName = '/all-baithak-table-screen';

  const AllBaithakTableScreen({super.key});

  @override
  State<AllBaithakTableScreen> createState() => _AllBaithakTableScreenState();
}

class _AllBaithakTableScreenState extends State<AllBaithakTableScreen> with AutomaticKeepAliveClientMixin {
// This override is what tells Flutter to keep the state alive.
  @override
  bool get wantKeepAlive => true;

  bool _searched = false;
  bool _isExpanded = true;

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
  int? _selectedKaryakramLevelId;

  List<Bhaitakdata> kendraBaithakList = [];

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) => populateDropdown());
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) => getAllData());
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
      karyakramLevelsListForSadbhav = getFilteredKaryakramLevels(dm.levelID ?? 0, isSadbhav: true);
    });
    await populateDropdown();
    getAllData();
  }

  Future<void> populateAllDropdowns(int level, DropDownModel dm) async {
    setState(() {
      _selectedGeoUnitId = _linkedMahaanagarValue = _linkedbhaagValue = _linkedshaharValue = _linkednagarValue = _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = null;
    });
    final selection = prepareSelection(dm);

    // Step 1: Mahaanagar
    await populatelinkedMahaanagarDropdown();
    _linkedMahaanagarValue = (level == 9 ? (dm.geoUnitID ?? 0).toString() : selection.mahaanagar) ?? _linkedMahaanagarValue;
    if (level == 9) {
      _selectedGeoUnitId = (dm.geoUnitID ?? selection.mahaanagar).toString();
      _selctedLevel = 'Mahaanagar';
    }

    // Step 2: Vibhaag
    await populatelinkedVibhaagDropdown(_linkedMahaanagarValue!);
    _linkedVibhaagValue = (level == 8 ? (dm.geoUnitID ?? 0).toString() : selection.vibhaag) ?? _linkedVibhaagValue;
    if (level == 8) {
      _selectedGeoUnitId = (dm.geoUnitID ?? selection.vibhaag).toString();
      _selctedLevel = 'Vibhaag';
    }

    // Step 3: Bhaag
    await populatelinkedBhaagDropdown(_linkedVibhaagValue!);
    _linkedbhaagValue = (level == 7 ? (dm.geoUnitID ?? 0).toString() : selection.bhaag) ?? _linkedbhaagValue;
    if (level == 7) {
      _selectedGeoUnitId = (dm.geoUnitID ?? selection.bhaag).toString();
      _selctedLevel = 'Bhaag';
    }

    // Step 4: Nagar
    await populatelinkedNagarDropdown(_linkedbhaagValue);
    _linkednagarValue = (level == 6 ? (dm.geoUnitID ?? 0).toString() : selection.nagar) ?? _linkednagarValue;
    if (level == 6) {
      _selectedGeoUnitId = (dm.geoUnitID ?? selection.nagar).toString();
      _selctedLevel = 'Nagar';
    }

    // Step 5: Upnagar (conditional)
    await populatelinkedUpnagarDropdown(_linkednagarValue);
    if (selection.upnagar != null && selection.upnagar!.isNotEmpty) {
      _linkedupnagarValue = (level == 13 ? (dm.geoUnitID ?? 0).toString() : selection.upnagar) ?? _linkedupnagarValue;
      if (level == 13) {
        _selectedGeoUnitId = (dm.geoUnitID ?? selection.upnagar).toString();
        _selctedLevel = 'Upnagar';
      }
    }

    // Step 6: Mandal
    await populatelinkedMandalDropdown(
      selection.upnagar != null ? "Nagar" : "Upnagar",
      selection.upnagar != null ? _linkednagarValue : _linkedupnagarValue,
    );
    _linkedmandalValue = (level == 4 ? (dm.geoUnitID ?? 0).toString() : selection.mandal) ?? _linkedmandalValue;
    if (level == 4) {
      _selectedGeoUnitId = (dm.geoUnitID ?? selection.mandal).toString();
      _selctedLevel = 'Mandal';
    }
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

  getAllData() async {
    FocusManager.instance.primaryFocus?.unfocus();

    var formData = {
      "levelid": _selectedKaryakramLevelId ?? 0,
      "geounitid": int.tryParse(_selectedGeoUnitId ?? "0") ?? 0,
      "appuserid": int.parse(Statics.userDetails['userID']),
    };

    final _data = await Statics.GetAllSadbhavBaithakListData(context: context, inputJson: formData, showLoader: true);

    if (_data != null) {
      kendraBaithakList = _data.bhaitakdata ?? [];
      setState(() {
        _searched = true;
        _isExpanded = false;
      });
    }
  }

  deleteSadbhavBaithakFun(String id) async {
    FocusManager.instance.primaryFocus?.unfocus();

    var formData = {
      "ids": id,
    };

    await Statics.DeleteSadbhavBaithakData(context: context, inputJson: formData, showLoader: true) ?? [];

    setState(() {
      _searched = true;
      _isExpanded = false;
    });
  }

  clearForm() async {
    setState(() {
      kendraBaithakList = [];
      _searched = false;
      _selectedKaryakramLevelId = _selectedGeoUnitId = null;
      _linkedMahaanagarValue = _linkedbhaagValue = _linkedshaharValue = _linkednagarValue = _linkedmandalValue = _linkedvastiValue = _linkedgraamValue = null;
      _linkedVibhaagValue = _linkedbhaag = _linkedshahar = _linkedgraam = _linkedmandal = _linkedvasti = _linkednagar = null;
      _selctedLevel = "praant";
    });
    await initData();
  }

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
      print("object is null");
      print("object is null ${userLevelId == null}");
      print("object is null ${ddm == null}");
      return;
    }
    print("object is not null >>>>>>>>>>>>>>>>>>>>>>");
    await populateAllDropdowns(userLevelId!, ddm!);
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

  List<String> headers = ["serialNo", "LevelName", "centreName", "date2", "anya_upastiti_male", "anya_upastiti_matrushakti", "Total", "sadbhavReportTable2"];

  // List<Map<String, dynamic>> karyakramLevelsList = [
  //   {"${Statics.getLabel("Bhaag")}": 1},
  //   {"${Statics.getLabel("railwayStation")}": 2},
  //   {"${Statics.getLabel("Shahar")}": 3},
  //   {"${Statics.getLabel("other")}": 4},
  //   {"${Statics.getLabel("Nagar")}": 5},
  //   {"${Statics.getLabel("upnagarUpkhanda")}": 6},
  //   {"${Statics.getLabel("Mandal")}": 7},
  // ];

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final sadbhavProvider = context.watch<SadbhavProvider>();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${Statics.getLabel('baithakDataTitle')}",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 8),
          stharDropdown(),
          SizedBox(height: 16),
          kendraBaithakList.isEmpty
              ? SizedBox(
                  height: 170,
                  child: Center(
                    child: Text(
                      Statics.getLabel("baithakNotFound"),
                      style: TextStyle(fontWeight: FontWeight.w800),
                    ),
                  ),
                )
              // : baithakListExpandableTable(),
              : Expanded(
                  child: SingleChildScrollView(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        headingRowColor: MaterialStateColor.resolveWith((_) => Colors.purple.shade100),
                        columnSpacing: 18,
                        horizontalMargin: 12,
                        border: TableBorder.all(color: Colors.black26),
                        columns: headers
                            .map((e) => DataColumn(
                                  label: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 8),
                                    constraints: const BoxConstraints(minWidth: 30, maxWidth: 130),
                                    child: Text(
                                      Statics.getLabel(e),
                                      softWrap: true,
                                      maxLines: 2,
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ))
                            .toList(),
                        rows: kendraBaithakList.asMap().entries.map((e) {
                          final index = e.key;
                          final data = e.value;
                          return DataRow(
                            cells: [
                              DataCell(Center(child: Text((index + 1).toString()))),
                              DataCell(Center(child: Text(data.stharname ?? "--"))),
                              DataCell(Center(child: Text(data.kendraname ?? "--"))),
                              DataCell(Center(child: Text(data.programdate ?? "--"))),
                              DataCell(Center(child: Text((data.male ?? 0).toString()))),
                              DataCell(Center(child: Text((data.female ?? 0).toString()))),
                              DataCell(Center(child: Text((data.totmalefemale ?? 0).toString()))),
                              DataCell(Center(child: Text((data.peoplecount ?? 0).toString()))),
                              // DataCell(PopupMenuButton(
                              //   color: Colors.white,
                              //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              //   onSelected: (value) async {
                              //     if (value == "Delete") {
                              //       showDialog(
                              //         context: context,
                              //         builder: (ctx) => AlertDialog(
                              //           title: Text(Statics.getLabel('AskConfirmation')),
                              //           content: Text(Statics.getLabel('AreyouSureYouWantToDeleteBaithak')),
                              //           actions: <Widget>[
                              //             MaterialButton(
                              //               child: Text(Statics.getLabel('ConfirmationYes')),
                              //               onPressed: () async {
                              //                 var _res = await Statics.DeleteSadbhavBaithakData(context: context, inputJson: {"id": data.pkid, "type": "vrutta"});
                              //                 if (_res) {
                              //                   Statics.showToast(Statics.getLabel('BaithakDeletedSuccessfully'));
                              //                 } else
                              //                   Statics.showToast(Statics.getLabel('errorOccurred'));
                              //                 Navigator.of(ctx).pop();
                              //                 await getBaithakListData(selectedKendra?.pkid ?? 0);
                              //               },
                              //             ),
                              //             MaterialButton(
                              //               child: Text(Statics.getLabel('ConfirmationNo')),
                              //               onPressed: () {
                              //                 Navigator.of(ctx).pop();
                              //               },
                              //             )
                              //           ],
                              //         ),
                              //       );
                              //     } else if (value == "EditMenu") {
                              //       print("EDIT >>>>>>>>>>>>>>");
                              //       await _getForm(data.pkid);
                              //       showBaithakDetailPopup(data);
                              //       // Navigator.of(context).pushNamed(SadbhavCenterCreationScreen.routeName, arguments: {"id": 0, "viewOnly": true});
                              //       // } else if (value == "baithak") {
                              //       // sadbhavProvider.updateSadbhavVal(SadbhavCenter(centername: "नवीन केंद्र", geounitname: "कोळीवाडा", sthartype: Statics.getLabel("railwayStation")));
                              //
                              //       // Navigator.of(context).pushNamed(SadbhavFormTab.routeName); //, arguments: {"id": data.pkid});
                              //     } else {
                              //       showBaithakDetailPopup(data, viewOnly: true);
                              //       // Navigator.of(context).pushNamed(SadbhavCenterCreationScreen.routeName, arguments: {"id": 0, "viewOnly": true});
                              //       // Navigator.of(context).pushNamed(SadbhavCenterListScreen.routeName); //, arguments: {"id": data.pkid, "viewOnly": true});
                              //     }
                              //   },
                              //   itemBuilder: (BuildContext context) {
                              //     return [
                              //       // Statics.MenuItem(Statics.getLabel('addinSoochi'), Icons.list, 'AddinSoochi'),
                              //       // if (showEditMenu == true)
                              //       Statics.MenuItem(Statics.getLabel('baithakVrutta'), FontAwesomeIcons.edit, 'EditMenu'),
                              //       Statics.MenuItem(Statics.getLabel('ViewMenu'), FontAwesomeIcons.eye, 'ViewMenu'),
                              //       // if (showDeleteMenu == true)
                              //       Statics.MenuItem(Statics.getLabel('Delete'), Icons.delete, 'Delete'),
                              //       // Statics.MenuItem(Statics.getLabel('baithak'), Icons.edit_note_rounded, 'baithak'),
                              //     ].map((Statics.MenuItem menuItem) {
                              //       return PopupMenuItem(
                              //         value: menuItem.menuKey,
                              //         child: ListTile(
                              //           // tileColor: Colors.white,
                              //           leading: Icon(
                              //             menuItem.iconVal,
                              //             color: Colors.purple,
                              //           ),
                              //           title: Text(menuItem.menuVal),
                              //         ),
                              //       );
                              //     }).toList();
                              //   },
                              // )),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  Widget stharDropdown() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
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
                  buildDropdownField(
                    // ignoring: dateController.text.isEmpty || (baithakId != null && baithakId != 0),
                    label: Statics.getLabel('selectStar'),
                    value: _selectedKaryakramLevelId == null ? null : _selectedKaryakramLevelId.toString(),
                    items: karyakramLevelsListForSadbhav
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
                      // print("baithakId >>>>>>>>>>>>>>>> ${baithakId}");
                      await getAllData();
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
                          onPressed: getAllData,
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
          if ([5, 6, 7].contains(_selectedKaryakramLevelId) && _linkednagar != null && _linkednagar!.isNotEmpty)
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
                  populatelinkedMandalDropdown('Nagar', value);
                  // populatelinkedVastiDropdown('Nagar', value);
                });
              },
              isDisabled: ((userLevelId ?? 0) < 6 || userLevelId == 13),
            ),
          if ([6, 7].contains(_selectedKaryakramLevelId) && _linkedupnagar != null && _linkedupnagar!.isNotEmpty)
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
                  populatelinkedMandalDropdown('Upnagar', value);
                  // populatelinkedVastiDropdown('Upnagar', value);
                });
              },
              isDisabled: ((userLevelId ?? 0) < 6 || userLevelId == 13),
            ),
          if ([7].contains(_selectedKaryakramLevelId) && _linkedmandal != null && _linkedmandal!.isNotEmpty)
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
                  // populatelinkedGraamDropdown(value);
                });
              },
              isDisabled: ((userLevelId ?? 0) < 4),
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
}
