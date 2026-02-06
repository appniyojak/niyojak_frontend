import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:math' as m;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:niyojak_prod/widgets/app_drawer.dart';
import 'package:niyojak_prod/widgets/single_column_row.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../helpers/static_data.dart' as Statics;
import '../../../models/response_model/get_vijaya_dashami_geounit_data.dart';
import '../../../models/response_model/gruh_abhiyaan_vrutta_data_model.dart';
import '../../../models/response_model/hindu_sanmelan_model.dart';
import '../../../models/response_model/vijayaDashamiInitModel.dart';
import '../../../providers/bals.dart';
import '../../../utils/globals.dart';
import '../../../validation_blocks/validator.dart';
import '../vijayadashami/add_mukhya_atithi_form.dart';
import '../vijayadashami/add_vishesh_vyakti.dart';
import 'search_sajjan_anya_screen.dart';

class HinduSanmelanForm extends StatefulWidget {
  static const String routeName = '/hindu_sanmelan-form-view';

  const HinduSanmelanForm({super.key});

  @override
  State<HinduSanmelanForm> createState() => _HinduSanmelanFormState();
}

class _HinduSanmelanFormState extends State<HinduSanmelanForm> with AutomaticKeepAliveClientMixin {
// This override is what tells Flutter to keep the state alive.
  @override
  bool get wantKeepAlive => true;

  final _formKey = GlobalKey<FormState>();

  // final ScrollController _scrollController = ScrollController();

  TextEditingController txtUrlsController = TextEditingController();
  TextEditingController txtUrlDescController = TextEditingController();

  bool _searched = false;
  bool _isExpanded = true;
  bool isVastiSearch = false;

  bool _markAtt = false;

  List<AbhiyaanPeopleModel> vaktaList = [];
  List<AbhiyaanPeopleModel> _selectedVaktaList = [];
  int? selectedVaktaIndex;

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

  // List<int?> selectedUpnagarList = [];

  Vastisarsajjanshakti? selectedPerson;
  Vastisanyaprabhavi? selectedPrabhavi;
  List<Vastisarsajjanshakti> selectedSajjanshaktiItems = [];
  List<Vastisanyaprabhavi> selectedAnyaprabhaviItems = [];

  HinduSanmelanModel? data;

  List<UpnagarmandallistVijayaDashami> checkboxGraamVastiSelectedItems = [];

  @override
  void initState() {
    super.initState();
    populateDropdown();
    presentMatrushaktiController.addListener(_calculateTotal);
    presentMaleController.addListener(_calculateTotal);
  }

  _getForm() async {
    ///
    selectedPerson = null;
    selectedPrabhavi = null;
    selectedVastiCount = 0;
    presentMaleController.clear();
    presentMatrushaktiController.clear();
    txtSanmelanFormatController.clear();
    selectedSajjanshaktiItemsIds = null;
    selectedAnyaprabhaviItemsIds = null;
    selectedBhougolikPratinidhitwaVastiIds = null;
    _urlsList = [];
    vaktaList = [];

    ///
    // if (_linkedmandalValue != null && _linkedmandalValue!.isNotEmpty)
    data = await Statics.getHinduSanmelanFormData(context, userID: Statics.userDetails["userID"], targetGeoUnitID: _selectedGeoUnitId);

    if (data != null) {
      final List<Vastisarsajjanshakti?>? _list1 = data?.vastisarsajjanshakti;
      final List<Vastisanyaprabhavi?>? _list2 = data?.vastisanyaprabhavi;
      if (_list1 != null && _list1.isNotEmpty) selectedPerson = _list1.where((e) => e?.isMukhyadefault == 1).cast().firstOrNull;
      if (_list2 != null && _list2.isNotEmpty) selectedPrabhavi = _list2.where((e) => e?.isMukhyadefault == 1).cast().firstOrNull;
      selectedVastiCount = data?.selectedgramcount;
      presentMaleController.text = (data?.malecount ?? 0).toString();
      presentMatrushaktiController.text = (data?.femalecount ?? 0).toString();
      txtSanmelanFormatController.text = data?.sanmelandesc ?? "";
      // txtUtsavPhotoDescController.text = data?.imgDesc ?? "";
      // txtUtsavAddPhotoDescController.text = data?.advDesc ?? "";
      selectedSajjanshaktiItemsIds = data?.vastisarsajjanshakti?.where((e) => e.isVisheshdefault == 1).map((e) => e.pkid).join(',');
      selectedSajjanshaktiItems = data?.vastisarsajjanshakti?.where((e) => e.isVisheshdefault == 1).toList() ?? [];
      selectedAnyaprabhaviItemsIds = data?.vastisanyaprabhavi?.where((e) => e.isVisheshdefault == 1).map((e) => e.pkId).join(',');
      selectedAnyaprabhaviItems = data?.vastisanyaprabhavi?.where((e) => e.isVisheshdefault == 1).toList() ?? [];
      selectedBhougolikPratinidhitwaVastiIds = data?.gramlist?.where((e) => e.isdefault == 1).map((e) => e.geoUnitID).join(',');
      checkboxGraamVastiSelectedItems = data!.gramlist!.where((e) => e.isdefault == 1).toList();
      _urlsList = data?.urldata ?? [];
      _selectedFileNames1 = data?.imgdata ?? [];
      _selectedFileNames2 = data?.advimgdata ?? [];
      vaktaList = data?.vaktaList ?? [];

      print("searchVijayaDashami data ${data?.vastisarsajjanshakti}");
    }
  }

  Future<void> submitForm({bool showLoader = true}) async {
    Map<String, dynamic> formData = {
      "geounitid": _selectedGeoUnitId,
      "AppUserID": int.parse(Statics.userDetails['userID']),
      "sajjanmukhyaatitiid": selectedPerson?.pkid ?? 0,
      "annyamukhyaatitiid": selectedPrabhavi?.pkId ?? 0,
      "selectedgramcount": selectedVastiCount,
      "malecount": presentMaleController.text.trim().isNotEmpty ? int.parse(presentMaleController.text) : 0,
      "femalecount": presentMatrushaktiController.text.trim().isNotEmpty ? int.parse(presentMatrushaktiController.text) : 0,
      "sanmelandesc": txtSanmelanFormatController.text.trim(),
      "sajjanvisheshtiid": selectedSajjanshaktiItemsIds ?? "",
      "annyavisheshtiid": selectedAnyaprabhaviItemsIds ?? "",
      "gramids": selectedBhougolikPratinidhitwaVastiIds ?? "",
      "imgDesc": "", //txtUtsavPhotoDescController.text.trim(),
      "advDesc": "", //txtUtsavAddPhotoDescController.text.trim(),
      "urls": _urlsList,
      "hindusanmelanvatta": vaktaList,
    };

    String formattedJson = const JsonEncoder.withIndent('  ').convert(formData);
    log("Form Data (JSON):\n$formattedJson");
    await Statics.saveHinduSanmelanFormData(context, formData, showLoader);
    // getFormData();
  }

  Future<String?> submitImageDataFun({bool showLoader = false, required String type, required String description}) async {
    Map<String, dynamic> formData = {
      "GeoUnitID": _selectedGeoUnitId,
      "filebase": selectedFilePath,
      "type": type,
      "Desc": description,
    };

    String formattedJson = const JsonEncoder.withIndent('  ').convert(formData);
    log("Form Data (JSON):\n$formattedJson");
    final _result = await Statics.saveHinduSanmelanImageData(context: context, inputJson: formData, showLoader: showLoader);
    // getFormData();
    return _result;
  }

  Future<bool> deleteImageDataFun({bool showLoader = true, required String imageName}) async {
    Map<String, dynamic> formData = {
      "GeoUnitID": _selectedGeoUnitId,
      "filepath": imageName,
    };

    String formattedJson = const JsonEncoder.withIndent('  ').convert(formData);
    log("Form Data (JSON):\n$formattedJson");
    final _result = await Statics.deleteHinduSanmelanImageData(context: context, inputJson: formData, showLoader: showLoader);
    // getFormData();
    return _result;
  }

  Future<void> clearForm() async {
    setState(() {
      // Reset expand/collapse state
      _isExpanded = false;

      // // Reset dropdowns / linked values
      // _linkedMahaanagarValue = null;
      // _linkedVibhaagValue = null;
      // _linkedbhaagValue = null;
      // _linkedshaharValue = null;
      // _linkednagarValue = null;
      // _linkedmandalValue = null;
      // _linkedgraamValue = null;
      // _linkedvastiValue = null;
      // selectedUpnagarList = [];
      //
      // // Reset data lists
      // _linkedbhaag = null;
      // _linkedshahar = null;
      // _linkednagar = null;
      // _linkedmandal = null;
      // _linkedgraam = null;
      // _linkedvasti = null;
      //
      // // Reset level tracking
      // selctedLevel = '';
      // selctedLevelName = '';
      // selctedLevelId = null;
      // selctedLevelIdForMandalDropdown = null;
      // selctedLevelIdForVastiDropdown = null;

      selectedPerson = null;
      selectedPrabhavi = null;
      selectedVastiCount = 0;
      presentMaleController.clear();
      presentMatrushaktiController.clear();
      txtSanmelanFormatController.clear();
      selectedSajjanshaktiItemsIds = null;
      selectedAnyaprabhaviItemsIds = null;
      selectedBhougolikPratinidhitwaVastiIds = null;
      _urlsList = [];
      vaktaList = [];

      // Reset selections
      selectedType = null;
      selectedSajjanshaktiItems = [];
      selectedAnyaprabhaviItems = [];
      selectedBhougolikPratinidhitwaVastiIds = null;

      // Reset counts for Vasti
      selectedVastiCount = 0;
      totalVastiCount = 0;

      selectedPrabhavi = null;
      selectedPerson = null;
      // Re-populate base dropdowns
      // populatelinkedVibhaagDropdown('');
    });
  }

  //////////////////////////////////////////////////////////////////////////////////////

  Future<void> populateDropdown() async {
    setState(() {
      _linkedMahaanagarValue = _linkedbhaagValue = _linkedshaharValue = _linkednagarValue = _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = null;
    });
    await populatelinkedMahaanagarDropdown();
    await populatelinkedVibhaagDropdown('');
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedMahaanagarDropdown() async {
    _linkedVibhaagValue = _linkedbhaagValue = _linkednagarValue = _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = null;
    List<GeoUnitMasterBAL> data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['MahaanagarLevelID'].toString(), '', '', '', isAbhiyaan: false);
    setState(() {
      _linkedMahaanagar = data;
    });
    return data;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedVibhaagDropdown(String mahaanagarIDStr) async {
    _linkedbhaagValue = _linkednagarValue = _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = null;
    _linkedbhaagName = _linkednagarName = _linkedmandalName = _linkedgraamName = _linkedvastiName = null;
    print("populatelinkedVibhaagDropdown $mahaanagarIDStr");
    var data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['VibhaagLevelID'].toString(), mahaanagarIDStr, (mahaanagarIDStr.isEmpty ? '' : 'Mahaanagar'), '', isAbhiyaan: false);
    setState(() {
      _linkedVibhaag = data;
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
      });
      return ngDD;
    }
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedMandalDropdown(String? nagarIDStr) async {
    _linkedmandalValue = _linkedgraamValue = null;
    _linkedmandalName = _linkedgraamName = null;
    _linkedmandal = _linkedgraam = null;
    var mnDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['MandalLevelID'].toString(), nagarIDStr!, 'Nagar', '', isAbhiyaan: false);
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
    });
    return gmDD;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedVastiDropdown(String? nagarIDStr) async {
    _linkedvastiValue = null;
    _linkedvastiName = null;
    var vsDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['VastiLevelID'].toString(), nagarIDStr!, 'Nagar', '', isAbhiyaan: false);
    setState(() {
      _linkedvasti = (vsDD.length > 0 ? vsDD : null);
    });
    return vsDD;
  }

  //////////////////////////////////////////////////////////////////////////////////////

  String? selctedLevel = 'praant';
  String? selctedLevelName = '';

  // String? selctedLevelId = '';
  String? selctedLevelIdForMandalDropdown = '';
  String? selctedLevelIdForVastiDropdown = '';
  String? selctedSanchalanLevelId = '';
  String? selctedSanchalanLevelName = '';

  int? programNirdharitVed;
  int? programHishobh24Hour;

  final TextEditingController presentMaleController = TextEditingController();
  final TextEditingController presentMatrushaktiController = TextEditingController();

  final TextEditingController txtSanmelanFormatController = TextEditingController();
  final TextEditingController txtVaktaNameController = TextEditingController();
  final TextEditingController txtVaktaTaskController = TextEditingController();
  final TextEditingController txtUtsavPhotoDescController = TextEditingController();
  final TextEditingController txtUtsavAddPhotoDescController = TextEditingController();

  // Pat Sankhya controllers
  final patShishuBaalCtrl = TextEditingController();
  final patMahavidyaCtrl = TextEditingController();
  final patTarunVyavCtrl = TextEditingController();
  final patProudhVyavCtrl = TextEditingController();

  // Ganveshat Upasthit controllers
  final ganShishuBaalCtrl = TextEditingController();
  final ganMahavidyaCtrl = TextEditingController();
  final ganTarunVyavCtrl = TextEditingController();
  final ganProudhVyavCtrl = TextEditingController();

  // Anya Upasthit controllers
  final anyaShishuBaalCtrl = TextEditingController();
  final anyaMahavidyaCtrl = TextEditingController();
  final anyaTarunVyavCtrl = TextEditingController();
  final anyaProudhVyavCtrl = TextEditingController();

  int _getColumnTotal(List<TextEditingController> ctrls) {
    return ctrls.fold<int>(
      0,
      (sum, c) => sum + (int.tryParse(c.text.trim().isEmpty ? "0" : c.text) ?? 0),
    );
  }

