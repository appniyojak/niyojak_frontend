import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:math' as m;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:niyojak_prod/screens/shatabdi_vrutta_sankalan/vijayadashami/vijaya_dashami_report.dart';
import 'package:niyojak_prod/widgets/app_drawer.dart';
import 'package:niyojak_prod/widgets/single_column_row.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../helpers/static_data.dart' as Statics;
import '../../../models/response_model/get_vijaya_dashami_geounit_data.dart';
import '../../../models/response_model/vasti_up_data_model.dart';
import '../../../models/response_model/vijayaDashamiInitModel.dart';
import '../../../providers/bals.dart';
import '../../../utils/globals.dart';
import '../../../validation_blocks/validator.dart';
import '../../levels_update_module/levels_manage_tabs.dart';
import 'add_mukhya_atithi_form.dart';
import 'add_vishesh_vyakti.dart';

class VijayadashamiFormView extends StatefulWidget {
  static const String routeName = '/vijayadashami-form-view';

  const VijayadashamiFormView({super.key});

  @override
  State<VijayadashamiFormView> createState() => _VijayadashamiFormViewState();
}

class _VijayadashamiFormViewState extends State<VijayadashamiFormView> {
  final _formKey = GlobalKey<FormState>();
  final ScrollController _scrollController = ScrollController();

  TextEditingController txtUrlsController = TextEditingController();
  TextEditingController txtUrlDescController = TextEditingController();

  bool _isSearching = false;
  bool _isExpanded = true;
  bool isVastiSearch = false;

  List<GeoUnitMasterBAL>? _linkedMahaanagar;
  List<GeoUnitMasterBAL>? _linkedVibhaag;
  List<GeoUnitMasterBAL>? _linkedBhaag;
  List<GeoUnitMasterBAL>? _linkedShahar;
  List<GeoUnitMasterBAL>? _linkedNagar;
  List<UpnagarmandallistVijayaDashami>? _linkedUpnagar;
  List<GeoUnitMasterBAL>? _linkedmandal;
  List<GeoUnitMasterBAL>? _linkedgraam;
  List<GeoUnitMasterBAL>? _linkedvasti;
  List<StaticMasterBAL>? _baithakTypes;
  String? _linkedMahaanagarValue = '';
  String? _linkedVibhaagValue = '';
  String? _linkedBhaagValue = '';
  String? _linkedShaharValue = '';
  String? _linkedNagarValue = '';
  String? _linkedNagarValuePopup = '';
  String? _linkedgraamValue = "";
  String? _linkedmandalValue = "";
  String? _linkedupnaragValue = "";
  String? _linkedvastiValue = "";
  String? _baithakTypeValue = '';
  String? _baithakTypeYear = '';
  int? _baithakType;
  String _selectedNagarAndBaithak = '';
  String? mahanagarId = '';
  String? vibhagId = '';

  List<int?> selectedUpnagarList = [];

  @override
  void initState() {
    super.initState();
    populateDropdown();
    presentMatrushaktiController.addListener(_calculateTotal);
    presentMaleController.addListener(_calculateTotal);
  }

  Future<void> clearForm() async {
    setState(() {
      // Reset int flags (as per your logic: 2 = default)
      programNirdharitVed = 2;
      vaiyaktikGitKantashtha = 2;
      programHishobh24Hour = 2;
      sanchalanZaleKa = 2;
      sanchalanSadandaZalKa = 2;
      sanchalanGhoshVadanZalKa = 2;

      // Reset text controllers
      presentMatrushaktiController.clear();
      presentMaleController.clear();
      patShishuBaalCtrl.clear();
      ganShishuBaalCtrl.clear();
      anyaShishuBaalCtrl.clear();
      patMahavidyaCtrl.clear();
      ganMahavidyaCtrl.clear();
      anyaMahavidyaCtrl.clear();
      patTarunVyavCtrl.clear();
      ganTarunVyavCtrl.clear();
      anyaTarunVyavCtrl.clear();
      patProudhVyavCtrl.clear();
      ganProudhVyavCtrl.clear();
      anyaProudhVyavCtrl.clear();

      // Reset expand/collapse state
      _isExpanded = false;

      // Reset dropdowns / linked values
      _linkedMahaanagarValue = null;
      _linkedVibhaagValue = null;
      _linkedBhaagValue = null;
      _linkedShaharValue = null;
      _linkedNagarValue = null;
      _linkedmandalValue = null;
      _linkedupnaragValue = null;
      _linkedgraamValue = null;
      _linkedvastiValue = null;
      selectedUpnagarList = [];

      // Reset data lists
      _linkedBhaag = null;
      _linkedShahar = null;
      _linkedNagar = null;
      _linkedmandal = null;
      _linkedgraam = null;
      _linkedvasti = null;

      // Reset level tracking
      selctedLevel = '';
      selctedLevelName = '';
      selctedLevelId = null;
      selctedLevelIdForMandalDropdown = null;
      selctedLevelIdForVastiDropdown = null;
      utsavKontyaStaravar = "6";

      // Reset selections
      selectedMukhyaAtithi = null;
      selectedType = null;
      selectedSajjanshaktiItems = [];
      selectedAnyaprabhaviItems = [];
      selectedBhougolikPratinidhitwaVastiIds = null;
      selectedShakhaaPratinidhitwaVastiIds = null;
      selectedMilanPratinidhitwaVastiIds = null;
      selectedSanghaMandaliPratinidhitwaVastiIds = null;

      // Reset counts for Vasti
      selectedVastiCount = 0;
      totalVastiCount = 0;

      // ✅ Reset Sangha Mandali
      countsSanghaMandali = null;
      checkboxSanghaMandaliSelectedItems = [];
      totalSanghaMandaliCount = 0;
      selectedSanghaMandaliCount = 0;
      averageSanghaMandaliCount = "0";
      selectedSanghaMandaliPratinidhitwaVastiIds = null;

      // ✅ Reset Milan
      countsMilan = null;
      checkboxMilanSelectedItems = [];
      totalMilanCount = 0;
      selectedMilanCount = 0;
      averageMilanCount = "0";
      selectedMilanPratinidhitwaVastiIds = null;

      // ✅ Reset Shakha
      checkboxShakhaSelectedItems = [];
      totalShakhaCount = 0;
      selectedShakhaCount = 0;
      averageShakhaCount = "0";
      selectedShakhaaPratinidhitwaVastiIds = null;

      selectedPrabhavi = null;
      selectedPerson = null;
      // Re-populate base dropdowns
      populatelinkedVibhaagDropdown('');
    });
  }

