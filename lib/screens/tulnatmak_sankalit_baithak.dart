import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:dropdown_search/dropdown_search.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;

import '../helpers/static_data.dart' as Statics;
import '../models/response_model/TulnatmakResponseModel.dart';
import '../models/response_model/dropdown_level_responsemodel.dart';
import '../providers/bals.dart';
import '../utils/globals.dart';

class TulnatmakBaithakEkatritVrutta extends StatefulWidget {
  static const routeName = '/tulnatmak-annual-baithak-ekatrit-vrutta';

  @override
  _TulnatmakBaithakEkatritVruttaState createState() => _TulnatmakBaithakEkatritVruttaState();
}

class _TulnatmakBaithakEkatritVruttaState extends State<TulnatmakBaithakEkatritVrutta> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final GlobalKey<FormState> _completeFormKey = GlobalKey();
  TulnatmakBaithakResponse? tulnatmakBaithakResponse;
  bool _isSearching = false;
  bool _isExpanded = false;
  bool _sankalpBar = false;

  List<GeoUnitMasterBAL>? _linkedMahaanagar;
  List<GeoUnitMasterBAL>? _linkedVibhaag;
  List<GeoUnitMasterBAL>? _linkedBhaag;
  List<GeoUnitMasterBAL>? _linkedShahar;
  List<GeoUnitMasterBAL>? _linkedNagar;
  List<StaticMasterBAL>? _baithakTypes;

  String? _linkedMahaanagarValue = '';
  String? _linkedVibhaagValue = '';
  String? _linkedBhaagValue = '';
  String? _linkedShaharValue = '';
  String? _linkedNagarValue = '';
  String? _baithakTypeValue1 = '';
  String? _baithakTypeValue2 = '';
  String? _baithakTypeValue3 = '';
  String? _selectedBaithak1 = '';
  String? _selectedBaithak2 = '';
  String? _selectedBaithak3 = '';
  int? _baithakType1;
  int? _baithakType2;
  int? _baithakType3;
  String _selectedNagarAndBaithak1 = '';
  String _selectedNagarAndBaithak2 = '';
  String _selectedNagarAndBaithak3 = '';
  String? mahanagarId = '';
  String? vibhagId = '';

  String? _baithakTypeValue1Name = '';
  String? _baithakTypeValue2Name = '';
  String? _baithakTypeValue3Name = '';

  String? _tulnatmakvruttapoint = '';
  final List<DropdownMenuItem<String>> _tulnatmakvruttapointItems = [
    DropdownMenuItem(value: 'bahugolik', child: Text('भौगौलिक कार्यस्थिती')),
    DropdownMenuItem(value: 'sevavrutta', child: Text('सेवा वृत्त')),
    DropdownMenuItem(value: 'purna', child: Text('पूर्ण')),
    DropdownMenuItem(value: 'karyastiti', child: Text('कार्यस्थिती')),
    DropdownMenuItem(value: 'toliyukt', child: Text('टोळी युक्त')),
    DropdownMenuItem(value: 'baithakkarnarya', child: Text('बैठक करणाऱ्या')),
    DropdownMenuItem(value: 'palakyukta', child: Text('पालक युक्त')),
    DropdownMenuItem(value: 'varshikotsavkarnarya', child: Text('वार्षिकोत्सव करणाऱ्या')),
  ];
  String? _bhougolikkaryastithisubpoint = '';
  final List<DropdownMenuItem<String>> _bhougolikkaryastithisubpointItems = [
    DropdownMenuItem(value: 'mahanagar', child: Text('महानगरीय नगर')),
    DropdownMenuItem(value: 'anyanagar', child: Text('अन्य नगर')),
    DropdownMenuItem(value: 'ekunnagar', child: Text('एकुण नगर')),
    DropdownMenuItem(value: 'taluka', child: Text("${Statics.getLabel('taalukaa')}")),
    DropdownMenuItem(value: 'madal', child: Text('मंडल')),
    DropdownMenuItem(value: 'graam', child: Text('ग्राम')),
    DropdownMenuItem(value: 'basti', child: Text('बस्ती')),
    DropdownMenuItem(value: 'sthan', child: Text("${Statics.getLabel('sthaan')}")),
  ];
  String? _mahAnyEkunManBasGram = '';
  final List<DropdownMenuItem<String>> _mahAnyEkunManBasGramItems = [
    DropdownMenuItem(value: 'sakhayukta', child: Text("${Statics.getLabel('shaakhaaYukta')}")),
    DropdownMenuItem(value: 'saptahikmilanyukt', child: Text('साप्ताहिक मिलन युक्त')),
    DropdownMenuItem(value: 'kimandosakha', child: Text('किमान दो शाखा')),
    DropdownMenuItem(value: 'mandaliyukt', child: Text('मंडळी युक्त')),
  ];

  String? _talukasubpoint = '';
  final List<DropdownMenuItem<String>> _talukasubpointItems = [
    DropdownMenuItem(value: 'sakhayukta', child: Text("${Statics.getLabel('shaakhaaYukta')}")),
    DropdownMenuItem(value: 'sakhayuktatalukakendra', child: Text('शाखायुक्त तालुका केंद्र')),
  ];

  String? _sthansubpoint = '';
  final List<DropdownMenuItem<String>> _sthansubpointItems = [
    DropdownMenuItem(value: 'mahanagariya', child: Text('महानगरीय')),
    DropdownMenuItem(value: 'anyanagar', child: Text('अन्य नगरीय')),
    DropdownMenuItem(value: 'ekunnagar', child: Text('एकुण नगरीय')),
    DropdownMenuItem(value: 'graminSthan', child: Text('ग्रामीण स्थान')),
    DropdownMenuItem(value: 'ekunstan', child: Text('एकुण स्थान')),
  ];

  String? _sewavruttasubpoint = '';
  final List<DropdownMenuItem<String>> _sewavruttasubpointItems = [
    DropdownMenuItem(value: 'niyamitsampakkarnaryasakha', child: Text('मासिक संपर्क करणाऱ्या शाखा')),
    DropdownMenuItem(value: 'sevaupakramkarnaryasaakha', child: Text('सेवा उपक्रम करणाऱ्या शाखा')),
    DropdownMenuItem(value: 'anyaupakramshaakhaa', child: Text('अन्य उपक्रम करणाऱ्या शाखा')),
    DropdownMenuItem(value: 'sewavastiidentified', child: Text('सेवा बस्ती निश्चित केलेल्या शाखांची संख्या')),
    DropdownMenuItem(value: 'sewapramukhidentified', child: Text('सेवा प्रमुख निश्चित केलेल्या शाखांची संख्या')),
  ];
  String? _purnasubpoint = '';
  final List<DropdownMenuItem<String>> _purnasubpointItems = [
    DropdownMenuItem(value: 'purnajilha', child: Text('पूर्ण जिल्हा')),
    DropdownMenuItem(value: 'purnataluka', child: Text('पूर्ण तालुका')),
    DropdownMenuItem(value: 'purnanagar', child: Text('पूर्ण नगर')),
    DropdownMenuItem(value: 'purnamandal', child: Text('पूर्ण मंडल')),
  ];
  String? _karyastithisubpoint = '';
  final List<DropdownMenuItem<String>> _karyastithisubpointItems = [
    DropdownMenuItem(value: 'shakha', child: Text("${Statics.getLabel('Shaakhaa')}")),
    DropdownMenuItem(value: 'saptahikmilan', child: Text("${Statics.getLabel('SaaptaahikMilan')}")),
    DropdownMenuItem(value: 'sanghmandali', child: Text('संघ मंडली')),
    DropdownMenuItem(value: 'masikmilan', child: Text("${Statics.getLabel('MaasikMilan')}")),
  ];

  //  String? _selectvayogatsubpoint='';
  // final List<DropdownMenuItem<String>> _selectvayogatsubpointItems = [
  //   DropdownMenuItem(value: 'baal/saiyukt', child: Text( 'बाल / संयुक्त')),
  //   DropdownMenuItem(value: 'mahavidyalain', child: Text('महाविद्यालयीन ( केवळ तरुण )')),
  //   DropdownMenuItem(value: 'tarunvaysai', child: Text('तरुण व्यवसायी')),
  //   DropdownMenuItem(value: 'prodhvaysai', child: Text('प्रौढ व्यवसायी')),
  //   DropdownMenuItem(value: 'vidyarthi', child: Text( 'विद्यार्थी')),
  //   DropdownMenuItem(value: 'vyavsayi', child: Text('व्यवसायी')),
  //   DropdownMenuItem(value: 'ekun', child: Text("${Statics.getLabel('Total')}")),
  // ];
  //
  //  String? _vayogatSanghamandaliSaptahikMilan ='';
  // final List<DropdownMenuItem<String>> _vayogatSanghamandaliSaptahikMilanItems = [
  //   DropdownMenuItem(value: 'vidyarthi', child: Text( 'विद्यार्थी')),
  //   DropdownMenuItem(value: 'vyavsayi', child: Text('व्यवसायी')),
  //   DropdownMenuItem(value: 'ekun', child: Text("${Statics.getLabel('Total')}")),
  // ];
  String? _selectvayogatsubpoint = '';
  List<DropdownMenuItem<String>> _selectvayogatsubpointItems = [];

  final List<DropdownMenuItem<String>> _vayogatItems1 = [
    DropdownMenuItem(value: 'vidyarthi', child: Text('विद्यार्थी')),
    DropdownMenuItem(value: 'vaysai', child: Text('व्यवसायी')),
    DropdownMenuItem(value: 'ekun', child: Text("${Statics.getLabel('Total')}")),
  ];

  final List<DropdownMenuItem<String>> _vayogatItems2 = [
    DropdownMenuItem(value: 'baal/saiyukt', child: Text('बाल / संयुक्त')),
    DropdownMenuItem(value: 'mahavidyalain', child: Text('महाविद्यालयीन (केवळ तरुण)')),
    DropdownMenuItem(value: 'tarunvaysai', child: Text('तरुण व्यवसायी')),
    DropdownMenuItem(value: 'prodhvaysai', child: Text('प्रौढ व्यवसायी')),
    DropdownMenuItem(value: 'ekun', child: Text("${Statics.getLabel('Total')}")),
  ];

  String? _saptahikmilansubpoint = '';
  List<DropdownMenuItem<String>> _saptahikmilansubpointItems = [];

  void _updateDropdownItems() {
    if (_karyastithisubpoint == "saptahikmilan") {
      _saptahikmilansubpointItems = [
        DropdownMenuItem(value: 'nagriya', child: Text('नगरीय')),
        DropdownMenuItem(value: 'gramin', child: Text('ग्रामीण')),
        DropdownMenuItem(value: 'ekun', child: Text("${Statics.getLabel('Total')}")),
      ];
    } else if (_toliyuktasubpoint == "saptahikmilan") {
      _saptahikmilansubpointItems = [
        DropdownMenuItem(value: 'ekun', child: Text("${Statics.getLabel('Total')}")),
      ];
    }
  }

  String? _toliyuktasubpoint = '';
  final List<DropdownMenuItem<String>> _toliyuktasubpointItems = [
    DropdownMenuItem(value: 'shakha', child: Text("${Statics.getLabel('Shaakhaa')}")),
    DropdownMenuItem(value: 'saptahikmilan', child: Text("${Statics.getLabel('SaaptaahikMilan')}")),
  ];

  String? _baithakkarnaryasubpoint = '';
  final List<DropdownMenuItem<String>> _baithakkarnaryasubpointItems = [
    DropdownMenuItem(value: 'shakha', child: Text("${Statics.getLabel('Shaakhaa')}")),
    DropdownMenuItem(value: 'saptahikmilan', child: Text("${Statics.getLabel('SaaptaahikMilan')}")),
  ];

  String? _palakyuktasubpoint = '';
  final List<DropdownMenuItem<String>> _palakyuktasubpointItems = [
    DropdownMenuItem(value: 'shakha', child: Text("${Statics.getLabel('Shaakhaa')}")),
    DropdownMenuItem(value: 'saptahikmilan', child: Text("${Statics.getLabel('SaaptaahikMilan')}")),
  ];

  String? _varshikotsavkarnaryasubpoint = '';
  final List<DropdownMenuItem<String>> _varshikotsavkarnaryasubpointItems = [
    DropdownMenuItem(value: 'shakha', child: Text("${Statics.getLabel('Shaakhaa')}")),
    DropdownMenuItem(value: 'saptahikmilan', child: Text("${Statics.getLabel('SaaptaahikMilan')}")),
  ];

  dynamic _ekatritVrutta;
  int? _geoLevel;
  bool _hasGraaminKshetra = false;
  String _selectedNagarAndBaithak = '';
  String _selectedcomparativevruttapoint = '';
  String _selectedbhougolikkaryastithisubpoint = '';
  String _selectedmahAnyEkunManBasGram = '';
  String _selectedtalukasubpoint = '';
  String _selectedsthansubpoint = '';
  String _selectedsewavruttasubpoint = '';
  String _selectedpurnasubpoint = '';
  String _selectedkaryastithisubpoint = '';
  String _selectedtoliyuktasubpoint = '';
  String _selectedbaithakkarnaryasubpoint = '';
  String _selectedsaptahikmilansubpoint = '';
  String _selectedvayogatsubpoint = '';

  String? _linkedupnagarValue = '';
  String? _selctedLevel = 'praant';
  String? _selctedLevelName = '';
  String _selctedLevelNames = '';
  List<String?> _selctedLevelNameList = [];
  String? _selectedGeoUnitId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    populateDropdown();
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
      _selectedGeoUnitId = _linkedMahaanagarValue = _linkedVibhaagValue = _linkedBhaagValue = _linkedNagarValue = null;
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

    // if (_linkedVibhaag != null && _linkedVibhaag!.isNotEmpty) _linkedVibhaagName = _linkedVibhaag!.firstWhere((bg) => bg.geoUnitID.toString() == _linkedBhaagValue).name;
    // if (_linkedBhaag != null && _linkedBhaag!.isNotEmpty) _linkedbhaagName = _linkedBhaag!.firstWhere((bg) => bg.geoUnitID.toString() == _linkedBhaagValue).name;
    // if (_linkedNagar != null && _linkedNagar!.isNotEmpty) _linkednagarName = _linkedNagar!.firstWhere((bg) => bg.geoUnitID.toString() == _linkedBhaagValue).name;

    setState(() {});
  }

  Future<void> populateDropdown({bool fromClear = false}) async {
    setState(() {
      _linkedMahaanagarValue = _linkedVibhaagValue = _linkedBhaagValue = _linkedNagarValue = null;
      _linkedMahaanagar = _linkedVibhaag = _linkedBhaag = _linkedNagar = null;
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
    var data = await Statics.getStaticLDB('AnnualBaithakType');
    if (!mounted) return;
    setState(() {
      _baithakTypes = data;
    });
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedMahaanagarDropdown() async {
    final data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['MahaanagarLevelID'].toString(), '', '', '', isAbhiyaan: false);
    setState(() => _linkedMahaanagar = data);
    return data;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedVibhaagDropdown(String mahaanagarIDStr) async {
    _linkedBhaagValue = _linkedNagarValue = null;
    final data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['VibhaagLevelID'].toString(), mahaanagarIDStr, mahaanagarIDStr.isEmpty ? '' : 'Mahaanagar', '', isAbhiyaan: false);
    setState(() => _linkedVibhaag = data);
    return data;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedBhaagDropdown(String vibhaagIDStr) async {
    _linkedNagarValue = null;
    //_linkedbhaagName = _linkednagarName = _linkedmandalName = _linkedgraamName = _linkedvastiName = null;
    _linkedBhaag = _linkedNagar = [];
    final data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['BhaagLevelID'].toString(), vibhaagIDStr, 'Vibhaag', '', isAbhiyaan: false);
    setState(() => _linkedBhaag = data);
    return data;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedNagarDropdown(String? bhaagIDStr, String? shaharIDStr) async {
    _linkedNagarValue = null;
    //_linkednagarName = _linkedmandalName = _linkedgraamName = _linkedvastiName = null;
    _linkedNagar = null;
    final parentID = shaharIDStr ?? bhaagIDStr!;
    final parentType = shaharIDStr != null ? 'Shahar' : 'Bhaag';
    final data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['NagarLevelID'].toString(), parentID, parentType, '', isAbhiyaan: false);
    setState(() => _linkedNagar = data.isNotEmpty ? data : null);
    return data;
  }

  // void populateDropdown() async {
  //   var data = await Statics.getStaticLDB('AnnualBaithakType');
  //   populatelinkedMahaanagarDropdown();
  //   populatelinkedVibhaagDropdown('');
  //   if (!mounted) return;
  //   setState(() {
  //     _baithakTypes = data;
  //   });
  // }

  // void populatelinkedMahaanagarDropdown() async {
  //   var data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['MahaanagarLevelID'].toString(), '', '', '');
  //   setState(() {
  //     _linkedMahaanagar = data;
  //   });
  // }
  //
  // void populatelinkedVibhaagDropdown(String mahaanagarIDStr) async {
  //   _linkedBhaagValue = null;
  //   var data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['VibhaagLevelID'].toString(), mahaanagarIDStr, (mahaanagarIDStr.isEmpty ? '' : 'Mahaanagar'), '');
  //   setState(() {
  //     _linkedVibhaag = data;
  //   });
  // }
  //
  // void populatelinkedBhaagDropdown(String vibhaagIDStr) async {
  //   _linkedShaharValue = _linkedNagarValue = null;
  //   var data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['BhaagLevelID'].toString(), vibhaagIDStr, 'Vibhaag', '');
  //   setState(() {
  //     _linkedBhaag = data;
  //   });
  // }
  //
  // void populatelinkedShaharDropdown(String? bhaagIDStr) async {
  //   _linkedShaharValue = _linkedShahar = null;
  //   var shDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['ShaharLevelID'].toString(), bhaagIDStr!, 'Bhaag', '');
  //   setState(() {
  //     _linkedShahar = (shDD.length > 0 ? shDD : null);
  //   });
  // }
  //
  // void populatelinkedNagarDropdown(String? bhaagIDStr, String? shaharIDStr) async {
  //   _linkedNagarValue = null;
  //   _linkedNagar = null;
  //   if (shaharIDStr != null) {
  //     var ngDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['NagarLevelID'].toString(), shaharIDStr, 'Shahar', '');
  //     setState(() {
  //       _linkedNagar = (ngDD.length > 0 ? ngDD : null);
  //     });
  //   } else {
  //     var ngDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['NagarLevelID'].toString(), bhaagIDStr!, 'Bhaag', '');
  //     setState(() {
  //       _linkedNagar = (ngDD.length > 0 ? ngDD : null);
  //     });
  //   }
  // }

  Future<dynamic> _getTulnatmakEkatritVrutta(
      int baithakTypeID1,
      int baithakTypeID2,
      int? baithakTypeID3,
      int? geoID,
      String? tulnatmakBindu,
      String? bhougolikKaryasthiti,
      String? mahAnyEkuManBasSub,
      String? talukaSub,
      String? sthanSub,
      String? sewavruttasub,
      String? purnaSub,
      String? karyastiti,
      String? toliyuktasub,
      String? baithakkarnarya,
      String? vayogat,
      String? saptahikmilan,
      String? palakyukta,
      String? varshikotsavkarnarya) async {
    bool isConnected = await Statics.isInternetConnected();
    if (isConnected) {
      String strInput = json.encode({
        "iAppUserID": int.parse(Statics.userDetails['userID']),
        "iBaithakTypeID1": baithakTypeID1,
        "iBaithakTypeID2": baithakTypeID2,
        "iBaithakTypeID3": baithakTypeID3 ?? 0,
        "iGeoUnitID": geoID ?? 0,
        "tulnakmakbindu": tulnatmakBindu,
        "bhougolikkaryastitisub": bhougolikKaryasthiti,
        "mahanyekumanbassub": mahAnyEkuManBasSub,
        "talukasub": talukaSub,
        "stansub": sthanSub,
        "sewavruttasub": sewavruttasub,
        "purnasub": purnaSub,
        "karyastitisub": karyastiti,
        "toliyuktasub": toliyuktasub,
        "baithakkarnaryasub": baithakkarnarya,
        "vayogat": vayogat,
        "saptahikmilan": saptahikmilan,
        "palakyukta": palakyukta,
        "varshikotsavkarnarya": varshikotsavkarnarya,
      });
      // print("_getTulnatmakEkatritVrutta req param :-  $strInput");
      // showPopupWithStrInput(context, strInput);
      tulnatmakBaithakResponse = await Statics.getTulnatmakBaithakEkatritVruttaForApp(strInput);
    } else {
      Statics.showMessageDialog(context, Statics.getLabel('internetNotConnected'));
      return null;
    }
  }

  void showPopupWithStrInput(BuildContext context, String strInput) {
    String formattedJson;

    try {
      var jsonObject = json.decode(strInput); // JSON string को object में बदलें
      formattedJson = const JsonEncoder.withIndent('  ').convert(jsonObject); // Pretty-print JSON
    } catch (e) {
      formattedJson = 'Invalid JSON format:\n$strInput'; // यदि JSON नहीं है
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Request Payload"),
          content: SingleChildScrollView(
            child: SelectableText(
              formattedJson,
              style: const TextStyle(
                fontSize: 15,
              ), // fixed-width font for JSON
            ),
          ),
          actions: [
            TextButton(
              child: const Text("Close"),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  Future<void> _search() async {
    print("_search 1");
    setState(() {
      _isSearching = true;
    });
    int? mahaanagarVal = _linkedMahaanagarValue == null || _linkedMahaanagarValue == "" ? null : int.parse(_linkedMahaanagarValue!);
    int? vibhaagVal = _linkedVibhaagValue == null || _linkedVibhaagValue == "" ? null : int.parse(_linkedVibhaagValue!);
    int? bhaagVal = _linkedBhaagValue == null || _linkedBhaagValue == "" ? null : int.parse(_linkedBhaagValue!);
    int? shaharVal = _linkedShaharValue == null || _linkedShaharValue == "" ? null : int.parse(_linkedShaharValue!);
    int? nagarVal = _linkedNagarValue == null || _linkedNagarValue == "" ? null : int.parse(_linkedNagarValue!);

    int? geoID = (nagarVal != null ? nagarVal : (bhaagVal != null ? bhaagVal : (vibhaagVal != null ? vibhaagVal : (mahaanagarVal != null ? mahaanagarVal : null))));
    _baithakType1 = _baithakTypeValue1 == null || _baithakTypeValue1 == "" ? null : int.parse(_baithakTypeValue1!);
    _baithakType2 = _baithakTypeValue2 == null || _baithakTypeValue2 == "" ? null : int.parse(_baithakTypeValue2!);
    _baithakType3 = _baithakTypeValue3 == null || _baithakTypeValue3 == "" ? null : int.parse(_baithakTypeValue3!);
    _geoLevel = (nagarVal != null ? 6 : (bhaagVal != null ? 7 : (vibhaagVal != null ? 8 : (mahaanagarVal != null ? 9 : 10))));

    dynamic obj;
    if (_baithakType1 != null && _baithakType2 != null || _baithakType3 != null) {
      print("_search 2");

      if (_baithakType1 != _baithakType2 && _baithakType1 != _baithakType3 && _baithakType2 != _baithakType3) {
        print("_search 3");

        try {
          obj = await _getTulnatmakEkatritVrutta(
              _baithakType1!,
              _baithakType2!,
              _baithakType3,
              geoID,
              _tulnatmakvruttapoint,
              _bhougolikkaryastithisubpoint,
              _mahAnyEkunManBasGram,
              _talukasubpoint,
              _sthansubpoint,
              _sewavruttasubpoint,
              _purnasubpoint,
              _karyastithisubpoint,
              _toliyuktasubpoint,
              _baithakkarnaryasubpoint,
              _selectvayogatsubpoint,
              _saptahikmilansubpoint,
              _palakyuktasubpoint,
              _varshikotsavkarnaryasubpoint);
        } catch (e) {
          print("_search 4");

          print("_search() $e");
        }
      } else {
        print("_search 5");

        Statics.showMessageDialog(context, Statics.getLabel('ChooseDiffrentMeetingType'));
      }
      print("_search 6");
    } else {
      print("_search 7");

      Statics.showMessageDialog(context, Statics.getLabel('baithakTypeNotSelected'));
    }

    setState(() {
      print("_search 8");

      if (_baithakType1 == null && _baithakType2 == null) {
        print("_search 9");

        _ekatritVrutta = null;
        _selectedBaithak1 = '';
        _selectedBaithak2 = '';
        _selectedBaithak3 = '';
        _selectedNagarAndBaithak = '';
      } else {
        print("_search 10");

        _ekatritVrutta = obj;
        _selectedNagarAndBaithak = (mahaanagarVal == null ? '' : _linkedMahaanagar!.firstWhere((element) => element.geoUnitID == mahaanagarVal).name!) +
            ' | ' +
            (vibhaagVal == null ? ' - ' : _linkedVibhaag!.firstWhere((element) => element.geoUnitID == vibhaagVal).name!) +
            ' | ' +
            (bhaagVal == null ? ' - ' : _linkedBhaag!.firstWhere((element) => element.geoUnitID == bhaagVal).name!) +
            ' | ' +
            (nagarVal == null ? ' - ' : _linkedNagar!.firstWhere((element) => element.geoUnitID == nagarVal).name!) +
            ' | ';
      }

      _isSearching = false;
      _isExpanded = false;
    });
  }

  Future<void> takeScreenShot() async {
    try {
      final boundary = _formKey.currentContext!.findRenderObject() as RenderRepaintBoundary;

      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final pngBytes = byteData!.buffer.asUint8List();

      final directory = await getApplicationDocumentsDirectory();
      final customDir = Directory('${directory.path}/MyCustomFolder');

      if (!(await customDir.exists())) {
        await customDir.create(recursive: true); // Create the folder
      }

      final imgFile = File('${customDir.path}/screenshot.png');
      await imgFile.writeAsBytes(pngBytes);

      print("Screenshot saved to ${imgFile.path}");

      final pdf = pw.Document();
      final pageWidth = 595.27; // A4 page width in points
      final pageHeight = 841.89; // A4 page height in points

      // Calculate aspect ratio of the image
      final imgWidth = image.width.toDouble();
      final imgHeight = image.height.toDouble();
      final aspectRatio = imgWidth / imgHeight;

      // Determine scaled dimensions to fit the image onto a single page
      double scaledWidth, scaledHeight;

      if (aspectRatio > pageWidth / pageHeight) {
        // Image is wider than the page, scale based on width
        scaledWidth = pageWidth;
        scaledHeight = pageWidth / aspectRatio;
      } else {
        // Image is taller than the page, scale based on height
        scaledHeight = pageHeight;
        scaledWidth = pageHeight * aspectRatio;
      }

      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Center(
              child: pw.Image(
                pw.MemoryImage(pngBytes),
                width: scaledWidth,
                height: scaledHeight,
                fit: pw.BoxFit.contain,
              ),
            );
          },
        ),
      );

      final pdfBytes = await pdf.save();
      final pdfFile = File('${customDir.path}/tulnatmak-sankalit-baithak-vrutta.pdf');
      await pdfFile.writeAsBytes(pdfBytes);

      print("PDF saved to ${pdfFile.path}");
      final result = await OpenFilex.open(pdfFile.path);
      print("Open file result: ${result.message}");
    } catch (e) {
      print("Error taking screenshot: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    _updateDropdownItems();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          Statics.getLabel('tulnatmakBaithakEkatritVruttaTitle'),
          style: TextStyle(fontSize: 20),
        ),
      ),
      floatingActionButton: tulnatmakBaithakResponse != null
          ? FloatingActionButton(
              mini: true,
              tooltip: Statics.getLabel("ExportToExcel"),
              onPressed: () async {
                takeScreenShot();
                // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('CSV file saved successfully')));
              },
              child: Icon(Icons.download_sharp),
              backgroundColor: Colors.green,
            )
          : Container(),
      // drawer: AppDrawer(),
      body: SingleChildScrollView(
        child: Container(
            padding: EdgeInsets.all(20),
            width: Statics.getDeviceSize(context).width,
            child: Form(
              key: _completeFormKey,
              child: Column(
                children: <Widget>[
                  Text(
                    Statics.getLabel('tulnatmakBaithakEkatritVruttaBanner'),
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
// ==============================================   BAITHAK TYPE DROPDOWNS  ==========================================================================================================================================
                              Text(Statics.getLabel('selectbaithakType'), style: TextStyle(color: Theme.of(context).primaryColor)),
                              if (_baithakTypes != null)
                                DropdownSearch<String>(
                                  popupProps: PopupProps.bottomSheet(
                                    showSearchBox: true,
                                    fit: FlexFit.tight,
                                    itemBuilder: (context, item, isSelected, val) {
                                      return Container(
                                        margin: EdgeInsets.symmetric(horizontal: 8),
                                        decoration: !isSelected
                                            ? null
                                            : BoxDecoration(
                                                border: Border.all(color: Theme.of(context).primaryColor),
                                                borderRadius: BorderRadius.circular(5),
                                                color: Colors.grey[300],
                                              ),
                                        child: ListTile(
                                          title: Text(
                                            item,
                                            style: TextStyle(fontSize: 14),
                                          ),
                                          contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                                          visualDensity: VisualDensity(vertical: -4),
                                        ),
                                      );
                                    },
                                    searchFieldProps: TextFieldProps(
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                                      ),
                                    ),
                                    constraints: BoxConstraints.tightFor(width: double.infinity),
                                    containerBuilder: (context, popupWidget) {
                                      return Stack(
                                        children: [
                                          popupWidget,
                                          Positioned(
                                            right: 10,
                                            top: 10,
                                            child: IconButton(
                                              icon: Icon(Icons.close),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                  items: (filter, loadProps) =>
                                      _baithakTypes?.map((e) => e.codeForDisplay.toString()).where((name) => name.toLowerCase().contains(filter.toLowerCase() ?? "")).toList() ?? [],
                                  decoratorProps: DropDownDecoratorProps(
                                    decoration: InputDecoration(
                                      labelText: Statics.getLabel('selectbaithakTypeLabel') + " 1",
                                    ),
                                  ),
                                  selectedItem: _baithakTypeValue1 == "" ? null : _baithakTypes?.firstWhere((element) => element.staticID.toString() == _baithakTypeValue1).codeForDisplay,
                                  onChanged: (value) {
                                    print(value);
                                    setState(() {
                                      _baithakTypeValue1 = _baithakTypes!.firstWhere((element) => element.codeForDisplay == value).staticID.toString();
                                      _baithakTypeValue1Name = _baithakTypes!.firstWhere((element) => element.codeForDisplay == value).codeForDisplay.toString();
                                    });
                                  },
                                ),
                              SizedBox(height: 10),
                              if (_baithakTypes != null)
                                DropdownSearch<String>(
                                  popupProps: PopupProps.bottomSheet(
                                    showSearchBox: true,
                                    fit: FlexFit.tight,
                                    itemBuilder: (context, item, isSelected, val) {
                                      return Container(
                                        margin: EdgeInsets.symmetric(horizontal: 8),
                                        decoration: !isSelected
                                            ? null
                                            : BoxDecoration(
                                                border: Border.all(color: Theme.of(context).primaryColor),
                                                borderRadius: BorderRadius.circular(5),
                                                color: Colors.grey[300],
                                              ),
                                        child: ListTile(
                                          title: Text(
                                            item,
                                            style: TextStyle(fontSize: 14),
                                          ),
                                          contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                                          visualDensity: VisualDensity(vertical: -4),
                                        ),
                                      );
                                    },
                                    searchFieldProps: TextFieldProps(
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                                      ),
                                    ),
                                    constraints: BoxConstraints.tightFor(width: double.infinity),
                                    containerBuilder: (context, popupWidget) {
                                      return Stack(
                                        children: [
                                          popupWidget,
                                          Positioned(
                                            right: 10,
                                            top: 10,
                                            child: IconButton(
                                              icon: Icon(Icons.close),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                  items: (filter, loadProps) =>
                                      _baithakTypes?.map((e) => e.codeForDisplay.toString()).where((name) => name.toLowerCase().contains(filter.toLowerCase() ?? "")).toList() ?? [],
                                  decoratorProps: DropDownDecoratorProps(
                                    decoration: InputDecoration(
                                      labelText: Statics.getLabel('selectbaithakTypeLabel') + " 2",
                                    ),
                                  ),
                                  selectedItem: _baithakTypeValue2 == "" ? null : _baithakTypes?.firstWhere((element) => element.staticID.toString() == _baithakTypeValue2).codeForDisplay,
                                  onChanged: (value) {
                                    print(value);
                                    setState(() {
                                      _baithakTypeValue2 = _baithakTypes!.firstWhere((element) => element.codeForDisplay == value).staticID.toString();
                                      _baithakTypeValue2Name = _baithakTypes!.firstWhere((element) => element.codeForDisplay == value).codeForDisplay.toString();
                                    });
                                  },
                                ),
                              SizedBox(height: 10),
                              if (_baithakTypes != null)
                                DropdownSearch<String>(
                                  popupProps: PopupProps.bottomSheet(
                                    showSearchBox: true,
                                    fit: FlexFit.tight,
                                    itemBuilder: (context, item, isSelected, val) {
                                      return Container(
                                        margin: EdgeInsets.symmetric(horizontal: 8),
                                        decoration: !isSelected
                                            ? null
                                            : BoxDecoration(
                                                border: Border.all(color: Theme.of(context).primaryColor),
                                                borderRadius: BorderRadius.circular(5),
                                                color: Colors.grey[300],
                                              ),
                                        child: ListTile(
                                          title: Text(
                                            item,
                                            style: TextStyle(fontSize: 14),
                                          ),
                                          contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                                          visualDensity: VisualDensity(vertical: -4),
                                        ),
                                      );
                                    },
                                    searchFieldProps: TextFieldProps(
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                                      ),
                                    ),
                                    constraints: BoxConstraints.tightFor(width: double.infinity),
                                    containerBuilder: (context, popupWidget) {
                                      return Stack(
                                        children: [
                                          popupWidget,
                                          Positioned(
                                            right: 10,
                                            top: 10,
                                            child: IconButton(
                                              icon: Icon(Icons.close),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                  items: (filter, loadProps) =>
                                      _baithakTypes?.map((e) => e.codeForDisplay.toString()).where((name) => name.toLowerCase().contains(filter.toLowerCase() ?? "")).toList() ?? [],
                                  decoratorProps: DropDownDecoratorProps(
                                    decoration: InputDecoration(
                                      labelText: Statics.getLabel('selectbaithakTypeLabel') + " 3",
                                    ),
                                  ),
                                  selectedItem: _baithakTypeValue3 == "" ? null : _baithakTypes?.firstWhere((element) => element.staticID.toString() == _baithakTypeValue3).codeForDisplay,
                                  onChanged: (value) {
                                    print(value);
                                    setState(() {
                                      _baithakTypeValue3 = _baithakTypes!.firstWhere((element) => element.codeForDisplay == value).staticID.toString();
                                      _baithakTypeValue3Name = _baithakTypes!.firstWhere((element) => element.codeForDisplay == value).codeForDisplay.toString();
                                    });
                                  },
                                ),
                              SizedBox(height: 15),
                              if (_linkedMahaanagar != null)

// ==============================================  BHOUGOLIK STHAR DROPDOWNS  ==========================================================================================================================================

                                Text(Statics.getLabel('selectBhaugolikSthar'), style: TextStyle(color: Theme.of(context).primaryColor)),
                              DropdownButtonFormField<String>(
                                decoration: InputDecoration(labelText: Statics.getLabel('Mahaanagar')),
                                isExpanded: true,
                                value: _linkedMahaanagarValue == "" ? null : _linkedMahaanagarValue,
                                items: _linkedMahaanagar?.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                                onChanged: MyAppGlobals.isDropdownDisabled('Mahaanagar')
                                    ? null
                                    : (value) {
                                        print("Mahaanagar---   $value");
                                        setState(() {
                                          _linkedMahaanagarValue = value;
                                          _linkedVibhaagValue = null;
                                          populatelinkedVibhaagDropdown(value!);
                                          mahanagarId = value;
                                        });
                                      },
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              if (_linkedVibhaag != null)
                                DropdownButtonFormField<String>(
                                  decoration: InputDecoration(labelText: Statics.getLabel('Vibhaag')),
                                  isExpanded: true,
                                  value: _linkedVibhaagValue == "" ? null : _linkedVibhaagValue,
                                  items: _linkedVibhaag!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                                  onChanged: MyAppGlobals.isDropdownDisabled('Vibhaag')
                                      ? null
                                      : (value) {
                                          print("Vibhaag---   $value");
                                          setState(() {
                                            _linkedVibhaagValue = value;
                                            populatelinkedBhaagDropdown(value!);
                                            vibhagId = value;
                                          });
                                        },
                                ),
                              SizedBox(
                                height: 10,
                              ),
                              if (_linkedBhaag != null)
                                DropdownButtonFormField<String>(
                                  decoration: InputDecoration(labelText: Statics.getLabel('Bhaag')),
                                  isExpanded: true,
                                  value: _linkedBhaagValue == "" ? null : _linkedBhaagValue,
                                  items: _linkedBhaag!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                                  onChanged: MyAppGlobals.isDropdownDisabled('Bhaag')
                                      ? null
                                      : (value) {
                                          print("Bhaag---   $value");
                                          setState(() {
                                            _linkedBhaagValue = value;

                                            populatelinkedNagarDropdown(value, null);
                                          });
                                        },
                                ),
                              SizedBox(
                                height: 10,
                              ),
                              // if (_linkedShahar != null && _linkedShahar!.length > 0)
                              //   DropdownButtonFormField<String>(
                              //     decoration: InputDecoration(labelText: Statics.getLabel('Shahar')),
                              //     isExpanded: true,
                              //     value: _linkedShaharValue == "" ? null : _linkedShaharValue,
                              //     items: _linkedShahar!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                              //     onChanged: MyAppGlobals.isDropdownDisabled('Mahaanagar')
                              //         ? null
                              //         :  (value) {
                              //       print("Shahar---   $value");
                              //       setState(() {
                              //         _linkedShaharValue = value;
                              //         populatelinkedNagarDropdown(null, value);
                              //       });
                              //     },
                              //   ),
                              // if (_linkedShahar != null && _linkedShahar!.length > 0)
                              //   SizedBox(
                              //     height: 10,
                              //   ),
                              if (_linkedNagar != null && _linkedNagar!.length > 0)
                                DropdownButtonFormField<String>(
                                  decoration: InputDecoration(labelText: Statics.getLabel('Nagar')),
                                  isExpanded: true,
                                  value: _linkedNagarValue == "" ? null : _linkedNagarValue,
                                  items: _linkedNagar!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                                  onChanged: MyAppGlobals.isDropdownDisabled('Nagar')
                                      ? null
                                      : (value) {
                                          print("Nagar---   $value");
                                          setState(() {
                                            _linkedNagarValue = value;
                                          });
                                        },
                                ),

// =================================================  Select Tulnatmak Bindu =======================================================================================================================================================================================================================================================================================
                              if (_linkedNagar != null && _linkedNagar!.length > 0)
                                SizedBox(
                                  height: 15,
                                ),
                              Text(Statics.getLabel('selectcomparativevruttapoint'), style: TextStyle(color: Theme.of(context).primaryColor)),
                              DropdownButtonFormField<String>(
                                decoration: InputDecoration(labelText: Statics.getLabel('comparativevruttapoint')),
                                isExpanded: true,
                                value: _tulnatmakvruttapoint == "" ? null : _tulnatmakvruttapoint,
                                items: _tulnatmakvruttapointItems,
                                onChanged: (value) {
                                  print("valuevaluevalue  $value");
                                  setState(() {
                                    _tulnatmakvruttapoint = value ?? "";
                                    _selectedcomparativevruttapoint = (_tulnatmakvruttapointItems.firstWhere((item) => item.value == value).child as Text).data!;
                                    _selectedmahAnyEkunManBasGram = "";
                                    _selectedbhougolikkaryastithisubpoint = "";
                                    _selectedtalukasubpoint = "";

                                    _bhougolikkaryastithisubpoint = "";
                                    _mahAnyEkunManBasGram = "";
                                    _talukasubpoint = "";
                                    _sthansubpoint = "";
                                    _selectedsthansubpoint = "";
                                    _sewavruttasubpoint = "";
                                    _selectedsewavruttasubpoint = "";
                                    _purnasubpoint = "";
                                    _selectedpurnasubpoint = "";
                                    _karyastithisubpoint = "";
                                    _selectedkaryastithisubpoint = "";
                                    _selectedtoliyuktasubpoint = "";
                                    _selectedbaithakkarnaryasubpoint = "";
                                    _selectvayogatsubpoint = "";
                                    _saptahikmilansubpoint = "";
                                    _selectvayogatsubpoint = "";
                                    _selectedsaptahikmilansubpoint = '';
                                    _selectedvayogatsubpoint = '';
                                    _toliyuktasubpoint = "";
                                    _baithakkarnaryasubpoint = "";
                                    _palakyuktasubpoint = "";
                                    _varshikotsavkarnaryasubpoint = "";
                                    if (value == "purna" || value == "karyastiti") {
                                      _sankalpBar = true;
                                    } else {
                                      _sankalpBar = false;
                                    }
                                  });
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty || value == "") {
                                    return (Statics.getLabel('mandatoryInformation'));
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(
                                height: 15,
                              ),
// ================================================= Tulnatmak Bindu ==> bahugolik  =======================================================================================================================================================================================================================================================================================
                              if (_tulnatmakvruttapoint == "bahugolik") Text(Statics.getLabel('selectedBhougolikkaryastithi'), style: TextStyle(color: Theme.of(context).primaryColor)),
                              if (_tulnatmakvruttapoint == "bahugolik")
                                DropdownButtonFormField<String>(
                                  decoration: InputDecoration(labelText: Statics.getLabel('selectedBhougolikkaryastithi')),
                                  isExpanded: true,
                                  value: _bhougolikkaryastithisubpoint == "" ? null : _bhougolikkaryastithisubpoint,
                                  items: _bhougolikkaryastithisubpointItems,
                                  onChanged: (value) {
                                    print("भौगौलिक कार्यस्थिती निवडल तर == > $value");
                                    setState(() {
                                      _bhougolikkaryastithisubpoint = value ?? "";
                                      _selectedbhougolikkaryastithisubpoint = (_bhougolikkaryastithisubpointItems.firstWhere((item) => item.value == value).child as Text).data!;
                                      _selectedmahAnyEkunManBasGram = "";
                                      _selectedtalukasubpoint = "";
                                      _mahAnyEkunManBasGram = "";
                                      _talukasubpoint = "";
                                      _selectedsthansubpoint = "";
                                      _sthansubpoint = "";

                                      _mahAnyEkunManBasGramItems.clear();
                                      _mahAnyEkunManBasGramItems.addAll([
                                        DropdownMenuItem(value: 'sakhayukta', child: Text("${Statics.getLabel('shaakhaaYukta')}")),
                                        DropdownMenuItem(value: 'saptahikmilanyukt', child: Text('साप्ताहिक मिलन युक्त')),
                                        DropdownMenuItem(value: 'mandaliyukt', child: Text('मंडळी युक्त')),
                                        DropdownMenuItem(value: 'kimandosakha', child: Text('किमान दो शाखा')),
                                      ]);
                                      if (value == "graam") {
                                        _mahAnyEkunManBasGramItems.removeWhere((element) => element.value == "kimandosakha");
                                      } else if (value == "madal") {
                                        _mahAnyEkunManBasGramItems.removeWhere((element) => element.value == "kimandosakha");
                                      }
                                    });
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty || value == "" && _tulnatmakvruttapoint == "bahugolik") {
                                      return (Statics.getLabel('mandatoryInformation'));
                                    }
                                    return null;
                                  },
                                ),
                              if (_tulnatmakvruttapoint == "bahugolik")
                                SizedBox(
                                  height: 15,
                                ),
// =================================================   Tulnatmak Bindu ==> bahugolik => mahanagar || anyanagar || ekunnagar || madal || basti || graam  =======================================================================================================================================================================================================================================================================================
                              if (_tulnatmakvruttapoint == "bahugolik" && _bhougolikkaryastithisubpoint == 'mahanagar' ||
                                  _bhougolikkaryastithisubpoint == 'anyanagar' ||
                                  _bhougolikkaryastithisubpoint == 'ekunnagar' ||
                                  _bhougolikkaryastithisubpoint == 'madal' ||
                                  _bhougolikkaryastithisubpoint == 'basti' ||
                                  _bhougolikkaryastithisubpoint == 'graam')
                                Text(Statics.getLabel('Type'), style: TextStyle(color: Theme.of(context).primaryColor)),
                              if (_tulnatmakvruttapoint == "bahugolik" && _bhougolikkaryastithisubpoint == 'mahanagar' ||
                                  _bhougolikkaryastithisubpoint == 'anyanagar' ||
                                  _bhougolikkaryastithisubpoint == 'ekunnagar' ||
                                  _bhougolikkaryastithisubpoint == 'madal' ||
                                  _bhougolikkaryastithisubpoint == 'basti' ||
                                  _bhougolikkaryastithisubpoint == 'graam')
                                DropdownButtonFormField<String>(
                                  decoration: InputDecoration(labelText: Statics.getLabel('Type')),
                                  isExpanded: true,
                                  value: _mahAnyEkunManBasGram == "" ? null : _mahAnyEkunManBasGram,
                                  items: _mahAnyEkunManBasGramItems,
                                  onChanged: (value) {
                                    setState(() {
                                      _mahAnyEkunManBasGram = value ?? "";
                                      _selectedmahAnyEkunManBasGram = (_mahAnyEkunManBasGramItems.firstWhere((item) => item.value == value).child as Text).data!;
                                      _talukasubpoint = "";
                                      _selectedtalukasubpoint = "";
                                      _selectedsthansubpoint = "";
                                    });
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty || value == "") {
                                      return (Statics.getLabel('mandatoryInformation'));
                                    }
                                    return null;
                                  },
                                ),
                              if (_tulnatmakvruttapoint == "bahugolik" && _bhougolikkaryastithisubpoint == 'mahanagar' ||
                                  _bhougolikkaryastithisubpoint == 'anyanagar' ||
                                  _bhougolikkaryastithisubpoint == 'ekunnagar' ||
                                  _bhougolikkaryastithisubpoint == 'madal' ||
                                  _bhougolikkaryastithisubpoint == 'basti' ||
                                  _bhougolikkaryastithisubpoint == 'graam')
                                SizedBox(
                                  height: 15,
                                ),

// =================================================  Tulnatmak Bindu ==> bahugolik => taluka =======================================================================================================================================================================================================================================================================================

                              if (_bhougolikkaryastithisubpoint == 'taluka' && _tulnatmakvruttapoint == "bahugolik")
                                Text(Statics.getLabel('Type'), style: TextStyle(color: Theme.of(context).primaryColor)),
                              if (_bhougolikkaryastithisubpoint == 'taluka' && _tulnatmakvruttapoint == "bahugolik")
                                DropdownButtonFormField<String>(
                                  decoration: InputDecoration(labelText: Statics.getLabel('Type')),
                                  isExpanded: true,
                                  value: _talukasubpoint == "" ? null : _talukasubpoint,
                                  items: _talukasubpointItems,
                                  onChanged: (value) {
                                    setState(() {
                                      _talukasubpoint = value;
                                      _selectedtalukasubpoint = (_talukasubpointItems.firstWhere((item) => item.value == value).child as Text).data!;
                                      _selectedmahAnyEkunManBasGram = "";
                                      _mahAnyEkunManBasGram = "";
                                      _selectedsthansubpoint = "";
                                    });
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty || value == "") {
                                      return (Statics.getLabel('mandatoryInformation'));
                                    }
                                    return null;
                                  },
                                ),
                              if (_bhougolikkaryastithisubpoint == 'taluka' && _tulnatmakvruttapoint == "bahugolik")
                                SizedBox(
                                  height: 15,
                                ),
// ================================================= Tulnatmak Bindu ==> bahugolik => sthan  =======================================================================================================================================================================================================================================================================================

                              if (_bhougolikkaryastithisubpoint == 'sthan' && _tulnatmakvruttapoint == "bahugolik")
                                Text(Statics.getLabel('Type'), style: TextStyle(color: Theme.of(context).primaryColor)),
                              if (_bhougolikkaryastithisubpoint == 'sthan' && _tulnatmakvruttapoint == "bahugolik")
                                DropdownButtonFormField<String>(
                                  decoration: InputDecoration(labelText: Statics.getLabel('Type')),
                                  isExpanded: true,
                                  value: _sthansubpoint == "" ? null : _sthansubpoint,
                                  items: _sthansubpointItems,
                                  onChanged: (value) {
                                    setState(() {
                                      _sthansubpoint = value;
                                      _selectedsthansubpoint = (_sthansubpointItems.firstWhere((item) => item.value == value).child as Text).data!;
                                    });
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty || value == "") {
                                      return (Statics.getLabel('mandatoryInformation'));
                                    }
                                    return null;
                                  },
                                ),
                              if (_bhougolikkaryastithisubpoint == 'sthan' && _tulnatmakvruttapoint == "bahugolik")
                                SizedBox(
                                  height: 15,
                                ),
// ================================================= Tulnatmak Bindu ==> bahugolik => sevavrutta  =======================================================================================================================================================================================================================================================================================

                              if (_tulnatmakvruttapoint == "sevavrutta") Text(Statics.getLabel('Type'), style: TextStyle(color: Theme.of(context).primaryColor)),
                              if (_tulnatmakvruttapoint == "sevavrutta")
                                DropdownButtonFormField<String>(
                                  decoration: InputDecoration(labelText: Statics.getLabel('Type')),
                                  isExpanded: true,
                                  value: _sewavruttasubpoint == "" ? null : _sewavruttasubpoint,
                                  items: _sewavruttasubpointItems,
                                  onChanged: (value) {
                                    setState(() {
                                      _sewavruttasubpoint = value;
                                      _selectedsewavruttasubpoint = (_sewavruttasubpointItems.firstWhere((item) => item.value == value).child as Text).data!;
                                    });
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty || value == "") {
                                      return (Statics.getLabel('mandatoryInformation'));
                                    }
                                    return null;
                                  },
                                ),
                              if (_tulnatmakvruttapoint == "sevavrutta")
                                SizedBox(
                                  height: 15,
                                ),

// ================================================= Tulnatmak Bindu ==> bahugolik => purna  =======================================================================================================================================================================================================================================================================================

                              if (_tulnatmakvruttapoint == "purna") Text(Statics.getLabel('Type'), style: TextStyle(color: Theme.of(context).primaryColor)),
                              if (_tulnatmakvruttapoint == "purna")
                                DropdownButtonFormField<String>(
                                  decoration: InputDecoration(labelText: Statics.getLabel('Type')),
                                  isExpanded: true,
                                  value: _purnasubpoint == "" ? null : _purnasubpoint,
                                  items: _purnasubpointItems,
                                  onChanged: (value) {
                                    setState(() {
                                      _purnasubpoint = value;
                                      _selectedpurnasubpoint = (_purnasubpointItems.firstWhere((item) => item.value == value).child as Text).data!;
                                    });
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty || value == "") {
                                      return (Statics.getLabel('mandatoryInformation'));
                                    }
                                    return null;
                                  },
                                ),
                              if (_tulnatmakvruttapoint == "purna")
                                SizedBox(
                                  height: 15,
                                ),
// ================================================= Tulnatmak Bindu ==> bahugolik => karyastiti  =======================================================================================================================================================================================================================================================================================

                              if (_tulnatmakvruttapoint == "karyastiti") Text(Statics.getLabel('Type'), style: TextStyle(color: Theme.of(context).primaryColor)),
                              if (_tulnatmakvruttapoint == "karyastiti")
                                DropdownButtonFormField<String>(
                                  decoration: InputDecoration(labelText: Statics.getLabel('Type')),
                                  isExpanded: true,
                                  value: _karyastithisubpoint == "" ? null : _karyastithisubpoint,
                                  items: _karyastithisubpointItems,
                                  onChanged: (value) {
                                    setState(() {
                                      _karyastithisubpoint = value;
                                      _selectedkaryastithisubpoint = (_karyastithisubpointItems.firstWhere((item) => item.value == value).child as Text).data!;
                                      _selectedsaptahikmilansubpoint = '';
                                      _selectedvayogatsubpoint = '';
                                      _saptahikmilansubpoint = "";
                                      _selectvayogatsubpoint = "";
                                    });
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty || value == "") {
                                      return (Statics.getLabel('mandatoryInformation'));
                                    }
                                    return null;
                                  },
                                ),
                              if (_tulnatmakvruttapoint == "karyastiti")
                                SizedBox(
                                  height: 15,
                                ),

// ================================================= Tulnatmak Bindu ==> bahugolik => karyastiti || toliyukta || baithak karnarya => Saptahik Milan  =======================================================================================================================================================================================================================================================================================

                              if (_tulnatmakvruttapoint == "toliyukt") Text(Statics.getLabel('Type'), style: TextStyle(color: Theme.of(context).primaryColor)),
                              if (_tulnatmakvruttapoint == "toliyukt")
                                DropdownButtonFormField<String>(
                                  decoration: InputDecoration(labelText: Statics.getLabel('Type')),
                                  isExpanded: true,
                                  value: _toliyuktasubpoint == "" ? null : _toliyuktasubpoint,
                                  items: _toliyuktasubpointItems,
                                  onChanged: (value) {
                                    setState(() {
                                      _toliyuktasubpoint = value;
                                      _selectedtoliyuktasubpoint = (_toliyuktasubpointItems.firstWhere((item) => item.value == value).child as Text).data!;
                                      _selectedsaptahikmilansubpoint = '';
                                      _selectedvayogatsubpoint = '';
                                      _saptahikmilansubpoint = "";
                                      _selectvayogatsubpoint = "";
                                    });
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty || value == "") {
                                      return (Statics.getLabel('mandatoryInformation'));
                                    }
                                    return null;
                                  },
                                ),
                              if (_tulnatmakvruttapoint == "toliyukt")
                                SizedBox(
                                  height: 15,
                                ),

// ================================================= Tulnatmak Bindu ==> bahugolik => karyastiti || toliyukta || baithak karnarya => Saptahik Milan  =======================================================================================================================================================================================================================================================================================

                              if (_tulnatmakvruttapoint == "baithakkarnarya") Text(Statics.getLabel('Type'), style: TextStyle(color: Theme.of(context).primaryColor)),
                              if (_tulnatmakvruttapoint == "baithakkarnarya")
                                DropdownButtonFormField<String>(
                                  decoration: InputDecoration(labelText: Statics.getLabel('Type')),
                                  isExpanded: true,
                                  value: _baithakkarnaryasubpoint == "" ? null : _baithakkarnaryasubpoint,
                                  items: _baithakkarnaryasubpointItems,
                                  onChanged: (value) {
                                    setState(() {
                                      _baithakkarnaryasubpoint = value;
                                      _selectedbaithakkarnaryasubpoint = (_baithakkarnaryasubpointItems.firstWhere((item) => item.value == value).child as Text).data!;
                                      _selectedsaptahikmilansubpoint = '';
                                      _selectedvayogatsubpoint = '';
                                      _saptahikmilansubpoint = "";
                                      _selectvayogatsubpoint = "";
                                    });
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty || value == "") {
                                      return (Statics.getLabel('mandatoryInformation'));
                                    }
                                    return null;
                                  },
                                ),
                              if (_tulnatmakvruttapoint == "baithakkarnarya")
                                SizedBox(
                                  height: 15,
                                ),
// ================================================= Tulnatmak Bindu ==> bahugolik => karyastiti || toliyukta || palakyukta => Saptahik Milan  =======================================================================================================================================================================================================================================================================================

                              if (_tulnatmakvruttapoint == "palakyukta") Text(Statics.getLabel('Type'), style: TextStyle(color: Theme.of(context).primaryColor)),
                              if (_tulnatmakvruttapoint == "palakyukta")
                                DropdownButtonFormField<String>(
                                  decoration: InputDecoration(labelText: Statics.getLabel('Type')),
                                  isExpanded: true,
                                  value: _palakyuktasubpoint == "" ? null : _palakyuktasubpoint,
                                  items: _palakyuktasubpointItems,
                                  onChanged: (value) {
                                    setState(() {
                                      _palakyuktasubpoint = value;
                                      _selectedbaithakkarnaryasubpoint = (_palakyuktasubpointItems.firstWhere((item) => item.value == value).child as Text).data!;
                                      _selectedsaptahikmilansubpoint = '';
                                      _selectedvayogatsubpoint = '';
                                      _saptahikmilansubpoint = "";
                                      _selectvayogatsubpoint = "";
                                    });
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty || value == "") {
                                      return (Statics.getLabel('mandatoryInformation'));
                                    }
                                    return null;
                                  },
                                ),
                              if (_tulnatmakvruttapoint == "palakyukta")
                                SizedBox(
                                  height: 15,
                                ),
// ================================================= Tulnatmak Bindu ==> bahugolik => karyastiti || toliyukta || varshikotsav karnarya => Saptahik Milan  =======================================================================================================================================================================================================================================================================================
                              if (_tulnatmakvruttapoint == "varshikotsavkarnarya") Text(Statics.getLabel('Type'), style: TextStyle(color: Theme.of(context).primaryColor)),
                              if (_tulnatmakvruttapoint == "varshikotsavkarnarya")
                                DropdownButtonFormField<String>(
                                  decoration: InputDecoration(labelText: Statics.getLabel('Type')),
                                  isExpanded: true,
                                  value: _varshikotsavkarnaryasubpoint == "" ? null : _varshikotsavkarnaryasubpoint,
                                  items: _varshikotsavkarnaryasubpointItems,
                                  onChanged: (value) {
                                    setState(() {
                                      _varshikotsavkarnaryasubpoint = value;
                                      _selectedbaithakkarnaryasubpoint = (_varshikotsavkarnaryasubpointItems.firstWhere((item) => item.value == value).child as Text).data!;
                                      _selectedsaptahikmilansubpoint = '';
                                      _selectedvayogatsubpoint = '';
                                      _saptahikmilansubpoint = "";
                                      _selectvayogatsubpoint = "";
                                    });
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty || value == "") {
                                      return (Statics.getLabel('mandatoryInformation'));
                                    }
                                    return null;
                                  },
                                ),
                              if (_tulnatmakvruttapoint == "varshikotsavkarnarya")
                                SizedBox(
                                  height: 15,
                                ),
// ================================================= Tulnatmak Bindu ==> bahugolik => karyastiti || toliyukta || baithak karnarya => Saptahik Milan  =======================================================================================================================================================================================================================================================================================

                              // if(_karyastithisubpoint == "saptahikmilan" || _toliyuktasubpoint == "saptahikmilan"|| _baithakkarnaryasubpoint == "saptahikmilan")
                              //   Text(Statics.getLabel('Type')
                              //       ,style: TextStyle(color:Theme.of(context).primaryColor )),
                              // if(_karyastithisubpoint == "saptahikmilan" || _toliyuktasubpoint == "saptahikmilan"|| _baithakkarnaryasubpoint == "saptahikmilan")
                              //   DropdownButtonFormField<String>(
                              //     decoration: InputDecoration(labelText: Statics.getLabel('Type')),
                              //     isExpanded: true,
                              //     value: _saptahikmilansubpoint == "" ? null : _saptahikmilansubpoint,
                              //     items: _saptahikmilansubpointItems,
                              //     onChanged: (value) {
                              //       setState(() {
                              //         _saptahikmilansubpoint = value;
                              //         _selectedsaptahikmilansubpoint =(_saptahikmilansubpointItems.firstWhere((item) => item.value == value).child as Text).data!;
                              //
                              //       });
                              //     },
                              //     validator: (value) {
                              //       if (value == null || value.isEmpty|| value == "" ) {
                              //         return (Statics.getLabel('mandatoryInformation'));
                              //       }
                              //       return null;
                              //     },
                              //   ),
                              // if(_karyastithisubpoint == "saptahikmilan" || _toliyuktasubpoint == "saptahikmilan"|| _baithakkarnaryasubpoint == "saptahikmilan")
                              //   SizedBox(height: 15,),
                              if (_karyastithisubpoint == "saptahikmilan" || _toliyuktasubpoint == "saptahikmilan")
                                Text(Statics.getLabel('Type'), style: TextStyle(color: Theme.of(context).primaryColor)),

                              if (_karyastithisubpoint == "saptahikmilan" || _toliyuktasubpoint == "saptahikmilan")
                                DropdownButtonFormField<String>(
                                  decoration: InputDecoration(labelText: Statics.getLabel('Type')),
                                  isExpanded: true,
                                  value: _saptahikmilansubpoint == "" ? null : _saptahikmilansubpoint,
                                  items: _saptahikmilansubpointItems,
                                  onChanged: (value) {
                                    setState(() {
                                      _saptahikmilansubpoint = value;
                                      _selectedsaptahikmilansubpoint = (_saptahikmilansubpointItems.firstWhere((item) => item.value == value).child as Text).data!;
                                    });
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty || value == "") {
                                      return Statics.getLabel('mandatoryInformation');
                                    }
                                    return null;
                                  },
                                ),
                              if (_karyastithisubpoint == "saptahikmilan" || _toliyuktasubpoint == "saptahikmilan")
                                SizedBox(
                                  height: 15,
                                ),
// ============= Tulnatmak Bindu ==> bahugolik => karyastiti || toliyukta || baithak karnarya =>  vayogat =======================================================================================================================================================================================================================================================================================
//
//
//                             // if(_tulnatmakvruttapoint == "karyastiti" ||_tulnatmakvruttapoint == "toliyukt"||_tulnatmakvruttapoint == "baithakkarnarya"  && _karyastithisubpoint != "masikmilan"  ||  _karyastithisubpoint != "sanghmandali")
//                             if(_tulnatmakvruttapoint == "toliyukt"||_tulnatmakvruttapoint == "baithakkarnarya")
//                             Text( Statics.getLabel('Vayogat')
//                                   ,style: TextStyle(color:Theme.of(context).primaryColor )),
//                             // if(_tulnatmakvruttapoint == "karyastiti" ||_tulnatmakvruttapoint == "toliyukt"||_tulnatmakvruttapoint == "baithakkarnarya"  && _karyastithisubpoint != "masikmilan"  ||  _karyastithisubpoint != "sanghmandali")
//                             if(_tulnatmakvruttapoint == "toliyukt"||_tulnatmakvruttapoint == "baithakkarnarya")
//                               DropdownButtonFormField<String>(
//                                 decoration: InputDecoration(labelText: Statics.getLabel('Vayogat')),
//                                 isExpanded: true,
//                                 value: _selectvayogatsubpoint == "" ? null : _selectvayogatsubpoint,
//                                 items: _selectvayogatsubpointItems,
//                                 onChanged: (value) {
//                                   print(value);
//                                   setState(() {
//                                     _selectvayogatsubpoint = value;
//                                     _selectedvayogatsubpoint =(_selectvayogatsubpointItems.firstWhere((item) => item.value == value).child as Text).data!;
//                                   });
//                                 },
//                                 validator: (value) {
//                                   if (value == null || value.isEmpty|| value == "" ) {
//                                     return (Statics.getLabel('mandatoryInformation'));
//                                   }
//                                   return null;
//                                 },
//                               ),
//                             // if(_tulnatmakvruttapoint == "karyastiti" ||_tulnatmakvruttapoint == "toliyukt"||_tulnatmakvruttapoint == "baithakkarnarya"  && _karyastithisubpoint != "masikmilan"  ||  _karyastithisubpoint != "sanghmandali")
//                             if(_tulnatmakvruttapoint == "toliyukt"||_tulnatmakvruttapoint == "baithakkarnarya")
//                               SizedBox(height: 15,),
//
// // ============= Tulnatmak Bindu ==> bahugolik => karyastiti => sangha mandali / masik milan =>  vayogat =======================================================================================================================================================================================================================================================================================
//
//                             if(_tulnatmakvruttapoint == "karyastiti" && _karyastithisubpoint == "masikmilan"  ||  _karyastithisubpoint == "sanghmandali" )
//                               Text( Statics.getLabel('Vayogat')
//                                   ,style: TextStyle(color:Theme.of(context).primaryColor )),
//                             if(_tulnatmakvruttapoint == "karyastiti" && _karyastithisubpoint == "masikmilan"  ||  _karyastithisubpoint == "sanghmandali" )
//                               DropdownButtonFormField<String>(
//                                 decoration: InputDecoration(labelText: Statics.getLabel('Vayogat')),
//                                 isExpanded: true,
//                                 value: _vayogatSanghamandaliSaptahikMilan == "" ? null : _vayogatSanghamandaliSaptahikMilan,
//                                 items: _vayogatSanghamandaliSaptahikMilanItems,
//                                 onChanged: (value) {
//                                   print(value);
//                                   setState(() {
//                                     _vayogatSanghamandaliSaptahikMilan = value;
//                                     // _vayogatSanghamandaliSaptahikMilan =(_vayogatSanghamandaliSaptahikMilanItems.firstWhere((item) => item.value == value).child as Text).data!;
//
//                                   });
//                                 },
//                                 validator: (value) {
//                                   if (value == null || value.isEmpty|| value == "" ) {
//                                     return (Statics.getLabel('mandatoryInformation'));
//                                   }
//                                   return null;
//                                 },
//                               ),
//                             if(_tulnatmakvruttapoint == "karyastiti" && _karyastithisubpoint == "masikmilan"  ||  _karyastithisubpoint == "sanghmandali" )
//                               SizedBox(height: 15,),
//

                              if (_tulnatmakvruttapoint == "karyastiti" ||
                                  _tulnatmakvruttapoint == "toliyukt" ||
                                  _tulnatmakvruttapoint == "baithakkarnarya" ||
                                  _tulnatmakvruttapoint == "palakyukta" ||
                                  _tulnatmakvruttapoint == "varshikotsavkarnarya")
                                Text(
                                  Statics.getLabel('Vayogat'),
                                  style: TextStyle(color: Theme.of(context).primaryColor),
                                ),
                              // if(_tulnatmakvruttapoint == "karyastiti" ||_tulnatmakvruttapoint == "toliyukt"||_tulnatmakvruttapoint == "baithakkarnarya")
                              if (_tulnatmakvruttapoint == "karyastiti" ||
                                  _tulnatmakvruttapoint == "toliyukt" ||
                                  _tulnatmakvruttapoint == "baithakkarnarya" ||
                                  _tulnatmakvruttapoint == "palakyukta" ||
                                  _tulnatmakvruttapoint == "varshikotsavkarnarya")
                                DropdownButtonFormField<String>(
                                  decoration: InputDecoration(labelText: Statics.getLabel('Vayogat')),
                                  isExpanded: true,
                                  value: _selectvayogatsubpoint == "" ? null : _selectvayogatsubpoint,
                                  items: (_tulnatmakvruttapoint == "karyastiti" && (_karyastithisubpoint == "masikmilan" || _karyastithisubpoint == "sanghmandali")) ? _vayogatItems1 : _vayogatItems2,
                                  onChanged: (value) {
                                    print(value);
                                    setState(() {
                                      _selectvayogatsubpoint = value;
                                      _selectedvayogatsubpoint = (_tulnatmakvruttapoint == "karyastiti" && (_karyastithisubpoint == "masikmilan" || _karyastithisubpoint == "sanghmandali"))
                                          ? (_vayogatItems1.firstWhere((item) => item.value == value).child as Text).data!
                                          : (_vayogatItems2.firstWhere((item) => item.value == value).child as Text).data!;
                                    });
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty || value == "") {
                                      return Statics.getLabel('mandatoryInformation');
                                    }
                                    return null;
                                  },
                                ),
                              // if(_tulnatmakvruttapoint == "karyastiti" ||_tulnatmakvruttapoint == "toliyukt"||_tulnatmakvruttapoint == "baithakkarnarya")
                              if (_tulnatmakvruttapoint == "karyastiti" ||
                                  _tulnatmakvruttapoint == "toliyukt" ||
                                  _tulnatmakvruttapoint == "baithakkarnarya" ||
                                  _tulnatmakvruttapoint == "palakyukta" ||
                                  _tulnatmakvruttapoint == "varshikotsavkarnarya")
                                SizedBox(height: 15),
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
                                if (_completeFormKey.currentState?.validate() ?? false) {
                                  _search();

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('प्रक्रिया करत आहे')),
                                  );
                                }
                              },
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
                                    mahanagarId = _linkedMahaanagarValue =
                                        _linkedVibhaagValue = _linkedBhaagValue = _linkedShaharValue = _linkedNagarValue = _baithakType1 = _baithakType2 = _baithakType3 = null;
                                    _linkedMahaanagar = _linkedVibhaag = _linkedBhaag = _linkedShahar = _linkedNagar = null;
                                    _baithakTypeValue1 = _baithakTypeValue2 = _baithakTypeValue3 = _selectedNagarAndBaithak1 = _selectedNagarAndBaithak2 = _selectedNagarAndBaithak3 = '';
                                    _ekatritVrutta = null;
                                    _isSearching = false;
                                    _selectedBaithak1 = '';
                                    _selectedBaithak2 = '';
                                    _selectedBaithak3 = '';
                                    _tulnatmakvruttapoint = '';
                                    _bhougolikkaryastithisubpoint = '';
                                    _mahAnyEkunManBasGram = '';
                                    _selectedmahAnyEkunManBasGram = "";
                                    _talukasubpoint = '';
                                    _selectedtalukasubpoint;
                                    _sthansubpoint = '';
                                    _selectedsthansubpoint = "";
                                    _sewavruttasubpoint = '';
                                    _selectedsewavruttasubpoint = '';
                                    _purnasubpoint = '';
                                    _selectedpurnasubpoint = '';
                                    _karyastithisubpoint = '';
                                    _selectvayogatsubpoint = '';
                                    ;
                                    _baithakkarnaryasubpoint = '';
                                    _toliyuktasubpoint = '';
                                    _saptahikmilansubpoint = '';
                                    _karyastithisubpoint = '';
                                    _selectedkaryastithisubpoint = '';
                                    _selectedtoliyuktasubpoint = '';
                                    _selectedbaithakkarnaryasubpoint = '';
                                    _selectvayogatsubpoint = '';
                                    _selectedsaptahikmilansubpoint = '';
                                    _selectedvayogatsubpoint = '';
                                    _varshikotsavkarnaryasubpoint = '';
                                    _varshikotsavkarnaryasubpoint = '';
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
                  RepaintBoundary(
                    key: _formKey,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Text(_selectedNagarAndBaithak, style: TextStyle(fontSize: 16)),
                        SizedBox(
                          height: 20,
                        ),
                        if (tulnatmakBaithakResponse != null)
                          Wrap(
                            alignment: WrapAlignment.center,
                            spacing: 8.0,
                            children: [
                              Text(
                                _selectedcomparativevruttapoint,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              if (_selectedbhougolikkaryastithisubpoint != "")
                                Text(
                                  "| ${_selectedbhougolikkaryastithisubpoint}",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              if (_selectedmahAnyEkunManBasGram != "")
                                Text(
                                  "| ${_selectedmahAnyEkunManBasGram}",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              if (_selectedtalukasubpoint != "")
                                Text(
                                  "| ${_selectedtalukasubpoint}",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              if (_selectedsthansubpoint != "")
                                Text(
                                  "| ${_selectedsthansubpoint}",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              if (_selectedsewavruttasubpoint != "")
                                Text(
                                  "| ${_selectedsewavruttasubpoint}",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              if (_selectedpurnasubpoint != "")
                                Text(
                                  "| ${_selectedpurnasubpoint}",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              if (_selectedkaryastithisubpoint != "")
                                Text(
                                  "| ${_selectedkaryastithisubpoint}",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              if (_selectedtoliyuktasubpoint != "")
                                Text(
                                  "| ${_selectedtoliyuktasubpoint}",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              if (_selectedbaithakkarnaryasubpoint != "")
                                Text(
                                  "| ${_selectedbaithakkarnaryasubpoint}",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              if (_selectedsaptahikmilansubpoint != "")
                                Text(
                                  "- ${_selectedsaptahikmilansubpoint}",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              if (_selectedvayogatsubpoint != "")
                                Text(
                                  "| ${_selectedvayogatsubpoint}",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                            ],
                          ),
                        SizedBox(
                          height: 20,
                        ),
                        if (tulnatmakBaithakResponse != null)
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "बैठक क्रमांक १  :- ",
                                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                              ),
                              Expanded(
                                child: Text(
                                  "${_baithakTypeValue1Name}  ( ${tulnatmakBaithakResponse?.baithak1a == -1 ? 0 : tulnatmakBaithakResponse?.baithak1a} )",
                                  style: TextStyle(color: Colors.black),
                                  maxLines: 2,
                                ),
                              ),
                            ],
                          ),
                        if (tulnatmakBaithakResponse != null)
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "बैठक क्रमांक २  :- ",
                                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                              ),
                              Expanded(
                                child: Text(
                                  "${_baithakTypeValue2Name}  ( ${tulnatmakBaithakResponse?.baithak2a == -1 ? 0 : tulnatmakBaithakResponse?.baithak2a} )",
                                  style: TextStyle(color: Colors.black),
                                  maxLines: 2,
                                ),
                              ),
                            ],
                          ),
                        if (tulnatmakBaithakResponse != null)
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "बैठक क्रमांक ३  :- ",
                                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                              ),
                              Expanded(
                                child: Text(
                                  "${_baithakTypeValue3Name}  ( ${tulnatmakBaithakResponse?.baithak3a == -1 ? 0 : tulnatmakBaithakResponse?.baithak3a} )",
                                  style: TextStyle(color: Colors.black),
                                  maxLines: 2,
                                ),
                              ),
                            ],
                          ),
                        if (tulnatmakBaithakResponse != null)
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "संकल्प                  :- ",
                                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                              ),
                              Expanded(
                                child: Text(
                                  "${tulnatmakBaithakResponse?.baithak3b == -1 ? "लागू नाही" : tulnatmakBaithakResponse?.baithak3b}",
                                  style: TextStyle(color: Colors.black),
                                  maxLines: 2,
                                ),
                              ),
                            ],
                          ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                Text(
                                  "वर्तमान",
                                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                                ),
                                Row(
                                  children: [
                                    Container(width: 20, height: 20, color: Colors.deepOrange),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Container(width: 20, height: 20, color: Colors.blue),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Container(width: 20, height: 20, color: Colors.lime),
                                  ],
                                )
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  "संकल्प",
                                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                                ),
                                Row(
                                  children: [
                                    Container(width: 20, height: 20, color: Colors.purpleAccent),
                                    // SizedBox(width: 10,),
                                    // Container(width: 20,height: 20,color: Colors.indigoAccent),
                                    // SizedBox(width: 10,),
                                    // Container(width: 20,height: 20,color: Colors.amberAccent),
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        if (_isSearching) CircularProgressIndicator(),
                        if (_isSearching == false)
                          tulnatmakBaithakResponse?.baithak1a != -1 && tulnatmakBaithakResponse?.baithak2a != -1 && tulnatmakBaithakResponse?.baithak3a != -1 && tulnatmakBaithakResponse != null
                              ? Row(
                                  children: [
                                    Flexible(
                                      flex: 1,
                                      child: Transform.rotate(
                                        angle: -3.14159 / 2,
                                        child: Container(
                                          color: Colors.white,
                                          child: FittedBox(
                                            fit: BoxFit.none,
                                            child: Wrap(
                                              alignment: WrapAlignment.center,
                                              spacing: 8.0,
                                              children: [
                                                Text(
                                                  _selectedcomparativevruttapoint,
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                if (_selectedbhougolikkaryastithisubpoint != "")
                                                  Text(
                                                    "| ${_selectedbhougolikkaryastithisubpoint}",
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                if (_selectedmahAnyEkunManBasGram != "")
                                                  Text(
                                                    "| ${_selectedmahAnyEkunManBasGram}",
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                if (_selectedtalukasubpoint != "")
                                                  Text(
                                                    "| ${_selectedtalukasubpoint}",
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                if (_selectedsthansubpoint != "")
                                                  Text(
                                                    "| ${_selectedsthansubpoint}",
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                if (_selectedsewavruttasubpoint != "")
                                                  Text(
                                                    "| ${_selectedsewavruttasubpoint}",
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                if (_selectedpurnasubpoint != "")
                                                  Text(
                                                    "| ${_selectedpurnasubpoint}",
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                if (_selectedkaryastithisubpoint != "")
                                                  Text(
                                                    "| ${_selectedkaryastithisubpoint}",
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                if (_selectedtoliyuktasubpoint != "")
                                                  Text(
                                                    "| ${_selectedtoliyuktasubpoint}",
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                if (_selectedbaithakkarnaryasubpoint != "")
                                                  Text(
                                                    "| ${_selectedbaithakkarnaryasubpoint}",
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                if (_selectedsaptahikmilansubpoint != "")
                                                  Text(
                                                    "- ${_selectedsaptahikmilansubpoint}",
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                if (_selectedvayogatsubpoint != "")
                                                  Text(
                                                    "| ${_selectedvayogatsubpoint}",
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                      flex: 9,
                                      child: Container(
                                        decoration: BoxDecoration(border: Border.all(color: Colors.black)),
                                        height: MediaQuery.of(context).size.height * 0.5,
                                        width: MediaQuery.of(context).size.width * 1.8,
                                        child: BarChartSample(
                                          tulnatmakBaithakResponse: tulnatmakBaithakResponse!,
                                          sankapBar: _sankalpBar,
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : Text(Statics.getLabel('noDataFoundTryAnotherSearch')),
                        SizedBox(
                          height: 30,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}

class BarChartSample extends StatelessWidget {
  final TulnatmakBaithakResponse tulnatmakBaithakResponse;
  bool sankapBar;

  BarChartSample({required this.tulnatmakBaithakResponse, required this.sankapBar});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<int>>(
      future: getCounts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          final data = snapshot.data;
          return Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 0, top: 50),
                child: BarChart(
                  BarChartData(
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      getDrawingHorizontalLine: (value) => FlLine(
                        color: Colors.black12,
                        strokeWidth: 1,
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    alignment: BarChartAlignment.spaceAround,
                    barGroups: _createBarGroups(data!, sankapBar),
                    // axisTitleData: FlAxisTitleData(),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                      )),
                      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: tulnatmakBaithakResponse?.baithak3b == -1
                            ? (value, meta) {
                                print(value);

                                switch (value.toInt()) {
                                  case 0:
                                    return Text('बैठक 1');
                                  case 1:
                                    return Text('बैठक 2');
                                  case 2:
                                    return Text('बैठक 3');
                                  default:
                                    return Text('');
                                }
                              }
                            : (value, meta) {
                                print(value);

                                switch (value.toInt()) {
                                  case 0:
                                    return Text('बैठक 1');
                                  case 1:
                                    return Text('बैठक 2');
                                  case 2:
                                    return Text('बैठक 3');
                                  case 5:
                                    return Text('संकल्प');
                                  default:
                                    return Text('');
                                }
                              },
                      )),
                    ),
                  ),
                ),
              ),
            ],
          );
        }
      },
    );
  }

  Future<List<int>> getCounts() async {
    return [
      _sanitize(tulnatmakBaithakResponse.baithak1a),
      _sanitize(tulnatmakBaithakResponse.baithak2a),
      _sanitize(tulnatmakBaithakResponse.baithak3a),
      _sanitize(tulnatmakBaithakResponse.baithak1b),
      _sanitize(tulnatmakBaithakResponse.baithak2b),
      _sanitize(tulnatmakBaithakResponse.baithak3b),
    ];
  }

  int _sanitize(int? value) {
    if (value == null || value.isNaN || value.isInfinite) {
      return 0;
    }
    return value;
  }

  List<BarChartGroupData> _createBarGroups(List<int> counts, bool sankalpBarStatus) {
    return [
      BarChartGroupData(
        x: 0,
        barRods: [
          BarChartRodData(
            toY: counts[0].isNaN || counts[0].isInfinite ? 0.0 : counts[0].toDouble(),
            color: Colors.deepOrange,
            borderRadius: BorderRadius.zero,
            width: 30,
          ),
        ],
      ),
      // if(sankalpBarStatus == true)
      // BarChartGroupData(
      //   x: 3,
      //   barRods: [
      //     BarChartRodData(
      //       y: counts[3].isNaN || counts[3].isInfinite ? 0.0 : counts[3].toDouble(),
      //       colors: [Colors.red],
      //       borderRadius: BorderRadius.zero,
      //       width: 30,
      //     ),
      //   ],
      // ),
      BarChartGroupData(
        x: 1,
        barRods: [
          BarChartRodData(
            toY: counts[1].isNaN || counts[1].isInfinite ? 0.0 : counts[1].toDouble(),
            color: Colors.blue,
            borderRadius: BorderRadius.zero,
            width: 30,
          ),
        ],
      ),
      // if(sankalpBarStatus == true)
      // BarChartGroupData(
      //   x: 4,
      //   barRods: [
      //     BarChartRodData(
      //       y: counts[4].isNaN || counts[4].isInfinite ? 0.0 : counts[4].toDouble(),
      //       colors: [Colors.indigoAccent],
      //       borderRadius: BorderRadius.zero,
      //       width: 30,
      //     ),
      //   ],
      // ),
      BarChartGroupData(
        x: 2,
        barRods: [
          BarChartRodData(
            toY: counts[2].isNaN || counts[2].isInfinite ? 0.0 : counts[2].toDouble(),
            color: Colors.lime,
            borderRadius: BorderRadius.zero,
            width: 30,
          ),
        ],
      ),
      if (sankalpBarStatus == true)
        BarChartGroupData(
          x: 5,
          barRods: [
            BarChartRodData(
              toY: counts[5].isNaN || counts[5].isInfinite ? 0.0 : counts[5].toDouble(),
              color: Colors.purpleAccent,
              borderRadius: BorderRadius.zero,
              width: 30,
            ),
          ],
        ),
    ];
  }
}