// helper function
  int _rowTotal(String gan, String anya) {
    final g = int.tryParse(gan) ?? 0;
    final a = int.tryParse(anya) ?? 0;
    return g + a;
  }

  // Widget _numberField(
  //   TextEditingController controller, {
  //   TextEditingController? limitController,
  //   TextEditingController? otherController,
  // }) {
  //   return Padding(
  //     padding: const EdgeInsets.all(4.0),
  //     child: TextField(
  //       controller: controller,
  //       keyboardType: TextInputType.number,
  //       textAlign: TextAlign.center,
  //       decoration: const InputDecoration(
  //         hintText: "0",
  //         border: UnderlineInputBorder(),
  //         focusedBorder: UnderlineInputBorder(
  //           borderSide: BorderSide(color: Colors.deepPurple, width: 2),
  //         ),
  //         enabledBorder: UnderlineInputBorder(
  //           borderSide: BorderSide(color: Colors.grey, width: 1),
  //         ),
  //         isDense: true, // compact look
  //         contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
  //       ),
  //       onChanged: (val) {
  //         if (_isSearching == false) {
  //           Fluttertoast.showToast(
  //             msg: "${Statics.getLabel('NagarSelectionImportant')}",
  //           );
  //           return;
  //         }
  //         if (limitController != null && otherController != null) {
  //           final limit = int.tryParse(limitController.text) ?? 0;
  //           final self = int.tryParse(val) ?? 0;
  //           final other = int.tryParse(otherController.text) ?? 0;
  //
  //           if (self + other > limit) {
  //             controller.text = (limit - other).toString();
  //             controller.selection = TextSelection.fromPosition(
  //               TextPosition(offset: controller.text.length),
  //             );
  //           }
  //         }
  //         if (mounted) setState(() {});
  //       },
  //     ),
  //   );
  // }
  Widget _numberField(
    TextEditingController controller, {
    // bool showPadding = false,
    EdgeInsetsGeometry? padding,
    Color? textBoxColor,
    Color? containerColor,
    TextEditingController? limitController,
    TextEditingController? otherController,
  }) {
    return Container(
      padding: padding ?? const EdgeInsets.all(4.0),
      alignment: Alignment.center,
      decoration: BoxDecoration(color: containerColor),
      child: TextField(
        controller: controller,
        readOnly: !_searched,
        // 🔑 typing disable when false
        onTap: () {
          if (!_searched) {
            Fluttertoast.showToast(
              msg: "${Statics.getLabel('NagarSelectionImportant')}",
            );
          }
        },
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          filled: textBoxColor != null,
          fillColor: textBoxColor,
          hintText: "0",
          border: UnderlineInputBorder(),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.deepPurple, width: 2),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 1),
          ),
          isDense: true,
          contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        ),
        onChanged: (val) {
          if (limitController != null && otherController != null) {
            final limit = int.tryParse(limitController.text) ?? 0;
            final self = int.tryParse(val) ?? 0;
            final other = int.tryParse(otherController.text) ?? 0;

            if (self + other > limit) {
              controller.text = (limit - other).toString();
              controller.selection = TextSelection.fromPosition(
                TextPosition(offset: controller.text.length),
              );
            }
          }
          if (mounted) setState(() {});
        },
      ),
    );
  }

  int total = 0;

  void _calculateTotal() {
    final int matru = int.tryParse(presentMatrushaktiController.text) ?? 0;
    final int male = int.tryParse(presentMaleController.text) ?? 0;
    setState(() {
      total = matru + male;
    });
  }

  @override
  void dispose() {
    presentMatrushaktiController.dispose();
    presentMaleController.dispose();
    for (var c in [
      patShishuBaalCtrl,
      patMahavidyaCtrl,
      patTarunVyavCtrl,
      patProudhVyavCtrl,
      ganShishuBaalCtrl,
      ganMahavidyaCtrl,
      ganTarunVyavCtrl,
      ganProudhVyavCtrl,
      anyaShishuBaalCtrl,
      anyaMahavidyaCtrl,
      anyaTarunVyavCtrl,
      anyaProudhVyavCtrl
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(
      //     "${Statics.getLabel('hinduSammelan')}",
      //     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      //   ),
      //   // actions: [
      //   //   IconButton(
      //   //       onPressed: () {
      //   //         Navigator.of(context).pushNamed(HinduSanmelanReport.routeName);
      //   //       },
      //   //       icon: Icon(Icons.document_scanner_outlined))
      //   // ],
      // ),
      drawer: AppDrawer(),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.end,
            //   children: [
            //     Text(
            //       "*Dummy UI",
            //       style: TextStyle(color: Colors.grey.shade600, fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
            //     )
            //   ],
            // ),
            SizedBox(height: 12),
//=======================================   SEARCH FILTERS ==========================================================================================
            vastiMandalDropdown(),
            SizedBox(height: 20),
            if (isVastiSearch == false)
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    // ""
                    // "${Statics.getLabel('Note')} :- "
                    "${Statics.getLabel('NagarSelectionImportant')}",
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 2),
                  Container(
                    height: 2,
                    width: double.infinity,
                    color: Colors.red,
                  ),
                ],
              ),
            if (selctedLevel != "" && selctedLevelName != "" && isVastiSearch == true)
              Container(
                  // height: 40,
                  width: MediaQuery.sizeOf(context).width,
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.purpleAccent, width: 1),
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          "${Statics.getLabel(selctedLevel ?? 'Nagar')}  ->  ",
                          style: TextStyle(color: Colors.purpleAccent, fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                      Flexible(
                        child: Text(
                          " $selctedLevelName",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 17),
                        ),
                      ),
                    ],
                  )),
            SizedBox(
              height: 10,
            ),
