import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../helpers/static_data.dart' as Statics;
import '../../../models/response_model/vijayaDashamiInitModel.dart';
import '../../../models/response_model/yuva_sangam_vrutta_resp.dart';
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

  TextEditingController txtExpMahaTarunController = TextEditingController();
  TextEditingController txtPresentMahaTarunController = TextEditingController();
  TextEditingController txtExpTaurunProfController = TextEditingController();
  TextEditingController txtPresentTaurunProfController = TextEditingController();
  TextEditingController txtExpYuvaMandalController = TextEditingController();
  TextEditingController txtPresentYuvaMandalController = TextEditingController();
  TextEditingController txtExpProfController = TextEditingController();
  TextEditingController txtPresentProfController = TextEditingController();
  TextEditingController txtExpMahavidController = TextEditingController();
  TextEditingController txtPresentMahavidController = TextEditingController();
  TextEditingController txtExpVastigruhController = TextEditingController();
  TextEditingController txtPresentVastigruhController = TextEditingController();

  List<YuvaaSpeaker> vaktaList = [];
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

  YuvaVruttadata? vruttaData;

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
  int? _aayaamValue;
  int? _gatividhiValue;
  int? _preritSansthaValue;
  List<dynamic>? _sanghaPreritSanstha;
  var _preritDesgCtrl = TextEditingController();
  var _preritRemarkCtrl = TextEditingController();
  var _othOrgNameCtrl = TextEditingController();
  var _othDesgCtrl = TextEditingController();
  var _othRemarksCtrl = TextEditingController();

  int? _pkid;
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
      _pkid = _data["pkid"];
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
    var formData = {
      "id": _pkid,
      "appuserid": int.parse(Statics.userDetails['userID']),
    };
    vruttaData = await Statics.GetYuvaSangamVruttaData(context: context, inputJson: formData, showLoader: true);
    setState(() {});
    if (vruttaData != null) {
      vaktaList = vruttaData?.yuvaaspeaker ?? [];

      txtExpMahaTarunController.text = (vruttaData?.yuvaexpectmaha ?? 0).toString();
      txtPresentMahaTarunController.text = (vruttaData?.yuvapresentmaha ?? 0).toString();
      txtExpTaurunProfController.text = (vruttaData?.yuvaexpecttarun ?? 0).toString();
      txtPresentTaurunProfController.text = (vruttaData?.yuvapresenttarun ?? 0).toString();
      txtExpYuvaMandalController.text = (vruttaData?.yuvaexpectmandal ?? 0).toString();
      txtPresentYuvaMandalController.text = (vruttaData?.yuvapresentmandal ?? 0).toString();
      txtExpProfController.text = (vruttaData?.yuvaexpectpradhyapak ?? 0).toString();
      txtPresentProfController.text = (vruttaData?.yuvapresentpradhyapak ?? 0).toString();
      txtExpMahavidController.text = (vruttaData?.mahaexpectmaha ?? 0).toString();
      txtPresentMahavidController.text = (vruttaData?.mahapresentmaha ?? 0).toString();
      txtExpVastigruhController.text = (vruttaData?.mahaexpectvasti ?? 0).toString();
      txtPresentVastigruhController.text = (vruttaData?.mahapresentvasti ?? 0).toString();

      txtSanmelanFormatController.text = vruttaData?.yuvadesc ?? "";

      _initializeSelectionFromData(vruttaData);

      // _selectedGeoUnitId = vruttaData?.geounitid.toString();
    }
    // data = await Statics.getVijayadashamiInitData(context, Statics.userDetails["userID"], "14255", "6");
    // setState(() {
    //   // Initialize selected items from the preselected list
    //   selectedItems = List.from(data?.shakhaalist ?? []);
    //
    //   // Extract unique categories (e.g., Senior Professionals, etc.)
    //   vayogatOptions = checkboxShakhaSelectedItems.map((e) => e.vayogatname ?? "").where((e) => e.isNotEmpty).toSet().toList();
    // });
  }

  Future<void> submitForm({bool showLoader = true}) async {
    if (txtSanmelanFormatController.text.isEmpty) {
      Statics.showToast(Statics.getLabel("impInfoRequired"));
      return;
    }

    final formData = YuvaVruttadata(
      pkid: _pkid,
      cuserid: int.parse(Statics.userDetails['userID']),
      yuvaexpectmaha: int.tryParse(txtExpMahaTarunController.text) ?? 0,
      yuvapresentmaha: int.tryParse(txtPresentMahaTarunController.text) ?? 0,
      yuvaexpecttarun: int.tryParse(txtExpTaurunProfController.text) ?? 0,
      yuvapresenttarun: int.tryParse(txtPresentTaurunProfController.text) ?? 0,
      yuvaexpectmandal: int.tryParse(txtExpYuvaMandalController.text) ?? 0,
      yuvapresentmandal: int.tryParse(txtPresentYuvaMandalController.text) ?? 0,
      yuvaexpectpradhyapak: int.tryParse(txtExpProfController.text) ?? 0,
      yuvapresentpradhyapak: int.tryParse(txtPresentProfController.text) ?? 0,
      mahaexpectmaha: int.tryParse(txtExpMahavidController.text) ?? 0,
      mahapresentmaha: int.tryParse(txtPresentMahavidController.text) ?? 0,
      mahaexpectvasti: int.tryParse(txtExpVastigruhController.text) ?? 0,
      mahapresentvasti: int.tryParse(txtPresentVastigruhController.text) ?? 0,
      yuvadesc: txtSanmelanFormatController.text.trim(),
      yuvaaspeaker: vaktaList,
      yuvasangampresentmahashaakha: selectedPresentMaha.where((e) => e.geoUnitID != null).map((e) => e.geoUnitID.toString()).join(","),
      yuvasangampresentmahashaakhasankalpit: selectedSankalpitMaha.where((e) => e.geoUnitID != null).map((e) => e.geoUnitID.toString()).join(","),
      yuvasangampresentvartmantarun: selectedPresentTarun.where((e) => e.geoUnitID != null).map((e) => e.geoUnitID.toString()).join(","),
      yuvasangampresentvartmantarunsankalpit: selectedSankalpitTarun.where((e) => e.geoUnitID != null).map((e) => e.geoUnitID.toString()).join(","),
    );

    String formattedJson = const JsonEncoder.withIndent('  ').convert(formData.toJson());
    log("Form Data (JSON):\n$formattedJson");
    await Statics.SaveYuvaSangamVruttaData(context: context, inputJson: formData.toJson(), showLoader: showLoader);
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
                            controller: txtExpMahaTarunController,
                            decoration: InputDecoration(
                              labelText: Statics.getLabel("mahavidya"),
                              labelStyle: const TextStyle(color: Colors.grey, fontSize: 14),
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
                            controller: txtPresentMahaTarunController,
                            decoration: InputDecoration(
                              labelText: Statics.getLabel("mahavidya"),
                              labelStyle: const TextStyle(color: Colors.grey, fontSize: 14),
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
                            controller: txtExpTaurunProfController,
                            decoration: InputDecoration(
                              labelText: '${Statics.getLabel(("TarunVyavasaayee"))} (< 30)',
                              // Replaced 'युवा व्यवसायी (< 3)' placeholder
                              labelStyle: const TextStyle(color: Colors.grey, fontSize: 14),
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
                            controller: txtPresentTaurunProfController,
                            decoration: InputDecoration(
                              labelText: '${Statics.getLabel(("TarunVyavasaayee"))} (< 30)',
                              labelStyle: const TextStyle(color: Colors.grey, fontSize: 14),
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
                            controller: txtExpYuvaMandalController,
                            decoration: InputDecoration(
                              labelText: '${Statics.getLabel(("yuvaMandal"))}',
                              // Replaced 'युवा व्यवसायी (< 3)' placeholder
                              labelStyle: const TextStyle(color: Colors.grey, fontSize: 14),
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
                            controller: txtPresentYuvaMandalController,
                            decoration: InputDecoration(
                              labelText: '${Statics.getLabel(("yuvaMandal"))}',
                              labelStyle: const TextStyle(color: Colors.grey, fontSize: 14),
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
                            controller: txtExpProfController,
                            decoration: InputDecoration(
                              labelText: '${Statics.getLabel(("professor"))}',
                              // Replaced 'प्राध्यापक' placeholder
                              labelStyle: const TextStyle(color: Colors.grey, fontSize: 14),
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
                            controller: txtPresentProfController,
                            decoration: InputDecoration(
                              labelText: '${Statics.getLabel(("professor"))}',
                              labelStyle: const TextStyle(color: Colors.grey, fontSize: 14),
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
                            controller: txtExpMahavidController,
                            decoration: InputDecoration(
                              labelText: Statics.getLabel("schools"),
                              labelStyle: const TextStyle(color: Colors.grey, fontSize: 14),
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
                            controller: txtPresentMahavidController,
                            decoration: InputDecoration(
                              labelText: Statics.getLabel("schools"),
                              labelStyle: const TextStyle(color: Colors.grey, fontSize: 14),
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
                            controller: txtExpVastigruhController,
                            decoration: InputDecoration(
                              labelText: '${Statics.getLabel(("vastigruh"))}',
                              // Replaced 'युवा व्यवसायी (< 3)' placeholder
                              labelStyle: const TextStyle(color: Colors.grey, fontSize: 14),
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
                            controller: txtPresentVastigruhController,
                            decoration: InputDecoration(
                              labelText: '${Statics.getLabel(("vastigruh"))}',
                              labelStyle: const TextStyle(color: Colors.grey, fontSize: 14),
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

                    // ✅ Two ExpansionTiles: one for Maha, one for Tarun
                    ...() {
                      // Define the two groups from the separated lists
                      final groups = [
                        {
                          'label': Statics.getLabel("shakhaMilantitle1"),
                          'items': vruttaData?.presentmahalist ?? <YuvaShakkhaaList>[],
                        },
                        {
                          'label': Statics.getLabel("shakhaMilantitle2"),
                          'items': vruttaData?.sankalpitmahalist ?? <YuvaShakkhaaList>[],
                        },
                        {
                          'label': Statics.getLabel("shakhaMilantitle3"),
                          'items': vruttaData?.presenttarunlist ?? <YuvaShakkhaaList>[],
                        },
                        {
                          'label': Statics.getLabel("shakhaMilantitle4"),
                          'items': vruttaData?.sankalpittarunlist ?? <YuvaShakkhaaList>[],
                        },
                      ];

                      return groups.map((group) {
                        final groupItems = group['items'] as List<YuvaShakkhaaList>;
                        final groupLabel = group['label'] as String;

                        // Count how many from this group are selected
                        final selectedInGroup = checkboxShakhaSelectedItems.where((e) => groupItems.any((g) => g.geoUnitID == e.geoUnitID)).length;

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
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            title: Text(
                              groupLabel,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                            subtitle: Text(
                              "${Statics.getLabel('Total')} : ${groupItems.length}   •   ${Statics.getLabel('selectedTotal')} : $selectedInGroup",
                              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                            ),

                            // ✅ Leading tristate checkbox: select/deselect entire group
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
                                    for (var item in groupItems) {
                                      final alreadyAdded = checkboxShakhaSelectedItems.any((e) => e.geoUnitID == item.geoUnitID);
                                      if (!alreadyAdded) {
                                        checkboxShakhaSelectedItems.add(item);
                                        item.iselected = 1; // ✅ sync iselected
                                      }
                                    }
                                  } else {
                                    final groupIds = groupItems.map((e) => e.geoUnitID).toSet();
                                    checkboxShakhaSelectedItems.removeWhere((e) => groupIds.contains(e.geoUnitID));
                                    for (var item in groupItems) {
                                      item.iselected = 0; // ✅ sync iselected
                                    }
                                  }
                                  _recalculateShakhaCounts(vruttaData);
                                  _separateSelectedByGroup(vruttaData);
                                });
                              },
                            ),

                            children: [
                              const Divider(height: 1),
                              ...groupItems.map((item) {
                                final isSelected = checkboxShakhaSelectedItems.any((e) => e.geoUnitID == item.geoUnitID);

                                return InkWell(
                                  onTap: () => _toggleItem(item, vruttaData),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    child: Row(
                                      children: [
                                        Checkbox(
                                          value: isSelected,
                                          activeColor: Colors.purpleAccent,
                                          onChanged: (checked) => _toggleItem(item, vruttaData),
                                        ),
                                        const SizedBox(width: 6),
                                        Expanded(
                                          child: Text(
                                            item.shaakhaaname ?? "", // ✅ was: preferedname
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

                    // ✅ Summary rows — now uses sankalpitmahalist + sankalpittarunlist for totals
                    SingleColumnRow(
                      txtString: "${Statics.getLabel('Total')} ${Statics.getLabel('shaakhaamilan')}",
                      value:
                          "${(vruttaData?.sankalpitmahalist ?? []).length + (vruttaData?.sankalpittarunlist ?? []).length + (vruttaData?.presenttarunlist ?? []).length + (vruttaData?.sankalpittarunlist ?? []).length}",
                    ),
                    SingleColumnRow(
                      txtString: "${Statics.getLabel('shaakhaamilan')} ${Statics.getLabel('pratinidhitva')}",
                      value: "$selectedShakhaCount",
                    ),
                    SingleColumnRow(
                      rowColor: Colors.grey.shade300,
                      txtString: "${Statics.getLabel('shaakhaamilan')} ${Statics.getLabel('average')} ${Statics.getLabel('pratinidhitva')}",
                      value: () {
                        final total = (vruttaData?.sankalpitmahalist ?? []).length +
                            (vruttaData?.sankalpittarunlist ?? []).length +
                            (vruttaData?.presenttarunlist ?? []).length +
                            (vruttaData?.sankalpittarunlist ?? []).length;
                        return total > 0 ? "${((selectedShakhaCount / total) * 100).round()} %" : "0 %";
                      }(),
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
                isRequired: true,
              ),

//==============================  SUBMIT BUTTON =======================================================================

              SizedBox(height: 24),
              Container(
                width: double.infinity,
                child: MaterialButton(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  color: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                  onPressed: //() => Statics.showToast(Statics.getLabel("workInProgress")),
                      submitForm,
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

  Map<String, int>? countsShakhaa;

  List<YuvaShakkhaaList> checkboxShakhaSelectedItems = [];

  List<YuvaShakkhaaList> selectedPresentMaha = [];
  List<YuvaShakkhaaList> selectedSankalpitMaha = [];
  List<YuvaShakkhaaList> selectedPresentTarun = [];
  List<YuvaShakkhaaList> selectedSankalpitTarun = [];

  int totalShakhaCount = 0;
  int selectedShakhaCount = 0;
  String averageShakhaCount = "0";
  String? selectedShakhaaPratinidhitwaVastiIds;

  void _separateSelectedByGroup(YuvaVruttadata? vruttaData) {
    final presentMahaIds = (vruttaData?.presentmahalist ?? []).map((e) => e.geoUnitID).toSet();
    final sankalpitMahaIds = (vruttaData?.sankalpitmahalist ?? []).map((e) => e.geoUnitID).toSet();
    final presentTarunIds = (vruttaData?.presenttarunlist ?? []).map((e) => e.geoUnitID).toSet();
    final sankalpitTarunIds = (vruttaData?.sankalpittarunlist ?? []).map((e) => e.geoUnitID).toSet();

    selectedPresentMaha = checkboxShakhaSelectedItems.where((e) => presentMahaIds.contains(e.geoUnitID)).toList();
    selectedSankalpitMaha = checkboxShakhaSelectedItems.where((e) => sankalpitMahaIds.contains(e.geoUnitID)).toList();
    selectedPresentTarun = checkboxShakhaSelectedItems.where((e) => presentTarunIds.contains(e.geoUnitID)).toList();
    selectedSankalpitTarun = checkboxShakhaSelectedItems.where((e) => sankalpitTarunIds.contains(e.geoUnitID)).toList();
  }

  // In your onTap / onChanged toggle logic, replace the raw add/remove with:

  void _toggleItem(YuvaShakkhaaList item, YuvaVruttadata? vruttaData) {
    setState(() {
      final index = checkboxShakhaSelectedItems.indexWhere((e) => e.geoUnitID == item.geoUnitID);

      if (index >= 0) {
        // ✅ Deselect — remove and mark iselected = 0
        checkboxShakhaSelectedItems.removeAt(index);
        item.iselected = 0;
      } else {
        // ✅ Select — add and mark iselected = 1
        checkboxShakhaSelectedItems.add(item);
        item.iselected = 1;
      }

      _recalculateShakhaCounts(vruttaData);
      _separateSelectedByGroup(vruttaData);
    });
  }

  void _initializeSelectionFromData(YuvaVruttadata? vruttaData) {
    final allItems = <YuvaShakkhaaList>[
      ...(vruttaData?.presentmahalist ?? []),
      ...(vruttaData?.sankalpitmahalist ?? []),
      ...(vruttaData?.presenttarunlist ?? []),
      ...(vruttaData?.sankalpittarunlist ?? []),
    ];

    // ✅ Pre-select items where iselected == 1
    checkboxShakhaSelectedItems = allItems.where((e) => e.iselected == 1).toList();

    // ✅ Derive group-wise split and recalculate counts
    _recalculateShakhaCounts(vruttaData);
    _separateSelectedByGroup(vruttaData);
  }

  void _recalculateShakhaCounts(YuvaVruttadata? vruttaData) {
    // ✅ Total shakha count from both sankalpit lists combined
    totalShakhaCount = (vruttaData?.sankalpitmahalist ?? []).length + (vruttaData?.sankalpittarunlist ?? []).length;

    // ✅ Selected shakha count — no frequency filter needed, lists are pre-separated
    selectedShakhaCount = checkboxShakhaSelectedItems.length;

    // ✅ Comma-separated geoUnitIDs of selected items
    selectedShakhaaPratinidhitwaVastiIds = checkboxShakhaSelectedItems.where((e) => e.geoUnitID != null).map((e) => e.geoUnitID.toString()).join(",");

    // ✅ Average percentage
    if (totalShakhaCount > 0) {
      averageShakhaCount = ((selectedShakhaCount / totalShakhaCount) * 100).round().toString();
    } else {
      averageShakhaCount = "0";
    }

    // ✅ Build VastiCounts — grouped by freqname (e.g. "Maha" / "Tarun")
    //    since vayogatname no longer exists in YuvaShakkhaaList
    final Map<String, int> freqnameCounts = {};
    for (var item in checkboxShakhaSelectedItems) {
      final key = item.freqname ?? "Unknown";
      freqnameCounts[key] = (freqnameCounts[key] ?? 0) + 1;
    }
    countsShakhaa = freqnameCounts; // reusing vayogatCounts slot for freqname groups
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

  // Widget (){}

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
            rows: vaktaList.asMap().entries.map((entry) {
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
                    DataCell(Text(data.daaitva ?? "--")),
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
                              _buildInfoRow("${Statics.getLabel('Daayitva')}", selectedData.daaitva),
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
                  final _data = vaktaList[selectedVaktaIndex!];

                  txtVaktaNameController.text = _data.name ?? "--";
                  txtVaktaTaskController.text = (_data.daaitva ?? "--").toString();
                  _daayitvaForValue = _daayitvaFor?.firstWhere((e) => e.staticID == _data.prakarid);
                  _aayaamValue = _data.gatividhid;
                  _gatividhiValue = _data.gatividhid;
                  _preritSansthaValue = _data.gatividhid;
                  _othOrgNameCtrl.text = (_data.annyaname ?? "").toString();
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
                      vaktaList.remove(vaktaList[selectedVaktaIndex!]);
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
      _daayitvaForValue = null;
      _aayaamValue = null;
      _gatividhiValue = null;
      _preritSansthaValue = null;
      txtVaktaNameController.clear();
      txtVaktaTaskController.clear();
      _othOrgNameCtrl.clear();
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
                      value: _daayitvaForValue,
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
                            value: _aayaamValue,
                            items: _aayam!.map((bg) => DropdownMenuItem(value: bg.aayaamID, child: Text(bg.aayaamName!))).toList(),
                            onChanged: (value) {
                              set(() {
                                _aayaamValue = int.parse(value.toString());
                              });
                            },
                            validator: (value) {
                              if (value == null) return (Statics.getLabel('AayaamVaidationMessage'));
                              return null;
                            },
                            onSaved: (value) {
                              if (value != null) {
                                swDaayitva!.aayaamID = int.parse(value.toString());
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
                            value: _gatividhiValue,
                            items: _gatividhi!.map((bg) => DropdownMenuItem(value: bg.gatividhiID, child: Text(bg.gatividhiName!))).toList(),
                            onChanged: (value) {
                              set(() {
                                _gatividhiValue = int.parse(value.toString());
                              });
                            },
                            validator: (value) {
                              if (value == null) return (Statics.getLabel('GaitividhiVaidationMessage'));
                              return null;
                            },
                            onSaved: (value) {
                              if (value != null) {
                                swDaayitva!.gatividhiID = int.parse(value.toString());
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
                            value: _preritSansthaValue,
                            items: _sanghaPreritSanstha!.map((bg) => DropdownMenuItem(value: bg["SanghaPreritSansthaaID"], child: Text(bg["SansthaaName"]))).toList(),
                            onChanged: (value) {
                              set(() {
                                _preritSansthaValue = int.parse(value.toString());
                              });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) return (Statics.getLabel('SansthaaValidationMessage'));
                              return null;
                            },
                            onSaved: (value) {
                              if (value != null && value.isNotEmpty) {
                                swDaayitva!.sanghaPreritSansthaaID = int.parse(value.toString());
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
                          vaktaList.add(YuvaaSpeaker(
                              pkid: 0,
                              name: txtVaktaNameController.text.trim(),
                              daaitva: txtVaktaTaskController.text.trim(),
                              prakarid: _daayitvaForValue?.staticID,
                              gatividhid: _aayaamValue ?? _gatividhiValue ?? _preritSansthaValue,
                              isannya: _daayitvaForValue!.code == "OtherSocialOrganization" ? 1 : 0,
                              annyaname: _othOrgNameCtrl.text));
                          txtVaktaNameController.clear();
                          txtVaktaTaskController.clear();
                          setState(() {});
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
                      _aayaamValue = int.parse(value.toString());
                    });
                  },
                  validator: (value) {
                    if (value == null) return (Statics.getLabel('AayaamVaidationMessage'));
                    return null;
                  },
                  onSaved: (value) {
                    if (value != null) {
                      swDaayitva!.aayaamID = int.parse(value.toString());
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
                      _gatividhiValue = int.parse(value.toString());
                    });
                  },
                  validator: (value) {
                    if (value == null) return (Statics.getLabel('GaitividhiVaidationMessage'));
                    return null;
                  },
                  onSaved: (value) {
                    if (value != null) {
                      swDaayitva!.gatividhiID = int.parse(value.toString());
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

  Widget mainContainer(String header, Widget child, {bool isRequired = false}) {
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  header,
                  style: TextStyle(
                    color: Colors.purpleAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                if (isRequired)
                  Text(
                    "  *",
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 21,
                    ),
                  ),
              ],
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
