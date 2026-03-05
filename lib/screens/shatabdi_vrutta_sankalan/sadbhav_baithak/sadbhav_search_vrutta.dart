import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../helpers/static_data.dart' as Statics;
import '../../../models/response_model/sadbhav_baithak_resp_model.dart';
import '../../../providers/bals.dart';
import '../../../providers/sadbhav_provider.dart';

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
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => getAllData());
  }

  getAllData() async {
    FocusManager.instance.primaryFocus?.unfocus();

    var formData = {
      "AppUserID": int.parse(Statics.userDetails['userID']),
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
    // clearForm();
    await populateDropdown();
  }

  //////////////////////////////////////////////////////////////////////////////////////

  Future<void> populateDropdown() async {
    setState(() {
      _linkedMahaanagarValue = _linkedbhaagValue = _linkedshaharValue = _linkednagarValue = _linkedupnagarValue = _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = null;
      _linkedMahaanagar = _linkedVibhaag = _linkedbhaag = _linkednagar = _linkedupnagar = _linkedmandal = null;
      _selctedLevelName = _selectedGeoUnitId = null;
      _selctedLevel = "praant";
    });
    await populatelinkedMahaanagarDropdown();
    await populatelinkedVibhaagDropdown('');
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

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final sadbhavProvider = context.watch<SadbhavProvider>();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${Statics.getLabel('selectKaryakramLevel')}",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
      ),
      body: kendraBaithakList.isEmpty
          ? Center(
              child: Text(
                Statics.getLabel("baithakNotFound"),
                style: TextStyle(fontWeight: FontWeight.w800),
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
    );
  }
}
