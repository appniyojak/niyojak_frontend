import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import '../../../helpers/static_data.dart' as Statics;
import '../../../models/response_model/sadbhav_baithak_resp_model.dart';
import '../../../providers/bals.dart';
import 'sadbhav_creation_screen.dart';
import 'sadbhav_form.dart';

class SadbhavSearchVruttaTab extends StatefulWidget {
  const SadbhavSearchVruttaTab({super.key});

  @override
  State<SadbhavSearchVruttaTab> createState() => _SadbhavSearchVruttaTabState();
}

class _SadbhavSearchVruttaTabState extends State<SadbhavSearchVruttaTab> with AutomaticKeepAliveClientMixin {
// This override is what tells Flutter to keep the state alive.
  @override
  bool get wantKeepAlive => true;

  bool _searched = false;
  bool _isExpanded = true;

  TextEditingController dateController = TextEditingController();
  TextEditingController txtGivenGroupNameController = TextEditingController();

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

  List<SadbhavMasterdata> sadbhavList = [];

  Map<String, List<SadbhavMasterdata>> datewiseSadbhavList = {};

  List<Map<String, dynamic>> karyakramLevelsList = [
    {"${Statics.getLabel("Bhaag")}": 1},
    {"${Statics.getLabel("railwayStation")}": 2},
    {"${Statics.getLabel("Shahar")}": 3},
    {"${Statics.getLabel("other")}": 4},
    {"${Statics.getLabel("Nagar")}": 5},
    {"${Statics.getLabel("upnagarUpkhanda")}": 6},
    {"${Statics.getLabel("Mandal")}": 7},
  ];
  int? _selectedKaryakramLevelId;

