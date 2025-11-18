import 'package:flutter/material.dart';

import '../../../helpers/static_data.dart' as Statics;
import '../../../models/response_model/AbhiyaanListResponse.dart';
import '../../../models/response_model/AbhiyaanLoginDataResponse.dart';
import '../../../providers/bals.dart';
import '../../../providers/swayamsevak_provider.dart';

class GruhSamparkaReportTab extends StatefulWidget {
  final AbhiyanSwayamsevakdata? initialData;

  const GruhSamparkaReportTab({super.key, this.initialData});

  @override
  State<GruhSamparkaReportTab> createState() => _GruhSamparkaReportTabState();
}

class _GruhSamparkaReportTabState extends State<GruhSamparkaReportTab> {
  bool _isSearching = false;

  String? selectedGruhaAbhiyanValue = "";
  List<AbhiyaanList> abhiyaanDataList = [
    AbhiyaanList.fromJson({
      "AbhiyaanID": 1,
      "AbhiyaanName": Statics.getLabel('gruhSamparkAbhiyan') + " (${Statics.getLabel('shatabdiVarsha')})",
      "EndDate": null,
      "EndDateStr": null,
      "PraantID": 1,
      "Remark": "C1-10 Rs, C2-100 Rs, C3-1000 Rs",
      "StartDate": null,
      "StartDateStr": null
    })
  ];

  // List<AbhiyanSwayamsevakList> abhiyaanSwayamsevakDataList = [];

  List<LevelMasterBAL>? _level;
  List<GeoUnitMasterBAL>? _geoUnits;
  String? _levelValue = "";
  String? _geoUnitsValue = "";

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
  String? type;
  List<MenuChoices> choices = [];
  String? selectedDayitvValue = "";

  bool _isExpanded = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    populateDropdown();
    Future.delayed(Duration.zero, () async {
      // await getAbhiyaanListData();
      selectedGruhaAbhiyanValue = abhiyaanDataList.first.abhiyaanID.toString();
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
    // if (widget.initialData != null) {
    setState(() {
      //     if (widget.initialData!.parentMahaanagarID != null) {
      //       _isExpanded = true;
      //       _linkedMahaanagarDisable = true;
      //       _linkedMahaanagarValue = widget.initialData!.parentMahaanagarID.toString();
      //     }
      //     if (widget.initialData!.parentVibhaagID != null) {
      //       populatelinkedVibhaagDropdown('');
      //       _isExpanded = true;
      //       _linkedVibhaagDisable = true;
      //       _linkedVibhaagValue = widget.initialData!.parentVibhaagID.toString();
      //     }
      //     if (widget.initialData!.parentBhaagID != null) {
      //       _isExpanded = true;
      //       _linkedbhaagDisable = true;
      //       _linkedbhaagValue = widget.initialData!.parentBhaagID.toString();
      //       populatelinkedNagarDropdown(_linkedbhaagValue, null);
      //     }
      //     if (widget.initialData!.parentNagarID != null) {
      //       _isExpanded = true;
      //       _linkednagarDisable = true;
      //       _linkednagarValue = widget.initialData!.parentNagarID.toString();
      //       populatelinkedMandalDropdown(_linkednagarValue);
      //       populatelinkedVastiDropdown(_linkednagarValue);
      //     }
      //     if (widget.initialData!.parentMandalID != null) {
      //       _isExpanded = true;
      //       _linkedmandalDisable = true;
      //       _linkedmandalValue = widget.initialData!.parentMandalID.toString();
      //       populatelinkedGraamDropdown(_linkedmandalValue);
      //     }
      //     if (widget.initialData!.levelName == "Vasti" && widget.initialData!.geoUnitID != null) {
      //       _isExpanded = true;
      //       _linkedvastiDisable = true;
      //       _linkedvastiValue = widget.initialData!.geoUnitID.toString();
      //     } else if (widget.initialData!.levelName == "Graam" && widget.initialData!.geoUnitID != null) {
      //       _isExpanded = true;
      //       _linkedgraamDisable = true;
      //       _linkedgraamValue = widget.initialData!.geoUnitID.toString();
      //     } else if (widget.initialData!.levelName == "Mandal" && widget.initialData!.geoUnitID != null) {
      //       _isExpanded = true;
      //       _linkedmandalDisable = true;
      //       _linkedmandalValue = widget.initialData!.geoUnitID.toString();
      //       populatelinkedGraamDropdown(_linkedmandalValue);
      //     } else if (widget.initialData!.levelName == "Nagar" && widget.initialData!.geoUnitID != null) {
      //       _isExpanded = true;
      //       _linkednagarDisable = true;
      //       _linkednagarValue = widget.initialData!.geoUnitID.toString();
      //       populatelinkedMandalDropdown(_linkednagarValue);
      //       populatelinkedVastiDropdown(_linkednagarValue);
      //     } else if (widget.initialData!.levelName == "Bhaag" && widget.initialData!.geoUnitID != null) {
      //       _isExpanded = true;
      //       _linkedbhaagDisable = true;
      //       _linkedbhaagValue = widget.initialData!.geoUnitID.toString();
      //       populatelinkedNagarDropdown(_linkedbhaagValue, null);
      //     } else {
      _isExpanded = true;
      // _linkedgraamDisable = true;
      _linkedbhaagValue = null;
      _linkedshaharValue = null;
      _linkednagarValue = null;
      _linkedmandalValue = null;
      _linkedgraamValue = null;
      _linkedvastiValue = null;
      // }
    });
    // }
  }

  populatelinkedMahaanagarDropdown() async {
    _linkedVibhaagValue = _linkedbhaagValue = _linkednagarValue = _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = null;
    var data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['MahaanagarLevelID'].toString(), '', '', '');
    setState(() {
      _linkedMahaanagar = data;
    });
  }

