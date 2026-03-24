import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../helpers/static_data.dart' as Statics;
import '../../../models/response_model/sadbhav_baithak_vrutta_resp_model.dart';
import '../../../models/response_model/vijayaDashamiInitModel.dart';
import '../../../providers/bals.dart';
import '../../../widgets/single_column_row.dart';
import '../vijayadashami/vijayadashami_form_view.dart';

class YuvaSangamFormScreen extends StatefulWidget {
  static const routeName = '/yuva-sangam-form-screen';

  const YuvaSangamFormScreen({super.key});

  @override
  State<YuvaSangamFormScreen> createState() => _YuvaSangamFormScreenState();
}

class _YuvaSangamFormScreenState extends State<YuvaSangamFormScreen> {
  final TextEditingController txtSanmelanFormatController = TextEditingController();
  final TextEditingController txtVaktaNameController = TextEditingController();
  final TextEditingController txtVaktaTaskController = TextEditingController();

  List<NamesList> vaktaList = [];
  int? selectedVaktaIndex;

  bool _searched = true;
  bool _isExpanded = true;
  bool _isViewOnly = true;

  // List<GeoUnitMasterBAL>? _linkedMahaanagar;
  // List<GeoUnitMasterBAL>? _linkedVibhaag;
  // List<GeoUnitMasterBAL>? _linkedbhaag;
  // List<GeoUnitMasterBAL>? _linkedshahar;
  // List<GeoUnitMasterBAL>? _linkednagar;
  // List<GeoUnitMasterBAL>? _linkedmandal;
  // List<GeoUnitMasterBAL>? _linkedgraam;
  // List<GeoUnitMasterBAL>? _linkedvasti;
  //
  // String? _linkedMahaanagarValue = '';
  // String? _linkedVibhaagValue = '';
  // String? _linkedbhaagValue = "";
  // String? _linkedshaharValue = "";
  // String? _linkednagarValue = "";
  // String? _linkedNagarValuePopup = '';
  // String? _linkedmandalValue = "";
  // String? _linkedgraamValue = "";
  // String? _linkedvastiValue = "";
  //
  // // String? _linkedMahaanagarName = '';
  // // String? _linkedVibhaagName = '';
  // String? _linkedbhaagName = "";
  // String? _linkedshaharName = "";
  // String? _linkednagarName = "";
  // String? _linkedmandalName = "";
  // String? _linkedgraamName = "";
  // String? _linkedvastiName = "";
  //
  // String? _selctedLevel = 'praant';
  // String? _selctedLevelName = '';
  // String _selctedLevelNames = '';
  // List<String?> _selctedLevelNameList = [];
  String? _selectedGeoUnitId;

  int? pkId;

  // SadbhavBaithakVruttaRespModel? vruttaData;

  Vastisarsajjanshakti? selectedPerson;
  Vastisanyaprabhavi? selectedPrabhavi;
  List<Vastisarsajjanshakti> selectedSajjanshaktiItems = [];
  List<Vastisanyaprabhavi> selectedAnyaprabhaviItems = [];

  List<StaticMasterBAL>? _daayitvaFor;

  // List<LevelMasterBAL>? _level;
  List<AayaamMasterBAL>? _aayam;
  List<GatividhiMasterBAL>? _gatividhi;
  String? _daayitvaValue = "";
  String _selectedDaayitvaID = "";
  String? _lblValue = "";
  SwayamsevakDaayitvaBAL? swDaayitva;
  StaticMasterBAL? _daayitvaForValue;
  int? _levelValue;
  String? _aayaamValue = "";
  String? _gatividhiValue = "";
  List<dynamic>? _sanghaPreritSanstha;
  String? _preritSansthaValue = "";
  var _preritDesgCtrl = TextEditingController();
  var _preritRemarkCtrl = TextEditingController();
  var _othOrgNameCtrl = TextEditingController();
  var _othDesgCtrl = TextEditingController();
  var _othRemarksCtrl = TextEditingController();

  String _type = "";
  String _date = "";
  String _geo = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => _initFormState());
  }

  List<Shakhaalist> selectedItems = [];
  List<String> vayogatOptions = [];

  _initFormState() async {
    final _data = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    if (_data != null) {
      _type = _data["type"];
      _date = _data["date"];
      _geo = _data["geo"];
    }
    await populateDropdown();
    await _getForm();
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   final args = ModalRoute
  //       .of(context)!
  //       .settings
  //       .arguments as Map<String, dynamic>?;
  //   pkId = args?["id"] ?? 0;
  //   // viewType = args!.viewType;
  // }

  String? selectedSajjanshaktiItemsIds;
  String? selectedAnyaprabhaviItemsIds;

  _getForm() async {
    // var formData = {
    //   "ids": 2,
    //   "AppUserID": int.parse(Statics.userDetails['userID']),
    // };
    // vruttaData = await Statics.GetSadbhavBaithakVruttaData(context: context, inputJson: formData);
    // setState(() {});
    // if (vruttaData != null) {
    //   selectedSajjanshaktiItemsIds = vruttaData?.vastisarsajjanshakti?.where((e) => e.isVisheshdefault == 1).map((e) => e.pkid).join(',');
    //   selectedSajjanshaktiItems = vruttaData?.vastisarsajjanshakti?.where((e) => e.isVisheshdefault == 1).toList() ?? [];
    //   selectedAnyaprabhaviItemsIds = vruttaData?.vastisanyaprabhavi?.where((e) => e.isVisheshdefault == 1).map((e) => e.pkId).join(',');
    //   selectedAnyaprabhaviItems = vruttaData?.vastisanyaprabhavi?.where((e) => e.isVisheshdefault == 1).toList() ?? [];
    //
    //   vaktaList = vruttaData?.namesList ?? [];
    //   _selectedGeoUnitId = vruttaData?.geounitid.toString();
    // }
    data = await Statics.getVijayadashamiInitData(context, Statics.userDetails["userID"], "14255", "6");
    setState(() {
      // Initialize selected items from the preselected list
      selectedItems = List.from(data?.shakhaalist ?? []);

      // Extract unique categories (e.g., Senior Professionals, etc.)
      vayogatOptions = checkboxShakhaSelectedItems.map((e) => e.vayogatname ?? "").where((e) => e.isNotEmpty).toSet().toList();
    });
  }

  Future<void> submitForm({bool showLoader = true}) async {
    if (selectedSajjanshaktiItemsIds == null || selectedSajjanshaktiItemsIds!.isEmpty || selectedAnyaprabhaviItemsIds == null || selectedAnyaprabhaviItemsIds!.isEmpty || vaktaList.isEmpty) {
      Statics.showToast(Statics.getLabel("submitValidation"));
      return;
    }

    Map<String, dynamic> formData = {
      "pkid": pkId,
      "sajjanids": selectedSajjanshaktiItemsIds ?? "",
      "annyaids": selectedAnyaprabhaviItemsIds ?? "",
      "sadbhavbaithaknames": vaktaList,
      "geounitid": _selectedGeoUnitId,
      "AppUserID": int.parse(Statics.userDetails['userID']),
    };

    String formattedJson = const JsonEncoder.withIndent('  ').convert(formData);
    log("Form Data (JSON):\n$formattedJson");
    await Statics.SaveSadbhavBaithakVruttaData(context: context, inputJson: formData, showLoader: showLoader);
    // getFormData();
  }

  //////////////////////////////////////////////////////////////////////////////////////
//
  Future<void> populateDropdown() async {
    var data = await Statics.getStaticLDB("DaayitvaFor");
    // var data2 = await Statics.getLevelLDB();
    var data3 = await Statics.getAayamLDB();
    var data4 = await Statics.getGatividhiLDB();
    var data5 = await Statics.getSanghaPreritSanstha("1", null, null);
    setState(() {
      _daayitvaFor = data;
      // _level = data2;
      _aayam = data3;
      _gatividhi = data4;
      _sanghaPreritSanstha = data5;
      // _linkedMahaanagarValue = _linkedbhaagValue = _linkedshaharValue = _linkednagarValue = _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = null;
    });
    // await populatelinkedMahaanagarDropdown();
    // await populatelinkedVibhaagDropdown('');
  }

//
//   Future<List<GeoUnitMasterBAL>> populatelinkedMahaanagarDropdown() async {
//     _linkedVibhaagValue = _linkedbhaagValue = _linkednagarValue = _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = null;
//     List<GeoUnitMasterBAL> data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['MahaanagarLevelID'].toString(), '', '', '', isAbhiyaan: false);
//     setState(() {
//       _linkedMahaanagar = data;
//     });
//     return data;
//   }
//
//   Future<List<GeoUnitMasterBAL>> populatelinkedVibhaagDropdown(String mahaanagarIDStr) async {
//     _linkedbhaagValue = _linkednagarValue = _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = null;
//     _linkedbhaagName = _linkednagarName = _linkedmandalName = _linkedgraamName = _linkedvastiName = null;
//     print("populatelinkedVibhaagDropdown $mahaanagarIDStr");
//     var data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['VibhaagLevelID'].toString(), mahaanagarIDStr, (mahaanagarIDStr.isEmpty ? '' : 'Mahaanagar'), '', isAbhiyaan: false);
//     setState(() {
//       _linkedVibhaag = data;
//     });
//     return data;
//   }
//
//   Future<List<GeoUnitMasterBAL>> populatelinkedBhaagDropdown(String vibhaagIDStr) async {
//     _linkedbhaagValue = _linkednagarValue = _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = null;
//     _linkedbhaagName = _linkednagarName = _linkedmandalName = _linkedgraamName = _linkedvastiName = null;
//     _linkedbhaag = _linkednagar = _linkedmandal = _linkedgraam = _linkedvasti = [];
//     var data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['BhaagLevelID'].toString(), vibhaagIDStr, 'Vibhaag', '', isAbhiyaan: false);
//     setState(() {
//       _linkedbhaag = data;
//     });
//     return data;
//   }
//
//   Future<List<GeoUnitMasterBAL>> populatelinkedShaharDropdown(String bhaagIDStr) async {
//     _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = null;
//     _linkedmandalName = _linkedgraamName = _linkedvastiName = null;
//     var shDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['ShaharLevelID'].toString(), bhaagIDStr, 'Bhaag', '', isAbhiyaan: false);
//     setState(() {
//       _linkedshahar = (shDD.length > 0 ? shDD : null);
//     });
//     return shDD;
//   }
//
//   Future<List<GeoUnitMasterBAL>> populatelinkedNagarDropdown(String? bhaagIDStr, String? shaharIDStr) async {
// // print("populatelinkedNagarDropdown ${bhaagIDStr} == ${shaharIDStr}  ");
//     _linkednagarValue = _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = null;
//     _linkednagarName = _linkedmandalName = _linkedgraamName = _linkedvastiName = null;
//     _linkednagar = _linkedmandal = _linkedgraam = _linkedvasti = null;
//     print("print LevelID > ${Statics.userDetails["LevelID"]}");
//     print("shaharIDStr shaharIDStr $shaharIDStr");
//     if (shaharIDStr != null) {
//       var ngDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['NagarLevelID'].toString(), shaharIDStr!, 'Shahar', '', isAbhiyaan: false);
//       setState(() {
//         _linkednagar = (ngDD.length > 0 ? ngDD : null);
//       });
//       return ngDD;
//     } else {
//       var ngDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['NagarLevelID'].toString(), bhaagIDStr!, 'Bhaag', '', isAbhiyaan: false);
//       setState(() {
//         _linkednagar = (ngDD.length > 0 ? ngDD : null);
//       });
//       return ngDD;
//     }
//   }
//
//   Future<List<GeoUnitMasterBAL>> populatelinkedMandalDropdown(String? nagarIDStr) async {
//     _linkedmandalValue = _linkedgraamValue = null;
//     _linkedmandalName = _linkedgraamName = null;
//     _linkedmandal = _linkedgraam = null;
//     var mnDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['MandalLevelID'].toString(), nagarIDStr!, 'Nagar', '', isAbhiyaan: false);
//     setState(() {
//       _linkedmandal = (mnDD.length > 0 ? mnDD : null);
//     });
//     return mnDD;
//   }
//
//   Future<List<GeoUnitMasterBAL>> populatelinkedGraamDropdown(String? mandalIDStr) async {
//     _linkedgraamValue = null;
//     _linkedgraamName = null;
//     var gmDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['GraamLevelID'].toString(), mandalIDStr!, 'Mandal', '', isAbhiyaan: false);
//     setState(() {
//       _linkedgraam = (gmDD.length > 0 ? gmDD : null);
//     });
//     return gmDD;
//   }
//
//   Future<List<GeoUnitMasterBAL>> populatelinkedVastiDropdown(String? nagarIDStr) async {
//     _linkedvastiValue = null;
//     _linkedvastiName = null;
//     var vsDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['VastiLevelID'].toString(), nagarIDStr!, 'Nagar', '', isAbhiyaan: false);
//     setState(() {
//       _linkedvasti = (vsDD.length > 0 ? vsDD : null);
//     });
//     return vsDD;
//   }
//
//   //////////////////////////////////////////////////////////////////////////////////////

  GetVijayadashamiInitModel? data;

  final _extraList = [
    Shakhaalist(
        frequencyName: "शाखा",
        geoUnitID: 1,
        geoUnitName: "example abc मिलन",
        geoUnitNameHindi: "example abc मिलन",
        geoUnitNameMarathi: "example abc मिलन",
        isSankalpit: 0,
        preferedname: "example abc मिलन",
        vayogatname: "प्रौढ व्यवसायी",
        linkedUpaNagarID: 0),
    Shakhaalist(
        frequencyName: "शाखा",
        geoUnitID: 1,
        geoUnitName: "example abc मिलन 2",
        geoUnitNameHindi: "example abc मिलन 2",
        geoUnitNameMarathi: "example abc मिलन 2",
        isSankalpit: 0,
        preferedname: "example abc मिलन 2",
        vayogatname: "प्रौढ व्यवसायी",
        linkedUpaNagarID: 0),
    Shakhaalist(
        frequencyName: "शाखा",
        geoUnitID: 1,
        geoUnitName: "example abc मिलन 3",
        geoUnitNameHindi: "example abc मिलन 3",
        geoUnitNameMarathi: "example abc मिलन 3",
        isSankalpit: 0,
        preferedname: "example abc मिलन 3",
        vayogatname: "तरुण विद्यार्थी",
        linkedUpaNagarID: 0),
    Shakhaalist(
        frequencyName: "शाखा",
        geoUnitID: 1,
        geoUnitName: "example abc मिलन 4",
        geoUnitNameHindi: "example abc मिलन 4",
        geoUnitNameMarathi: "example abc मिलन 4",
        isSankalpit: 0,
        preferedname: "example abc मिलन 4",
        vayogatname: "तरुण व्यवसायी",
        linkedUpaNagarID: 0),
    Shakhaalist(
        frequencyName: "शाखा",
        geoUnitID: 1,
        geoUnitName: "example abc मिलन 5",
        geoUnitNameHindi: "example abc मिलन 5",
        geoUnitNameMarathi: "example abc मिलन 5",
        isSankalpit: 0,
        preferedname: "example abc मिलन 5",
        vayogatname: "तरुण व्यवसायी",
        linkedUpaNagarID: 0),
    Shakhaalist(
        frequencyName: "शाखा",
        geoUnitID: 1,
        geoUnitName: "example abc मिलन 6",
        geoUnitNameHindi: "example abc मिलन 6",
        geoUnitNameMarathi: "example abc मिलन 6",
        isSankalpit: 0,
        preferedname: "example abc मिलन 6",
        vayogatname: "बाल/संयुक्त",
        linkedUpaNagarID: 0),
    Shakhaalist(
        frequencyName: "शाखा",
        geoUnitID: 1,
        geoUnitName: "example abc मिलन 7",
        geoUnitNameHindi: "example abc मिलन 7",
        geoUnitNameMarathi: "example abc मिलन 7",
        isSankalpit: 0,
        preferedname: "example abc मिलन 7",
        vayogatname: "बाल/संयुक्त",
        linkedUpaNagarID: 0),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${Statics.getLabel('yuvaSangam')} ${Statics.getLabel('Vrutta')}",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        // actions: [IconButton(onPressed: getExcelReportDataFun, icon: Icon(Icons.download))],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "*Dummy Data",
                    style: TextStyle(color: Colors.grey.shade600, fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
                  )
                ],
              ),
              const SizedBox(height: 20),
              // vastiMandalDropdown(),

