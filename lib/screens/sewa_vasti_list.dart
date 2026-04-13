import 'dart:convert';

import 'package:flutter/material.dart';

import '../helpers/static_data.dart' as Statics;
import '../providers/bals.dart';
import '../screens/edit_sewa_vasti.dart';
import '../widgets/app_drawer.dart';
import '../widgets/sewa_vasti_card.dart';
import 'home_screen/home_screen.dart';

class SearchSewaVasti extends StatefulWidget {
  static const routeName = '/search-sewavasti-screen';

  @override
  _SearchSewaVastiState createState() => _SearchSewaVastiState();
}

class _SearchSewaVastiState extends State<SearchSewaVasti> {
  Future<List<dynamic>>? _sewaVastiList;
  bool _isSearching = false;
  bool _isExpanded = false;

  List<GeoUnitMasterBAL>? _bhaag;
  List<GeoUnitMasterBAL>? _shahar;
  List<GeoUnitMasterBAL>? _nagar;

  String? _bhaagValue = "";
  String? _shaharValue = "";
  String? _nagarValue = "";
  int? geoUnitIDnew;

  List<GeoUnitMasterBAL>? _linkedMahaanagar;
  List<GeoUnitMasterBAL>? _linkedVibhaag;
  List<GeoUnitMasterBAL>? _linkedbhaag;
  List<GeoUnitMasterBAL>? _linkedshahar;
  List<GeoUnitMasterBAL>? _linkednagar;
  List<GeoUnitMasterBAL>? _linkedmandal;
  List<GeoUnitMasterBAL>? _linkedgraam;
  List<GeoUnitMasterBAL>? _linkedvasti;

  String? _linkedMahaanagarValue = '';
  String? _linkedVibhaagValue = '';
  String? _linkedbhaagValue = "";
  String? _linkedshaharValue = "";
  String? _linkednagarValue = "";
  String? _linkedmandalValue = "";
  String? _linkedgraamValue = "";
  String? _linkedvastiValue = "";
  String? type;

  @override
  void initState() {
    super.initState();
    populateDropdown();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    populateBhaagDropdown();
    _sewaVastiList = _getSewaVastiLst(-1, null, null, null, null, null, null, null, null);
  }

  void onSaveDetails() {
    var data = _getSewaVastiLst(
        (_linkedMahaanagarValue == null || _linkedMahaanagarValue == "" ? null : int.parse(_linkedMahaanagarValue!)),
        (_linkedVibhaagValue == null || _linkedVibhaagValue == "" ? null : int.parse(_linkedVibhaagValue!)),
        (_linkedbhaagValue == null || _linkedbhaagValue == "" ? null : int.parse(_linkedbhaagValue!)),
        (_linkednagarValue == null || _linkednagarValue == "" ? null : int.parse(_linkednagarValue!)),
        (_linkedvastiValue == null || _linkedvastiValue == "" ? null : int.parse(_linkedvastiValue!)),
        (_linkedgraamValue == null || _linkedgraamValue == "" ? null : int.parse(_linkedgraamValue!)),
        (_linkedmandalValue == null || _linkedmandalValue == "" ? null : int.parse(_linkedmandalValue!)),
        null,
        geoUnitIDnew);
    setState(() {
      _sewaVastiList = data;
    });
  }