  @override
  void initState() {
    super.initState();
    _selectedKaryakramLevelId = 1;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => getSadbhavBaithakListFun());
  }

  Map<String, List<SadbhavMasterdata>> groupByDate() {
    datewiseSadbhavList = groupBy(sadbhavList, (item) => item.programdate.toString());

    // for (var item in sadbhavList) {
    //   String date = item.programdate.toString();
    //
    //   datewiseSadbhavList.putIfAbsent(date, () => []);
    //   datewiseSadbhavList[date]!.add(item);
    // }

    setState(() {});
    datewiseSadbhavList.keys.toList()
      ..sort((a, b) {
        DateTime dateA = DateFormat('dd/MM/yyyy').parse(a);
        DateTime dateB = DateFormat('dd/MM/yyyy').parse(b);

        return dateB.compareTo(dateA); // latest first
      });

    setState(() {});
    return datewiseSadbhavList;
  }

  getSadbhavBaithakListFun() async {
    FocusManager.instance.primaryFocus?.unfocus();

    var formData = {
      "date": dateController.text,
      "levelid": _selectedKaryakramLevelId ?? 1,
      // "geounitid": _selectedGeoUnitId,
      "appuserid": int.parse(Statics.userDetails['userID']),
    };

    sadbhavList = await Statics.GetSadbhavBaithakListData(context: context, inputJson: formData, showLoader: true) ?? [];

    setState(() {
      _searched = true;
      _isExpanded = false;
    });
    await groupByDate();
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
      sadbhavList = [];
      datewiseSadbhavList = {};
      _searched = false;
      _selectedKaryakramLevelId = _selectedGeoUnitId = null;
      _linkedMahaanagarValue = _linkedbhaagValue = _linkedshaharValue = _linkednagarValue = _linkedmandalValue = _linkedvastiValue = _linkedgraamValue = null;
      _linkedVibhaagValue = _linkedbhaag = _linkedshahar = _linkedgraam = _linkedmandal = _linkedvasti = _linkednagar = null;
      _selctedLevel = "praant";
    });
    // clearForm();
    await populateDropdown();
    dateController.clear();
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

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "${Statics.getLabel('date2')} : ",
                      style: TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    // Text(
                    //   " *",
                    //   style: TextStyle(fontSize: 15, color: Colors.red, fontWeight: FontWeight.bold),
                    // ),
                    SizedBox(width: 12),
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width * 0.4,
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

                            await populateDropdown();
                            setState(() {
                              _searched = false;
                            });
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
                  ],
                ),
              ),
              SizedBox(height: 12),
              _buildDropdownField(
                label: Statics.getLabel('selectStar'),
                value: _selectedKaryakramLevelId == null ? null : _selectedKaryakramLevelId.toString(),
                items: karyakramLevelsList
                    .map((bg) => DropdownMenuItem(
                          value: bg.values.first.toString(),
                          child: Text(bg.keys.first),
                        ))
                    .toList(),
                onChanged: (value) {
                  populateDropdown();
                  _searched = false;
                  setState(() => _selectedKaryakramLevelId = int.tryParse(value.toString()));
                },
                isDisabled: false,
              ),
              SizedBox(height: 18),
              // if (_selectedKaryakramLevel != null) nagarDropdown(),
              SizedBox(height: 18),
              // if ((([Statics.getLabel("railwayStation"), Statics.getLabel("Shahar"), Statics.getLabel("other")].contains(_selectedKaryakramLevel)) && _selctedLevel == Statics.getLabel('Bhaag')) ||_selctedLevel == _selectedKaryakramLevel)
              if (_selectedKaryakramLevelId != null)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // if ((_linkedgraamValue != "" && _linkedgraamValue != null) || (_linkedvastiValue != "" && _linkedvastiValue != null))
                    MaterialButton(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                      padding: EdgeInsets.symmetric(
                        horizontal: 35,
                        vertical: 5,
                      ),
                      color: Theme.of(context).primaryColor,
                      textColor: Theme.of(context).primaryTextTheme.labelMedium?.color,
                      onPressed: getSadbhavBaithakListFun,
                      child: Text(
                        "${Statics.getLabel('search')}",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    MaterialButton(onPressed: clearForm, child: Text(Statics.getLabel('clear'))),
                  ],
                ),
              SizedBox(height: 18),
              sadbhavList.isEmpty
                  ? SizedBox(
                      height: MediaQuery.sizeOf(context).height * 0.45,
                      child: Center(
                        child: Text(
                          Statics.getLabel("baithakNotFound"),
                          style: TextStyle(fontWeight: FontWeight.w800),
                        ),
                      ),
                    )
                  : ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      separatorBuilder: (context, index) => SizedBox(height: 12),
                      itemCount: datewiseSadbhavList.length,
                      itemBuilder: (context, index) {
                        String date = datewiseSadbhavList.keys.toList()[index];
                        final items = datewiseSadbhavList[date]!;
                        return dateWiseCard(index == 0, date, items);
                      },
                    ),
              SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  Widget dateWiseCard(bool isFirst, String date, List<SadbhavMasterdata> items) {
    return ExpansionTile(
      tilePadding: EdgeInsets.only(right: 16, left: 16),
      childrenPadding: EdgeInsets.only(right: 12, left: 12, top: 12, bottom: 8),
      collapsedBackgroundColor: Colors.purple.shade100,
      backgroundColor: Colors.purple.shade50,
      initiallyExpanded: isFirst,
      shape: RoundedRectangleBorder(side: BorderSide.none, borderRadius: BorderRadius.circular(12)),
      collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      showTrailingIcon: true,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [Text("(${items.length})"), Icon(Icons.keyboard_arrow_down_outlined)],
      ),
      title: Text(
        date.toString(),
        style: TextStyle(fontWeight: FontWeight.w800),
      ),
      // subtitle: Text(
      //   (karyakramLevelsList.firstWhere((e) => e.values.first == items.first.shatapdistharlevelid).keys.first).toString(),
      //   style: TextStyle(color: Colors.blue),
      // ),
      children: items.asMap().entries.map((_baithak) => vruttaCard(_baithak)).toList(),
    );
  }

  Widget vruttaCard(MapEntry<int, SadbhavMasterdata> maps) {
    final index = maps.key;
    final data = maps.value;
    return Card(
      margin: EdgeInsets.all(5),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8),
        child: Row(
          children: [
            // Title and Subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // index
                  Text(
                    "${index + 1}. ",
                    // "${data.name}  -  ${data.geoname}",
                    style: TextStyle(fontSize: 16),
                  ),
                  // Title
                  Text(
                    [data.name, data.geoname].where((e) => e != null && e.isNotEmpty).join('  -  '),
                    // "${data.name}  -  ${data.geoname}",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 5),
                  SizedBox(height: 5),
                  // RichText(
                  //   text: TextSpan(
                  //     text: 'Date: ${data.programdate}',
                  //     style: TextStyle(color: Colors.blue),
                  //   ),
                  // )
                ],
              ),
            ),

            // Trailing Buttons
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Menu",
                  style: TextStyle(fontSize: 10),
                ),
                PopupMenuButton(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  onSelected: (value) {
                    if (value == "Delete") {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: Text(Statics.getLabel('AskConfirmation')),
                          content: Text(Statics.getLabel('AreyouSureYouWantToDeleteBaithak')),
                          actions: <Widget>[
                            MaterialButton(
                              child: Text(Statics.getLabel('ConfirmationYes')),
                              onPressed: () async {
                                var _res = await Statics.DeleteSadbhavBaithakData(context: context, inputJson: {"ids": data.pkid});
                                if (_res) {
                                  Statics.showToast(Statics.getLabel('BaithakDeletedSuccessfully'));
                                } else
                                  Statics.showToast(Statics.getLabel('errorOccurred'));
                                Navigator.of(ctx).pop();
                                await getSadbhavBaithakListFun();
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
                    } else if (value == "EditMenu") {
                      print("EDIT >>>>>>>>>>>>>>");
                      Navigator.of(context).pushNamed(SadbhavCreationScreen.routeName, arguments: {"id": data.pkid, "viewOnly": false});
                    } else if (value == "fillVrutta") {
                      Navigator.of(context).pushNamed(SadbhavFormTab.routeName, arguments: {"id": data.pkid});
                    } else {
                      Navigator.of(context).pushNamed(SadbhavCreationScreen.routeName, arguments: {"id": data.pkid, "viewOnly": true});
                    }
                  },
                  itemBuilder: (BuildContext context) {
                    return [
                      // Statics.MenuItem(Statics.getLabel('addinSoochi'), Icons.list, 'AddinSoochi'),
                      // if (showEditMenu == true)
                      Statics.MenuItem(Statics.getLabel('EditMenu'), FontAwesomeIcons.edit, 'EditMenu'),
                      Statics.MenuItem(Statics.getLabel('ViewMenu'), FontAwesomeIcons.eye, 'ViewMenu'),
                      // if (showDeleteMenu == true)
                      Statics.MenuItem(Statics.getLabel('Delete'), Icons.delete, 'Delete'),
                      Statics.MenuItem(Statics.getLabel('fillVrutta'), Icons.edit_note_rounded, 'fillVrutta'),
                    ].map((Statics.MenuItem menuItem) {
                      return PopupMenuItem(
                        value: menuItem.menuKey,
                        child: ListTile(
                          // tileColor: Colors.white,
                          leading: Icon(
                            menuItem.iconVal,
                            color: Colors.purple,
                          ),
                          title: Text(menuItem.menuVal),
                        ),
                      );
                    }).toList();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget nagarDropdown() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      margin: EdgeInsets.symmetric(horizontal: 20),
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
              onChanged: (value) async {
                final selectedItem = _linkednagar!.firstWhere((bg) => bg.geoUnitID.toString() == value);
                setState(() {
                  _linkednagarValue = value;
                  _selectedGeoUnitId = value;
                  _selctedLevel = Statics.getLabel('Nagar');
                  _selctedLevelName = selectedItem.name ?? "";
                  _linkednagarName = selectedItem.name ?? "";
                });
                await populatelinkedUpnagarDropdown(value);
                await populatelinkedMandalDropdown('Nagar', value);
                // await populatelinkedVastiDropdown('Nagar', value);
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
          if (_selectedKaryakramLevelId == 7 && _linkedmandal != null && _linkedmandal!.isNotEmpty)
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
}