// ================================== HEADER CARD ==================================================================================================================================================================================================================================================================================================================================================
              Container(
                decoration: BoxDecoration(
                  color: Colors.purple, // Precise deep purple
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _type, // Replaced 'भाग - जिल्हा' and 'नगर'
                          style: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 12,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          _geo, // Assuming 'Zone - Chembur' or 'Zone: Chembur' isn't needed as user said to replace with simple English words. Just District value is good.
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_month_outlined, // Replaced gift box icon with standard calendar icon
                              color: Colors.white70,
                              size: 16,
                            ),
                            SizedBox(width: 4),
                            Text(
                              Statics.getLabel('date2'),
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _date, // Date value kept as is
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Spacing between cards
// ================================== 1 QUESTIONS Box ==================================================================================================================================================================================================================================================================================================================================================

              // Main White Card with Shadow
              mainContainer(
                "${Statics.getLabel("youthProfessorAtt")}",
                Column(
                  children: [
                    // Table Column Headers Row
                    Row(
                      children: [
                        Expanded(
                          child: Center(
                            child: Text(
                              Statics.getLabel('Apekshit'), // Replaced 'अपेक्षित (Expected)'
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 16), // Spacing between columns
                        Expanded(
                          child: Center(
                            child: Text(
                              Statics.getLabel('Present'), // Replaced 'उपस्थित (Present)'
                              style: TextStyle(
                                color: const Color(0xFF2E7D32), // Precise green color
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Form Rows (Carefully aligned as table structure)
                    // Row 1: College Student fields
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(
                              hintText: Statics.getLabel("mahavidya"),
                              hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                              fillColor: const Color(0xFFF0F0F2),
                              // Light grey fill
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none, // Hide default border
                              ),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12), // Align left of field
                            ),
                            style: const TextStyle(color: Colors.grey, fontSize: 14), // Original fields looked greyed out
                          ),
                        ),
                        const SizedBox(width: 16), // Column spacing
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(
                              hintText: Statics.getLabel("mahavidya"),
                              hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                              fillColor: const Color(0xFFF0F0F2),
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                            ),
                            style: const TextStyle(color: Colors.grey, fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Row 2: Youth Professional fields
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(
                              hintText: '${Statics.getLabel(("TarunVyavasaayee"))} (< 30)',
                              // Replaced 'युवा व्यवसायी (< 3)' placeholder
                              hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                              fillColor: const Color(0xFFF0F0F2),
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                            ),
                            style: const TextStyle(color: Colors.grey, fontSize: 14),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(
                              hintText: '${Statics.getLabel(("TarunVyavasaayee"))} (< 30)',
                              hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                              fillColor: const Color(0xFFF0F0F2),
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                            ),
                            style: const TextStyle(color: Colors.grey, fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Row 3: Yuva Mandal fields
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(
                              hintText: '${Statics.getLabel(("yuvaMandal"))}',
                              // Replaced 'युवा व्यवसायी (< 3)' placeholder
                              hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                              fillColor: const Color(0xFFF0F0F2),
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                            ),
                            style: const TextStyle(color: Colors.grey, fontSize: 14),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(
                              hintText: '${Statics.getLabel(("yuvaMandal"))}',
                              hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                              fillColor: const Color(0xFFF0F0F2),
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                            ),
                            style: const TextStyle(color: Colors.grey, fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Row 4: Faculty fields
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(
                              hintText: '${Statics.getLabel(("professor"))}',
                              // Replaced 'प्राध्यापक' placeholder
                              hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                              fillColor: const Color(0xFFF0F0F2),
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                            ),
                            style: const TextStyle(color: Colors.grey, fontSize: 14),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(
                              hintText: '${Statics.getLabel(("professor"))}',
                              hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                              fillColor: const Color(0xFFF0F0F2),
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                            ),
                            style: const TextStyle(color: Colors.grey, fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
// ================================== 2 QUESTIONS Box ==================================================================================================================================================================================================================================================================================================================================================

              // Main White Card with Shadow
              mainContainer(
                "${Statics.getLabel("schoolsVastigruhAtt")}",
                Column(
                  children: [
                    // Table Column Headers Row
                    Row(
                      children: [
                        Expanded(
                          child: Center(
                            child: Text(
                              Statics.getLabel('Apekshit'), // Replaced 'अपेक्षित (Expected)'
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 16), // Spacing between columns
                        Expanded(
                          child: Center(
                            child: Text(
                              Statics.getLabel('Present'), // Replaced 'उपस्थित (Present)'
                              style: TextStyle(
                                color: const Color(0xFF2E7D32), // Precise green color
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Form Rows (Carefully aligned as table structure)
                    // Row 1: College Student fields
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(
                              hintText: Statics.getLabel("schools"),
                              hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                              fillColor: const Color(0xFFF0F0F2),
                              // Light grey fill
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none, // Hide default border
                              ),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12), // Align left of field
                            ),
                            style: const TextStyle(color: Colors.grey, fontSize: 14), // Original fields looked greyed out
                          ),
                        ),
                        const SizedBox(width: 16), // Column spacing
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(
                              hintText: Statics.getLabel("schools"),
                              hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                              fillColor: const Color(0xFFF0F0F2),
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                            ),
                            style: const TextStyle(color: Colors.grey, fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Row 2: Youth Professional fields
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(
                              hintText: '${Statics.getLabel(("vastigruh"))}',
                              // Replaced 'युवा व्यवसायी (< 3)' placeholder
                              hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                              fillColor: const Color(0xFFF0F0F2),
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                            ),
                            style: const TextStyle(color: Colors.grey, fontSize: 14),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(
                              hintText: '${Statics.getLabel(("vastigruh"))}',
                              hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                              fillColor: const Color(0xFFF0F0F2),
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                            ),
                            style: const TextStyle(color: Colors.grey, fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
// // ================================== 3 QUESTIONS Box ==================================================================================================================================================================================================================================================================================================================================================
//               mainContainer(
//                 "${Statics.getLabel('presentMahanubhav')}",
//                 Column(
//                   children: [
//                     // Button for popup
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       children: [
//                         InkWell(
//                           borderRadius: BorderRadius.circular(15),
//                           onTap: () async {
//                             if (!_searched) {
//                               Fluttertoast.showToast(msg: "${Statics.getLabel('NagarSelectionImportant')}");
//                               return;
//                             }
//
//                             final _tempFiles1 = (vruttaData?.vastisarsajjanshakti ?? []).where((e) => selectedPerson != e).toList();
//                             final _tempFiles2 = (vruttaData?.vastisanyaprabhavi ?? []).where((e) => selectedPrabhavi != e).toList();
//
//                             // _tempFiles1.where((e) => e.pkid != selectedPerson?.pkid || e.isMukhyadefault == 0).toList();
//                             // _tempFiles2.where((e) => e.pkId != selectedPrabhavi?.pkId || e.isMukhyadefault == 0).toList();
//                             await showVisheshAtithiSelectionPopup(
//                               context,
//                               sarsajjanshaktiList: _tempFiles1,
//                               sanyaprabhaviList: _tempFiles2,
//                             );
//                           },
//                           child: Container(
//                             padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
//                             // width: 150,
//                             // height: 35,
//                             decoration: BoxDecoration(
//                               border: Border.all(color: Colors.purpleAccent.shade100),
//                               borderRadius: BorderRadius.circular(15),
//                             ),
//                             child: Text(
//                               "${Statics.getLabel('addPresentMahanubhav')}",
//                               style: TextStyle(
//                                 color: Colors.purpleAccent,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//
//                     const SizedBox(height: 20),
//
//                     // Table for Sajjanshakti
//                     if (selectedSajjanshaktiItems.isNotEmpty) ...[
//                       Text("${Statics.getLabel('SajjanShakti')}", style: TextStyle(fontWeight: FontWeight.bold)),
//                       Table(
//                         border: TableBorder.all(),
//                         columnWidths: const {
//                           0: FixedColumnWidth(40),
//                           1: FlexColumnWidth(),
//                           2: FlexColumnWidth(),
//                         },
//                         children: [
//                           TableRow(
//                             decoration: BoxDecoration(color: Color(0xFFE0E0E0)),
//                             children: [
//                               Padding(padding: EdgeInsets.all(4), child: Text("${Statics.getLabel('serialNo')}")),
//                               Padding(padding: EdgeInsets.all(4), child: Text("${Statics.getLabel('Name')}")),
//                               Padding(padding: EdgeInsets.all(4), child: Text("${Statics.getLabel('samparkSootraNaav')}")),
//                               Padding(padding: EdgeInsets.all(4), child: Text("${Statics.getLabel('ViewMenu')}")),
//                             ],
//                           ),
//                           ...selectedSajjanshaktiItems.asMap().entries.map((entry) {
//                             int srNo = entry.key + 1;
//                             final item = entry.value;
//                             return TableRow(
//                               children: [
//                                 Padding(padding: const EdgeInsets.all(4), child: Text(srNo.toString())),
//                                 Padding(padding: const EdgeInsets.all(4), child: Text(item.name ?? "")),
//                                 Padding(padding: const EdgeInsets.all(4), child: Text(item.samparkasutranava ?? "")),
//                                 IconButton(
//                                   icon: Icon(Icons.remove_red_eye, size: 22, color: Colors.purpleAccent),
//                                   onPressed: () {
//                                     showPersonDetailsPopup(context, item, srNo);
//                                   },
//                                 ),
//                               ],
//                             );
//                           }).toList(),
//                         ],
//                       ),
//                     ],
//
//                     const SizedBox(height: 20),
//
//                     // Table for Anyaprabhavi
//                     if (selectedAnyaprabhaviItems.isNotEmpty) ...[
//                       Text("${Statics.getLabel('anyaPrabhaviLok')}", style: TextStyle(fontWeight: FontWeight.bold)),
//                       Table(
//                         border: TableBorder.all(),
//                         columnWidths: const {
//                           0: FixedColumnWidth(40),
//                           1: FlexColumnWidth(),
//                           2: FlexColumnWidth(),
//                           3: FixedColumnWidth(50), // 👁 button column
//                         },
//                         children: [
//                           TableRow(
//                             decoration: BoxDecoration(color: Color(0xFFE0E0E0)),
//                             children: [
//                               Padding(padding: EdgeInsets.all(4), child: Text("${Statics.getLabel('serialNo')}")),
//                               Padding(padding: EdgeInsets.all(4), child: Text("${Statics.getLabel('Name')}")),
//                               Padding(padding: EdgeInsets.all(4), child: Text("${Statics.getLabel('samparkSootraNaav')}")),
//                               Padding(padding: EdgeInsets.all(4), child: Text("${Statics.getLabel('ViewMenu')}")), // 👁 column heading
//                             ],
//                           ),
//                           ...selectedAnyaprabhaviItems.asMap().entries.map((entry) {
//                             int srNo = entry.key + 1;
//                             final item = entry.value;
//
//                             return TableRow(
//                               children: [
//                                 Padding(padding: const EdgeInsets.all(4), child: Text(srNo.toString())),
//                                 Padding(padding: const EdgeInsets.all(4), child: Text(item.name ?? "")),
//                                 Padding(padding: const EdgeInsets.all(4), child: Text(item.samparkAsutraNav ?? "")),
//                                 IconButton(
//                                   icon: Icon(Icons.remove_red_eye, size: 22, color: Colors.purpleAccent),
//                                   onPressed: () {
//                                     showPersonDetailsPopup(context, item, srNo);
//                                   },
//                                 ),
//                               ],
//                             );
//                           }).toList(),
//                         ],
//                       ),
//                     ],
//                   ],
//                 ),
//               ),
// ================================== 4 QUESTIONS Box ==================================================================================================================================================================================================================================================================================================================================================
              mainContainer(
                "${Statics.getLabel('shakhaMilanPratinidhitwa')}",
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ✅ Header Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          Statics.getLabel('selectshakhaa'),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.purpleAccent,
                          ),
                        ),
                        Text(
                          "${Statics.getLabel('selectedTotal')} : $selectedShakhaCount",
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // ✅ One ExpansionTile per vayogat group
                    ...() {
                      final List<String> vayogatOptions = (data?.shakhaalist ?? []).map((e) => e.vayogatname ?? "").where((e) => e.isNotEmpty).toSet().toList();

                      return vayogatOptions.map((vayogat) {
                        final groupItems = ((data?.shakhaalist ?? []) + _extraList.toList()).where((e) => e.vayogatname == vayogat && e.frequencyName == "शाखा").toList();

                        final selectedInGroup = checkboxShakhaSelectedItems.where((e) => e.vayogatname == vayogat).length;

                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(color: Colors.purpleAccent.shade100),
                          ),
                          elevation: 0,
                          child: ExpansionTile(
                            tilePadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                            childrenPadding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            collapsedShape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            title: Text(
                              vayogat,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            subtitle: Text(
                              "${Statics.getLabel('Total')} : ${groupItems.length}   •   ${Statics.getLabel('selectedTotal')} : $selectedInGroup",
                              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                            ),
                            // ✅ Leading checkbox: select/deselect entire group
                            leading: Checkbox(
                              tristate: true,
                              value: selectedInGroup == 0
                                  ? false
                                  : selectedInGroup == groupItems.length
                                      ? true
                                      : null,
                              activeColor: Colors.purpleAccent,
                              onChanged: (val) {
                                setState(() {
                                  if (val == true) {
                                    // Add all from group not already added
                                    for (var item in groupItems) {
                                      if (!checkboxShakhaSelectedItems.contains(item)) {
                                        checkboxShakhaSelectedItems.add(item);
                                      }
                                    }
                                  } else {
                                    // Remove all from group
                                    checkboxShakhaSelectedItems.removeWhere((item) => item.vayogatname == vayogat);
                                  }
                                  _recalculateShakhaCounts(data);
                                });
                              },
                            ),
                            children: [
                              const Divider(height: 1),
                              ...groupItems.map((item) {
                                final isSelected = checkboxShakhaSelectedItems.contains(item);
                                return InkWell(
                                  onTap: () {
                                    setState(() {
                                      if (isSelected) {
                                        checkboxShakhaSelectedItems.remove(item);
                                      } else {
                                        checkboxShakhaSelectedItems.add(item);
                                      }
                                      _recalculateShakhaCounts(data);
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    child: Row(
                                      children: [
                                        Checkbox(
                                          value: isSelected,
                                          activeColor: Colors.purpleAccent,
                                          onChanged: (checked) {
                                            setState(() {
                                              if (checked == true) {
                                                checkboxShakhaSelectedItems.add(item);
                                              } else {
                                                checkboxShakhaSelectedItems.remove(item);
                                              }
                                              _recalculateShakhaCounts(data);
                                            });
                                          },
                                        ),
                                        const SizedBox(width: 6),
                                        Expanded(
                                          child: Text(
                                            item.preferedname ?? "",
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: isSelected ? Colors.purpleAccent.shade700 : Colors.black87,
                                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            ],
                          ),
                        );
                      }).toList();
                    }(),

                    const SizedBox(height: 12),

                    // ✅ Summary rows
                    SingleColumnRow(
                      txtString: "${Statics.getLabel('Total')} ${Statics.getLabel('Shaakhaa')} ",
                      value: "${((data?.shakhaalist ?? []) + _extraList.toList()).where((item) => item.frequencyName == "शाखा").length}",
                    ),
                    SingleColumnRow(
                      txtString: " ${Statics.getLabel('Shaakhaa')} ${Statics.getLabel('pratinidhitva')}",
                      value: "$selectedShakhaCount",
                    ),
                    SingleColumnRow(
                      rowColor: Colors.grey.shade300,
                      txtString: " ${Statics.getLabel('Shaakhaa')} ${Statics.getLabel('average')} ${Statics.getLabel('pratinidhitva')} ",
                      value: (((data?.shakhaalist ?? []) + _extraList.toList()).where((item) => item.frequencyName == "शाखा").length > 0
                              ? ((selectedShakhaCount / ((data?.shakhaalist ?? []) + _extraList.toList()).where((item) => item.frequencyName == "शाखा").length) * 100).round().toString()
                              : "0") +
                          " %",
                    ),
                  ],
                ),
              ),
// ================================== 5 QUESTIONS Box ==================================================================================================================================================================================================================================================================================================================================================
              mainContainer(
                "${Statics.getLabel('sanmelanVakta')}",
                vaktaTable(),
              ),
// ================================== 6 QUESTIONS Box ==================================================================================================================================================================================================================================================================================================================================================
              mainContainer(
                "${Statics.getLabel('sanmelanFormat')}",
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Text(
                    //   Statics.getLabel("sanmelanFormat"),
                    //   style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    // ),
                    SizedBox(height: 8),
                    TextFormField(
                      controller: txtSanmelanFormatController,
                      textAlignVertical: TextAlignVertical.center,
                      // textAlign: TextAlign.left,
                      autofocus: false,
                      readOnly: !_searched,
                      onTap: () {
                        print(DateTime.now());
                        if (!_searched) {
                          Fluttertoast.showToast(
                            msg: "${Statics.getLabel('NagarSelectionImportant')}",
                          );
                        }
                      },
                      maxLines: 5,
                      onChanged: (value) => setState(() {}),
                      onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
                      decoration: InputDecoration(
                        hintText: Statics.getLabel("AddSanmelanFormat"),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        // enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        // focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.purple),borderRadius: BorderRadius.circular(12)),
                      ),
                      // validator: (value) {
                      //   // if (value != null && value.trim().isNotEmpty && value.length < 9 && memberController.contactList.value.isEmpty){
                      //   //   return "Invalid contact number";
                      //   // }else
                      //   if (memberController.contactList.value.isEmpty) {
                      //     if (value == null || value.trim().isEmpty) {
                      //       return "Please enter contact number";
                      //     }
                      //     if (value.length < 9) {
                      //       return "Invalid contact number";
                      //     }
                      //     return null;
                      //     // return "Please enter at least one contact number";
                      //   } else {
                      //     if (value != null && value.trim().isNotEmpty && value.length < 9) {
                      //       return "Invalid contact number";
                      //     }
                      //   }
                      //
                      //   return null;
                      // },
                    ),
                  ],
                ),
              ),

//==============================  SUBMIT BUTTON =======================================================================

              SizedBox(height: 24),
              Container(
                width: double.infinity,
                child: MaterialButton(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  color: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                  onPressed: () => Statics.showToast(Statics.getLabel("workInProgress")),
                  // submitForm,
                  child: Text(
                    Statics.getLabel('Submit'),
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
              SizedBox(height: 70),
            ],
          ),
        ),
      ),
    );
  }

  VastiCounts? countsShakhaa;

  List<Shakhaalist> checkboxShakhaSelectedItems = [];
  int totalShakhaCount = 0;
  int selectedShakhaCount = 0;
  String averageShakhaCount = "0";
  String? selectedShakhaaPratinidhitwaVastiIds;

  void _recalculateShakhaCounts(GetVijayadashamiInitModel? data) {
    // ✅ Total shakha count
    totalShakhaCount = (data?.shakhaalist ?? []).where((item) => item.frequencyName == "शाखा").length;

    // ✅ Selected shakha count
    selectedShakhaCount = checkboxShakhaSelectedItems.where((item) => item.frequencyName == "शाखा").length;

    // ✅ Comma-separated IDs
    selectedShakhaaPratinidhitwaVastiIds = checkboxShakhaSelectedItems.map((e) => e.geoUnitID.toString()).join(",");

    // ✅ Average percentage
    if (totalShakhaCount > 0) {
      averageShakhaCount = ((selectedShakhaCount / totalShakhaCount) * 100).round().toString();
    } else {
      averageShakhaCount = "0";
    }

    // ✅ Build VastiCounts
    final Map<String, int> vayogatCounts = {};
    for (var item in checkboxShakhaSelectedItems) {
      final key = item.vayogatname ?? "Unknown";
      vayogatCounts[key] = (vayogatCounts[key] ?? 0) + 1;
    }
    countsShakhaa = VastiCounts(
      prakarCounts: {},
      vayogatCounts: vayogatCounts,
    );
  }

  Future<void> showShakhaalistPopup(
    BuildContext context, {
    required List<Shakhaalist> shakhaalist,
    List<Shakhaalist>? preselectedItems,
    required void Function(
      List<Shakhaalist> selectedItems,
      VastiCounts counts,
    ) onSubmit,
  }) async {
    log("showShakhaalistPopup Opened >>>>>>>>>>>>>>>>>>>>> ");
    List<Shakhaalist> selectedItems = List.from(preselectedItems ?? []);

    final List<String> vayogatOptions = shakhaalist.map((e) => e.vayogatname ?? "").where((e) => e.isNotEmpty).toSet().toList();

    String? selectedVayogat;

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            final filteredList = selectedVayogat == null ? shakhaalist : shakhaalist.where((e) => e.vayogatname == selectedVayogat).toList();

            return Dialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              insetPadding: const EdgeInsets.all(16),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(16),
                // ✅ Standard height for popup (60% of screen)
                height: MediaQuery.of(context).size.height * 0.75,
                width: double.maxFinite,
                child: Column(
                  children: [
                    // ✅ Title Bar
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          Statics.getLabel('selectshakhaa'),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.redAccent),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    const Divider(),

                    // ✅ Dropdown
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        labelText: Statics.getLabel("Vayogat"),
                      ),
                      value: selectedVayogat,
                      items: vayogatOptions.map((v) {
                        return DropdownMenuItem(
                          value: v,
                          child: Text(v),
                        );
                      }).toList(),
                      onChanged: (val) {
                        setState(() {
                          selectedVayogat = val;
                        });
                      },
                    ),
                    const SizedBox(height: 10),

                    // ✅ Stats
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${Statics.getLabel('Total')} : ${filteredList.where((item) => item.frequencyName == "शाखा").length}",
                          style: const TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        Text(
                          "${Statics.getLabel('selectedTotal')} : ${selectedItems.where((item) => item.frequencyName == "शाखा").length}",
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // ✅ Table inside scroll
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black12),
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.white,
                        ),
                        child: SingleChildScrollView(
                          child: Table(
                            border: TableBorder.symmetric(
                              inside: const BorderSide(color: Colors.black12),
                            ),
                            columnWidths: const {
                              0: FixedColumnWidth(50),
                            },
                            children: [
                              // Header
                              TableRow(
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade50,
                                ),
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(8),
                                    child: Text("✔", style: TextStyle(fontWeight: FontWeight.bold)),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8),
                                    child: Text(Statics.getLabel("Name"), style: TextStyle(fontWeight: FontWeight.bold)),
                                  ),
                                ],
                              ),
                              ...filteredList.where((item) => item.frequencyName == "शाखा").map((item) {
                                final isSelected = selectedItems.contains(item);

                                return TableRow(
                                  children: [
                                    Center(
                                      child: Checkbox(
                                        value: isSelected,
                                        onChanged: (checked) {
                                          setState(() {
                                            if (checked == true) {
                                              selectedItems.add(item);
                                            } else {
                                              selectedItems.remove(item);
                                            }
                                          });
                                        },
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Text(item.preferedname ?? ""),
                                    ),
                                  ],
                                );
                              }),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // ✅ Footer
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purpleAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      ),
                      onPressed: () {
                        final Map<String, int> vayogatCounts = {};
                        for (var item in selectedItems) {
                          final key = item.vayogatname ?? "Unknown";
                          vayogatCounts[key] = (vayogatCounts[key] ?? 0) + 1;
                        }

                        final counts = VastiCounts(
                          prakarCounts: {},
                          vayogatCounts: vayogatCounts,
                        );

                        onSubmit(selectedItems, counts);
                        Navigator.pop(context);
                      },
                      child: Text(
                        Statics.getLabel('Submit'),
                        style: const TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // Future<void> showVisheshAtithiSelectionPopup(BuildContext context, {sarsajjanshaktiList, sanyaprabhaviList}) async {
  //   print("showVisheshAtithiSelectionPopup onTap >>>>>>>>>>>>>>> ");
  //   // final _sarsajjanshaktiList = data?.vastisarsajjanshakti ?? [];
  //   // final _sanyaprabhaviList = data?.vastisanyaprabhavi ?? [];
  //
  //   await showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (ctx) {
  //       if (vruttaData == null) {
  //         return Center(child: CircularProgressIndicator());
  //       }
  //       return StatefulBuilder(
  //         builder: (ctnx, set) {
  //           return AlertDialog(
  //             clipBehavior: Clip.antiAlias,
  //             contentPadding: EdgeInsets.zero,
  //             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  //             insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
  //             content: Container(
  //               // padding: const EdgeInsets.all(16),
  //               width: double.maxFinite,
  //               child: Column(
  //                 mainAxisSize: MainAxisSize.min,
  //                 children: [
  //                   /// Title with Close Button
  //                   Container(
  //                     width: double.infinity,
  //                     padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
  //                     // decoration: const BoxDecoration(
  //                     //   gradient: LinearGradient(
  //                     //     colors: [Colors.purple, Colors.purpleAccent],
  //                     //     begin: Alignment.centerLeft,
  //                     //     end: Alignment.centerRight,
  //                     //   ),
  //                     // ),
  //                     child: Row(
  //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                       children: [
  //                         Text(
  //                           Statics.getLabel('presentMahanubhav'),
  //                           style: const TextStyle(
  //                             fontWeight: FontWeight.bold,
  //                             fontSize: 18,
  //                             color: Colors.black,
  //                           ),
  //                         ),
  //                         IconButton(
  //                           icon: const Icon(Icons.close, color: Colors.red),
  //                           onPressed: () => Navigator.pop(ctnx),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                   Flexible(
  //                     child: Padding(
  //                       padding: const EdgeInsets.symmetric(horizontal: 16),
  //                       child: Column(
  //                         mainAxisSize: MainAxisSize.min,
  //                         children: [
  //                           // SizedBox(height: 24),
  //                           Row(
  //                             spacing: 12,
  //                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                             children: [
  //                               ElevatedButton(
  //                                 style: ElevatedButton.styleFrom(
  //                                   tapTargetSize: MaterialTapTargetSize.shrinkWrap,
  //                                   backgroundColor: Colors.green,
  //                                   shape: RoundedRectangleBorder(
  //                                     borderRadius: BorderRadius.circular(12),
  //                                   ),
  //                                   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
  //                                 ),
  //                                 onPressed: () async {
  //                                   // await submitForm();
  //                                   Navigator.of(context).pushReplacementNamed(
  //                                     SearchSajjanAnyaScreen.routeName,
  //                                     arguments: {'geoUnitId': _selectedGeoUnitId},
  //                                   ).then(
  //                                     (value) async {
  //                                       await _getForm();
  //                                       setState(() {});
  //                                     },
  //                                   );
  //                                 },
  //                                 child: Row(
  //                                   mainAxisSize: MainAxisSize.min,
  //                                   children: [
  //                                     Icon(
  //                                       Icons.search,
  //                                       color: Colors.white,
  //                                     ),
  //                                     Text(
  //                                       Statics.getLabel('Search'),
  //                                       style: const TextStyle(color: Colors.white),
  //                                     ),
  //                                   ],
  //                                 ),
  //                               ),
  //                               OutlinedButton(
  //                                 style: OutlinedButton.styleFrom(
  //                                   side: const BorderSide(color: Colors.purpleAccent, width: 1.5),
  //                                   shape: RoundedRectangleBorder(
  //                                     borderRadius: BorderRadius.circular(12),
  //                                   ),
  //                                   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
  //                                 ),
  //                                 onPressed: () async {
  //                                   //await submitForm();
  //                                   Navigator.of(context).pushReplacementNamed(
  //                                     AddVishisthaAtithi.routeName,
  //                                     arguments: {'geoUnitId': _selectedGeoUnitId},
  //                                   ).then(
  //                                     (value) async {
  //                                       await _getForm();
  //                                       setState(() {});
  //                                     },
  //                                   );
  //                                 },
  //                                 child: Text(
  //                                   Statics.getLabel('fillNewRecord'),
  //                                   style: const TextStyle(color: Colors.purpleAccent),
  //                                 ),
  //                               ),
  //                             ],
  //                           ),
  //                           SizedBox(height: 6),
  //                           Flexible(
  //                             child: SingleChildScrollView(
  //                               child: Column(
  //                                 children: [
  //                                   /// Content
  //                                   const SizedBox(height: 12),
  //                                   Text(
  //                                     Statics.getLabel('SajjanShakti'),
  //                                     style: const TextStyle(
  //                                       fontWeight: FontWeight.w600,
  //                                       fontSize: 16,
  //                                       color: Colors.blueGrey,
  //                                     ),
  //                                   ),
  //                                   const Divider(),
  //                                   Container(
  //                                     decoration: BoxDecoration(
  //                                       border: Border.all(color: Colors.black12),
  //                                       borderRadius: BorderRadius.circular(12),
  //                                       color: Colors.white,
  //                                     ),
  //                                     child: Table(
  //                                       border: TableBorder.symmetric(
  //                                         inside: const BorderSide(color: Colors.black12),
  //                                       ),
  //                                       columnWidths: const {
  //                                         0: FixedColumnWidth(50),
  //                                       },
  //                                       children: [
  //                                         // Header
  //                                         TableRow(
  //                                           decoration: BoxDecoration(
  //                                             color: Colors.blue.shade50,
  //                                           ),
  //                                           children: [
  //                                             Padding(
  //                                               padding: EdgeInsets.all(8),
  //                                               child: Text("✔", style: TextStyle(fontWeight: FontWeight.bold)),
  //                                             ),
  //                                             Padding(
  //                                               padding: EdgeInsets.all(8),
  //                                               child: Text(Statics.getLabel("Name"), style: TextStyle(fontWeight: FontWeight.bold)),
  //                                             ),
  //                                           ],
  //                                         ),
  //                                         ...sarsajjanshaktiList.map((item) {
  //                                           return TableRow(
  //                                             children: [
  //                                               Center(
  //                                                   child: Checkbox(
  //                                                 materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
  //                                                 value: selectedSajjanshaktiItems.any((x) => x.pkid == item.pkid),
  //                                                 onChanged: (val) {
  //                                                   set(() {
  //                                                     if (val == true) {
  //                                                       selectedSajjanshaktiItems.add(item);
  //                                                     } else {
  //                                                       selectedSajjanshaktiItems.removeWhere((x) => x.pkid == item.pkid);
  //                                                     }
  //                                                   });
  //                                                   selectedSajjanshaktiItemsIds = selectedSajjanshaktiItems.map((e) => e.pkid.toString()).join(",");
  //                                                   // String anyaIds = selectedAnyaprabhavi.map((e) => e.pkId.toString()).join(",");
  //                                                   log(selectedSajjanshaktiItemsIds.toString());
  //                                                   log("-----------------------------");
  //                                                   // log(anyaIds);
  //
  //                                                   // onSubmit(sajIds, anyaIds, selectedSajjanshakti, selectedAnyaprabhavi);
  //                                                   set(() {});
  //                                                 },
  //                                               )),
  //                                               Padding(
  //                                                 padding: const EdgeInsets.all(8),
  //                                                 child: Text(item.name ?? "Unknown"),
  //                                               ),
  //                                             ],
  //                                           );
  //                                         }),
  //                                       ],
  //                                     ),
  //                                   ),
  //
  //                                   const SizedBox(height: 12),
  //
  //                                   /// Anya Prabhavi Lok
  //                                   Text(
  //                                     Statics.getLabel('anyaPrabhaviLok'),
  //                                     style: const TextStyle(
  //                                       fontWeight: FontWeight.w600,
  //                                       fontSize: 16,
  //                                       color: Colors.blueGrey,
  //                                     ),
  //                                   ),
  //                                   const Divider(),
  //                                   Container(
  //                                     decoration: BoxDecoration(
  //                                       border: Border.all(color: Colors.black12),
  //                                       borderRadius: BorderRadius.circular(12),
  //                                       color: Colors.white,
  //                                     ),
  //                                     child: Table(
  //                                       border: TableBorder.symmetric(
  //                                         inside: const BorderSide(color: Colors.black12),
  //                                       ),
  //                                       columnWidths: const {
  //                                         0: FixedColumnWidth(50),
  //                                       },
  //                                       children: [
  //                                         // Header
  //                                         TableRow(
  //                                           decoration: BoxDecoration(
  //                                             color: Colors.blue.shade50,
  //                                           ),
  //                                           children: [
  //                                             Padding(
  //                                               padding: EdgeInsets.all(8),
  //                                               child: Text("✔", style: TextStyle(fontWeight: FontWeight.bold)),
  //                                             ),
  //                                             Padding(
  //                                               padding: EdgeInsets.all(8),
  //                                               child: Text(Statics.getLabel("Name"), style: TextStyle(fontWeight: FontWeight.bold)),
  //                                             ),
  //                                           ],
  //                                         ),
  //                                         ...sanyaprabhaviList.map((item) {
  //                                           return TableRow(
  //                                             children: [
  //                                               Center(
  //                                                   child: Checkbox(
  //                                                 materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
  //                                                 value: selectedAnyaprabhaviItems.any((x) => x.pkId == item.pkId),
  //                                                 onChanged: (val) {
  //                                                   set(() {
  //                                                     if (val == true) {
  //                                                       selectedAnyaprabhaviItems.add(item);
  //                                                     } else {
  //                                                       selectedAnyaprabhaviItems.removeWhere((x) => x.pkId == item.pkId);
  //                                                     }
  //                                                   });
  //                                                   // String sajIds = selectedSajjanshakti.map((e) => e.pkid.toString()).join(",");
  //                                                   selectedAnyaprabhaviItemsIds = selectedAnyaprabhaviItems.map((e) => e.pkId.toString()).join(",");
  //
  //                                                   // onSubmit(sajIds, anyaIds, selectedSajjanshakti, selectedAnyaprabhavi);
  //                                                   // log(sajIds);
  //                                                   log(selectedAnyaprabhaviItemsIds.toString());
  //                                                   set(() {});
  //                                                 },
  //                                               )),
  //                                               Padding(
  //                                                 padding: const EdgeInsets.all(8),
  //                                                 child: Text(item.name ?? "Unknown"),
  //                                               ),
  //                                             ],
  //                                           );
  //                                         }),
  //                                       ],
  //                                     ),
  //                                   ),
  //                                 ],
  //                               ),
  //                             ),
  //                           ),
  //                           SizedBox(height: 12),
  //                           Row(
  //                             children: [
  //                               Expanded(
  //                                 child: ElevatedButton(
  //                                   style: ElevatedButton.styleFrom(
  //                                     backgroundColor: Colors.purpleAccent,
  //                                     shape: RoundedRectangleBorder(
  //                                       borderRadius: BorderRadius.circular(12),
  //                                     ),
  //                                   ),
  //                                   onPressed: () async {
  //                                     set(() {});
  //                                     Navigator.pop(ctx);
  //                                     setState(() {});
  //                                   },
  //                                   child: Text(
  //                                     Statics.getLabel('Submit'),
  //                                     style: const TextStyle(color: Colors.white),
  //                                   ),
  //                                 ),
  //                               ),
  //                             ],
  //                           ),
  //                           SizedBox(height: 24),
  //                         ],
  //                       ),
  //                     ),
  //                   )
  //                 ],
  //               ),
  //             ),
  //           );
  //         },
  //       );
  //     },
  //   );
  // }

  Widget vaktaTable() {
    return Column(
      spacing: 12,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: InkWell(
            borderRadius: BorderRadius.circular(15),
            onTap: showAddVaktaDialogBox,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
              decoration: BoxDecoration(border: Border.all(color: Colors.purpleAccent.shade100), borderRadius: BorderRadius.circular(15)),
              child: Text(
                "${Statics.getLabel('addVakta')}",
                style: const TextStyle(color: Colors.purpleAccent, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        Container(
          width: double.infinity,
          constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * 0.4),
          padding: EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black54),
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          // width: MediaQuery.of(context).size.width,
          child: DataTable(
            columnSpacing: 12,
            // // dataRowMinHeight: 30,
            // // dataRowMaxHeight: 70,
            showCheckboxColumn: false,
            headingRowColor: MaterialStatePropertyAll(Colors.purple.shade50),
            headingTextStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
            columns: [
              // if (!isAbhiyaanButPramukh) DataColumn(label: SizedBox()),
              DataColumn(
                  label: Text(
                "${Statics.getLabel('serialNo')}",
              )),
              DataColumn(
                  label: Text(
                "${Statics.getLabel('Name')}",
              )),
              DataColumn(
                  label: Text(
                "${Statics.getLabel('Daayitva')}",
              )),
            ],
            rows: vaktaList.where((e) => e.isactive == 1).toList().asMap().entries.map((entry) {
              int index = entry.key;
              var data = entry.value;
              bool isSelected = selectedVaktaIndex == index;
              return DataRow(
                  selected: isSelected,
                  color: MaterialStateProperty.resolveWith<Color?>(
                    (Set<MaterialState> states) {
                      if (isSelected) return Colors.yellow.shade100;
                      return null;
                    },
                  ),
                  onSelectChanged: (value) {
                    if (value != null && value) {
                      setState(() {
                        selectedVaktaIndex = index;
                      });
                    } else {
                      setState(() {
                        selectedVaktaIndex = null;
                      });
                    }
                    // if (!_markAtt) {
                    //   return;
                    // }
                    // if (!isAbhiyaanButPramukh) {
                    //   return;
                    // }
                    // if (gruhAbhiyaanVruttaData!.abhiyaandata!.ishide) {
                    //   return;
                    // }
                    // if ((data.isdefault == 1)) {
                    //   return;
                    // }
                    // if (!isSelected) {
                    //   setState(() {
                    //     // selectedKaryakartaList.add(data);
                    //     data.isSelected = true;
                    //     _selectedVaktaList.add(data);
                    //   });
                    // } else {
                    //   setState(() {
                    //     data.isSelected = false;
                    //     // selectedKaryakartaList.add(data);
                    //     _selectedVaktaList.remove(data);
                    //   });
                    // }
                    // setState(() {
                    //   // samparkaSahabhagiController.text = gruhAbhiyaanToliList.where((e) => e.isdefault == 1 || e.isSelected).length.toString();
                    // });
                    // log(_selectedVaktaList.map((e) => e.swayamsevakID.toString()).join(','));
                  },
                  cells: [
                    // if (!isAbhiyaanButPramukh) DataCell(Icon(isSelected ? Icons.check_box_rounded : Icons.check_box_outline_blank_rounded, color: Colors.yellow.shade900, size: 21)),
                    DataCell(Text("${index + 1}.")),
                    DataCell(Container(constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width * 0.4), child: Text(data.name ?? ''))),
                    DataCell(Text(data.daayitva ?? "--")),
                    // DataCell(Text(Statics.getLabel(data.daayitva.toString(), returnKey: true))),
                  ]);
            }).toList(),
          ),
        ),
        // if (isAbhiyaanButKaryavah)
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            InkWell(
              onTap: () {
                if (selectedVaktaIndex != null) {
                  var selectedData = vaktaList[selectedVaktaIndex!];
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        backgroundColor: Colors.white,
                        title: Center(
                          child: Text(
                            "${Statics.getLabel('sanmelanVakta')}",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.purpleAccent,
                            ),
                          ),
                        ),
                        content: SingleChildScrollView(
                          child: Column(
                            spacing: 8,
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Divider(thickness: 1, color: Colors.deepPurple.shade100),
                              SizedBox(height: 4),
                              _buildInfoRow("${Statics.getLabel('Name')}", selectedData.name),
                              _buildInfoRow("${Statics.getLabel('Daayitva')}", selectedData.daayitva),
                              // SizedBox(),
                              // _buildInfoRow("${Statics.getLabel('sanmelanVaktaTask')}", selectedData.fksadbhavbaithakmasterid.toString()),
                            ],
                          ),
                        ),
                        actionsAlignment: MainAxisAlignment.center,
                        actions: [
                          ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text("${Statics.getLabel('bandKara')}", style: TextStyle(color: Colors.white)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.purpleAccent,
                              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: Icon(Icons.remove_red_eye, color: Colors.green, size: 20),
            ),
            SizedBox(width: 20),
            InkWell(
              onTap: () {
                if (selectedVaktaIndex != null) {
                  txtVaktaNameController.text = vaktaList[selectedVaktaIndex!].name ?? "--";
                  txtVaktaTaskController.text = (vaktaList[selectedVaktaIndex!].daayitva ?? "--").toString();
                  showAddVaktaDialogBox(fromEditing: true);
                }
              },
              child: Icon(Icons.edit, color: Colors.blue, size: 20),
            ),
            SizedBox(width: 20),
            InkWell(
              onTap: () async {
                if (selectedVaktaIndex != null) {
                  final shouldDelete = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      backgroundColor: Colors.white,
                      title: Center(
                        child: Text(
                          "${Statics.getLabel('pusthikarn')}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.redAccent,
                          ),
                        ),
                      ),
                      content: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Text(
                          "${Statics.getLabel('deleteconfirmText')}",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      actionsAlignment: MainAxisAlignment.spaceEvenly,
                      actions: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey.shade300,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () => Navigator.pop(context, false),
                          child: Text(
                            "${Statics.getLabel('ConfirmationNo')}",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () => Navigator.pop(context, true),
                          child: Text(
                            "${Statics.getLabel('ConfirmationYes')}",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  );
                  if (shouldDelete == true) {
                    setState(() {
                      vaktaList[selectedVaktaIndex!].isactive = 0;
                      selectedVaktaIndex = null;
                    });
                  }
                }
              },
              child: Icon(Icons.delete, color: Colors.red, size: 20),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoRow(String title, String? value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 5,
          child: Text(
            "$title : ",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: Colors.purpleAccent,
            ),
          ),
        ),
        Expanded(
          flex: 7,
          child: Text(
            value ?? "—",
            style: TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }

  showAddVaktaDialogBox({bool fromEditing = false}) {
    if (!_searched) {
      Fluttertoast.showToast(msg: "${Statics.getLabel('NagarSelectionImportant')}");
      return;
    }
    if (!fromEditing) {
      txtVaktaNameController.clear();
      txtVaktaTaskController.clear();
    }
    return showDialog(
      context: context,
      builder: (ct) {
        return StatefulBuilder(builder: (ctx, set) {
          return Dialog(
            surfaceTintColor: Colors.transparent,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            // contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            insetPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 16),
            // titlePadding: const EdgeInsets.fromLTRB(20, 20, 12, 0),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14),
              child: Column(
                spacing: 8,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "${Statics.getLabel('sanmelanVakta')}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.purpleAccent,
                    ),
                  ),
                  // SizedBox(height: 4),
                  Divider(thickness: 1, color: Colors.deepPurple.shade100),
                  SizedBox(height: 4),
                  textControllerField2(
                    name: Statics.getLabel("sanmelanVaktaName"),
                    controller: txtVaktaNameController,
                    keyboardType: TextInputType.name,
                  ),
                  textControllerField2(
                    name: Statics.getLabel("Daayitva"),
                    controller: txtVaktaTaskController,
                    keyboardType: TextInputType.name,
                  ),

                  SizedBox(height: 12),
                  if (_daayitvaFor != null)
                    DropdownButtonFormField<StaticMasterBAL>(
                      decoration: InputDecoration(labelText: Statics.getLabel('SelectDaayitvaFor')),
                      isExpanded: true,
                      value: _daayitvaForValue == null ? null : _daayitvaForValue,
                      items: _daayitvaFor!.map((bg) => DropdownMenuItem(value: bg, child: Text(bg.codeForDisplay!))).toList(),
                      onChanged: (value) {
                        set(() {
                          _daayitvaForValue = value;
                        });
                        print(_daayitvaForValue!.ViewOnly);
                      },
                      validator: (value) {
                        if (value == null) return (Statics.getLabel('DaayitvaForValidationMessage'));
                        return null;
                      },
                      onSaved: (value) {
                        swDaayitva!.daayitvaFor = value!.staticID;
                        print("field SelectDaayitvaFor :--${value.staticID}");
                      },
                    ),
                  if (_daayitvaForValue != null)
                    if (_daayitvaForValue!.code == "Aayaam")
                      Column(
                        children: [
                          SizedBox(height: 10),
                          DropdownButtonFormField(
                            decoration: InputDecoration(labelText: Statics.getLabel('SelectAayaam')),
                            isExpanded: true,
                            value: _aayaamValue == "" ? null : _aayaamValue,
                            items: _aayam!.map((bg) => DropdownMenuItem(value: bg.aayaamID.toString(), child: Text(bg.aayaamName!))).toList(),
                            onChanged: (value) {
                              set(() {
                                _aayaamValue = value;
                              });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) return (Statics.getLabel('AayaamVaidationMessage'));
                              return null;
                            },
                            onSaved: (value) {
                              if (value != null && value.isNotEmpty) {
                                swDaayitva!.aayaamID = int.parse(value);
                                print("field SelectAayaam :--${value}");
                              } else {
                                swDaayitva!.aayaamID = null;
                              }
                            },
                          ),
                        ],
                      )
                    else if (_daayitvaForValue!.code == "Gatividhi")
                      Column(
                        children: [
                          SizedBox(height: 10),
                          DropdownButtonFormField(
                            decoration: InputDecoration(labelText: Statics.getLabel('SelectGatividhi')),
                            isExpanded: true,
                            value: _gatividhiValue == "" ? null : _gatividhiValue,
                            items: _gatividhi!.map((bg) => DropdownMenuItem(value: bg.gatividhiID.toString(), child: Text(bg.gatividhiName!))).toList(),
                            onChanged: (value) {
                              set(() {
                                _gatividhiValue = value;
                              });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) return (Statics.getLabel('GaitividhiVaidationMessage'));
                              return null;
                            },
                            onSaved: (value) {
                              if (value != null && value.isNotEmpty) {
                                swDaayitva!.gatividhiID = int.parse(value);
                                print("field SelectGatividhi :--${value}");
                              } else {
                                swDaayitva!.gatividhiID = null;
                              }
                            },
                          ),
                        ],
                      ),
                  if (_daayitvaForValue != null)
                    if (_daayitvaForValue!.code == "SanghaPreritSansthaa")
                      Column(
                        children: [
                          SizedBox(height: 10),
                          // Legend(
                          //     legendString: 'Sangha-PreritSansthaa',
                          //     fontsize: 18),
                          DropdownButtonFormField<dynamic>(
                            decoration: InputDecoration(labelText: Statics.getLabel('SansthaaName')),
                            isExpanded: true,
                            value: _preritSansthaValue == "" ? null : _preritSansthaValue,
                            items: _sanghaPreritSanstha!.map((bg) => DropdownMenuItem(value: bg["SanghaPreritSansthaaID"].toString(), child: Text(bg["SansthaaName"]))).toList(),
                            onChanged: (value) {
                              set(() {
                                _preritSansthaValue = value;
                              });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) return (Statics.getLabel('SansthaaValidationMessage'));
                              return null;
                            },
                            onSaved: (value) {
                              if (value != null && value.isNotEmpty) {
                                swDaayitva!.sanghaPreritSansthaaID = int.parse(value);
                                print("field SansthaaName sanghaPreritSansthaaID :--${swDaayitva!.sanghaPreritSansthaaID}");
                              } else
                                swDaayitva!.sanghaPreritSansthaaID = null;
                            },
                          ),
                        ],
                      ),
                  if (_daayitvaForValue != null)
                    if (_daayitvaForValue!.code == "OtherSocialOrganization")
                      Column(
                        children: [
                          SizedBox(height: 10),
                          // Legend(
                          //     legendString:
                          //         'OtherSocialOrganization',
                          //     fontsize: 18),
                          TextFormField(
                            textInputAction: TextInputAction.next,
                            controller: _othOrgNameCtrl,
                            decoration: InputDecoration(labelText: Statics.getLabel('SansthaaName')),
                            keyboardType: TextInputType.text,
                            validator: (value) {
                              if (value == null || value.isEmpty) return (Statics.getLabel('DesignationValidationMessage'));
                              return null;
                            },
                            onSaved: (value) {
                              if (value != null && value.isNotEmpty) {
                                swDaayitva!.otherSocialOrganizationName = value;
                                print("field SansthaaName otherSocialOrganizationName :--${swDaayitva!.sanghaPreritSansthaaID}");
                              } else
                                swDaayitva!.otherSocialOrganizationName = null;
                            },
                          ),
                        ],
                      ),
                  SizedBox(height: 12),

                  // textControllerField2(
                  //   name: Statics.getLabel("sanmelanVaktaTask"),
                  //   controller: txtVaktaTaskController,
                  //   keyboardType: TextInputType.name,
                  // ),
                  SizedBox(height: 4),
                  Row(
                    spacing: 12,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purpleAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        ),
                        onPressed: () async {
                          vaktaList.add(NamesList(pkid: 0, name: txtVaktaNameController.text.trim(), daayitva: txtVaktaTaskController.text.trim(), fksadbhavbaithakmasterid: 0, isactive: 1));
                          txtVaktaNameController.clear();
                          txtVaktaTaskController.clear();
                          // Statics.showToast(Statics.getLabel("workInProgress"));
                          Navigator.pop(ctx);
                          // await addToToliListFun();
                        },
                        child: Text(
                          Statics.getLabel('Submit'),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      if (fromEditing)
                        MaterialButton(
                          onPressed: () async {
                            txtVaktaNameController.clear();
                            txtVaktaTaskController.clear();
                            Navigator.pop(ct);
                            // await populateDropdown(isClear: true);
                          },
                          child: Text(
                            Statics.getLabel('clear'),
                          ),
                        ),
                    ],
                  )
                ],
              ),
            ),
          );
        });
      },
    );
  }

  Widget daayitvaTypes() {
    return Column(
      children: [
        if (_daayitvaFor != null)
          DropdownButtonFormField<StaticMasterBAL>(
            decoration: InputDecoration(labelText: Statics.getLabel('SelectDaayitvaFor')),
            isExpanded: true,
            value: _daayitvaForValue == null ? null : _daayitvaForValue,
            items: _daayitvaFor!.map((bg) => DropdownMenuItem(value: bg, child: Text(bg.codeForDisplay!))).toList(),
            onChanged: (value) {
              setState(() {
                _daayitvaForValue = value;
              });
              print(_daayitvaForValue!.ViewOnly);
            },
            validator: (value) {
              if (value == null) return (Statics.getLabel('DaayitvaForValidationMessage'));
              return null;
            },
            onSaved: (value) {
              swDaayitva!.daayitvaFor = value!.staticID;
              print("field SelectDaayitvaFor :--${value.staticID}");
            },
          ),
        if (_daayitvaForValue != null)
          if (_daayitvaForValue!.code == "Aayaam")
            Column(
              children: [
                SizedBox(height: 10),
                DropdownButtonFormField(
                  decoration: InputDecoration(labelText: Statics.getLabel('SelectAayaam')),
                  isExpanded: true,
                  value: _aayaamValue == "" ? null : _aayaamValue,
                  items: _aayam!.map((bg) => DropdownMenuItem(value: bg.aayaamID.toString(), child: Text(bg.aayaamName!))).toList(),
                  onChanged: (value) {
                    setState(() {
                      _aayaamValue = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) return (Statics.getLabel('AayaamVaidationMessage'));
                    return null;
                  },
                  onSaved: (value) {
                    if (value != null && value.isNotEmpty) {
                      swDaayitva!.aayaamID = int.parse(value);
                      print("field SelectAayaam :--${value}");
                    } else {
                      swDaayitva!.aayaamID = null;
                    }
                  },
                ),
              ],
            )
          else if (_daayitvaForValue!.code == "Gatividhi")
            Column(
              children: [
                SizedBox(height: 10),
                DropdownButtonFormField(
                  decoration: InputDecoration(labelText: Statics.getLabel('SelectGatividhi')),
                  isExpanded: true,
                  value: _gatividhiValue == "" ? null : _gatividhiValue,
                  items: _gatividhi!.map((bg) => DropdownMenuItem(value: bg.gatividhiID.toString(), child: Text(bg.gatividhiName!))).toList(),
                  onChanged: (value) {
                    setState(() {
                      _gatividhiValue = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) return (Statics.getLabel('GaitividhiVaidationMessage'));
                    return null;
                  },
                  onSaved: (value) {
                    if (value != null && value.isNotEmpty) {
                      swDaayitva!.gatividhiID = int.parse(value);
                      print("field SelectGatividhi :--${value}");
                    } else {
                      swDaayitva!.gatividhiID = null;
                    }
                  },
                ),
              ],
            ),
        if (_daayitvaForValue != null)
          if (_daayitvaForValue!.code == "SanghaPreritSansthaa")
            Column(
              children: [
                // Legend(
                //     legendString: 'Sangha-PreritSansthaa',
                //     fontsize: 18),
                DropdownButtonFormField<dynamic>(
                  decoration: InputDecoration(labelText: Statics.getLabel('SansthaaName')),
                  isExpanded: true,
                  value: _preritSansthaValue == "" ? null : _preritSansthaValue,
                  items: _sanghaPreritSanstha!.map((bg) => DropdownMenuItem(value: bg["SanghaPreritSansthaaID"].toString(), child: Text(bg["SansthaaName"]))).toList(),
                  onChanged: (value) {
                    setState(() {
                      _preritSansthaValue = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) return (Statics.getLabel('SansthaaValidationMessage'));
                    return null;
                  },
                  onSaved: (value) {
                    if (value != null && value.isNotEmpty) {
                      swDaayitva!.sanghaPreritSansthaaID = int.parse(value);
                      print("field SansthaaName sanghaPreritSansthaaID :--${swDaayitva!.sanghaPreritSansthaaID}");
                    } else
                      swDaayitva!.sanghaPreritSansthaaID = null;
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  textInputAction: TextInputAction.next,
                  controller: _preritDesgCtrl,
                  decoration: InputDecoration(labelText: Statics.getLabel('Designation')),
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value == null || value.isEmpty) return (Statics.getLabel('DesignationValidationMessage'));
                    return null;
                  },
                  onSaved: (value) {
                    if (value != null && value.isNotEmpty) {
                      swDaayitva!.sanghaPreritSansthaaDesignation = value;
                      print("field SansthaaName sanghaPreritSansthaaDesignation :--${swDaayitva!.sanghaPreritSansthaaID}");
                    } else
                      swDaayitva!.sanghaPreritSansthaaDesignation = null;
                  },
                ),
                TextFormField(
                  textInputAction: TextInputAction.next,
                  controller: _preritRemarkCtrl,
                  decoration: InputDecoration(labelText: Statics.getLabel('Remarks')),
                  keyboardType: TextInputType.text,
                  onSaved: (value) {
                    if (value != null && value.isNotEmpty)
                      swDaayitva!.sanghaPreritSansthaaRemark = value;
                    else
                      swDaayitva!.sanghaPreritSansthaaRemark = null;
                  },
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
        if (_daayitvaForValue != null)
          if (_daayitvaForValue!.code == "OtherSocialOrganization")
            Column(
              children: [
                // Legend(
                //     legendString:
                //         'OtherSocialOrganization',
                //     fontsize: 18),
                TextFormField(
                  textInputAction: TextInputAction.next,
                  controller: _othOrgNameCtrl,
                  decoration: InputDecoration(labelText: Statics.getLabel('SansthaaName')),
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value == null || value.isEmpty) return (Statics.getLabel('DesignationValidationMessage'));
                    return null;
                  },
                  onSaved: (value) {
                    if (value != null && value.isNotEmpty) {
                      swDaayitva!.otherSocialOrganizationName = value;
                      print("field SansthaaName otherSocialOrganizationName :--${swDaayitva!.sanghaPreritSansthaaID}");
                    } else
                      swDaayitva!.otherSocialOrganizationName = null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  textInputAction: TextInputAction.next,
                  controller: _othDesgCtrl,
                  decoration: InputDecoration(labelText: Statics.getLabel('Designation')),
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value == null || value.isEmpty) return (Statics.getLabel('OrganizationNameValidationMessage'));
                    return null;
                  },
                  onSaved: (value) {
                    if (value != null && value.isNotEmpty)
                      swDaayitva!.otherSocialOrganizationDesignation = value;
                    else
                      swDaayitva!.otherSocialOrganizationDesignation = null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  textInputAction: TextInputAction.next,
                  controller: _othRemarksCtrl,
                  decoration: InputDecoration(labelText: Statics.getLabel('Remarks')),
                  keyboardType: TextInputType.text,
                  onSaved: (value) {
                    if (value != null && value.isNotEmpty)
                      swDaayitva!.otherSocialOrganizationRemark = value;
                    else
                      swDaayitva!.otherSocialOrganizationRemark = null;
                  },
                ),
                SizedBox(height: 20),
              ],
            ),
      ],
    );
  }

  Widget textControllerField2({
    required String name,
    required TextEditingController controller,
    double height = 50.0,
    TextInputType keyboardType = TextInputType.text,
    bool isEdit = false,
    String? hintTextString,
    String? imp,
    int? maxInput,
    bool isTextBold = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: name,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: isTextBold ? FontWeight.bold : FontWeight.normal,
                  color: Colors.black,
                ),
              ),
              TextSpan(
                text: imp,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 5),
        SizedBox(
          height: height,
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            inputFormatters: keyboardType == TextInputType.number ? [FilteringTextInputFormatter.allow(RegExp(r'^[0-9]*$'))] : [],
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              filled: true,
              fillColor: Colors.white,
              hintText: hintTextString,
            ),
            readOnly: isEdit || !_searched,
            maxLength: maxInput,
            onTap: () {
              if (!_searched) {
                Fluttertoast.showToast(
                  msg: "${Statics.getLabel('NagarSelectionImportant')}",
                );
              }
            },
            buildCounter: (context, {int? currentLength, int? maxLength, bool? isFocused}) => null,
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget mainContainer(String header, Widget child) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        // padding: EdgeInsets.all(10),
        decoration: BoxDecoration(border: Border.all(color: Colors.purpleAccent), borderRadius: BorderRadius.all(Radius.circular(10))),

        padding: EdgeInsets.symmetric(
          vertical: size.height * 0.01,
          horizontal: size.width * 0.03,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              header,
              style: TextStyle(
                color: Colors.purpleAccent,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            Divider(color: Colors.black87, thickness: 1),
            SizedBox(
              height: 10,
            ),
            // Container(margin: giveChildPadding ? EdgeInsets.symmetric(horizontal: size.width * 0.03) : null, child: child),
            child,
          ],
        ),
      ),
    );
  }

  Future<void> showPersonDetailsPopup(BuildContext context, dynamic item, int srNo) {
    List<Map<String, String>> details = [];

    // Agar Vastisarsajjanshakti ka object aaya
    if (item is Vastisarsajjanshakti) {
      details = [
        {"${Statics.getLabel('Vasti')} :": item.vastiname ?? ""},
        {"${Statics.getLabel('Name')} :": item.name ?? ""},
        {"${Statics.getLabel('Address')} :": item.address ?? ""},
        {"${Statics.getLabel('mobileNumberLabel')} :": item.doorabhaash ?? ""},
        {"${Statics.getLabel('shreni')}  :": item.selectedDropdownValueName ?? ""},
        {"${Statics.getLabel('OrganizationName')}  :": item.sanstheCheNaav ?? ""},
        {"${Statics.getLabel('sansthetKuthalaPadavar')}   :": item.sansthechaKuthalaPadavar ?? ""},
        {"${Statics.getLabel('samparkSthiti')}  :": item.selectedDropdownValueName1 ?? ""},
        {"${Statics.getLabel('special')} :": item.visheshname ?? ""},
        {"${Statics.getLabel('prabhavKshetra')} :": item.prabhaavkshetrName ?? ""},
        {"${Statics.getLabel('samparkSootraNaav')} :": item.samparkasutranava ?? ""},
        {"${Statics.getLabel('samparakSootraDoorbhash')} :": item.samparkasutraMobileNumber ?? ""},
      ];
    }

    // Agar Vastisanyaprabhavi ka object aaya
    else if (item is Vastisanyaprabhavi) {
      details = [
        {"${Statics.getLabel('Vasti')}  :": item.vastiName ?? ""},
        {"${Statics.getLabel('Name')} :": item.name ?? ""},
        {"${Statics.getLabel('Address')}:": item.address ?? ""},
        {"${Statics.getLabel('mobileNumberLabel')} :": item.doorabhaash ?? ""},
        {"${Statics.getLabel('shreni')}  :": item.shreneeName ?? ""},
        {"${Statics.getLabel('upshreni')} :": item.upshreneeName ?? ""},
        {"${Statics.getLabel('otherUpshreni')}  :": item.otherUpshrenee ?? ""},
        {"${Statics.getLabel('upshreni')}2 :": item.upshrenee2Name ?? ""},
        {"${Statics.getLabel('otherUpshreni')}2 :": item.otherUpshrenee2 ?? ""},
        {"${Statics.getLabel('special')}  :": item.visheshName ?? ""},
        {"${Statics.getLabel('prabhavKshetra')} :": item.prabhaavKshetreName ?? ""},
        {"${Statics.getLabel('other')} ${Statics.getLabel('special')}  :": item.anyaVishesMahiti ?? ""},
        {"${Statics.getLabel('samparkStithi')} :": item.samparkSthit ?? ""},
        {"${Statics.getLabel('samparkSootraNaav')} :": item.samparkAsutraNav ?? ""},
        {"${Statics.getLabel('samparakSootraDoorbhash')} :": item.samparkaSutraDoorbhash ?? ""},
      ];
    }

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
                // 🔹 Header with gradient
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
                        "${Statics.getLabel('PersonalDetails')}",
                        style: TextStyle(
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

                // 🔹 Details List
                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: details
                          .map(
                            (e) => Container(
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Text(
                                      e.keys.first,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 5,
                                    child: Text(
                                      e.values.first.isEmpty ? "-" : e.values.first,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                // 🔹 Footer Button
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
                      style: TextStyle(fontSize: 16, color: Colors.white),
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

// Widget vastiMandalDropdown() {
//   return Container(
//     // margin: EdgeInsets.symmetric(horizontal: 20),
//     decoration: BoxDecoration(
//       borderRadius: BorderRadius.circular(5),
//       border: Border.all(width: 0.7, color: Colors.grey.shade700),
//     ),
//     child: ExpansionPanelList(
//       elevation: 0,
//       expandedHeaderPadding: EdgeInsets.zero,
//       expansionCallback: (int index, bool isExpanded) {
//         setState(() {
//           _isExpanded = isExpanded;
//         });
//       },
//       children: [
//         ExpansionPanel(
//           backgroundColor: Colors.transparent,
//           headerBuilder: (BuildContext context, bool isExpanded) {
//             return ListTile(
//               title: Text(
//                 "${Statics.getLabel('selectVastiMandal')}",
//                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
//               ),
//             );
//           },
//           body: Container(
//             margin: EdgeInsets.all(10),
//             child: Column(
//               children: [
//                 if (_linkedMahaanagar != null)
//                   _buildDropdownField(
//                     label: Statics.getLabel('Mahaanagar'),
//                     value: _linkedMahaanagarValue,
//                     items: _linkedMahaanagar!
//                         .map((bg) => DropdownMenuItem(
//                               value: bg.geoUnitID.toString(),
//                               child: Text(bg.name!),
//                             ))
//                         .toList(),
//                     onChanged: (value) async {
//                       final selectedItem = _linkedMahaanagar!.firstWhere((bg) => bg.geoUnitID.toString() == value);
//                       setState(() {
//                         _linkedMahaanagarValue = value;
//                         _linkedVibhaagValue = null;
//                         _selctedLevel = 'Mahanagar';
//                         _selctedLevelName = selectedItem.name ?? "";
//                         _selectedGeoUnitId = value;
//                         // _linkedMahaanagarName = selectedItem.name ?? "";
//                         // _resetLinkedValues();
//                       });
//                       populatelinkedVibhaagDropdown(value!);
//                       populatelinkedBhaagDropdown("");
//                     },
//                     isDisabled: false,
//                   ),
//                 if (_linkedVibhaag != null)
//                   _buildDropdownField(
//                     label: Statics.getLabel('Vibhaag'),
//                     value: _linkedVibhaagValue,
//                     items: _linkedVibhaag!
//                         .map((bg) => DropdownMenuItem(
//                               value: bg.geoUnitID.toString(),
//                               child: Text(bg.name!),
//                             ))
//                         .toList(),
//                     onChanged: (value) {
//                       final selectedItem = _linkedVibhaag!.firstWhere((bg) => bg.geoUnitID.toString() == value);
//                       setState(() {
//                         _linkedVibhaagValue = value;
//                         _selctedLevel = 'Vibhaag';
//                         _selctedLevelName = selectedItem.name ?? "";
//                         _selectedGeoUnitId = value;
//                         // _linkedVibhaagName = selectedItem.name ?? "";
//                       });
//                       populatelinkedBhaagDropdown(value!);
//                     },
//                     isDisabled: false,
//                   ),
//                 if (_linkedbhaag != null && _linkedbhaag!.isNotEmpty)
//                   _buildDropdownField(
//                     label: Statics.getLabel('Bhaag'),
//                     value: _linkedbhaagValue,
//                     items: _linkedbhaag!
//                         .map((bg) => DropdownMenuItem(
//                               value: bg.geoUnitID.toString(),
//                               child: Text(bg.name!),
//                             ))
//                         .toList(),
//                     onChanged: (value) {
//                       final selectedItem = _linkedbhaag!.firstWhere((bg) => bg.geoUnitID.toString() == value);
//                       setState(() {
//                         _linkedbhaagValue = value;
//                         _selctedLevel = 'Bhaag';
//                         _selctedLevelName = selectedItem.name ?? "";
//                         _linkedbhaagName = selectedItem.name ?? "";
//                         _selectedGeoUnitId = value;
//                         populatelinkedShaharDropdown(value!);
//                         populatelinkedNagarDropdown(value, null);
//                       });
//                     },
//                     isDisabled: false,
//                   ),
//                 if (_linkedshahar != null && _linkedshahar!.isNotEmpty)
//                   _buildDropdownField(
//                     label: Statics.getLabel('Shahar'),
//                     value: _linkedshaharValue,
//                     items: _linkedshahar!
//                         .map((bg) => DropdownMenuItem(
//                               value: bg.geoUnitID.toString(),
//                               child: Text(bg.name!),
//                             ))
//                         .toList(),
//                     onChanged: (value) {
//                       final selectedItem = _linkedshahar!.firstWhere((bg) => bg.geoUnitID.toString() == value);
//                       setState(() {
//                         _linkedshaharValue = value;
//                         _selectedGeoUnitId = value;
//                         _selctedLevel = 'Shahar';
//                         _selctedLevelName = selectedItem.name ?? "";
//                         _linkedshaharName = selectedItem.name ?? "";
//                         populatelinkedNagarDropdown(null, value);
//                       });
//                     },
//                     isDisabled: false,
//                   ),
//                 if (_linkednagar != null && _linkednagar!.isNotEmpty)
//                   _buildDropdownField(
//                     label: Statics.getLabel('Nagar'),
//                     value: _linkednagarValue,
//                     items: _linkednagar!
//                         .map((bg) => DropdownMenuItem(
//                               value: bg.geoUnitID.toString(),
//                               child: Text(bg.name!),
//                             ))
//                         .toList(),
//                     onChanged: (value) {
//                       final selectedItem = _linkednagar!.firstWhere((bg) => bg.geoUnitID.toString() == value);
//                       setState(() {
//                         _linkednagarValue = value;
//                         _selectedGeoUnitId = value;
//                         _selctedLevel = 'Nagar';
//                         _selctedLevelName = selectedItem.name ?? "";
//                         _linkednagarName = selectedItem.name ?? "";
//                         populatelinkedMandalDropdown(value);
//                         populatelinkedVastiDropdown(value);
//                       });
//                     },
//                     isDisabled: false,
//                   ),
//                 if (_linkedmandal != null && _linkedmandal!.isNotEmpty)
//                   _buildDropdownField(
//                     label: Statics.getLabel('Mandal'),
//                     value: _linkedmandalValue,
//                     items: _linkedmandal!
//                         .map((bg) => DropdownMenuItem(
//                               value: bg.geoUnitID.toString(),
//                               child: Text(bg.name!),
//                             ))
//                         .toList(),
//                     onChanged: (value) {
//                       final selectedItem = _linkedmandal!.firstWhere((bg) => bg.geoUnitID.toString() == value);
//                       setState(() {
//                         _linkedmandalValue = value;
//                         _selectedGeoUnitId = value.toString();
//                         _selctedLevel = 'Mandal';
//                         _selctedLevelName = selectedItem.name ?? "";
//                         _linkedmandalName = selectedItem.name ?? "";
//                         populatelinkedGraamDropdown(value);
//                       });
//                     },
//                     isDisabled: false,
//                   ),
//                 // if (_linkedgraam != null && _linkedgraam!.isNotEmpty)
//                 //   _buildDropdownField(
//                 //     label: Statics.getLabel('Graam'),
//                 //     value: _linkedgraamValue,
//                 //     items: _linkedgraam!
//                 //         .map((bg) => DropdownMenuItem(
//                 //               value: bg.geoUnitID.toString(),
//                 //               child: Text(bg.name!),
//                 //             ))
//                 //         .toList(),
//                 //     onChanged: (value) {
//                 //       final selectedItem = _linkedgraam!.firstWhere((bg) => bg.geoUnitID.toString() == value);
//                 //       setState(() {
//                 //         _linkedgraamValue = value;
//                 //         _selectedGeoUnitId = value.toString();
//                 //         _selctedLevel = 'Graam';
//                 //         _selctedLevelName = selectedItem.name ?? "";
//                 //         _linkedgraamName = selectedItem.name ?? "";
//                 //       });
//                 //     },
//                 //     isDisabled: false,
//                 //   ),
//                 if (_linkedvasti != null && _linkedvasti!.isNotEmpty)
//                   _buildDropdownField(
//                     label: Statics.getLabel('Vasti'),
//                     value: _linkedvastiValue,
//                     items: _linkedvasti!
//                         .map((bg) => DropdownMenuItem(
//                               value: bg.geoUnitID.toString(),
//                               child: Text(bg.name!),
//                             ))
//                         .toList(),
//                     onChanged: (value) {
//                       final selectedItem = _linkedvasti!.firstWhere((bg) => bg.geoUnitID.toString() == value);
//                       setState(() {
//                         _linkedvastiValue = value;
//                         _selectedGeoUnitId = value.toString();
//                         _selctedLevel = 'Vasti';
//                         _selctedLevelName = selectedItem.name ?? "";
//                         _linkedvastiName = selectedItem.name ?? "";
//                       });
//                     },
//                     isDisabled: false,
//                   ),
//                 SizedBox(height: 15),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     // if ((_linkedgraamValue != "" && _linkedgraamValue != null) || (_linkedvastiValue != "" && _linkedvastiValue != null))
//                     MaterialButton(
//                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
//                       padding: EdgeInsets.symmetric(
//                         horizontal: 35,
//                         vertical: 5,
//                       ),
//                       color: Theme.of(context).primaryColor,
//                       textColor: Theme.of(context).primaryTextTheme.labelMedium?.color,
//                       onPressed: () async {
//                         _selctedLevelNameList = [];
//                         setState(() {});
//                         // _selctedLevelNameList.add(_linkedMahaanagarName);
//                         // _selctedLevelNameList.add(_linkedVibhaagName);
//                         _selctedLevelNameList.add(_linkedbhaagName);
//                         _selctedLevelNameList.add(_linkedshaharName);
//                         _selctedLevelNameList.add(_linkednagarName);
//                         _selctedLevelNameList.add(_linkedmandalName);
//                         _selctedLevelNameList.add(_linkedgraamName);
//                         _selctedLevelNameList.add(_linkedvastiName);
//                         setState(() {});
//
//                         // await _getForm();
//
//                         setState(() {
//                           _selctedLevelNames = _selctedLevelNameList
//                               .where((e) => e != null && e.isNotEmpty) // remove null or empty strings
//                               .cast<String>() // convert from String? to String
//                               .join(' -> ');
//                           _searched = true;
//                           _isExpanded = false;
//                         });
//                       },
//                       child: Text(
//                         "${Statics.getLabel('search')}",
//                         style: TextStyle(fontSize: 16),
//                       ),
//                     ),
//                     MaterialButton(
//                         onPressed: () async {
//                           setState(() {
//                             _searched = false;
//                             _selectedGeoUnitId = null;
//                             _linkedMahaanagarValue = _linkedbhaagValue = _linkedshaharValue = _linkednagarValue = _linkedmandalValue = _linkedvastiValue = _linkedgraamValue = null;
//                             _linkedVibhaagValue = _linkedbhaag = _linkedshahar = _linkedgraam = _linkedmandal = _linkedvasti = _linkednagar = null;
//                             _selctedLevel = "praant";
//                           });
//                           // clearForm();
//                           await populateDropdown();
//                         },
//                         child: Text(Statics.getLabel('clear'))),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           isExpanded: _isExpanded,
//         ),
//       ],
//     ),
//   );
// }
//
// Widget _buildDropdownField({
//   required String label,
//   required String? value,
//   required List<DropdownMenuItem<String>> items,
//   required ValueChanged<String?> onChanged,
//   required bool isDisabled,
// }) {
//   return IgnorePointer(
//     ignoring: isDisabled,
//     child: DropdownButtonFormField(
//       decoration: InputDecoration(labelText: label),
//       isExpanded: true,
//       value: value == "" ? null : value,
//       items: items,
//       onChanged: onChanged,
//     ),
//   );
// }
}
