import 'dart:convert';

import 'package:flutter/material.dart';

import '../../helpers/static_data.dart' as Statics;
import '../../models/response_model/dropdown_level_responsemodel.dart';
import '../../models/response_model/geounit_name_model.dart';
import '../../providers/bals.dart';
import '../../utils/globals.dart';

class UpdateMasterDataScreen extends StatefulWidget {
  static const routeName = '/master-data-update';

  @override
  _UpdateMasterDataScreenState createState() => _UpdateMasterDataScreenState();
}

class _UpdateMasterDataScreenState extends State<UpdateMasterDataScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => initData());
  }

  // ====================================  DATA TYPE ============================================
  bool _isSearching = false;
  bool viewcontainer = false;
  bool _isExpanded = true;

  List<GeoUnitMasterBAL>? _linkedMahaanagar;
  List<GeoUnitMasterBAL>? _linkedVibhaag;
  List<GeoUnitMasterBAL>? _linkedBhaag;
  List<GeoUnitMasterBAL>? _linkedShahar;
  List<GeoUnitMasterBAL>? _linkedNagar;
  List<GeoUnitMasterBAL>? _linkedmandal;
  List<GeoUnitMasterBAL>? _linkedgraam;
  List<GeoUnitMasterBAL>? _linkedvasti;
  List<StaticMasterBAL>? _baithakTypes;
  List<GeoUnitMasterBAL>? _linkedupnagar;
  GetgeounitNameModel? getgeounitNameModel;

  String? _linkedMahaanagarValue = '';
  String? _linkedVibhaagValue = '';
  String? _linkedBhaagValue = '';
  String? _linkedNagarValue = '';
  String? _linkedgraamValue = '';
  String? _linkedMandalValue = '';
  String? _linkedvastiValue = '';
  String? mahanagarId = '';
  String? vibhagId = '';
  String? selctedLevel = 'praant';
  String? selctedLevelName = '';
  String? selctedLevelId = '';
  String? selctedLevelNameNew = '';
  String? selctedLevelIdNew = '';

  String? _selctedLevel = 'praant';
  String? _selctedLevelName = '';
  String _selctedLevelNames = '';
  List<String?> _selctedLevelNameList = [];

  String? _selectedGeoUnitId;
  String? _linkedupnagarValue;
  String? _linkedupnagarName = '';
  String? _linkedmandalName = '';
  String? _linkedgraamName = '';

  TextEditingController marathiNameController = TextEditingController();
  TextEditingController hindiNameController = TextEditingController();
  TextEditingController englishNameController = TextEditingController();

  Future<void> initData() async {
    DropDownModel dm = await MyAppGlobals.getLevelLDB();

    setState(() {
      userLevelId = dm.levelID;
      userGeoUnitId = dm.geoUnitID;
      ddm = dm;
    });
    await populateDropdown();
  }

  final GlobalKey<FormState> _formKey = GlobalKey();

