import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:niyojak_prod/utils/globals.dart';

import '../../../helpers/static_data.dart' as Statics;
import '../../../models/response_model/dropdown_level_responsemodel.dart';
import '../../../models/response_model/sadbhav_baithak_resp_model.dart';
import '../../../models/response_model/yuva_sangam_report_model.dart';
import '../../../providers/bals.dart';

class YuvaSangamReportTab extends StatefulWidget {
  const YuvaSangamReportTab({super.key});

  @override
  State<YuvaSangamReportTab> createState() => _YuvaSangamReportTabState();
}

class _YuvaSangamReportTabState extends State<YuvaSangamReportTab> with AutomaticKeepAliveClientMixin {
// This override is what tells Flutter to keep the state alive.
  @override
  bool get wantKeepAlive => true;

  late ScrollController _scrollController;
  bool _searched = false;
  bool _isExpanded = true;

  List<Nagardata> nagarList = [];
  List<GeoUnitMasterBAL>? _linkedMahaanagar;
  List<GeoUnitMasterBAL>? _linkedVibhaag;
  List<GeoUnitMasterBAL>? _linkedbhaag;
  List<GeoUnitMasterBAL>? _linkedshahar;
  List<GeoUnitMasterBAL>? _linkednagar;
  List<GeoUnitMasterBAL>? _linkedmandal;
  List<GeoUnitMasterBAL>? _linkedgraam;
  List<GeoUnitMasterBAL>? _linkedvasti;
  List<GeoUnitMasterBAL>? _linkedupnagar;

  String? _linkedupnagarName = "";
  String? _linkedupnagarValue = "";
  String? _linkedMahaanagarValue = '';
  String? _linkedVibhaagValue = '';
  String? _linkedbhaagValue = "";
  String? _linkedshaharValue = "";
  String? _linkednagarValue = "";
  String? _linkedNagarValuePopup = '';
  String? _linkedmandalValue = "";
  String? _linkedgraamValue = "";
  String? _linkedvastiValue = "";

  // String? _linkedMahaanagarName = '';
  // String? _linkedVibhaagName = '';
  String? _linkedbhaagName = "";
  String? _linkedshaharName = "";
  String? _linkednagarName = "";
  String? _linkedmandalName = "";
  String? _linkedgraamName = "";
  String? _linkedvastiName = "";

  String? _selctedLevel = 'praant';
  String? _selctedLevelName = '';
  String _selctedLevelNames = '';
  List<String?> _selctedLevelNameList = [];
  String? _selectedGeoUnitId;

  List<Yuvrpt> report = [];

