import 'dart:convert';
import 'dart:developer';
import 'dart:io';

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
import '../../../models/response_model/dropdown_level_responsemodel.dart';
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
  final String? id;

  const HinduSanmelanForm({required this.id, super.key});

  @override
  State<HinduSanmelanForm> createState() => _HinduSanmelanFormState();
}

class _HinduSanmelanFormState extends State<HinduSanmelanForm> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  // ─── Form ─────────────────────────────────────────────────────────────────
  final _formKey = GlobalKey<FormState>();
  final ScrollController _scrollController = ScrollController();

  // ─── URL controllers ──────────────────────────────────────────────────────
  final TextEditingController txtUrlsController = TextEditingController();
  final TextEditingController txtUrlDescController = TextEditingController();

  // ─── State flags ──────────────────────────────────────────────────────────
  bool _searched = false;
  bool _isExpanded = true;
  bool isVastiSearch = false;
  bool _markAtt = false;

  // ─── Vakta ────────────────────────────────────────────────────────────────
  List<AbhiyaanPeopleModel> vaktaList = [];
  List<AbhiyaanPeopleModel> _selectedVaktaList = [];
  int? selectedVaktaIndex;

  // ─── Geo-unit dropdowns ───────────────────────────────────────────────────
  List<GeoUnitMasterBAL>? _linkedMahaanagar, _linkedVibhaag, _linkedbhaag;
  List<GeoUnitMasterBAL>? _linkedshahar, _linkednagar, _linkedupnagar, _linkedmandal;
  List<GeoUnitMasterBAL>? _linkedgraam, _linkedvasti;

  String? _linkedMahaanagarValue = '';
  String? _linkedVibhaagValue = '';
  String? _linkedbhaagValue = '';
  String? _linkedshaharValue = '';
  String? _linkednagarValue = '';
  String? _linkedNagarValuePopup = '';
  String? _linkedupnagarValue = '';
  String? _linkedmandalValue = '';
  String? _linkedgraamValue = '';
  String? _linkedvastiValue = '';

  String? _linkedbhaagName = '';
  String? _linkedshaharName = '';
  String? _linkednagarName = '';
  String? _linkedupnagarName = '';
  String? _linkedmandalName = '';
  String? _linkedgraamName = '';
  String? _linkedvastiName = '';

  String? _selctedLevel = 'praant';
  String? _selctedLevelName = '';
  String _selctedLevelNames = '';
  List<String?> _selctedLevelNameList = [];
  String? _selectedGeoUnitId;

  // ─── Selection state ──────────────────────────────────────────────────────
  Vastisarsajjanshakti? selectedPerson;
  Vastisanyaprabhavi? selectedPrabhavi;
  List<Vastisarsajjanshakti> selectedSajjanshaktiItems = [];
  List<Vastisanyaprabhavi> selectedAnyaprabhaviItems = [];
  String? selectedSajjanshaktiItemsIds;
  String? selectedAnyaprabhaviItemsIds;
  String? selectedBhougolikPratinidhitwaVastiIds;
  String? selectedType;

  int? selectedVastiCount = 0;
  int totalVastiCount = 0;

  // ─── Bhaugolik ────────────────────────────────────────────────────────────
  List<UpnagarmandallistVijayaDashami> checkboxGraamVastiSelectedItems = [];

  // ─── Form data ────────────────────────────────────────────────────────────
  HinduSanmelanModel? data;

  // ─── Text controllers ─────────────────────────────────────────────────────
  final TextEditingController presentMaleController = TextEditingController();
  final TextEditingController presentMatrushaktiController = TextEditingController();
  final TextEditingController txtSanmelanFormatController = TextEditingController();
  final TextEditingController txtVaktaNameController = TextEditingController();
  final TextEditingController txtVaktaTaskController = TextEditingController();
  final TextEditingController txtUtsavPhotoDescController = TextEditingController();
  final TextEditingController txtUtsavAddPhotoDescController = TextEditingController();

  int total = 0;

  // ─── File / URL lists ─────────────────────────────────────────────────────
  String? selectedFilePath;
  List<TypeValueData?> _selectedFileNames1 = [];
  List<TypeValueData?> _selectedFileNames2 = [];
  List<TypeValueData?> _urlsList = [];

  static const int _maxImages = 3;
  static const int _maxAddImages = 10;

  final ValueNotifier<bool> loadingNotifier1 = ValueNotifier(false);
  final ValueNotifier<bool> loadingNotifier2 = ValueNotifier(false);
  final ValueNotifier<bool> loadingNotifier3 = ValueNotifier(false);

  // ═══════════════════════════════════════════════════════════════════════════
  // LIFECYCLE
  // ═══════════════════════════════════════════════════════════════════════════

  @override
  void initState() {
    super.initState();
    populateDropdown();
    presentMatrushaktiController.addListener(_calculateTotal);
    presentMaleController.addListener(_calculateTotal);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => initData());
  }

  Future<void> initData() async {
    DropDownModel dm = await MyAppGlobals.getLevelLDB();

    setState(() {
      userLevelId = dm.levelID;
      userGeoUnitId = dm.geoUnitID;
    });
    await populateAllDropdowns(userLevelId!, dm);
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
      _selectedGeoUnitId = _linkedMahaanagarValue = _linkedbhaagValue = _linkedshaharValue = _linkednagarValue = _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = null;
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
    _selectedGeoUnitId = _linkedbhaagValue = (level == 7 ? (dm.geoUnitID ?? "").toString() : selection.bhaag) ?? '';
    _selctedLevel = 'Bhaag';

    // Step 4: Nagar
    await populatelinkedNagarDropdown(_linkedbhaagValue, null);
    _selectedGeoUnitId = _linkednagarValue = (level == 6 ? (dm.geoUnitID ?? "").toString() : selection.nagar) ?? '';
    _selctedLevel = 'Nagar';

    // Step 5: Upnagar (conditional)
    if (selection.upnagar != null && selection.upnagar!.isNotEmpty) {
      await populatelinkedUpnagarDropdown(_linkednagarValue);
      _selectedGeoUnitId = _linkedupnagarValue = (level == 13 ? (dm.geoUnitID ?? "").toString() : selection.upnagar) ?? '';
    }

    // Step 6: Mandal
    await populatelinkedMandalDropdown(
      selection.upnagar != null,
      selection.upnagar != null ? _linkedupnagarValue : _linkednagarValue,
    );
    _selectedGeoUnitId = _linkedmandalValue = (level == 4 ? (dm.geoUnitID ?? "").toString() : selection.mandal) ?? '';

    // Step 7: Graam
    await populatelinkedGraamDropdown(_linkedmandalValue);
    _selectedGeoUnitId = _linkedgraamValue = (level == 3 ? (dm.geoUnitID ?? "").toString() : selection.graam) ?? '';

    // Step 8: Vasti
    await populatelinkedVastiDropdown(_linkednagarValue);
    _selectedGeoUnitId = _linkedvastiValue = (level == 2 ? (dm.geoUnitID ?? "").toString() : selection.vasti) ?? '';

    // if (_linkedVibhaag != null && _linkedVibhaag!.isNotEmpty) _linkedVibhaagName = _linkedVibhaag!.firstWhere((bg) => bg.geoUnitID.toString() == _linkedbhaagValue).name;
    // if (_linkedbhaag != null && _linkedbhaag!.isNotEmpty) _linkedbhaagName = _linkedbhaag!.firstWhere((bg) => bg.geoUnitID.toString() == _linkedbhaagValue).name;
    // if (_linkednagar != null && _linkednagar!.isNotEmpty) _linkednagarName = _linkednagar!.firstWhere((bg) => bg.geoUnitID.toString() == _linkedbhaagValue).name;

    setState(() {});
  }

  @override
  void didUpdateWidget(covariant HinduSanmelanForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.id != null && widget.id != oldWidget.id) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _getForm(id: widget.id));
    }
  }

  @override
  void dispose() {
    presentMatrushaktiController.dispose();
    presentMaleController.dispose();
    txtUrlsController.dispose();
    txtUrlDescController.dispose();
    txtSanmelanFormatController.dispose();
    txtVaktaNameController.dispose();
    txtVaktaTaskController.dispose();
    txtUtsavPhotoDescController.dispose();
    txtUtsavAddPhotoDescController.dispose();
    super.dispose();
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // DATA
  // ═══════════════════════════════════════════════════════════════════════════

  _getForm({String? id}) async {
    _resetFormFields();
    data = await Statics.getHinduSanmelanFormData(context, userID: Statics.userDetails["userID"], targetGeoUnitID: id ?? _selectedGeoUnitId);

    if (data != null) {
      final list1 = data?.vastisarsajjanshakti;
      final list2 = data?.vastisanyaprabhavi;
      if (list1 != null && list1.isNotEmpty) selectedPerson = list1.where((e) => e?.isMukhyadefault == 1).cast().firstOrNull;
      if (list2 != null && list2.isNotEmpty) selectedPrabhavi = list2.where((e) => e?.isMukhyadefault == 1).cast().firstOrNull;

      selectedVastiCount = data?.selectedgramcount;
      presentMaleController.text = (data?.malecount ?? 0).toString();
      presentMatrushaktiController.text = (data?.femalecount ?? 0).toString();
      txtSanmelanFormatController.text = data?.sanmelandesc ?? "";
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

      final geo = data?.geodata;
      if (geo != null) {
        if (geo.parentMahaanagarID != null && geo.parentMahaanagarID != 0) {
          _linkedMahaanagarValue = geo.parentMahaanagarID.toString();
          await populatelinkedVibhaagDropdown(geo.parentMahaanagarID.toString());
        }
        if (geo.parentVibhaagID != null && geo.parentVibhaagID != 0) {
          await populatelinkedBhaagDropdown(geo.parentVibhaagID.toString());
          _linkedVibhaagValue = geo.parentVibhaagID.toString();
        }
        if (geo.parentBhaagID != null && geo.parentBhaagID != 0) {
          await populatelinkedNagarDropdown(geo.parentBhaagID.toString(), null);
          _linkedbhaagValue = geo.parentBhaagID.toString();
        }
        if (geo.parentNagarID != null && geo.parentNagarID != 0) {
          await populatelinkedMandalDropdown(false, geo.parentNagarID.toString());
          await populatelinkedVastiDropdown(geo.parentNagarID.toString());
          _linkednagarValue = geo.parentNagarID.toString();
        }
        if (geo.levelID == 4)
          _linkedmandalValue = geo.geounitid.toString();
        else if (geo.levelID == 2) _linkedvastiValue = geo.geounitid.toString();
        if (geo.geounitid != null && geo.geounitid != 0) _selectedGeoUnitId = geo.geounitid.toString();
        _selctedLevelNameList = [];
        setState(() {});
        _selctedLevelNameList.addAll([
          _linkedbhaagName,
          _linkedshaharName,
          _linkednagarName,
          _linkedmandalName,
          _linkedgraamName,
          _linkedvastiName,
        ]);

        _selctedLevelNames = _selctedLevelNameList.where((e) => e != null && e.isNotEmpty).cast<String>().join(' -> ');
        _searched = true;
        _isExpanded = false;
        isVastiSearch = geo.levelID == 2;
      }

      if (id != null) await _scrollToBottom();
    }
    setState(() {});
  }

  void _resetFormFields() {
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
    _selectedFileNames1 = [];
    _selectedFileNames2 = [];
  }

  Future<void> _scrollToBottom() async {
    if (!_scrollController.hasClients) return;
    await _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOut,
    );
    await Future.delayed(const Duration(milliseconds: 100));
    await _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void _calculateTotal() {
    final matru = int.tryParse(presentMatrushaktiController.text) ?? 0;
    final male = int.tryParse(presentMaleController.text) ?? 0;
    setState(() => total = matru + male);
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // SUBMIT / IMAGE API
  // ═══════════════════════════════════════════════════════════════════════════

  Future<void> submitForm({bool showLoader = true}) async {
    final formData = {
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
      "imgDesc": "",
      "advDesc": "",
      "urls": _urlsList,
      "hindusanmelanvatta": vaktaList,
    };
    log("Form Data:\n${const JsonEncoder.withIndent('  ').convert(formData)}");
    await Statics.saveHinduSanmelanFormData(context, formData, showLoader);
  }

  Future<String?> submitImageDataFun({
    bool showLoader = false,
    bool isimg = false,
    required int pkid,
    required String type,
    String? filebase,
    String? newfilebase,
    required String description,
  }) async {
    final formData = {
      "pkid": pkid,
      "GeoUnitID": _selectedGeoUnitId,
      "filebase": filebase ?? selectedFilePath,
      "type": type,
      "Desc": description,
      "newfilebase": newfilebase ?? "",
      "isimg": isimg ? 1 : 0,
    };
    log("Image Data:\n${const JsonEncoder.withIndent('  ').convert(formData)}");
    return await Statics.saveHinduSanmelanImageData(context: context, inputJson: formData, showLoader: showLoader);
  }

  Future<bool> deleteImageDataFun({
    bool showLoader = true,
    required String imageName,
  }) async {
    final formData = {"GeoUnitID": _selectedGeoUnitId, "filepath": imageName};
    return await Statics.deleteHinduSanmelanImageData(context: context, inputJson: formData, showLoader: showLoader);
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // DROPDOWNS
  // ═══════════════════════════════════════════════════════════════════════════

  // Future<void> populateDropdown() async {
  //   setState(() {
  //     _linkedMahaanagarValue = _linkedbhaagValue = _linkedshaharValue = _linkednagarValue = _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = null;
  //   });
  //   await populatelinkedMahaanagarDropdown();
  //   await populatelinkedVibhaagDropdown('');
  // }

  Future<void> populateDropdown({bool fromClear = false}) async {
    if (fromClear || userLevelId == null || ddm == null) {
      setState(() {
        _linkedMahaanagarValue = _linkedbhaagValue = _linkedshaharValue = _linkednagarValue = _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = null;
        _linkedMahaanagar = _linkedVibhaag = _linkedbhaag = _linkednagar = _linkedmandal = null;
        _selctedLevelName = _selectedGeoUnitId = null;
        _selctedLevel = "praant";
      });
      await populatelinkedMahaanagarDropdown();
      await populatelinkedVibhaagDropdown('');
      return;
    }
    setState(() {
      _linkedMahaanagarValue = _linkedbhaagValue = _linkedshaharValue = _linkednagarValue = _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = null;
    });
    await populateAllDropdowns(userLevelId!, ddm!);
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedMahaanagarDropdown() async {
    final data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['MahaanagarLevelID'].toString(), '', '', '', isAbhiyaan: false);
    setState(() => _linkedMahaanagar = data);
    return data;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedVibhaagDropdown(String mahaanagarIDStr) async {
    _linkedbhaagValue = _linkednagarValue = _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = null;
    final data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['VibhaagLevelID'].toString(), mahaanagarIDStr, mahaanagarIDStr.isEmpty ? '' : 'Mahaanagar', '', isAbhiyaan: false);
    setState(() => _linkedVibhaag = data);
    return data;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedBhaagDropdown(String vibhaagIDStr) async {
    _linkedbhaagValue = _linkednagarValue = _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = null;
    _linkedbhaagName = _linkednagarName = _linkedmandalName = _linkedgraamName = _linkedvastiName = null;
    _linkedbhaag = _linkednagar = _linkedmandal = _linkedgraam = _linkedvasti = [];
    final data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['BhaagLevelID'].toString(), vibhaagIDStr, 'Vibhaag', '', isAbhiyaan: false);
    setState(() => _linkedbhaag = data);
    return data;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedShaharDropdown(String bhaagIDStr) async {
    _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = null;
    _linkedmandalName = _linkedgraamName = _linkedvastiName = null;
    final data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['ShaharLevelID'].toString(), bhaagIDStr, 'Bhaag', '', isAbhiyaan: false);
    setState(() => _linkedshahar = data.isNotEmpty ? data : null);
    return data;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedNagarDropdown(String? bhaagIDStr, String? shaharIDStr) async {
    _linkednagarValue = _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = null;
    _linkednagarName = _linkedmandalName = _linkedgraamName = _linkedvastiName = null;
    _linkednagar = _linkedmandal = _linkedgraam = _linkedvasti = null;
    final parentID = shaharIDStr ?? bhaagIDStr!;
    final parentType = shaharIDStr != null ? 'Shahar' : 'Bhaag';
    final data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['NagarLevelID'].toString(), parentID, parentType, '', isAbhiyaan: false);
    setState(() => _linkednagar = data.isNotEmpty ? data : null);
    return data;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedUpnagarDropdown(String? nagarIDStr) async {
    _linkedupnagarValue = _linkedmandalValue = _linkedgraamValue = null;
    _linkedupnagarName = _linkedmandalName = _linkedgraamName = null;
    _linkedupnagar = _linkedmandal = _linkedgraam = null;
    var mnDD;

    mnDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['UpaNagarLevelID'].toString(), nagarIDStr!, 'Nagar', '');

    setState(() {
      _linkedupnagar = (mnDD.length > 0 ? mnDD : null);
      //_linkedupnagarValue = (userparentUpanagarid ?? userGeoUnitId).toString();
    });
    return mnDD;
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
    final data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['GraamLevelID'].toString(), mandalIDStr!, 'Mandal', '', isAbhiyaan: false);
    setState(() => _linkedgraam = data.isNotEmpty ? data : null);
    return data;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedVastiDropdown(String? nagarIDStr) async {
    _linkedvastiValue = null;
    _linkedvastiName = null;
    final data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['VastiLevelID'].toString(), nagarIDStr!, 'Nagar', '', isAbhiyaan: false);
    setState(() => _linkedvasti = data.isNotEmpty ? data : null);
    return data;
  }

  String? selctedLevel = 'praant';
  String? selctedLevelName = '';
  String? selctedLevelIdForMandalDropdown = '';
  String? selctedLevelIdForVastiDropdown = '';

  Future<void> clearForm() async {
    setState(() {
      _isExpanded = false;
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
      selectedType = null;
      selectedSajjanshaktiItems = [];
      selectedAnyaprabhaviItems = [];
      selectedVastiCount = 0;
      totalVastiCount = 0;
    });
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // GUARD: require geo-unit selection before editing
  // ═══════════════════════════════════════════════════════════════════════════

  bool _guardSearch() {
    if (!_searched) {
      Fluttertoast.showToast(msg: Statics.getLabel('NagarSelectionImportant'));
      return false;
    }
    return true;
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // BUILD
  // ═══════════════════════════════════════════════════════════════════════════

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      drawer: AppDrawer(),
      body: Form(
        key: _formKey,
        child: ListView(
          controller: _scrollController,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          children: [
            const SizedBox(height: 27),
            vastiMandalDropdown(),
            const SizedBox(height: 20),
            _geoUnitSelectionBanner(),
            const SizedBox(height: 10),
            mainContainer(Statics.getLabel('mukhyaAtithi'), _mukhyaAtithiSection()),
            mainContainer(Statics.getLabel('specialAtithi'), _visheshAtithiSection()),
            mainContainer(Statics.getLabel('sanmelanVakta'), vaktaTable()),
            if (_linkedmandalValue != null && _linkedmandalValue!.isNotEmpty) mainContainer(Statics.getLabel('bhougolikPratinidhitwa'), _bhougolikSection()),
            mainContainer(Statics.getLabel('sanmelanJoinedCount'), _attendanceSection()),
            mainContainer(Statics.getLabel('moreInfo'), _moreInfoSection()),
            const SizedBox(height: 24),
            _submitButton(),
            const SizedBox(height: 70),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION WIDGETS
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _geoUnitSelectionBanner() {
    if (isVastiSearch == false) {
      return Column(children: [
        Text(
          Statics.getLabel('NagarSelectionImportant'),
          style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 2),
        Container(height: 2, width: double.infinity, color: Colors.red),
      ]);
    }
    if (selctedLevel != "" && selctedLevelName != "") {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.purpleAccent, width: 1),
          borderRadius: const BorderRadius.all(Radius.circular(15)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Text(
                "${Statics.getLabel(selctedLevel ?? 'Nagar')}  ->  ",
                style: const TextStyle(color: Colors.purpleAccent, fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            Flexible(
              child: Text(
                " $selctedLevelName",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 17),
              ),
            ),
          ],
        ),
      );
    }
    return const SizedBox.shrink();
  }

  // ── Mukhya Atithi ─────────────────────────────────────────────────────────
  Widget _mukhyaAtithiSection() {
    return Column(children: [
      Align(
        alignment: Alignment.centerRight,
        child: _outlineButton(
          label: Statics.getLabel('addMukhyaAtithi'),
          onTap: () {
            if (!_guardSearch()) return;
            final s1 = (data?.vastisarsajjanshakti ?? []).where((e) => !selectedSajjanshaktiItems.contains(e)).toList();
            final s2 = (data?.vastisanyaprabhavi ?? []).where((e) => !selectedAnyaprabhaviItems.contains(e)).toList();
            showMukhyaAtithiSelectionPopup(context, sarsajjanshaktiList: s1, sanyaprabhaviList: s2);
          },
        ),
      ),
      const SizedBox(height: 10),
      _personTable(
        rows: [
          _personTableRow(
            srNo: 1,
            name: selectedPerson?.name ?? selectedPrabhavi?.name ?? "",
            contact: selectedPerson?.samparkasutranava ?? selectedPrabhavi?.samparkAsutraNav ?? "",
            onView: () {
              if (selectedPerson != null)
                showPersonDetailsPopup(context, selectedPerson!, 1);
              else if (selectedPrabhavi != null) showPersonDetailsPopup(context, selectedPrabhavi!, 1);
            },
          ),
        ],
      ),
    ]);
  }

  // ── Vishesh Atithi ────────────────────────────────────────────────────────
  Widget _visheshAtithiSection() {
    return Column(children: [
      Align(
        alignment: Alignment.centerRight,
        child: _outlineButton(
          label: Statics.getLabel('addVIshishthaAtithi'),
          onTap: () async {
            if (!_guardSearch()) return;
            final s1 = (data?.vastisarsajjanshakti ?? []).where((e) => selectedPerson != e).toList();
            final s2 = (data?.vastisanyaprabhavi ?? []).where((e) => selectedPrabhavi != e).toList();
            await showVisheshAtithiSelectionPopup(context, sarsajjanshaktiList: s1, sanyaprabhaviList: s2);
          },
        ),
      ),
      const SizedBox(height: 20),
      if (selectedSajjanshaktiItems.isNotEmpty) ...[
        Text(Statics.getLabel('SajjanShakti'), style: const TextStyle(fontWeight: FontWeight.bold)),
        _personTable(
          rows: selectedSajjanshaktiItems.asMap().entries.map((e) {
            return _personTableRow(
              srNo: e.key + 1,
              name: e.value.name ?? "",
              contact: e.value.samparkasutranava ?? "",
              onView: () => showPersonDetailsPopup(context, e.value, e.key + 1),
            );
          }).toList(),
        ),
      ],
      if (selectedAnyaprabhaviItems.isNotEmpty) ...[
        const SizedBox(height: 20),
        Text(Statics.getLabel('anyaPrabhaviLok'), style: const TextStyle(fontWeight: FontWeight.bold)),
        _personTable(
          rows: selectedAnyaprabhaviItems.asMap().entries.map((e) {
            return _personTableRow(
              srNo: e.key + 1,
              name: e.value.name ?? "",
              contact: e.value.samparkAsutraNav ?? "",
              onView: () => showPersonDetailsPopup(context, e.value, e.key + 1),
            );
          }).toList(),
        ),
      ],
    ]);
  }

  // ── Bhaugolik ─────────────────────────────────────────────────────────────
  Widget _bhougolikSection() {
    return Column(children: [
      Align(
        alignment: Alignment.centerRight,
        child: _outlineButton(
          label: Statics.getLabel('addGraam'),
          onTap: () {
            if (!_guardSearch()) return;
            showGraamVastiMandalUpnagarPopup(
              context,
              vastiList: data?.gramlist ?? [],
              preselectedItems: checkboxGraamVastiSelectedItems,
              onSubmit: (items, selected, total) {
                setState(() {
                  checkboxGraamVastiSelectedItems = items;
                  totalVastiCount = total;
                  selectedVastiCount = selected;
                  selectedBhougolikPratinidhitwaVastiIds = items.map((e) => e.geoUnitID.toString()).join(",");
                });
              },
            );
          },
        ),
      ),
      const SizedBox(height: 10),
      SingleColumnRow(txtString: "${Statics.getLabel('Total')} ${Statics.getLabel('Graam')}", value: (data?.gramlist ?? []).length.toString()),
      SingleColumnRow(txtString: "${Statics.getLabel('Graam')} ${Statics.getLabel('pratinidhitva')}  ", value: selectedVastiCount.toString()),
      SingleColumnRow(
        rowColor: Colors.grey.shade300,
        txtString: "${Statics.getLabel('average')} ${Statics.getLabel('pratinidhitva')} ",
        value: "${(data?.gramlist ?? []).length > 0 ? ((selectedVastiCount! / (data?.gramlist ?? []).length) * 100).toStringAsFixed(0) : 0} %",
      ),
    ]);
  }

  // ── Attendance ────────────────────────────────────────────────────────────
  Widget _attendanceSection() {
    return Column(children: [
      Row(children: [
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
      ]),
      SingleColumnRow(
        rowColor: Colors.grey.shade300,
        txtString: "${Statics.getLabel('presentTotal')} ",
        value: total.toString(),
      ),
    ]);
  }

  // ── More Info (Section 12) ─────────────────────────────────────────────────
  /// This is the main improved section. Contains:
  ///   1. Sanmelan format text field
  ///   2. Utsav photos (filePickerField1 → _filePickerSection)
  ///   3. Advertisement photos (filePickerField2 → _filePickerSection)
  ///   4. URLs list
  Widget _moreInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Sanmelan format ──────────────────────────────────────────────────
        Text(Statics.getLabel("sanmelanFormat"), style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextFormField(
          controller: txtSanmelanFormatController,
          maxLines: 5,
          readOnly: !_searched,
          onTap: () => _guardSearch(),
          onChanged: (_) => setState(() {}),
          onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
          decoration: InputDecoration(
            hintText: Statics.getLabel("AddSanmelanFormat"),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),

        const Divider(height: 32),

        // ── Utsav photos ─────────────────────────────────────────────────────
        _filePickerSection(
          question: Statics.getLabel('AddSanmelanFiles'),
          subtitle: Statics.getLabel('AddSanmelanFilesSubtitle'),
          descHint: Statics.getLabel('AddSanmelanFilesDesc'),
          fileList: _selectedFileNames1,
          maxFiles: _maxImages,
          fileType: "img",
          baseUrl: '${Statics.baseUrl}/Files/hindusanmelanfiles/',
          loadingNotifier: loadingNotifier1,
          descController: txtUtsavPhotoDescController,
        ),

        const Divider(height: 32),

        // ── Advertisement photos ──────────────────────────────────────────────
        _filePickerSection(
          question: Statics.getLabel('AddAdvSanmelanFiles'),
          subtitle: Statics.getLabel('AddAdvSanmelanFilesSubtitle'),
          descHint: Statics.getLabel('AddAdvSanmelanFilesDesc'),
          fileList: _selectedFileNames2,
          maxFiles: _maxAddImages,
          fileType: "advimg",
          baseUrl: '${Statics.baseUrl}/Files/hindusanmelanfiles/',
          loadingNotifier: loadingNotifier2,
          descController: txtUtsavAddPhotoDescController,
        ),

        const Divider(height: 32),

        // ── URLs ──────────────────────────────────────────────────────────────
        _urlsSection(),
      ],
    );
  }

  // ─── Submit ────────────────────────────────────────────────────────────────
  Widget _submitButton() {
    return MaterialButton(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      color: Theme.of(context).primaryColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      onPressed: () {
        if (!_guardSearch()) return;
        if (txtUrlsController.text.trim().isNotEmpty && txtUrlDescController.text.trim().isEmpty) {
          Statics.showToast(Statics.getLabel('urlDescIsImp'), toastLength: Toast.LENGTH_LONG);
          return;
        }
        if (txtUrlsController.text.trim().isNotEmpty && txtUrlDescController.text.trim().isNotEmpty) {
          Statics.showToast(Statics.getLabel('clickOnAddBtn'), toastLength: Toast.LENGTH_LONG);
          return;
        }
        if ((presentMatrushaktiController.text.trim().isEmpty || presentMatrushaktiController.text == "0") && (presentMaleController.text.trim().isEmpty || presentMaleController.text == "0")) {
          Statics.showToast(Statics.getLabel('presentMaleFemaleValidation'), toastLength: Toast.LENGTH_LONG);
          return;
        }
        submitForm();
      },
      child: Text(
        Statics.getLabel('Submit'),
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // ─────────────────────  FILE PICKER SECTION (MERGED)  ─────────────────────
  // ═══════════════════════════════════════════════════════════════════════════

  /// Single reusable widget replacing the old `filePickerField1` / `filePickerField2`.
  /// Handles upload, view gallery, edit description/image, and delete.
  Widget _filePickerSection({
    required String question,
    required String subtitle,
    required String descHint,
    required List<TypeValueData?> fileList,
    required int maxFiles,
    required String fileType, // "img" or "advimg"
    required String baseUrl,
    required ValueNotifier<bool> loadingNotifier,
    required TextEditingController descController,
  }) {
    final canAdd = fileList.length < maxFiles;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Header row: title + gallery-view icon ─────────────────────────
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(question, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                  Text(subtitle, style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w400)),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.remove_red_eye, color: Colors.purpleAccent),
              onPressed: fileList.isEmpty ? null : () => _showGalleryDialog(fileList, baseUrl),
            ),
          ],
        ),

        const SizedBox(height: 8),

        // ── File rows ─────────────────────────────────────────────────────
        ...fileList.map((item) => _fileItemRow(
              item: item,
              baseUrl: baseUrl,
              fileType: fileType,
              fileList: fileList,
            )),

        // ── Add button ────────────────────────────────────────────────────
        if (canAdd)
          Align(
            alignment: Alignment.centerRight,
            child: ValueListenableBuilder<bool>(
              valueListenable: loadingNotifier,
              builder: (_, isLoading, __) => OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.purpleAccent, width: 1.5),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
                onPressed: isLoading
                    ? null
                    : () => _pickAndUploadImage(
                          fileList: fileList,
                          fileType: fileType,
                          descController: descController,
                          descHint: descHint,
                          loadingNotifier: loadingNotifier,
                        ),
                child: isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(
                        "+ ${Statics.getLabel("AddMore")}",
                        style: const TextStyle(fontSize: 14, color: Colors.purple),
                      ),
              ),
            ),
          ),

        const SizedBox(height: 14),
      ],
    );
  }

  // ─── Single file item row (filename | edit | delete) ──────────────────────
  Widget _fileItemRow({
    required TypeValueData? item,
    required String baseUrl,
    required String fileType,
    required List<TypeValueData?> fileList,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black54, width: 1),
        borderRadius: BorderRadius.circular(11),
      ),
      child: Row(
        children: [
          // filename
          Expanded(
            child: Text(
              item?.value ?? Statics.getLabel('selectFile'),
              style: const TextStyle(color: Colors.black87),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // edit
          IconButton(
            style: IconButton.styleFrom(tapTargetSize: MaterialTapTargetSize.shrinkWrap),
            icon: const Icon(Icons.edit, color: Colors.blue, size: 20),
            tooltip: Statics.getLabel('edit'),
            onPressed: () => _showEditFileDialog(item: item, baseUrl: baseUrl, fileType: fileType),
          ),
          // delete
          IconButton(
            style: IconButton.styleFrom(tapTargetSize: MaterialTapTargetSize.shrinkWrap),
            icon: const Icon(Icons.delete_forever, color: Colors.red),
            onPressed: () async {
              final shouldDelete = await _showDeleteConfirmDialog(message: Statics.getLabel('AreyouSureYouWantToDeleteImage'));
              if (shouldDelete == true) {
                final ok = await deleteImageDataFun(imageName: (item?.value).toString());
                if (ok) setState(() => fileList.remove(item));
              }
            },
          ),
        ],
      ),
    );
  }

  // ─── Edit file popup ───────────────────────────────────────────────────────
  /// Allows editing the description and optionally replacing the image.
  /// On save: calls `submitImageDataFun` with:
  ///   - `pkid`  = item.pkid
  ///   - `isimg` = true if image was replaced
  ///   - `newfilebase` (via selectedFilePath)
  ///   - `description` = new description text
  Future<void> _showEditFileDialog({
    required TypeValueData? item,
    required String baseUrl,
    required String fileType,
  }) async {
    if (!_guardSearch()) return;
    if (item == null) return;

    final descCtrl = TextEditingController(text: item.description ?? "");
    bool imageReplaced = false;
    String? previewBase64; // local base64 preview after pick
    final savingNotifier = ValueNotifier<bool>(false);

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, set) {
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Title ──────────────────────────────────────────────
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          Statics.getLabel('Edit'),
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.purpleAccent),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.redAccent),
                          onPressed: () => Navigator.pop(ctx),
                        ),
                      ],
                    ),
                    Divider(color: Colors.deepPurple.shade100),
                    const SizedBox(height: 8),

                    // ── Current filename ───────────────────────────────────
                    Text(
                      "${Statics.getLabel('submittedFile')}:   ${item.value ?? ''}",
                      style: TextStyle(fontSize: 13, color: Colors.grey.shade700, fontStyle: FontStyle.italic),
                    ),

                    // Preview of new image (if picked)
                    if (item.value != null && item.value!.isNotEmpty)
                      Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        height: 120,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: CachedNetworkImage(
                            imageUrl: '$baseUrl${item.value}',
                            errorWidget: (_, __, ___) => SizedBox(width: double.infinity, height: 120, child: Center(child: Text(Statics.getLabel("errorOccurred")))),
                            progressIndicatorBuilder: (_, __, ___) => const SizedBox(width: double.infinity, height: 120, child: Center(child: CircularProgressIndicator())),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    const SizedBox(height: 12),

                    // ── Description field ──────────────────────────────────
                    TextFormField(
                      controller: descCtrl,
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: Statics.getLabel('AddSanmelanFilesDesc'),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // ── Replace image section ──────────────────────────────
                    Text(
                      Statics.getLabel('replacedFile'),
                      style: TextStyle(fontSize: 13, color: Colors.grey.shade700, fontStyle: FontStyle.italic),
                    ),
                    const SizedBox(height: 8),

                    // Preview of new image (if picked)
                    if (previewBase64 != null)
                      Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        height: 120,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.memory(
                            base64Decode(previewBase64!.split(',').last),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _iconPickerBtn(
                          icon: Icons.camera_alt,
                          label: Statics.getLabel('camera'),
                          onTap: () async {
                            final base64 = await _pickAndCompressImage(ImageSource.camera);
                            if (base64 != null) {
                              set(() {
                                previewBase64 = base64;
                                selectedFilePath = base64;
                                imageReplaced = true;
                              });
                            }
                          },
                        ),
                        _iconPickerBtn(
                          icon: Icons.photo_library,
                          label: Statics.getLabel('gallery'),
                          onTap: () async {
                            final base64 = await _pickAndCompressImage(ImageSource.gallery);
                            if (base64 != null) {
                              set(() {
                                previewBase64 = base64;
                                selectedFilePath = base64;
                                imageReplaced = true;
                              });
                            }
                          },
                        ),
                        if (imageReplaced)
                          TextButton(
                            onPressed: () {
                              set(() {
                                previewBase64 = null;
                                selectedFilePath = null;
                                imageReplaced = false;
                              });
                            },
                            child: Row(
                              spacing: 4,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.cancel, color: Colors.orange.shade700),
                                Text(
                                  Statics.getLabel('clear'),
                                  style: TextStyle(color: Colors.orange.shade700),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // ── Save button ────────────────────────────────────────
                    ValueListenableBuilder<bool>(
                      valueListenable: savingNotifier,
                      builder: (_, saving, __) => ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purpleAccent,
                          minimumSize: const Size.fromHeight(44),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: saving
                            ? null
                            : () async {
                                savingNotifier.value = true;
                                final _res = await submitImageDataFun(
                                  pkid: item.pkid ?? 0,
                                  type: fileType,
                                  isimg: imageReplaced,
                                  filebase: item.value,
                                  newfilebase: imageReplaced ? selectedFilePath : "",
                                  description: descCtrl.text.trim(),
                                );
                                // Update local item
                                setState(() {
                                  item.description = descCtrl.text.trim();
                                  if (imageReplaced) {
                                    item.isimg = 1;
                                    item.newfilebase = selectedFilePath;
                                    item.value = _res;
                                    selectedFilePath = null;
                                  }
                                });
                                savingNotifier.value = false;
                                if (mounted) Navigator.pop(ctx);
                              },
                        child: saving
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                              )
                            : Text(
                                Statics.getLabel('Submit'),
                                style: const TextStyle(color: Colors.white),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ─── Gallery / view-all dialog ─────────────────────────────────────────────
  void _showGalleryDialog(List<TypeValueData?> fileList, String baseUrl) {
    showDialog(
      context: context,
      builder: (ctx) => Material(
        child: StatefulBuilder(builder: (context, set) {
          String _currentImg = "";
          return Container(
            color: Colors.transparent,
            padding: const EdgeInsets.all(20),
            child: ListView(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ),
                const SizedBox(height: 10),
                ...fileList.asMap().entries.map((entry) {
                  final index = entry.key;
                  final fi = entry.value;
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                "${index + 1}. ${fi?.value}",
                                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                              ),
                            ),
                            IconButton(
                              onPressed: () async {
                                set(() => _currentImg = fi.toString());
                                loadingNotifier3.value = true;
                                await MyAppGlobals.downloadFile('$baseUrl${fi?.value}', (fi?.value).toString());
                                loadingNotifier3.value = false;
                                set(() => _currentImg = "");
                              },
                              icon: ValueListenableBuilder<bool>(
                                valueListenable: loadingNotifier3,
                                builder: (_, loading, __) => loading && fi.toString() == _currentImg
                                    ? const SizedBox(
                                        width: 17,
                                        height: 17,
                                        child: CircularProgressIndicator(strokeWidth: 2),
                                      )
                                    : const Icon(Icons.download, color: Colors.purple),
                              ),
                            ),
                          ],
                        ),
                        if ((fi?.description ?? "").isNotEmpty) Text(fi!.description!, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14.5)),
                        const SizedBox(height: 6),
                        CachedNetworkImage(
                          imageUrl: '$baseUrl${fi?.value}',
                          errorWidget: (_, __, ___) => SizedBox(width: double.infinity, height: 120, child: Center(child: Text(Statics.getLabel("errorOccurred")))),
                          progressIndicatorBuilder: (_, __, ___) => const SizedBox(width: double.infinity, height: 120, child: Center(child: CircularProgressIndicator())),
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
      ),
    );
  }

  // ─── Pick + upload flow (add new) ──────────────────────────────────────────
  Future<void> _pickAndUploadImage({
    required List<TypeValueData?> fileList,
    required String fileType,
    required TextEditingController descController,
    required String descHint,
    required ValueNotifier<bool> loadingNotifier,
  }) async {
    if (!_guardSearch()) return;
    loadingNotifier.value = true;

    // Ask for description + source
    final isCamera = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => PopScope(
        canPop: false,
        child: AlertDialog(
          title: Text(Statics.getLabel('AddSanmelanFiles')),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: descController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: descHint,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _iconPickerBtn(
                      icon: Icons.camera_alt,
                      label: Statics.getLabel('camera'),
                      onTap: () {
                        if (descController.text.trim().isEmpty) {
                          Statics.showToast(descHint);
                          return;
                        }
                        Navigator.pop(ctx, true);
                      }),
                  _iconPickerBtn(
                      icon: Icons.photo_library,
                      label: Statics.getLabel('gallery'),
                      onTap: () {
                        if (descController.text.trim().isEmpty) {
                          Statics.showToast(descHint);
                          return;
                        }
                        Navigator.pop(ctx, false);
                      }),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text(Statics.getLabel('clear')),
              onPressed: () {
                loadingNotifier.value = false;
                Navigator.pop(ctx);
              },
            ),
          ],
        ),
      ),
    );

    if (isCamera == null) {
      loadingNotifier.value = false;
      return;
    }

    try {
      final base64File = await _pickAndCompressImage(isCamera ? ImageSource.camera : ImageSource.gallery);
      if (base64File != null) {
        selectedFilePath = base64File;
        final resultName = await submitImageDataFun(
          pkid: 0,
          type: fileType,
          showLoader: true,
          isimg: true,
          description: descController.text.trim(),
        );
        setState(() {
          fileList.add(TypeValueData(
            type: fileType,
            value: resultName ?? "",
            description: descController.text.trim(),
          ));
          descController.clear();
          selectedFilePath = null;
        });
      }
    } catch (e) {
      log("Error during file processing: $e");
    } finally {
      loadingNotifier.value = false;
    }
    setState(() {});
  }

  // ─── Image pick + compress helper ─────────────────────────────────────────
  Future<String?> _pickAndCompressImage(ImageSource source) async {
    final result = await ImagePicker().pickImage(source: source);
    if (result == null) return null;
    try {
      final file = File(result.path);
      img.Image? original = img.decodeImage(file.readAsBytesSync());
      if (original == null) return null;
      img.Image compressed = img.copyResize(original, width: original.width);
      while (compressed.length > 2 * 1024 * 1024) {
        compressed = img.copyResize(compressed, width: (compressed.width * 0.9).toInt());
      }
      final bytes = img.encodeJpg(compressed, quality: 85);
      return "data:image/jpg;base64,${base64Encode(bytes)}";
    } catch (e) {
      log("Image compress error: $e");
      return null;
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // URL SECTION
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _urlsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(Statics.getLabel('AddLinks'), style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextFormField(
          controller: txtUrlsController,
          readOnly: !_searched,
          onTap: () => _guardSearch(),
          onChanged: (_) => setState(() {}),
          onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
          decoration: InputDecoration(
            hintText: Statics.getLabel("url"),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: txtUrlDescController,
          maxLines: 3,
          maxLength: 160,
          readOnly: !_searched,
          onTap: () => _guardSearch(),
          onChanged: (_) => setState(() {}),
          onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
          decoration: InputDecoration(
            hintText: Statics.getLabel("urlDesc"),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerRight,
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.purpleAccent, width: 1.5),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            ),
            onPressed: () async {
              if (txtUrlsController.text.trim().isNotEmpty && txtUrlDescController.text.trim().isNotEmpty) {
                final valid = await isValidUrl(txtUrlsController.text.trim());
                if (!valid) {
                  Fluttertoast.showToast(msg: Statics.getLabel('urlValidation'));
                  return;
                }
                setState(() {
                  _urlsList.add(TypeValueData(
                    type: "url",
                    value: txtUrlsController.text.trim(),
                    description: txtUrlDescController.text.trim(),
                  ));
                  txtUrlsController.clear();
                  txtUrlDescController.clear();
                });
              } else {
                if (!_guardSearch()) return;
                if (txtUrlDescController.text.trim().isEmpty) {
                  Fluttertoast.showToast(msg: Statics.getLabel('urlDescIsImp'));
                } else {
                  Fluttertoast.showToast(msg: Statics.getLabel('urlValidation'));
                }
              }
            },
            child: Text("+ ${Statics.getLabel("Add")}"),
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          runSpacing: 8,
          spacing: 8,
          children: _urlsList.asMap().entries.map((entry) {
            final srNo = entry.key + 1;
            final url = entry.value;
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey.shade200,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("$srNo. ", style: const TextStyle(fontWeight: FontWeight.w700)),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () async {
                            final uri = Uri.parse((url?.value).toString());
                            if (await isValidUrl((url?.value).toString())) {
                              await launchUrl(uri, mode: LaunchMode.externalApplication);
                            }
                          },
                          child: Text(
                            (url?.value).toString(),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: Colors.blue, decoration: TextDecoration.underline, decorationColor: Colors.blue),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text((url?.description).toString(), style: const TextStyle(fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  InkWell(
                    onTap: () async {
                      final del = await _showDeleteConfirmDialog(message: Statics.getLabel('AreyouSureYouWantToDeleteUrl'));
                      if (del == true) {
                        setState(() => _urlsList.removeWhere((e) => e == url));
                      }
                    },
                    child: const Icon(Icons.delete_forever, color: Colors.red, size: 18),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // SMALL HELPERS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Generic confirm-delete dialog — returns `true` if user confirms.
  Future<bool?> _showDeleteConfirmDialog({required String message}) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text(
          Statics.getLabel('AskConfirmation'),
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red.shade700, fontSize: 18),
        ),
        content: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text(message, style: TextStyle(fontSize: 16, color: Colors.red.shade800)),
        ),
        actions: [
          TextButton(
            child: Text(Statics.getLabel('ConfirmationNo')),
            onPressed: () => Navigator.pop(ctx, false),
          ),
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.red.shade700,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(Statics.getLabel('ConfirmationYes'), style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  /// Small icon + label button used in image-source pickers.
  Widget _iconPickerBtn({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton.filled(
          onPressed: onTap,
          icon: Icon(icon),
        ),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  /// Purple outline button used throughout (add mukhya atithi, add graam …).
  Widget _outlineButton({required String label, required VoidCallback onTap}) {
    return InkWell(
      borderRadius: BorderRadius.circular(15),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.purpleAccent.shade100),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Text(label, style: const TextStyle(color: Colors.purpleAccent, fontWeight: FontWeight.bold)),
      ),
    );
  }

  // ─── Person table helpers ──────────────────────────────────────────────────
  Widget _personTable({required List<TableRow> rows}) {
    return Table(
      border: TableBorder.all(),
      columnWidths: const {
        0: FixedColumnWidth(40),
        1: FlexColumnWidth(),
        2: FlexColumnWidth(),
        3: FixedColumnWidth(50),
      },
      children: [
        TableRow(
          decoration: const BoxDecoration(color: Color(0xFFE0E0E0)),
          children: [
            Center(child: Padding(padding: const EdgeInsets.all(4), child: Text(Statics.getLabel('serialNo'), textAlign: TextAlign.center))),
            Center(child: Padding(padding: const EdgeInsets.all(4), child: Text(Statics.getLabel('Name'), textAlign: TextAlign.center))),
            Center(child: Padding(padding: const EdgeInsets.all(4), child: Text(Statics.getLabel('samparkSootraNaav'), textAlign: TextAlign.center))),
            Center(child: Padding(padding: const EdgeInsets.all(4), child: Text(Statics.getLabel('ViewMenu'), textAlign: TextAlign.center))),
          ],
        ),
        ...rows,
      ],
    );
  }

  TableRow _personTableRow({
    required int srNo,
    required String name,
    required String contact,
    required VoidCallback onView,
  }) {
    return TableRow(children: [
      Padding(padding: const EdgeInsets.all(4), child: Text('$srNo')),
      Padding(padding: const EdgeInsets.all(4), child: Text(name)),
      Padding(padding: const EdgeInsets.all(4), child: Text(contact)),
      IconButton(
        icon: const Icon(Icons.remove_red_eye, size: 22, color: Colors.purpleAccent),
        onPressed: onView,
      ),
    ]);
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // VAKTA TABLE (unchanged logic, kept clean)
  // ═══════════════════════════════════════════════════════════════════════════

  Widget vaktaTable() {
    return Column(
      spacing: 12,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: _outlineButton(label: Statics.getLabel('addVakta'), onTap: showAddVaktaDialogBox),
        ),
        Container(
          width: double.infinity,
          constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * 0.4),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black54),
            borderRadius: const BorderRadius.all(Radius.circular(15)),
          ),
          child: DataTable(
            columnSpacing: 12,
            showCheckboxColumn: _markAtt,
            headingRowColor: MaterialStatePropertyAll(Colors.purple.shade50),
            headingTextStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
            columns: [
              DataColumn(label: Text(Statics.getLabel('Name'))),
              DataColumn(label: Text(Statics.getLabel('sanmelanVaktaTask'))),
            ],
            rows: vaktaList.where((e) => e.isactive == 1).toList().asMap().entries.map((entry) {
              final index = entry.key;
              final d = entry.value;
              final isSelected = selectedVaktaIndex == index;
              return DataRow(
                selected: isSelected,
                color: MaterialStateProperty.resolveWith<Color?>((states) => isSelected ? Colors.yellow.shade100 : null),
                onSelectChanged: (val) => setState(() {
                  selectedVaktaIndex = (val == true) ? index : null;
                }),
                cells: [
                  DataCell(Container(
                    constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width * 0.4),
                    child: Text(d.name ?? ''),
                  )),
                  DataCell(Text(d.desgination ?? '')),
                ],
              );
            }).toList(),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // View
            InkWell(
              onTap: () {
                if (selectedVaktaIndex == null) return;
                final d = vaktaList[selectedVaktaIndex!];
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    backgroundColor: Colors.white,
                    title: Center(
                      child: Text(Statics.getLabel('sanmelanVakta'), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.purpleAccent)),
                    ),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Divider(color: Colors.deepPurple.shade100),
                        _buildInfoRow(Statics.getLabel('Name'), d.name),
                        _buildInfoRow(Statics.getLabel('sanmelanVaktaTask'), d.desgination),
                      ],
                    ),
                    actions: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.purpleAccent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                        onPressed: () => Navigator.pop(context),
                        child: Text(Statics.getLabel('bandKara'), style: const TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                );
              },
              child: const Icon(Icons.remove_red_eye, color: Colors.green, size: 20),
            ),
            const SizedBox(width: 20),
            // Edit
            InkWell(
              onTap: () {
                if (selectedVaktaIndex != null) {
                  txtVaktaNameController.text = vaktaList[selectedVaktaIndex!].name ?? "--";
                  txtVaktaTaskController.text = vaktaList[selectedVaktaIndex!].desgination ?? "--";
                  showAddVaktaDialogBox(fromEditing: true);
                }
              },
              child: const Icon(Icons.edit, color: Colors.blue, size: 20),
            ),
            const SizedBox(width: 20),
            // Delete
            InkWell(
              onTap: () async {
                if (selectedVaktaIndex == null) return;
                final del = await _showDeleteConfirmDialog(message: Statics.getLabel('deleteconfirmText'));
                if (del == true) {
                  setState(() {
                    vaktaList[selectedVaktaIndex!].isactive = 0;
                    selectedVaktaIndex = null;
                  });
                }
              },
              child: const Icon(Icons.delete, color: Colors.red, size: 20),
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
          child: Text("$title : ", style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: Colors.purpleAccent)),
        ),
        Expanded(
          flex: 7,
          child: Text(value ?? "—", style: const TextStyle(fontSize: 16, color: Colors.black87)),
        ),
      ],
    );
  }

  showAddVaktaDialogBox({bool fromEditing = false}) {
    if (!_guardSearch()) return;
    if (!fromEditing) {
      txtVaktaNameController.clear();
      txtVaktaTaskController.clear();
    }
    return showDialog(
      context: context,
      builder: (ct) => StatefulBuilder(
        builder: (ctx, set) => Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          insetPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(Statics.getLabel('sanmelanVakta'), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.purpleAccent)),
                Divider(color: Colors.deepPurple.shade100),
                const SizedBox(height: 4),
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
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purpleAccent,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      ),
                      onPressed: () {
                        final d = AbhiyaanPeopleModel(
                          pkid: 0,
                          name: txtVaktaNameController.text.trim(),
                          desgination: txtVaktaTaskController.text.trim(),
                          isactive: 1,
                        );
                        if (fromEditing) {
                          vaktaList.removeAt(selectedVaktaIndex!);
                          vaktaList.insert(selectedVaktaIndex!, d);
                        } else {
                          vaktaList.add(d);
                        }
                        txtVaktaNameController.clear();
                        txtVaktaTaskController.clear();
                        Navigator.pop(ctx);
                        setState(() {});
                      },
                      child: Text(Statics.getLabel('Submit'), style: const TextStyle(color: Colors.white)),
                    ),
                    if (fromEditing) const SizedBox(width: 12),
                    if (fromEditing)
                      MaterialButton(
                        onPressed: () {
                          txtVaktaNameController.clear();
                          txtVaktaTaskController.clear();
                          Navigator.pop(ct);
                        },
                        child: Text(Statics.getLabel('clear')),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // GEO-UNIT DROPDOWN PANEL (unchanged logic)
  // ═══════════════════════════════════════════════════════════════════════════

  Widget vastiMandalDropdown() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(width: 0.7, color: Colors.grey.shade700),
      ),
      child: ExpansionPanelList(
        elevation: 0,
        expandedHeaderPadding: EdgeInsets.zero,
        expansionCallback: (_, isExpanded) => setState(() => _isExpanded = isExpanded),
        children: [
          ExpansionPanel(
            backgroundColor: Colors.transparent,
            headerBuilder: (_, __) => ListTile(
              title: Text(Statics.getLabel('selectVastiMandal'), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            ),
            body: Container(
              margin: const EdgeInsets.all(10),
              child: Column(
                children: [
                  if (_linkedMahaanagar != null)
                    _buildDropdownField(
                      isDisabled: MyAppGlobals.isDropdownDisabled('Mahaanagar'),
                      label: Statics.getLabel('Mahaanagar'),
                      value: _linkedMahaanagarValue,
                      items: _linkedMahaanagar!.map((g) => DropdownMenuItem(value: g.geoUnitID.toString(), child: Text(g.name!))).toList(),
                      onChanged: (value) async {
                        final item = _linkedMahaanagar!.firstWhere((g) => g.geoUnitID.toString() == value);
                        setState(() {
                          _linkedMahaanagarValue = value;
                          _linkedVibhaagValue = null;
                          _selctedLevel = 'Mahanagar';
                          _selctedLevelName = item.name ?? "";
                          _selectedGeoUnitId = value;
                        });
                        populatelinkedVibhaagDropdown(value!);
                        populatelinkedBhaagDropdown("");
                      },
                    ),
                  if (_linkedVibhaag != null)
                    _buildDropdownField(
                      isDisabled: MyAppGlobals.isDropdownDisabled('Vibhaag'),
                      label: Statics.getLabel('Vibhaag'),
                      value: _linkedVibhaagValue,
                      items: _linkedVibhaag!.map((g) => DropdownMenuItem(value: g.geoUnitID.toString(), child: Text(g.name!))).toList(),
                      onChanged: (value) {
                        final item = _linkedVibhaag!.firstWhere((g) => g.geoUnitID.toString() == value);
                        setState(() {
                          _linkedVibhaagValue = value;
                          _selctedLevel = 'Vibhaag';
                          _selctedLevelName = item.name ?? "";
                          _selectedGeoUnitId = value;
                        });
                        populatelinkedBhaagDropdown(value!);
                      },
                    ),
                  if (_linkedbhaag != null && _linkedbhaag!.isNotEmpty)
                    _buildDropdownField(
                      isDisabled: MyAppGlobals.isDropdownDisabled('Bhaag'),
                      label: Statics.getLabel('Bhaag'),
                      value: _linkedbhaagValue,
                      items: _linkedbhaag!.map((g) => DropdownMenuItem(value: g.geoUnitID.toString(), child: Text(g.name!))).toList(),
                      onChanged: (value) {
                        final item = _linkedbhaag!.firstWhere((g) => g.geoUnitID.toString() == value);
                        setState(() {
                          _linkedbhaagValue = value;
                          _selctedLevel = 'Bhaag';
                          _selctedLevelName = item.name ?? "";
                          _linkedbhaagName = item.name ?? "";
                          _selectedGeoUnitId = value;
                          populatelinkedShaharDropdown(value!);
                          populatelinkedNagarDropdown(value, null);
                        });
                      },
                    ),
                  if (_linkedshahar != null && _linkedshahar!.isNotEmpty)
                    _buildDropdownField(
                      isDisabled: MyAppGlobals.isDropdownDisabled('Nagar'),
                      label: Statics.getLabel('Shahar'),
                      value: _linkedshaharValue,
                      items: _linkedshahar!.map((g) => DropdownMenuItem(value: g.geoUnitID.toString(), child: Text(g.name!))).toList(),
                      onChanged: (value) {
                        final item = _linkedshahar!.firstWhere((g) => g.geoUnitID.toString() == value);
                        setState(() {
                          _linkedshaharValue = value;
                          _selectedGeoUnitId = value;
                          _selctedLevel = 'Shahar';
                          _selctedLevelName = item.name ?? "";
                          _linkedshaharName = item.name ?? "";
                          populatelinkedNagarDropdown(null, value);
                        });
                      },
                    ),
                  if (_linkednagar != null && _linkednagar!.isNotEmpty)
                    _buildDropdownField(
                      isDisabled: MyAppGlobals.isDropdownDisabled('upnagarUpkhanda'),
                      label: Statics.getLabel('Nagar'),
                      value: _linkednagarValue,
                      items: _linkednagar!.map((g) => DropdownMenuItem(value: g.geoUnitID.toString(), child: Text(g.name!))).toList(),
                      onChanged: (value) {
                        final item = _linkednagar!.firstWhere((g) => g.geoUnitID.toString() == value);
                        setState(() {
                          _linkednagarValue = value;
                          _selectedGeoUnitId = value;
                          _selctedLevel = 'Nagar';
                          _selctedLevelName = item.name ?? "";
                          _linkednagarName = item.name ?? "";
                          populatelinkedMandalDropdown(false, value);
                          populatelinkedVastiDropdown(value);
                        });
                      },
                    ),
                  if (_linkedupnagar != null && _linkedupnagar!.isNotEmpty)
                    _buildDropdownField(
                      isDisabled: MyAppGlobals.isDropdownDisabled('Mandal'),
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
                    ),
                  if (_linkedmandal != null && _linkedmandal!.isNotEmpty)
                    _buildDropdownField(
                      isDisabled: MyAppGlobals.isDropdownDisabled('Graam'),
                      label: Statics.getLabel('Mandal'),
                      value: _linkedmandalValue,
                      items: _linkedmandal!.map((g) => DropdownMenuItem(value: g.geoUnitID.toString(), child: Text(g.name!))).toList(),
                      onChanged: (value) {
                        final item = _linkedmandal!.firstWhere((g) => g.geoUnitID.toString() == value);
                        setState(() {
                          _linkedmandalValue = value;
                          _selectedGeoUnitId = value.toString();
                          _selctedLevel = 'Mandal';
                          _selctedLevelName = item.name ?? "";
                          _linkedmandalName = item.name ?? "";
                          populatelinkedGraamDropdown(value);
                        });
                      },
                    ),
                  if (_linkedvasti != null && _linkedvasti!.isNotEmpty)
                    _buildDropdownField(
                      isDisabled: MyAppGlobals.isDropdownDisabled('Vasti'),
                      label: Statics.getLabel('Vasti'),
                      value: _linkedvastiValue,
                      items: _linkedvasti!.map((g) => DropdownMenuItem(value: g.geoUnitID.toString(), child: Text(g.name!))).toList(),
                      onChanged: (value) {
                        final item = _linkedvasti!.firstWhere((g) => g.geoUnitID.toString() == value);
                        setState(() {
                          _linkedvastiValue = value;
                          _selectedGeoUnitId = value.toString();
                          _selctedLevel = 'Vasti';
                          _selctedLevelName = item.name ?? "";
                          _linkedvastiName = item.name ?? "";
                        });
                      },
                    ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if ((_linkedmandalValue != null && _linkedmandalValue!.isNotEmpty) || (_linkedvastiValue != null && _linkedvastiValue!.isNotEmpty))
                        MaterialButton(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                          padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 5),
                          color: Theme.of(context).primaryColor,
                          textColor: Theme.of(context).primaryTextTheme.labelMedium?.color,
                          onPressed: () async {
                            _selctedLevelNameList = [];
                            setState(() {});
                            _selctedLevelNameList.addAll([
                              _linkedbhaagName,
                              _linkedshaharName,
                              _linkednagarName,
                              _linkedmandalName,
                              _linkedgraamName,
                              _linkedvastiName,
                            ]);
                            await _getForm();
                            setState(() {
                              _selctedLevelNames = _selctedLevelNameList.where((e) => e != null && e.isNotEmpty).cast<String>().join(' -> ');
                              _searched = true;
                              _isExpanded = false;
                              isVastiSearch = true;
                            });
                          },
                          child: Text(Statics.getLabel('search'), style: const TextStyle(fontSize: 16)),
                        ),
                      MaterialButton(
                        onPressed: () async {
                          setState(() {
                            _searched = false;
                            isVastiSearch = false;
                            _selectedGeoUnitId = null;
                            _linkedMahaanagarValue = _linkedbhaagValue = _linkedshaharValue = _linkednagarValue = _linkedmandalValue = _linkedvastiValue = _linkedgraamValue = null;
                            _linkedVibhaagValue = _linkedbhaag = _linkedshahar = _linkedgraam = _linkedmandal = _linkedvasti = _linkednagar = null;
                            _selctedLevel = "praant";
                          });
                          clearForm();
                          await populateDropdown();
                        },
                        child: Text(Statics.getLabel('clear')),
                      ),
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
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(labelText: label),
        isExpanded: true,
        value: (value == null || value.isEmpty) ? null : value,
        items: items,
        onChanged: onChanged,
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // COMMON FORM WIDGETS
  // ═══════════════════════════════════════════════════════════════════════════

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
          text: TextSpan(children: [
            TextSpan(
              text: name,
              style: TextStyle(fontSize: 15, fontWeight: isTextBold ? FontWeight.bold : FontWeight.normal, color: Colors.black),
            ),
            TextSpan(
              text: imp,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.red),
            ),
          ]),
        ),
        const SizedBox(height: 5),
        SizedBox(
          height: height,
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            inputFormatters: keyboardType == TextInputType.number ? [FilteringTextInputFormatter.allow(RegExp(r'^[0-9]*$'))] : [],
            decoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              filled: true,
              fillColor: Colors.white,
              hintText: hintTextString,
            ),
            readOnly: isEdit || !_searched,
            maxLength: maxInput,
            onTap: () => _guardSearch(),
            // buildCounter: (_, {currentLength, maxLength, isFocused}) => null,
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget mainContainer(String header, Widget child) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.purpleAccent),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        padding: EdgeInsets.symmetric(
          vertical: size.height * 0.01,
          horizontal: size.width * 0.03,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              header,
              style: const TextStyle(color: Colors.purpleAccent, fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const Divider(color: Colors.black87, thickness: 1),
            const SizedBox(height: 10),
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
          text: TextSpan(children: [
            TextSpan(
              text: "${questionNumber != null ? "$questionNumber. " : ""}$question",
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            TextSpan(
              text: imp,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.red),
            ),
          ]),
        ),
        Row(children: [
          Radio<int>(
            value: 1,
            groupValue: selectedOption,
            activeColor: Colors.purpleAccent,
            onChanged: isDisable
                ? null
                : (v) {
                    if (!_guardSearch()) return;
                    if (v != null) onChanged(v);
                  },
          ),
          Text(Statics.getLabel('ConfirmationYes'), style: const TextStyle(fontSize: 14)),
          const SizedBox(width: 20),
          Radio<int>(
            value: 0,
            groupValue: selectedOption,
            activeColor: Colors.purpleAccent,
            onChanged: isDisable
                ? null
                : (v) {
                    if (!_guardSearch()) return;
                    if (v != null) onChanged(v);
                  },
          ),
          Text(Statics.getLabel('ConfirmationNo'), style: const TextStyle(fontSize: 14)),
        ]),
      ],
    );
  }

  Widget _numberField(
    TextEditingController controller, {
    EdgeInsetsGeometry? padding,
    Color? textBoxColor,
    Color? containerColor,
    TextEditingController? limitController,
    TextEditingController? otherController,
  }) {
    return Container(
      padding: padding ?? const EdgeInsets.all(4),
      alignment: Alignment.center,
      decoration: BoxDecoration(color: containerColor),
      child: TextField(
        controller: controller,
        readOnly: !_searched,
        onTap: () => _guardSearch(),
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          filled: textBoxColor != null,
          fillColor: textBoxColor,
          hintText: "0",
          border: const UnderlineInputBorder(),
          focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.deepPurple, width: 2)),
          enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey, width: 1)),
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        ),
        onChanged: (val) {
          if (limitController != null && otherController != null) {
            final limit = int.tryParse(limitController.text) ?? 0;
            final self = int.tryParse(val) ?? 0;
            final other = int.tryParse(otherController.text) ?? 0;
            if (self + other > limit) {
              controller.text = (limit - other).toString();
              controller.selection = TextSelection.fromPosition(TextPosition(offset: controller.text.length));
            }
          }
          if (mounted) setState(() {});
        },
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // POPUPS (unchanged logic, kept as-is)
  // ═══════════════════════════════════════════════════════════════════════════

  Future<void> showMukhyaAtithiSelectionPopup(BuildContext context, {sarsajjanshaktiList, sanyaprabhaviList, dynamic preselectedItem}) async {
    dynamic selectedItem = selectedPerson ?? selectedPrabhavi;
    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, set) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          titlePadding: const EdgeInsets.fromLTRB(12, 20, 12, 0),
          title: Column(mainAxisSize: MainAxisSize.min, children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 8),
                Expanded(
                  child: Text(Statics.getLabel('selectMukhyaAtithi'), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
                IconButton(
                  style: IconButton.styleFrom(tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                  icon: const Icon(Icons.close, color: Colors.redAccent),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              spacing: 12,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  ),
                  icon: const Icon(Icons.search, color: Colors.white),
                  label: Text(Statics.getLabel('Search'), style: const TextStyle(color: Colors.white)),
                  onPressed: () async {
                    if (selectedItem != null || selectedPerson != null || selectedPrabhavi != null) {
                      Statics.showToast("test");
                      return;
                    }
                    await submitForm();
                    Navigator.of(context).pushReplacementNamed(
                      SearchSajjanAnyaScreen.routeName,
                      arguments: {'geoUnitId': _selectedGeoUnitId, 'fromMukhya': true},
                    ).then((_) async {
                      await _getForm();
                      setState(() {});
                    });
                  },
                ),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.purpleAccent, width: 1.5),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  ),
                  onPressed: () async {
                    await submitForm();
                    Navigator.of(context).pushReplacementNamed(
                      AddMukhyaAtithi.routeName,
                      arguments: {'linkedNagar': _linkednagar, 'selectedLevelId': _linkednagarValue},
                    ).then((_) => _getForm());
                  },
                  child: Text(Statics.getLabel('fillNewRecord'), style: const TextStyle(color: Colors.purpleAccent)),
                ),
              ],
            ),
          ]),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          content: Container(
            width: double.maxFinite,
            constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * 0.58),
            child: Scrollbar(
              radius: const Radius.circular(8),
              interactive: true,
              thumbVisibility: true,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(Statics.getLabel('SajjanShakti'), style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: Colors.blueGrey)),
                    const Divider(),
                    _radioTable(
                        list: sarsajjanshaktiList,
                        selectedItem: selectedItem,
                        onChanged: (item) {
                          set(() {
                            selectedItem = item;
                            selectedType = "sarsajjanshakti";
                            selectedPrabhavi = null;
                          });
                          setState(() {});
                        },
                        getName: (e) => e.name ?? ""),
                    const SizedBox(height: 16),
                    Text(Statics.getLabel('anyaPrabhaviLok'), style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: Colors.blueGrey)),
                    const Divider(),
                    _radioTable(
                        list: sanyaprabhaviList,
                        selectedItem: selectedItem,
                        onChanged: (item) {
                          set(() {
                            selectedItem = item;
                            selectedType = "anyaprabhavi";
                            selectedPerson = null;
                          });
                          setState(() {});
                        },
                        getName: (e) => e.name ?? ""),
                  ],
                ),
              ),
            ),
          ),
          actionsPadding: const EdgeInsets.only(left: 12, right: 12, bottom: 12, top: 6),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purpleAccent,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    ),
                    onPressed: () {
                      if (selectedItem != null && selectedType != null) {
                        set(() {
                          if (selectedType == "sarsajjanshakti") {
                            selectedPerson = selectedItem as Vastisarsajjanshakti;
                            selectedPrabhavi = null;
                          } else {
                            selectedPrabhavi = selectedItem as Vastisanyaprabhavi;
                            selectedPerson = null;
                          }
                        });
                        setState(() {});
                      }
                      Navigator.pop(context);
                    },
                    child: Text(Statics.getLabel('Submit'), style: const TextStyle(color: Colors.white)),
                  ),
                ),
                if (selectedItem != null || selectedPerson != null || selectedPrabhavi != null) ...[
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.purpleAccent, width: 1.5),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      ),
                      onPressed: () {
                        set(() {
                          selectedItem = null;
                          selectedPerson = null;
                          selectedPrabhavi = null;
                          for (final e in data!.vastisarsajjanshakti!) e.isMukhyadefault = 0;
                          for (final e in data!.vastisanyaprabhavi!) e.isMukhyadefault = 0;
                        });
                        setState(() {});
                      },
                      child: Text(Statics.getLabel('clear'), style: const TextStyle(color: Colors.purpleAccent)),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Generic radio selection table used in Mukhya Atithi popup.
  Widget _radioTable({
    required List list,
    required dynamic selectedItem,
    required void Function(dynamic) onChanged,
    required String Function(dynamic) getName,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black12),
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: Table(
        border: TableBorder.symmetric(inside: const BorderSide(color: Colors.black12)),
        columnWidths: const {0: FixedColumnWidth(50)},
        children: [
          TableRow(
            decoration: BoxDecoration(color: Colors.blue.shade50),
            children: [
              const Padding(padding: EdgeInsets.all(8), child: Text("🔘", style: TextStyle(fontWeight: FontWeight.bold))),
              Padding(padding: const EdgeInsets.all(8), child: Text(Statics.getLabel('Name'), style: const TextStyle(fontWeight: FontWeight.bold))),
            ],
          ),
          ...list.map((item) => TableRow(children: [
                Center(
                  child: Radio(
                    value: item,
                    groupValue: selectedItem,
                    activeColor: Colors.purpleAccent,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    onChanged: (_) => onChanged(item),
                  ),
                ),
                Padding(padding: const EdgeInsets.all(8), child: Text(getName(item))),
              ])),
        ],
      ),
    );
  }

  Future<void> showGraamVastiMandalUpnagarPopup(
    BuildContext context, {
    required List<UpnagarmandallistVijayaDashami> vastiList,
    List<UpnagarmandallistVijayaDashami>? preselectedItems,
    required void Function(List<UpnagarmandallistVijayaDashami>, int, int) onSubmit,
  }) async {
    List<UpnagarmandallistVijayaDashami> selected = List.from(preselectedItems ?? []);
    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, set) => Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          insetPadding: const EdgeInsets.all(16),
          child: Container(
            padding: const EdgeInsets.all(16),
            height: MediaQuery.of(context).size.height * 0.6,
            width: double.maxFinite,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(Statics.getLabel('addGraam'), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    IconButton(icon: const Icon(Icons.close, color: Colors.redAccent), onPressed: () => Navigator.pop(context)),
                  ],
                ),
                const Divider(),
                Text("${Statics.getLabel('totalGraam')}: ${vastiList.length}", style: const TextStyle(fontSize: 14, color: Colors.grey)),
                Text("${Statics.getLabel('selectedTotal')}: ${selected.length}", style: const TextStyle(fontSize: 14, color: Colors.blue)),
                const SizedBox(height: 10),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListView.builder(
                      itemCount: vastiList.length,
                      itemBuilder: (_, i) {
                        final item = vastiList[i];
                        return CheckboxListTile(
                          title: Text(item.geoUnitName ?? ""),
                          value: selected.any((e) => e.geoUnitID == item.geoUnitID),
                          onChanged: (checked) {
                            set(() {
                              if (checked == true) {
                                if (!selected.any((e) => e.geoUnitID == item.geoUnitID)) selected.add(item);
                              } else {
                                selected.removeWhere((e) => e.geoUnitID == item.geoUnitID);
                              }
                            });
                          },
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purpleAccent,
                    minimumSize: const Size.fromHeight(44),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    onSubmit(selected, selected.length, vastiList.length);
                    Navigator.pop(context);
                  },
                  child: Text(Statics.getLabel('Submit'), style: const TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> showVisheshAtithiSelectionPopup(BuildContext context, {sarsajjanshaktiList, sanyaprabhaviList}) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        if (data == null) {
          return const Center(child: CircularProgressIndicator());
        }
        return StatefulBuilder(
          builder: (ctnx, set) => AlertDialog(
            clipBehavior: Clip.antiAlias,
            contentPadding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            content: Container(
              width: double.maxFinite,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(Statics.getLabel('selectSpecialPerson'), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
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
                          Row(
                            spacing: 12,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                ),
                                icon: const Icon(Icons.search, color: Colors.white),
                                label: Text(Statics.getLabel('Search'), style: const TextStyle(color: Colors.white)),
                                onPressed: () async {
                                  await submitForm();
                                  Navigator.of(context).pushReplacementNamed(
                                    SearchSajjanAnyaScreen.routeName,
                                    arguments: {'geoUnitId': _selectedGeoUnitId},
                                  ).then((_) async {
                                    await _getForm();
                                    setState(() {});
                                  });
                                },
                              ),
                              OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: Colors.purpleAccent, width: 1.5),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                ),
                                onPressed: () async {
                                  await submitForm();
                                  Navigator.of(context).pushReplacementNamed(
                                    AddVishisthaAtithi.routeName,
                                    arguments: {'geoUnitId': _selectedGeoUnitId},
                                  ).then((_) async {
                                    await _getForm();
                                    setState(() {});
                                  });
                                },
                                child: Text(Statics.getLabel('fillNewRecord'), style: const TextStyle(color: Colors.purpleAccent)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Flexible(
                            child: SingleChildScrollView(
                              child: Column(children: [
                                const SizedBox(height: 12),
                                Text(Statics.getLabel('SajjanShakti'), style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: Colors.blueGrey)),
                                const Divider(),
                                _checkboxTable(
                                  list: sarsajjanshaktiList,
                                  isSelected: (item) => selectedSajjanshaktiItems.any((x) => x.pkid == item.pkid),
                                  onChanged: (item, val) {
                                    set(() {
                                      if (val)
                                        selectedSajjanshaktiItems.add(item);
                                      else
                                        selectedSajjanshaktiItems.removeWhere((x) => x.pkid == item.pkid);
                                      selectedSajjanshaktiItemsIds = selectedSajjanshaktiItems.map((e) => e.pkid.toString()).join(",");
                                    });
                                  },
                                  getName: (e) => e.name ?? "",
                                ),
                                const SizedBox(height: 12),
                                Text(Statics.getLabel('anyaPrabhaviLok'), style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: Colors.blueGrey)),
                                const Divider(),
                                _checkboxTable(
                                  list: sanyaprabhaviList,
                                  isSelected: (item) => selectedAnyaprabhaviItems.any((x) => x.pkId == item.pkId),
                                  onChanged: (item, val) {
                                    set(() {
                                      if (val)
                                        selectedAnyaprabhaviItems.add(item);
                                      else
                                        selectedAnyaprabhaviItems.removeWhere((x) => x.pkId == item.pkId);
                                      selectedAnyaprabhaviItemsIds = selectedAnyaprabhaviItems.map((e) => e.pkId.toString()).join(",");
                                    });
                                  },
                                  getName: (e) => e.name ?? "",
                                ),
                              ]),
                            ),
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.purpleAccent,
                              minimumSize: const Size.fromHeight(44),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            onPressed: () {
                              set(() {});
                              Navigator.pop(ctx);
                              setState(() {});
                            },
                            child: Text(Statics.getLabel('Submit'), style: const TextStyle(color: Colors.white)),
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// Generic checkbox table used in Vishesh Atithi popup.
  Widget _checkboxTable({
    required List list,
    required bool Function(dynamic) isSelected,
    required void Function(dynamic, bool) onChanged,
    required String Function(dynamic) getName,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black12),
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: Table(
        border: TableBorder.symmetric(inside: const BorderSide(color: Colors.black12)),
        columnWidths: const {0: FixedColumnWidth(50)},
        children: [
          TableRow(
            decoration: BoxDecoration(color: Colors.blue.shade50),
            children: [
              const Padding(padding: EdgeInsets.all(8), child: Text("✔", style: TextStyle(fontWeight: FontWeight.bold))),
              Padding(padding: const EdgeInsets.all(8), child: Text(Statics.getLabel("Name"), style: const TextStyle(fontWeight: FontWeight.bold))),
            ],
          ),
          ...list.map((item) => TableRow(children: [
                Center(
                  child: Checkbox(
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    value: isSelected(item),
                    onChanged: (val) => onChanged(item, val ?? false),
                  ),
                ),
                Padding(padding: const EdgeInsets.all(8), child: Text(getName(item))),
              ])),
        ],
      ),
    );
  }

  Future<void> showPersonDetailsPopup(BuildContext context, dynamic item, int srNo) {
    List<Map<String, String>> details = [];
    if (item is Vastisarsajjanshakti) {
      details = [
        {Statics.getLabel('Vasti'): item.vastiname ?? ""},
        {Statics.getLabel('Name'): item.name ?? ""},
        {Statics.getLabel('Address'): item.address ?? ""},
        {Statics.getLabel('mobileNumberLabel'): item.doorabhaash ?? ""},
        {Statics.getLabel('shreni'): item.selectedDropdownValueName ?? ""},
        {Statics.getLabel('OrganizationName'): item.sanstheCheNaav ?? ""},
        {Statics.getLabel('sansthetKuthalaPadavar'): item.sansthechaKuthalaPadavar ?? ""},
        {Statics.getLabel('samparkSthiti'): item.selectedDropdownValueName1 ?? ""},
        {Statics.getLabel('special'): item.visheshname ?? ""},
        {Statics.getLabel('prabhavKshetra'): item.prabhaavkshetrName ?? ""},
        {Statics.getLabel('samparkSootraNaav'): item.samparkasutranava ?? ""},
        {Statics.getLabel('samparakSootraDoorbhash'): item.samparkasutraMobileNumber ?? ""},
      ];
    } else if (item is Vastisanyaprabhavi) {
      details = [
        {Statics.getLabel('Vasti'): item.vastiName ?? ""},
        {Statics.getLabel('Name'): item.name ?? ""},
        {Statics.getLabel('Address'): item.address ?? ""},
        {Statics.getLabel('mobileNumberLabel'): item.doorabhaash ?? ""},
        {Statics.getLabel('shreni'): item.shreneeName ?? ""},
        {Statics.getLabel('upshreni'): item.upshreneeName ?? ""},
        {Statics.getLabel('otherUpshreni'): item.otherUpshrenee ?? ""},
        {"${Statics.getLabel('upshreni')}2": item.upshrenee2Name ?? ""},
        {"${Statics.getLabel('otherUpshreni')}2": item.otherUpshrenee2 ?? ""},
        {Statics.getLabel('special'): item.visheshName ?? ""},
        {Statics.getLabel('prabhavKshetra'): item.prabhaavKshetreName ?? ""},
        {"${Statics.getLabel('other')} ${Statics.getLabel('special')}": item.anyaVishesMahiti ?? ""},
        {Statics.getLabel('samparkStithi'): item.samparkSthit ?? ""},
        {Statics.getLabel('samparkSootraNaav'): item.samparkAsutraNav ?? ""},
        {Statics.getLabel('samparakSootraDoorbhash'): item.samparkaSutraDoorbhash ?? ""},
      ];
    }

    return showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        insetPadding: const EdgeInsets.all(16),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.purple, Colors.purpleAccent],
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(Statics.getLabel('PersonalDetails'), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: details
                        .map((e) => Container(
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
                                    child: Text("${e.keys.first}:", style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Colors.black87)),
                                  ),
                                  Expanded(
                                    flex: 5,
                                    child: Text(e.values.first.isEmpty ? "-" : e.values.first, style: const TextStyle(fontSize: 14, color: Colors.black54)),
                                  ),
                                ],
                              ),
                            ))
                        .toList(),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.all(12),
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purpleAccent,
                    minimumSize: const Size.fromHeight(45),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.check_circle, color: Colors.white),
                  label: Text(Statics.getLabel('bandKara'), style: const TextStyle(fontSize: 16, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