// ==================   DROP - DOWNS =================================

  Future<void> populateAllDropdowns(int level, DropDownModel dm) async {
    setState(() {
      _selectedGeoUnitId = _linkedMahaanagarValue = _linkedBhaagValue = _linkedNagarValue = _linkedvastiValue = null;
    });
    final selection = prepareSelection(dm);

    // Step 1: Mahaanagar
    await populatelinkedMahaanagarDropdown();
    _selectedGeoUnitId = _linkedMahaanagarValue = (level == 9 ? (dm.geoUnitID ?? "").toString() : selection.mahaanagar) ?? '';
    _selctedLevel = 'Mahaanagar';

    // Step 2: Vibhaag
    await populatelinkedVibhaagDropdown(_linkedMahaanagarValue!);
    _selectedGeoUnitId = _linkedVibhaagValue = (level == 8 ? (dm.geoUnitID ?? "").toString() : selection.vibhaag) ?? '';
    _selctedLevel = 'Vibhaag';

    // Step 3: Bhaag
    await populatelinkedBhaagDropdown(_linkedVibhaagValue!);
    _selectedGeoUnitId = _linkedBhaagValue = (level == 7 ? (dm.geoUnitID ?? "").toString() : selection.bhaag) ?? '';
    _selctedLevel = 'Bhaag';

    // Step 4: Nagar
    await populatelinkedNagarDropdown(_linkedBhaagValue, null);
    _selectedGeoUnitId = _linkedNagarValue = (level == 6 ? (dm.geoUnitID ?? "").toString() : selection.nagar) ?? '';
    _selctedLevel = 'Nagar';

    // Step 5: Upnagar (conditional)
    if (selection.upnagar != null && selection.upnagar!.isNotEmpty) {
      await populatelinkedUpnagarDropdown(_linkedNagarValue);
      _selectedGeoUnitId = _linkedupnagarValue = (level == 13 ? (dm.geoUnitID ?? "").toString() : selection.upnagar) ?? '';
    }
    if (selection.mandal != null && selection.mandal!.isNotEmpty) {
      await populatelinkedMandalDropdown(selection.upnagar != null, selection.upnagar != null ? _linkedNagarValue! : _linkedupnagarValue!);
      _selectedGeoUnitId = _linkedMandalValue = (level == 4 ? (dm.geoUnitID ?? "").toString() : selection.mandal) ?? '';
    }
    // Step 7: Graam
    await populatelinkedGraamDropdown(_linkedMandalValue!);
    _selectedGeoUnitId = _linkedgraamValue = (level == 3 ? (dm.geoUnitID ?? "").toString() : selection.graam) ?? '';

    // Step 8: Vasti
    await populatelinkedVastiDropdown(_linkedNagarValue!);
    _selectedGeoUnitId = _linkedvastiValue = (level == 2 ? (dm.geoUnitID ?? "").toString() : selection.vasti) ?? '';

    // if (_linkedVibhaag != null && _linkedVibhaag!.isNotEmpty) _linkedVibhaagName = _linkedVibhaag!.firstWhere((bg) => bg.geoUnitID.toString() == _linkedBhaagValue).name;
    // if (_linkedBhaag != null && _linkedBhaag!.isNotEmpty) _linkedbhaagName = _linkedBhaag!.firstWhere((bg) => bg.geoUnitID.toString() == _linkedBhaagValue).name;
    // if (_linkedNagar != null && _linkedNagar!.isNotEmpty) _linkednagarName = _linkedNagar!.firstWhere((bg) => bg.geoUnitID.toString() == _linkedBhaagValue).name;

    setState(() {});
  }

  Future<void> populateDropdown({bool fromClear = false}) async {
    setState(() {
      _linkedMahaanagarValue = _linkedBhaagValue = _linkedNagarValue = _linkedvastiValue = null;
      _linkedMahaanagar = _linkedVibhaag = _linkedBhaag = _linkedNagar = _linkedupnagar = null;
      _selctedLevelName = _selectedGeoUnitId = null;
      _selctedLevel = "praant";
    });
    await populatelinkedMahaanagarDropdown();
    await populatelinkedVibhaagDropdown('');
    if (fromClear || userLevelId == null || ddm == null) {
      print("object is null");
      return;
    }
    print("object is not null >>>>>>>>>>>>>>>>>>>>>>");
    await populateAllDropdowns(userLevelId!, ddm!);
    setState(() => viewcontainer = false);
    var data = await Statics.getStaticLDB('AnnualBaithakType');
    // populatelinkedMahaanagarDropdown();
    // populatelinkedVibhaagDropdown('');
    if (!mounted) return;
    _baithakTypes = data;
    _baithakTypes = _baithakTypes!.where((element) => element.showAnnualBaithakkey!.contains('1')).toList();
    print("_baithakTypes :-- $_baithakTypes");
    setState(() {});
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedMahaanagarDropdown() async {
    setState(() => viewcontainer = false);
    var data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['MahaanagarLevelID'].toString(), '', '', '');
    if (mounted)
      setState(() {
        _linkedMahaanagar = data;
      });
    return data;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedUpnagarDropdown(String? nagarIDStr) async {
    _linkedupnagarValue = _linkedvastiValue = null;
    _linkedupnagarName = _linkedmandalName = _linkedgraamName = null;
    _linkedupnagar = _linkedvasti = null;
    var mnDD;

    mnDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['UpaNagarLevelID'].toString(), nagarIDStr!, 'Nagar', '');

    setState(() {
      _linkedupnagar = (mnDD.length > 0 ? mnDD : null);
      //_linkedupnagarValue = (userparentUpanagarid ?? userGeoUnitId).toString();
    });
    return mnDD;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedBhaagDropdown(String vibhaagIDStr) async {
    setState(() => viewcontainer = false);
    _linkedNagarValue = null;
    var data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['BhaagLevelID'].toString(), vibhaagIDStr, 'Vibhaag', '');
    setState(() {
      _linkedBhaag = data;
    });
    return data;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedVibhaagDropdown(String mahaanagarIDStr) async {
    setState(() => viewcontainer = false);
    _linkedBhaagValue = null;
    var data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['VibhaagLevelID'].toString(), mahaanagarIDStr, (mahaanagarIDStr.isEmpty ? '' : 'Mahaanagar'), '');
    if (mounted)
      setState(() {
        _linkedVibhaag = data;
      });
    return data;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedNagarDropdown(String? bhaagIDStr, String? shaharIDStr) async {
    setState(() => viewcontainer = false);
    _linkedNagarValue = null;
    _linkedNagar = null;
    if (shaharIDStr != null) {
      var ngDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['NagarLevelID'].toString(), shaharIDStr, 'Shahar', '');
      setState(() {
        _linkedNagar = (ngDD.length > 0 ? ngDD : null);
      });
      return ngDD;
    } else {
      var ngDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['NagarLevelID'].toString(), bhaagIDStr!, 'Bhaag', '');
      setState(() {
        _linkedNagar = (ngDD.length > 0 ? ngDD : null);
      });
      return ngDD;
    }
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedMandalDropdown(bool haveParentUp, String nagarIDStr) async {
    setState(() => viewcontainer = false);
    _linkedgraamValue = null;
    _linkedmandal = _linkedgraam = null;
    var mnDD;
    if (haveParentUp) {
      mnDD = await Statics.getGeoUnitsByLevelAndParentForUpnagar(Statics.levels['MandalLevelID'].toString(), nagarIDStr, "Upnagar", '');
    } else {
      mnDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['MandalLevelID'].toString(), nagarIDStr, "Nagar", '');
    }
    //var mnDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['MandalLevelID'].toString(), nagarIDStr, 'Nagar', '');
    setState(() {
      _linkedmandal = (mnDD.length > 0 ? mnDD : null);
    });
    return mnDD;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedGraamDropdown(String mandalIDStr) async {
    setState(() => viewcontainer = false);
    _linkedgraamValue = null;
    print("mandalIDStr mandalIDStr ==> $mandalIDStr");
    var gmDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['GraamLevelID'].toString(), mandalIDStr, 'Mandal', '');
    setState(() {
      _linkedgraam = (gmDD.length > 0 ? gmDD : null);
    });
    return gmDD;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedVastiDropdown(String nagarIDStr) async {
    setState(() => viewcontainer = false);
    _linkedvastiValue = null;
    var vsDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['VastiLevelID'].toString(), nagarIDStr, 'Nagar', '');
    setState(() {
      _linkedvasti = (vsDD.length > 0 ? vsDD : null);
    });
    return vsDD;
  }

  Future<void> getData(context) async {
    print("GeoUnitID  :- $selctedLevelId");
    print("selctedLevel  :- $selctedLevel");
    print("selctedLevelName  :- $selctedLevelName");
    var inputData = json.encode({
      "GeoUnitID": selctedLevelId,
    });
    print("getData" + inputData);
    getgeounitNameModel = await Statics.getlevelUpdatedata(inputData);

    setState(() {
      marathiNameController.text = getgeounitNameModel!.geoUnitNameMarathi!;
      hindiNameController.text = getgeounitNameModel!.geoUnitNameHindi!;
      englishNameController.text = getgeounitNameModel!.geoUnitName!;
      viewcontainer = true;
      _isExpanded = false;
    });
  }

  void _submitForm() {
    print("Form Submitted Successfully");
    print("Form Submitted Successfully $_linkedMahaanagarValue");
    print("Form Submitted Successfully $_linkedVibhaagValue");
    print("Form Submitted Successfully $_linkedBhaagValue");
    print("Form Submitted Successfully $_linkedNagarValue ");
    print("Form Submitted Successfully $_linkedMandalValue");
    print("Form Submitted Successfully $_linkedgraamValue");
    print("Form Submitted Successfully $_linkedvastiValue");

    var inputData = json.encode({
      "GeoUnitID": selctedLevelId,
      "ParentMahaanagarID": _linkedMahaanagarValue == "" || selctedLevelId == _linkedMahaanagarValue ? null : _linkedMahaanagarValue,
      "ParentVibhaagID": _linkedVibhaagValue == "" || selctedLevelId == _linkedVibhaagValue ? null : _linkedVibhaagValue,
      "ParentBhaagID": _linkedBhaagValue == "" || selctedLevelId == _linkedBhaagValue ? null : _linkedBhaagValue,
      "ParentNagarID": _linkedNagarValue == "" || selctedLevelId == _linkedNagarValue ? null : _linkedNagarValue,
      "ParentMandalID": _linkedMandalValue == "" || selctedLevelId == _linkedMandalValue ? null : _linkedMandalValue,
      "ParentGraamID": _linkedgraamValue == "" || selctedLevelId == _linkedgraamValue ? null : _linkedgraamValue,
      "ParentVastiID": _linkedvastiValue == "" || selctedLevelId == _linkedvastiValue ? null : _linkedvastiValue,
      "GeoUnitNameMarathi": marathiNameController.text,
      "GeoUnitNameHindi": hindiNameController.text,
      "GeoUnitName": englishNameController.text,
    });
    print("_submitForm" + inputData);
    // Statics.savelevelUpdatedata(context, inputData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: SingleChildScrollView(
            child: Column(
          children: [
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
                        if (_linkedMahaanagar != null)
                          DropdownButtonFormField(
                            decoration: InputDecoration(labelText: Statics.getLabel('Mahaanagar')),
                            isExpanded: true,
                            value: _linkedMahaanagarValue == "" ? null : _linkedMahaanagarValue,
                            items: _linkedMahaanagar!
                                .map((bg) => DropdownMenuItem(
                                      value: bg.geoUnitID.toString(),
                                      child: Text(bg.name!),
                                    ))
                                .toList(),
                            onChanged: MyAppGlobals.isDropdownDisabled('Mahaanagar')
                                ? null
                                : (value) {
                                    final selectedItem = _linkedMahaanagar!.firstWhere((bg) => bg.geoUnitID.toString() == value);
                                    setState(() {
                                      _linkedMahaanagarValue = value.toString();
                                      _linkedVibhaagValue = null;
                                      _linkedBhaagValue = null;
                                      _linkedNagarValue = null;
                                      populatelinkedVibhaagDropdown(value!.toString());
                                      mahanagarId = value.toString();
                                      selctedLevelId = value.toString();
                                      selctedLevelName = selectedItem.name ?? "";
                                      selctedLevel = 'Mahanagar';
                                    });
                                    print("Selected Id: $value");
                                    print("Selected Level Name: ${selectedItem.name}");
                                  },
                          ),
                        SizedBox(
                          height: 10,
                        ),
                        if (_linkedVibhaag != null)
                          DropdownButtonFormField(
                            decoration: InputDecoration(labelText: Statics.getLabel('Vibhaag')),
                            isExpanded: true,
                            value: _linkedVibhaagValue == "" ? null : _linkedVibhaagValue,
                            items: _linkedVibhaag!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                            onChanged: MyAppGlobals.isDropdownDisabled('Vibhaag')
                                ? null
                                : (value) {
                                    final selectedItem = _linkedVibhaag!.firstWhere((bg) => bg.geoUnitID.toString() == value);
                                    print(value);
                                    setState(() {
                                      _linkedVibhaagValue = value.toString();
                                      populatelinkedBhaagDropdown(value.toString()!);
                                      vibhagId = value.toString();
                                      _linkedBhaagValue = _linkedNagarValue = null;
                                      _linkedBhaag = _linkedNagar = null;
                                      selctedLevelId = value.toString();
                                      selctedLevelName = selectedItem.name ?? "";
                                      selctedLevel = 'Vibhaag';
                                    });
                                    print("Selected Id: $value");
                                    print("Selected Level Name: ${selectedItem.name}");
                                  },
                          ),
                        SizedBox(
                          height: 10,
                        ),
                        if (_linkedBhaag != null)
                          DropdownButtonFormField(
                            decoration: InputDecoration(labelText: Statics.getLabel('Bhaag')),
                            isExpanded: true,
                            value: _linkedBhaagValue == "" ? null : _linkedBhaagValue,
                            items: _linkedBhaag!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                            onChanged: MyAppGlobals.isDropdownDisabled('Bhaag')
                                ? null
                                : (value) {
                                    final selectedItem = _linkedBhaag!.firstWhere((bg) => bg.geoUnitID.toString() == value);
                                    setState(() {
                                      _linkedBhaagValue = value.toString();
                                      populatelinkedNagarDropdown(value.toString(), null);
                                      selctedLevelId = value.toString();
                                      selctedLevelName = selectedItem.name ?? "";
                                      selctedLevel = 'Bhaag';
                                    });
                                    print("Selected Id: $value");
                                    print("Selected Level Name: ${selectedItem.name}");
                                  },
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
                            onChanged: MyAppGlobals.isDropdownDisabled('Nagar')
                                ? null
                                : (value) {
                                    final selectedItem = _linkedNagar!.firstWhere((bg) => bg.geoUnitID.toString() == value);
                                    setState(() {
                                      _linkedNagarValue = value.toString();
                                      populatelinkedVastiDropdown(value!.toString());
                                      populatelinkedMandalDropdown(false, value.toString());
                                      selctedLevelId = value.toString();
                                      selctedLevelName = selectedItem.name ?? "";
                                      selctedLevel = 'Nagar';
                                    });
                                    print("Selected Id: $value");
                                    print("Selected Level Name: ${selectedItem.name}");
                                  },
                          ),
                        if (_linkedNagar != null && _linkedNagar!.length > 0)
                          SizedBox(
                            height: 10,
                          ),
                        if (_linkedupnagar != null && _linkedupnagar!.isNotEmpty)
                          buildDropdownField(
                            isDisabled: MyAppGlobals.isDropdownDisabled('Mandal'),
                            label: Statics.getLabel('upnagarUpkhanda'),
                            value: _linkedupnagarValue,
                            items: _linkedupnagar!
                                .map((bg) => DropdownMenuItem(
                                      value: bg.geoUnitID.toString(),
                                      child: Text(bg.name!),
                                    ))
                                .toList(),
                            onChanged: MyAppGlobals.isDropdownDisabled('upnagarUpkhanda')
                                ? null
                                : (value) {
                                    final selectedItem = _linkedupnagar!.firstWhere((bg) => bg.geoUnitID.toString() == value);
                                    setState(() {
                                      _linkedupnagarValue = value;
                                      _selectedGeoUnitId = value;
                                      _selctedLevel = 'upnagarUpkhanda';
                                      _selctedLevelName = selectedItem.name ?? "";
                                      populatelinkedVastiDropdown(value!);
                                      populatelinkedMandalDropdown(true, value);
                                      // populatelinkedNagarDropdown(null, value);
                                    });
                                  },
                          ),
                        if (_linkedmandal != null && _linkedmandal!.length > 0)
                          DropdownButtonFormField(
                            decoration: InputDecoration(labelText: Statics.getLabel('Mandal')),
                            isExpanded: true,
                            value: _linkedMandalValue == "" ? null : _linkedMandalValue,
                            items: _linkedmandal!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                            onChanged: MyAppGlobals.isDropdownDisabled('Mandal')
                                ? null
                                : (value) {
                                    final selectedItem = _linkedmandal!.firstWhere((bg) => bg.geoUnitID.toString() == value);
                                    setState(() {
                                      _linkedMandalValue = value.toString();
                                      populatelinkedGraamDropdown(value.toString());
                                      selctedLevelId = value.toString();
                                      selctedLevelName = selectedItem.name ?? "";
                                      selctedLevel = 'Mandal';
                                    });
                                    print("Selected Id: $value");
                                    print("Selected Level Name: ${selectedItem.name}");
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
                            items: _linkedgraam!
                                .map((bg) => DropdownMenuItem(
                                      value: bg.geoUnitID.toString(),
                                      child: Text(bg.name!),
                                    ))
                                .toList(),
                            onChanged: MyAppGlobals.isDropdownDisabled('Graam')
                                ? null
                                : (value) {
                                    final selectedItem = _linkedgraam!.firstWhere((bg) => bg.geoUnitID.toString() == value);
                                    setState(() {
                                      _linkedgraamValue = value.toString(); // D2 me bhi same value aayegi
                                      selctedLevelId = value.toString();
                                      selctedLevelName = selectedItem.name ?? "";
                                      selctedLevel = 'Graam';
                                    });
                                    print("D1 Selected Id: $value");
                                    print("D1 Selected Level Name: ${selectedItem.name}");
                                  },
                          ),
                        if (_linkedvasti != null && _linkedvasti!.length > 0)
                          SizedBox(
                            height: 10,
                          ),
                        if (_linkedvasti != null && _linkedvasti!.length > 0)
                          DropdownButtonFormField(
                            decoration: InputDecoration(labelText: Statics.getLabel('Vasti')),
                            isExpanded: true,
                            value: _linkedvastiValue == "" ? null : _linkedvastiValue,
                            items: _linkedvasti!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                            onChanged: MyAppGlobals.isDropdownDisabled('Vasti')
                                ? null
                                : (value) {
                                    final selectedItem = _linkedvasti!.firstWhere((bg) => bg.geoUnitID.toString() == value);
                                    setState(() {
                                      _linkedvastiValue = value.toString();
                                      selctedLevelId = value.toString();
                                      selctedLevelName = selectedItem.name ?? "";
                                      selctedLevel = 'Vasti';
                                    });
                                    print("Selected Id: $value");
                                    print("Selected Level Name: ${selectedItem.name}");
                                  },
                          ),
                        if (_linkedgraam != null && _linkedgraam!.length > 0)
                          SizedBox(
                            height: 10,
                          ),
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
                        onPressed: () {
                          getData(context);
                        },
                        child: Text(
                          Statics.getLabel('ViewMenu'),
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      MaterialButton(
                          onPressed: () {
                            setState(() {
                              _linkedMahaanagarValue = _linkedVibhaagValue = _linkedBhaagValue = _linkedNagarValue = _linkedvastiValue = _linkedMandalValue = null;
                              _linkedMahaanagar = _linkedVibhaag = _linkedBhaag = _linkedNagar = _linkedvasti = null;
                              _isSearching = false;
                              marathiNameController.clear();
                              hindiNameController.clear();
                              englishNameController.clear();
                              viewcontainer = false;
                            });
                            populatelinkedMahaanagarDropdown();
                            populatelinkedVibhaagDropdown('');
                          },
                          child: Text(Statics.getLabel('clear'))),
                    ],
                  ),
                ],
              ),
            ),