  populatelinkedVibhaagDropdown(String? mahaanagarIDStr) async {
    _linkedbhaagValue = _linkednagarValue = _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = null;
    var data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['VibhaagLevelID'].toString(), mahaanagarIDStr!, (mahaanagarIDStr.isEmpty ? '' : 'Mahaanagar'), '');
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

  getAbhiyaanListData() async {
    try {
      bool isConnected = await Statics.isInternetConnected();
      if (isConnected) {
        setState(() {
          _isSearching = true;
        });
        var result = await SwayamsevakProvider().getAbhiyanList();
        if (result.status == "200") {
          print("succeed");
          abhiyaanDataList = result.abhiyaanList!;
          selectedGruhaAbhiyanValue = abhiyaanDataList.first.abhiyaanID.toString();

          setState(() {
            _isSearching = false;
          });
        } else {
          setState(() {
            _isSearching = false;
          });
          Statics.showToast(Statics.getLabel('noDataFoundTryAnotherSearch').split(",").first);
        }
      }
    } catch (e) {
      print(e);
      setState(() {
        _isSearching = false;
      });
      Statics.showToast(Statics.getLabel('noDataFoundTryAnotherSearch').split(",").first);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 25,
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  "${Statics.getLabel('Abhiyaan')} ${Statics.getLabel('Reportonly')}",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(left: 5, right: 0, top: 5, bottom: 5),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: Colors.black38)),
                  child: DropdownButton(
                    isExpanded: true,
                    isDense: true,
                    iconSize: 30,
                    underline: SizedBox(),
                    value: selectedGruhaAbhiyanValue == "" ? null : selectedGruhaAbhiyanValue,
                    onChanged: (newValue) {
                      print(newValue);
                      setState(() {
                        selectedGruhaAbhiyanValue = newValue;
                      });
                    },
                    items: abhiyaanDataList.map((value) {
                      return DropdownMenuItem(
                        value: value.abhiyaanID.toString(),
                        child: Text(value.abhiyaanName!),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.9,
            // margin: EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(width: 0.7, color: Colors.grey.shade700)),
            child: ExpansionPanelList(
              elevation: 0,
              expandedHeaderPadding: EdgeInsets.zero,
              expansionCallback: (int index, bool isExpanded) {
                setState(() {
                  _isExpanded = isExpanded;
                  // if(_swSthaanList != null){
                  //   _search2("Search");
                  // }
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
                        if (_linkedMahaanagar != null)
                          IgnorePointer(
                            ignoring: _linkedMahaanagarDisable!,
                            child: DropdownButtonFormField(
                              decoration: InputDecoration(labelText: Statics.getLabel('Mahaanagar')),
                              isExpanded: true,
                              value: _linkedMahaanagarValue == "" ? null : _linkedMahaanagarValue,
                              items: _linkedMahaanagar!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                              onChanged: (value) {
                                print(value);
                                setState(() {
                                  _linkedMahaanagarValue = value;
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
                              items: _linkedVibhaag!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _linkedVibhaagValue = value;
                                  populatelinkedBhaagDropdown(value);
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
                              items: _linkedbhaag!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _linkedbhaagValue = value;
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
                              items: _linkedshahar!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _linkedshaharValue = value;
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
                              items: _linkednagar!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _linkednagarValue = value;
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
                              items: _linkedmandal!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _linkedmandalValue = value;
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
                              items: _linkedgraam!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _linkedgraamValue = value;
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
                              items: _linkedvasti!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _linkedvastiValue = value;
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
          SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MaterialButton(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                padding: EdgeInsets.symmetric(
                  horizontal: 35,
                  vertical: 5,
                ),
                color: Theme.of(context).primaryColor,
                textColor: Theme.of(context).primaryTextTheme.labelMedium?.color,
                onPressed: () async {
                  // if(Statics.userDetails[])
                  // await getAbhiyaanGruhaSamparkListData();
                },
                child: Text(
                  "${Statics.getLabel('search')}",
                  style: TextStyle(fontSize: 22),
                ),
              ),
              MaterialButton(
                  onPressed: () {
                    setState(() {
                      _linkedMahaanagarValue = _linkedbhaagValue = _linkedshaharValue = _linkednagarValue = _linkedmandalValue = _linkedvastiValue = _linkedgraamValue = null;
                      _linkedVibhaagValue = _linkedbhaag = _linkedshahar = _linkedgraam = _linkedmandal = _linkedvasti = _linkednagar = null;
                      type = "praant";
                    });
                  },
                  child: Text(Statics.getLabel('clear'))),
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.03,
          ),
        ],
      ),
    ));
  }
}