// // ================================== 1 QUESTIONS Box ==================================================================================================================================================================================================================================================================================================================================================
//             mainContainer(
//               "${Statics.getLabel('sammelanInfo')}",
//               Column(
//                 children: [
//                   yesNoRadioButton(
//                     question: "${Statics.getLabel('sanmelanQuestion1')}",
//                     selectedOption: programNirdharitVed ?? 2,
//                     imp: " *",
//                     onChanged: (value) {
//                       setState(() {
//                         programNirdharitVed = value;
//                       });
//                     },
//                   ),
//                   // yesNoRadioButton(
//                   //   question: "${Statics.getLabel('vaiyaktikGitKantashtha')}",
//                   //   selectedOption: vaiyaktikGitKantashtha ?? 2,
//                   //   imp: " *",
//                   //   onChanged: (value) {
//                   //     setState(() {
//                   //       vaiyaktikGitKantashtha = value;
//                   //     });
//                   //   },
//                   // ),
//                   yesNoRadioButton(
//                     question: "${Statics.getLabel('sanmelanQuestion2')}",
//                     selectedOption: programHishobh24Hour ?? 2,
//                     imp: " *",
//                     onChanged: (value) {
//                       setState(() {
//                         programHishobh24Hour = value;
//                       });
//                     },
//                   ),
//                 ],
//               ),
//             ),
// ================================== 2 QUESTIONS Box ==================================================================================================================================================================================================================================================================================================================================================
            mainContainer(
              "${Statics.getLabel('mukhyaAtithi')}",
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        borderRadius: BorderRadius.circular(15),
                        onTap: () {
                          if (!_searched) {
                            Fluttertoast.showToast(msg: "${Statics.getLabel('NagarSelectionImportant')}");
                            return;
                          }

                          final _tempFiles1 = (data?.vastisarsajjanshakti ?? []).where((e) => !selectedSajjanshaktiItems.contains(e)).toList();
                          final _tempFiles2 = (data?.vastisanyaprabhavi ?? []).where((e) => !selectedAnyaprabhaviItems.contains(e)).toList();

                          // final preselected = list.any((e) => e.isMukhyadefault == 1) ? list.firstWhere((e) => e.isMukhyadefault == 1) : list2.firstWhere((e) => e.isMukhyadefault == 1,orElse: () => list2.first);

                          showMukhyaAtithiSelectionPopup(
                            context,
                            sarsajjanshaktiList: _tempFiles1,
                            sanyaprabhaviList: _tempFiles2,
                            // preselectedItem: preselected,
                            // preselectedType: selectedType,
                            // onSubmit: (id, type, selectedItem) {
                            //   setState(() {
                            //     selectedType = type;
                            //     if (type == "sarsajjanshakti") {
                            //       selectedPerson = selectedItem as Vastisarsajjanshakti;
                            //       selectedPrabhavi = null;
                            //       selectedMukhyaAtithi = selectedPerson?.pkid;
                            //     } else {
                            //       selectedPrabhavi = selectedItem as Vastisanyaprabhavi;
                            //       selectedPerson = null;
                            //       selectedMukhyaAtithi = selectedPrabhavi?.pkId;
                            //     }
                            //   });
                            // },
                            // onAdd: () {
                            //   Navigator.of(context).pushReplacementNamed(
                            //     AddMukhyaAtithi.routeName,
                            //     arguments: {'linkedNagar': _linkednagar, 'selectedLevelId': _linkednagarValue},
                            //   ).then((value) => _getForm());
                            // },
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                          // width: 130,
                          // height: 35,
                          decoration: BoxDecoration(border: Border.all(color: Colors.purpleAccent.shade100), borderRadius: BorderRadius.circular(15)),
                          child: Text(
                            "${Statics.getLabel('addMukhyaAtithi')}",
                            style: const TextStyle(color: Colors.purpleAccent, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Table(
                    border: TableBorder.all(),
                    columnWidths: const {
                      0: FixedColumnWidth(40),
                      1: FlexColumnWidth(),
                      2: FlexColumnWidth(),
                    },
                    children: [
                      TableRow(
                        decoration: const BoxDecoration(color: Color(0xFFE0E0E0)),
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(4),
                            child: Text("${Statics.getLabel('serialNo')}"),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4),
                            child: Text("${Statics.getLabel('Name')}"),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4),
                            child: Text("${Statics.getLabel('samparkSootraNaav')}"),
                          ),
                          Padding(padding: EdgeInsets.all(4), child: Text("${Statics.getLabel('ViewMenu')}")),
                        ],
                      ),
                      TableRow(
                        children: [
                          const Padding(padding: EdgeInsets.all(4), child: Text("1")),
                          Padding(
                            padding: const EdgeInsets.all(4),
                            child: Text(selectedPerson?.name ?? selectedPrabhavi?.name ?? ""),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4),
                            child: Text(selectedPerson?.samparkasutranava ?? selectedPrabhavi?.samparkAsutraNav ?? ""),
                          ),
                          IconButton(
                            icon: Icon(Icons.remove_red_eye, size: 22, color: Colors.purpleAccent),
                            onPressed: () {
                              // 👇 Check which object is available and open popup
                              if (selectedPerson != null) {
                                showPersonDetailsPopup(context, selectedPerson!, 1);
                              } else if (selectedPrabhavi != null) {
                                showPersonDetailsPopup(context, selectedPrabhavi!, 1);
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
// ================================== 3 QUESTIONS Box ==================================================================================================================================================================================================================================================================================================================================================
            mainContainer(
              "${Statics.getLabel('specialAtithi')}",
              Column(
                children: [
                  // Button for popup
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        borderRadius: BorderRadius.circular(15),
                        onTap: () async {
                          if (!_searched) {
                            Fluttertoast.showToast(msg: "${Statics.getLabel('NagarSelectionImportant')}");
                            return;
                          }

                          final _tempFiles1 = (data?.vastisarsajjanshakti ?? []).where((e) => selectedPerson != e).toList();
                          final _tempFiles2 = (data?.vastisanyaprabhavi ?? []).where((e) => selectedPrabhavi != e).toList();

                          // _tempFiles1.where((e) => e.pkid != selectedPerson?.pkid || e.isMukhyadefault == 0).toList();
                          // _tempFiles2.where((e) => e.pkId != selectedPrabhavi?.pkId || e.isMukhyadefault == 0).toList();
                          await showVisheshAtithiSelectionPopup(
                            context,
                            sarsajjanshaktiList: _tempFiles1,
                            sanyaprabhaviList: _tempFiles2,
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                          // width: 150,
                          // height: 35,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.purpleAccent.shade100),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Text(
                            "${Statics.getLabel('addVIshishthaAtithi')}",
                            style: TextStyle(
                              color: Colors.purpleAccent,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Table for Sajjanshakti
                  if (selectedSajjanshaktiItems.isNotEmpty) ...[
                    Text("${Statics.getLabel('SajjanShakti')}", style: TextStyle(fontWeight: FontWeight.bold)),
                    Table(
                      border: TableBorder.all(),
                      columnWidths: const {
                        0: FixedColumnWidth(40),
                        1: FlexColumnWidth(),
                        2: FlexColumnWidth(),
                      },
                      children: [
                        TableRow(
                          decoration: BoxDecoration(color: Color(0xFFE0E0E0)),
                          children: [
                            Padding(padding: EdgeInsets.all(4), child: Text("${Statics.getLabel('serialNo')}")),
                            Padding(padding: EdgeInsets.all(4), child: Text("${Statics.getLabel('Name')}")),
                            Padding(padding: EdgeInsets.all(4), child: Text("${Statics.getLabel('samparkSootraNaav')}")),
                            Padding(padding: EdgeInsets.all(4), child: Text("${Statics.getLabel('ViewMenu')}")),
                          ],
                        ),
                        ...selectedSajjanshaktiItems.asMap().entries.map((entry) {
                          int srNo = entry.key + 1;
                          final item = entry.value;
                          return TableRow(
                            children: [
                              Padding(padding: const EdgeInsets.all(4), child: Text(srNo.toString())),
                              Padding(padding: const EdgeInsets.all(4), child: Text(item.name ?? "")),
                              Padding(padding: const EdgeInsets.all(4), child: Text(item.samparkasutranava ?? "")),
                              IconButton(
                                icon: Icon(Icons.remove_red_eye, size: 22, color: Colors.purpleAccent),
                                onPressed: () {
                                  showPersonDetailsPopup(context, item, srNo);
                                },
                              ),
                            ],
                          );
                        }).toList(),
                      ],
                    ),
                  ],

                  const SizedBox(height: 20),

                  // Table for Anyaprabhavi
                  if (selectedAnyaprabhaviItems.isNotEmpty) ...[
                    Text("${Statics.getLabel('anyaPrabhaviLok')}", style: TextStyle(fontWeight: FontWeight.bold)),
                    Table(
                      border: TableBorder.all(),
                      columnWidths: const {
                        0: FixedColumnWidth(40),
                        1: FlexColumnWidth(),
                        2: FlexColumnWidth(),
                        3: FixedColumnWidth(50), // 👁 button column
                      },
                      children: [
                        TableRow(
                          decoration: BoxDecoration(color: Color(0xFFE0E0E0)),
                          children: [
                            Padding(padding: EdgeInsets.all(4), child: Text("${Statics.getLabel('serialNo')}")),
                            Padding(padding: EdgeInsets.all(4), child: Text("${Statics.getLabel('Name')}")),
                            Padding(padding: EdgeInsets.all(4), child: Text("${Statics.getLabel('samparkSootraNaav')}")),
                            Padding(padding: EdgeInsets.all(4), child: Text("${Statics.getLabel('ViewMenu')}")), // 👁 column heading
                          ],
                        ),
                        ...selectedAnyaprabhaviItems.asMap().entries.map((entry) {
                          int srNo = entry.key + 1;
                          final item = entry.value;

                          return TableRow(
                            children: [
                              Padding(padding: const EdgeInsets.all(4), child: Text(srNo.toString())),
                              Padding(padding: const EdgeInsets.all(4), child: Text(item.name ?? "")),
                              Padding(padding: const EdgeInsets.all(4), child: Text(item.samparkAsutraNav ?? "")),
                              IconButton(
                                icon: Icon(Icons.remove_red_eye, size: 22, color: Colors.purpleAccent),
                                onPressed: () {
                                  showPersonDetailsPopup(context, item, srNo);
                                },
                              ),
                            ],
                          );
                        }).toList(),
                      ],
                    ),
                  ],
                ],
              ),
            ),
// ================================== 4 QUESTIONS Box ==================================================================================================================================================================================================================================================================================================================================================
            mainContainer(
              "${Statics.getLabel('sanmelanVakta')}",
              vaktaTable(),
            ),
// // ================================== 5 QUESTIONS Box ==================================================================================================================================================================================================================================================================================================================================================
//             mainContainer(
//               "${Statics.getLabel('swayamsewakUpastithi')}",
//               Column(
//                 children: [
//                   Scrollbar(
//                     controller: _scrollController,
//                     interactive: true,
//                     thumbVisibility: true,
//                     radius: Radius.circular(8),
//                     child: SingleChildScrollView(
//                       controller: _scrollController,
//                       scrollDirection: Axis.horizontal, // 👉 Horizontal scroll
//                       child: Container(
//                         width: 450,
//                         padding: const EdgeInsets.all(8),
//                         child: Table(
//                           defaultVerticalAlignment: TableCellVerticalAlignment.middle,
//                           border: TableBorder.all(color: Colors.black),
//                           columnWidths: const {
//                             0: FlexColumnWidth(3),
//                             1: FlexColumnWidth(2),
//                             2: FlexColumnWidth(1.5),
//                             // 3: FlexColumnWidth(2.5),
//                             3: FlexColumnWidth(2),
//                           },
//                           children: [
//                             // Header Row
//                             TableRow(
//                               decoration: BoxDecoration(color: Colors.purpleAccent.shade100),
//                               children: [
//                                 Padding(
//                                   padding: const EdgeInsets.all(8.0),
//                                   child: Text("${Statics.getLabel('Vayogat')}", style: const TextStyle(fontSize: 15.6, fontWeight: FontWeight.bold, color: Colors.white)),
//                                 ),
//                                 Padding(
//                                   padding: const EdgeInsets.all(8.0),
//                                   child:
//                                       Text("${Statics.getLabel('patSankhyaa')}", textAlign: TextAlign.center, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
//                                 ),
//                                 Center(
//                                   child: Padding(
//                                     padding: EdgeInsets.all(8.0),
//                                     child: Text("${Statics.getLabel('Total')}", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
//                                   ),
//                                 ),
//                                 // Padding(
//                                 //   padding: const EdgeInsets.all(8.0),
//                                 //   child: Text("${Statics.getLabel('ganveshatPresentCount')}", style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
//                                 // ),
//                                 Padding(
//                                   padding: const EdgeInsets.all(8.0),
//                                   child: Text("${Statics.getLabel('otherSwayamsewakPresentCount')}",
//                                       textAlign: TextAlign.center, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
//                                 ),
//                               ],
//                             ),
//
//                             // Data Rows
//                             TableRow(
//                               // decoration: BoxDecoration(color: Colors.grey.shade300),
//                               children: [
//                                 Padding(
//                                   padding: const EdgeInsets.all(8.0),
//                                   child: Text("${Statics.getLabel('Shishu')}/${Statics.getLabel('Baal')}", style: TextStyle(fontSize: 14.5)),
//                                 ),
//                                 _numberField(patShishuBaalCtrl, textBoxColor: Colors.grey.shade300, containerColor: Colors.grey.shade300),
//                                 Container(
//                                   padding: const EdgeInsets.symmetric(vertical: 14.0),
//                                   alignment: Alignment.center,
//                                   decoration: BoxDecoration(color: Colors.grey.shade300),
//                                   child: Text(_rowTotal(ganShishuBaalCtrl.text, anyaShishuBaalCtrl.text).toString()),
//                                 ),
//                                 // _numberField(ganShishuBaalCtrl, limitController: patShishuBaalCtrl, otherController: anyaShishuBaalCtrl),
//                                 _numberField(anyaShishuBaalCtrl, limitController: patShishuBaalCtrl, otherController: ganShishuBaalCtrl),
//                               ],
//                             ),
//
//                             TableRow(
//                               children: [
//                                 Padding(
//                                   padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2),
//                                   child: Text("${Statics.getLabel('MahaavidyaalayeenTarunLabel')}", style: TextStyle(fontSize: 14.5)),
//                                 ),
//                                 _numberField(patMahavidyaCtrl, padding: const EdgeInsets.symmetric(vertical: 12.0), textBoxColor: Colors.grey.shade300, containerColor: Colors.grey.shade300),
//                                 Container(
//                                   padding: const EdgeInsets.symmetric(vertical: 20.0),
//                                   alignment: Alignment.center,
//                                   decoration: BoxDecoration(color: Colors.grey.shade300),
//                                   child: Text(_rowTotal(ganMahavidyaCtrl.text, anyaMahavidyaCtrl.text).toString()),
//                                 ),
//                                 // _numberField(ganMahavidyaCtrl, limitController: patMahavidyaCtrl, otherController: anyaMahavidyaCtrl),
//                                 _numberField(anyaMahavidyaCtrl, limitController: patMahavidyaCtrl, otherController: ganMahavidyaCtrl),
//                               ],
//                             ),
//
//                             TableRow(
//                               children: [
//                                 Padding(
//                                   padding: const EdgeInsets.all(8.0),
//                                   child: Text("${Statics.getLabel('TarunVyavasaayee')}", style: TextStyle(fontSize: 14.5)),
//                                 ),
//                                 _numberField(patTarunVyavCtrl, textBoxColor: Colors.grey.shade300, containerColor: Colors.grey.shade300),
//                                 Container(
//                                   padding: const EdgeInsets.symmetric(vertical: 14.0),
//                                   alignment: Alignment.center,
//                                   decoration: BoxDecoration(color: Colors.grey.shade300),
//                                   child: Text(_rowTotal(ganTarunVyavCtrl.text, anyaTarunVyavCtrl.text).toString()),
//                                 ),
//                                 // _numberField(ganTarunVyavCtrl, limitController: patTarunVyavCtrl, otherController: anyaTarunVyavCtrl),
//                                 _numberField(anyaTarunVyavCtrl, limitController: patTarunVyavCtrl, otherController: ganTarunVyavCtrl),
//                               ],
//                             ),
//
//                             TableRow(
//                               children: [
//                                 Padding(
//                                   padding: const EdgeInsets.all(8.0),
//                                   child: Text("${Statics.getLabel('ProudhaVyavasaayeeLabel')}", style: TextStyle(fontSize: 14.5)),
//                                 ),
//                                 _numberField(patProudhVyavCtrl, textBoxColor: Colors.grey.shade300, containerColor: Colors.grey.shade300),
//                                 Container(
//                                   padding: const EdgeInsets.symmetric(vertical: 14.0),
//                                   alignment: Alignment.center,
//                                   decoration: BoxDecoration(color: Colors.grey.shade300),
//                                   child: Text(_rowTotal(ganProudhVyavCtrl.text, anyaProudhVyavCtrl.text).toString()),
//                                 ),
//                                 // _numberField(ganProudhVyavCtrl, limitController: patProudhVyavCtrl, otherController: anyaProudhVyavCtrl),
//                                 _numberField(anyaProudhVyavCtrl, limitController: patProudhVyavCtrl, otherController: ganProudhVyavCtrl),
//                               ],
//                             ),
//
//                             // Total Row
//                             TableRow(
//                               decoration: const BoxDecoration(color: Colors.amberAccent),
//                               children: [
//                                 Padding(
//                                   padding: EdgeInsets.all(8.0),
//                                   child: Text("${Statics.getLabel('Total')}", style: TextStyle(fontSize: 14.7, fontWeight: FontWeight.w900)),
//                                 ),
//                                 Center(
//                                   child: Padding(
//                                     padding: const EdgeInsets.all(8.0),
//                                     child: Text(_getColumnTotal([patShishuBaalCtrl, patMahavidyaCtrl, patTarunVyavCtrl, patProudhVyavCtrl]).toString(), style: TextStyle(fontWeight: FontWeight.w900)),
//                                   ),
//                                 ),
//                                 Center(
//                                   child: Padding(
//                                     padding: const EdgeInsets.all(8.0),
//                                     child: Text(
//                                         (_getColumnTotal([ganShishuBaalCtrl, ganMahavidyaCtrl, ganTarunVyavCtrl, ganProudhVyavCtrl]) +
//                                                 _getColumnTotal([anyaShishuBaalCtrl, anyaMahavidyaCtrl, anyaTarunVyavCtrl, anyaProudhVyavCtrl]))
//                                             .toString(),
//                                         style: TextStyle(fontWeight: FontWeight.w900)),
//                                   ),
//                                 ),
//                                 // Center(
//                                 //   child: Padding(
//                                 //     padding: const EdgeInsets.all(8.0),
//                                 //     child: Text(_getColumnTotal([ganShishuBaalCtrl, ganMahavidyaCtrl, ganTarunVyavCtrl, ganProudhVyavCtrl]).toString(), style: TextStyle(fontWeight: FontWeight.w900)),
//                                 //   ),
//                                 // ),
//                                 Center(
//                                   child: Padding(
//                                     padding: const EdgeInsets.all(8.0),
//                                     child:
//                                         Text(_getColumnTotal([anyaShishuBaalCtrl, anyaMahavidyaCtrl, anyaTarunVyavCtrl, anyaProudhVyavCtrl]).toString(), style: TextStyle(fontWeight: FontWeight.w900)),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
// ================================== 6 QUESTIONS Box ==================================================================================================================================================================================================================================================================================================================================================
            if (_linkedmandalValue != null && _linkedmandalValue!.isNotEmpty)
              mainContainer(
                "${Statics.getLabel('bhougolikPratinidhitwa')}",
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: () {
                            if (!_searched) {
                              Fluttertoast.showToast(
                                msg: "${Statics.getLabel('NagarSelectionImportant')}",
                              );
                              return;
                            }
                            showGraamVastiMandalUpnagarPopup(
                              context,
                              vastiList: data?.gramlist ?? [],
                              preselectedItems: checkboxGraamVastiSelectedItems,
                              onSubmit: (selectedItems, selectedCount, totalCount) {
                                print("Selected: $selectedCount / $totalCount");
                                setState(() {
                                  checkboxGraamVastiSelectedItems = selectedItems;
                                  totalVastiCount = totalCount;
                                  selectedVastiCount = selectedCount;
                                  selectedBhougolikPratinidhitwaVastiIds = selectedItems.map((e) => e.geoUnitID.toString()).join(",");
                                });
                                print("Selected Items: ${selectedItems.map((e) => e.geoUnitID)}");
                              },
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 14),
                            // width: 120,
                            height: 35,
                            decoration: BoxDecoration(border: Border.all(color: Colors.purpleAccent.shade100), borderRadius: BorderRadius.circular(15)),
                            child: Center(
                              child: Text(
                                "${Statics.getLabel('addGraam')}",
                                style: TextStyle(color: Colors.purpleAccent, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SingleColumnRow(
                      txtString: "${Statics.getLabel('Total')} ${Statics.getLabel('Graam')}",
                      value: (data?.gramlist ?? []).length.toString(),
                    ),
                    SingleColumnRow(
                      txtString: "${Statics.getLabel('Graam')} ${Statics.getLabel('pratinidhitva')}  ",
                      value: selectedVastiCount.toString(),
                    ),
                    SingleColumnRow(
                      rowColor: Colors.grey.shade300,
                      txtString: "${Statics.getLabel('average')} ${Statics.getLabel('pratinidhitva')} ",
                      // value: "40 %",
                      value: "${(data?.gramlist ?? []).length > 0 ? ((selectedVastiCount! / (data?.gramlist ?? []).length) * 100).toStringAsFixed(0) : 0} %",
                    )
                  ],
                ),
              ),
// // ================================== 7 QUESTIONS Box ==================================================================================================================================================================================================================================================================================================================================================
//             mainContainer(
//               "${Statics.getLabel('shakhaMilanPratinidhitwa')}",
//               Column(
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     children: [
//                       InkWell(
//                         onTap: () {
//                           if (!_searched) {
//                             Fluttertoast.showToast(
//                               msg: "${Statics.getLabel('NagarSelectionImportant')}",
//                             );
//                             return;
//                           }
//                           showShakhaalistPopup(
//                             context,
//                             shakhaalist: data?.shakhaalist ?? [],
//                             preselectedItems: checkboxShakhaSelectedItems,
//                             onSubmit: (selectedItems, counts) {
//                               setState(() {
//                                 checkboxShakhaSelectedItems = selectedItems;
//                                 countsShakhaa = counts; // model me store
//
//                                 // ✅ Total shakha count
//                                 totalShakhaCount = (data?.shakhaalist ?? []).where((item) => item.frequencyName == "शाखा").length;
//
//                                 // ✅ Selected shakha count
//                                 selectedShakhaCount = selectedItems.where((item) => item.frequencyName == "शाखा").length;
//                                 selectedShakhaaPratinidhitwaVastiIds = selectedItems.map((e) => e.geoUnitID.toString()).join(",");
//                                 // ✅ Average shakha count (percentage)
//                                 if (totalShakhaCount > 0) {
//                                   averageShakhaCount = ((selectedShakhaCount / totalShakhaCount) * 100).round().toString();
//                                 } else {
//                                   averageShakhaCount = "0";
//                                 }
//                               });
//                             },
//                           );
//                         },
//                         child: Container(
//                           padding: const EdgeInsets.symmetric(vertical: 5),
//                           width: 120,
//                           height: 35,
//                           decoration: BoxDecoration(
//                             border: Border.all(color: Colors.purpleAccent.shade100),
//                             borderRadius: BorderRadius.circular(15),
//                           ),
//                           child: Center(
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 const SizedBox(width: 5),
//                                 Text(
//                                   "${Statics.getLabel('selectshakhaa')}",
//                                   style: const TextStyle(
//                                     color: Colors.purpleAccent,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 10),
//
//                   // ✅ Results after submit
//                   SingleColumnRow(
//                     txtString: "${Statics.getLabel('Total')} ${Statics.getLabel('Shaakhaa')} ",
//                     value: "${(data?.shakhaalist ?? []).where((item) => item.frequencyName == "शाखा").length}",
//                   ),
//                   SingleColumnRow(
//                     txtString: " ${Statics.getLabel('Shaakhaa')} ${Statics.getLabel('pratinidhitva')}",
//                     value: "$selectedShakhaCount",
//                   ),
//                   SingleColumnRow(
//                     rowColor: Colors.grey.shade300,
//                     txtString: " ${Statics.getLabel('Shaakhaa')} ${Statics.getLabel('average')} ${Statics.getLabel('pratinidhitva')} ",
//                     value: ((data?.shakhaalist ?? []).where((item) => item.frequencyName == "शाखा").length > 0
//                             ? ((selectedShakhaCount / (data?.shakhaalist ?? []).where((item) => item.frequencyName == "शाखा").length) * 100).round().toString()
//                             : "0") +
//                         " %",
//                   ),
//                 ],
//               ),
//             ),
// // ================================== 8 QUESTIONS Box ==================================================================================================================================================================================================================================================================================================================================================
//             mainContainer(
//               "${Statics.getLabel('MilanPratinidhitwa')}",
//               Column(
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     children: [
//                       InkWell(
//                         onTap: () {
//                           if (!_searched) {
//                             Fluttertoast.showToast(
//                               msg: "${Statics.getLabel('NagarSelectionImportant')}",
//                             );
//                             return;
//                           }
//                           showMilanalistPopup(
//                             context,
//                             milanalist: data?.shakhaalist ?? [],
//                             preselectedItems: checkboxMilanSelectedItems,
//                             onSubmit: (selectedItems, counts) {
//                               setState(() {
//                                 selectedMilanPratinidhitwaVastiIds = selectedItems.map((e) => e.geoUnitID.toString()).join(",");
//                                 checkboxMilanSelectedItems = selectedItems;
//                                 countsMilan = counts; // model me store
//
//                                 // ✅ Total shakha count
//                                 totalMilanCount = (data?.shakhaalist ?? []).where((item) => item.frequencyName == "साप्ताहिक मिलन").length;
//
//                                 // ✅ Selected shakha count
//                                 selectedMilanCount = selectedItems.where((item) => item.frequencyName == "साप्ताहिक मिलन").length;
//
//                                 // ✅ Average shakha count (percentage)
//                                 if (totalMilanCount > 0) {
//                                   averageMilanCount = ((selectedMilanCount / totalMilanCount) * 100).round().toString();
//                                 } else {
//                                   averageMilanCount = "0";
//                                 }
//                               });
//                             },
//                           );
//                         },
//                         child: Container(
//                           padding: const EdgeInsets.symmetric(vertical: 5),
//                           width: 160,
//                           height: 35,
//                           decoration: BoxDecoration(
//                             border: Border.all(color: Colors.purpleAccent.shade100),
//                             borderRadius: BorderRadius.circular(15),
//                           ),
//                           child: Center(
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Text(
//                                   "${Statics.getLabel('selectSaptahikMilan')}",
//                                   style: const TextStyle(
//                                     color: Colors.purpleAccent,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 10),
//
//                   // ✅ Results after submit
//                   SingleColumnRow(
//                     txtString: "${Statics.getLabel('Total')} ${Statics.getLabel('SaaptaahikMilan')} ",
//                     value: "${(data?.shakhaalist ?? []).where((item) => item.frequencyName == "साप्ताहिक मिलन").length}",
//                   ),
//                   SingleColumnRow(
//                     txtString: " ${Statics.getLabel('SaaptaahikMilan')} ${Statics.getLabel('pratinidhitva')} ",
//                     value: "$selectedMilanCount",
//                   ),
//                   SingleColumnRow(
//                     rowColor: Colors.grey.shade300,
//                     txtString: " ${Statics.getLabel('SaaptaahikMilan')} ${Statics.getLabel('average')} ${Statics.getLabel('pratinidhitva')} ",
//                     value: ((data?.shakhaalist ?? []).where((item) => item.frequencyName == "साप्ताहिक मिलन").length > 0
//                             ? ((selectedMilanCount / ((data?.shakhaalist ?? []).where((item) => item.frequencyName == "साप्ताहिक मिलन").length)) * 100).round().toString()
//                             : "0") +
//                         " %",
//                   ),
//                 ],
//               ),
//             ),
// // ================================== 9 QUESTIONS Box ==================================================================================================================================================================================================================================================================================================================================================
//             mainContainer(
//               "${Statics.getLabel('milanMandali')} ${Statics.getLabel('pratinidhitva')}",
//               Column(
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     children: [
//                       InkWell(
//                         onTap: () {
//                           if (!_searched) {
//                             Fluttertoast.showToast(
//                               msg: "${Statics.getLabel('NagarSelectionImportant')}",
//                             );
//                             return;
//                           }
//                           showSanghaMandalialistPopup(
//                             context,
//                             sanghaMandalialist: data?.shakhaalist ?? [],
//                             preselectedItems: checkboxSanghaMandaliSelectedItems,
//                             onSubmit: (selectedItems, counts) {
//                               setState(() {
//                                 selectedSanghaMandaliPratinidhitwaVastiIds = selectedItems.map((e) => e.geoUnitID.toString()).join(",");
//                                 checkboxSanghaMandaliSelectedItems = selectedItems;
//                                 countsSanghaMandali = counts; // model me store
//
//                                 // ✅ Total shakha count
//                                 totalSanghaMandaliCount = (data?.shakhaalist ?? []).where((item) => item.frequencyName == "मासिक मिलन/संघ मंडळी").length;
//
//                                 // ✅ Selected shakha count
//                                 selectedSanghaMandaliCount = selectedItems.where((item) => item.frequencyName == "मासिक मिलन/संघ मंडळी").length;
//
//                                 // ✅ Average shakha count (percentage)
//                                 if (totalSanghaMandaliCount > 0) {
//                                   averageSanghaMandaliCount = ((selectedSanghaMandaliCount / totalSanghaMandaliCount) * 100).round().toString();
//                                 } else {
//                                   averageSanghaMandaliCount = "0";
//                                 }
//                               });
//                             },
//                           );
//                         },
//                         child: Container(
//                           padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 14),
//                           // width: 200,
//                           height: 35,
//                           decoration: BoxDecoration(
//                             border: Border.all(color: Colors.purpleAccent.shade100),
//                             borderRadius: BorderRadius.circular(15),
//                           ),
//                           child: Center(
//                             child: Text(
//                               "${Statics.getLabel('selectSanghaMandali')}",
//                               style: const TextStyle(
//                                 color: Colors.purpleAccent,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 10),
//
//                   // ✅ Results after submit
//                   SingleColumnRow(
//                     txtString: "${Statics.getLabel('Total')} ${Statics.getLabel('milanMandali')} ",
//                     value: "${(data?.shakhaalist ?? []).where((item) => item.frequencyName == "मासिक मिलन/संघ मंडळी").length}",
//                   ),
//                   SingleColumnRow(
//                     txtString: " ${Statics.getLabel('milanMandali')} ${Statics.getLabel('pratinidhitva')} ",
//                     value: "$selectedSanghaMandaliCount",
//                   ),
//                   SingleColumnRow(
//                     rowColor: Colors.grey.shade300,
//                     txtString: "${Statics.getLabel('milanMandali')}  ${Statics.getLabel('average')}  ${Statics.getLabel('pratinidhitva')} ",
//                     value: ((data?.shakhaalist ?? []).where((item) => item.frequencyName == "मासिक मिलन/संघ मंडळी").length > 0
//                             ? ((selectedSanghaMandaliCount / ((data?.shakhaalist ?? []).where((item) => item.frequencyName == "मासिक मिलन/संघ मंडळी").length)) * 100).round().toString()
//                             : "0") +
//                         " %",
//                   ),
//                 ],
//               ),
//             ),
// // ================================== 10 QUESTIONS Box ==================================================================================================================================================================================================================================================================================================================================================
//             mainContainer(
//               "${Statics.getLabel('Total')} ${Statics.getLabel('pratinidhitva')}",
//               Column(
//                 children: [
//                   // ✅ Total
//                   SingleColumnRow(
//                     txtString: "${Statics.getLabel('Total')} ",
//                     value:
//                         "${((data?.shakhaalist ?? []).where((item) => item.frequencyName == "शाखा").length) + ((data?.shakhaalist ?? []).where((item) => item.frequencyName == "साप्ताहिक मिलन").length) + ((data?.shakhaalist ?? []).where((item) => item.frequencyName == "मासिक मिलन/संघ मंडळी").length)}",
//                   ),
//
//                   // ✅ Selected
//                   SingleColumnRow(
//                     txtString: "${Statics.getLabel('Total')}  ${Statics.getLabel('pratinidhitva')}",
//                     value: "${selectedShakhaCount + selectedMilanCount + selectedSanghaMandaliCount}",
//                   ),
//
//                   // ✅ Average (calculated from above two)
//                   SingleColumnRow(
//                     rowColor: Colors.grey.shade300,
//                     txtString: "${Statics.getLabel('Total')}  ${Statics.getLabel('average')}  ${Statics.getLabel('pratinidhitva')} ",
//                     value: (() {
//                       final total = ((data?.shakhaalist ?? []).where((item) => item.frequencyName == "शाखा").length) +
//                           ((data?.shakhaalist ?? []).where((item) => item.frequencyName == "साप्ताहिक मिलन").length) +
//                           ((data?.shakhaalist ?? []).where((item) => item.frequencyName == "मासिक मिलन/संघ मंडळी").length);
//                       final selected = selectedShakhaCount + selectedMilanCount + selectedSanghaMandaliCount;
//
//                       if (total == 0) return "0 %";
//                       final avg = ((selected / total) * 100).round();
//                       return "$avg %";
//                     })(),
//                   ),
//                 ],
//               ),
//             ),
// ================================== 11 QUESTIONS Box ==================================================================================================================================================================================================================================================================================================================================================
            mainContainer(
              "${Statics.getLabel('sanmelanJoinedCount')}",
              Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: textControllerField2(
                          name: Statics.getLabel("presentMatrushakti"),
                          controller: presentMatrushaktiController,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: textControllerField2(
                          name: Statics.getLabel("presentMale"),
                          controller: presentMaleController,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  //
                  // SingleColumnRow(
                  //   txtString: "${Statics.getLabel('presentTotalMaleFemale')} ",
                  //   value: total.toString(),
                  // ),
                  //
                  // SingleColumnRow(
                  //   txtString: "${Statics.getLabel('presentGanveshatTotal')} ",
                  //   value: _getColumnTotal([ganShishuBaalCtrl, ganMahavidyaCtrl, ganTarunVyavCtrl, ganProudhVyavCtrl]).toString(),
                  // ),
                  //
                  // SingleColumnRow(
                  //   txtString: "${Statics.getLabel('otherSwayamsewakPresentCount')} ",
                  //   value: _getColumnTotal([anyaShishuBaalCtrl, anyaMahavidyaCtrl, anyaTarunVyavCtrl, anyaProudhVyavCtrl]).toString(),
                  // ),
                  //
                  // SingleColumnRow(
                  //   txtString: "${Statics.getLabel('presentSamajik')} ",
                  //   value: "${totalShakhaCount + totalMilanCount + totalSanghaMandaliCount}",
                  // ),
                  // ✅ Total
                  SingleColumnRow(
                    rowColor: Colors.grey.shade300,
                    txtString: "${Statics.getLabel('presentTotal')} ",
                    value: total.toString(),
                    // value: "${total + _getColumnTotal([ganShishuBaalCtrl, ganMahavidyaCtrl, ganTarunVyavCtrl, ganProudhVyavCtrl]) + _getColumnTotal([
                    //           anyaShishuBaalCtrl,
                    //           anyaMahavidyaCtrl,
                    //           anyaTarunVyavCtrl,
                    //           anyaProudhVyavCtrl
                    //         ])}",
                  ),
                  // const SizedBox(height: 10),
                  // Text(
                  //   "${Statics.getLabel('Total')} : $total",
                  //   style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  // ),
                ],
              ),
            ),
// ================================== 12 QUESTIONS Box =======================================================================
            mainContainer(
              "${Statics.getLabel('moreInfo')}",
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    Statics.getLabel("sanmelanFormat"),
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
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
                  Divider(height: 32),
                  filePickerField1(
                    question: "${Statics.getLabel('AddSanmelanFiles')}",
                    subtitle: "${Statics.getLabel('AddSanmelanFilesSubtitle')}",
                    // selectedFileName: selectedFileName,
                    // onFileSelected: (base64File, fileName) {
                    //   setState(() {
                    //     selectedFilePath = base64File;
                    //     // selectedFileName = fileName;
                    //     imageAdd = 1;
                    //   });
                    //   log("Selected File Path (Base64): $selectedFilePath");
                    // },
                    loadingNotifier: loadingNotifier1,
                    // loadingNotifier2: loadingNotifier3,
                    context: context,
                  ),
                  Divider(height: 32),
                  filePickerField2(
                    question: "${Statics.getLabel('AddAdvSanmelanFiles')}",
                    subtitle: "${Statics.getLabel('AddAdvSanmelanFilesSubtitle')}",
                    loadingNotifier: loadingNotifier2,
                    // loadingNotifier2: loadingNotifier3,
                    context: context,
                  ),
                  Divider(height: 32),
                  addUrlsListWidget(
                    question: "${Statics.getLabel('AddLinks')}",
                    context: context,
                  )
                ],
              ),
            ),
//==============================  SUBMIT BUTTON =======================================================================

            SizedBox(height: 24),
            Container(
              child: MaterialButton(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                color: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                onPressed: () {
                  if (!_searched) {
                    Fluttertoast.showToast(msg: "${Statics.getLabel('NagarSelectionImportant')}");
                    return;
                  }
                  // if (_selectedFileNames1.isNotEmpty && txtUtsavPhotoDescController.text.trim().isEmpty) {
                  //   Statics.showToast("${Statics.getLabel('AddSanmelanFilesDesc')}", toastLength: Toast.LENGTH_LONG);
                  //   return;
                  // }
                  // if (_selectedFileNames2.isNotEmpty && txtUtsavAddPhotoDescController.text.trim().isEmpty) {
                  //   Statics.showToast("${Statics.getLabel('AddAdvSanmelanFilesDesc')}", toastLength: Toast.LENGTH_LONG);
                  //   return;
                  // }
                  if (txtUrlsController.text.trim().isNotEmpty && txtUrlDescController.text.trim().isEmpty) {
                    Statics.showToast("${Statics.getLabel('urlDescIsImp')}", toastLength: Toast.LENGTH_LONG);
                    return;
                  }
                  if (txtUrlsController.text.trim().isNotEmpty && txtUrlDescController.text.trim().isNotEmpty) {
                    Statics.showToast("${Statics.getLabel('clickOnAddBtn')}", toastLength: Toast.LENGTH_LONG);
                    return;
                  }
                  // if ([null, 2].contains(programNirdharitVed) || [null, 2].contains(programHishobh24Hour)) {
                  //   Fluttertoast.showToast(msg: "${Statics.getLabel('impInfoRequired')}");
                  //   return;
                  // }
                  submitForm();
                },
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
    );
  }

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
            // dataRowMinHeight: 30,
            // dataRowMaxHeight: 70,
            showCheckboxColumn: _markAtt,
            headingRowColor: MaterialStatePropertyAll(Colors.purple.shade50),
            headingTextStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
            columns: [
              // if (!isAbhiyaanButPramukh) DataColumn(label: SizedBox()),
              DataColumn(
                  label: Text(
                "${Statics.getLabel('Name')}",
              )),
              DataColumn(
                  label: Text(
                "${Statics.getLabel('sanmelanVaktaTask')}",
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
                    DataCell(Container(constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width * 0.4), child: Text(data.name ?? ''))),
                    DataCell(Text(data.desgination ?? '')),
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
                              SizedBox(),
                              _buildInfoRow("${Statics.getLabel('sanmelanVaktaTask')}", selectedData.desgination),
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
                  txtVaktaTaskController.text = vaktaList[selectedVaktaIndex!].desgination ?? "--";
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
                    name: Statics.getLabel("sanmelanVaktaTask"),
                    controller: txtVaktaTaskController,
                    keyboardType: TextInputType.name,
                  ),
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
                          vaktaList.add(AbhiyaanPeopleModel(pkid: 0, name: txtVaktaNameController.text.trim(), desgination: txtVaktaTaskController.text.trim(), isactive: 1));
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

  Widget vastiMandalDropdown() {
    return Container(
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
                  "${Statics.getLabel('selectVastiMandal')}",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              );
            },
            body: Container(
              margin: EdgeInsets.all(10),
              child: Column(
                children: [
                  if (_linkedMahaanagar != null)
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
                          _selctedLevel = 'Mahanagar';
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
                          _selctedLevel = 'Vibhaag';
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
                          _selctedLevel = 'Bhaag';
                          _selctedLevelName = selectedItem.name ?? "";
                          _linkedbhaagName = selectedItem.name ?? "";
                          _selectedGeoUnitId = value;
                          populatelinkedShaharDropdown(value!);
                          populatelinkedNagarDropdown(value, null);
                        });
                      },
                      isDisabled: false,
                    ),
                  if (_linkedshahar != null && _linkedshahar!.isNotEmpty)
                    _buildDropdownField(
                      label: Statics.getLabel('Shahar'),
                      value: _linkedshaharValue,
                      items: _linkedshahar!
                          .map((bg) => DropdownMenuItem(
                                value: bg.geoUnitID.toString(),
                                child: Text(bg.name!),
                              ))
                          .toList(),
                      onChanged: (value) {
                        final selectedItem = _linkedshahar!.firstWhere((bg) => bg.geoUnitID.toString() == value);
                        setState(() {
                          _linkedshaharValue = value;
                          _selectedGeoUnitId = value;
                          _selctedLevel = 'Shahar';
                          _selctedLevelName = selectedItem.name ?? "";
                          _linkedshaharName = selectedItem.name ?? "";
                          populatelinkedNagarDropdown(null, value);
                        });
                      },
                      isDisabled: false,
                    ),
                  if (_linkednagar != null && _linkednagar!.isNotEmpty)
                    _buildDropdownField(
                      label: Statics.getLabel('Nagar'),
                      value: _linkednagarValue,
                      items: _linkednagar!
                          .map((bg) => DropdownMenuItem(
                                value: bg.geoUnitID.toString(),
                                child: Text(bg.name!),
                              ))
                          .toList(),
                      onChanged: (value) {
                        final selectedItem = _linkednagar!.firstWhere((bg) => bg.geoUnitID.toString() == value);
                        setState(() {
                          _linkednagarValue = value;
                          _selectedGeoUnitId = value;
                          _selctedLevel = 'Nagar';
                          _selctedLevelName = selectedItem.name ?? "";
                          _linkednagarName = selectedItem.name ?? "";
                          populatelinkedMandalDropdown(value);
                          populatelinkedVastiDropdown(value);
                        });
                      },
                      isDisabled: false,
                    ),
                  if (_linkedmandal != null && _linkedmandal!.isNotEmpty)
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
                          _selctedLevel = 'Mandal';
                          _selctedLevelName = selectedItem.name ?? "";
                          _linkedmandalName = selectedItem.name ?? "";
                          populatelinkedGraamDropdown(value);
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
                  if (_linkedvasti != null && _linkedvasti!.isNotEmpty)
                    _buildDropdownField(
                      label: Statics.getLabel('Vasti'),
                      value: _linkedvastiValue,
                      items: _linkedvasti!
                          .map((bg) => DropdownMenuItem(
                                value: bg.geoUnitID.toString(),
                                child: Text(bg.name!),
                              ))
                          .toList(),
                      onChanged: (value) {
                        final selectedItem = _linkedvasti!.firstWhere((bg) => bg.geoUnitID.toString() == value);
                        setState(() {
                          _linkedvastiValue = value;
                          _selectedGeoUnitId = value.toString();
                          _selctedLevel = 'Vasti';
                          _selctedLevelName = selectedItem.name ?? "";
                          _linkedvastiName = selectedItem.name ?? "";
                        });
                      },
                      isDisabled: false,
                    ),
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

                          await _getForm();

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
                              _selectedGeoUnitId = null;
                              _linkedMahaanagarValue = _linkedbhaagValue = _linkedshaharValue = _linkednagarValue = _linkedmandalValue = _linkedvastiValue = _linkedgraamValue = null;
                              _linkedVibhaagValue = _linkedbhaag = _linkedshahar = _linkedgraam = _linkedmandal = _linkedvasti = _linkednagar = null;
                              _selctedLevel = "praant";
                            });
                            clearForm();
                            await populateDropdown();
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
        value: value == "" ? null : value,
        items: items,
        onChanged: onChanged,
      ),
    );
  }

  String? selectedFilePath;
  String? filePathOg;
  List<TypeValueData?> _selectedFileNames1 = []; // To display the file name
  List<TypeValueData?> _selectedFileNames2 = []; // To display the file name
  List<TypeValueData?> _urlsList = []; // To display the file name
  // int? imageAdd = 0;
  final int _maxImages = 3;
  final int _maxAddImages = 10;
  ValueNotifier<bool> loadingNotifier1 = ValueNotifier(false);
  ValueNotifier<bool> loadingNotifier2 = ValueNotifier(false);
  ValueNotifier<bool> loadingNotifier3 = ValueNotifier(false);

  Widget filePickerField1({
    required BuildContext context,
    required String question,
    required String subtitle,
    // required Function(String?, String?) onFileSelected,
    // List<String?> selectedFileNames,
    int? questionNumber,
    bool isLoading = false,
    ValueNotifier<bool>? loadingNotifier,
    // required ValueNotifier<bool> loadingNotifier2,
  }) {
    final canAddMore = _selectedFileNames1.length < _maxImages;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${questionNumber != null ? "$questionNumber. " : ""}$question",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {
                if (_selectedFileNames1.isNotEmpty) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Material(
                        child: StatefulBuilder(builder: (context, set) {
                          String _currentImg = "";
                          return Container(
                            color: Colors.transparent,
                            padding: const EdgeInsets.all(20),
                            child: ListView(
                              // mainAxisSize: MainAxisSize.min,
                              children: [
                                Align(
                                  alignment: Alignment.topRight,
                                  child: IconButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    icon: Icon(Icons.close, color: Colors.black),
                                  ),
                                ),
                                SizedBox(height: 10),
                                ..._selectedFileNames1.asMap().entries.map((entry) {
                                  int index = entry.key; // index
                                  var img = entry.value;
                                  return Container(
                                    margin: EdgeInsets.only(bottom: 12),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                "${(index + 1)}. ${img?.value}",
                                                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                                              ),
                                            ),
                                            IconButton(
                                              onPressed: () async {
                                                set(() {
                                                  _currentImg = img.toString();
                                                });
                                                set(() {
                                                  loadingNotifier3.value = true;
                                                });
                                                setState(() {});
                                                print(img.toString() == _currentImg);
                                                print("printing img name >>>>>>>> ${img?.value}");
                                                log("printing img name >>>>>>>> ${img?.value}");
                                                await MyAppGlobals.downloadFile('${Statics.baseUrl}/Files/hindusanmelanfiles/${img?.value}', (img?.value).toString());
                                                set(() {
                                                  loadingNotifier3.value = false;
                                                });

                                                setState(() {});
                                                set(() {
                                                  _currentImg = "";
                                                });
                                              },
                                              icon: ValueListenableBuilder<bool>(
                                                valueListenable: loadingNotifier3,
                                                builder: (context, isLoading, _) {
                                                  return (isLoading && img.toString() == _currentImg)
                                                      ? SizedBox(
                                                          width: 17,
                                                          height: 17,
                                                          child: CircularProgressIndicator(strokeWidth: 2),
                                                        )
                                                      : Icon(
                                                          Icons.download,
                                                          color: Colors.purple,
                                                        );
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 6),
                                        Text(
                                          img?.description ?? "--",
                                          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14.5),
                                        ),
                                        SizedBox(height: 6),
                                        CachedNetworkImage(
                                          imageUrl: '${Statics.baseUrl}/Files/hindusanmelanfiles/${img?.value}',
                                          errorWidget: (context, error, stackTrace) =>
                                              SizedBox(width: MediaQuery.sizeOf(context).width, height: 120, child: Center(child: Text(Statics.getLabel("errorOccurred")))),
                                          progressIndicatorBuilder: (context, child, loadingProgress) =>
                                              SizedBox(width: MediaQuery.sizeOf(context).width, height: 120, child: Center(child: CircularProgressIndicator())),
                                          fit: BoxFit.contain,
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                              ],
                            ),
                          );
                        }),
                      );
                    },
                  );
                }
              },
              icon: Icon(Icons.remove_red_eye, color: Colors.purpleAccent),
            ),
          ],
        ),
        SizedBox(height: 8),
        ..._selectedFileNames1.map(
          (img) => Container(
            margin: EdgeInsets.only(bottom: 8),
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black54, width: 1),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    img?.value ?? "${Statics.getLabel('selectFile')}",
                    style: TextStyle(color: Colors.black87),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  style: IconButton.styleFrom(tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                  onPressed: () async {
                    final _shouldDelete = await showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        backgroundColor: Colors.white,
                        title: Text(
                          "${Statics.getLabel('AskConfirmation')}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red.shade700,
                            fontSize: 18,
                          ),
                        ),
                        content: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            "${Statics.getLabel('AreyouSureYouWantToDeleteImage')}",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.red.shade800,
                            ),
                          ),
                        ),
                        actions: [
                          TextButton(
                            child: Text(Statics.getLabel('ConfirmationNo')),
                            onPressed: () {
                              Navigator.of(ctx).pop(false);
                            },
                          ),
                          TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.red.shade700,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            ),
                            onPressed: () => Navigator.of(ctx).pop(true),
                            child: Text(
                              "${Statics.getLabel('ConfirmationYes')}",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    );

                    if (_shouldDelete) {
                      final _result = await deleteImageDataFun(imageName: (img?.value).toString());
                      if (_result) {
                        setState(() {
                          _selectedFileNames1.remove(img);
                        });
                      }
                    }
                  },
                  icon: Icon(Icons.delete_forever, color: Colors.red),
                ),
              ],
            ),
          ),
        ),
        if (canAddMore)
          Align(
            alignment: Alignment.centerRight,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                side: const BorderSide(color: Colors.purpleAccent, width: 1.5),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                textStyle: const TextStyle(fontSize: 14, color: Colors.purple),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              ),
              onPressed: () async {
                if (!_searched) {
                  Fluttertoast.showToast(
                    msg: "${Statics.getLabel('NagarSelectionImportant')}",
                  );
                  return;
                }
                loadingNotifier?.value = true;
                XFile? result;
                final isCamera = await showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (ctx) => PopScope(
                    canPop: false,
                    child: AlertDialog(
                      title: Text(Statics.getLabel('AddSanmelanFiles')),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        spacing: 8,
                        children: [
                          TextFormField(
                            controller: txtUtsavPhotoDescController,
                            textAlignVertical: TextAlignVertical.center,
                            // textAlign: TextAlign.left,
                            autofocus: false,
                            readOnly: !_searched,
                            onTap: () {
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
                              hintText: Statics.getLabel("AddSanmelanFilesDesc"),
                              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                              // enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                              // focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.purple),borderRadius: BorderRadius.circular(12)),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return Statics.getLabel("AddSanmelanFilesDesc");
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              IconButton.filled(
                                onPressed: () async {
                                  if (txtUtsavPhotoDescController.text.trim().isEmpty) {
                                    Statics.showToast(Statics.getLabel("AddSanmelanFilesDesc"));
                                    return;
                                  }
                                  Navigator.of(ctx).pop(true);
                                },
                                icon: Icon(Icons.camera_alt),
                              ),
                              IconButton.filled(
                                onPressed: () async {
                                  if (txtUtsavPhotoDescController.text.trim().isEmpty) {
                                    Statics.showToast(Statics.getLabel("AddSanmelanFilesDesc"));
                                    return;
                                  }
                                  Navigator.of(ctx).pop(false);
                                },
                                icon: Icon(Icons.photo_library),
                              ),
                            ],
                          ),
                        ],
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: Text(Statics.getLabel('clear')),
                          onPressed: () {
                            Navigator.of(ctx).pop();
                            setState(() {
                              loadingNotifier?.value = false;
                            });
                          },
                        )
                      ],
                    ),
                  ),
                );
                setState(() {});

                if (isCamera == null) return;

                if (isCamera) {
                  result = await ImagePicker().pickImage(source: ImageSource.camera);
                } else {
                  result = await ImagePicker().pickImage(source: ImageSource.gallery);
                }
                setState(() {});
                // showLoaderDialog(context);
                try {
                  if (result != null) {
                    // final random = m.Random();
                    final _imgName = m.Random().nextInt(99999999);
                    String filePath = File(result.path).path;
                    filePathOg = File(result.path).path;
                    String fileName = isCamera ? "Img_${_imgName}.${filePathOg?.split("/").last.split(".").last}" : filePathOg!.split("/").last;
                    File file = File(filePath);
                    img.Image? originalImage = img.decodeImage(file.readAsBytesSync());
                    if (originalImage != null) {
                      img.Image compressedImage = img.copyResize(originalImage, width: originalImage.width);
                      while (compressedImage.length > 2 * 1024 * 1024) {
                        compressedImage = img.copyResize(compressedImage, width: (compressedImage.width * 0.9).toInt());
                      }
                      List<int> compressedBytes = img.encodeJpg(compressedImage, quality: 85);
                      String base64String = base64Encode(compressedBytes);
                      String base64File = "data:image/jpg;base64,$base64String";
                      selectedFilePath = base64File;
                      final _result = await submitImageDataFun(type: "img", showLoader: true, description: txtUtsavPhotoDescController.text.trim());
                      _selectedFileNames1.add(TypeValueData(type: "img", value: _result ?? fileName, description: txtUtsavPhotoDescController.text.trim()));
                      setState(() {
                        txtUtsavPhotoDescController.clear();
                        txtUtsavAddPhotoDescController.clear();
                      });
                    }
                  }
                } catch (e) {
                  log("Error during file processing: $e");
                } finally {
                  loadingNotifier?.value = false;
                }
                setState(() {});
                // Navigator.of(context).pop();

                // log("Selected File Path (Base64): $selectedFilePath");
              },
              child: loadingNotifier != null
                  ? ValueListenableBuilder<bool>(
                      valueListenable: loadingNotifier,
                      builder: (context, isLoading, _) {
                        return isLoading
                            ? SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : Text(
                                "+ ${Statics.getLabel("AddMore")}",
                                style: const TextStyle(fontSize: 14, color: Colors.purple),
                              );
                      },
                    )
                  : Text(
                      "+ ${Statics.getLabel("AddMore")}",
                      style: const TextStyle(fontSize: 14, color: Colors.purple),
                    ),
            ),
          ),
        SizedBox(height: 14),
        // TextFormField(
        //   controller: txtUtsavPhotoDescController,
        //   textAlignVertical: TextAlignVertical.center,
        //   // textAlign: TextAlign.left,
        //   autofocus: false,
        //   readOnly: !_searched,
        //   onTap: () {
        //     if (!_searched) {
        //       Fluttertoast.showToast(
        //         msg: "${Statics.getLabel('NagarSelectionImportant')}",
        //       );
        //     }
        //   },
        //   maxLines: 5,
        //   onChanged: (value) => setState(() {}),
        //   onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
        //   decoration: InputDecoration(
        //     hintText: Statics.getLabel("AddSanmelanFilesDesc"),
        //     contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        //     border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        //     // enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        //     // focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.purple),borderRadius: BorderRadius.circular(12)),
        //   ),
        //   // validator: (value) {
        //   //   // if (value != null && value.trim().isNotEmpty && value.length < 9 && memberController.contactList.value.isEmpty){
        //   //   //   return "Invalid contact number";
        //   //   // }else
        //   //   if (memberController.contactList.value.isEmpty) {
        //   //     if (value == null || value.trim().isEmpty) {
        //   //       return "Please enter contact number";
        //   //     }
        //   //     if (value.length < 9) {
        //   //       return "Invalid contact number";
        //   //     }
        //   //     return null;
        //   //     // return "Please enter at least one contact number";
        //   //   } else {
        //   //     if (value != null && value.trim().isNotEmpty && value.length < 9) {
        //   //       return "Invalid contact number";
        //   //     }
        //   //   }
        //   //
        //   //   return null;
        //   // },
        // ),
      ],
    );
  }

  Widget filePickerField2({
    required BuildContext context,
    required String question,
    required String subtitle,
    // required Function(String?, String?) onFileSelected,
    // List<String?> selectedFileNames,
    int? questionNumber,
    bool isLoading = false,
    ValueNotifier<bool>? loadingNotifier,
    // ValueNotifier<bool>? loadingNotifier2,
  }) {
    final canAddMore = _selectedFileNames2.length < _maxAddImages;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${questionNumber != null ? "$questionNumber. " : ""}$question",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {
                if (_selectedFileNames2.isNotEmpty) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Material(
                        child: StatefulBuilder(builder: (context, set) {
                          String _currentImg = "";
                          return Container(
                            color: Colors.transparent,
                            padding: const EdgeInsets.all(20),
                            child: ListView(
                              // mainAxisSize: MainAxisSize.min,
                              children: [
                                Align(
                                  alignment: Alignment.topRight,
                                  child: IconButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    icon: Icon(Icons.close, color: Colors.black),
                                  ),
                                ),
                                SizedBox(height: 10),
                                ..._selectedFileNames2.asMap().entries.map((entry) {
                                  int index = entry.key; // index
                                  var img = entry.value;
                                  return Container(
                                    margin: EdgeInsets.only(bottom: 12),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                "${(index + 1)}. ${img?.value}",
                                                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                                              ),
                                            ),
                                            IconButton(
                                              onPressed: () async {
                                                set(() {
                                                  _currentImg = img.toString();
                                                });
                                                set(() {
                                                  loadingNotifier3.value = true;
                                                });
                                                await MyAppGlobals.downloadFile('${Statics.baseUrl}/Files/hindusanmelanfiles/${img?.value}', (img?.value).toString());
                                                set(() {
                                                  loadingNotifier3.value = false;
                                                });
                                                set(() {
                                                  _currentImg = "";
                                                });
                                              },
                                              icon: ValueListenableBuilder<bool>(
                                                valueListenable: loadingNotifier3,
                                                builder: (context, isLoading, _) {
                                                  return (isLoading && img.toString() == _currentImg)
                                                      ? SizedBox(
                                                          width: 17,
                                                          height: 17,
                                                          child: CircularProgressIndicator(strokeWidth: 2),
                                                        )
                                                      : Icon(
                                                          Icons.download,
                                                          color: Colors.purple,
                                                        );
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 6),
                                        Text(
                                          img?.description ?? "--",
                                          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14.5),
                                        ),
                                        SizedBox(height: 6),
                                        CachedNetworkImage(
                                          imageUrl: '${Statics.baseUrl}/Files/hindusanmelanfiles/${img?.value}',
                                          errorWidget: (context, error, stackTrace) =>
                                              SizedBox(width: MediaQuery.sizeOf(context).width, height: 120, child: Center(child: Text(Statics.getLabel("errorOccurred")))),
                                          progressIndicatorBuilder: (context, child, loadingProgress) =>
                                              SizedBox(width: MediaQuery.sizeOf(context).width, height: 120, child: Center(child: CircularProgressIndicator())),
                                          fit: BoxFit.contain,
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                              ],
                            ),
                          );
                        }),
                      );
                    },
                  );
                }
              },
              icon: Icon(Icons.remove_red_eye, color: Colors.purpleAccent),
            ),
          ],
        ),
        SizedBox(height: 8),
        ..._selectedFileNames2.map(
          (img) => Container(
            margin: EdgeInsets.only(bottom: 8),
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black54, width: 1),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    img?.value ?? "${Statics.getLabel('selectFile')}",
                    style: TextStyle(color: Colors.black87),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  style: IconButton.styleFrom(tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                  onPressed: () async {
                    final _shouldDelete = await showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        backgroundColor: Colors.white,
                        title: Text(
                          "${Statics.getLabel('AskConfirmation')}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red.shade700,
                            fontSize: 18,
                          ),
                        ),
                        content: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            "${Statics.getLabel('AreyouSureYouWantToDeleteImage')}",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.red.shade800,
                            ),
                          ),
                        ),
                        actions: [
                          TextButton(
                            child: Text(Statics.getLabel('ConfirmationNo')),
                            onPressed: () {
                              Navigator.of(ctx).pop(false);
                            },
                          ),
                          TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.red.shade700,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            ),
                            onPressed: () => Navigator.of(ctx).pop(true),
                            child: Text(
                              "${Statics.getLabel('ConfirmationYes')}",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    );

                    if (_shouldDelete) {
                      final _result = await deleteImageDataFun(imageName: (img?.value).toString());
                      if (_result) {
                        setState(() {
                          _selectedFileNames2.remove(img);
                        });
                      }
                    }
                  },
                  icon: Icon(Icons.delete_forever, color: Colors.red),
                ),
              ],
            ),
          ),
        ),
        if (canAddMore)
          Align(
            alignment: Alignment.centerRight,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                side: const BorderSide(color: Colors.purpleAccent, width: 1.5),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                textStyle: const TextStyle(fontSize: 14, color: Colors.purple),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              ),
              onPressed: () async {
                if (!_searched) {
                  Fluttertoast.showToast(
                    msg: "${Statics.getLabel('NagarSelectionImportant')}",
                  );
                  return;
                }
                loadingNotifier?.value = true;
                XFile? result;
                final isCamera = await showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (ctx) => PopScope(
                    canPop: false,
                    child: AlertDialog(
                      title: Text(Statics.getLabel('AddSanmelanFiles')),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        spacing: 8,
                        children: [
                          TextFormField(
                            controller: txtUtsavAddPhotoDescController,
                            textAlignVertical: TextAlignVertical.center,
                            // textAlign: TextAlign.left,
                            autofocus: false,
                            readOnly: !_searched,
                            onTap: () {
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
                              hintText: Statics.getLabel("AddAdvSanmelanFilesDesc"),
                              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                              // enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                              // focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.purple),borderRadius: BorderRadius.circular(12)),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return Statics.getLabel("AddAdvSanmelanFilesDesc");
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              IconButton.filled(
                                onPressed: () async {
                                  if (txtUtsavPhotoDescController.text.trim().isEmpty) {
                                    Statics.showToast(Statics.getLabel("AddAdvSanmelanFilesDesc"));
                                    return;
                                  }
                                  Navigator.of(ctx).pop(true);
                                },
                                icon: Icon(Icons.camera_alt),
                              ),
                              IconButton.filled(
                                onPressed: () async {
                                  if (txtUtsavPhotoDescController.text.trim().isEmpty) {
                                    Statics.showToast(Statics.getLabel("AddAdvSanmelanFilesDesc"));
                                    return;
                                  }
                                  Navigator.of(ctx).pop(false);
                                },
                                icon: Icon(Icons.photo_library),
                              ),
                            ],
                          ),
                        ],
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: Text(Statics.getLabel('clear')),
                          onPressed: () {
                            Navigator.of(ctx).pop();
                            setState(() {
                              loadingNotifier?.value = false;
                            });
                          },
                        )
                      ],
                    ),
                  ),
                );
                setState(() {});

                if (isCamera == null) return;

                if (isCamera) {
                  result = await ImagePicker().pickImage(source: ImageSource.camera);
                } else {
                  result = await ImagePicker().pickImage(source: ImageSource.gallery);
                }
                setState(() {});
                // showLoaderDialog(context);
                try {
                  if (result != null) {
                    // final random = m.Random();
                    final _imgName = m.Random().nextInt(9999999);
                    String filePath = File(result.path).path;
                    filePathOg = File(result.path).path;
                    String fileName = isCamera ? "Img_${_imgName}.${filePathOg?.split("/").last.split(".").last}" : filePathOg!.split("/").last;
                    File file = File(filePath);
                    img.Image? originalImage = img.decodeImage(file.readAsBytesSync());
                    if (originalImage != null) {
                      img.Image compressedImage = img.copyResize(originalImage, width: originalImage.width);
                      while (compressedImage.length > 2 * 1024 * 1024) {
                        compressedImage = img.copyResize(compressedImage, width: (compressedImage.width * 0.9).toInt());
                      }
                      List<int> compressedBytes = img.encodeJpg(compressedImage, quality: 85);
                      String base64String = base64Encode(compressedBytes);
                      String base64File = "data:image/jpg;base64,$base64String";
                      selectedFilePath = base64File;
                      final _result = await submitImageDataFun(type: "advimg", showLoader: true, description: txtUtsavPhotoDescController.text.trim());
                      _selectedFileNames2.add(TypeValueData(type: "advimg", description: txtUtsavPhotoDescController.text.trim(), value: _result ?? fileName));
                      setState(() {
                        txtUtsavPhotoDescController.clear();
                        txtUtsavAddPhotoDescController.clear();
                      });
                    }
                  }
                } catch (e) {
                  log("Error during file processing: $e");
                } finally {
                  loadingNotifier?.value = false;
                }
                setState(() {
                  loadingNotifier?.value = false;
                });
                // Navigator.of(context).pop();

                // log("Selected File Path (Base64): $selectedFilePath");
              },
              child: loadingNotifier != null
                  ? ValueListenableBuilder<bool>(
                      valueListenable: loadingNotifier,
                      builder: (context, isLoading, _) {
                        return isLoading
                            ? SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : Text(
                                "+ ${Statics.getLabel("AddMore")}",
                                style: const TextStyle(fontSize: 14, color: Colors.purple),
                              );
                      },
                    )
                  : Text(
                      "+ ${Statics.getLabel("AddMore")}",
                      style: const TextStyle(fontSize: 14, color: Colors.purple),
                    ),
            ),
          ),
        SizedBox(height: 14),
        // Text(
        //   "वर्तमान पत्राचे नाव, दिनांक  आणि आवृत्ति",
        //   style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600, color: Colors.grey.shade700, fontStyle: FontStyle.italic),
        // ),
        // SizedBox(height: 14),
        // TextFormField(
        //   controller: txtUtsavAddPhotoDescController,
        //   textAlignVertical: TextAlignVertical.center,
        //   // textAlign: TextAlign.left,
        //   autofocus: false,
        //   readOnly: !_searched,
        //   onTap: () {
        //     if (!_searched) {
        //       Fluttertoast.showToast(
        //         msg: "${Statics.getLabel('NagarSelectionImportant')}",
        //       );
        //     }
        //   },
        //   maxLines: 5,
        //   onChanged: (value) => setState(() {}),
        //   onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
        //   decoration: InputDecoration(
        //     hintText: Statics.getLabel("AddAdvSanmelanFilesDesc"),
        //     contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        //     border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        //     // enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        //     // focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.purple),borderRadius: BorderRadius.circular(12)),
        //   ),
        //   // validator: (value) {
        //   //   // if (value != null && value.trim().isNotEmpty && value.length < 9 && memberController.contactList.value.isEmpty){
        //   //   //   return "Invalid contact number";
        //   //   // }else
        //   //   if (memberController.contactList.value.isEmpty) {
        //   //     if (value == null || value.trim().isEmpty) {
        //   //       return "Please enter contact number";
        //   //     }
        //   //     if (value.length < 9) {
        //   //       return "Invalid contact number";
        //   //     }
        //   //     return null;
        //   //     // return "Please enter at least one contact number";
        //   //   } else {
        //   //     if (value != null && value.trim().isNotEmpty && value.length < 9) {
        //   //       return "Invalid contact number";
        //   //     }
        //   //   }
        //   //
        //   //   return null;
        //   // },
        // ),
      ],
    );
  }

  Widget addUrlsListWidget({
    required BuildContext context,
    required String question,
    int? questionNumber,
  }) {
    // final canAddMore = _urlsList.length < _maxImages;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "${questionNumber != null ? "$questionNumber. " : ""}$question",
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        // if (canAddMore)
        Column(
          children: [
            TextFormField(
              controller: txtUrlsController,
              textAlignVertical: TextAlignVertical.center,
              // textAlign: TextAlign.left,
              autofocus: false,
              readOnly: !_searched,
              onTap: () {
                if (!_searched) {
                  Fluttertoast.showToast(
                    msg: "${Statics.getLabel('NagarSelectionImportant')}",
                  );
                }
              },
              onChanged: (value) => setState(() {}),
              onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
              decoration: InputDecoration(
                hintText: Statics.getLabel("url"),
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
            SizedBox(height: 8),
            TextFormField(
              controller: txtUrlDescController,
              textAlignVertical: TextAlignVertical.center,
              // textAlign: TextAlign.left,
              autofocus: false,
              maxLength: 160,
              // minLines: 1,
              maxLines: 5,
              readOnly: !_searched,
              onTap: () {
                if (!_searched) {
                  Fluttertoast.showToast(
                    msg: "${Statics.getLabel('NagarSelectionImportant')}",
                  );
                }
              },
              onChanged: (value) => setState(() {}),
              onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
              decoration: InputDecoration(
                hintText: Statics.getLabel("urlDesc"),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                // enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                // focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  side: const BorderSide(color: Colors.purpleAccent, width: 1.5),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  textStyle: const TextStyle(fontSize: 14, color: Colors.purple),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
                onPressed: () async {
                  // print(contactList.value.toString());
                  if (txtUrlsController.text.trim().isNotEmpty && txtUrlDescController.text.trim().isNotEmpty) {
                    bool valid = await isValidUrl(txtUrlsController.text.trim());
                    print(valid);
                    if (!valid) {
                      Fluttertoast.showToast(msg: "${Statics.getLabel('urlValidation')}");
                      return;
                    }
                    _urlsList.add(TypeValueData(type: "url", value: txtUrlsController.text.trim(), description: txtUrlDescController.text.trim()));
                    txtUrlsController.clear();
                    txtUrlDescController.clear();
                  } else {
                    if (!_searched) {
                      Fluttertoast.showToast(
                        msg: "${Statics.getLabel('NagarSelectionImportant')}",
                      );
                      setState(() {});
                      return;
                    }
                    if (txtUrlDescController.text.trim().isEmpty) {
                      Fluttertoast.showToast(
                        msg: "${Statics.getLabel('urlDescIsImp')}",
                      );
                      setState(() {});
                      return;
                    }
                    Fluttertoast.showToast(msg: "${Statics.getLabel('urlValidation')}");
                    // formKey.currentState?.validate();
                  }
                  setState(() {});
                },
                child: Text("+ ${Statics.getLabel("Add")}"),
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        Wrap(
          runSpacing: 8,
          spacing: 8,
          direction: Axis.horizontal,
          crossAxisAlignment: WrapCrossAlignment.center,
          alignment: WrapAlignment.start,
          runAlignment: WrapAlignment.center,
          children: _urlsList.asMap().entries.map(
            (entry) {
              int srNo = entry.key + 1;
              final url = entry.value;
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey.shade200,
                  border: Border.all(color: Colors.grey.shade200, width: 0.7),
                ),
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      srNo.toString() + ". ",
                      // maxLines: 2, softWrap: true, overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
                      // style: AppTextStyles.labels(Get.context!).copyWith(fontWeight: FontWeight.w500),
                    ),
                    SizedBox(width: 4),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () async {
                              final Uri uri = Uri.parse((url?.value).toString());
                              if (await isValidUrl((url?.value).toString())) {
                                await launchUrl(uri, mode: LaunchMode.externalApplication);
                              } else {
                                Fluttertoast.showToast(msg: "${Statics.getLabel('errorOccurred')}");
                              }
                            },
                            child: Text(
                              (url?.value).toString(),
                              maxLines: 2, softWrap: true, overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline, decorationColor: Colors.blue),
                              // style: AppTextStyles.labels(Get.context!).copyWith(fontWeight: FontWeight.w500),
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            (url?.description).toString(),
                            // maxLines: 2, softWrap: true, overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
                            // style: AppTextStyles.labels(Get.context!).copyWith(fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 8),
                    InkWell(
                      onTap: () async {
                        final _shouldDelete = await showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            backgroundColor: Colors.white,
                            title: Text(
                              "${Statics.getLabel('AskConfirmation')}",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.red.shade700,
                                fontSize: 18,
                              ),
                            ),
                            content: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Text(
                                "${Statics.getLabel('AreyouSureYouWantToDeleteUrl')}",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.red.shade800,
                                ),
                              ),
                            ),
                            actions: [
                              TextButton(
                                child: Text(Statics.getLabel('ConfirmationNo')),
                                onPressed: () {
                                  Navigator.of(ctx).pop(false);
                                },
                              ),
                              TextButton(
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.red.shade700,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                ),
                                onPressed: () => Navigator.of(ctx).pop(true),
                                child: Text(
                                  "${Statics.getLabel('ConfirmationYes')}",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        );

                        if (_shouldDelete) {
                          setState(() {
                            _urlsList.removeWhere((e) => e == url);
                          });
                        }
                      },
                      child: Icon(Icons.delete_forever, color: Colors.red, size: 18),
                    )
                  ],
                ),
              );
            },
          ).toList(),
        ),
        // if (canAddMore)
        //   Align(
        //     alignment: Alignment.centerRight,
        //     child: OutlinedButton(
        //       style: OutlinedButton.styleFrom(
        //         tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        //         side: const BorderSide(color: Colors.purpleAccent, width: 1.5),
        //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        //         textStyle: const TextStyle(fontSize: 14, color: Colors.purple),
        //         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        //       ),
        //       onPressed: () async {
        //         // _urlsList.add();
        //       },
        //       child: Text(
        //         "+ Add more",
        //         style: const TextStyle(fontSize: 14, color: Colors.purple),
        //       ),
        //     ),
        //   )
      ],
    );
  }

