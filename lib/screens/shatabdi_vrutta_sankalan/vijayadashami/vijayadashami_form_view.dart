import 'dart:convert';
import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:niyojak_prod/screens/shatabdi_vrutta_sankalan/vijayadashami/vijaya_dashami_report.dart';
import 'package:niyojak_prod/widgets/app_drawer.dart';
import 'package:niyojak_prod/widgets/single_column_row.dart';

import '../../../helpers/static_data.dart' as Statics;
import '../../../models/response_model/get_vijaya_dashami_geounit_data.dart';
import '../../../models/response_model/vasti_up_data_model.dart';
import '../../../models/response_model/vijayaDashamiInitModel.dart';
import '../../../providers/bals.dart';
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

  bool _isSearching = false;
  bool _isExpanded = true;
  bool isVastiSearch = false;

  List<GeoUnitMasterBAL>? _linkedMahaanagar;
  List<GeoUnitMasterBAL>? _linkedVibhaag;
  List<GeoUnitMasterBAL>? _linkedBhaag;
  List<GeoUnitMasterBAL>? _linkedShahar;
  List<GeoUnitMasterBAL>? _linkedNagar;
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
  String? _linkedvastiValue = "";
  String? _baithakTypeValue = '';
  String? _baithakTypeYear = '';
  int? _baithakType;
  String _selectedNagarAndBaithak = '';
  String? mahanagarId = '';
  String? vibhagId = '';

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
      _linkedgraamValue = null;
      _linkedvastiValue = null;

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
      utsavKontyaStaravar = "1";

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

  Future<List<GeoUnitMasterBAL>> populatelinkedBhaagDropdown(String vibhaagIDStr) async {
    _linkedShaharValue = _linkedNagarValue = null;
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
    TextEditingController? limitController,
    TextEditingController? otherController,
  }) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
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
        decoration: const InputDecoration(
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
    data = await Statics.getVijayadashamiInitData(context, Statics.userDetails["userID"], selctedLevelId);
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
                    items: _linkedNagar!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                    onChanged: (value) async {
                      set(() {
                        _linkedNagarValuePopup = value;
                      });
                      final _data = await Statics.getVijayadashamiInitData(context, Statics.userDetails["userID"], value);
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
                        const Divider(),
                        ...vastisarsajjanshaktiList.map((item) {
                          return RadioListTile(
                            title: Text(item.name ?? "Unknown"),
                            value: item,
                            groupValue: selectedItem,
                            activeColor: Colors.purpleAccent,
                            contentPadding: EdgeInsets.zero,
                            onChanged: (val) {
                              print("printing the val >>>>>>>> ${jsonEncode(val)}");
                              set(() {
                                selectedItem = val;
                                selectedType = "sarsajjanshakti";
                              });
                            },
                          );
                        }),
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
                        ...vastisanyaprabhaviList.map((item) {
                          return RadioListTile(
                            title: Text(item.name ?? "Unknown"),
                            value: item,
                            groupValue: selectedItem,
                            activeColor: Colors.blueAccent,
                            contentPadding: EdgeInsets.zero,
                            onChanged: (val) {
                              set(() {
                                selectedItem = val;
                                selectedType = "anyaprabhavi";
                              });
                            },
                          );
                        }),
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
    print("popup onTap >>>>>>>>>>>>>>> $sajjanshaktiIds");
    print("popup onTap >>>>>>>>>>>>>>> $anyaprabhaviIds");
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
                padding: const EdgeInsets.all(16),
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
                      items: _linkedNagar!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                      onChanged: (value) async {
                        set(() {
                          _linkedNagarValuePopup = value;
                        });
                        final _data = await Statics.getVijayadashamiInitData(context, Statics.userDetails["userID"], value);

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
                              // selectedSajjanshakti.addAll(filteredSajjanshakti.where((e) => ids.contains(e.pkid.toString())).toList());
                              selectedSajjanshakti.toSet().toList();
                            }
                            // selectedSajjanshakti = preselectedItem ?? vastisarsajjanshaktiList.firstWhereOrNull((e) => e.pkid == selectedMukhyaAtithi);
                          } else {
                            if (anyaprabhaviIds != null && anyaprabhaviIds.isNotEmpty) {
                              print("Printing ids >>>>>>>>> $anyaprabhaviIds");
                              final ids = anyaprabhaviIds.split(",").map((e) => e.trim()).toList();
                              // selectedAnyaprabhavi.addAll(filteredAnyaprabhavi.where((e) => ids.contains(e.pkId.toString())).toList());
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

                    /// Content
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// Sajjan Shakti
                            Text(
                              Statics.getLabel('SajjanShakti'),
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: Colors.blueGrey,
                              ),
                            ),
                            const Divider(),

                            ...filteredSajjanshakti.map((item) {
                              return CheckboxListTile(
                                dense: true,
                                contentPadding: EdgeInsets.zero,
                                title: Text(item.name ?? "Unknown"),
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
                              );
                            }),

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

                            ...filteredAnyaprabhavi.map((item) {
                              return CheckboxListTile(
                                dense: true,
                                contentPadding: EdgeInsets.zero,
                                title: Text(item.name ?? "Unknown"),
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
                              );
                            }),
                          ],
                        ),
                      ),
                    ),
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

  String? utsavKontyaStaravar = "1";

  VastiUpDataListModel? vastiUpDataListModel;

  Future<void> getVastiUpDataList() async {
    var inputData = json.encode({
      "AppUserID": Statics.userDetails['userID'],
      "GeoUnitID": selctedLevelId,
    });

    print("_submitForm $inputData");

    vastiUpDataListModel = await Statics.getVastiUpdata(inputData);
    getFormData();
    if (vastiUpDataListModel != null) {
      print("Data fetched successfully");
      setState(() {
        print("selectedIdString getVastiUpDataList  --->>>   $vastiUpDataListModel");
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
                  Row(
                    children: [
                      Expanded(
                        child: RadioListTile<String>(
                          contentPadding: EdgeInsets.zero,
                          title: Text("${Statics.getLabel('NagarKaaryakartaaCount')}"),
                          value: "1",
                          groupValue: utsavKontyaStaravar,
                          onChanged: (value) {
                            setState(() {
                              utsavKontyaStaravar = value;
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: RadioListTile<String>(
                          contentPadding: EdgeInsets.zero,
                          title: Text("${Statics.getLabel('upnagarUpkhanda')}"),
                          value: "0",
                          groupValue: utsavKontyaStaravar,
                          onChanged: (value) {
                            setState(() {
                              utsavKontyaStaravar = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
//=======================================   SEARCH FILTERS ==========================================================================================
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.purpleAccent),
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              padding: EdgeInsets.symmetric(
                // vertical: size.height * 0.01,
                horizontal: size.width * 0.02,
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
                              onChanged: (value) {
                                final selectedItem = _linkedNagar!.firstWhere((bg) => bg.geoUnitID.toString() == value);
                                populatelinkedMandalDropdown(value!);
                                populatelinkedVastiDropdown(value);
                                setState(() {
                                  selctedLevelName = selectedItem.name ?? "";
                                  selctedLevel = 'Nagar';
                                  selctedLevelId = value;

                                  _linkedNagarValue = value;
                                });
                              },
                            ),
                          if (_linkedNagar != null && _linkedNagar!.length > 0)
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
                                final selectedItem = _linkedmandal!.firstWhere((bg) => bg.geoUnitID.toString() == value);
                                setState(() {
                                  selctedLevelName = selectedItem.name ?? "";
                                  selctedLevel = 'Mandal';
                                  selctedLevelId = value;

                                  _linkedmandalValue = value;
                                  populatelinkedGraamDropdown(value!);
                                });
                              },
                            ),
                          // if (_linkedmandal != null && _linkedmandal!.length > 0)
                          //   SizedBox(
                          //     height: 10,
                          //   ),
                          // if (_linkedgraam != null && _linkedgraam!.length > 0)
                          //   DropdownButtonFormField(
                          //     decoration: InputDecoration(
                          //         labelText: Statics.getLabel('Graam')),
                          //     isExpanded: true,
                          //     value: _linkedgraamValue == ""
                          //         ? null
                          //         : _linkedgraamValue,
                          //     items: _linkedgraam!
                          //         .map((bg) => DropdownMenuItem(
                          //             value: bg.geoUnitID.toString(),
                          //             child: Text(bg.name!)))
                          //         .toList(),
                          //     onChanged: (value) {
                          //       final selectedItem = _linkedgraam!.firstWhere(
                          //           (bg) => bg.geoUnitID.toString() == value);
                          //       setState(() {
                          //         _linkedgraamValue = value;
                          //         selctedLevelName = selectedItem.name ?? "";
                          //         selctedLevel = 'Graam';
                          //         selctedLevelId = value;
                          //       });
                          //     },
                          //   ),
                          // if (_linkedvasti != null && _linkedvasti!.length > 0)

                          // DropdownButtonFormField(
                          //   decoration: InputDecoration(
                          //       labelText: Statics.getLabel('Vasti')),
                          //   isExpanded: true,
                          //   value: _linkedvastiValue == ""
                          //       ? null
                          //       : _linkedvastiValue,
                          //   items: _linkedvasti!
                          //       .map((bg) => DropdownMenuItem(
                          //           value: bg.geoUnitID.toString(),
                          //           child: Text(bg.name!)))
                          //       .toList(),
                          //   onChanged: (value) {
                          //     final selectedItem = _linkedvasti!.firstWhere(
                          //         (bg) => bg.geoUnitID.toString() == value);
                          //     setState(() {
                          //       _linkedvastiValue = value;
                          //       selctedLevelName = selectedItem.name ?? "";
                          //       selctedLevel = 'Vasti';
                          //       selctedLevelId = value;
                          //     });
                          //   },
                          // ),
                          SizedBox(
                            height: 15,
                          ),
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
            ),
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
                        "${selctedLevel}  ->  ",
                        style: TextStyle(color: Colors.purpleAccent, fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Text(
                        " $selctedLevelName",
                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 17),
                      ),
                    ],
                  )),
            SizedBox(
              height: 10,
            ),
// ================================== 1 QUESTIONS Box ==================================================================================================================================================================================================================================================================================================================================================
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
// ================================== 2 QUESTIONS Box ==================================================================================================================================================================================================================================================================================================================================================
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
// ================================== 3 QUESTIONS Box ==================================================================================================================================================================================================================================================================================================================================================
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
                              Navigator.of(context)
                                  .pushReplacementNamed(
                                    AddMukhyaAtithi.routeName,
                                    arguments: _linkedNagar,
                                  )
                                  .then((value) => searchVijayaDashami());
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
// ================================== 4 QUESTIONS Box ==================================================================================================================================================================================================================================================================================================================================================
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
                                  child: Text("${Statics.getLabel('Vayogat')}", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("${Statics.getLabel('patSankhyaa')}", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                                ),
                                Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text("${Statics.getLabel('Total')}", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("${Statics.getLabel('ganveshatPresentCount')}", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("${Statics.getLabel('otherSwayamsewakPresentCount')}", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                                ),
                              ],
                            ),

                            // Data Rows
                            TableRow(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("${Statics.getLabel('Shishu')}/${Statics.getLabel('Baal')}"),
                                ),
                                _numberField(patShishuBaalCtrl),
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(_rowTotal(ganShishuBaalCtrl.text, anyaShishuBaalCtrl.text).toString()),
                                  ),
                                ),
                                _numberField(ganShishuBaalCtrl, limitController: patShishuBaalCtrl, otherController: anyaShishuBaalCtrl),
                                _numberField(anyaShishuBaalCtrl, limitController: patShishuBaalCtrl, otherController: ganShishuBaalCtrl),
                              ],
                            ),

                            TableRow(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("${Statics.getLabel('MahaavidyaalayeenTarunLabel')}"),
                                ),
                                _numberField(patMahavidyaCtrl),
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(_rowTotal(ganMahavidyaCtrl.text, anyaMahavidyaCtrl.text).toString()),
                                  ),
                                ),
                                _numberField(ganMahavidyaCtrl, limitController: patMahavidyaCtrl, otherController: anyaMahavidyaCtrl),
                                _numberField(anyaMahavidyaCtrl, limitController: patMahavidyaCtrl, otherController: ganMahavidyaCtrl),
                              ],
                            ),

                            TableRow(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("${Statics.getLabel('TarunVyavasaayee')}"),
                                ),
                                _numberField(patTarunVyavCtrl),
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(_rowTotal(ganTarunVyavCtrl.text, anyaTarunVyavCtrl.text).toString()),
                                  ),
                                ),
                                _numberField(ganTarunVyavCtrl, limitController: patTarunVyavCtrl, otherController: anyaTarunVyavCtrl),
                                _numberField(anyaTarunVyavCtrl, limitController: patTarunVyavCtrl, otherController: ganTarunVyavCtrl),
                              ],
                            ),

                            TableRow(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("${Statics.getLabel('ProudhaVyavasaayeeLabel')}"),
                                ),
                                _numberField(patProudhVyavCtrl),
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(_rowTotal(ganProudhVyavCtrl.text, anyaProudhVyavCtrl.text).toString()),
                                  ),
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
                                  child: Text("${Statics.getLabel('Total')}", style: TextStyle(fontWeight: FontWeight.bold)),
                                ),
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(_getColumnTotal([patShishuBaalCtrl, patMahavidyaCtrl, patTarunVyavCtrl, patProudhVyavCtrl]).toString()),
                                  ),
                                ),
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      (_getColumnTotal([ganShishuBaalCtrl, ganMahavidyaCtrl, ganTarunVyavCtrl, ganProudhVyavCtrl]) +
                                              _getColumnTotal([anyaShishuBaalCtrl, anyaMahavidyaCtrl, anyaTarunVyavCtrl, anyaProudhVyavCtrl]))
                                          .toString(),
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(_getColumnTotal([ganShishuBaalCtrl, ganMahavidyaCtrl, ganTarunVyavCtrl, ganProudhVyavCtrl]).toString()),
                                  ),
                                ),
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(_getColumnTotal([anyaShishuBaalCtrl, anyaMahavidyaCtrl, anyaTarunVyavCtrl, anyaProudhVyavCtrl]).toString()),
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
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          width: 120,
                          height: 35,
                          decoration: BoxDecoration(border: Border.all(color: Colors.purpleAccent.shade100), borderRadius: BorderRadius.circular(15)),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(width: 5),
                                Text(
                                  "${Statics.getLabel('addVasti')}",
                                  style: TextStyle(color: Colors.purpleAccent, fontWeight: FontWeight.bold),
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
                  SingleColumnRow(
                    txtString: "${Statics.getLabel('Total')} ${Statics.getLabel('Vasti')} ",
                    value: totalVastiCount.toString(),
                  ),
                  SingleColumnRow(
                    txtString: "${Statics.getLabel('pratinidhitva')} ${Statics.getLabel('Vasti')} ",
                    value: selectedVastiCount.toString(),
                  ),
                  SingleColumnRow(
                    txtString: "${Statics.getLabel('average')} ${Statics.getLabel('pratinidhitva')} ",
                    value: "${totalVastiCount > 0 ? ((selectedVastiCount! / totalVastiCount) * 100).toStringAsFixed(0) : 0} %",
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
                    value: "$totalShakhaCount",
                  ),
                  SingleColumnRow(
                    txtString: " ${Statics.getLabel('Shaakhaa')} ${Statics.getLabel('pratinidhitva')}",
                    value: "$selectedShakhaCount",
                  ),
                  SingleColumnRow(
                    txtString: " ${Statics.getLabel('Shaakhaa')} ${Statics.getLabel('average')} ${Statics.getLabel('pratinidhitva')} ",
                    value: "$averageShakhaCount %",
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
                    value: "$totalMilanCount",
                  ),
                  SingleColumnRow(
                    txtString: " ${Statics.getLabel('SaaptaahikMilan')} ${Statics.getLabel('pratinidhitva')} ",
                    value: "$selectedMilanCount",
                  ),
                  SingleColumnRow(
                    txtString: " ${Statics.getLabel('SaaptaahikMilan')} ${Statics.getLabel('average')} ${Statics.getLabel('pratinidhitva')} ",
                    value: "$averageMilanCount %",
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
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          width: 200,
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
                                  "${Statics.getLabel('selectSanghaMandali')}",
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
                    txtString: "${Statics.getLabel('Total')} ${Statics.getLabel('milanMandali')} ",
                    value: "$totalSanghaMandaliCount",
                  ),
                  SingleColumnRow(
                    txtString: " ${Statics.getLabel('milanMandali')} ${Statics.getLabel('pratinidhitva')} ",
                    value: "$selectedSanghaMandaliCount",
                  ),
                  SingleColumnRow(
                    txtString: "${Statics.getLabel('milanMandali')}  ${Statics.getLabel('average')}  ${Statics.getLabel('pratinidhitva')} ",
                    value: "$averageSanghaMandaliCount %",
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
                    value: "${totalShakhaCount + totalMilanCount + totalSanghaMandaliCount}",
                  ),

                  // ✅ Selected
                  SingleColumnRow(
                    txtString: "${Statics.getLabel('Total')}  ${Statics.getLabel('pratinidhitva')}",
                    value: "${selectedShakhaCount + selectedMilanCount + selectedSanghaMandaliCount}",
                  ),

                  // ✅ Average (calculated from above two)
                  SingleColumnRow(
                    txtString: "${Statics.getLabel('Total')}  ${Statics.getLabel('average')}  ${Statics.getLabel('pratinidhitva')} ",
                    value: (() {
                      final total = totalShakhaCount + totalMilanCount + totalSanghaMandaliCount;
                      final selected = selectedShakhaCount + selectedMilanCount + selectedSanghaMandaliCount;

                      if (total == 0) return "0 %";
                      final avg = ((selected / total) * 100).round();
                      return "$avg %";
                    })(),
                  ),
                ],
              ),
            ),
