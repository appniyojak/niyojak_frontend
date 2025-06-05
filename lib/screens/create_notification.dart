import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:multi_select_flutter/chip_display/multi_select_chip_display.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:niyojak_prod/widgets/app_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../helpers/static_data.dart' as Statics;
import '../helpers/static_data.dart';
import '../models/response_model/AbhiyaanLoginDataResponse.dart';
import '../providers/bals.dart';


class CreateNotificationView extends StatefulWidget {
  static const String routeName = '/create-notification';
  const CreateNotificationView({super.key});

  @override
  State<CreateNotificationView> createState() => _CreateNotificationViewState();
}

class _CreateNotificationViewState extends State<CreateNotificationView> {


  @override
  void initState() {
    getInitialData();
    populateDropdown();
    super.initState();
  }
  getInitialData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var data = pref.getString("AbhiyanSwayamsevakData");
    print(data);
    if (data != null) {
      initialData = AbhiyanSwayamsevakdata.fromJson(jsonDecode(data));
      type = initialData!.levelName!.toLowerCase();
      print("initialData!.levelName  ---> ${type}");
      setState(() {});
    }
  }
  TextEditingController customMessageController = TextEditingController();
  bool _isExpanded = false;
  bool _isExpanded2 = false;
  List<GeoUnitMasterBAL>? _linkedMahaanagar;
  List<GeoUnitMasterBAL>? _linkedVibhaag;
  List<GeoUnitMasterBAL>? _linkedbhaag;
  List<GeoUnitMasterBAL>? _linkedshahar;
  List<GeoUnitMasterBAL>? _linkednagar;
  List<GeoUnitMasterBAL>? _linkedmandal;
  List<GeoUnitMasterBAL>? _linkedgraam;
  List<GeoUnitMasterBAL>? _linkedvasti;

  bool? _linkedMahaanagarDisable = false;
  bool? _linkedVibhaagDisable = false;
  bool? _linkedbhaagDisable = false;
  bool? _linkedshaharDisable = false;
  bool? _linkednagarDisable = false;
  bool? _linkedmandalDisable = false;
  bool? _linkedgraamDisable = false;
  bool? _linkedvastiDisable = false;

  String? _linkedMahaanagarValue = '';
  String? _linkedVibhaagValue = '';
  String? _linkedbhaagValue = "";
  String? _linkedshaharValue = "";
  String? _linkednagarValue = "";
  String? _linkedmandalValue = "";
  String? _linkedgraamValue = "";
  String? _linkedvastiValue = "";
  String? type = 'praant';
  String? geoUnitId;
  bool? viewSanghaPreritDropDown = false;
  List<StaticMasterBAL>? _daayitvaFor;
  List<dynamic>? _sanghaPreritSanstha;
  List<LevelMasterBAL>? _level;
  List<GeoUnitMasterBAL>? _geoUnits;
  List<StaticMasterBAL> _selectedDaayitvaFor = [];
  List<DaayitvaMasterBAL> _selectedDayitvaItems = [];
  List<DaayitvaMasterBAL> _selectedDayitvaList = [];
  List<dynamic> _selectedPreritSanstha = [];
  bool? sanghaPreritSansthaa;

  AbhiyanSwayamsevakdata? initialData;

  populatelinkedMahaanagarDropdown() async {
    _linkedVibhaagValue = _linkedbhaagValue = _linkednagarValue = _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = null;
    var data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['MahaanagarLevelID'].toString(), '', '', '');
    setState(() {
      _linkedMahaanagar = data;
    });
  }

  populatelinkedVibhaagDropdown(String? mahaanagarIDStr) async {
    _linkedbhaagValue = _linkednagarValue = _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = null;
    var data = await Statics.getGeoUnitsByLevelAndParent(
        Statics.levels['VibhaagLevelID'].toString(), mahaanagarIDStr!, (mahaanagarIDStr.isEmpty ? '' : 'Mahaanagar'), '');
    setState(() {
      _linkedVibhaag = data;
    });
  }

  void populatelinkedBhaagDropdown(String? vibhaagIDStr) async {
    _linkedbhaagValue = _linkednagarValue = _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = null;
    _linkedbhaag = _linkednagar = _linkedmandal = _linkedgraam = _linkedvasti = [];
    var data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['BhaagLevelID'].toString(), vibhaagIDStr!, 'Vibhaag', '');
    setState(() {
      _linkedbhaag = data;
    });
  }

  void populatelinkedShaharDropdown(String? bhaagIDStr) async {
    _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = null;
    var shDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['ShaharLevelID'].toString(), bhaagIDStr!, 'Bhaag', '');
    setState(() {
      _linkedshahar = (shDD.length > 0 ? shDD : null);
    });
  }

  void populatelinkedNagarDropdown(String? bhaagIDStr, String? shaharIDStr) async {
    _linkednagarValue = _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = null;
    _linkednagar = _linkedmandal = _linkedgraam = _linkedvasti = null;
    if (shaharIDStr != null) {
      var ngDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['NagarLevelID'].toString(), shaharIDStr, 'Shahar', '');
      setState(() {
        _linkednagar = (ngDD.length > 0 ? ngDD : null);
      });
    } else {
      var ngDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['NagarLevelID'].toString(), bhaagIDStr!, 'Bhaag', '');
      setState(() {
        _linkednagar = (ngDD.length > 0 ? ngDD : null);
      });
    }
  }

  void populatelinkedMandalDropdown(String? nagarIDStr) async {
    _linkedmandalValue = _linkedgraamValue = null;
    _linkedmandal = _linkedgraam = null;
    var mnDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['MandalLevelID'].toString(), nagarIDStr!, 'Nagar', '');
    setState(() {
      _linkedmandal = (mnDD.length > 0 ? mnDD : null);
    });
  }

  void populatelinkedGraamDropdown(String? mandalIDStr) async {
    _linkedgraamValue = null;
    var gmDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['GraamLevelID'].toString(), mandalIDStr!, 'Mandal', '');
    setState(() {
      _linkedgraam = (gmDD.length > 0 ? gmDD : null);
    });
  }

  void populatelinkedVastiDropdown(String? nagarIDStr) async {
    _linkedvastiValue = null;
    var vsDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['VastiLevelID'].toString(), nagarIDStr!, 'Nagar', '');
    setState(() {
      _linkedvasti = (vsDD.length > 0 ? vsDD : null);
    });
  }

  Future<void> populateDropdown() async {
    setState(() {
      _linkedshaharValue = null;
      _linkednagarValue = null;
      _linkedmandalValue = null;
      _linkedgraamValue = null;
      _linkedvastiValue = null;
    });
    await populatelinkedMahaanagarDropdown();
    await populatelinkedVibhaagDropdown('');
    print("initialDatainitialData $initialData");
    if (initialData != null) {
      setState(() {
        if (initialData!.parentMahaanagarID != null) {
          _isExpanded = true;
          _linkedMahaanagarDisable = true;
          _linkedMahaanagarValue = initialData!.parentMahaanagarID.toString();
        }
        if (initialData!.parentVibhaagID != null) {
          populatelinkedVibhaagDropdown('');
          _isExpanded = true;
          _linkedVibhaagDisable = true;
          _linkedVibhaagValue = initialData!.parentVibhaagID.toString();
        }
        if (initialData!.parentBhaagID != null) {
          _isExpanded = true;
          _linkedbhaagDisable = true;
          _linkedbhaagValue = initialData!.parentBhaagID.toString();
          populatelinkedNagarDropdown(_linkedbhaagValue, null);
        }
        if (initialData!.parentNagarID != null) {
          _isExpanded = true;
          _linkednagarDisable = true;
          _linkednagarValue = initialData!.parentNagarID.toString();
          populatelinkedMandalDropdown(_linkednagarValue);
          populatelinkedVastiDropdown(_linkednagarValue);
        }
        if (initialData!.parentMandalID != null) {
          _isExpanded = true;
          _linkedmandalDisable = true;
          _linkedmandalValue = initialData!.parentMandalID.toString();
          populatelinkedGraamDropdown(_linkedmandalValue);
        }
        if (initialData!.levelName == "Vasti" && initialData!.geoUnitID != null) {
          _isExpanded = true;
          _linkedvastiDisable = true;
          _linkedvastiValue = initialData!.geoUnitID.toString();
        } else if (initialData!.levelName == "Graam" && initialData!.geoUnitID != null) {
          _isExpanded = true;
          _linkedgraamDisable = true;
          _linkedgraamValue = initialData!.geoUnitID.toString();
        } else if (initialData!.levelName == "Mandal" && initialData!.geoUnitID != null) {
          _isExpanded = true;
          _linkedmandalDisable = true;
          _linkedmandalValue = initialData!.geoUnitID.toString();
          populatelinkedGraamDropdown(_linkedmandalValue);
        } else if (initialData!.levelName == "Nagar" && initialData!.geoUnitID != null) {
          _isExpanded = true;
          _linkednagarDisable = true;
          _linkednagarValue = initialData!.geoUnitID.toString();
          populatelinkedMandalDropdown(_linkednagarValue);
          populatelinkedVastiDropdown(_linkednagarValue);
        } else if (initialData!.levelName == "Bhaag" && initialData!.geoUnitID != null) {
          _isExpanded = true;
          _linkedbhaagDisable = true;
          _linkedbhaagValue = initialData!.geoUnitID.toString();
          populatelinkedNagarDropdown(_linkedbhaagValue, null);
        } else {
          _isExpanded = false;
          // _linkedgraamDisable = true;
          _linkedbhaagValue = null;
          _linkedshaharValue = null;
          _linkednagarValue = null;
          _linkedmandalValue = null;
          _linkedgraamValue = null;
          _linkedvastiValue = null;
        }

      });

    }
   var data4 = await Statics.getStaticLDB("DaayitvaFor");
    var data5 = await Statics.getLevelLDB();
    var data6 = await Statics.getSanghaPreritSanstha("1", null, null);
    print("geoUnitId ${_linkedvastiValue ??_linkedgraamValue??_linkedmandalValue??
        _linkednagarValue??_linkedshaharValue??_linkedbhaagValue??_linkedVibhaagValue
        ??_linkedMahaanagarValue }");

   setState(() {
     geoUnitId = _linkedvastiValue ??_linkedgraamValue??_linkedmandalValue??
         _linkednagarValue??_linkedshaharValue??_linkedbhaagValue??_linkedVibhaagValue
         ??_linkedMahaanagarValue ;
      _daayitvaFor = data4;
      _level = data5;
      _sanghaPreritSanstha = data6;
    });
  }


  void populateGeoUnitforDaayitva(String levelID) async {
    var data4;
    if (levelID == "") {
      data4 = await Statics.getGeoUnitsByLevel(Statics.levels['MahaanagarLevelID']);
    } else
      data4 = await Statics.getGeoUnitsByLevel(levelID);
    setState(() {
      _geoUnits = data4;
    });
  }

  Future<List<DaayitvaMasterBAL>> populateDaayitva(String daayitvaId, String pattern) async {
    var data3 = await Statics.getDaayitvaLDB(daayitvaId, pattern, "");
    return data3;
  }


  void onSubmit(String? messageCustom,
      String? type,
      List<DaayitvaMasterBAL> selectedDayitvaSubType,
      List<dynamic> selectedSanghaPreritSanstha) {

    print("AppUserID  :--==>>>>  ${userDetails["userID"]}");
    print("Custome message  :--==>>>>  ${messageCustom}");
    print("type  :--==>>>>  ${type}");
    print("GeoUnitID  :--==>>>>  ${geoUnitId}");
    print("DayitvaIDs  :--==>>>>  ${selectedDayitvaSubType.map((e) => e.daayitvaID).join(",")}");
    print("SanghapreritSansthaIds  :--==>>>>  ${selectedSanghaPreritSanstha.join(",")}");

    var inputData = json.encode({
      "AppUserID": userDetails["userID"],
      "CustomMessage": messageCustom,
      "type": type,
      "GeoUnitID": geoUnitId,
      "DayitvaIDs": selectedDayitvaSubType.map((e) => e.daayitvaID).join(","),
      "SanghapreritSansthaIds": selectedSanghaPreritSanstha.join(","),
    });
    print("Suchana Request :--==>>>>  ${inputData}");
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: Center(
          child: Text(
          "${Statics.getLabel('createNotification')}",
            style: TextStyle(fontSize: 24),
            ),
        ),),
            drawer: AppDrawer(),
            body: Container(
              padding: EdgeInsets.all(10),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(width: 0.7, color: Colors.grey.shade700)),
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
                                "${Statics.getLabel('SelectLevel')}",
                                style: TextStyle(fontSize: 16),
                              ),
                            );
                          },
                          body: Container(
                            margin: EdgeInsets.all(10),
                            child: Column(
                              children: [
//===============================  DROPDOWN SECTION ================================================================
                                if(_linkedMahaanagar != null)
                                  IgnorePointer(
                                    ignoring: _linkedMahaanagarDisable!,
                                    child: DropdownButtonFormField(
                                      decoration: InputDecoration(labelText: Statics.getLabel('Mahaanagar')),
                                      isExpanded: true,
                                      value: _linkedMahaanagarValue == "" ? null : _linkedMahaanagarValue,
                                      items: _linkedMahaanagar!
                                          .map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!)))
                                          .toList(),
                                      onChanged: (value) {
                                        print(value);
                                        setState(() {
                                          _linkedMahaanagarValue = value;
                                          geoUnitId = value;
                                          _linkedVibhaagValue = null;
                                          _linkedMahaanagarDisable = false;
                                          _linkedVibhaagDisable = false;
                                          _linkedbhaagDisable = false;
                                          _linkedshaharDisable = false;
                                          _linkednagarDisable = false;
                                          _linkedmandalDisable = false;
                                          _linkedgraamDisable = false;
                                          _linkedvastiDisable = false;
                                          _linkedVibhaag = _linkedbhaag = _linkednagar = _linkedmandal = _linkedgraam = _linkedvasti = null;
                                          type = "mahanagar";
                                          populatelinkedVibhaagDropdown(value);
                                        });
                                      },
                                    ),
                                  ),
                                SizedBox(
                                  height: 10,
                                ),
                                if (_linkedVibhaag != null && _linkedVibhaag!.length > 0)
                                  IgnorePointer(
                                    ignoring: false,
                                    child: DropdownButtonFormField(
                                      decoration: InputDecoration(labelText: Statics.getLabel('Vibhaag')),
                                      isExpanded: true,
                                      value: _linkedVibhaagValue == "" ? null : _linkedVibhaagValue,
                                      items: _linkedVibhaag!
                                          .map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!)))
                                          .toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          _linkedVibhaagValue = value;
                                          geoUnitId = value;

                                          populatelinkedBhaagDropdown(value);
                                          _linkedMahaanagarDisable = false;
                                          _linkedVibhaagDisable = false;
                                          _linkedbhaagDisable = false;
                                          _linkedshaharDisable = false;
                                          _linkednagarDisable = false;
                                          _linkedmandalDisable = false;
                                          _linkedgraamDisable = false;
                                          _linkedvastiDisable = false;
                                          type = "vibhag";
                                        });
                                      },
                                    ),
                                  ),
                                if (_linkedVibhaag != null && _linkedVibhaag!.length > 0)
                                  SizedBox(
                                    height: 10,
                                  ),
                                if (_linkedbhaag != null && _linkedbhaag!.length > 0)
                                  IgnorePointer(
                                    ignoring: _linkedbhaagDisable!,
                                    child: DropdownButtonFormField(
                                      decoration: InputDecoration(labelText: Statics.getLabel('Bhaag')),
                                      isExpanded: true,
                                      value: _linkedbhaagValue == "" ? null : _linkedbhaagValue,
                                      items: _linkedbhaag!
                                          .map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!)))
                                          .toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          _linkedbhaagValue = value;
                                          geoUnitId = value;

                                          populatelinkedShaharDropdown(value);
                                          populatelinkedNagarDropdown(value, null);
                                          type = "bhag";
                                        });
                                      },
                                    ),
                                  ),
                                if (_linkedbhaag != null && _linkedbhaag!.length > 0)
                                  SizedBox(
                                    height: 10,
                                  ),
                                if (_linkedshahar != null && _linkedshahar!.length > 0)
                                  IgnorePointer(
                                    ignoring: _linkedshaharDisable!,
                                    child: DropdownButtonFormField(
                                      decoration: InputDecoration(labelText: Statics.getLabel('Shahar')),
                                      isExpanded: true,
                                      value: _linkedshaharValue == "" ? null : _linkedshaharValue,
                                      items: _linkedshahar!
                                          .map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!)))
                                          .toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          _linkedshaharValue = value;
                                          geoUnitId = value;

                                          populatelinkedNagarDropdown(null, value);
                                          type = "shahar";
                                        });
                                      },
                                    ),
                                  ),
                                if (_linkedshahar != null && _linkedshahar!.length > 0)
                                  SizedBox(
                                    height: 10,
                                  ),
                                if (_linkednagar != null && _linkednagar!.length > 0)
                                  IgnorePointer(
                                    ignoring: _linkednagarDisable!,
                                    child: DropdownButtonFormField(
                                      decoration: InputDecoration(labelText: Statics.getLabel('Nagar')),
                                      isExpanded: true,
                                      value: _linkednagarValue == "" ? null : _linkednagarValue,
                                      items: _linkednagar!
                                          .map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!)))
                                          .toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          _linkednagarValue = value;
                                          geoUnitId = value;

                                          populatelinkedMandalDropdown(value);
                                          populatelinkedVastiDropdown(value);
                                          type = "nagar";
                                        });
                                      },
                                    ),
                                  ),
                                if (_linkednagar != null && _linkednagar!.length > 0)
                                  SizedBox(
                                    height: 10,
                                  ),
                                if (_linkedmandal != null && _linkedmandal!.length > 0)
                                  IgnorePointer(
                                    ignoring: _linkedmandalDisable!,
                                    child: DropdownButtonFormField(
                                      decoration: InputDecoration(labelText: Statics.getLabel('Mandal')),
                                      isExpanded: true,
                                      value: _linkedmandalValue == "" ? null : _linkedmandalValue,
                                      items: _linkedmandal!
                                          .map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!)))
                                          .toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          _linkedmandalValue = value;
                                          geoUnitId = value;

                                          populatelinkedGraamDropdown(value);
                                          type = "mandal";
                                        });
                                      },
                                    ),
                                  ),
                                if (_linkedmandal != null && _linkedmandal!.length > 0)
                                  SizedBox(
                                    height: 10,
                                  ),
                                if (_linkedgraam != null && _linkedgraam!.length > 0)
                                  IgnorePointer(
                                    ignoring: _linkedgraamDisable!,
                                    child: DropdownButtonFormField(
                                      decoration: InputDecoration(labelText: Statics.getLabel('Graam')),
                                      isExpanded: true,
                                      value: _linkedgraamValue == "" ? null : _linkedgraamValue,
                                      items: _linkedgraam!
                                          .map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!)))
                                          .toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          _linkedgraamValue = value;
                                          geoUnitId = value;

                                          type = "gram";
                                        });
                                      },
                                    ),
                                  ),
                                if (_linkedvasti != null && _linkedvasti!.length > 0)
                                  IgnorePointer(
                                    ignoring: _linkedvastiDisable!,
                                    child: DropdownButtonFormField(
                                      decoration: InputDecoration(labelText: Statics.getLabel('Vasti')),
                                      isExpanded: true,
                                      value: _linkedvastiValue == "" ? null : _linkedvastiValue,
                                      items: _linkedvasti!
                                          .map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!)))
                                          .toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          _linkedvastiValue = value;
                                          geoUnitId = value;

                                          type = "vasti";
                                        });
                                      },
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          isExpanded: _isExpanded,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20,),
//===============================  Dayitwa SECTION ================================================================
                      Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(width: 0.7, color: Colors.grey.shade700)),
                        child: ExpansionPanelList(
                          elevation: 0,
                          expandedHeaderPadding: EdgeInsets.zero,
                          expansionCallback: (int index, bool isExpanded) {
                            setState(() {
                              _isExpanded2 = isExpanded;
                            });
                          },
                          children: [
                            ExpansionPanel(
                              backgroundColor: Colors.transparent,
                              headerBuilder: (BuildContext context, bool isExpanded) {
                                return ListTile(
                                  title: Text(
                                    "${Statics.getLabel('SelectDaayitvaLable')}",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  trailing: IconButton(onPressed: (){
                                    setState(() {
                                      _selectedDayitvaList = _selectedDayitvaItems =[];
                                      _selectedDaayitvaFor = [];
                                      _selectedPreritSanstha = [];
                                    });
                                  }, icon: Icon(Icons.refresh)),
                                );
                              },
                              body: Container(
                                margin: EdgeInsets.all(10),
                                child: Column(
                                  children: [
                                    if(_daayitvaFor != null)
                                      Column(
                                        children: [
                                          // MultiSelectDialogField(
                                          //   items: _daayitvaFor!
                                          //       .where((e) => e.codeForDisplay != "${Statics.getLabel('OtherSocialOrganization')}")
                                          //       .map((e) => MultiSelectItem(e, e.codeForDisplay!))
                                          //       .toList(),
                                          //   title: Text( "${Statics.getLabel('SelectDaayitvaFor')}",),
                                          //   selectedColor: Colors.purple,
                                          //   buttonText: Text( "${Statics.getLabel('SelectDaayitvaFor')}",),
                                          //   initialValue: _selectedDaayitvaFor,
                                          //   dialogHeight: 250,
                                          //   searchable: true,
                                          //
                                          //   onConfirm: (values) async {
                                          //     setState(() {
                                          //       _selectedDayitvaItems = [];
                                          //       _selectedDaayitvaFor = values.cast<StaticMasterBAL>();
                                          //     });
                                          //     List<DaayitvaMasterBAL> tempDayitvaList = [];
                                          //     for (var item in _selectedDaayitvaFor) {
                                          //       print("Fetching dayitva for: ID: ${item.staticID}, Name: ${item.codeForDisplay}");
                                          //       var dayitvaList = await Statics.getDaayitvaLDB(item.staticID.toString(), "", "");
                                          //       print("Fetched Dayitva: ${dayitvaList.map((e) => e.daayitvaName).toList()}");
                                          //       tempDayitvaList.addAll(dayitvaList);
                                          //     }
                                          //     bool isSanghaPreritSelected = _selectedDaayitvaFor.any((item) => item.staticID == 141);
                                          //
                                          //     setState(() {
                                          //       viewSanghaPreritDropDown = isSanghaPreritSelected;
                                          //       _selectedDayitvaList = tempDayitvaList;
                                          //     });
                                          //   },
                                          //   chipDisplay: MultiSelectChipDisplay(
                                          //     onTap: (value) {
                                          //       setState(() {
                                          //         _selectedDaayitvaFor.remove(value);
                                          //         bool isSanghaPreritSelected = _selectedDaayitvaFor.any((item) => item.staticID == 141);
                                          //         viewSanghaPreritDropDown = isSanghaPreritSelected;
                                          //       });
                                          //     },
                                          //   ),
                                          // ),
                                          MultiSelectDialogField(
                                            items: [
                                              MultiSelectItem("all", "Select All"), // Custom "Select All" Option
                                              ..._daayitvaFor!
                                                  .where((e) => e.codeForDisplay != "${Statics.getLabel('OtherSocialOrganization')}")
                                                  .map((e) => MultiSelectItem(e, e.codeForDisplay!))
                                                  .toList(),
                                            ],
                                            title: Text("${Statics.getLabel('SelectDaayitvaFor')}"),
                                            selectedColor: Colors.purple,
                                            buttonText: Text("${Statics.getLabel('SelectDaayitvaFor')}"),
                                            initialValue: _selectedDaayitvaFor,
                                            dialogHeight: 250,
                                            searchable: true,
                                            onConfirm: (values) async {
                                              setState(() {
                                                if (values.contains("all")) {
                                                  _selectedDaayitvaFor = _daayitvaFor!
                                                      .where((e) => e.codeForDisplay != "${Statics.getLabel('OtherSocialOrganization')}")
                                                      .toList();
                                                } else {
                                                  _selectedDaayitvaFor = values.cast<StaticMasterBAL>();
                                                }
                                                _selectedDayitvaItems = [];
                                              });

                                              List<DaayitvaMasterBAL> tempDayitvaList = [];
                                              for (var item in _selectedDaayitvaFor) {
                                                print("Fetching dayitva for: ID: ${item.staticID}, Name: ${item.codeForDisplay}");
                                                var dayitvaList = await Statics.getDaayitvaLDB(item.staticID.toString(), "", "");
                                                print("Fetched Dayitva: ${dayitvaList.map((e) => e.daayitvaName).toList()}");
                                                tempDayitvaList.addAll(dayitvaList);
                                              }

                                              bool isSanghaPreritSelected = _selectedDaayitvaFor.any((item) => item.staticID == 141);

                                              setState(() {
                                                viewSanghaPreritDropDown = isSanghaPreritSelected;
                                                _selectedDayitvaList = tempDayitvaList;
                                              });
                                            },
                                            chipDisplay: MultiSelectChipDisplay(
                                              scroll: true,
                                              onTap: (value) {
                                                setState(() {
                                                  _selectedDaayitvaFor.remove(value);
                                                  bool isSanghaPreritSelected = _selectedDaayitvaFor.any((item) => item.staticID == 141);
                                                  viewSanghaPreritDropDown = isSanghaPreritSelected;
                                                });
                                              },
                                            ),
                                          ),

                                        ],
                                      ),
                                    // SizedBox(height: 10),
                                    // Text("${_selectedDaayitvaFor.map((e) => e.staticID)}"),
                                    SizedBox(height: 10),
                                    // MultiSelectDialogField(
                                    //   dialogHeight: 400,
                                    //   items: _selectedDayitvaList.map((e) => MultiSelectItem(e, e.daayitvaName!)).toList(),
                                    //   title: Text( "${Statics.getLabel('SelectDaayitva')}",),
                                    //   selectedColor: Colors.blue,
                                    //   buttonText: Text( "${Statics.getLabel('SelectDaayitva')}",),
                                    //   initialValue: _selectedDayitvaItems,
                                    //   onConfirm: (values) {
                                    //     setState(() {
                                    //       _selectedDayitvaItems = values.cast<DaayitvaMasterBAL>();
                                    //     });
                                    //   },
                                    //   chipDisplay: MultiSelectChipDisplay(
                                    //     onTap: (value) {
                                    //
                                    //       setState(() {
                                    //
                                    //         _selectedDayitvaItems.remove(value);
                                    //       });
                                    //     },
                                    //   ),
                                    // ),
                                    MultiSelectDialogField(
                                      dialogHeight: 400,
                                      items: [
                                        MultiSelectItem("all", "Select All"), // Custom "Select All" option
                                        ..._selectedDayitvaList.map((e) => MultiSelectItem(e, e.daayitvaName!)).toList(),
                                      ],
                                      title: Text("${Statics.getLabel('SelectDaayitva')}"),
                                      selectedColor: Colors.blue,
                                      buttonText: Text("${Statics.getLabel('SelectDaayitva')}"),
                                      initialValue: _selectedDayitvaItems,
                                      searchable: true,
                                      onConfirm: (values) {
                                        setState(() {
                                          if (values.contains("all")) {
                                            _selectedDayitvaItems = _selectedDayitvaList.toList();
                                          } else {
                                            _selectedDayitvaItems = values.where((e) => e != "all").cast<DaayitvaMasterBAL>().toList();
                                          }
                                        });
                                      },
                                      chipDisplay: MultiSelectChipDisplay(
                                        scroll: true,
                                        onTap: (value) {
                                          setState(() {
                                            _selectedDayitvaItems.remove(value);
                                            // Auto deselect "Select All" if an item is removed
                                            if (_selectedDayitvaItems.length < _selectedDayitvaList.length) {
                                              _selectedDayitvaItems.remove("all");
                                            }
                                          });
                                        },
                                      ),
                                    ),

                                    // SizedBox(height: 10),
                                    // Text("${_selectedDayitvaItems.map((e) => e.daayitvaID)}"),
                                    SizedBox(height: 10),
                                    if(_sanghaPreritSanstha != null && viewSanghaPreritDropDown == true)
                                      // MultiSelectDialogField(
                                      //   searchable: true,
                                      //   dialogHeight: 300,
                                      //   items: _sanghaPreritSanstha!
                                      //       .map((bg) => MultiSelectItem(bg["SanghaPreritSansthaaID"].toString(), bg["SansthaaName"]))
                                      //       .toList(),
                                      //   title: Text(Statics.getLabel('SansthaaName')),
                                      //   selectedColor: Colors.purple,
                                      //   buttonText: Text(Statics.getLabel('SansthaaName')),
                                      //   initialValue: _selectedPreritSanstha,
                                      //   onConfirm: (values) {
                                      //     setState(() {
                                      //       _selectedPreritSanstha = values.cast<String>();
                                      //     });
                                      //   },
                                      //   chipDisplay: MultiSelectChipDisplay(
                                      //     scroll: true,
                                      //
                                      //     onTap: (value) {
                                      //       setState(() {
                                      //         _selectedPreritSanstha.remove(value);
                                      //       });
                                      //     },
                                      //   ),
                                      // ),
                                      MultiSelectDialogField(
                                        searchable: true,
                                        dialogHeight: 300,
                                        items: [
                                          MultiSelectItem("all", "Select All"), // Custom "Select All" option
                                          ..._sanghaPreritSanstha!.map((bg) => MultiSelectItem(bg["SanghaPreritSansthaaID"].toString(), bg["SansthaaName"])).toList(),
                                        ],
                                        title: Text(Statics.getLabel('SansthaaName')),
                                        selectedColor: Colors.purple,
                                        buttonText: Text(Statics.getLabel('SansthaaName')),
                                        initialValue: _selectedPreritSanstha,
                                        onConfirm: (values) {
                                          setState(() {
                                            if (values.contains("all")) {
                                              _selectedPreritSanstha = _sanghaPreritSanstha!.map((bg) => bg["SanghaPreritSansthaaID"].toString()).toList();
                                            } else {
                                             _selectedPreritSanstha = values.where((e) => e != "all").cast<String>().toList();
                                            }
                                          });
                                        },
                                        chipDisplay: MultiSelectChipDisplay(
                                          scroll: true,
                                          onTap: (value) {
                                            setState(() {
                                              _selectedPreritSanstha.remove(value);
                                              if (_selectedPreritSanstha.length < _sanghaPreritSanstha!.length) {
                                                _selectedPreritSanstha.remove("all");
                                              }
                                            });
                                          },
                                        ),
                                      ),

                                    // SizedBox(height: 10),
                                    // Text("${_selectedPreritSanstha}"),

                                  ],
                                ),
                              ),
                              isExpanded: _isExpanded2,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10,),

//===============================  TextFIled SECTION ================================================================
                      Container(
                        padding: EdgeInsets.all(10),
                        child: SizedBox(
                          height: 150,
                          child: TextFormField(
                            controller: customMessageController,
                            maxLines: null,
                            expands: true,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: Statics.getLabel('CustMessage'),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) return (Statics.getLabel('validationMessage'));
                              return null;
                            },
                          ),
                        ),
                      ),



//===============================  Button SECTION ================================================================
                      Container(
                        padding: EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            MaterialButton(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                              padding: EdgeInsets.symmetric(
                                horizontal: 35,
                                vertical: 5,
                              ),
                              color: Theme.of(context).primaryColor,
                              textColor: Theme.of(context).primaryTextTheme.button!.color,
                              onPressed: () async {
                                if (   customMessageController.text == "") {
                                  Statics.showToast("कस्टम मेसेज एंटर करा");
                                  return null;
                                } else {
                                  onSubmit(
                                      customMessageController.text,type,_selectedDayitvaItems,_selectedPreritSanstha
                                  );}
                              },
                              child: Text(
                                "${Statics.getLabel('Submit')}",
                                style: TextStyle(fontSize: 22),
                              ),
                            ),
                            MaterialButton(
                                onPressed: () {
                                  setState(() {
                                    _selectedDayitvaList = _selectedDayitvaItems =[];
                                     _selectedDaayitvaFor = [];
                                    _selectedPreritSanstha = [];
                                    _linkedMahaanagarValue =  _linkedbhaagValue =_linkedshaharValue = _linkednagarValue = _linkedmandalValue = _linkedvastiValue = _linkedgraamValue = null;
                                    _linkedVibhaagValue = _linkedbhaag = _linkedshahar = _linkedgraam = _linkedmandal = _linkedvasti = _linkednagar = null;
                                    customMessageController.clear();
                                    geoUnitId ="";
                                    type ="praant";
                                    _isExpanded2 = _isExpanded = false;
                                    populateDropdown();
                                  });
                                },
                                child: Text(Statics.getLabel('clear'))),
                          ],
                        ),
                      ),
                ]),
              ),
            )
      ,
    );
  }
}