// ================================ END  Swayamsewak POPUP ==================================================================

  String? selectedType;

  // int? selectedMukhyaAtithi;

  Future<void> showMukhyaAtithiSelectionPopup(BuildContext context, {sarsajjanshaktiList, sanyaprabhaviList, dynamic preselectedItem}) async {
    // print(vastisarsajjanshaktiList.length);
    dynamic selectedItem = selectedPerson ?? selectedPrabhavi;
    // String? selectedType = preselectedType;
    // _linkedNagarValuePopup = "";
    log("showMukhyaAtithiSelectionPopup Opened >>>>>>>>>>>>>>>>>>>>> ");

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, set) {
            // dynamic selectedItem = preselectedItem ?? data!.vastisarsajjanshakti!.firstWhere((e) => e.pkid == selectedMukhyaAtithi);

            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              insetPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              titlePadding: const EdgeInsets.fromLTRB(12, 20, 12, 0),
              title: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          Statics.getLabel('selectMukhyaAtithi'),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        style: IconButton.styleFrom(tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                        icon: const Icon(Icons.close, color: Colors.redAccent),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  // DropdownButtonFormField(
                  //   decoration: InputDecoration(
                  //     labelText: Statics.getLabel('Nagar'),
                  //     border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  //     enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  //     focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  //   ),
                  //   isExpanded: true,
                  //   value: _linkedNagarValuePopup == "" ? _linkednagarValue : _linkedNagarValuePopup,
                  //   items: _linkednagar?.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                  //   onChanged: (value) async {
                  //     set(() {
                  //       _linkedNagarValuePopup = value;
                  //     });
                  //     final _data = await Statics.getVijayadashamiInitData(context, Statics.userDetails["userID"], value, "6");
                  //     set(() {
                  //       vastisarsajjanshaktiList = _data?.vastisarsajjanshakti ?? [];
                  //       vastisanyaprabhaviList = _data?.vastisanyaprabhavi ?? [];
                  //       if (selectedType == "sarsajjanshakti") {
                  //         selectedItem = preselectedItem ?? vastisarsajjanshaktiList.firstWhere((e) => e.pkid == selectedMukhyaAtithi);
                  //       } else {
                  //         selectedItem = preselectedItem ?? vastisanyaprabhaviList.firstWhere((e) => e.pkId == selectedMukhyaAtithi);
                  //       }
                  //     });
                  //   },
                  // ),
                  // SizedBox(height: 6),
                  Row(
                    spacing: 12,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        ),
                        onPressed: () async {
                          if (selectedItem != null || selectedPerson != null || selectedPrabhavi != null) {
                            Statics.showToast("test");
                            return;
                          }
                          await submitForm();
                          Navigator.of(context).pushReplacementNamed(
                            SearchSajjanAnyaScreen.routeName,
                            arguments: {'geoUnitId': _selectedGeoUnitId, 'fromMukhya': true},
                          ).then(
                            (value) async {
                              await _getForm();
                              setState(() {});
                            },
                          );
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.search,
                              color: Colors.white,
                            ),
                            Text(
                              Statics.getLabel('Search'),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          side: const BorderSide(color: Colors.purpleAccent, width: 1.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        ),
                        onPressed: () async {
                          await submitForm();
                          Navigator.of(context).pushReplacementNamed(
                            AddMukhyaAtithi.routeName,
                            arguments: {'linkedNagar': _linkednagar, 'selectedLevelId': _linkednagarValue},
                          ).then((value) => _getForm());
                        },
                        child: Text(
                          Statics.getLabel('fillNewRecord'),
                          style: const TextStyle(color: Colors.purpleAccent),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              content: Container(
                width: double.maxFinite,
                // height: 400,
                constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * 0.58),
                child: Scrollbar(
                  radius: Radius.circular(8),
                  interactive: true,
                  thumbVisibility: true,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                Statics.getLabel('SajjanShakti'),
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: Colors.blueGrey,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Divider(),

                        // ✅ Table
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black12),
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.white,
                          ),
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
                                    child: Text("🔘", style: TextStyle(fontWeight: FontWeight.bold)),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8),
                                    child: Text("${Statics.getLabel('Name')}", style: TextStyle(fontWeight: FontWeight.bold)),
                                  ),
                                  // Padding(
                                  //   padding: EdgeInsets.all(8),
                                  //   child: Text("${Statics.getLabel('SelectDaayitva')}", style: TextStyle(fontWeight: FontWeight.bold)),
                                  // ),
                                ],
                              ),
                              ...sarsajjanshaktiList.map((item) {
                                return TableRow(
                                  children: [
                                    Center(
                                        child: Radio(
                                      value: item,
                                      groupValue: selectedItem,
                                      activeColor: Colors.purpleAccent,
                                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                      onChanged: (val) {
                                        print("printing the val >>>>>>>> ${jsonEncode(val)}");
                                        set(() {
                                          // item.isMukhyadefault = 1;
                                          selectedItem = item;
                                          selectedType = "sarsajjanshakti";
                                          selectedPrabhavi = null;
                                          // selectedPerson = item;
                                        });
                                        setState(() {});
                                      },
                                    )),
                                    Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Text(item.name ?? "Unknown"),
                                    ),
                                    // Padding(
                                    //   padding: const EdgeInsets.all(8),
                                    //   child: Text(item.da ?? "Unknown"),
                                    // ),
                                  ],
                                );
                              }),
                            ],
                          ),
                        ),
                        // ...vastisarsajjanshaktiList.map((item) {
                        //   return RadioListTile(
                        //     title: Text(item.name ?? "Unknown"),
                        //     value: item,
                        //     groupValue: selectedItem,
                        //     activeColor: Colors.purpleAccent,
                        //     contentPadding: EdgeInsets.zero,
                        //     onChanged: (val) {
                        //       print("printing the val >>>>>>>> ${jsonEncode(val)}");
                        //       set(() {
                        //         selectedItem = val;
                        //         selectedType = "sarsajjanshakti";
                        //       });
                        //     },
                        //   );
                        // }),
                        const SizedBox(height: 16),
                        Text(
                          Statics.getLabel('anyaPrabhaviLok'),
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Colors.blueGrey,
                          ),
                        ),
                        const Divider(),

                        // ✅ Table
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black12),
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.white,
                          ),
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
                                    child: Text("🔘", style: TextStyle(fontWeight: FontWeight.bold)),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8),
                                    child: Text("${Statics.getLabel('Name')}", style: TextStyle(fontWeight: FontWeight.bold)),
                                  ),
                                ],
                              ),
                              ...sanyaprabhaviList.map((item) {
                                return TableRow(
                                  children: [
                                    Center(
                                        child: Radio(
                                      value: item,
                                      groupValue: selectedItem,
                                      activeColor: Colors.purpleAccent,
                                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                      onChanged: (val) {
                                        set(() {
                                          // item.isMukhyadefault = 1;
                                          selectedItem = item;
                                          selectedType = "anyaprabhavi";
                                          selectedPerson = null;
                                          // selectedPrabhavi = item;
                                        });
                                        setState(() {});
                                      },
                                    )),
                                    Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Text(item.name ?? "Unknown"),
                                    ),
                                  ],
                                );
                              }),
                            ],
                          ),
                        ),
                        // ...vastisanyaprabhaviList.map((item) {
                        //   return RadioListTile(
                        //     title: Text(item.name ?? "Unknown"),
                        //     value: item,
                        //     groupValue: selectedItem,
                        //     activeColor: Colors.blueAccent,
                        //     contentPadding: EdgeInsets.zero,
                        //     onChanged: (val) {
                        //       set(() {
                        //         selectedItem = val;
                        //         selectedType = "anyaprabhavi";
                        //       });
                        //     },
                        //   );
                        // }),
                      ],
                    ),
                  ),
                ),
              ),
              actionsPadding: const EdgeInsets.only(left: 12, right: 12, bottom: 12, top: 6),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 12,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purpleAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        ),
                        onPressed: () {
                          if (selectedItem != null && selectedType != null) {
                            set(() {
                              if (selectedType == "sarsajjanshakti") {
                                selectedPerson = selectedItem as Vastisarsajjanshakti;
                                selectedPrabhavi = null;
                                print(selectedPerson?.pkid);
                                // selectedMukhyaAtithi = selectedPerson?.pkid;
                              } else {
                                selectedPrabhavi = selectedItem as Vastisanyaprabhavi;
                                selectedPerson = null;
                                print(selectedPrabhavi?.pkId);
                                // selectedMukhyaAtithi = selectedPrabhavi?.pkId;
                              }
                            });
                            setState(() {});
                          }
                          Navigator.pop(context);
                        },
                        child: Text(
                          Statics.getLabel('Submit'),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    // SizedBox(
                    //   width: 15,
                    // ),
                    if (selectedItem != null || selectedPerson != null || selectedPrabhavi != null)
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.purpleAccent, width: 1.5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          ),
                          onPressed: () {
                            set(() {
                              selectedItem = null;
                              selectedPerson = null;
                              selectedPrabhavi = null;

                              for (final item in data!.vastisarsajjanshakti!) {
                                item.isMukhyadefault = 0;
                              }

                              for (final item in data!.vastisanyaprabhavi!) {
                                item.isMukhyadefault = 0;
                              }
                            });
                            setState(() {});
                          },
                          child: Text(
                            Statics.getLabel('clear'),
                            style: const TextStyle(color: Colors.purpleAccent),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }

  int? selectedVastiCount = 0;
  int totalVastiCount = 0;
  String? selectedBhougolikPratinidhitwaVastiIds;

  Future<void> showGraamVastiMandalUpnagarPopup(
    BuildContext context, {
    required List<UpnagarmandallistVijayaDashami> vastiList,
    List<UpnagarmandallistVijayaDashami>? preselectedItems,
    required void Function(
      List<UpnagarmandallistVijayaDashami> selectedItems,
      int selectedCount,
      int totalCount,
    ) onSubmit,
  }) async {
    print(">>>>>>>>>>> $preselectedItems");
    List<UpnagarmandallistVijayaDashami> selectedItems = List.from(preselectedItems ?? []);
    print((vastiList.length));
    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              insetPadding: const EdgeInsets.all(16),
              child: Container(
                padding: const EdgeInsets.all(16),
                height: MediaQuery.of(context).size.height * 0.6, // ✅ Standard height
                width: double.maxFinite,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ✅ Title & counts
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${Statics.getLabel('addGraam')}",
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
                    Text(
                      "${Statics.getLabel('totalGraam')}: ${vastiList.length}",
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    Text(
                      "${Statics.getLabel('selectedTotal')}: ${selectedItems.length}",
                      style: const TextStyle(fontSize: 14, color: Colors.blue),
                    ),
                    const SizedBox(height: 10),

                    // ✅ List scrollable
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListView.builder(
                          itemCount: vastiList.length,
                          itemBuilder: (context, index) {
                            final item = vastiList[index];
                            final isSelected = selectedItems.contains(item);

                            return CheckboxListTile(
                              title: Text(item.geoUnitName ?? ""),
                              value: selectedItems.any((e) => e.geoUnitID == item.geoUnitID), // ✅ check by id
                              onChanged: (bool? checked) {
                                setState(() {
                                  if (checked == true) {
                                    if (!selectedItems.any((e) => e.geoUnitID == item.geoUnitID)) {
                                      selectedItems.add(item);
                                    }
                                  } else {
                                    selectedItems.removeWhere((e) => e.geoUnitID == item.geoUnitID);
                                  }
                                });
                              },
                            );
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // ✅ Footer Button
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purpleAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      ),
                      onPressed: () {
                        onSubmit(
                          selectedItems,
                          selectedItems.length,
                          vastiList.length,
                        );
                        Navigator.pop(context);
                      },
                      child: Center(
                        child: Text(
                          Statics.getLabel('Submit'),
                          style: const TextStyle(color: Colors.white),
                        ),
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

  String? selectedSajjanshaktiItemsIds;
  String? selectedAnyaprabhaviItemsIds;

  Future<void> showVisheshAtithiSelectionPopup(BuildContext context, {sarsajjanshaktiList, sanyaprabhaviList}) async {
    print("showVisheshAtithiSelectionPopup onTap >>>>>>>>>>>>>>> ");
    // final _sarsajjanshaktiList = data?.vastisarsajjanshakti ?? [];
    // final _sanyaprabhaviList = data?.vastisanyaprabhavi ?? [];

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        if (data == null) {
          return Center(child: CircularProgressIndicator());
        }
        return StatefulBuilder(
          builder: (ctnx, set) {
            return AlertDialog(
              clipBehavior: Clip.antiAlias,
              contentPadding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              content: Container(
                // padding: const EdgeInsets.all(16),
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    /// Title with Close Button
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                      // decoration: const BoxDecoration(
                      //   gradient: LinearGradient(
                      //     colors: [Colors.purple, Colors.purpleAccent],
                      //     begin: Alignment.centerLeft,
                      //     end: Alignment.centerRight,
                      //   ),
                      // ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            Statics.getLabel('selectSpecialPerson'),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.red),
                            onPressed: () => Navigator.pop(ctnx),
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // SizedBox(height: 24),
                            Row(
                              spacing: 12,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    backgroundColor: Colors.green,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                  ),
                                  onPressed: () async {
                                    await submitForm();
                                    Navigator.of(context).pushReplacementNamed(
                                      SearchSajjanAnyaScreen.routeName,
                                      arguments: {'geoUnitId': _selectedGeoUnitId},
                                    ).then(
                                      (value) async {
                                        await _getForm();
                                        setState(() {});
                                      },
                                    );
                                  },
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.search,
                                        color: Colors.white,
                                      ),
                                      Text(
                                        Statics.getLabel('Search'),
                                        style: const TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                                OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(color: Colors.purpleAccent, width: 1.5),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                  ),
                                  onPressed: () async {
                                    await submitForm();
                                    Navigator.of(context).pushReplacementNamed(
                                      AddVishisthaAtithi.routeName,
                                      arguments: {'geoUnitId': _selectedGeoUnitId},
                                    ).then(
                                      (value) async {
                                        await _getForm();
                                        setState(() {});
                                      },
                                    );
                                  },
                                  child: Text(
                                    Statics.getLabel('fillNewRecord'),
                                    style: const TextStyle(color: Colors.purpleAccent),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 6),
                            Flexible(
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    /// Content
                                    const SizedBox(height: 12),
                                    Text(
                                      Statics.getLabel('SajjanShakti'),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                        color: Colors.blueGrey,
                                      ),
                                    ),
                                    const Divider(),
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.black12),
                                        borderRadius: BorderRadius.circular(12),
                                        color: Colors.white,
                                      ),
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
                                          ...sarsajjanshaktiList.map((item) {
                                            return TableRow(
                                              children: [
                                                Center(
                                                    child: Checkbox(
                                                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                  value: selectedSajjanshaktiItems.any((x) => x.pkid == item.pkid),
                                                  onChanged: (val) {
                                                    set(() {
                                                      if (val == true) {
                                                        selectedSajjanshaktiItems.add(item);
                                                      } else {
                                                        selectedSajjanshaktiItems.removeWhere((x) => x.pkid == item.pkid);
                                                      }
                                                    });
                                                    selectedSajjanshaktiItemsIds = selectedSajjanshaktiItems.map((e) => e.pkid.toString()).join(",");
                                                    // String anyaIds = selectedAnyaprabhavi.map((e) => e.pkId.toString()).join(",");
                                                    log(selectedSajjanshaktiItemsIds.toString());
                                                    log("-----------------------------");
                                                    // log(anyaIds);

                                                    // onSubmit(sajIds, anyaIds, selectedSajjanshakti, selectedAnyaprabhavi);
                                                    set(() {});
                                                  },
                                                )),
                                                Padding(
                                                  padding: const EdgeInsets.all(8),
                                                  child: Text(item.name ?? "Unknown"),
                                                ),
                                              ],
                                            );
                                          }),
                                        ],
                                      ),
                                    ),

                                    const SizedBox(height: 12),

                                    /// Anya Prabhavi Lok
                                    Text(
                                      Statics.getLabel('anyaPrabhaviLok'),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                        color: Colors.blueGrey,
                                      ),
                                    ),
                                    const Divider(),
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.black12),
                                        borderRadius: BorderRadius.circular(12),
                                        color: Colors.white,
                                      ),
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
                                          ...sanyaprabhaviList.map((item) {
                                            return TableRow(
                                              children: [
                                                Center(
                                                    child: Checkbox(
                                                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                  value: selectedAnyaprabhaviItems.any((x) => x.pkId == item.pkId),
                                                  onChanged: (val) {
                                                    set(() {
                                                      if (val == true) {
                                                        selectedAnyaprabhaviItems.add(item);
                                                      } else {
                                                        selectedAnyaprabhaviItems.removeWhere((x) => x.pkId == item.pkId);
                                                      }
                                                    });
                                                    // String sajIds = selectedSajjanshakti.map((e) => e.pkid.toString()).join(",");
                                                    selectedAnyaprabhaviItemsIds = selectedAnyaprabhaviItems.map((e) => e.pkId.toString()).join(",");

                                                    // onSubmit(sajIds, anyaIds, selectedSajjanshakti, selectedAnyaprabhavi);
                                                    // log(sajIds);
                                                    log(selectedAnyaprabhaviItemsIds.toString());
                                                    set(() {});
                                                  },
                                                )),
                                                Padding(
                                                  padding: const EdgeInsets.all(8),
                                                  child: Text(item.name ?? "Unknown"),
                                                ),
                                              ],
                                            );
                                          }),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.purpleAccent,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    onPressed: () async {
                                      set(() {});
                                      Navigator.pop(ctx);
                                      setState(() {});
                                    },
                                    child: Text(
                                      Statics.getLabel('Submit'),
                                      style: const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 24),
                          ],
                        ),
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