//======================================================   EDIT VIEW ===============================================================
            if (viewcontainer == true)
              Container(
                width: double.infinity,
                decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.all(Radius.circular(15))),
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    if (_linkedMahaanagar != null)
                      if (selctedLevel == 'Vibhaag' || selctedLevel == 'Bhaag')
                        DropdownButtonFormField(
                          decoration: InputDecoration(labelText: Statics.getLabel('Mahaanagar')),
                          isExpanded: true,
                          value: _linkedMahaanagarValue == "" ? null : _linkedMahaanagarValue,
                          items: _linkedMahaanagar!
                              .map((bg) => DropdownMenuItem(
                                    value: bg.geoUnitID.toString(),
                                    child: Text(bg.name!),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            final selectedItem = _linkedMahaanagar!.firstWhere((bg) => bg.geoUnitID.toString() == value);
                            setState(() {
                              selctedLevelIdNew = value;
                              selctedLevelNameNew = selectedItem.name ?? "";
                            });
                            print("Selected Id: $value");
                            print("Selected Level Name: ${selectedItem.name}");
                          },
                        ),
                    SizedBox(
                      height: 10,
                    ),
                    if (_linkedVibhaag != null)
                      if (selctedLevel == 'Vibhaag' || selctedLevel == 'Mahanagar')
                        DropdownButtonFormField(
                          decoration: InputDecoration(labelText: Statics.getLabel('Vibhaag')),
                          isExpanded: true,
                          value: _linkedVibhaagValue == "" ? null : _linkedVibhaagValue,
                          items: _linkedVibhaag!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                          onChanged: (value) {
                            final selectedItem = _linkedVibhaag!.firstWhere((bg) => bg.geoUnitID.toString() == value);
                            print(value);
                            setState(() {
                              _linkedVibhaagValue = value;
                              selctedLevelIdNew = value;
                              selctedLevelNameNew = selectedItem.name ?? "";
                            });
                            print("Selected Id: $value");
                            print("Selected Level Name: ${selectedItem.name}");
                          },
                        ),
                    SizedBox(
                      height: 10,
                    ),
                    if (_linkedBhaag != null)
                      if (selctedLevel == 'Bhaag' || selctedLevel == 'Nagar')
                        DropdownButtonFormField(
                          decoration: InputDecoration(labelText: Statics.getLabel('Bhaag')),
                          isExpanded: true,
                          value: _linkedBhaagValue == "" ? null : _linkedBhaagValue,
                          items: _linkedBhaag!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                          onChanged: (value) {
                            final selectedItem = _linkedBhaag!.firstWhere((bg) => bg.geoUnitID.toString() == value);
                            setState(() {
                              _linkedBhaagValue = value;
                              selctedLevelIdNew = value;
                              selctedLevelNameNew = selectedItem.name ?? "";
                            });
                            print("Selected Id: $value");
                            print("Selected Level Name: ${selectedItem.name}");
                          },
                        ),
                    SizedBox(
                      height: 10,
                    ),
                    if (_linkedNagar != null && _linkedNagar!.length > 0)
                      if (selctedLevel == 'Nagar' || selctedLevel == 'Vasti' || selctedLevel == 'Mandal')
                        DropdownButtonFormField(
                          decoration: InputDecoration(labelText: Statics.getLabel('Nagar')),
                          isExpanded: true,
                          value: _linkedNagarValue == "" ? null : _linkedNagarValue,
                          items: _linkedNagar!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                          onChanged: (value) {
                            final selectedItem = _linkedNagar!.firstWhere((bg) => bg.geoUnitID.toString() == value);
                            setState(() {
                              _linkedNagarValue = value;
                              selctedLevelIdNew = value;
                              selctedLevelNameNew = selectedItem.name ?? "";
                            });
                            print("Selected Id: $value");
                            print("Selected Level Name: ${selectedItem.name}");
                          },
                        ),
                    SizedBox(
                      height: 10,
                    ),
                    if (_linkedvasti != null && _linkedvasti!.length > 0)
                      if (selctedLevel == 'Vasti')
                        DropdownButtonFormField(
                          decoration: InputDecoration(labelText: Statics.getLabel('Vasti')),
                          isExpanded: true,
                          value: _linkedvastiValue == "" ? null : _linkedvastiValue,
                          items: _linkedvasti!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                          onChanged: (value) {
                            final selectedItem = _linkedvasti!.firstWhere((bg) => bg.geoUnitID.toString() == value);
                            setState(() {
                              _linkedvastiValue = value;
                              selctedLevelIdNew = value;
                              selctedLevelNameNew = selectedItem.name ?? "";
                            });
                            print("Selected Id: $value");
                            print("Selected Level Name: ${selectedItem.name}");
                          },
                        ),
                    SizedBox(
                      height: 10,
                    ),
                    if (_linkedmandal != null && _linkedmandal!.length > 0)
                      if (selctedLevel == 'Mandal' || selctedLevel == 'Graam')
                        DropdownButtonFormField(
                          decoration: InputDecoration(labelText: Statics.getLabel('Mandal')),
                          isExpanded: true,
                          value: _linkedMandalValue == "" ? null : _linkedMandalValue,
                          items: _linkedmandal!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                          onChanged: (value) {
                            final selectedItem = _linkedmandal!.firstWhere((bg) => bg.geoUnitID.toString() == value);
                            setState(() {
                              _linkedMandalValue = value;
                              selctedLevelIdNew = value;
                              selctedLevelNameNew = selectedItem.name ?? "";
                            });
                            print("Selected Id: $value");
                            print("Selected Level Name: ${selectedItem.name}");
                          },
                        ),
                    SizedBox(
                      height: 10,
                    ),
                    if (_linkedgraam != null && _linkedgraam!.length > 0)
                      if (selctedLevel == 'Graam')
                        DropdownButtonFormField(
                          decoration: InputDecoration(labelText: Statics.getLabel('Graam')),
                          isExpanded: true,
                          value: _linkedgraamValue == "" ? null : _linkedgraamValue,
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
                              selctedLevelIdNew = value;
                              selctedLevelNameNew = selectedItem.name ?? "";
                            });
                            print("D2 Selected Id: $value");
                            print("D2 Selected Level Name: ${selectedItem.name}");
                          },
                        ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: marathiNameController,
                              keyboardType: TextInputType.text,
                              textDirection: TextDirection.ltr,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: "मराठीत नाव",
                                labelText: "मराठीत नाव",
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "कृपया मराठी नाव प्रविष्ट करा";
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 20),
                            TextFormField(
                              controller: hindiNameController,
                              keyboardType: TextInputType.text,
                              textDirection: TextDirection.ltr,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: "हिंदी में नाम",
                                labelText: "हिंदी में नाम",
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "कृपया हिंदी नाम दर्ज करें";
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 20),
                            TextFormField(
                              controller: englishNameController,
                              keyboardType: TextInputType.text,
                              textDirection: TextDirection.ltr,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: "Name in English",
                                labelText: "Name in English",
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter the name in English";
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  _submitForm();
                                }
                              },
                              child: Text(Statics.getLabel('Submit'), style: TextStyle(fontSize: 18)),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              )
          ],
        )),
      ),
    );
  }
}