  final List<bool> _expanded = List.generate(3, (_) => true);

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    initData();
  }

  Future<void> initData() async {
    DropDownModel dm = await MyAppGlobals.getLevelLDB();

    setState(() {
      userLevelId = dm.levelID;
      userGeoUnitId = dm.geoUnitID;
      ddm = dm;
    });
    await populateDropdown(userLevelId!, dm);
    //await populateAllDropdowns(userLevelId!, dm);
  }

  // Future<void> _initData() async {
  //   await _fetchdataFromDaitwaMaster();
  //   await populateDropdown();
  // }

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
      _linkedMahaanagarValue = _linkedbhaagValue = _linkedshaharValue = _linkednagarValue = _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = null;
    });
    final selection = prepareSelection(dm);

    // Step 1: Mahaanagar
    await populatelinkedMahaanagarDropdown();
    _linkedMahaanagarValue = (level == 9 ? dm.geoUnitID.toString() : selection.mahaanagar) ?? '';

    // Step 2: Vibhaag
    await populatelinkedVibhaagDropdown(_linkedMahaanagarValue!);
    _linkedVibhaagValue = (level == 8 ? dm.geoUnitID.toString() : selection.vibhaag) ?? '';

    // Step 3: Bhaag
    await populatelinkedBhaagDropdown(_linkedVibhaagValue!);
    _linkedbhaagValue = (level == 7 ? dm.geoUnitID.toString() : selection.bhaag) ?? '';

    // Step 4: Nagar
    await populatelinkedNagarDropdown(_linkedbhaagValue, null);
    _linkednagarValue = (level == 6 ? dm.geoUnitID.toString() : selection.nagar) ?? '';

    // Step 5: Upnagar (conditional)
    if (selection.upnagar != null && selection.upnagar!.isNotEmpty) {
      await populatelinkedUpnagarDropdown(_linkednagarValue);
      _linkedupnagarValue = (level == 13 ? dm.geoUnitID.toString() : selection.upnagar) ?? '';
    }

    // Step 6: Mandal
    await populatelinkedMandalDropdown(
      selection.upnagar != null,
      selection.upnagar != null ? _linkednagarValue : _linkedupnagarValue,
    );
    _linkedmandalValue = (level == 4 ? dm.geoUnitID.toString() : selection.mandal) ?? '';

    // Step 7: Graam
    await populatelinkedGraamDropdown(_linkedmandalValue);
    _linkedgraamValue = (level == 3 ? dm.geoUnitID.toString() : selection.graam) ?? '';

    // Step 8: Vasti
    await populatelinkedVastiDropdown(_linkednagarValue);
    _linkedvastiValue = (level == 2 ? dm.geoUnitID.toString() : selection.vasti) ?? '';

    setState(() {});
  }

  //////////////////////////////////////////////////////////////////////////////////////
  //-----getting levelid and geounit from db-----------------//
  // Future<void> _fetchdataFromDaitwaMaster() async {
  //   DropDownModel dm = await MyAppGlobals.getLevelLDB();
  //   userLevelId = dm.levelID;
  //   print("daitwamaster level id:${dm.levelID}");
  //   userGeoUnitId = dm.geoUnitID;
  //   print("daitwamaster GeoUnitId id:${dm.geoUnitID}");
  //   userparentMahanagar = dm.parentMahaanagarID;
  //   userparentVibhag = dm.parentVibhaagID;
  //   userparentBhaag = dm.parentBhaagID;
  //   userparentNagarid = dm.parentNagarID;
  //   userparentUpanagarid = dm.parentUpaNagarID;
  //   userparentMandalid = dm.parentMandalID;
  //   userParentGramid = dm.parentGraamID;
  //   userParentVastiid = dm.parentVastiID;
  // }

  // Future<void> mainPopulateDropdown() async {
  //   print("i am in switchcase $userLevelId");
  //   switch (userLevelId) {
  //     case 10:
  //     case 9:
  //       print("i am in switchcase 9");
  //       setState(() {
  //         _linkedMahaanagarValue = userGeoUnitId.toString();
  //         print("geounitid:$_linkedMahaanagarValue");
  //       });
  //
  //       await populatelinkedMahaanagarDropdown();
  //       await populatelinkedVibhaagDropdown('');
  //       break;
  //
  //     case 8:
  //       print("i am in switchcase 8");
  //       await populatelinkedMahaanagarDropdown();
  //       setState(() {
  //         _linkedMahaanagarValue = (userparentMahanagar ?? '').toString();
  //       });
  //       await populatelinkedVibhaagDropdown(_linkedMahaanagarValue!);
  //       setState(() {
  //         _linkedVibhaagValue = userGeoUnitId.toString();
  //       });
  //
  //       await populatelinkedBhaagDropdown(userGeoUnitId.toString());
  //       break;
  //     case 7:
  //       print("i am in switchcase 7");
  //       await populatelinkedMahaanagarDropdown();
  //       setState(() {
  //         _linkedMahaanagarValue = (userparentMahanagar ?? '').toString();
  //       });
  //       await populatelinkedVibhaagDropdown(_linkedMahaanagarValue!);
  //       setState(() {
  //         _linkedVibhaagValue = userparentVibhag.toString();
  //       });
  //       await populatelinkedBhaagDropdown(_linkedVibhaagValue!);
  //       setState(() {
  //         _linkedbhaagValue = userGeoUnitId.toString();
  //       });
  //       await populatelinkedNagarDropdown(userGeoUnitId.toString(), null);
  //       break;
  //     case 6:
  //       print("i am in switchcase 6");
  //       await populatelinkedMahaanagarDropdown();
  //       setState(() {
  //         _linkedMahaanagarValue = (userparentMahanagar ?? '').toString();
  //       });
  //       await populatelinkedVibhaagDropdown(_linkedMahaanagarValue!);
  //       setState(() {
  //         _linkedVibhaagValue = userparentVibhag.toString();
  //       });
  //       await populatelinkedBhaagDropdown(_linkedVibhaagValue!);
  //       setState(() {
  //         _linkedbhaagValue = userparentBhaag.toString();
  //       });
  //       await populatelinkedNagarDropdown(_linkedbhaagValue, null);
  //       setState(() {
  //         _linkednagarValue = userGeoUnitId.toString();
  //       });
  //       await populatelinkedUpnagarDropdown(userGeoUnitId.toString());
  //       await populatelinkedMandalDropdown(false, userGeoUnitId.toString());
  //       await populatelinkedVastiDropdown(userGeoUnitId.toString());
  //       break;
  //     case 13:
  //       print("i am in switchcase 13");
  //       await populatelinkedMahaanagarDropdown();
  //       setState(() {
  //         _linkedMahaanagarValue = (userparentMahanagar ?? '').toString();
  //       });
  //       await populatelinkedVibhaagDropdown(_linkedMahaanagarValue!);
  //       setState(() {
  //         _linkedVibhaagValue = userparentVibhag.toString();
  //       });
  //       await populatelinkedBhaagDropdown(_linkedVibhaagValue!);
  //       setState(() {
  //         _linkedbhaagValue = userparentBhaag.toString();
  //       });
  //       await populatelinkedNagarDropdown(_linkedbhaagValue!, null);
  //       setState(() {
  //         _linkednagarValue = userparentNagarid.toString();
  //       });
  //       await populatelinkedUpnagarDropdown(_linkednagarValue!);
  //       setState(() {
  //         _linkedupnagarValue = userGeoUnitId.toString();
  //       });
  //       await populatelinkedMandalDropdown(true, _linkedupnagarValue);
  //       await populatelinkedVastiDropdown(_linkedupnagarValue);
  //
  //       break;
  //     case 4:
  //       print("i am in switchcase 4");
  //       await populatelinkedMahaanagarDropdown();
  //       setState(() {
  //         _linkedMahaanagarValue = (userparentMahanagar ?? '').toString();
  //       });
  //       print("vibhag dropdown:$userparentVibhag");
  //       await populatelinkedVibhaagDropdown(_linkedMahaanagarValue!);
  //       setState(() {
  //         _linkedVibhaagValue = userparentVibhag.toString();
  //         print("vibhag dropdown:$_linkedVibhaagValue");
  //       });
  //       await populatelinkedBhaagDropdown(_linkedVibhaagValue!);
  //       setState(() {
  //         _linkedbhaagValue = userparentBhaag.toString();
  //       });
  //       await populatelinkedNagarDropdown(_linkedbhaagValue, null);
  //       setState(() {
  //         _linkednagarValue = userparentNagarid.toString();
  //       });
  //       await populatelinkedUpnagarDropdown(_linkednagarValue);
  //       setState(() {
  //         _linkedupnagarValue = userparentUpanagarid.toString();
  //       });
  //       await populatelinkedMandalDropdown(userparentUpanagarid != null, userparentUpanagarid != null ? _linkedupnagarValue : _linkednagarValue);
  //       setState(() {
  //         _linkedmandalValue = userGeoUnitId.toString();
  //       });
  //       await populatelinkedGraamDropdown(userGeoUnitId.toString());
  //       break;
  //     case 3:
  //       print("i am in switchcase 3");
  //       await populatelinkedMahaanagarDropdown();
  //       setState(() {
  //         _linkedMahaanagarValue = (userparentMahanagar ?? '').toString();
  //       });
  //       await populatelinkedVibhaagDropdown(_linkedMahaanagarValue!);
  //       setState(() {
  //         _linkedVibhaagValue = userparentVibhag.toString();
  //       });
  //       await populatelinkedBhaagDropdown(_linkedVibhaagValue!);
  //       setState(() {
  //         _linkedbhaagValue = userparentBhaag.toString();
  //       });
  //       await populatelinkedNagarDropdown(_linkedbhaagValue, null);
  //       setState(() {
  //         _linkednagarValue = userparentNagarid.toString();
  //       });
  //       if (userparentUpanagarid != null) {
  //         await populatelinkedUpnagarDropdown(_linkednagarValue);
  //         setState(() {
  //           _linkedupnagarValue = userparentUpanagarid.toString();
  //         });
  //       }
  //       await populatelinkedMandalDropdown(userparentUpanagarid != null, userparentUpanagarid != null ? _linkedupnagarValue : _linkednagarValue);
  //       setState(() {
  //         _linkedmandalValue = userparentMandalid.toString();
  //       });
  //       await populatelinkedGraamDropdown(userparentMandalid.toString());
  //       setState(() {
  //         _linkedgraamValue = userGeoUnitId.toString();
  //       });
  //       break;
  //     case 2:
  //       print("i am in switchcase 2");
  //       await populatelinkedMahaanagarDropdown();
  //       setState(() {
  //         _linkedMahaanagarValue = (userparentMahanagar ?? '').toString();
  //       });
  //       await populatelinkedVibhaagDropdown(_linkedMahaanagarValue!);
  //       setState(() {
  //         _linkedVibhaagValue = userparentVibhag.toString();
  //       });
  //       await populatelinkedBhaagDropdown(_linkedVibhaagValue!);
  //       setState(() {
  //         _linkedbhaagValue = userparentBhaag.toString();
  //       });
  //       await populatelinkedNagarDropdown(_linkedbhaagValue, null);
  //       setState(() {
  //         _linkednagarValue = userparentNagarid.toString();
  //       });
  //       await populatelinkedUpnagarDropdown(_linkednagarValue);
  //       setState(() {
  //         _linkedupnagarValue = userparentUpanagarid.toString();
  //       });
  //       await populatelinkedVastiDropdown(_linkednagarValue);
  //       setState(() {
  //         _linkedvastiValue = userGeoUnitId.toString();
  //       });
  //       break;
  //     default:
  //       print("why i am in switchcase 1");
  //       await populatelinkedMahaanagarDropdown();
  //       setState(() {
  //         _linkedMahaanagarValue = (userparentMahanagar ?? '').toString();
  //       });
  //       await populatelinkedVibhaagDropdown(_linkedMahaanagarValue!);
  //       setState(() {
  //         _linkedVibhaagValue = userparentVibhag.toString();
  //       });
  //       await populatelinkedBhaagDropdown(_linkedVibhaagValue!);
  //       setState(() {
  //         _linkedbhaagValue = userparentBhaag.toString();
  //       });
  //       await populatelinkedNagarDropdown(_linkedbhaagValue, null);
  //       setState(() {
  //         _linkednagarValue = userparentNagarid.toString();
  //       });
  //       await populatelinkedUpnagarDropdown(_linkednagarValue);
  //       setState(() {
  //         _linkedupnagarValue = userparentUpanagarid.toString();
  //       });
  //       await populatelinkedMandalDropdown(userparentUpanagarid != null, userparentUpanagarid != null ? _linkedupnagarValue : _linkednagarValue);
  //       setState(() {
  //         _linkedmandalValue = userparentMandalid.toString();
  //       });
  //       await populatelinkedVastiDropdown(_linkednagarValue);
  //       setState(() {
  //         _linkedvastiValue = userParentVastiid.toString();
  //       });
  //       await populatelinkedGraamDropdown(_linkedmandalValue);
  //       setState(() {
  //         _linkedgraamValue = userParentGramid.toString();
  //       });
  //       break;
  //   }
  // }

  Future<void> populateDropdown(int level, DropDownModel? dm, {bool fromClear = false}) async {
    if (fromClear) {
      setState(() {
        _linkedMahaanagarValue = _linkedbhaagValue = _linkedshaharValue = _linkednagarValue = _linkedupnagarValue = _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = null;
        _linkedMahaanagar = _linkedVibhaag = _linkedbhaag = _linkednagar = _linkedupnagar = _linkedmandal = null;
        _selctedLevelName = _selectedGeoUnitId = null;
        nagarList = [];
        _selctedLevel = "praant";
      });
      await populatelinkedMahaanagarDropdown();
      await populatelinkedVibhaagDropdown('');
      return;
    }
    setState(() {
      _linkedMahaanagarValue = _linkedbhaagValue = _linkedshaharValue = _linkednagarValue = _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = null;
    });
    await populateAllDropdowns(level, dm!);
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedMahaanagarDropdown() async {
    print("i am in mahanagrdropdown");
    _linkedVibhaagValue = _linkedbhaagValue = _linkednagarValue = _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = null;
    List<GeoUnitMasterBAL> data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['MahaanagarLevelID'].toString(), '', '', '', isAbhiyaan: false);
    setState(() {
      _linkedMahaanagar = data;
      print("mahanagar selected string:$_linkedMahaanagarValue");
    });
    return data;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedVibhaagDropdown(String mahaanagarIDStr) async {
    if (mahaanagarIDStr.isEmpty) {
      mahaanagarIDStr = '';
    }
    print("i am in linkedvibhag dropdown");
    _linkedbhaagValue = _linkednagarValue = _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = null;
    _linkedbhaagName = _linkednagarName = _linkedmandalName = _linkedgraamName = _linkedvastiName = null;
    print("populatelinkedVibhaagDropdown $mahaanagarIDStr");
    var data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['VibhaagLevelID'].toString(), mahaanagarIDStr, (mahaanagarIDStr.isEmpty ? '' : 'Mahaanagar'), '', isAbhiyaan: false);
    setState(() {
      _linkedVibhaag = data;
      print("vibhag selected string:$_linkedVibhaagValue");
      //_linkedVibhaagValue = (userparentVibhag ?? userGeoUnitId).toString();
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
        //_linkednagarValue = (userparentNagarid ?? userGeoUnitId).toString();
      });
      return ngDD;
    }
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
      // _linkedgraamValue = (userParentGramid ?? userGeoUnitId).toString();
    });
    return gmDD;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedVastiDropdown(String? nagarIDStr) async {
    //_linkedvastiValue = null;
    _linkedvastiName = null;

    var vsDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['VastiLevelID'].toString(), nagarIDStr!, 'Nagar', '', isAbhiyaan: false);
    setState(() {
      _linkedvasti = (vsDD.length > 0 ? vsDD : null);
      //_linkedvastiValue = (userParentVastiid ?? userGeoUnitId).toString();
    });
    return vsDD;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedUpnagarDropdown(String? nagarIDStr) async {
    _linkedupnagarValue = _linkedmandalValue = _linkedgraamValue = null;
    _linkedupnagarName = _linkedmandalName = _linkedgraamName = null;
    _linkedupnagar = _linkedmandal = _linkedgraam = null;
    nagarList = [];
    var mnDD;

    mnDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['UpaNagarLevelID'].toString(), nagarIDStr!, 'Nagar', '');

    setState(() {
      _linkedupnagar = (mnDD.length > 0 ? mnDD : null);
      //_linkedupnagarValue = (userparentUpanagarid ?? userGeoUnitId).toString();
    });
    return mnDD;
  }

  //////////////////////////////////////////////////////////////////////////////////////

  getReportDataFun() async {
    setState(() {
      report = [];
      // _isLoading = true;
    });
    Map<String, dynamic> formData = {
      "geounitid": int.tryParse(_selectedGeoUnitId.toString()) ?? 0,
      "appuserid": int.tryParse(Statics.userDetails['userID']) ?? null,
    };

    // String formattedJson = const JsonEncoder.withIndent('  ').convert(formData);
    // log("Form Data (JSON):\n$formattedJson");
    report = await Statics.YuvaSangamReportData(context, formData) ?? [];
    // log("vijayadashamiReport >>>>>>>>>>>>>>>>> ${jsonDecode(jsonEncode(vijayadashamiReport))}");
    setState(() {
      report;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(
      //     Statics.getLabel('hinduSammelanReport'),
      //     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      //   ),
      //   // actions: [IconButton(onPressed: getExcelReportDataFun, icon: Icon(Icons.download))],
      // ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          children: [
            SizedBox(height: 10),
            _buildExpansionPanel(),
            SizedBox(height: 20),
            if (_searched) ...[
              Container(
                  height: 40,
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
                  )),
              SizedBox(height: 10),
              Divider(color: Colors.black),
              SizedBox(height: 10),
              if (report.isNotEmpty) buildMarathiDataTable(report),
              SizedBox(height: 18),
            ]
          ],
        ),
      ),
    );
  }

  Widget buildMarathiDataTable(List<Yuvrpt> data) {
    final List<String> headers = [
      Statics.getLabel('yuvaReportTable1'),
      Statics.getLabel('yuvaReportTable2'),
      Statics.getLabel('yuvaReportTable3'),
      Statics.getLabel('yuvaReportTable4'),
      Statics.getLabel('yuvaReportTable15'),
      Statics.getLabel('yuvaReportTable5'),
      Statics.getLabel('yuvaReportTable16'),
      Statics.getLabel('yuvaReportTable6'),
      Statics.getLabel('yuvaReportTable17'),
      Statics.getLabel('yuvaReportTable7'),
      Statics.getLabel('yuvaReportTable18'),
      Statics.getLabel('yuvaReportTable8'),
      Statics.getLabel('yuvaReportTable19'),
      Statics.getLabel('yuvaReportTable9'),
      Statics.getLabel('yuvaReportTable20'),
      Statics.getLabel('yuvaReportTable10'),
      Statics.getLabel('yuvaReportTable21'),
      Statics.getLabel('yuvaReportTable11'),
      Statics.getLabel('yuvaReportTable22'),
      Statics.getLabel('yuvaReportTable12'),
      Statics.getLabel('yuvaReportTable23'),
      Statics.getLabel('yuvaReportTable13'),
      Statics.getLabel('yuvaReportTable24'),
      Statics.getLabel('yuvaReportTable14'),
      Statics.getLabel('yuvaReportTable25'),
      Statics.getLabel('yuvaReportTable26'),
      Statics.getLabel('yuvaReportTable27'),
      Statics.getLabel('yuvaReportTable28'),
      Statics.getLabel('yuvaReportTable29'),
      Statics.getLabel('yuvaReportTable30'),
      Statics.getLabel('yuvaReportTable31'),
    ];

    return Row(
      children: [
        DataTable(
          headingRowColor: MaterialStateColor.resolveWith((_) => Colors.purple.shade100),
          columnSpacing: 0,
          horizontalMargin: 16,
          // dataRowMinHeight: 70,
          // dataRowMaxHeight: 75,

          border: TableBorder.all(color: Colors.black26),
          columns: [
            DataColumn(
              label: Container(
                alignment: Alignment.center,
                // constraints: BoxConstraints(minWidth: 40, maxWidth: 90),
                child: Text(
                  Statics.getLabel("SelectLevel"),
                  softWrap: true,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
          rows: data.map((level) {
                return DataRow(cells: [
                  DataCell(Container(
                      constraints: BoxConstraints(minWidth: 40, maxWidth: 115),
                      child: Text(
                        level.levelname == "रेल्वे स्थानक / शहर / अन्य" ? "अन्य" : level.levelname.toString(),
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ))),
                ]);
              }).toList() +
              [
                DataRow(color: MaterialStatePropertyAll(Colors.yellow.shade100), cells: [
                  DataCell(Container(
                    constraints: BoxConstraints(minWidth: 40, maxWidth: 120),
                    child: Text(
                      Statics.getLabel("Total"),
                      style: TextStyle(fontWeight: FontWeight.w800),
                    ),
                  )),
                ])
              ],
        ),
        Expanded(
          child: Scrollbar(
            controller: _scrollController,
            thumbVisibility: true,
            interactive: true,
            thickness: 5,
            radius: Radius.circular(10),
            child: SingleChildScrollView(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columnSpacing: 0,
                horizontalMargin: 12,
                // dataRowMaxHeight: 75,
                headingRowColor: MaterialStateColor.resolveWith((_) => Colors.purple.shade100),
                border: TableBorder(verticalInside: BorderSide(width: 0.7, color: Colors.grey.shade200)),
                columns: headers
                    .map((header) => DataColumn(
                          label: Container(
                            margin: EdgeInsets.symmetric(horizontal: 14),
                            constraints: BoxConstraints(minWidth: 40, maxWidth: 250),
                            // constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width * 0.2),
                            child: Text(header, softWrap: true, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ))
                    .toList(),
                rows: data.map((level) {
                      return DataRow(cells: [
                        DataCell(Center(
                            child: Row(
                          mainAxisAlignment: (level.ekunyuva != 0 && level.ekunyuvaname != null && level.ekunyuvaname!.isNotEmpty) ? MainAxisAlignment.spaceBetween : MainAxisAlignment.center,
                          children: [
                            if (level.ekunyuva != 0 && level.ekunyuvaname != null && level.ekunyuvaname!.isNotEmpty) SizedBox(width: 1),
                            Container(
                                margin: EdgeInsets.only(right: (level.ekunyuva != 0 && level.ekunyuvaname != null && level.ekunyuvaname!.isNotEmpty) ? 0 : 10), child: Text(level.ekunyuva.toString())),
                            if (level.ekunyuva != 0 && level.ekunyuvaname != null && level.ekunyuvaname!.isNotEmpty)
                              InkWell(
                                borderRadius: BorderRadius.circular(50),
                                onTap: () {
                                  showInfoDialogBox(names: level.ekunyuvaname ?? "", title: Statics.getLabel("yuvaReportTable1"));
                                },
                                child: Icon(Icons.info_rounded, color: CupertinoColors.activeBlue, size: 16),
                              ),
                          ],
                        ))),
                        DataCell(Center(
                            child: Row(
                          mainAxisAlignment:
                              (level.completeyuva != 0 && level.completeyuvaname != null && level.completeyuvaname!.isNotEmpty) ? MainAxisAlignment.spaceBetween : MainAxisAlignment.center,
                          children: [
                            if (level.completeyuva != 0 && level.completeyuvaname != null && level.completeyuvaname!.isNotEmpty) SizedBox(width: 1),
                            Container(
                                margin: EdgeInsets.only(right: (level.completeyuva != 0 && level.completeyuvaname != null && level.completeyuvaname!.isNotEmpty) ? 0 : 10),
                                child: Text(level.completeyuva.toString())),
                            if (level.completeyuva != 0 && level.completeyuvaname != null && level.completeyuvaname!.isNotEmpty)
                              InkWell(
                                borderRadius: BorderRadius.circular(50),
                                onTap: () {
                                  showInfoDialogBox(names: level.completeyuvaname ?? "", title: Statics.getLabel("yuvaReportTable3"));
                                },
                                child: Icon(Icons.info_rounded, color: CupertinoColors.activeBlue, size: 16),
                              ),
                          ],
                        ))),
                        DataCell(Center(
                            child: Row(
                          mainAxisAlignment: (level.pendingyuva != 0 && level.pendingyuvaname != null && level.pendingyuvaname!.isNotEmpty) ? MainAxisAlignment.spaceBetween : MainAxisAlignment.center,
                          children: [
                            if (level.pendingyuva != 0 && level.pendingyuvaname != null && level.pendingyuvaname!.isNotEmpty) SizedBox(width: 1),
                            Container(
                                margin: EdgeInsets.only(right: (level.pendingyuva != 0 && level.pendingyuvaname != null && level.pendingyuvaname!.isNotEmpty) ? 0 : 10),
                                child: Text(level.pendingyuva.toString())),
                            if (level.pendingyuva != 0 && level.pendingyuvaname != null && level.pendingyuvaname!.isNotEmpty)
                              InkWell(
                                borderRadius: BorderRadius.circular(50),
                                onTap: () {
                                  showInfoDialogBox(names: level.pendingyuvaname ?? "", title: Statics.getLabel("yuvaReportTable2"));
                                },
                                child: Icon(Icons.info_rounded, color: CupertinoColors.activeBlue, size: 16),
                              ),
                          ],
                        ))),
                        DataCell(Center(child: Text(level.yuvaexpectmaha.toString()))),
                        DataCell(Center(child: Text(level.yuvapresentmaha.toString()))),
//
                        DataCell(Center(child: Text(level.yuvaexpecttarun.toString()))),
                        DataCell(Center(child: Text(level.yuvapresenttarun.toString()))),
//
                        DataCell(Center(child: Text(level.yuvaexpectpradhyapak.toString()))),
                        DataCell(Center(child: Text(level.yuvapresentpradhyapak.toString()))),
                        //
                        DataCell(Center(child: Text(level.ekunexcept.toString(), style: TextStyle(fontWeight: FontWeight.w700)))),
                        DataCell(Center(child: Text(level.ekunpresent.toString(), style: TextStyle(fontWeight: FontWeight.w700)))),
                        //
                        DataCell(Container(
                            decoration: BoxDecoration(
                              color: Colors.orange.shade50,
                              border: Border.all(color: Colors.black26, width: 0.7),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              level.yuvaexpectmandal.toString(),
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ))),
                        DataCell(Container(
                            decoration: BoxDecoration(
                              color: Colors.orange.shade50,
                              border: Border.all(color: Colors.black26, width: 0.7),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              level.yuvapresentmandal.toString(),
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ))),
                        //
                        DataCell(Center(child: Text(level.mahaexpectmaha.toString()))),
                        DataCell(Center(child: Text(level.mahapresentmaha.toString()))),
                        //
                        DataCell(Center(child: Text(level.mahaexpectvasti.toString()))),
                        DataCell(Center(child: Text(level.mahapresentvasti.toString()))),
                        //
                        DataCell(Center(child: Text(level.yuvasangamexceptmahashaakha.toString()))),
                        DataCell(Center(child: Text(level.yuvasangampresentmahashaakha.toString()))),
                        //
                        DataCell(Center(child: Text(level.yuvasangamexceptmahashaakhasankalpit.toString()))),
                        DataCell(Center(child: Text(level.yuvasangampresentmahashaakhasankalpit.toString()))),
                        //
                        DataCell(Center(child: Text(level.yuvasangamexceptvartmantarun.toString()))),
                        DataCell(Center(child: Text(level.yuvasangampresentvartmantarun.toString()))),
                        //
                        DataCell(Center(child: Text(level.yuvasangamexceptvartmantarunsankalpit.toString()))),
                        DataCell(Center(child: Text(level.yuvasangampresentvartmantarunsankalpit.toString()))),
                        //
                        DataCell(Center(child: Text(level.yuvasangamexceptshaakha.toString()))),
                        DataCell(Center(child: Text(level.yuvasangampresentshaakha.toString()))),
                        //
                        DataCell(Center(child: Text(level.yuvasangamexceptvartmansankalpit.toString()))),
                        DataCell(Center(child: Text(level.yuvasangampresentsankalpitshaakha.toString()))),
                        //
                        DataCell(Center(child: Text(level.totalyuvasangamexceptshaakha.toString()))),
                        DataCell(Center(child: Text(level.totalyuvasangampresentshaakha.toString()))),
                      ]);
                    }).toList() +
                    [
                      DataRow(color: MaterialStatePropertyAll(Colors.yellow.shade100), cells: [
                        DataCell(Center(
                            child: Text(
                          data.fold(0, (sum, item) => sum + (item.ekunyuva ?? 0)).toString(),
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ))),
                        DataCell(Center(
                            child: Text(
                          data.fold(0, (sum, item) => sum + (item.completeyuva ?? 0)).toString(),
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ))),
                        DataCell(Center(
                            child: Text(
                          data.fold(0, (sum, item) => sum + (item.pendingyuva ?? 0)).toString(),
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ))),
                        DataCell(Center(
                            child: Text(
                          data.fold(0, (sum, item) => sum + (item.yuvaexpectmaha ?? 0)).toString(),
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ))),
                        DataCell(Center(
                            child: Text(
                          data.fold(0, (sum, item) => sum + (item.yuvapresentmaha ?? 0)).toString(),
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ))),
                        DataCell(Center(
                            child: Text(
                          data.fold(0, (sum, item) => sum + (item.yuvaexpecttarun ?? 0)).toString(),
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ))),
                        DataCell(Center(
                            child: Text(
                          data.fold(0, (sum, item) => sum + (item.yuvapresenttarun ?? 0)).toString(),
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ))),
                        DataCell(Center(
                            child: Text(
                          data.fold(0, (sum, item) => sum + (item.yuvaexpectpradhyapak ?? 0)).toString(),
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ))),
                        DataCell(Center(
                            child: Text(
                          data.fold(0, (sum, item) => sum + (item.yuvapresentpradhyapak ?? 0)).toString(),
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ))),
                        DataCell(Center(
                            child: Text(
                          data.fold(0, (sum, item) => sum + (item.ekunexcept ?? 0)).toString(),
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ))),
                        DataCell(Center(
                            child: Text(
                          data.fold(0, (sum, item) => sum + (item.ekunpresent ?? 0)).toString(),
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ))),
                        DataCell(Center(
                            child: Text(
                          data.fold(0, (sum, item) => sum + (item.yuvaexpectmandal ?? 0)).toString(),
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ))),
                        DataCell(Center(
                            child: Text(
                          data.fold(0, (sum, item) => sum + (item.yuvapresentmandal ?? 0)).toString(),
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ))),
                        DataCell(Center(
                            child: Text(
                          data.fold(0, (sum, item) => sum + (item.mahaexpectmaha ?? 0)).toString(),
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ))),
                        DataCell(Center(
                            child: Text(
                          data.fold(0, (sum, item) => sum + (item.mahapresentmaha ?? 0)).toString(),
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ))),
                        DataCell(Center(
                            child: Text(
                          data.fold(0, (sum, item) => sum + (item.mahaexpectvasti ?? 0)).toString(),
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ))),
                        DataCell(Center(
                            child: Text(
                          data.fold(0, (sum, item) => sum + (item.mahapresentvasti ?? 0)).toString(),
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ))),
                        DataCell(Center(
                            child: Text(
                          data.fold(0, (sum, item) => sum + (item.yuvasangamexceptmahashaakha ?? 0)).toString(),
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ))),
                        DataCell(Center(
                            child: Text(
                          data.fold(0, (sum, item) => sum + (item.yuvasangampresentmahashaakha ?? 0)).toString(),
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ))),
                        DataCell(Center(
                            child: Text(
                          data.fold(0, (sum, item) => sum + (item.yuvasangamexceptmahashaakhasankalpit ?? 0)).toString(),
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ))),
                        DataCell(Center(
                            child: Text(
                          data.fold(0, (sum, item) => sum + (item.yuvasangampresentmahashaakhasankalpit ?? 0)).toString(),
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ))),
                        DataCell(Center(
                            child: Text(
                          data.fold(0, (sum, item) => sum + (item.yuvasangamexceptvartmantarun ?? 0)).toString(),
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ))),
                        DataCell(Center(
                            child: Text(
                          data.fold(0, (sum, item) => sum + (item.yuvasangampresentvartmantarun ?? 0)).toString(),
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ))),
                        DataCell(Center(
                            child: Text(
                          data.fold(0, (sum, item) => sum + (item.yuvasangamexceptvartmantarunsankalpit ?? 0)).toString(),
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ))),
                        DataCell(Center(
                            child: Text(
                          data.fold(0, (sum, item) => sum + (item.yuvasangampresentvartmantarunsankalpit ?? 0)).toString(),
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ))),
                        DataCell(Center(
                            child: Text(
                          data.fold(0, (sum, item) => sum + (item.yuvasangampresentshaakha ?? 0)).toString(),
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ))),
                        DataCell(Center(
                            child: Text(
                          data.fold(0, (sum, item) => sum + (item.yuvasangampresentsankalpitshaakha ?? 0)).toString(),
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ))),
                        DataCell(Center(
                            child: Text(
                          data.fold(0, (sum, item) => sum + (item.yuvasangamexceptshaakha ?? 0)).toString(),
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ))),
                        DataCell(Center(
                            child: Text(
                          data.fold(0, (sum, item) => sum + (item.yuvasangamexceptvartmansankalpit ?? 0)).toString(),
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ))),
                        DataCell(Center(
                            child: Text(
                          data.fold(0, (sum, item) => sum + (item.totalyuvasangamexceptshaakha ?? 0)).toString(),
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ))),
                        DataCell(Center(
                            child: Text(
                          data.fold(0, (sum, item) => sum + (item.totalyuvasangampresentshaakha ?? 0)).toString(),
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ))),
                      ])
                    ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  showInfoDialogBox({required String names, required String title}) {
    final ScrollController _scrollController = ScrollController();
    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, set) {
            return AlertDialog(
              insetPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 36),
              // contentPadding: EdgeInsets.zero,
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.white,
              title: Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.purple.shade400)),
              content: SingleChildScrollView(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Scrollbar(
                    controller: _scrollController,
                    thumbVisibility: true,
                    interactive: true,
                    thickness: 5,
                    radius: Radius.circular(10),
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columnSpacing: 14,
                        horizontalMargin: 12,
                        border: TableBorder.symmetric(inside: BorderSide(width: 0.4, color: Colors.grey.shade400)),
                        showCheckboxColumn: false,
                        headingRowColor: MaterialStatePropertyAll(Colors.purple.shade50),
                        headingTextStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
                        columns: [
                          DataColumn(
                              label: Container(
                            constraints: BoxConstraints(maxWidth: 40),
                            child: Text(" "),
                          )),
                          DataColumn(
                              label: Container(
                            constraints: BoxConstraints(minWidth: MediaQuery.sizeOf(context).width * 0.5),
                            child: Text(
                              "${Statics.getLabel('Name')}",
                            ),
                          )),
                        ],
                        rows: names.split(",").toList().asMap().entries.map((entry) {
                          int index = entry.key;
                          var data = entry.value;
                          return DataRow(cells: [
                            DataCell(Container(constraints: BoxConstraints(maxWidth: 40), child: Text((index + 1).toString()))),
                            DataCell(Text(data, maxLines: 2, overflow: TextOverflow.ellipsis, softWrap: true)),
                          ]);
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ),
              actions: [
                ElevatedButton(
                  child: Text(Statics.getLabel("bandKara")),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildExpansionPanel() {
    return Container(
      // width: MediaQuery.of(context).size.width * 0.9,
      // margin: EdgeInsets.symmetric(horizontal: 20),
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
              margin: EdgeInsets.all(10),
              child: Column(
                children: [
                  if (_linkedMahaanagar != null && _linkedMahaanagar!.isNotEmpty)
                    _buildDropdownField(
                      label: Statics.getLabel('Mahaanagar'),
                      value: _linkedMahaanagarValue,
                      items: _linkedMahaanagar == null
                          ? []
                          : _linkedMahaanagar!
                              .map((bg) => DropdownMenuItem(
                                    value: bg.geoUnitID.toString(),
                                    child: Text(bg.name!),
                                  ))
                              .toList(),
                      onChanged: MyAppGlobals.isDropdownDisabled('Mahaanagar')
                          ? (value) {
                              if (value == null) return;
                            }
                          : (value) {
                              final selectedItem = _linkedMahaanagar!.firstWhere((bg) => bg.geoUnitID.toString() == value);
                              setState(() {
                                _searched = false;
                                _linkedMahaanagarValue = value;
                                _linkedVibhaagValue = null;
                                _selctedLevel = 'Mahaanagar';
                                _selctedLevelName = selectedItem.name ?? "";
                                _selectedGeoUnitId = value;
                                // _linkedMahaanagarName = selectedItem.name ?? "";
                                // _resetLinkedValues();
                              });
                              populatelinkedVibhaagDropdown(value!);
                              populatelinkedBhaagDropdown("");
                            },
                      isDisabled: MyAppGlobals.isDropdownDisabled('Mahaanagar'),
                    ),
                  if (_linkedVibhaag != null)
                    _buildDropdownField(
                      label: Statics.getLabel('Vibhaag'),
                      value: _linkedVibhaagValue,
                      items: _linkedVibhaag == null
                          ? []
                          : _linkedVibhaag!
                              .map((bg) => DropdownMenuItem(
                                    value: bg.geoUnitID.toString(),
                                    child: Text(bg.name!),
                                  ))
                              .toList(),
                      onChanged: MyAppGlobals.isDropdownDisabled('Vibhaag')
                          ? (value) {
                              if (value == null) return;
                            }
                          : (value) {
                              final selectedItem = _linkedVibhaag!.firstWhere((bg) => bg.geoUnitID.toString() == value);
                              setState(() {
                                print("i am in vibhag setstate");
                                _searched = false;
                                _linkedVibhaagValue = value;
                                _selctedLevel = 'Vibhaag';
                                _selctedLevelName = selectedItem.name ?? "";
                                _selectedGeoUnitId = value;
                                // _linkedVibhaagName = selectedItem.name ?? "";
                              });
                              populatelinkedBhaagDropdown(value!);
                            },
                      isDisabled: MyAppGlobals.isDropdownDisabled('Vibhaag'),
                    ),
                  //if (_linkedbhaag != null && _linkedbhaag!.isNotEmpty)
                  _buildDropdownField(
                    label: Statics.getLabel('Bhaag'),
                    value: _linkedbhaagValue,
                    items: _linkedbhaag == null
                        ? []
                        : _linkedbhaag!
                            .map((bg) => DropdownMenuItem(
                                  value: bg.geoUnitID.toString(),
                                  child: Text(bg.name!),
                                ))
                            .toList(),
                    onChanged: MyAppGlobals.isDropdownDisabled('Bhaag')
                        ? (value) {
                            if (value == null) return;
                          }
                        : (value) {
                            final selectedItem = _linkedbhaag!.firstWhere((bg) => bg.geoUnitID.toString() == value);
                            setState(() {
                              _searched = false;
                              _linkedbhaagValue = value;
                              _selctedLevel = 'Bhaag';
                              _selctedLevelName = selectedItem.name ?? "";
                              _linkedbhaagName = selectedItem.name ?? "";
                              _selectedGeoUnitId = value;
                              //populatelinkedShaharDropdown(value!);
                              populatelinkedNagarDropdown(value, null);
                            });
                          },
                    isDisabled: MyAppGlobals.isDropdownDisabled('Bhaag'),
                  ),

                  // if (_linkednagar != null && _linkednagar!.isNotEmpty)
                  _buildDropdownField(
                    label: Statics.getLabel('Nagar'),
                    value: _linkednagarValue,
                    items: _linkednagar == null
                        ? []
                        : _linkednagar!
                            .map((bg) => DropdownMenuItem(
                                  value: bg.geoUnitID.toString(),
                                  child: Text(bg.name!),
                                ))
                            .toList(),
                    onChanged: MyAppGlobals.isDropdownDisabled('Nagar')
                        ? (value) {
                            if (value == null) return;
                          }
                        : (value) {
                            final selectedItem = _linkednagar!.firstWhere((bg) => bg.geoUnitID.toString() == value);
                            setState(() {
                              _searched = false;
                              _linkednagarValue = value;
                              _selectedGeoUnitId = value;
                              _selctedLevel = 'Nagar';
                              _selctedLevelName = selectedItem.name ?? "";
                              _linkednagarName = selectedItem.name ?? "";
                              populatelinkedUpnagarDropdown(value);
                              populatelinkedMandalDropdown(false, value);
                              populatelinkedVastiDropdown(value);
                            });
                          },
                    isDisabled: MyAppGlobals.isDropdownDisabled('Nagar'),
                  ),
                  /*if (_linkedupnagar != null && _linkedupnagar!.isNotEmpty)
                    _buildDropdownField(
                      label: Statics.getLabel('upnagarUpkhanda'),
                      value: _linkedupnagarValue,
                      items: _linkedupnagar == null
                          ? []
                          : _linkedupnagar!
                              .map((bg) => DropdownMenuItem(
                                    value: bg.geoUnitID.toString(),
                                    child: Text(bg.name!),
                                  ))
                              .toList(),
                      onChanged: MyAppGlobals.isDropdownDisabled('upnagarUpkhanda')
                          ? (value) {
                              if (value == null) return;
                            }
                          : (value) {
                              final selectedItem = _linkedupnagar!.firstWhere((bg) => bg.geoUnitID.toString() == value);
                              setState(() {
                                _searched = false;
                                _linkedupnagarValue = value;
                                _selectedGeoUnitId = value;
                                _selctedLevel = 'upnagarUpkhanda';
                                _selctedLevelName = selectedItem.name ?? "";
                                _linkedshaharName = selectedItem.name ?? "";
                                populatelinkedMandalDropdown(true, value);
                                populatelinkedVastiDropdown(value);

                                // populatelinkedNagarDropdown(null, value);
                              });
                            },
                      isDisabled: MyAppGlobals.isDropdownDisabled('upnagarUpkhanda'),
                    ),

                  if (_linkedmandal != null && _linkedmandal!.isNotEmpty)
                    _buildDropdownField(
                      label: Statics.getLabel('Mandal'),
                      value: _linkedmandalValue,
                      items: _linkedmandal == null
                          ? []
                          : _linkedmandal!
                              .map((bg) => DropdownMenuItem(
                                    value: bg.geoUnitID.toString(),
                                    child: Text(bg.name!),
                                  ))
                              .toList(),
                      onChanged: MyAppGlobals.isDropdownDisabled('Mandal')
                          ? (value) {
                              if (value == null) return;
                            }
                          : (value) {
                              final selectedItem = _linkedmandal!.firstWhere((bg) => bg.geoUnitID.toString() == value);
                              setState(() {
                                _linkedmandalValue = value;
                                _selectedGeoUnitId = value.toString();
                                _selctedLevel = 'Mandal';
                                _selctedLevelName = selectedItem.name ?? "";
                                _linkedmandalName = selectedItem.name ?? "";
                                populatelinkedGraamDropdown(value);
                              });
                            },
                      isDisabled: MyAppGlobals.isDropdownDisabled('Mandal'),
                    ),
                  if (_linkedgraam != null && _linkedgraam!.isNotEmpty)
                    _buildDropdownField(
                      label: Statics.getLabel('Graam'),
                      value: _linkedgraamValue,
                      items: _linkedgraam == null
                          ? []
                          : _linkedgraam!
                              .map((bg) => DropdownMenuItem(
                                    value: bg.geoUnitID.toString(),
                                    child: Text(bg.name!),
                                  ))
                              .toList(),
                      onChanged: MyAppGlobals.isDropdownDisabled('Graam')
                          ? (value) {
                              if (value == null) return;
                            }
                          : (value) {
                              final selectedItem = _linkedgraam!.firstWhere((bg) => bg.geoUnitID.toString() == value);
                              setState(() {
                                _linkedgraamValue = value;
                                _selectedGeoUnitId = value.toString();
                                _selctedLevel = 'Graam';
                                _selctedLevelName = selectedItem.name ?? "";
                                _linkedgraamName = selectedItem.name ?? "";
                              });
                            },
                      isDisabled: MyAppGlobals.isDropdownDisabled('Graam'),
                    ),
                  if (_linkedvasti != null && _linkedvasti!.isNotEmpty)
                    _buildDropdownField(
                      label: Statics.getLabel('Vasti'),
                      value: _linkedvastiValue,
                      items: _linkedvasti == null
                          ? []
                          : _linkedvasti!
                              .map((bg) => DropdownMenuItem(
                                    value: bg.geoUnitID.toString(),
                                    child: Text(bg.name!),
                                  ))
                              .toList(),
                      onChanged: MyAppGlobals.isDropdownDisabled('Vasti')
                          ? (value) {
                              if (value == null) return;
                            }
                          : (value) {
                              final selectedItem = _linkedvasti!.firstWhere((bg) => bg.geoUnitID.toString() == value);
                              setState(() {
                                _linkedvastiValue = value;
                                _selectedGeoUnitId = value.toString();
                                _selctedLevel = 'Vasti';
                                _selctedLevelName = selectedItem.name ?? "";
                                _linkedvastiName = selectedItem.name ?? "";
                              });
                            },
                      isDisabled: MyAppGlobals.isDropdownDisabled('Vasti'),
                    ),*/
                  SizedBox(height: 15),
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
                        onPressed: () async {
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
                              _selctedLevelName = "";
                              _selectedGeoUnitId = null;
                              _linkedMahaanagarValue = _linkedbhaagValue = _linkedshaharValue = _linkednagarValue = _linkedmandalValue = _linkedvastiValue = _linkedgraamValue = null;
                              _linkedVibhaagValue = _linkedbhaag = _linkedshahar = _linkedgraam = _linkedmandal = _linkedvasti = _linkednagar = null;
                              _selctedLevel = "praant";
                            });
                            await populateDropdown(userLevelId!, null, fromClear: true);
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
        value: (value == "" || value == "null") ? null : value,
        items: items,
        onChanged: onChanged,
      ),
    );
  }
}