// ================================== 7 QUESTIONS Box ==================================================================================================================================================================================================================================================================================================================================================
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
                      txtString: "${Statics.getLabel('Total')} ",
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
                )),
//==============================  SUBMIT BUTTON =======================================================================
            Container(
              child: MaterialButton(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                color: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                onPressed: () {
                  if (_isSearching == false) {
                    Fluttertoast.showToast(
                      msg: "${Statics.getLabel('NagarSelectionImportant')}",
                    );
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

  Future<void> submitForm() async {
    Map<String, dynamic> formData = {
      "GeoUnitID": int.parse(selctedLevelId!),
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
    };

    String formattedJson = const JsonEncoder.withIndent('  ').convert(formData);
    log("Form Data (JSON):\n$formattedJson");
    await Statics.saveVijayaDashamiUtsavData(context, formData);
    getFormData();
  }

  GetVijayadashamiDataByGeoUnitModel? getVijayaDashamiUtsavDataByGeounitData;

  Future<void> getFormData() async {
    Map<String, dynamic> formData = {
      "GeoUnitID": int.parse(selctedLevelId!),
      "AppUserID": int.parse(Statics.userDetails['userID']),
      "isnagar": int.parse(utsavKontyaStaravar!),
    };

    String formattedJson = const JsonEncoder.withIndent('  ').convert(formData);
    log("Form Data (JSON):\n$formattedJson");
    getVijayaDashamiUtsavDataByGeounitData = await Statics.getVijayaDashamiUtsavDataByGeounit(context, formData);
    log("getVijayaDashamiUtsavDataByGeounitData $getVijayaDashamiUtsavDataByGeounitData");
    setState(() {
      VijayadashamiUtsav utsav = getVijayaDashamiUtsavDataByGeounitData!.vijayadashamiUtsav!;

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