// ================================ Select Vasti POPUP ==================================================================

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

  Widget yesNoRadioButton({
    required String question,
    required Function(int) onChanged,
    required int selectedOption,
    int? questionNumber,
    String? imp,
    bool isDisable = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: "${questionNumber != null ? "$questionNumber. " : ""}$question",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
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
        Row(
          children: [
            Radio<int>(
              value: 1,
              groupValue: selectedOption,
              onChanged: isDisable
                  ? null
                  : (value) {
                      if (!_searched) {
                        // ✅ Search disabled => show toast
                        Fluttertoast.showToast(msg: "${Statics.getLabel('NagarSelectionImportant')}");
                        return;
                      }
                      if (value != null) onChanged(value);
                    },
              activeColor: Colors.purpleAccent,
            ),
            Text(
              "${Statics.getLabel('ConfirmationYes')}",
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(width: 20),
            Radio<int>(
              value: 0,
              groupValue: selectedOption,
              onChanged: isDisable
                  ? null
                  : (value) {
                      if (!_searched) {
                        Fluttertoast.showToast(msg: "${Statics.getLabel('NagarSelectionImportant')}");
                        return;
                      }
                      if (value != null) onChanged(value);
                    },
              activeColor: Colors.purpleAccent,
            ),
            Text(
              "${Statics.getLabel('ConfirmationNo')}",
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ],
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
}