  void populateBhaagDropdown() async {
    _shaharValue = _nagarValue = null;
    var data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['BhaagLevelID'].toString(), "", "", "");
    setState(() {
      _bhaag = data;
      _isSearching = false;
    });
  }

  void populateShaharDropdown(String bhaagIDStr) async {
    _shaharValue = null;
    _shahar = null;
    var shDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['ShaharLevelID'].toString(), bhaagIDStr, 'Bhaag', '');
    setState(() {
      _shahar = (shDD.length > 0 ? shDD : null);
    });
  }

  void populateNagarDropdown(String? bhaagIDStr, String? shaharIDStr) async {
    _nagarValue = null;

    _nagar = null;
    if (shaharIDStr != null) {
      var ngDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['NagarLevelID'].toString(), shaharIDStr, 'Shahar', '');
      setState(() {
        _nagar = (ngDD.length > 0 ? ngDD : null);
      });
    } else {
      var ngDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['NagarLevelID'].toString(), bhaagIDStr!, 'Bhaag', '');
      setState(() {
        _nagar = (ngDD.length > 0 ? ngDD : null);
      });
    }
  }

  Future<List<dynamic>> _getSewaVastiLst(int? mahanagar, int? vibhag, int? bhag, int? nagar, int? vasti, int? gram, int? manadal, int? sewaVastiID, int? geounitID) async {
    bool isConnected = await Statics.isInternetConnected();
    if (isConnected) {
      String strInput = json.encode({
        "AppUserID": Statics.userDetails['userID'],
        "MahanagarID": mahanagar,
        "VibhaagID": vibhag,
        "BhaagID": bhag,
        "ShaharID": _shaharValue,
        "NagarID": nagar,
        "VastiID": vasti,
        "GraamID": gram,
        "MandalID": manadal,
        "SewaVastiID": sewaVastiID,
        "GeoUnitId": geounitID
      });

      return Statics.getSewaVastiForApp(strInput);
    } else {
      Statics.showMessageDialog(context, Statics.getLabel('internetNotConnected'));
      return [];
    }
  }

  Future<void> _search() async {
    setState(() {
      _isSearching = true;
    });

    int? mahanagar = _linkedMahaanagarValue == null || _linkedMahaanagarValue == "" ? null : int.parse(_linkedMahaanagarValue!);
    int? vibhag = _linkedVibhaagValue == null || _linkedVibhaagValue == "" ? null : int.parse(_linkedVibhaagValue!);
    int? bhag = _linkedbhaagValue == null || _linkedbhaagValue == "" ? null : int.parse(_linkedbhaagValue!);
    int? nagar = _linkednagarValue == null || _linkednagarValue == "" ? null : int.parse(_linkednagarValue!);
    int? vasti = _linkedvastiValue == null || _linkedvastiValue == "" ? null : int.parse(_linkedvastiValue!);
    int? gram = _linkedgraamValue == null || _linkedgraamValue == "" ? null : int.parse(_linkedgraamValue!);
    int? manadal = _linkedmandalValue == null || _linkedmandalValue == "" ? null : int.parse(_linkedmandalValue!);

    setState(() {
      _sewaVastiList = _getSewaVastiLst(mahanagar, vibhag, bhag, nagar, vasti, gram, manadal, null, geoUnitIDnew);
      _isSearching = false;
      _isExpanded = false;
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

    setState(() {
      _linkedbhaagValue = null;
      _linkedshaharValue = null;
      _linkednagarValue = null;
      _linkedmandalValue = null;
      _linkedgraamValue = null;
      _linkedvastiValue = null;
    });
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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.popAndPushNamed(context, HomeScreen.routeName);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            Statics.getLabel('searchSewaVastiScreenLabel'),
            style: TextStyle(fontSize: 24),
          ),
          actions: <Widget>[
            // if ((Statics.userDetails['LevelName'] == 'Praant' ||
            //         Statics.userDetails['LevelName'] == 'Mahaanagar' ||
            //         Statics.userDetails['LevelName'] == 'Bhaag' ||
            //         Statics.userDetails['LevelName'] == 'Vibhaag' ||
            //         Statics.userDetails['LevelName'] == 'प्रांत' ||
            //         Statics.userDetails['LevelName'] == 'महानगर' ||
            //         Statics.userDetails['LevelName'] == 'भाग/जिल्हा' ||
            //         Statics.userDetails['LevelName'] == 'Nagar\/Taalukaa' ||
            //         Statics.userDetails['LevelName'] == 'Nagar' ||
            //         Statics.userDetails["LevelName"] == "नगर/तालुका" ||
            //         Statics.userDetails['LevelName'] == 'विभाग' ||
            //         Statics.userDetails["LevelName"] == "Bhaag" ||
            //         Statics.userDetails["LevelName"] == "भाग/जिला" ||
            //         Statics.userDetails["LevelName"] == "भाग/जिल्हा")
            //     // &&
            //     // (Statics.userDetails["DaayitvaName"] == "Join RSS Sanyojak" ||
            //     //     Statics.userDetails["DaayitvaName"] == "जॉयन आर.एस.एस. संयोजक" ||
            //     //     Statics.userDetails["DaayitvaName"] == "Join RSS Pramukh" ||
            //     //     Statics.userDetails["DaayitvaName"] == "जॉयन आर.एस.एस. प्रमुख" ||
            //     //     Statics.userDetails["DaayitvaName"] == "Baal Vidyaarthi Pramukh" ||
            //     //     Statics.userDetails["DaayitvaName"] == "बाल विद्यार्थी प्रमुख" ||
            //     //     Statics.userDetails["DaayitvaName"] == "बाल विद्यार्थी प्रमुख" ||
            //     //     Statics.userDetails["DaayitvaName"] == "Mahaavidyaalayeen Vidyaarthi Pramukh" ||
            //     //     Statics.userDetails["DaayitvaName"] == "महाविद्यालयीन प्रमुख" ||
            //     //     Statics.userDetails["DaayitvaName"] == "महाविद्यालयीन प्रमुख" ||
            //     //     Statics.userDetails["DaayitvaName"] == "Vyavasaayee Pramukh" ||
            //     //     Statics.userDetails["DaayitvaName"] == "व्यवसायी प्रमुख" ||
            //     //     Statics.userDetails["DaayitvaName"] == "व्यवसायी प्रमुख" ||
            //     //     Statics.userDetails["DaayitvaName"] == "Vyavasaayee Saha-Pramukh" ||
            //     //     Statics.userDetails["DaayitvaName"] == "व्यवसायी सह प्रमुख" ||
            //     //     Statics.userDetails["DaayitvaName"] == "व्यवसायी सह प्रमुख" ||
            //     //     Statics.userDetails["DaayitvaName"] == "Tarun Vyavsayee Pramukh" ||
            //     //     Statics.userDetails["DaayitvaName"] == "तरुण व्यवसायी प्रमुख" ||
            //     //     Statics.userDetails["DaayitvaName"] == "तरुण व्यवसायी प्रमुख" ||
            //     //     Statics.userDetails["DaayitvaName"] == "Praudh Vyavsayee Pramukh" ||
            //     //     Statics.userDetails["DaayitvaName"] == "प्रौढ व्यवसायी प्रमुख" ||
            //     //     Statics.userDetails["DaayitvaName"] == "प्रौढ व्यवसायी प्रमुख" ||
            //     //     Statics.userDetails["DaayitvaName"] == "Tarun Vyavsayee Sah Pramukh" ||
            //     //     Statics.userDetails["DaayitvaName"] == "तरुण व्यवसायी सह प्रमुख" ||
            //     //     Statics.userDetails["DaayitvaName"] == "तरुण व्यवसायी सह प्रमुख" ||
            //     //     Statics.userDetails["DaayitvaName"] == "Praudh Vyavsayee Sah Pramukh" ||
            //     //     Statics.userDetails["DaayitvaName"] == "प्रौढ व्यवसायी सह प्रमुख" ||
            //     //     Statics.userDetails["DaayitvaName"] == "प्रौढ व्यवसायी सह प्रमुख" ||
            //     //     Statics.userDetails["DaayitvaName"] == "Bal Vidyarthi Sah Pramukh" ||
            //     //     Statics.userDetails["DaayitvaName"] == "बाल विद्यार्थी सह प्रमुख" ||
            //     //     Statics.userDetails["DaayitvaName"] == "बाल विद्यार्थी सह प्रमुख" ||
            //     //     Statics.userDetails["DaayitvaName"] == "Mahavidyaleen Vidyarthi Sah Pramukh" ||
            //     //     Statics.userDetails["DaayitvaName"] == "महाविद्यालयीन विद्यार्थी सह प्रमुख" ||
            //     //     Statics.userDetails["DaayitvaName"] == "महाविद्यालयीन विद्यार्थी सह प्रमुख" ||
            //     //     Statics.userDetails["DaayitvaName"] == "App Sanyojak" ||
            //     //     Statics.userDetails["DaayitvaName"] == "एप संयोजक" ||
            //     //     Statics.userDetails["DaayitvaName"] == "Kaaryavaah" ||
            //     //     Statics.userDetails["DaayitvaName"] == "कार्यवाह" ||
            //     //     Statics.userDetails["DaayitvaName"] == "karyalay sachiv" ||
            //     //     Statics.userDetails["DaayitvaName"] == "कार्यालय सचिव" ||
            //     //     Statics.userDetails["DaayitvaName"] == "Saha-Kaaryavaah" ||
            //     //     Statics.userDetails["DaayitvaName"] == "सह कार्यवाह" ||
            //     //     Statics.userDetails["DaayitvaName"] == "Sewa Pramukh" ||
            //     //     Statics.userDetails["DaayitvaName"] == "सेवा प्रमुख" ||
            //     //     Statics.userDetails["DaayitvaName"] == "Saha-SewaPramukh" ||
            //     //     Statics.userDetails["DaayitvaName"] == "Sewa Vibhaag - Toli Sadasya" ||
            //     //     Statics.userDetails["DaayitvaName"] == "सेवा विभाग टोली सदस्य" ||
            //     //     Statics.userDetails["DaayitvaName"] == "Sewa Saha-Pramukh" ||
            //     //     Statics.userDetails["DaayitvaName"] == "सेवा सह प्रमुख" ||
            //     //     Statics.userDetails["DaayitvaName"] == "सेवा सह प्रमुख" ||
            //     //     Statics.userDetails['DaayitvaName'] == 'Kaaryaalay Pramukh' ||
            //     //     Statics.userDetails['DaayitvaName'] == 'कार्यालय प्रमुख' ||
            //     //     Statics.userDetails['DaayitvaName'] == 'Prachaarak' ||
            //     //     Statics.userDetails['DaayitvaName'] == 'प्रचारक' ||
            //     //     Statics.userDetails['DaayitvaName'] == 'Saha-Prachaarak' ||
            //     //     Statics.userDetails['DaayitvaName'] == 'सह प्रचारक' ||
            //     //     Statics.userDetails["DaayitvaName"] == "Kaaryavaah" ||
            //     //     Statics.userDetails["DaayitvaName"] == "कार्यवाह" ||
            //     //     Statics.userDetails["DaayitvaName"] == "karyalay sachiv" ||
            //     //     Statics.userDetails["DaayitvaName"] == "कार्यालय सचिव")
            //     )
            if ((int.tryParse(Statics.userDetails["LevelID"]?.toString() ?? "0") ?? 0) > 1)
              IconButton(
                padding: EdgeInsets.all(8),
                icon: const Icon(Icons.add),
                onPressed: () {
                  Navigator.of(context).pushNamed(EditSewaVasti.routeName, arguments: Statics.ScreenArguments(0, Statics.getLabel('EditMenu')));
                },
              ),
          ],
        ),
        drawer: AppDrawer(),
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(10),
            child: Column(
              children: <Widget>[
                SizedBox(height: 10),
                Text(
                  Statics.getLabel('searchSewaVastiScreenBanner'),
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 10),
                ExpansionPanelList(
                  expansionCallback: (int index, bool isExpanded) {
                    setState(() {
                      _isExpanded = isExpanded;
                    });
                  },
                  children: [
                    ExpansionPanel(
                      headerBuilder: (BuildContext context, bool isExpanded) {
                        return ListTile(
                          title: Text(Statics.getLabel('Filters')),
                        );
                      },
                      body: Container(
                        margin: EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Container(
                              margin: EdgeInsets.all(10),
                              child: Column(
                                children: [
                                  if (_linkedMahaanagar != null)
                                    DropdownButtonFormField(
                                      decoration: InputDecoration(labelText: Statics.getLabel('Mahaanagar')),
                                      isExpanded: true,
                                      value: _linkedMahaanagarValue == "" ? null : _linkedMahaanagarValue,
                                      items: _linkedMahaanagar!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                                      onChanged: (value) {
                                        print(value);
                                        setState(() {
                                          _linkedMahaanagarValue = value;
                                          _linkedVibhaagValue = null;

                                          _linkedVibhaag = _linkedbhaag = _linkednagar = _linkedmandal = _linkedgraam = _linkedvasti = null;
                                          type = "mahanagar";
                                          populatelinkedVibhaagDropdown(value);
                                        });
                                      },
                                    ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  if (_linkedVibhaag != null && _linkedVibhaag!.length > 0)
                                    DropdownButtonFormField(
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
                                  if (_linkedVibhaag != null && _linkedVibhaag!.length > 0)
                                    SizedBox(
                                      height: 10,
                                    ),
                                  if (_linkedbhaag != null && _linkedbhaag!.length > 0)
                                    DropdownButtonFormField(
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
                                  if (_linkedbhaag != null && _linkedbhaag!.length > 0)
                                    SizedBox(
                                      height: 10,
                                    ),
                                  if (_linkedshahar != null && _linkedshahar!.length > 0)
                                    DropdownButtonFormField(
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
                                  if (_linkedshahar != null && _linkedshahar!.length > 0)
                                    SizedBox(
                                      height: 10,
                                    ),
                                  if (_linkednagar != null && _linkednagar!.length > 0)
                                    DropdownButtonFormField(
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
                                  if (_linkednagar != null && _linkednagar!.length > 0)
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
                                        setState(() {
                                          _linkedmandalValue = value;
                                          populatelinkedGraamDropdown(value);
                                          type = "mandal";
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
                                        setState(() {
                                          _linkedgraamValue = value;
                                          type = "gram";
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
                                        setState(() {
                                          _linkedvastiValue = value;
                                          type = "vasti";
                                        });
                                      },
                                    ),
                                ],
                              ),
                            ),
                            // if(_bhaag != null)
                            // DropdownButtonFormField(
                            //   decoration: InputDecoration(labelText: Statics.getLabel('Bhaag')),
                            //   isExpanded: true,
                            //   value: _bhaagValue == "" ? null : _bhaagValue,
                            //   items: _bhaag!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                            //   onChanged: (value) {
                            //     setState(() {
                            //       _bhaagValue = value;
                            //       populateShaharDropdown(value!);
                            //       populateNagarDropdown(value, null);
                            //     });
                            //   },
                            // ),
                            // SizedBox(
                            //   height: 10,
                            // ),
                            // if (_shahar != null && _shahar!.length > 0)
                            //   DropdownButtonFormField(
                            //     decoration: InputDecoration(labelText: Statics.getLabel('Shahar')),
                            //     isExpanded: true,
                            //     value: _shaharValue == "" ? null : _shaharValue,
                            //     items: _shahar!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                            //     onChanged: (value) {
                            //       setState(() {
                            //         _shaharValue = value;
                            //         populateNagarDropdown(null, value);
                            //       });
                            //     },
                            //   ),
                            // if (_shahar != null && _shahar!.length > 0)
                            //   SizedBox(
                            //     height: 10,
                            //   ),
                            // if (_nagar != null && _nagar!.length > 0)
                            //   DropdownButtonFormField(
                            //     decoration: InputDecoration(labelText: Statics.getLabel('Nagar')),
                            //     isExpanded: true,
                            //     value: _nagarValue == "" ? null : _nagarValue,
                            //     items: _nagar!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                            //     onChanged: (value) {
                            //       setState(() {
                            //         _nagarValue = value;
                            //       });
                            //     },
                            //   ),
                            // if (_nagar != null && _nagar!.length > 0)
                            //   SizedBox(
                            //     height: 10,
                            //   ),
                          ],
                        ),
                      ),
                      isExpanded: _isExpanded,
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      if (_isSearching)
                        CircularProgressIndicator()
                      else
                        Wrap(
                          children: [
                            MaterialButton(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                              padding: EdgeInsets.symmetric(
                                horizontal: 15,
                                vertical: 8,
                              ),
                              color: Theme.of(context).primaryColor,
                              textColor: Theme.of(context).primaryTextTheme.labelMedium?.color,
                              onPressed: _search,
                              child: Text(
                                Statics.getLabel('Search'),
                                style: TextStyle(fontSize: 25),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            MaterialButton(
                                onPressed: () {
                                  setState(() {
                                    _linkedMahaanagarValue =
                                        _linkedVibhaagValue = _linkedbhaagValue = _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = _bhaagValue = _shaharValue = _nagarValue = null;
                                    _linkedbhaag = _linkedmandal = _linkednagar = _linkedgraam = _linkedmandal = _linkedvasti = _bhaag = _shahar = _nagar = null;
                                  });
                                  populateBhaagDropdown();
                                },
                                child: Text(Statics.getLabel('clear'))),
                          ],
                        ),
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.75,
                  child: FutureBuilder<List<dynamic>>(
                    future: _sewaVastiList,
                    builder: (ctx, dataSnapshot) {
                      //print(dataSnapshot.connectionState.toString());
                      //print(dataSnapshot.hasData.toString());
                      //print(_isSearching.toString());

                      if (dataSnapshot.connectionState != ConnectionState.done) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (dataSnapshot.hasError) {
                        return Center(
                            child: Text(
                          'Server Error, Please Try Again Later',
                          style: TextStyle(color: Colors.red),
                        ));
                      }
                      return dataSnapshot.hasData && dataSnapshot.data!.length > 0
                          ? ListView.separated(
                              separatorBuilder: (context, index) => SizedBox(height: 8),
                              itemCount: dataSnapshot.data!.length,
                              itemBuilder: (context, index) => SewaVastiCard(dataSnapshot.data![index], onSaveDetails),
                            )
                          : Padding(
                              padding: const EdgeInsets.only(bottom: 178.0),
                              child: Center(child: Text(Statics.getLabel('noDataFoundTryAnotherSearch'))),
                            );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