  void populateDropdown() async {
    var data = await Statics.getStaticLDB('AnnualBaithakType');
    populatelinkedMahaanagarDropdown();
    populatelinkedVibhaagDropdown('');
    if (!mounted) return;
    _baithakTypes = data;
    _baithakTypes = _baithakTypes!.where((element) => element.showAnnualBaithakkey!.contains('1')).toList();
    print("_baithakTypes :-- ${_baithakTypes}");
    setState(() {});
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedMahaanagarDropdown() async {
    var data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['MahaanagarLevelID'].toString(), '', '', '');
    setState(() {
      _linkedMahaanagar = data;
    });
    return data;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedBhaagDropdownForMandal(String vibhaagIDStr) async {
    _linkedNagarValue = null;
    var data = await Statics.getGeoUnitsByLevelAndParentForMandal(Statics.levels['BhaagLevelID'].toString(), vibhaagIDStr, 'Vibhaag', '');
    setState(() {
      _linkedBhaag = data;
    });
    return data;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedVibhaagDropdownForMandal(String mahaanagarIDStr) async {
    _linkedBhaagValue = null;
    var data = await Statics.getGeoUnitsByLevelAndParentForMandal(Statics.levels['VibhaagLevelID'].toString(), mahaanagarIDStr, (mahaanagarIDStr.isEmpty ? '' : 'Mahaanagar'), '');
    setState(() {
      _linkedVibhaag = data;
    });
    return data;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedNagarDropdownForMandal(String? bhaagIDStr, String? shaharIDStr) async {
    _linkedNagarValue = null;
    _linkedNagar = null;
    if (shaharIDStr != null) {
      var ngDD = await Statics.getGeoUnitsByLevelAndParentForMandal(Statics.levels['NagarLevelID'].toString(), shaharIDStr, 'Shahar', '');
      setState(() {
        _linkedNagar = (ngDD.length > 0 ? ngDD : null);
      });
      return ngDD;
    } else {
      var ngDD = await Statics.getGeoUnitsByLevelAndParentForMandal(Statics.levels['NagarLevelID'].toString(), bhaagIDStr!, 'Bhaag', '');
      setState(() {
        _linkedNagar = (ngDD.length > 0 ? ngDD : null);
      });
      return ngDD;
    }
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedMandalDropdownForMandal(String nagarIDStr) async {
    _linkedgraamValue = null;
    _linkedmandal = _linkedgraam = null;
    var mnDD = await Statics.getGeoUnitsByLevelAndParentForMandal(Statics.levels['MandalLevelID'].toString(), nagarIDStr, 'Nagar', '');
    setState(() {
      _linkedmandal = (mnDD.length > 0 ? mnDD : null);
    });
    return mnDD;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedBhaagDropdown(String vibhaagIDStr) async {
    _linkedShaharValue = _linkedupnaragValue = _linkedNagarValue = null;
    var data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['BhaagLevelID'].toString(), vibhaagIDStr, 'Vibhaag', '');
    setState(() {
      _linkedBhaag = data;
    });
    return data;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedVibhaagDropdown(String mahaanagarIDStr) async {
    _linkedBhaagValue = null;
    var data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['VibhaagLevelID'].toString(), mahaanagarIDStr, (mahaanagarIDStr.isEmpty ? '' : 'Mahaanagar'), '');
    setState(() {
      _linkedVibhaag = data;
    });
    return data;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedMahaanagarDropdownForVasti() async {
    var data = await Statics.getGeoUnitsByLevelAndParentForVasti(Statics.levels['MahaanagarLevelID'].toString(), '', '', '');
    setState(() {
      _linkedMahaanagar = data;
    });
    return data;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedBhaagDropdownForVasti(String vibhaagIDStr) async {
    _linkedNagarValue = null;
    var data = await Statics.getGeoUnitsByLevelAndParentForVasti(Statics.levels['BhaagLevelID'].toString(), vibhaagIDStr, 'Vibhaag', '');
    setState(() {
      _linkedBhaag = data;
    });
    return data;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedVibhaagDropdownForVasti(String mahaanagarIDStr) async {
    _linkedBhaagValue = null;
    var data = await Statics.getGeoUnitsByLevelAndParentForVasti(Statics.levels['VibhaagLevelID'].toString(), mahaanagarIDStr, (mahaanagarIDStr.isEmpty ? '' : 'Mahaanagar'), '');
    setState(() {
      _linkedVibhaag = data;
    });
    return data;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedNagarDropdownForVasti(String? bhaagIDStr, String? shaharIDStr) async {
    _linkedNagarValue = null;
    _linkedNagar = null;
    if (shaharIDStr != null) {
      var ngDD = await Statics.getGeoUnitsByLevelAndParentForVasti(Statics.levels['NagarLevelID'].toString(), shaharIDStr, 'Shahar', '');
      setState(() {
        _linkedNagar = (ngDD.length > 0 ? ngDD : null);
      });
      return ngDD;
    } else {
      var ngDD = await Statics.getGeoUnitsByLevelAndParentForVasti(Statics.levels['NagarLevelID'].toString(), bhaagIDStr!, 'Bhaag', '');
      setState(() {
        _linkedNagar = (ngDD.length > 0 ? ngDD : null);
      });
      return ngDD;
    }
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedVastiDropdownForVasti(String nagarIDStr) async {
    _linkedvastiValue = null;
    var vsDD = await Statics.getGeoUnitsByLevelAndParentForVasti(Statics.levels['VastiLevelID'].toString(), nagarIDStr, 'Nagar', '');
    setState(() {
      _linkedvasti = (vsDD.length > 0 ? vsDD : null);
    });
    return vsDD;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedShaharDropdown(String bhaagIDStr) async {
    _linkedShaharValue = _linkedShahar = null;
    var shDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['ShaharLevelID'].toString(), bhaagIDStr, 'Bhaag', '');
    setState(() {
      _linkedShahar = (shDD.length > 0 ? shDD : null);
    });
    return shDD;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedNagarDropdown(String? bhaagIDStr, String? shaharIDStr) async {
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

  Future<List<GeoUnitMasterBAL>> populatelinkedMandalDropdown(String nagarIDStr) async {
    _linkedgraamValue = null;
    _linkedmandal = _linkedgraam = null;
    var mnDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['MandalLevelID'].toString(), nagarIDStr, 'Nagar', '');
    setState(() {
      _linkedmandal = (mnDD.length > 0 ? mnDD : null);
    });
    return mnDD;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedGraamDropdown(String mandalIDStr) async {
    _linkedgraamValue = null;
    var gmDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['GraamLevelID'].toString(), mandalIDStr, 'Mandal', '');
    setState(() {
      _linkedgraam = (gmDD.length > 0 ? gmDD : null);
    });
    return gmDD;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedVastiDropdown(String nagarIDStr) async {
    _linkedvastiValue = null;
    var vsDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['VastiLevelID'].toString(), nagarIDStr, 'Nagar', '');
    setState(() {
      _linkedvasti = (vsDD.length > 0 ? vsDD : null);
    });
    return vsDD;
  }

  String? selctedLevel = 'praant';
  String? selctedLevelName = '';
  String? selctedLevelId = '';
  String? selctedLevelIdForMandalDropdown = '';
  String? selctedLevelIdForVastiDropdown = '';
  String? selctedSanchalanLevelId = '';
  String? selctedSanchalanLevelName = '';

  int? programNirdharitVed = 2;
  int? vaiyaktikGitKantashtha = 2;
  int? programHishobh24Hour = 2;
  int? sanchalanZaleKa = 2;
  int? sanchalanSadandaZalKa = 2;
  int? sanchalanGhoshVadanZalKa = 2;

  final TextEditingController presentMaleController = TextEditingController();
  final TextEditingController presentMatrushaktiController = TextEditingController();

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
        readOnly: _isSearching == false,
        // 🔑 typing disable when false
        onTap: () {
          if (_isSearching == false) {
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

  GetVijayadashamiInitModel? data;

  Future<void> searchVijayaDashami() async {
    data = await Statics.getVijayadashamiInitData(context, Statics.userDetails["userID"], selectedUpnagarList.isEmpty ? selctedLevelId.toString() : selectedUpnagarList.join(","), utsavKontyaStaravar);
    print("searchVijayaDashami data ${data?.vastisarsajjanshakti}");
    selectedPrabhavi = null;
    selectedPerson = null;
    getVastiUpDataList();
    setState(() {});
  }

  Vastisarsajjanshakti? selectedPerson;
  Vastisanyaprabhavi? selectedPrabhavi;
  String? selectedType;
  int? selectedMukhyaAtithi;

  Future<void> showMukhyaAtithiSelectionPopup(
    BuildContext context, {
    required List<Vastisarsajjanshakti> vastisarsajjanshaktiList,
    required List<Vastisanyaprabhavi> vastisanyaprabhaviList,
    required void Function(String id, String type, dynamic selectedItem) onSubmit,
    required VoidCallback onAdd,
    dynamic preselectedItem,
    String? preselectedType,
  }) async {
    dynamic selectedItem = preselectedItem ?? vastisarsajjanshaktiList.firstWhereOrNull((e) => e.pkid == selectedMukhyaAtithi);
    String? selectedType = preselectedType;
    _linkedNagarValuePopup = "";
    log("showMukhyaAtithiSelectionPopup Opened >>>>>>>>>>>>>>>>>>>>> ");

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, set) {
            // dynamic selectedItem = preselectedItem ?? data!.vastisarsajjanshakti!.firstWhere((e) => e.pkid == selectedMukhyaAtithi);

            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              titlePadding: const EdgeInsets.fromLTRB(20, 20, 12, 0),
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
                  DropdownButtonFormField(
                    decoration: InputDecoration(
                      labelText: Statics.getLabel('Nagar'),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    isExpanded: true,
                    value: _linkedNagarValuePopup == "" ? _linkedNagarValue : _linkedNagarValuePopup,
                    items: _linkedNagar?.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                    onChanged: (value) async {
                      set(() {
                        _linkedNagarValuePopup = value;
                      });
                      final _data = await Statics.getVijayadashamiInitData(context, Statics.userDetails["userID"], value, "6");
                      set(() {
                        vastisarsajjanshaktiList = _data?.vastisarsajjanshakti ?? [];
                        vastisanyaprabhaviList = _data?.vastisanyaprabhavi ?? [];
                        if (selectedType == "sarsajjanshakti") {
                          selectedItem = preselectedItem ?? vastisarsajjanshaktiList.firstWhereOrNull((e) => e.pkid == selectedMukhyaAtithi);
                        } else {
                          selectedItem = preselectedItem ?? vastisanyaprabhaviList.firstWhereOrNull((e) => e.pkId == selectedMukhyaAtithi);
                        }
                      });
                    },
                  ),
                  SizedBox(height: 6),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      side: const BorderSide(color: Colors.purpleAccent, width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    ),
                    onPressed: onAdd,
                    child: Text(
                      Statics.getLabel('fillNewRecord'),
                      style: const TextStyle(color: Colors.purpleAccent),
                    ),
                  ),
                ],
              ),
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
                                ],
                              ),
                              ...vastisarsajjanshaktiList.map((item) {
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
                                          selectedItem = val;
                                          selectedType = "sarsajjanshakti";
                                        });
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
                              ...vastisanyaprabhaviList.map((item) {
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
                                          selectedItem = val;
                                          selectedType = "anyaprabhavi";
                                        });
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
                            String id = "";
                            if (selectedType == "sarsajjanshakti") {
                              id = (selectedItem as Vastisarsajjanshakti).pkid.toString();
                            } else {
                              id = (selectedItem as Vastisanyaprabhavi).pkId.toString();
                            }
                            onSubmit(id, selectedType!, selectedItem);
                            Navigator.pop(context);
                          }
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
                    // OutlinedButton(
                    //   style: OutlinedButton.styleFrom(
                    //     side: const BorderSide(color: Colors.purpleAccent, width: 1.5),
                    //     shape: RoundedRectangleBorder(
                    //       borderRadius: BorderRadius.circular(12),
                    //     ),
                    //     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    //   ),
                    //   onPressed: onAdd,
                    //   child: Text(
                    //     Statics.getLabel('fillNewRecord'),
                    //     style: const TextStyle(color: Colors.purpleAccent),
                    //   ),
                    // ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }

  List<Vastisarsajjanshakti> selectedSajjanshaktiItems = [];
  List<Vastisanyaprabhavi> selectedAnyaprabhaviItems = [];
  String? selectedSajjanshaktiItemsIds;
  String? selectedAnyaprabhaviItemsIds;

  Future<void> showVisheshAtithiSelectionPopup(
    BuildContext context, {
    required List<Vastisarsajjanshakti> vastisarsajjanshaktiList,
    required List<Vastisanyaprabhavi> vastisanyaprabhaviList,
    required List<Vastisarsajjanshakti> selectedSajjanshaktiItems,
    required List<Vastisanyaprabhavi> selectedAnyaprabhaviItems,
    required dynamic excludedItem,
    required String? sajjanshaktiIds,
    required String? anyaprabhaviIds,
    required String? selectedType, // 👈 नया parameter
    required int? selectedMukhyaAtithi, // 👈 नया parameter
    required VoidCallback onAdd,
    required void Function(
      String sajjanshaktiIds,
      String anyaprabhaviIds,
      List<Vastisarsajjanshakti> selectedSajjanshakti,
      List<Vastisanyaprabhavi> selectedAnyaprabhavi,
    ) onSubmit,
  }) async {
    print("showVisheshAtithiSelectionPopup onTap >>>>>>>>>>>>>>> $sajjanshaktiIds");
    print("showVisheshAtithiSelectionPopup onTap >>>>>>>>>>>>>>> $anyaprabhaviIds");
    _linkedNagarValuePopup = "";

    List<Vastisarsajjanshakti> filteredSajjanshakti = vastisarsajjanshaktiList.where((e) {
      if (excludedItem != null && excludedItem is Vastisarsajjanshakti) {
        if (e.pkid == excludedItem.pkid) return false;
      }

      // 👇 अगर selectedType = "sarsajjanshakti" है तो selectedMukhyaAtithi को exclude करना
      if (selectedType == "sarsajjanshakti" && selectedMukhyaAtithi != null) {
        if (e.pkid == selectedMukhyaAtithi) return false;
      }

      return true;
    }).toList();

    List<Vastisanyaprabhavi> filteredAnyaprabhavi = vastisanyaprabhaviList.where((e) {
      if (excludedItem != null && excludedItem is Vastisanyaprabhavi) {
        if (e.pkId == excludedItem.pkId) return false;
      }

      // 👇 अगर selectedType = "anyaprabhavi" है तो selectedMukhyaAtithi को exclude करना
      if (selectedType == "anyaprabhavi" && selectedMukhyaAtithi != null) {
        if (e.pkId == selectedMukhyaAtithi) return false;
      }

      return true;
    }).toList();

    /// ✅ Preselect items from comma separated IDs
    List<Vastisarsajjanshakti> selectedSajjanshakti = [];
    selectedSajjanshakti.addAll(selectedSajjanshaktiItems);
    if (sajjanshaktiIds != null && sajjanshaktiIds.isNotEmpty) {
      final ids = sajjanshaktiIds.split(",").map((e) => e.trim()).toList();
      // selectedSajjanshakti.addAll(filteredSajjanshakti.where((e) => ids.contains(e.pkid.toString())).toList());
      selectedSajjanshakti.toSet().toList();
    }

    List<Vastisanyaprabhavi> selectedAnyaprabhavi = [];
    selectedAnyaprabhavi.addAll(selectedAnyaprabhaviItems);
    if (anyaprabhaviIds != null && anyaprabhaviIds.isNotEmpty) {
      final ids = anyaprabhaviIds.split(",").map((e) => e.trim()).toList();
      // selectedAnyaprabhavi.addAll(filteredAnyaprabhavi.where((e) => ids.contains(e.pkId.toString())).toList());
      selectedAnyaprabhavi.toSet().toList();
    }

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, set) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              content: Container(
                // padding: const EdgeInsets.all(16),
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    /// Title with Close Button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          Statics.getLabel('selectVIshishthaAtithi'),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.purpleAccent,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.red),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    DropdownButtonFormField(
                      decoration: InputDecoration(
                        labelText: Statics.getLabel('Nagar'),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      isExpanded: true,
                      value: _linkedNagarValuePopup == "" ? _linkedNagarValue : _linkedNagarValuePopup,
                      items: _linkedNagar?.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                      onChanged: (value) async {
                        set(() {
                          _linkedNagarValuePopup = value;
                        });
                        final _data = await Statics.getVijayadashamiInitData(context, Statics.userDetails["userID"], value, "6");

                        set(() {
                          vastisarsajjanshaktiList = _data?.vastisarsajjanshakti ?? [];
                          vastisanyaprabhaviList = _data?.vastisanyaprabhavi ?? [];
                        });
                        set(() {
                          // if (vastisarsajjanshaktiList.isEmpty) return;
                          // if (vastisanyaprabhaviList.isEmpty) return;

                          filteredSajjanshakti = vastisarsajjanshaktiList.where((e) {
                            if (excludedItem != null && excludedItem is Vastisarsajjanshakti) {
                              if (e.pkid == excludedItem.pkid) return false;
                            }

                            // 👇 अगर selectedType = "sarsajjanshakti" है तो selectedMukhyaAtithi को exclude करना
                            if (selectedType == "sarsajjanshakti" && selectedMukhyaAtithi != null) {
                              if (e.pkid == selectedMukhyaAtithi) return false;
                            }

                            return true;
                          }).toList();

                          filteredAnyaprabhavi = vastisanyaprabhaviList.where((e) {
                            if (excludedItem != null && excludedItem is Vastisanyaprabhavi) {
                              if (e.pkId == excludedItem.pkId) return false;
                            }

                            // 👇 अगर selectedType = "anyaprabhavi" है तो selectedMukhyaAtithi को exclude करना
                            if (selectedType == "anyaprabhavi" && selectedMukhyaAtithi != null) {
                              if (e.pkId == selectedMukhyaAtithi) return false;
                            }

                            return true;
                          }).toList();
                        });

                        set(() {
                          if (selectedType == "sarsajjanshakti") {
                            if (sajjanshaktiIds != null && sajjanshaktiIds.isNotEmpty) {
                              print("Printing ids >>>>>>>>> $sajjanshaktiIds");
                              final ids = sajjanshaktiIds.split(",").map((e) => e.trim()).toList();
                              selectedSajjanshakti.addAll(filteredSajjanshakti.where((e) => ids.contains(e.pkid.toString())).toList());
                              selectedSajjanshakti.toSet().toList();
                            }
                            // selectedSajjanshakti = preselectedItem ?? vastisarsajjanshaktiList.firstWhereOrNull((e) => e.pkid == selectedMukhyaAtithi);
                          } else {
                            if (anyaprabhaviIds != null && anyaprabhaviIds.isNotEmpty) {
                              print("Printing ids >>>>>>>>> $anyaprabhaviIds");
                              final ids = anyaprabhaviIds.split(",").map((e) => e.trim()).toList();
                              selectedAnyaprabhavi.addAll(filteredAnyaprabhavi.where((e) => ids.contains(e.pkId.toString())).toList());
                              selectedAnyaprabhavi.toSet().toList();
                            }
                            // selectedAnyaprabhavi = preselectedItem ?? vastisanyaprabhaviList.firstWhereOrNull((e) => e.pkId == selectedMukhyaAtithi);
                          }
                        });
                        // String sajIds = selectedSajjanshakti.map((e) => e.pkid.toString()).join(",");
                        // String anyaIds = selectedAnyaprabhavi.map((e) => e.pkId.toString()).join(",");
                        //
                        // set(() {
                        //   onSubmit(sajIds, anyaIds, selectedSajjanshakti, selectedAnyaprabhavi);
                        // });
                      },
                    ),
                    SizedBox(height: 6),

                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            /// Content
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
                                    children: const [
                                      Padding(
                                        padding: EdgeInsets.all(8),
                                        child: Text("✔", style: TextStyle(fontWeight: FontWeight.bold)),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(8),
                                        child: Text("Naam", style: TextStyle(fontWeight: FontWeight.bold)),
                                      ),
                                    ],
                                  ),
                                  ...filteredSajjanshakti.map((item) {
                                    return TableRow(
                                      children: [
                                        Center(
                                            child: Checkbox(
                                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                          value: selectedSajjanshakti.any((x) => x.pkid == item.pkid),
                                          onChanged: (val) {
                                            set(() {
                                              if (val == true) {
                                                selectedSajjanshakti.add(item);
                                              } else {
                                                selectedSajjanshakti.removeWhere((x) => x.pkid == item.pkid);
                                              }
                                            });
                                            String sajIds = selectedSajjanshakti.map((e) => e.pkid.toString()).join(",");
                                            String anyaIds = selectedAnyaprabhavi.map((e) => e.pkId.toString()).join(",");
                                            log(sajIds);
                                            log("-----------------------------");
                                            log(anyaIds);

                                            onSubmit(sajIds, anyaIds, selectedSajjanshakti, selectedAnyaprabhavi);
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
                                    children: const [
                                      Padding(
                                        padding: EdgeInsets.all(8),
                                        child: Text("✔", style: TextStyle(fontWeight: FontWeight.bold)),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(8),
                                        child: Text("Naam", style: TextStyle(fontWeight: FontWeight.bold)),
                                      ),
                                    ],
                                  ),
                                  ...filteredAnyaprabhavi.map((item) {
                                    return TableRow(
                                      children: [
                                        Center(
                                            child: Checkbox(
                                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                          value: selectedAnyaprabhavi.any((x) => x.pkId == item.pkId),
                                          onChanged: (val) {
                                            set(() {
                                              if (val == true) {
                                                selectedAnyaprabhavi.add(item);
                                              } else {
                                                selectedAnyaprabhavi.removeWhere((x) => x.pkId == item.pkId);
                                              }
                                            });
                                            String sajIds = selectedSajjanshakti.map((e) => e.pkid.toString()).join(",");
                                            String anyaIds = selectedAnyaprabhavi.map((e) => e.pkId.toString()).join(",");

                                            onSubmit(sajIds, anyaIds, selectedSajjanshakti, selectedAnyaprabhavi);
                                            log(sajIds);
                                            log(anyaIds);
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

                            // ...filteredAnyaprabhavi.map((item) {
                            //   return CheckboxListTile(
                            //     dense: true,
                            //     contentPadding: EdgeInsets.zero,
                            //     title: Text(item.name ?? "Unknown"),
                            //     value: selectedAnyaprabhavi.any((x) => x.pkId == item.pkId),
                            //     onChanged: (val) {
                            //       set(() {
                            //         if (val == true) {
                            //           selectedAnyaprabhavi.add(item);
                            //         } else {
                            //           selectedAnyaprabhavi.removeWhere((x) => x.pkId == item.pkId);
                            //         }
                            //       });
                            //       String sajIds = selectedSajjanshakti.map((e) => e.pkid.toString()).join(",");
                            //       String anyaIds = selectedAnyaprabhavi.map((e) => e.pkId.toString()).join(",");
                            //
                            //       onSubmit(sajIds, anyaIds, selectedSajjanshakti, selectedAnyaprabhavi);
                            //       log(sajIds);
                            //       log(anyaIds);
                            //       set(() {});
                            //     },
                            //   );
                            // }),
                            // Expanded(
                            //   child: SingleChildScrollView(
                            //     child: Column(
                            //       crossAxisAlignment: CrossAxisAlignment.start,
                            //       children: [
                            //         /// Sajjan Shakti
                            //         Text(
                            //           Statics.getLabel('SajjanShakti'),
                            //           style: const TextStyle(
                            //             fontWeight: FontWeight.w600,
                            //             fontSize: 16,
                            //             color: Colors.blueGrey,
                            //           ),
                            //         ),
                            //         const Divider(),
                            //
                            //         ...filteredSajjanshakti.map((item) {
                            //           return CheckboxListTile(
                            //             dense: true,
                            //             contentPadding: EdgeInsets.zero,
                            //             title: Text(item.name ?? "Unknown"),
                            //             value: selectedSajjanshakti.any((x) => x.pkid == item.pkid),
                            //             onChanged: (val) {
                            //               set(() {
                            //                 if (val == true) {
                            //                   selectedSajjanshakti.add(item);
                            //                 } else {
                            //                   selectedSajjanshakti.removeWhere((x) => x.pkid == item.pkid);
                            //                 }
                            //               });
                            //               String sajIds = selectedSajjanshakti.map((e) => e.pkid.toString()).join(",");
                            //               String anyaIds = selectedAnyaprabhavi.map((e) => e.pkId.toString()).join(",");
                            //               log(sajIds);
                            //               log("-----------------------------");
                            //               log(anyaIds);
                            //
                            //               onSubmit(sajIds, anyaIds, selectedSajjanshakti, selectedAnyaprabhavi);
                            //               set(() {});
                            //             },
                            //           );
                            //         }),
                            //
                            //         const SizedBox(height: 12),
                            //
                            //         /// Anya Prabhavi Lok
                            //         Text(
                            //           Statics.getLabel('anyaPrabhaviLok'),
                            //           style: const TextStyle(
                            //             fontWeight: FontWeight.w600,
                            //             fontSize: 16,
                            //             color: Colors.blueGrey,
                            //           ),
                            //         ),
                            //         const Divider(),
                            //
                            //         ...filteredAnyaprabhavi.map((item) {
                            //           return CheckboxListTile(
                            //             dense: true,
                            //             contentPadding: EdgeInsets.zero,
                            //             title: Text(item.name ?? "Unknown"),
                            //             value: selectedAnyaprabhavi.any((x) => x.pkId == item.pkId),
                            //             onChanged: (val) {
                            //               set(() {
                            //                 if (val == true) {
                            //                   selectedAnyaprabhavi.add(item);
                            //                 } else {
                            //                   selectedAnyaprabhavi.removeWhere((x) => x.pkId == item.pkId);
                            //                 }
                            //               });
                            //               String sajIds = selectedSajjanshakti.map((e) => e.pkid.toString()).join(",");
                            //               String anyaIds = selectedAnyaprabhavi.map((e) => e.pkId.toString()).join(",");
                            //
                            //               onSubmit(sajIds, anyaIds, selectedSajjanshakti, selectedAnyaprabhavi);
                            //               log(sajIds);
                            //               log(anyaIds);
                            //               set(() {});
                            //             },
                            //           );
                            //         }),
                            //       ],
                            //     ),
                            //   ),
                            // ),
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
                            onPressed: () {
                              String sajIds = selectedSajjanshakti.map((e) => e.pkid.toString()).join(",");
                              String anyaIds = selectedAnyaprabhavi.map((e) => e.pkId.toString()).join(",");

                              onSubmit(sajIds, anyaIds, selectedSajjanshakti, selectedAnyaprabhavi);

                              Navigator.pop(context);
                            },
                            child: Text(
                              Statics.getLabel('Submit'),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.purpleAccent, width: 1.5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          ),
                          onPressed: onAdd,
                          child: Text(
                            Statics.getLabel('addVIshishthaAtithi'),
                            style: const TextStyle(color: Colors.purpleAccent),
                          ),
                        ),
                      ],
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

  List<UpnagarmandallistVijayaDashami> checkboxGraamVastiSelectedItems = [];
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
    List<UpnagarmandallistVijayaDashami> selectedItems = List.from(preselectedItems ?? []);

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
                          "${Statics.getLabel('addVasti')}",
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
                      "${Statics.getLabel('totalVasti')}: ${vastiList.length}",
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
                              title: Text(item.preferedname ?? ""),
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

  VastiCounts? countsShakhaa;

  List<Shakhaalist> checkboxShakhaSelectedItems = [];
  int totalShakhaCount = 0;
  int selectedShakhaCount = 0;
  String averageShakhaCount = "0";
  String? selectedShakhaaPratinidhitwaVastiIds;

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
                        labelText: "Vayogat",
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
                                children: const [
                                  Padding(
                                    padding: EdgeInsets.all(8),
                                    child: Text("✔", style: TextStyle(fontWeight: FontWeight.bold)),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8),
                                    child: Text("Naam", style: TextStyle(fontWeight: FontWeight.bold)),
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

  VastiCounts? countsMilan;
  List<Shakhaalist> checkboxMilanSelectedItems = [];
  int totalMilanCount = 0;
  int selectedMilanCount = 0;
  String averageMilanCount = "0";
  String? selectedMilanPratinidhitwaVastiIds;

  Future<void> showMilanalistPopup(
    BuildContext context, {
    required List<Shakhaalist> milanalist,
    List<Shakhaalist>? preselectedItems,
    required void Function(
      List<Shakhaalist> selectedItems,
      VastiCounts counts,
    ) onSubmit,
  }) async {
    List<Shakhaalist> selectedItems = List.from(preselectedItems ?? []);

    final List<String> vayogatOptions = milanalist.map((e) => e.vayogatname ?? "").where((e) => e.isNotEmpty).toSet().toList();

    String? selectedVayogat;

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            final filteredList = selectedVayogat == null ? milanalist : milanalist.where((e) => e.vayogatname == selectedVayogat).toList();

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
                          Statics.getLabel('selectSaptahikMilan'),
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
                        labelText: "Vayogat",
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
                          "${Statics.getLabel('Total')} : ${filteredList.where((item) => item.frequencyName == "साप्ताहिक मिलन").length}",
                          style: const TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        Text(
                          "${Statics.getLabel('selectedTotal')} : ${selectedItems.where((item) => item.frequencyName == "साप्ताहिक मिलन").length}",
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
                                children: const [
                                  Padding(
                                    padding: EdgeInsets.all(8),
                                    child: Text("✔", style: TextStyle(fontWeight: FontWeight.bold)),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8),
                                    child: Text("Naam", style: TextStyle(fontWeight: FontWeight.bold)),
                                  ),
                                ],
                              ),
                              ...filteredList.where((item) => item.frequencyName == "साप्ताहिक मिलन").map((item) {
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

  VastiCounts? countsSanghaMandali;
  List<Shakhaalist> checkboxSanghaMandaliSelectedItems = [];
  int totalSanghaMandaliCount = 0;
  int selectedSanghaMandaliCount = 0;
  String averageSanghaMandaliCount = "0";
  String? selectedSanghaMandaliPratinidhitwaVastiIds;

  Future<void> showSanghaMandalialistPopup(
    BuildContext context, {
    required List<Shakhaalist> sanghaMandalialist,
    List<Shakhaalist>? preselectedItems,
    required void Function(
      List<Shakhaalist> selectedItems,
      VastiCounts counts,
    ) onSubmit,
  }) async {
    List<Shakhaalist> selectedItems = List.from(preselectedItems ?? []);

    final List<String> vayogatOptions = sanghaMandalialist.map((e) => e.vayogatname ?? "").where((e) => e.isNotEmpty).toSet().toList();

    String? selectedVayogat;

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            final filteredList = selectedVayogat == null ? sanghaMandalialist : sanghaMandalialist.where((e) => e.vayogatname == selectedVayogat).toList();

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
                          Statics.getLabel('selectSanghaMandali'),
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
                        labelText: "Vayogat",
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
                          "${Statics.getLabel('Total')} : ${filteredList.where((item) => item.frequencyName == "मासिक मिलन/संघ मंडळी").length}",
                          style: const TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        Text(
                          "${Statics.getLabel('selectedTotal')} : ${selectedItems.where((item) => item.frequencyName == "मासिक मिलन/संघ मंडळी").length}",
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
                                children: const [
                                  Padding(
                                    padding: EdgeInsets.all(8),
                                    child: Text("✔", style: TextStyle(fontWeight: FontWeight.bold)),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8),
                                    child: Text("Naam", style: TextStyle(fontWeight: FontWeight.bold)),
                                  ),
                                ],
                              ),
                              ...filteredList.where((item) => item.frequencyName == "मासिक मिलन/संघ मंडळी").map((item) {
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

  String? utsavKontyaStaravar = "6";
  List<Map<String, String>> utsavKontyaStaravarList = [
    {
      "2": "${Statics.getLabel('SelectVasti')}",
    },
    {
      "4": "${Statics.getLabel('Mandal')}",
    },
    {
      "13": "${Statics.getLabel('upnagarUpkhanda')}",
    },
    {
      "6": "${Statics.getLabel('NagarKaaryakartaaCount')}",
    }
  ];

  VastiUpDataListModel? vastiUpDataListModel;

  Future<void> getVastiUpDataList() async {
    var inputData = json.encode({
      "AppUserID": Statics.userDetails['userID'],
      "GeoUnitID": selectedUpnagarList.isEmpty ? selctedLevelId.toString() : selectedUpnagarList.join(","),
      "isnagar": int.parse(utsavKontyaStaravar ?? "6"),
    });

    print("_submitForm $inputData");

    vastiUpDataListModel = await Statics.getVastiUpdata(inputData);

    ///
    getFormData();

    ///
    if (vastiUpDataListModel != null) {
      print("Data fetched successfully");
      setState(() {
        print("selectedIdString getVastiUpDataList  --->>>   ${jsonDecode(jsonEncode(vastiUpDataListModel))}");
      });
    } else {
      print("Failed to fetch data");
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${Statics.getLabel('vijayaDashamiUtsav')}",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(VijayadashamiFormReport.routeName);
              },
              icon: Icon(Icons.document_scanner_outlined))
        ],
      ),
      drawer: AppDrawer(),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.purpleAccent),
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              padding: EdgeInsets.symmetric(
                vertical: size.height * 0.01,
                horizontal: size.width * 0.03,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${Statics.getLabel('vijaaydashamiStarQuestion')}",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6),
                    child: DropdownButtonFormField(
                      decoration: InputDecoration(labelText: Statics.getLabel('Level')),
                      isExpanded: true,
                      value: utsavKontyaStaravar == "" ? null : utsavKontyaStaravar,
                      items: utsavKontyaStaravarList.map((bg) => DropdownMenuItem(value: bg.keys.first.toString(), child: Text(bg.values.first.toString()))).toList(),
                      onChanged: (value) async {
                        await clearForm();
                        setState(() {
                          utsavKontyaStaravar = value;
                          _isExpanded = true;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Row(
                  //   children: [
                  //     Expanded(
                  //       child: RadioListTile<String>(
                  //         contentPadding: EdgeInsets.zero,
                  //         materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  //         title: Text("${Statics.getLabel('NagarKaaryakartaaCount')}", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                  //         value: "6",
                  //         groupValue: utsavKontyaStaravar,
                  //         onChanged: (value) async {
                  //           await clearForm();
                  //           setState(() {
                  //             utsavKontyaStaravar = value;
                  //             _isExpanded = true;
                  //           });
                  //         },
                  //       ),
                  //     ),
                  //     Expanded(
                  //       child: RadioListTile<String>(
                  //         contentPadding: EdgeInsets.zero,
                  //         materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  //         title: Text("${Statics.getLabel('upnagarUpkhanda')}", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                  //         value: "13",
                  //         groupValue: utsavKontyaStaravar,
                  //         onChanged: (value) async {
                  //           await clearForm();
                  //           setState(() {
                  //             utsavKontyaStaravar = value;
                  //             _isExpanded = true;
                  //           });
                  //         },
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  // Row(
                  //   children: [
                  //     Expanded(
                  //       child: RadioListTile<String>(
                  //         contentPadding: EdgeInsets.zero,
                  //         materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  //         title: Text("${Statics.getLabel('Mandal')}", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                  //         value: "4",
                  //         groupValue: utsavKontyaStaravar,
                  //         onChanged: (value) async {
                  //           await clearForm();
                  //           setState(() {
                  //             utsavKontyaStaravar = value;
                  //             _isExpanded = true;
                  //           });
                  //           populatelinkedVibhaagDropdownForMandal('');
                  //         },
                  //       ),
                  //     ),
                  //     Expanded(
                  //       child: RadioListTile<String>(
                  //         contentPadding: EdgeInsets.zero,
                  //         materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  //         title: Text("${Statics.getLabel('SelectVasti')}", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                  //         value: "2",
                  //         groupValue: utsavKontyaStaravar,
                  //         onChanged: (value) async {
                  //           await clearForm();
                  //           setState(() {
                  //             utsavKontyaStaravar = value;
                  //             _isExpanded = true;
                  //           });
                  //         },
                  //       ),
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
//=======================================   SEARCH FILTERS ==========================================================================================
            utsavKontyaStaravar == "2"
                ? vastiDropdown()
                : utsavKontyaStaravar == "4"
                    ? mandalDropdown()
                    : utsavKontyaStaravar == "13"
                        ? upnagarDropdown()
                        : nagarDropdown(),
            SizedBox(
              height: 20,
            ),
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
// ================================== 1 QUESTIONS Box ==================================================================================================================================================================================================================================================================================================================================================
            mainContainer(
              "${Statics.getLabel('utsavLable')}  ${Statics.getLabel('Information')}",
              Column(
                children: [
                  yesNoRadioButton(
                    question: "${Statics.getLabel('ProgramNirdharitTime')}",
                    selectedOption: programNirdharitVed ?? 2,
                    onChanged: (value) {
                      setState(() {
                        programNirdharitVed = value;
                      });
                    },
                  ),
                  yesNoRadioButton(
                    question: "${Statics.getLabel('vaiyaktikGitKantashtha')}",
                    selectedOption: vaiyaktikGitKantashtha ?? 2,
                    onChanged: (value) {
                      setState(() {
                        vaiyaktikGitKantashtha = value;
                      });
                    },
                  ),
                  yesNoRadioButton(
                    question: "${Statics.getLabel('programHishobh24Hour')}",
                    selectedOption: programHishobh24Hour ?? 2,
                    onChanged: (value) {
                      setState(() {
                        programHishobh24Hour = value;
                      });
                    },
                  ),
                ],
              ),
            ),
// ================================== 2 QUESTIONS Box ==================================================================================================================================================================================================================================================================================================================================================
            mainContainer(
              "${Statics.getLabel('mukhyaAtithi')}",
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          if (_isSearching == false) {
                            Fluttertoast.showToast(msg: "${Statics.getLabel('NagarSelectionImportant')}");
                            return;
                          }
                          final list = data?.vastisarsajjanshakti ?? [];
                          final preselected = list.any((e) => e.pkid == selectedMukhyaAtithi) ? list.firstWhere((e) => e.pkid == selectedMukhyaAtithi) : null;

                          showMukhyaAtithiSelectionPopup(
                            context,
                            vastisarsajjanshaktiList: data?.vastisarsajjanshakti ?? [],
                            vastisanyaprabhaviList: data?.vastisanyaprabhavi ?? [],
                            preselectedItem: preselected,
                            preselectedType: selectedType,
                            onSubmit: (id, type, selectedItem) {
                              setState(() {
                                selectedType = type;
                                if (type == "sarsajjanshakti") {
                                  selectedPerson = selectedItem as Vastisarsajjanshakti;
                                  selectedPrabhavi = null;
                                  selectedMukhyaAtithi = selectedPerson?.pkid;
                                } else {
                                  selectedPrabhavi = selectedItem as Vastisanyaprabhavi;
                                  selectedPerson = null;
                                  selectedMukhyaAtithi = selectedPrabhavi?.pkId;
                                }
                              });
                            },
                            onAdd: () {
                              Navigator.of(context).pushReplacementNamed(
                                AddMukhyaAtithi.routeName,
                                arguments: {'linkedNagar': _linkedNagar, 'selectedLevelId': _linkedNagarValue},
                              ).then((value) => searchVijayaDashami());
                            },
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          width: 130,
                          height: 35,
                          decoration: BoxDecoration(border: Border.all(color: Colors.purpleAccent.shade100), borderRadius: BorderRadius.circular(15)),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(width: 5),
                                Text(
                                  "${Statics.getLabel('addMukhyaAtithi')}",
                                  style: const TextStyle(color: Colors.purpleAccent, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
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
                        onTap: () async {
                          if (_isSearching == false) {
                            Fluttertoast.showToast(msg: "${Statics.getLabel('NagarSelectionImportant')}");
                            return;
                          }
                          await showVisheshAtithiSelectionPopup(context,
                              vastisarsajjanshaktiList: data?.vastisarsajjanshakti ?? [],
                              vastisanyaprabhaviList: data?.vastisanyaprabhavi ?? [],
                              excludedItem: null,
                              sajjanshaktiIds: selectedSajjanshaktiItemsIds,
                              anyaprabhaviIds: selectedAnyaprabhaviItemsIds,
                              selectedAnyaprabhaviItems: selectedAnyaprabhaviItems,
                              selectedSajjanshaktiItems: selectedSajjanshaktiItems, onSubmit: (sajIds, anyaIds, sajList, anyaList) {
                            print("onSubmit Called >>>>>>>>>>>>>>>>>>>>>>>>>>>");
                            setState(() {
                              selectedSajjanshaktiItemsIds = sajIds;
                              selectedAnyaprabhaviItemsIds = anyaIds;
                              selectedSajjanshaktiItems = sajList;
                              selectedAnyaprabhaviItems = anyaList;
                            });

                            print(selectedSajjanshaktiItemsIds);
                            print(selectedAnyaprabhaviItemsIds);
                            // print(selectedSajjanshaktiItems);
                            // print(selectedAnyaprabhaviItems);
                          }, onAdd: () {
                            submitForm(showLoader: false);
                            Navigator.of(context)
                                .pushReplacementNamed(
                                  AddVishisthaAtithi.routeName,
                                  arguments: _linkedNagar,
                                )
                                .then((value) => searchVijayaDashami());
                          }, selectedMukhyaAtithi: selectedMukhyaAtithi, selectedType: selectedType);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          width: 150,
                          height: 35,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.purpleAccent.shade100),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Center(
                            child: Text(
                              "${Statics.getLabel('addVIshishthaAtithi')}",
                              style: TextStyle(
                                color: Colors.purpleAccent,
                                fontWeight: FontWeight.bold,
                              ),
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
              "${Statics.getLabel('karyakramVakta')}",
              Column(
                children: [
                  textControllerField2(
                    name: Statics.getLabel("karyakramVaktaName"),
                    controller: txtVaktaNameController,
                    keyboardType: TextInputType.name,
                  ),
                  const SizedBox(height: 12),
                  textControllerField2(
                    name: Statics.getLabel("karyakramVaktaTask"),
                    controller: txtVaktaTaskController,
                    keyboardType: TextInputType.name,
                  ),
                ],
              ),
            ),
// ================================== 5 QUESTIONS Box ==================================================================================================================================================================================================================================================================================================================================================
            mainContainer(
              "${Statics.getLabel('swayamsewakUpastithi')}",
              Column(
                children: [
                  Scrollbar(
                    controller: _scrollController,
                    interactive: true,
                    thumbVisibility: true,
                    radius: Radius.circular(8),
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      scrollDirection: Axis.horizontal, // 👉 Horizontal scroll
                      child: Container(
                        width: 450,
                        padding: const EdgeInsets.all(8),
                        child: Table(
                          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                          border: TableBorder.all(color: Colors.black),
                          columnWidths: const {
                            0: FlexColumnWidth(3),
                            1: FlexColumnWidth(2),
                            2: FlexColumnWidth(1.5),
                            3: FlexColumnWidth(2.5),
                            4: FlexColumnWidth(2),
                          },
                          children: [
                            // Header Row
                            TableRow(
                              decoration: BoxDecoration(color: Colors.purpleAccent.shade100),
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("${Statics.getLabel('Vayogat')}", style: const TextStyle(fontSize: 15.6, fontWeight: FontWeight.bold, color: Colors.white)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("${Statics.getLabel('patSankhyaa')}", style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
                                ),
                                Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text("${Statics.getLabel('Total')}", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("${Statics.getLabel('ganveshatPresentCount')}", style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("${Statics.getLabel('otherSwayamsewakPresentCount')}", style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
                                ),
                              ],
                            ),

                            // Data Rows
                            TableRow(
                              // decoration: BoxDecoration(color: Colors.grey.shade300),
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("${Statics.getLabel('Shishu')}/${Statics.getLabel('Baal')}", style: TextStyle(fontSize: 14.5)),
                                ),
                                _numberField(patShishuBaalCtrl, textBoxColor: Colors.grey.shade300, containerColor: Colors.grey.shade300),
                                Container(
                                  padding: const EdgeInsets.symmetric(vertical: 14.0),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(color: Colors.grey.shade300),
                                  child: Text(_rowTotal(ganShishuBaalCtrl.text, anyaShishuBaalCtrl.text).toString()),
                                ),
                                _numberField(ganShishuBaalCtrl, limitController: patShishuBaalCtrl, otherController: anyaShishuBaalCtrl),
                                _numberField(anyaShishuBaalCtrl, limitController: patShishuBaalCtrl, otherController: ganShishuBaalCtrl),
                              ],
                            ),

                            TableRow(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2),
                                  child: Text("${Statics.getLabel('MahaavidyaalayeenTarunLabel')}", style: TextStyle(fontSize: 14.5)),
                                ),
                                _numberField(patMahavidyaCtrl, padding: const EdgeInsets.symmetric(vertical: 12.0), textBoxColor: Colors.grey.shade300, containerColor: Colors.grey.shade300),
                                Container(
                                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(color: Colors.grey.shade300),
                                  child: Text(_rowTotal(ganMahavidyaCtrl.text, anyaMahavidyaCtrl.text).toString()),
                                ),
                                _numberField(ganMahavidyaCtrl, limitController: patMahavidyaCtrl, otherController: anyaMahavidyaCtrl),
                                _numberField(anyaMahavidyaCtrl, limitController: patMahavidyaCtrl, otherController: ganMahavidyaCtrl),
                              ],
                            ),

                            TableRow(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("${Statics.getLabel('TarunVyavasaayee')}", style: TextStyle(fontSize: 14.5)),
                                ),
                                _numberField(patTarunVyavCtrl, textBoxColor: Colors.grey.shade300, containerColor: Colors.grey.shade300),
                                Container(
                                  padding: const EdgeInsets.symmetric(vertical: 14.0),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(color: Colors.grey.shade300),
                                  child: Text(_rowTotal(ganTarunVyavCtrl.text, anyaTarunVyavCtrl.text).toString()),
                                ),
                                _numberField(ganTarunVyavCtrl, limitController: patTarunVyavCtrl, otherController: anyaTarunVyavCtrl),
                                _numberField(anyaTarunVyavCtrl, limitController: patTarunVyavCtrl, otherController: ganTarunVyavCtrl),
                              ],
                            ),

                            TableRow(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("${Statics.getLabel('ProudhaVyavasaayeeLabel')}", style: TextStyle(fontSize: 14.5)),
                                ),
                                _numberField(patProudhVyavCtrl, textBoxColor: Colors.grey.shade300, containerColor: Colors.grey.shade300),
                                Container(
                                  padding: const EdgeInsets.symmetric(vertical: 14.0),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(color: Colors.grey.shade300),
                                  child: Text(_rowTotal(ganProudhVyavCtrl.text, anyaProudhVyavCtrl.text).toString()),
                                ),
                                _numberField(ganProudhVyavCtrl, limitController: patProudhVyavCtrl, otherController: anyaProudhVyavCtrl),
                                _numberField(anyaProudhVyavCtrl, limitController: patProudhVyavCtrl, otherController: ganProudhVyavCtrl),
                              ],
                            ),

                            // Total Row
                            TableRow(
                              decoration: const BoxDecoration(color: Colors.amberAccent),
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text("${Statics.getLabel('Total')}", style: TextStyle(fontSize: 14.7, fontWeight: FontWeight.w900)),
                                ),
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(_getColumnTotal([patShishuBaalCtrl, patMahavidyaCtrl, patTarunVyavCtrl, patProudhVyavCtrl]).toString(), style: TextStyle(fontWeight: FontWeight.w900)),
                                  ),
                                ),
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                        (_getColumnTotal([ganShishuBaalCtrl, ganMahavidyaCtrl, ganTarunVyavCtrl, ganProudhVyavCtrl]) +
                                                _getColumnTotal([anyaShishuBaalCtrl, anyaMahavidyaCtrl, anyaTarunVyavCtrl, anyaProudhVyavCtrl]))
                                            .toString(),
                                        style: TextStyle(fontWeight: FontWeight.w900)),
                                  ),
                                ),
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(_getColumnTotal([ganShishuBaalCtrl, ganMahavidyaCtrl, ganTarunVyavCtrl, ganProudhVyavCtrl]).toString(), style: TextStyle(fontWeight: FontWeight.w900)),
                                  ),
                                ),
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child:
                                        Text(_getColumnTotal([anyaShishuBaalCtrl, anyaMahavidyaCtrl, anyaTarunVyavCtrl, anyaProudhVyavCtrl]).toString(), style: TextStyle(fontWeight: FontWeight.w900)),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
// ================================== 6 QUESTIONS Box ==================================================================================================================================================================================================================================================================================================================================================
            mainContainer(
              "${Statics.getLabel('bhougolikPratinidhitwa')}",
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          if (_isSearching == false) {
                            Fluttertoast.showToast(
                              msg: "${Statics.getLabel('NagarSelectionImportant')}",
                            );
                            return;
                          }
                          showGraamVastiMandalUpnagarPopup(
                            context,
                            vastiList: data?.vastimandallist ?? [],
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
                              "${Statics.getLabel('addVasti')}",
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
                    txtString: "${Statics.getLabel('Total')} ${Statics.getLabel('Vasti')} / ${Statics.getLabel('Mandal')}",
                    value: (data?.vastimandallist ?? []).length.toString(),
                  ),
                  SingleColumnRow(
                    txtString: "${Statics.getLabel('Vasti')} ${Statics.getLabel('pratinidhitva')}  ",
                    value: selectedVastiCount.toString(),
                  ),
                  SingleColumnRow(
                    rowColor: Colors.grey.shade300,
                    txtString: "${Statics.getLabel('average')} ${Statics.getLabel('pratinidhitva')} ",
                    value: "${(data?.vastimandallist ?? []).length > 0 ? ((selectedVastiCount! / (data?.vastimandallist ?? []).length) * 100).toStringAsFixed(0) : 0} %",
                  )
                ],
              ),
            ),
// ================================== 7 QUESTIONS Box ==================================================================================================================================================================================================================================================================================================================================================
            mainContainer(
              "${Statics.getLabel('shakhaMilanPratinidhitwa')}",
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          if (_isSearching == false) {
                            Fluttertoast.showToast(
                              msg: "${Statics.getLabel('NagarSelectionImportant')}",
                            );
                            return;
                          }
                          showShakhaalistPopup(
                            context,
                            shakhaalist: data?.shakhaalist ?? [],
                            preselectedItems: checkboxShakhaSelectedItems,
                            onSubmit: (selectedItems, counts) {
                              setState(() {
                                checkboxShakhaSelectedItems = selectedItems;
                                countsShakhaa = counts; // model me store

                                // ✅ Total shakha count
                                totalShakhaCount = (data?.shakhaalist ?? []).where((item) => item.frequencyName == "शाखा").length;

                                // ✅ Selected shakha count
                                selectedShakhaCount = selectedItems.where((item) => item.frequencyName == "शाखा").length;
                                selectedShakhaaPratinidhitwaVastiIds = selectedItems.map((e) => e.geoUnitID.toString()).join(",");
                                // ✅ Average shakha count (percentage)
                                if (totalShakhaCount > 0) {
                                  averageShakhaCount = ((selectedShakhaCount / totalShakhaCount) * 100).round().toString();
                                } else {
                                  averageShakhaCount = "0";
                                }
                              });
                            },
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          width: 120,
                          height: 35,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.purpleAccent.shade100),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(width: 5),
                                Text(
                                  "${Statics.getLabel('selectshakhaa')}",
                                  style: const TextStyle(
                                    color: Colors.purpleAccent,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // ✅ Results after submit
                  SingleColumnRow(
                    txtString: "${Statics.getLabel('Total')} ${Statics.getLabel('Shaakhaa')} ",
                    value: "${(data?.shakhaalist ?? []).where((item) => item.frequencyName == "शाखा").length}",
                  ),
                  SingleColumnRow(
                    txtString: " ${Statics.getLabel('Shaakhaa')} ${Statics.getLabel('pratinidhitva')}",
                    value: "$selectedShakhaCount",
                  ),
                  SingleColumnRow(
                    rowColor: Colors.grey.shade300,
                    txtString: " ${Statics.getLabel('Shaakhaa')} ${Statics.getLabel('average')} ${Statics.getLabel('pratinidhitva')} ",
                    value: ((data?.shakhaalist ?? []).where((item) => item.frequencyName == "शाखा").length > 0
                            ? ((selectedShakhaCount / (data?.shakhaalist ?? []).where((item) => item.frequencyName == "शाखा").length) * 100).round().toString()
                            : "0") +
                        " %",
                  ),
                ],
              ),
            ),
// ================================== 8 QUESTIONS Box ==================================================================================================================================================================================================================================================================================================================================================
            mainContainer(
              "${Statics.getLabel('MilanPratinidhitwa')}",
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          if (_isSearching == false) {
                            Fluttertoast.showToast(
                              msg: "${Statics.getLabel('NagarSelectionImportant')}",
                            );
                            return;
                          }
                          showMilanalistPopup(
                            context,
                            milanalist: data?.shakhaalist ?? [],
                            preselectedItems: checkboxMilanSelectedItems,
                            onSubmit: (selectedItems, counts) {
                              setState(() {
                                selectedMilanPratinidhitwaVastiIds = selectedItems.map((e) => e.geoUnitID.toString()).join(",");
                                checkboxMilanSelectedItems = selectedItems;
                                countsMilan = counts; // model me store

                                // ✅ Total shakha count
                                totalMilanCount = (data?.shakhaalist ?? []).where((item) => item.frequencyName == "साप्ताहिक मिलन").length;

                                // ✅ Selected shakha count
                                selectedMilanCount = selectedItems.where((item) => item.frequencyName == "साप्ताहिक मिलन").length;

                                // ✅ Average shakha count (percentage)
                                if (totalMilanCount > 0) {
                                  averageMilanCount = ((selectedMilanCount / totalMilanCount) * 100).round().toString();
                                } else {
                                  averageMilanCount = "0";
                                }
                              });
                            },
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          width: 160,
                          height: 35,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.purpleAccent.shade100),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "${Statics.getLabel('selectSaptahikMilan')}",
                                  style: const TextStyle(
                                    color: Colors.purpleAccent,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // ✅ Results after submit
                  SingleColumnRow(
                    txtString: "${Statics.getLabel('Total')} ${Statics.getLabel('SaaptaahikMilan')} ",
                    value: "${(data?.shakhaalist ?? []).where((item) => item.frequencyName == "साप्ताहिक मिलन").length}",
                  ),
                  SingleColumnRow(
                    txtString: " ${Statics.getLabel('SaaptaahikMilan')} ${Statics.getLabel('pratinidhitva')} ",
                    value: "$selectedMilanCount",
                  ),
                  SingleColumnRow(
                    rowColor: Colors.grey.shade300,
                    txtString: " ${Statics.getLabel('SaaptaahikMilan')} ${Statics.getLabel('average')} ${Statics.getLabel('pratinidhitva')} ",
                    value: ((data?.shakhaalist ?? []).where((item) => item.frequencyName == "साप्ताहिक मिलन").length > 0
                            ? ((selectedMilanCount / ((data?.shakhaalist ?? []).where((item) => item.frequencyName == "साप्ताहिक मिलन").length)) * 100).round().toString()
                            : "0") +
                        " %",
                  ),
                ],
              ),
            ),
// ================================== 9 QUESTIONS Box ==================================================================================================================================================================================================================================================================================================================================================
            mainContainer(
              "${Statics.getLabel('milanMandali')} ${Statics.getLabel('pratinidhitva')}",
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          if (_isSearching == false) {
                            Fluttertoast.showToast(
                              msg: "${Statics.getLabel('NagarSelectionImportant')}",
                            );
                            return;
                          }
                          showSanghaMandalialistPopup(
                            context,
                            sanghaMandalialist: data?.shakhaalist ?? [],
                            preselectedItems: checkboxSanghaMandaliSelectedItems,
                            onSubmit: (selectedItems, counts) {
                              setState(() {
                                selectedSanghaMandaliPratinidhitwaVastiIds = selectedItems.map((e) => e.geoUnitID.toString()).join(",");
                                checkboxSanghaMandaliSelectedItems = selectedItems;
                                countsSanghaMandali = counts; // model me store

                                // ✅ Total shakha count
                                totalSanghaMandaliCount = (data?.shakhaalist ?? []).where((item) => item.frequencyName == "मासिक मिलन/संघ मंडळी").length;

                                // ✅ Selected shakha count
                                selectedSanghaMandaliCount = selectedItems.where((item) => item.frequencyName == "मासिक मिलन/संघ मंडळी").length;

                                // ✅ Average shakha count (percentage)
                                if (totalSanghaMandaliCount > 0) {
                                  averageSanghaMandaliCount = ((selectedSanghaMandaliCount / totalSanghaMandaliCount) * 100).round().toString();
                                } else {
                                  averageSanghaMandaliCount = "0";
                                }
                              });
                            },
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 14),
                          // width: 200,
                          height: 35,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.purpleAccent.shade100),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Center(
                            child: Text(
                              "${Statics.getLabel('selectSanghaMandali')}",
                              style: const TextStyle(
                                color: Colors.purpleAccent,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // ✅ Results after submit
                  SingleColumnRow(
                    txtString: "${Statics.getLabel('Total')} ${Statics.getLabel('milanMandali')} ",
                    value: "${(data?.shakhaalist ?? []).where((item) => item.frequencyName == "मासिक मिलन/संघ मंडळी").length}",
                  ),
                  SingleColumnRow(
                    txtString: " ${Statics.getLabel('milanMandali')} ${Statics.getLabel('pratinidhitva')} ",
                    value: "$selectedSanghaMandaliCount",
                  ),
                  SingleColumnRow(
                    rowColor: Colors.grey.shade300,
                    txtString: "${Statics.getLabel('milanMandali')}  ${Statics.getLabel('average')}  ${Statics.getLabel('pratinidhitva')} ",
                    value: ((data?.shakhaalist ?? []).where((item) => item.frequencyName == "मासिक मिलन/संघ मंडळी").length > 0
                            ? ((selectedSanghaMandaliCount / ((data?.shakhaalist ?? []).where((item) => item.frequencyName == "मासिक मिलन/संघ मंडळी").length)) * 100).round().toString()
                            : "0") +
                        " %",
                  ),
                ],
              ),
            ),
// ================================== 10 QUESTIONS Box ==================================================================================================================================================================================================================================================================================================================================================
            mainContainer(
              "${Statics.getLabel('Total')} ${Statics.getLabel('pratinidhitva')}",
              Column(
                children: [
                  // ✅ Total
                  SingleColumnRow(
                    txtString: "${Statics.getLabel('Total')} ",
                    value:
                        "${((data?.shakhaalist ?? []).where((item) => item.frequencyName == "शाखा").length) + ((data?.shakhaalist ?? []).where((item) => item.frequencyName == "साप्ताहिक मिलन").length) + ((data?.shakhaalist ?? []).where((item) => item.frequencyName == "मासिक मिलन/संघ मंडळी").length)}",
                  ),

                  // ✅ Selected
                  SingleColumnRow(
                    txtString: "${Statics.getLabel('Total')}  ${Statics.getLabel('pratinidhitva')}",
                    value: "${selectedShakhaCount + selectedMilanCount + selectedSanghaMandaliCount}",
                  ),

                  // ✅ Average (calculated from above two)
                  SingleColumnRow(
                    rowColor: Colors.grey.shade300,
                    txtString: "${Statics.getLabel('Total')}  ${Statics.getLabel('average')}  ${Statics.getLabel('pratinidhitva')} ",
                    value: (() {
                      final total = ((data?.shakhaalist ?? []).where((item) => item.frequencyName == "शाखा").length) +
                          ((data?.shakhaalist ?? []).where((item) => item.frequencyName == "साप्ताहिक मिलन").length) +
                          ((data?.shakhaalist ?? []).where((item) => item.frequencyName == "मासिक मिलन/संघ मंडळी").length);
                      final selected = selectedShakhaCount + selectedMilanCount + selectedSanghaMandaliCount;

                      if (total == 0) return "0 %";
                      final avg = ((selected / total) * 100).round();
                      return "$avg %";
                    })(),
                  ),
                ],
              ),
            ),
// ================================== 11 QUESTIONS Box ==================================================================================================================================================================================================================================================================================================================================================
            mainContainer(
              "${Statics.getLabel('anyaUpstithMahiti')}",
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
                  SingleColumnRow(
                    txtString: "${Statics.getLabel('presentTotalMaleFemale')} ",
                    value: total.toString(),
                  ),
                  //
                  SingleColumnRow(
                    txtString: "${Statics.getLabel('presentGanveshatTotal')} ",
                    value: _getColumnTotal([ganShishuBaalCtrl, ganMahavidyaCtrl, ganTarunVyavCtrl, ganProudhVyavCtrl]).toString(),
                  ),
                  //
                  SingleColumnRow(
                    txtString: "${Statics.getLabel('otherSwayamsewakPresentCount')} ",
                    value: _getColumnTotal([anyaShishuBaalCtrl, anyaMahavidyaCtrl, anyaTarunVyavCtrl, anyaProudhVyavCtrl]).toString(),
                  ),
                  //
                  // SingleColumnRow(
                  //   txtString: "${Statics.getLabel('presentSamajik')} ",
                  //   value: "${totalShakhaCount + totalMilanCount + totalSanghaMandaliCount}",
                  // ),
                  // ✅ Total
                  SingleColumnRow(
                    rowColor: Colors.grey.shade300,
                    txtString: "${Statics.getLabel('presentTotal')} ",
                    value: "${total + _getColumnTotal([ganShishuBaalCtrl, ganMahavidyaCtrl, ganTarunVyavCtrl, ganProudhVyavCtrl]) + _getColumnTotal([
                              anyaShishuBaalCtrl,
                              anyaMahavidyaCtrl,
                              anyaTarunVyavCtrl,
                              anyaProudhVyavCtrl
                            ])}",
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
              "${Statics.getLabel('sanchalan')}",
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  yesNoRadioButton(
                    question: "${Statics.getLabel('sanchalanZaleKa')}",
                    selectedOption: sanchalanZaleKa ?? 2,
                    onChanged: (value) {
                      setState(() {
                        sanchalanZaleKa = value;
                      });
                    },
                  ),
                  yesNoRadioButton(
                    question: Statics.getLabel('sanchalanSadandaZalKa'),
                    selectedOption: sanchalanSadandaZalKa ?? 2,
                    onChanged: (value) {
                      setState(() {
                        sanchalanSadandaZalKa = value;
                      });
                    },
                  ),
                  yesNoRadioButton(
                    question: Statics.getLabel('sanchalanGhoshVadanZalKa'),
                    selectedOption: sanchalanGhoshVadanZalKa ?? 2,
                    onChanged: (value) {
                      setState(() {
                        sanchalanGhoshVadanZalKa = value;
                      });
                    },
                  ),
                ],
              ),
            ),
// ================================== 13 QUESTIONS Box =======================================================================
            mainContainer(
              "${Statics.getLabel('moreInfo')}",
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  filePickerField1(
                    question: "${Statics.getLabel('AddUtsavFiles')}",
                    subtitle: "${Statics.getLabel('AddUtsavFilesSubtitle')}",
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
                    question: "${Statics.getLabel('AddAdvUtsavFiles')}",
                    subtitle: "${Statics.getLabel('AddAdvUtsavFilesSubtitle')}",
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
            Container(
              child: MaterialButton(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                color: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                onPressed: () {
                  if (_isSearching == false) {
                    Fluttertoast.showToast(msg: "${Statics.getLabel('NagarSelectionImportant')}");
                    return;
                  }
                  submitForm();
                },
                child: Text(
                  Statics.getLabel('Submit'),
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget vastiDropdown() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.purpleAccent),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      padding: EdgeInsets.symmetric(
        // vertical: size.height * 0.01,
        horizontal: MediaQuery.of(context).size.width * 0.02,
      ),
      child: ExpansionPanelList(
        expansionCallback: (int index, bool isExpanded) {
          setState(() {
            _isExpanded = isExpanded;
          });
        },
        elevation: 0,
        dividerColor: Colors.transparent,
        children: [
          ExpansionPanel(
            headerBuilder: (BuildContext context, bool isExpanded) {
              return ListTile(
                title: Text(
                  Statics.getLabel('selectStar'),
                  style: TextStyle(color: Colors.purpleAccent, fontWeight: FontWeight.bold),
                ),
                trailing: IconButton(
                    onPressed: () {
                      clearForm();
                    },
                    icon: Icon(Icons.refresh),
                    color: Colors.purpleAccent),
                iconColor: Colors.purpleAccent,
              );
            },
            body: Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  if (_linkedMahaanagar != null)
                    DropdownButtonFormField(
                      decoration: InputDecoration(labelText: "${Statics.getLabel('mahaanagar')}"),
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
                          _linkedMahaanagarValue = value;
                          _linkedVibhaagValue = null;
                          _linkedBhaagValue = null;
                          _linkedNagarValue = null;
                          populatelinkedVibhaagDropdown(value!);
                          mahanagarId = value;
                          selctedLevelId = value;
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
                      decoration: InputDecoration(labelText: "${Statics.getLabel('vibhaag')}"),
                      isExpanded: true,
                      value: _linkedVibhaagValue == "" ? null : _linkedVibhaagValue,
                      items: _linkedVibhaag!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                      onChanged: (value) {
                        final selectedItem = _linkedVibhaag!.firstWhere((bg) => bg.geoUnitID.toString() == value);
                        print(value);
                        setState(() {
                          _linkedVibhaagValue = value;
                          populatelinkedBhaagDropdown(value!);
                          vibhagId = value;
                          _linkedBhaagValue = _linkedNagarValue = null;
                          _linkedBhaag = _linkedNagar = null;
                          selctedLevelId = value;
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
                      onChanged: (value) {
                        final selectedItem = _linkedBhaag!.firstWhere((bg) => bg.geoUnitID.toString() == value);
                        setState(() {
                          _linkedBhaagValue = value;
                          populatelinkedNagarDropdown(value, null);
                          selctedLevelId = value;
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
                      decoration: InputDecoration(labelText: "${Statics.getLabel('NagarShahari')}"),
                      isExpanded: true,
                      value: _linkedNagarValue == "" ? null : _linkedNagarValue,
                      items: _linkedNagar!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                      onChanged: (value) {
                        final selectedItem = _linkedNagar!.firstWhere((bg) => bg.geoUnitID.toString() == value);
                        setState(() {
                          _linkedNagarValue = value;
                          populatelinkedVastiDropdown(value!);
                          selctedLevelId = value;
                          selctedLevelIdForVastiDropdown = value;
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
                  if (_linkedvasti != null && _linkedvasti!.length > 0)
                    DropdownButtonFormField(
                      decoration: InputDecoration(labelText: "${Statics.getLabel('vastiLabel')}"),
                      isExpanded: true,
                      value: _linkedvastiValue == "" ? null : _linkedvastiValue,
                      items: _linkedvasti!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                      onChanged: (value) {
                        final selectedItem = _linkedvasti!.firstWhere((bg) => bg.geoUnitID.toString() == value);
                        setState(() {
                          _linkedvastiValue = value;
                          selctedLevelId = value;
                          selctedLevelName = selectedItem.name ?? "";
                          selctedLevel = 'Vasti';
                        });
                        setState(() {});
                        print("Selected Id: $value");
                        print("Selected Level Name: ${selectedItem.name}");
                      },
                    ),
                  if (_linkedvasti != null && _linkedvasti!.length > 0)
                    SizedBox(
                      height: 10,
                    ),
                  if (selctedLevel == "Vasti")
                    Align(
                      alignment: Alignment.center,
                      child: ElevatedButton(
                        style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.purpleAccent)),
                        onPressed: () {
                          searchVijayaDashami();
                          setState(() {
                            _isExpanded = false;
                            isVastiSearch = true;
                            _isSearching = true;
                          });
                        },
                        child: Text("${Statics.getLabel('Filters')}", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    )
                ],
              ),
            ),
            isExpanded: _isExpanded,
          ),
        ],
      ),
    );
  }

  Widget mandalDropdown() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.purpleAccent),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      padding: EdgeInsets.symmetric(
        // vertical: size.height * 0.01,
        horizontal: MediaQuery.of(context).size.width * 0.02,
      ),
      child: ExpansionPanelList(
        expansionCallback: (int index, bool isExpanded) {
          setState(() {
            _isExpanded = isExpanded;
          });
        },
        elevation: 0,
        dividerColor: Colors.transparent,
        children: [
          ExpansionPanel(
            headerBuilder: (BuildContext context, bool isExpanded) {
              return ListTile(
                title: Text(
                  Statics.getLabel('selectStar'),
                  style: TextStyle(color: Colors.purpleAccent, fontWeight: FontWeight.bold),
                ),
                trailing: IconButton(
                    onPressed: () async {
                      await clearForm();
                      populatelinkedVibhaagDropdownForMandal('');
                    },
                    icon: Icon(Icons.refresh),
                    color: Colors.purpleAccent),
                iconColor: Colors.purpleAccent,
              );
            },
            body: Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  if (_linkedVibhaag != null)
                    DropdownButtonFormField(
                      decoration: InputDecoration(labelText: Statics.getLabel('vibhaag')),
                      isExpanded: true,
                      value: _linkedVibhaagValue == "" ? null : _linkedVibhaagValue,
                      items: _linkedVibhaag!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                      onChanged: (value) {
                        final selectedItem = _linkedVibhaag!.firstWhere((bg) => bg.geoUnitID.toString() == value);
                        print(value);
                        setState(() {
                          _linkedVibhaagValue = value;
                          populatelinkedBhaagDropdownForMandal(value!);
                          vibhagId = value;
                          _linkedBhaagValue = _linkedNagarValue = null;
                          _linkedBhaag = _linkedNagar = _linkedmandal = null;
                          selctedLevelId = value;
                          selctedLevelName = selectedItem.name ?? "";
                          selctedLevel = 'vibhag';
                          _linkedmandalValue = null;
                        });
                        print("Selected Id: $value");
                        print("Selected Level Name: ${selectedItem.name}");
                      },
                    ),
                  SizedBox(height: 10),
                  if (_linkedBhaag != null)
                    DropdownButtonFormField(
                      decoration: InputDecoration(labelText: "${Statics.getLabel('Bhaag')}"),
                      isExpanded: true,
                      value: _linkedBhaagValue == "" ? null : _linkedBhaagValue,
                      items: _linkedBhaag!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                      onChanged: (value) {
                        final selectedItem = _linkedBhaag!.firstWhere((bg) => bg.geoUnitID.toString() == value);
                        setState(() {
                          _linkedBhaagValue = value;
                          populatelinkedNagarDropdownForMandal(value, null);
                          selctedLevelId = value;
                          selctedLevelName = selectedItem.name ?? "";
                          selctedLevel = 'bhag';
                          _linkedmandalValue = null;
                        });
                        print("Selected Id: $value");
                        print("Selected Level Name: ${selectedItem.name}");
                      },
                    ),
                  SizedBox(height: 10),
                  if (_linkedNagar != null && _linkedNagar!.length > 0)
                    DropdownButtonFormField(
                      decoration: InputDecoration(labelText: "${Statics.getLabel('taalukaa')}"),
                      isExpanded: true,
                      value: _linkedNagarValue == "" ? null : _linkedNagarValue,
                      items: _linkedNagar!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                      onChanged: (value) {
                        final selectedItem = _linkedNagar!.firstWhere((bg) => bg.geoUnitID.toString() == value);
                        setState(() {
                          _linkedNagarValue = value;
                          populatelinkedMandalDropdownForMandal(value!);
                          selctedLevelId = value;
                          selctedLevelIdForMandalDropdown = value;
                          selctedLevelName = selectedItem.name ?? "";
                          selctedLevel = 'nagar';
                          _linkedmandalValue = null;
                        });
                        print("Selected Id: $value");
                        print("Selected Level Name: ${selectedItem.name}");
                      },
                    ),
                  if (_linkedNagar != null && _linkedNagar!.length > 0) SizedBox(height: 10),
                  if (_linkedmandal != null && _linkedmandal!.length > 0)
                    DropdownButtonFormField(
                      decoration: InputDecoration(labelText: "${Statics.getLabel('Mandal')}"),
                      isExpanded: true,
                      value: _linkedmandalValue == "" ? null : _linkedmandalValue,
                      items: _linkedmandal!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                      onChanged: (value) {
                        final selectedItem = _linkedmandal!.firstWhere((bg) => bg.geoUnitID.toString() == value);
                        setState(() {
                          _linkedmandalValue = value;
                          selctedLevelId = value;
                          selctedLevelName = selectedItem.name ?? "";
                          selctedLevel = 'Mandal';
                        });
                        setState(() {});
                        print("Selected Id: $value");
                        print("Selected Level Name: ${selectedItem.name}");
                      },
                    ),
                  if (_linkedmandal != null && _linkedmandal!.length > 0) SizedBox(height: 10),
                  if (selctedLevel == 'Mandal')
                    Align(
                      alignment: Alignment.center,
                      child: ElevatedButton(
                        style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.purpleAccent)),
                        onPressed: () {
                          searchVijayaDashami();
                          setState(() {
                            _isExpanded = false;
                            isVastiSearch = true;
                            _isSearching = true;
                          });
                        },
                        child: Text("${Statics.getLabel('Filters')}", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    )
                ],
              ),
            ),
            isExpanded: _isExpanded,
          ),
        ],
      ),
    );
  }

  Widget upnagarDropdown() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.purpleAccent),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      padding: EdgeInsets.symmetric(
        // vertical: size.height * 0.01,
        horizontal: MediaQuery.of(context).size.width * 0.02,
      ),
      child: ExpansionPanelList(
        elevation: 0,
        dividerColor: Colors.transparent,
        expansionCallback: (int index, bool isExpanded) {
          setState(() {
            _isExpanded = isExpanded;
          });
        },
        children: [
          ExpansionPanel(
            headerBuilder: (BuildContext context, bool isExpanded) {
              return ListTile(
                title: Text(
                  Statics.getLabel('selectStar'),
                  style: TextStyle(color: Colors.purpleAccent, fontWeight: FontWeight.bold),
                ),
                trailing: IconButton(
                    onPressed: () {
                      clearForm();
                    },
                    icon: Icon(Icons.refresh),
                    color: Colors.purpleAccent),
                iconColor: Colors.purpleAccent,
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
                      items: _linkedMahaanagar!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                      onChanged: (value) {
                        final selectedItem = _linkedMahaanagar!.firstWhere((bg) => bg.geoUnitID.toString() == value);
                        print(value);
                        setState(() {
                          _linkedMahaanagarValue = value;
                          _linkedVibhaagValue = null;
                          _linkedBhaagValue = null;
                          _linkedShaharValue = null;
                          _linkedNagarValue = null;
                          populatelinkedVibhaagDropdown(value!);
                          mahanagarId = value;
                          selctedLevelName = selectedItem.name ?? "";
                          selctedLevel = 'Mahanagar';
                          selctedLevelId = value;
                        });
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
                      onChanged: (value) {
                        final selectedItem = _linkedVibhaag!.firstWhere((bg) => bg.geoUnitID.toString() == value);
                        print(value);
                        setState(() {
                          _linkedVibhaagValue = value;
                          populatelinkedBhaagDropdown(value!);
                          vibhagId = value;
                          _linkedBhaagValue = _linkedNagarValue = null;
                          _linkedBhaag = _linkedNagar = null;
                          selctedLevelName = selectedItem.name ?? "";
                          selctedLevel = 'Vibhaag';
                          selctedLevelId = value;
                        });
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
                      onChanged: (value) {
                        final selectedItem = _linkedBhaag!.firstWhere((bg) => bg.geoUnitID.toString() == value);
                        setState(() {
                          _linkedBhaagValue = value;
                          // populatelinkedShaharDropdown(value!);
                          populatelinkedNagarDropdown(value, null);
                          selctedLevelName = selectedItem.name ?? "";
                          selctedLevel = 'Bhaag';
                          selctedLevelId = value;
                        });
                      },
                    ),
                  if (_linkedNagar != null && _linkedNagar!.length > 0)
                    DropdownButtonFormField(
                      decoration: InputDecoration(labelText: Statics.getLabel('Nagar')),
                      isExpanded: true,
                      value: _linkedNagarValue == "" ? null : _linkedNagarValue,
                      items: _linkedNagar!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                      onChanged: (value) async {
                        selectedUpnagarList = [];
                        final selectedItem = _linkedNagar!.firstWhere((bg) => bg.geoUnitID.toString() == value);
                        setState(() {
                          _linkedupnaragValue = null;
                          selctedLevelName = selectedItem.name ?? "";
                          selctedLevel = 'Nagar';
                          selctedLevelId = value;

                          _linkedNagarValue = value;
                        });
                        data = await Statics.getVijayadashamiInitData(context, Statics.userDetails["userID"], selctedLevelId, selctedLevel == 'Nagar' ? "6" : utsavKontyaStaravar);
                        log("searchVijayaDashami data ${jsonDecode(jsonEncode(data))}");
                        selectedPrabhavi = null;
                        selectedPerson = null;
                        setState(() {
                          _linkedUpnagar = data?.upnagarmandallist ?? [];
                        });
                        if (_linkedUpnagar == null || _linkedUpnagar?.length == 0) {
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: Text(Statics.getLabel('AskConfirmation')),
                              content: Text(Statics.getLabel('addUpnagarDialogBox')),
                              actions: <Widget>[
                                TextButton(
                                  child: Text(Statics.getLabel('add')),
                                  onPressed: () async {
                                    Navigator.of(context).pushReplacementNamed(TabScreen.routeName).then((value) {
                                      if (mounted) clearForm();
                                    }); //.then((value) => searchVijayaDashami());
                                  },
                                ),
                                TextButton(
                                  child: Text(Statics.getLabel('clear')),
                                  onPressed: () {
                                    Navigator.of(ctx).pop();
                                  },
                                )
                              ],
                            ),
                          );
                        }

                        return;
                        // populatelinkedMandalDropdown(value!);
                        // populatelinkedVastiDropdown(value);
                      },
                    ),
                  if (_linkedUpnagar != null && _linkedUpnagar!.length > 0)
                    SizedBox(
                      height: 10,
                    ),
                  if ((selctedLevel == 'Nagar' || selctedLevel == 'upnagarUpkhanda') && _linkedUpnagar != null && _linkedUpnagar!.length > 0)
                    MultiSelectDialogField(
                      title: Text(Statics.getLabel('upnagarUpkhanda')),
                      buttonText: Text(Statics.getLabel('upnagarUpkhanda')),
                      buttonIcon: Icon(Icons.arrow_drop_down),
                      decoration: BoxDecoration(
                        // borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        border: Border(bottom: selectedUpnagarList.isEmpty ? BorderSide(color: Colors.grey) : BorderSide.none),
                      ),
                      confirmText: Text(
                        Statics.getLabel('Submit'),
                        style: const TextStyle(color: Colors.purple),
                      ),
                      cancelText: Text(
                        Statics.getLabel('clear'),
                        style: const TextStyle(color: Colors.purple),
                      ),
                      searchable: false,
                      listType: MultiSelectListType.LIST,
                      items: _linkedUpnagar!.map((bg) => MultiSelectItem(bg.geoUnitID, bg.preferedname.toString())).toList(),
                      initialValue: selectedUpnagarList,
                      chipDisplay: MultiSelectChipDisplay(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.purple, width: 0.7),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          // icon: Icon(Icons.done, color: Colors.purple, size: 16),
                          chipColor: Colors.white,
                          textStyle: TextStyle(fontSize: 12, color: Colors.purple, fontWeight: FontWeight.w500)),
                      // onSaved: (newValue) {},
                      onConfirm: (values) {
                        selectedUpnagarList = values.map((e) {
                          // Check if the element is an integer
                          if (e is int) {
                            return e;
                          }
                          // If it's a string, try to parse it
                          else if (e is String) {
                            return int.tryParse(e); // Use tryParse to handle invalid strings and return null
                          }
                          // Otherwise, return null or handle as needed
                          return null;
                        }).toList();
                        print("valueeeeeeeesssss >>>>>>>>>>>>>>> $values");
                        // if (selectedUpnagarList.contains(values)) {
                        selctedLevel = 'upnagarUpkhanda';
                        selctedLevelName = _linkedUpnagar!.where((upnagar) => selectedUpnagarList.contains(upnagar.geoUnitID)).map((upnagar) => upnagar.preferedname).toList().join(",");
                        //   selectedUpnagarList.add(bg);
                        // } else {
                        //   selectedUpnagarList.remove(bg);
                        // }
                        setState(() {});

                        // print("selctedLevelId >>>>>>>>>>>>>>>>> $selctedLevelId");
                        print("valueeeeeeeesssss >>>>>>>>>>>>>>> ${selectedUpnagarList.join(",")}");
                      },
                    ),
                  // DropdownButtonFormField(
                  //   decoration: InputDecoration(labelText: Statics.getLabel('upnagarUpkhanda')),
                  //   isExpanded: true,
                  //   value: _linkedupnaragValue == "" ? null : _linkedupnaragValue,
                  //   items: _linkedUpnagar?.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.preferedname.toString()))).toList(),
                  //   onChanged: (value) {
                  //     final selectedItem = _linkedUpnagar!.firstWhere((bg) => bg.geoUnitID.toString() == value);
                  //     setState(() {
                  //       selctedLevelName = selectedItem?.preferedname ?? "";
                  //       selctedLevel = 'upnagarUpkhanda';
                  //       selctedLevelId = value;
                  //
                  //       _linkedupnaragValue = value;
                  //       // populatelinkedGraamDropdown(value!);
                  //     });
                  //
                  //     print("selctedLevelId >>>>>>>>>>>>>>>>> $selctedLevelId");
                  //   },
                  // ),
                  SizedBox(
                    height: 15,
                  ),
                  if (selctedLevel == 'upnagarUpkhanda' && selectedUpnagarList.isNotEmpty)
                    Align(
                      alignment: Alignment.center,
                      child: ElevatedButton(
                        style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.purpleAccent)),
                        onPressed: () {
                          searchVijayaDashami();
                          setState(() {
                            _isExpanded = false;
                            isVastiSearch = true;
                            _isSearching = true;
                          });
                        },
                        child: Text("${Statics.getLabel('Filters')}", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    )
                ],
              ),
            ),
            isExpanded: _isExpanded,
          ),
        ],
      ),
    );
  }

  Widget nagarDropdown() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.purpleAccent),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      padding: EdgeInsets.symmetric(
        // vertical: size.height * 0.01,
        horizontal: MediaQuery.of(context).size.width * 0.02,
      ),
      child: ExpansionPanelList(
        elevation: 0,
        dividerColor: Colors.transparent,
        expansionCallback: (int index, bool isExpanded) {
          setState(() {
            _isExpanded = isExpanded;
          });
        },
        children: [
          ExpansionPanel(
            headerBuilder: (BuildContext context, bool isExpanded) {
              return ListTile(
                title: Text(
                  Statics.getLabel('selectStar'),
                  style: TextStyle(color: Colors.purpleAccent, fontWeight: FontWeight.bold),
                ),
                trailing: IconButton(
                    onPressed: () {
                      clearForm();
                    },
                    icon: Icon(Icons.refresh),
                    color: Colors.purpleAccent),
                iconColor: Colors.purpleAccent,
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
                      items: _linkedMahaanagar!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                      onChanged: (value) {
                        final selectedItem = _linkedMahaanagar!.firstWhere((bg) => bg.geoUnitID.toString() == value);
                        print(value);
                        setState(() {
                          _linkedMahaanagarValue = value;
                          _linkedVibhaagValue = null;
                          _linkedBhaagValue = null;
                          _linkedShaharValue = null;
                          _linkedNagarValue = null;
                          populatelinkedVibhaagDropdown(value!);
                          mahanagarId = value;
                          selctedLevelName = selectedItem.name ?? "";
                          selctedLevel = 'Mahanagar';
                          selctedLevelId = value;
                        });
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
                      onChanged: (value) {
                        final selectedItem = _linkedVibhaag!.firstWhere((bg) => bg.geoUnitID.toString() == value);
                        print(value);
                        setState(() {
                          _linkedVibhaagValue = value;
                          populatelinkedBhaagDropdown(value!);
                          vibhagId = value;
                          _linkedBhaagValue = _linkedNagarValue = null;
                          _linkedBhaag = _linkedNagar = null;
                          selctedLevelName = selectedItem.name ?? "";
                          selctedLevel = 'Vibhaag';
                          selctedLevelId = value;
                        });
                      },
                    ),
                  SizedBox(height: 10),
                  if (_linkedBhaag != null)
                    DropdownButtonFormField(
                      decoration: InputDecoration(labelText: Statics.getLabel('Bhaag')),
                      isExpanded: true,
                      value: _linkedBhaagValue == "" ? null : _linkedBhaagValue,
                      items: _linkedBhaag!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                      onChanged: (value) {
                        final selectedItem = _linkedBhaag!.firstWhere((bg) => bg.geoUnitID.toString() == value);
                        setState(() {
                          _linkedBhaagValue = value;
                          // populatelinkedShaharDropdown(value!);
                          populatelinkedNagarDropdown(value, null);
                          selctedLevelName = selectedItem.name ?? "";
                          selctedLevel = 'Bhaag';
                          selctedLevelId = value;
                        });
                      },
                    ),
                  if (_linkedNagar != null && _linkedNagar!.length > 0)
                    DropdownButtonFormField(
                      decoration: InputDecoration(labelText: Statics.getLabel('Nagar')),
                      isExpanded: true,
                      value: _linkedNagarValue == "" ? null : _linkedNagarValue,
                      items: _linkedNagar!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                      onChanged: (value) async {
                        final selectedItem = _linkedNagar!.firstWhere((bg) => bg.geoUnitID.toString() == value);
                        setState(() {
                          selctedLevelName = selectedItem.name ?? "";
                          selctedLevel = 'Nagar';
                          selctedLevelId = value;

                          _linkedNagarValue = value;
                        });
                        populatelinkedMandalDropdown(value!);
                        populatelinkedVastiDropdown(value);
                      },
                    ),
                  if (_linkedNagar != null && _linkedNagar!.length > 0) SizedBox(height: 10),
                  if (selctedLevel == 'Nagar')
                    Align(
                      alignment: Alignment.center,
                      child: ElevatedButton(
                        style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.purpleAccent)),
                        onPressed: () {
                          searchVijayaDashami();
                          setState(() {
                            _isExpanded = false;
                            isVastiSearch = true;
                            _isSearching = true;
                          });
                        },
                        child: Text("${Statics.getLabel('Filters')}", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    )
                ],
              ),
            ),
            isExpanded: _isExpanded,
          ),
        ],
      ),
    );
  }

  String? selectedFilePath;
  String? filePathOg;
  List<String?> _selectedFileNames1 = []; // To display the file name
  List<String?> _selectedFileNames2 = []; // To display the file name
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
                                                "${(index + 1)}. $img",
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
                                                await MyAppGlobals.downloadFile('${Statics.baseUrl}/Files/vijayadhasmifiles/$img', img.toString());
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
                                        CachedNetworkImage(
                                          imageUrl: '${Statics.baseUrl}/Files/vijayadhasmifiles/$img',
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
                    img ?? "${Statics.getLabel('selectFile')}",
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
                      final _result = await deleteImageDataFun(imageName: img.toString());
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
                if (!_isSearching) {
                  Fluttertoast.showToast(
                    msg: "${Statics.getLabel('NagarSelectionImportant')}",
                  );
                  return;
                }
                loadingNotifier?.value = true;
                XFile? result;
                final isCamera = await showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: Text(Statics.getLabel('chooseAnOption')),
                    content: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton.filled(
                          onPressed: () async {
                            Navigator.of(ctx).pop(true);
                          },
                          icon: Icon(Icons.camera_alt),
                        ),
                        IconButton.filled(
                          onPressed: () async {
                            Navigator.of(ctx).pop(false);
                          },
                          icon: Icon(Icons.photo_library),
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
                );
                setState(() {});

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
                      final _result = await submitImageDataFun(type: "utsavImgData", showLoader: true);
                      _selectedFileNames1.add(_result ?? fileName);
                      setState(() {});
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
        TextFormField(
          controller: txtUtsavPhotoDescController,
          textAlignVertical: TextAlignVertical.center,
          // textAlign: TextAlign.left,
          autofocus: false,
          readOnly: _isSearching == false,
          onTap: () {
            if (_isSearching == false) {
              Fluttertoast.showToast(
                msg: "${Statics.getLabel('NagarSelectionImportant')}",
              );
            }
          },
          maxLines: 5,
          onChanged: (value) => setState(() {}),
          onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
          decoration: InputDecoration(
            hintText: Statics.getLabel("AddUtsavFilesDesc"),
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
                                                "${(index + 1)}. $img",
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
                                                await MyAppGlobals.downloadFile('${Statics.baseUrl}/Files/vijayadhasmifiles/$img', img.toString());
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
                                        CachedNetworkImage(
                                          imageUrl: '${Statics.baseUrl}/Files/vijayadhasmifiles/$img',
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
                    img ?? "${Statics.getLabel('selectFile')}",
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
                      final _result = await deleteImageDataFun(imageName: img.toString());
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
                if (!_isSearching) {
                  Fluttertoast.showToast(
                    msg: "${Statics.getLabel('NagarSelectionImportant')}",
                  );
                  return;
                }
                loadingNotifier?.value = true;
                XFile? result;
                final isCamera = await showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: Text(Statics.getLabel('chooseAnOption')),
                    content: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton.filled(
                          onPressed: () async {
                            Navigator.of(ctx).pop(true);
                          },
                          icon: Icon(Icons.camera_alt),
                        ),
                        IconButton.filled(
                          onPressed: () async {
                            Navigator.of(ctx).pop(false);
                          },
                          icon: Icon(Icons.photo_library),
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
                );
                setState(() {});

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
                      final _result = await submitImageDataFun(type: "Add", showLoader: true);
                      _selectedFileNames2.add(_result ?? fileName);
                      setState(() {});
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
        TextFormField(
          controller: txtUtsavAddPhotoDescController,
          textAlignVertical: TextAlignVertical.center,
          // textAlign: TextAlign.left,
          autofocus: false,
          readOnly: _isSearching == false,
          onTap: () {
            if (_isSearching == false) {
              Fluttertoast.showToast(
                msg: "${Statics.getLabel('NagarSelectionImportant')}",
              );
            }
          },
          maxLines: 5,
          onChanged: (value) => setState(() {}),
          onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
          decoration: InputDecoration(
            hintText: Statics.getLabel("AddAdvUtsavFilesDesc"),
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
              readOnly: _isSearching == false,
              onTap: () {
                if (_isSearching == false) {
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
              readOnly: _isSearching == false,
              onTap: () {
                if (_isSearching == false) {
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
                    _urlsList.add(TypeValueData(value: txtUrlsController.text.trim(), description: txtUrlDescController.text.trim()));
                    txtUrlsController.clear();
                    txtUrlDescController.clear();
                  } else {
                    if (!_isSearching) {
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
            readOnly: isEdit || _isSearching == false,
            maxLength: maxInput,
            onTap: () {
              if (_isSearching == false) {
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
                      if (!_isSearching) {
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
                      if (!_isSearching) {
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

  Future<void> submitForm({bool showLoader = true}) async {
    Map<String, dynamic> formData = {
      "GeoUnitID": selectedUpnagarList.isEmpty ? selctedLevelId.toString() : selectedUpnagarList.join(","),
      "AppUserID": int.parse(Statics.userDetails['userID']),
      "is_nagar": int.parse(utsavKontyaStaravar!),
      "shanchalan_zaleka": sanchalanZaleKa,
      "shanchalan_sadan_zaleka": sanchalanSadandaZalKa,
      "shanchalan_ghosvandan_zaleka": sanchalanGhoshVadanZalKa,
      "karyakram_nirdharit_vedhvar_zaleka": programNirdharitVed,
      "vyakti_geet_khantasta_khoteka": vaiyaktikGitKantashtha,
      "karaykram_hisob_24_tasa_purna_zaleka": programHishobh24Hour,
      "mukhya_atithi_id": selectedMukhyaAtithi,
      "mukhya_atithi_is_sajjan_shakti": selectedType == "sarsajjanshakti" ? 1 : 0,
      "visitit_atithi_sajjan_shaktiids": selectedSajjanshaktiItems.map((e) => e.pkid.toString()).join(","),
      "visitit_atithi_anyaprabha_vi_lokamids": selectedAnyaprabhaviItems.map((e) => e.pkId.toString()).join(","),
      "bhougolik_pratinidhatva_ids": selectedBhougolikPratinidhitwaVastiIds,
      "bhougolik_pratinidhatva_count": selectedVastiCount,
      "shakha_pratinidhatva_ids": selectedShakhaaPratinidhitwaVastiIds,
      "shakha_pratinidhatva_count": selectedShakhaCount,
      "milan_pratinidhatva_ids": selectedMilanPratinidhitwaVastiIds,
      "milan_pratinidhatva_count": selectedMilanCount,
      "manasik_sangh_mandali_pratinidhatva_ids": selectedSanghaMandaliPratinidhitwaVastiIds,
      "manasik_sangh_mandali_pratinidhatva_count": selectedSanghaMandaliCount,
      "anya_upastiti_matrushakti": presentMatrushaktiController.text,
      "anya_upastiti_male": presentMaleController.text,
      "baal_pat": patShishuBaalCtrl.text,
      "baal_gan": ganShishuBaalCtrl.text,
      "baal_anya": anyaShishuBaalCtrl.text,
      "Mahavidya_pat": patMahavidyaCtrl.text,
      "Mahavidya_gan": ganMahavidyaCtrl.text,
      "Mahavidya_anya": anyaMahavidyaCtrl.text,
      "TarunVyav_pat": patTarunVyavCtrl.text,
      "TarunVyav_gan": ganTarunVyavCtrl.text,
      "TarunVyav_anya": anyaTarunVyavCtrl.text,
      "ProudhVyav_pat": patProudhVyavCtrl.text,
      "ProudhVyav_gan": ganProudhVyavCtrl.text,
      "ProudhVyav_anya": anyaProudhVyavCtrl.text,
      "urls": _urlsList,
      "karyakramVaktaName": txtVaktaNameController.text.trim(),
      "karyakramVaktaTask": txtVaktaTaskController.text.trim(),
      "utsavPhotoDesc": txtUtsavPhotoDescController.text.trim(),
      "utsavAddPhotoDesc": txtUtsavAddPhotoDescController.text.trim(),
    };

    String formattedJson = const JsonEncoder.withIndent('  ').convert(formData);
    log("Form Data (JSON):\n$formattedJson");
    await Statics.saveVijayaDashamiUtsavData(context, formData, showLoader);
    getFormData();
  }

  Future<String?> submitImageDataFun({bool showLoader = false, required String type}) async {
    Map<String, dynamic> formData = {
      "GeoUnitID": selectedUpnagarList.isEmpty ? selctedLevelId.toString() : selectedUpnagarList.join(","),
      "filebase": selectedFilePath,
      "type": type,
    };

    String formattedJson = const JsonEncoder.withIndent('  ').convert(formData);
    log("Form Data (JSON):\n$formattedJson");
    final _result = await Statics.saveVijayaDashamiImageData(context: context, inputJson: formData, showLoader: showLoader);
    // getFormData();
    return _result;
  }

  Future<bool> deleteImageDataFun({bool showLoader = true, required String imageName}) async {
    Map<String, dynamic> formData = {
      "GeoUnitID": selectedUpnagarList.isEmpty ? selctedLevelId.toString() : selectedUpnagarList.join(","),
      "filepath": imageName,
    };

    String formattedJson = const JsonEncoder.withIndent('  ').convert(formData);
    log("Form Data (JSON):\n$formattedJson");
    final _result = await Statics.deleteVijayaDashamiImageData(context: context, inputJson: formData, showLoader: showLoader);
    // getFormData();
    return _result;
  }

  GetVijayadashamiDataByGeoUnitModel? getVijayaDashamiUtsavDataByGeounitData;

  Future<void> getFormData() async {
    Map<String, dynamic> formData = {
      "GeoUnitID": selectedUpnagarList.isEmpty ? selctedLevelId.toString() : selectedUpnagarList.join(","),
      "AppUserID": int.parse(Statics.userDetails['userID']),
      "isnagar": int.parse(utsavKontyaStaravar!),
    };

    String formattedJson = jsonEncode(formData);
    log("Form Data (JSON):\n$formattedJson");
    getVijayaDashamiUtsavDataByGeounitData = await Statics.getVijayaDashamiUtsavDataByGeounit(context, formData);
    log("getVijayaDashamiUtsavDataByGeounitData ${jsonDecode(jsonEncode(getVijayaDashamiUtsavDataByGeounitData))}");
    setState(() {
      VijayadashamiUtsav utsav = getVijayaDashamiUtsavDataByGeounitData!.vijayadashamiUtsav!;

      _urlsList = getVijayaDashamiUtsavDataByGeounitData?.urldata ?? [];
      txtVaktaNameController.text = getVijayaDashamiUtsavDataByGeounitData?.vijayadashamiUtsav?.karyakramVaktaName ?? "";
      txtVaktaTaskController.text = getVijayaDashamiUtsavDataByGeounitData?.vijayadashamiUtsav?.karyakramVaktaTask ?? "";
      txtUtsavPhotoDescController.text = getVijayaDashamiUtsavDataByGeounitData?.vijayadashamiUtsav?.utsavPhotoDesc ?? "";
      txtUtsavAddPhotoDescController.text = getVijayaDashamiUtsavDataByGeounitData?.vijayadashamiUtsav?.utsavAddPhotoDesc ?? "";
      _selectedFileNames1 = getVijayaDashamiUtsavDataByGeounitData?.eventdata?.map((url) => url.value).toList() ?? [];
      _selectedFileNames2 = getVijayaDashamiUtsavDataByGeounitData?.adddata?.map((url) => url.value).toList() ?? [];

      // Example text controllers
      presentMatrushaktiController.text = utsav.anyaUpastitiMatrushakti?.toString() ?? '';
      presentMaleController.text = utsav.anyaUpastitiMale?.toString() ?? '';

      patShishuBaalCtrl.text = utsav.baalPat?.toString() ?? '';
      ganShishuBaalCtrl.text = utsav.baalGan?.toString() ?? '';
      anyaShishuBaalCtrl.text = utsav.baalAnya?.toString() ?? '';

      patMahavidyaCtrl.text = utsav.mahavidyaPat?.toString() ?? '';
      ganMahavidyaCtrl.text = utsav.mahavidyaGan?.toString() ?? '';
      anyaMahavidyaCtrl.text = utsav.mahavidyaAnya?.toString() ?? '';

      patTarunVyavCtrl.text = utsav.tarunVyavPat?.toString() ?? '';
      ganTarunVyavCtrl.text = utsav.tarunVyavGan?.toString() ?? '';
      anyaTarunVyavCtrl.text = utsav.tarunVyavAnya?.toString() ?? '';

      patProudhVyavCtrl.text = utsav.proudhVyavPat?.toString() ?? '';
      ganProudhVyavCtrl.text = utsav.proudhVyavGan?.toString() ?? '';
      anyaProudhVyavCtrl.text = utsav.proudhVyavAnya?.toString() ?? '';

      // Example int variables
      sanchalanZaleKa = utsav.shanchalanZaleka ?? 2;
      sanchalanSadandaZalKa = utsav.shanchalanSadanZaleka ?? 2;
      sanchalanGhoshVadanZalKa = utsav.shanchalanGhosvandanZaleka ?? 2;
      programNirdharitVed = utsav.karyakramNirdharitVedhvarZaleka ?? 2;
      vaiyaktikGitKantashtha = utsav.vyaktiGeetKhantastaKhoteka ?? 2;
      programHishobh24Hour = utsav.karaykramHisob24TasaPurnaZaleka ?? 2;

      // selectedMukhyaAtithi = utsav.mukhyaAtithiId;
      // selectedType = utsav.mukhyaAtithiIsSajjanShakti == 1
      //     ? "sarsajjanshakti"
      //     : "anyaprabhavi";

      selectedSajjanshaktiItemsIds = utsav.visititAtithiSajjanShaktiids;
      // Sajjan Shakti
      if (selectedSajjanshaktiItemsIds != null && selectedSajjanshaktiItemsIds!.isNotEmpty && data?.vastisarsajjanshakti != null) {
        final idSet = selectedSajjanshaktiItemsIds!.split(",").map((e) => e.trim()).where((e) => e.isNotEmpty).toSet(); // remove duplicates

        selectedSajjanshaktiItems = data!.vastisarsajjanshakti!.where((item) => idSet.contains(item.pkid.toString())).toList();
      } else {
        selectedSajjanshaktiItems = [];
      }
      selectedAnyaprabhaviItemsIds = utsav.visititAtithiAnyaprabhaViLokamids;
      // Anya Prabhavi
      if (selectedAnyaprabhaviItemsIds != null && selectedAnyaprabhaviItemsIds!.isNotEmpty && data?.vastisanyaprabhavi != null) {
        final idSet = selectedAnyaprabhaviItemsIds!.split(",").map((e) => e.trim()).where((e) => e.isNotEmpty).toSet();

        selectedAnyaprabhaviItems = data!.vastisanyaprabhavi!.where((item) => idSet.contains(item.pkId.toString())).toList();
      } else {
        selectedAnyaprabhaviItems = [];
      }

      selectedMukhyaAtithi = utsav.mukhyaAtithiId;
      selectedType = utsav.mukhyaAtithiIsSajjanShakti == 1 ? "sarsajjanshakti" : "anyaprabhavi";

      if (selectedType == "sarsajjanshakti") {
        selectedPerson = (data?.vastisarsajjanshakti ?? []).firstWhere(
          (e) => e.pkid == selectedMukhyaAtithi,
        );
        selectedPrabhavi = null;
      } else {
        selectedPrabhavi = (data?.vastisanyaprabhavi ?? []).where((e) => e.pkId == selectedMukhyaAtithi).toList().isNotEmpty
            ? (data?.vastisanyaprabhavi ?? []).firstWhere((e) => e.pkId == selectedMukhyaAtithi)
            : null;

        selectedPerson = null;
      }
//============================================   bhougolik pratinidhitwa =================================================================
      selectedBhougolikPratinidhitwaVastiIds = utsav.bhougolikPratinidhatvaIds ?? '';

      if (selectedBhougolikPratinidhitwaVastiIds != null && selectedBhougolikPratinidhitwaVastiIds!.isNotEmpty && data?.vastimandallist != null) {
        final idSet = selectedBhougolikPratinidhitwaVastiIds!.split(",").map((e) => e.trim()).where((e) => e.isNotEmpty).toSet();

        checkboxGraamVastiSelectedItems = data!.vastimandallist!.where((item) => idSet.contains(item.geoUnitID.toString())).toList();
      } else {
        checkboxGraamVastiSelectedItems = [];
      }
      selectedVastiCount = utsav.bhougolikPratinidhatvaCount ?? 0;
      selectedVastiCount = utsav.bhougolikPratinidhatvaCount ?? 0;

//============================================   SHAKHAA pratinidhitwa =================================================================

      selectedShakhaaPratinidhitwaVastiIds = utsav.shakhaPratinidhatvaIds ?? '';
      if (selectedShakhaaPratinidhitwaVastiIds != null && selectedShakhaaPratinidhitwaVastiIds!.isNotEmpty && data?.shakhaalist != null) {
        final idSet = selectedShakhaaPratinidhitwaVastiIds!.split(",").map((e) => e.trim()).where((e) => e.isNotEmpty).toSet();

        checkboxShakhaSelectedItems = data!.shakhaalist!.where((item) => idSet.contains(item.geoUnitID.toString())).toList();
      } else {
        checkboxShakhaSelectedItems = [];
      }
      selectedShakhaCount = utsav.shakhaPratinidhatvaCount ?? 0;
//============================================   MILAN pratinidhitwa =================================================================
      selectedMilanPratinidhitwaVastiIds = utsav.milanPratinidhatvaIds ?? '';
      if (selectedMilanPratinidhitwaVastiIds != null && selectedMilanPratinidhitwaVastiIds!.isNotEmpty && data?.shakhaalist != null) {
        final idSet = selectedMilanPratinidhitwaVastiIds!.split(",").map((e) => e.trim()).where((e) => e.isNotEmpty).toSet();

        checkboxMilanSelectedItems = data!.shakhaalist!.where((item) => idSet.contains(item.geoUnitID.toString())).toList();
      } else {
        checkboxMilanSelectedItems = [];
      }

      selectedMilanCount = utsav.milanPratinidhatvaCount ?? 0;
//============================================   MASIKMILAN SANGHA MANDALI  pratinidhitwa =================================================================

      selectedSanghaMandaliPratinidhitwaVastiIds = utsav.manasikSanghMandaliPratinidhatvaIds ?? '';
      if (selectedSanghaMandaliPratinidhitwaVastiIds != null && selectedSanghaMandaliPratinidhitwaVastiIds!.isNotEmpty && data?.shakhaalist != null) {
        final idSet = selectedSanghaMandaliPratinidhitwaVastiIds!.split(",").map((e) => e.trim()).where((e) => e.isNotEmpty).toSet();

        checkboxSanghaMandaliSelectedItems = data!.shakhaalist!.where((item) => idSet.contains(item.geoUnitID.toString())).toList();
      } else {
        checkboxSanghaMandaliSelectedItems = [];
      }

      selectedSanghaMandaliCount = utsav.manasikSanghMandaliPratinidhatvaCount ?? 0;
      totalVastiCount = utsav.bhougolikEkunvasti ?? 0;
      totalShakhaCount = utsav.shakhaPratinidhatvaEkun ?? 0;
      totalMilanCount = utsav.milanPratinidhatvaEkun ?? 0;
      totalSanghaMandaliCount = utsav.manasikSanghMandaliPratinidhatvaEkun ?? 0;
      averageShakhaCount = utsav.shakhaPratinidhatvaSahasari.toString();
      averageMilanCount = utsav.milanPratinidhatvaSahasari.toString();
      averageSanghaMandaliCount = utsav.manasikSanghMandaliPratinidhatvaSahasari.toString();
    });
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

class VastiPerson {
  String? samparkasutranava;
  String? address;
  String? doorabhaash;
  int? isactive;
  String? name;
  int? pkid;
  String? prabhaavkshetrName;
  int? prabhaavkshetrid;
  String? samparkasutraMobileNumber;
  String? samparksthitiName;
  int? samparksthitiid;
  String? sanstheCheNaav;
  String? sansthechaKuthalaPadavar;
  String? selectedDropdownValueName;
  String? selectedDropdownValueName1;
  String? selectedDropdownValueName2;
  String? shreneedhiName;
  int? shreneeid;
  int? vastiid;
  String? vastiname;
  int? visheshId;
  String? visheshname;

  VastiPerson({
    this.samparkasutranava,
    this.address,
    this.doorabhaash,
    this.isactive,
    this.name,
    this.pkid,
    this.prabhaavkshetrName,
    this.prabhaavkshetrid,
    this.samparkasutraMobileNumber,
    this.samparksthitiName,
    this.samparksthitiid,
    this.sanstheCheNaav,
    this.sansthechaKuthalaPadavar,
    this.selectedDropdownValueName,
    this.selectedDropdownValueName1,
    this.selectedDropdownValueName2,
    this.shreneedhiName,
    this.shreneeid,
    this.vastiid,
    this.vastiname,
    this.visheshId,
    this.visheshname,
  });
}

class VastiCounts {
  final Map<String, int> prakarCounts;
  final Map<String, int> vayogatCounts;

  VastiCounts({
    required this.prakarCounts,
    required this.vayogatCounts,
  });

  // Factory for JSON parsing
  factory VastiCounts.fromJson(Map<String, dynamic> json) {
    return VastiCounts(
      prakarCounts: Map<String, int>.from(json['prakarCounts'] ?? {}),
      vayogatCounts: Map<String, int>.from(json['vayogatCounts'] ?? {}),
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'prakarCounts': prakarCounts,
      'vayogatCounts': vayogatCounts,
    };
  }
}
