import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:niyojak_prod/screens/shatabdi_vrutta_sankalan/vijayadashami/vijaya_dashami_report.dart';
import 'package:niyojak_prod/widgets/app_drawer.dart';
import 'package:niyojak_prod/widgets/single_column_row.dart';

import '../../../helpers/static_data.dart' as Statics;
import '../../../models/response_model/vijayaDashamiInitModel.dart';
import '../../../providers/bals.dart';

class VijayadashamiFormView extends StatefulWidget {
  static const String routeName = '/vijayadashami-form-view';

  const VijayadashamiFormView({super.key});

  @override
  State<VijayadashamiFormView> createState() => _VijayadashamiFormViewState();
}

class _VijayadashamiFormViewState extends State<VijayadashamiFormView> {
  final _formKey = GlobalKey<FormState>();

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
  }

  void clearForm() async {
    setState(() {
      programNirdharitVed = 2;
      vaiyaktikGitKantashtha = 2;
      programHishobh24Hour = 2;
      sanchalanZaleKa = 2;
      sanchalanSadandaZalKa = 2;
      sanchalanGhoshVadanZalKa = 2;
      // savedPatGanAnyaEntries = [];
      presentMatrushaktiController.clear();
      presentMaleController.clear();
      _isExpanded = false;

      // Reset selected values
      _linkedMahaanagarValue = null;
      _linkedVibhaagValue = null;
      _linkedBhaagValue = null;
      _linkedShaharValue = null;
      _linkedNagarValue = null;
      _linkedmandalValue = null;
      _linkedgraamValue = null;
      _linkedvastiValue = null;

      // Clear data lists
      // _linkedVibhaag = null;
      _linkedBhaag = null;
      _linkedShahar = null;
      _linkedNagar = null;
      _linkedmandal = null;
      _linkedgraam = null;
      _linkedvasti = null;

      // Reset level tracking variables
      selctedLevel = '';
      selctedLevelName = '';
      selctedLevelId = null;
      populatelinkedVibhaagDropdown('');
    });
  }

  void populateDropdown() async {
    var data = await Statics.getStaticLDB('AnnualBaithakType');
    populatelinkedMahaanagarDropdown();
    populatelinkedVibhaagDropdown('');
    if (!mounted) return;
    _baithakTypes = data;
    _baithakTypes = _baithakTypes!
        .where((element) => element.showAnnualBaithakkey!.contains('1'))
        .toList();
    print("_baithakTypes :-- ${_baithakTypes}");
    setState(() {});
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedMahaanagarDropdown() async {
    var data = await Statics.getGeoUnitsByLevelAndParent(
        Statics.levels['MahaanagarLevelID'].toString(), '', '', '');
    setState(() {
      _linkedMahaanagar = data;
    });
    return data;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedBhaagDropdown(
      String vibhaagIDStr) async {
    _linkedShaharValue = _linkedNagarValue = null;
    var data = await Statics.getGeoUnitsByLevelAndParent(
        Statics.levels['BhaagLevelID'].toString(), vibhaagIDStr, 'Vibhaag', '');
    setState(() {
      _linkedBhaag = data;
    });
    return data;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedVibhaagDropdown(
      String mahaanagarIDStr) async {
    _linkedBhaagValue = null;
    var data = await Statics.getGeoUnitsByLevelAndParent(
        Statics.levels['VibhaagLevelID'].toString(),
        mahaanagarIDStr,
        (mahaanagarIDStr.isEmpty ? '' : 'Mahaanagar'),
        '');
    setState(() {
      _linkedVibhaag = data;
    });
    return data;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedShaharDropdown(
      String bhaagIDStr) async {
    _linkedShaharValue = _linkedShahar = null;
    var shDD = await Statics.getGeoUnitsByLevelAndParent(
        Statics.levels['ShaharLevelID'].toString(), bhaagIDStr, 'Bhaag', '');
    setState(() {
      _linkedShahar = (shDD.length > 0 ? shDD : null);
    });
    return shDD;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedNagarDropdown(
      String? bhaagIDStr, String? shaharIDStr) async {
    _linkedNagarValue = null;
    _linkedNagar = null;
    if (shaharIDStr != null) {
      var ngDD = await Statics.getGeoUnitsByLevelAndParent(
          Statics.levels['NagarLevelID'].toString(), shaharIDStr, 'Shahar', '');
      setState(() {
        _linkedNagar = (ngDD.length > 0 ? ngDD : null);
      });
      return ngDD;
    } else {
      var ngDD = await Statics.getGeoUnitsByLevelAndParent(
          Statics.levels['NagarLevelID'].toString(), bhaagIDStr!, 'Bhaag', '');
      setState(() {
        _linkedNagar = (ngDD.length > 0 ? ngDD : null);
      });
      return ngDD;
    }
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedMandalDropdown(
      String nagarIDStr) async {
    _linkedgraamValue = null;
    _linkedmandal = _linkedgraam = null;
    var mnDD = await Statics.getGeoUnitsByLevelAndParent(
        Statics.levels['MandalLevelID'].toString(), nagarIDStr, 'Nagar', '');
    setState(() {
      _linkedmandal = (mnDD.length > 0 ? mnDD : null);
    });
    return mnDD;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedGraamDropdown(
      String mandalIDStr) async {
    _linkedgraamValue = null;
    var gmDD = await Statics.getGeoUnitsByLevelAndParent(
        Statics.levels['GraamLevelID'].toString(), mandalIDStr, 'Mandal', '');
    setState(() {
      _linkedgraam = (gmDD.length > 0 ? gmDD : null);
    });
    return gmDD;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedVastiDropdown(
      String nagarIDStr) async {
    _linkedvastiValue = null;
    var vsDD = await Statics.getGeoUnitsByLevelAndParent(
        Statics.levels['VastiLevelID'].toString(), nagarIDStr, 'Nagar', '');
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
  final TextEditingController presentMatrushaktiController =
      TextEditingController();

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
      (sum, c) =>
          sum + (int.tryParse(c.text.trim().isEmpty ? "0" : c.text) ?? 0),
    );
  }

  Widget _numberField(TextEditingController controller,
      {TextEditingController? limitController,
      TextEditingController? otherController}) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        onChanged: (_) {
          // Validate when value changes
          if (limitController != null && otherController != null) {
            final int limit = int.tryParse(limitController.text) ?? 0;
            final int current = int.tryParse(controller.text) ?? 0;
            final int other = int.tryParse(otherController.text) ?? 0;

            // Agar current + other > limit hua to current ko adjust karo
            if (current + other > limit) {
              final int allowed = limit - other;
              controller.text = allowed < 0 ? "0" : allowed.toString();
              controller.selection = TextSelection.fromPosition(
                TextPosition(offset: controller.text.length),
              );
            }
          }
          setState(() {});
        },
        decoration: const InputDecoration(border: InputBorder.none),
      ),
    );
  }

  @override
  void dispose() {
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
    data = await Statics.getVijayadashamiInitData(
        context, Statics.userDetails["userID"], selctedLevelId);
    print("searchVijayaDashami data ${data?.vastisarsajjanshakti}");
    setState(() {});
  }

  Vastisarsajjanshakti? selectedPerson;
  Future<void> showVastiSelectionPopup(
    BuildContext context, {
    required List<Vastisarsajjanshakti> vastiList,
    Vastisarsajjanshakti? preselectedItem, // <-- pass selected item here
    required void Function(Vastisarsajjanshakti selectedItem) onSubmit,
  }) async {
    dynamic selectedItem = preselectedItem; // <-- start with preselected

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text("${Statics.getLabel('selectMukhyaAtithi')}"),
              content: SizedBox(
                width: double.maxFinite,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: vastiList.length,
                  itemBuilder: (context, index) {
                    final item = vastiList[index];
                    return RadioListTile<dynamic>(
                      title: Text(
                          "${item.name} (${item.samparkasutranava == "" ? "-" : item.samparkasutranava})"),
                      value: item,
                      groupValue: selectedItem,
                      onChanged: (value) {
                        setState(() {
                          selectedItem = value;
                        });
                      },
                    );
                  },
                ),
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    if (selectedItem != null) {
                      onSubmit(selectedItem);
                    }
                    Navigator.pop(context);
                  },
                  child: Center(child: Text("${Statics.getLabel('Submit')}")),
                ),
              ],
            );
          },
        );
      },
    );
  }

  List<Vastisarsajjanshakti> checkboxSelectedItems = [];

  Future<void> showVastiCheckboxPopup(
    BuildContext context, {
    required List<Vastisarsajjanshakti> vastiList,
    Vastisarsajjanshakti? excludeItem,
    List<Vastisarsajjanshakti>? preselectedItems, // <-- pass selected list here
    required void Function(List<Vastisarsajjanshakti> selectedItems) onSubmit,
  }) async {
    List<Vastisarsajjanshakti> filteredList =
        vastiList.where((item) => item.pkid != excludeItem?.pkid).toList();

    List<Vastisarsajjanshakti> selectedItems =
        List.from(preselectedItems ?? []);

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text("${Statics.getLabel('selectVIshishthaAtithi')}"),
              content: SizedBox(
                width: double.maxFinite,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: filteredList.length,
                  itemBuilder: (context, index) {
                    final item = filteredList[index];
                    final isSelected = selectedItems.contains(item);
                    return CheckboxListTile(
                      title: Text(
                          "${item.name} (${item.samparkasutranava == "" ? "-" : item.samparkasutranava})"),
                      value: isSelected,
                      onChanged: (bool? checked) {
                        setState(() {
                          if (checked == true) {
                            selectedItems.add(item);
                          } else {
                            selectedItems.remove(item);
                          }
                        });
                      },
                    );
                  },
                ),
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    onSubmit(selectedItems);
                    Navigator.pop(context);
                  },
                  child: Center(child: Text("${Statics.getLabel('Submit')}")),
                ),
              ],
            );
          },
        );
      },
    );
  }

  List<Upnagarmandallist> checkboxGraamVastiSelectedItems = [];
  int? selectedVastiCount = 0;
  int? totalVastiCount = 0;
  Future<void> showGraamVastiMandalUpnagarPopup(
    BuildContext context, {
    required List<Upnagarmandallist> vastiList,
    List<Upnagarmandallist>? preselectedItems,
    required void Function(List<Upnagarmandallist> selectedItems,
            int selectedCount, int totalCount)
        onSubmit,
  }) async {
    List<Upnagarmandallist> selectedItems = List.from(preselectedItems ?? []);

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Vasti Joda", // heading
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Total Vasti: ${vastiList.length}", // total count
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  Text(
                    "Selected: ${selectedItems.length}", // selected count
                    style: const TextStyle(fontSize: 14, color: Colors.blue),
                  ),
                ],
              ),
              content: SizedBox(
                width: double.maxFinite,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: vastiList.length,
                  itemBuilder: (context, index) {
                    final item = vastiList[index];
                    final isSelected = selectedItems.contains(item);

                    return CheckboxListTile(
                      title: Text(item.preferedname ?? ""),
                      value: isSelected,
                      onChanged: (bool? checked) {
                        setState(() {
                          if (checked == true) {
                            selectedItems.add(item);
                          } else {
                            selectedItems.remove(item);
                          }
                        });
                      },
                    );
                  },
                ),
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    onSubmit(
                      selectedItems,
                      selectedItems.length,
                      vastiList.length,
                    );
                    Navigator.pop(context);
                  },
                  child: Center(child: Text("${Statics.getLabel('Submit')}")),
                ),
              ],
            );
          },
        );
      },
    );
  }

  VastiCounts? countsShakhaa;
  List<Shakhaalist> checkboxShakhaSelectedItems = [];

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

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${Statics.getLabel('selectshakhaa')}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "${Statics.getLabel('Total')} ${Statics.getLabel('Shaakhaa')} : ${shakhaalist.length}",
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  Text(
                    "${Statics.getLabel('selectedTotal')} : ${selectedItems.length}",
                    style: const TextStyle(fontSize: 14, color: Colors.blue),
                  ),
                ],
              ),
              content: SizedBox(
                width: double.maxFinite,
                height: MediaQuery.of(context).size.height * 0.6,
                child: SingleChildScrollView(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Table(
                      border: TableBorder.all(color: Colors.black26),
                      defaultColumnWidth: const IntrinsicColumnWidth(),
                      columnWidths: const {
                        0: FixedColumnWidth(50),
                      },
                      children: [
                        // Header Row
                        TableRow(
                          decoration:
                              const BoxDecoration(color: Color(0xFFE0E0E0)),
                          children: const [
                            Padding(
                              padding: EdgeInsets.all(8),
                              child: Text("✔",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8),
                              child: Text("Vayogat",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8),
                              child: Text("Prakar",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8),
                              child: Text("Naam",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),

                        // Data Rows
                        ...shakhaalist.map((item) {
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
                                child: Text(item.vayogatname ?? ""),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: Text(item.frequencyName ?? ""),
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
              actions: [
                ElevatedButton(
                  onPressed: () {
                    // ✅ Store selected items in global list
                    checkboxShakhaSelectedItems = List.from(selectedItems);

                    // ✅ Agar aapko counts bhi chahiye (group by prakar & vayogat)
                    final Map<String, int> prakarCounts = {};
                    for (var item in selectedItems) {
                      final key = item.frequencyName ?? "Unknown";
                      prakarCounts[key] = (prakarCounts[key] ?? 0) + 1;
                    }

                    final Map<String, int> vayogatCounts = {};
                    for (var item in selectedItems) {
                      final key = item.vayogatname ?? "Unknown";
                      vayogatCounts[key] = (vayogatCounts[key] ?? 0) + 1;
                    }

                    final counts = VastiCounts(
                      prakarCounts: prakarCounts,
                      vayogatCounts: vayogatCounts,
                    );

                    // ✅ Callback fire karna (parent ko data dena)
                    onSubmit(selectedItems, counts);

                    Navigator.pop(context);
                  },
                  child: Center(child: Text("${Statics.getLabel('Submit')}")),
                ),
              ],
            );
          },
        );
      },
    );
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
                Navigator.of(context)
                    .pushNamed(VijayadashamiFormReport.routeName);
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
//=======================================   SEARCH FILTERS ==========================================================================================
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
                      title: Text(
                        Statics.getLabel('selectStar'),
                        style: TextStyle(
                            color: Colors.purpleAccent,
                            fontWeight: FontWeight.bold),
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
                            decoration: InputDecoration(
                                labelText: Statics.getLabel('Mahaanagar')),
                            isExpanded: true,
                            value: _linkedMahaanagarValue == ""
                                ? null
                                : _linkedMahaanagarValue,
                            items: _linkedMahaanagar!
                                .map((bg) => DropdownMenuItem(
                                    value: bg.geoUnitID.toString(),
                                    child: Text(bg.name!)))
                                .toList(),
                            onChanged: (value) {
                              final selectedItem = _linkedMahaanagar!
                                  .firstWhere(
                                      (bg) => bg.geoUnitID.toString() == value);
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
                            decoration: InputDecoration(
                                labelText: Statics.getLabel('Vibhaag')),
                            isExpanded: true,
                            value: _linkedVibhaagValue == ""
                                ? null
                                : _linkedVibhaagValue,
                            items: _linkedVibhaag!
                                .map((bg) => DropdownMenuItem(
                                    value: bg.geoUnitID.toString(),
                                    child: Text(bg.name!)))
                                .toList(),
                            onChanged: (value) {
                              final selectedItem = _linkedVibhaag!.firstWhere(
                                  (bg) => bg.geoUnitID.toString() == value);
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
                            decoration: InputDecoration(
                                labelText: Statics.getLabel('Bhaag')),
                            isExpanded: true,
                            value: _linkedBhaagValue == ""
                                ? null
                                : _linkedBhaagValue,
                            items: _linkedBhaag!
                                .map((bg) => DropdownMenuItem(
                                    value: bg.geoUnitID.toString(),
                                    child: Text(bg.name!)))
                                .toList(),
                            onChanged: (value) {
                              final selectedItem = _linkedBhaag!.firstWhere(
                                  (bg) => bg.geoUnitID.toString() == value);
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
                            decoration: InputDecoration(
                                labelText: Statics.getLabel('Nagar')),
                            isExpanded: true,
                            value: _linkedNagarValue == ""
                                ? null
                                : _linkedNagarValue,
                            items: _linkedNagar!
                                .map((bg) => DropdownMenuItem(
                                    value: bg.geoUnitID.toString(),
                                    child: Text(bg.name!)))
                                .toList(),
                            onChanged: (value) {
                              final selectedItem = _linkedNagar!.firstWhere(
                                  (bg) => bg.geoUnitID.toString() == value);
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
                        // if (_linkedNagar != null && _linkedNagar!.length > 0)
                        //   SizedBox(
                        //     height: 10,
                        //   ),
                        // if (_linkedmandal != null && _linkedmandal!.length > 0)
                        //   DropdownButtonFormField(
                        //     decoration: InputDecoration(
                        //         labelText: Statics.getLabel('Mandal')),
                        //     isExpanded: true,
                        //     value: _linkedmandalValue == ""
                        //         ? null
                        //         : _linkedmandalValue,
                        //     items: _linkedmandal!
                        //         .map((bg) => DropdownMenuItem(
                        //             value: bg.geoUnitID.toString(),
                        //             child: Text(bg.name!)))
                        //         .toList(),
                        //     onChanged: (value) {
                        //       final selectedItem = _linkedmandal!.firstWhere(
                        //           (bg) => bg.geoUnitID.toString() == value);
                        //       setState(() {
                        //         selctedLevelName = selectedItem.name ?? "";
                        //         selctedLevel = 'Mandal';
                        //         selctedLevelId = value;
                        //
                        //         _linkedmandalValue = value;
                        //         populatelinkedGraamDropdown(value!);
                        //       });
                        //     },
                        //   ),
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
                              style: ButtonStyle(
                                  backgroundColor: MaterialStatePropertyAll(
                                      Colors.purpleAccent)),
                              onPressed: () {
                                searchVijayaDashami();
                                setState(() {
                                  _isExpanded = false;
                                  isVastiSearch = true;
                                });
                              },
                              child: Text("${Statics.getLabel('Filters')}",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                            ),
                          )
                      ],
                    ),
                  ),
                  isExpanded: _isExpanded,
                ),
              ],
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
            if (selctedLevel != "" &&
                selctedLevelName != "" &&
                isVastiSearch == true)
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
                        style: TextStyle(
                            color: Colors.purpleAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                      Text(
                        " $selctedLevelName",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 17),
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
                          showVastiSelectionPopup(
                            context,
                            vastiList: data?.vastisarsajjanshakti ?? [],
                            preselectedItem: selectedPerson,
                            onSubmit: (selectedItem) {
                              setState(() {
                                selectedPerson = selectedItem;
                                checkboxSelectedItems.remove(selectedPerson);
                              });
                            },
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          width: 130,
                          height: 35,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.purpleAccent.shade100),
                              // color:
                              //     Colors.purpleAccent.withOpacity(0.7),
                              borderRadius: BorderRadius.circular(15)),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(width: 5),
                                Text(
                                  "${Statics.getLabel('addMukhyaAtithi')}",
                                  style: TextStyle(
                                      color: Colors.purpleAccent,
                                      fontWeight: FontWeight.bold),
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
                        decoration: BoxDecoration(color: Color(0xFFE0E0E0)),
                        children: [
                          Padding(
                              padding: EdgeInsets.all(4),
                              child: Text(
                                "${Statics.getLabel('serialNo')}",
                              )),
                          Padding(
                              padding: EdgeInsets.all(4),
                              child: Text(
                                "${Statics.getLabel('Name')}",
                              )),
                          Padding(
                              padding: EdgeInsets.all(4),
                              child: Text(
                                  "${Statics.getLabel('samparkSootraNaav')}")),
                        ],
                      ),
                      TableRow(
                        children: [
                          const Padding(
                              padding: EdgeInsets.all(4), child: Text("1")),
                          Padding(
                              padding: const EdgeInsets.all(4),
                              child: Text(selectedPerson?.name ?? "")),
                          Padding(
                              padding: const EdgeInsets.all(4),
                              child: Text(
                                  selectedPerson?.samparkasutranava ?? "")),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () async {
                          await showVastiCheckboxPopup(
                            context,
                            vastiList: data?.vastisarsajjanshakti ?? [],
                            excludeItem: selectedPerson,
                            preselectedItems:
                                checkboxSelectedItems, // <-- Pass previous selections
                            onSubmit: (selectedItems) {
                              setState(() {
                                checkboxSelectedItems = selectedItems;
                              });
                            },
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          width: 150,
                          height: 35,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.purpleAccent.shade100),
                              // color:
                              //     Colors.purpleAccent.withOpacity(0.7),
                              borderRadius: BorderRadius.circular(15)),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(width: 5),
                                Text(
                                  "${Statics.getLabel('addVIshishthaAtithi')}",
                                  style: TextStyle(
                                      color: Colors.purpleAccent,
                                      fontWeight: FontWeight.bold),
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
                        decoration: BoxDecoration(color: Color(0xFFE0E0E0)),
                        children: [
                          Padding(
                              padding: EdgeInsets.all(4),
                              child: Text(
                                "${Statics.getLabel('serialNo')}",
                              )),
                          Padding(
                              padding: EdgeInsets.all(4),
                              child: Text(
                                "${Statics.getLabel('Name')}",
                              )),
                          Padding(
                              padding: EdgeInsets.all(4),
                              child: Text(
                                  "${Statics.getLabel('samparkSootraNaav')}")),
                        ],
                      ),
                      ...checkboxSelectedItems
                          .asMap()
                          .entries
                          .where((entry) =>
                              checkboxSelectedItems.indexWhere(
                                  (e) => e.pkid == entry.value.pkid) ==
                              entry.key)
                          .map((entry) {
                        int srNo = entry.key + 1;
                        final item = entry.value;
                        return TableRow(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(4),
                              child: Text(srNo.toString()),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(4),
                              child: Text(item.name ?? ""),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(4),
                              child: Text(item.samparkasutranava ?? ""),
                            ),
                          ],
                        );
                      }).toList(),
                    ],
                  ),
                ],
              ),
            ),
// ================================== 5 QUESTIONS Box ==================================================================================================================================================================================================================================================================================================================================================

            mainContainer(
              "${Statics.getLabel('swayamsewakUpastithi')}",
              Column(
                children: [
                  Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        child: Table(
                          border: TableBorder.all(color: Colors.black),
                          columnWidths: const {
                            0: FlexColumnWidth(3),
                            1: FlexColumnWidth(2),
                            2: FlexColumnWidth(3),
                            3: FlexColumnWidth(2),
                          },
                          children: [
                            // Header Row
                            // Header Row
                            TableRow(
                              decoration: BoxDecoration(
                                  color: Colors.purpleAccent.shade100),
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    "${Statics.getLabel('Vayogat')}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white, // Text color white
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    "${Statics.getLabel('patSankhyaa')}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    "${Statics.getLabel('ganveshatPresentCount')}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    "${Statics.getLabel('otherSwayamsewakPresentCount')}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            // Data Rows
                            TableRow(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                      "${Statics.getLabel('Shishu')}/${Statics.getLabel('Baal')}"),
                                ),
                                _numberField(patShishuBaalCtrl),
                                _numberField(ganShishuBaalCtrl,
                                    limitController: patShishuBaalCtrl,
                                    otherController: anyaShishuBaalCtrl),
                                _numberField(anyaShishuBaalCtrl,
                                    limitController: patShishuBaalCtrl,
                                    otherController: ganShishuBaalCtrl),
                              ],
                            ),
                            TableRow(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                      "${Statics.getLabel('MahaavidyaalayeenTarunLabel')}"),
                                ),
                                _numberField(patMahavidyaCtrl),
                                _numberField(ganMahavidyaCtrl,
                                    limitController: patMahavidyaCtrl,
                                    otherController: anyaMahavidyaCtrl),
                                _numberField(anyaMahavidyaCtrl,
                                    limitController: patMahavidyaCtrl,
                                    otherController: ganMahavidyaCtrl),
                              ],
                            ),
                            TableRow(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                      "${Statics.getLabel('TarunVyavasaayee')}"),
                                ),
                                _numberField(patTarunVyavCtrl),
                                _numberField(ganTarunVyavCtrl,
                                    limitController: patTarunVyavCtrl,
                                    otherController: anyaTarunVyavCtrl),
                                _numberField(anyaTarunVyavCtrl,
                                    limitController: patTarunVyavCtrl,
                                    otherController: ganTarunVyavCtrl),
                              ],
                            ),
                            TableRow(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                      "${Statics.getLabel('ProudhaVyavasaayeeLabel')}"),
                                ),
                                _numberField(patProudhVyavCtrl),
                                _numberField(ganProudhVyavCtrl,
                                    limitController: patProudhVyavCtrl,
                                    otherController: anyaProudhVyavCtrl),
                                _numberField(anyaProudhVyavCtrl,
                                    limitController: patProudhVyavCtrl,
                                    otherController: ganProudhVyavCtrl),
                              ],
                            ),

                            // Total Row
                            TableRow(
                              decoration: const BoxDecoration(
                                  color: Colors.amberAccent),
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text("Total",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(_getColumnTotal([
                                    patShishuBaalCtrl,
                                    patMahavidyaCtrl,
                                    patTarunVyavCtrl,
                                    patProudhVyavCtrl
                                  ]).toString()),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(_getColumnTotal([
                                    ganShishuBaalCtrl,
                                    ganMahavidyaCtrl,
                                    ganTarunVyavCtrl,
                                    ganProudhVyavCtrl
                                  ]).toString()),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(_getColumnTotal([
                                    anyaShishuBaalCtrl,
                                    anyaMahavidyaCtrl,
                                    anyaTarunVyavCtrl,
                                    anyaProudhVyavCtrl
                                  ]).toString()),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
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
                          showGraamVastiMandalUpnagarPopup(
                            context,
                            vastiList: data?.vastimandallist ?? [],
                            preselectedItems: checkboxGraamVastiSelectedItems,
                            onSubmit:
                                (selectedItems, selectedCount, totalCount) {
                              print("Selected: $selectedCount / $totalCount");
                              setState(() {
                                totalVastiCount = totalCount;
                                selectedVastiCount = selectedCount;
                              });
                              print(
                                  "Selected Items: ${selectedItems.map((e) => e.geoUnitName)}");
                            },
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          width: 120,
                          height: 35,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.purpleAccent.shade100),
                              borderRadius: BorderRadius.circular(15)),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(width: 5),
                                Text(
                                  "${Statics.getLabel('addVasti')}",
                                  style: TextStyle(
                                      color: Colors.purpleAccent,
                                      fontWeight: FontWeight.bold),
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
                    txtString:
                        "${Statics.getLabel('Total')} ${Statics.getLabel('Vasti')} ",
                    value: totalVastiCount.toString(),
                  ),
                  SingleColumnRow(
                    txtString:
                        "${Statics.getLabel('pratinidhitva')} ${Statics.getLabel('Vasti')} ",
                    value: selectedVastiCount.toString(),
                  ),
                  SingleColumnRow(
                    txtString:
                        "${Statics.getLabel('average')} ${Statics.getLabel('upastithi')} ",
                    value:
                        "${((selectedVastiCount! / totalVastiCount!) * 100).toStringAsFixed(2)} %",
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
                          showShakhaalistPopup(
                            context,
                            shakhaalist: data?.shakhaalist ?? [],
                            preselectedItems: checkboxShakhaSelectedItems,
                            onSubmit: (selectedItems, counts) {
                              setState(() {
                                checkboxShakhaSelectedItems = selectedItems;
                                countsShakhaa = counts; // model me store
                              });

                              print(
                                  "Selected Items: ${selectedItems.map((e) => e.geoUnitName)}");
                              print("Prakar Counts: ${counts.prakarCounts}");
                              print("Vayogat Counts: ${counts.vayogatCounts}");
                            },
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          width: 120,
                          height: 35,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.purpleAccent.shade100),
                              borderRadius: BorderRadius.circular(15)),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(width: 5),
                                Text(
                                  "${Statics.getLabel('addshakhaa')}",
                                  style: TextStyle(
                                      color: Colors.purpleAccent,
                                      fontWeight: FontWeight.bold),
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
                    txtString:
                        "${Statics.getLabel('Total')} ${Statics.getLabel('Vasti')} ",
                    value: totalVastiCount.toString(),
                  ),
                  SingleColumnRow(
                    txtString:
                        "${Statics.getLabel('pratinidhitva')} ${Statics.getLabel('Vasti')} ",
                    value: selectedVastiCount.toString(),
                  ),
                  SingleColumnRow(
                    txtString:
                        "${Statics.getLabel('average')} ${Statics.getLabel('upastithi')} ",
                    value:
                        "${((selectedVastiCount! / totalVastiCount!) * 100).toStringAsFixed(2)} %",
                  )
                ],
              ),
            ),
// ================================== 7 QUESTIONS Box ==================================================================================================================================================================================================================================================================================================================================================
            mainContainer(
              "${Statics.getLabel('otherInfo')}",
              Column(
                children: [
                  textControllerField2(
                      name: Statics.getLabel("presentMatrushakti"),
                      controller: presentMatrushaktiController,
                      keyboardType: TextInputType.number),
                  textControllerField2(
                      name: Statics.getLabel("presentMale"),
                      controller: presentMaleController,
                      keyboardType: TextInputType.number),
                ],
              ),
            ),
//==============================  SUBMIT BUTTON =======================================================================
            Container(
              child: MaterialButton(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                color: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50)),
                onPressed: () {
                  submitForm();
                },
                child: Text(
                  Statics.getLabel('Submit'),
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
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
    bool isTextBold = true, // <-- NEW argument
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
                  fontWeight: isTextBold
                      ? FontWeight.bold
                      : FontWeight.normal, // <-- toggle bold
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
        SizedBox(height: 5),
        Container(
          height: height,
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            inputFormatters: keyboardType == TextInputType.number
                ? [FilteringTextInputFormatter.allow(RegExp(r'^[0-9]*$'))]
                : [],
            decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              filled: true,
              fillColor: Colors.white,
              hintText: hintTextString,
            ),
            readOnly: isEdit,
            maxLength: maxInput,
            buildCounter: (context,
                    {int? currentLength, int? maxLength, bool? isFocused}) =>
                null,
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }

  Widget mainContainer(String header, Widget child) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        // padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.purpleAccent),
            borderRadius: BorderRadius.all(Radius.circular(10))),

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
            child
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
                text:
                    "${questionNumber != null ? "$questionNumber. " : ""}$question",
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
      "vastiid": int.parse(selctedLevelId!),
      "cuserid": int.parse(Statics.userDetails['userID']),
      "programNirdharitVed": programNirdharitVed,
      "vaiyaktikGitKantashtha": vaiyaktikGitKantashtha,
      "programHishobh24Hour": programHishobh24Hour,
      "maleCount": "maleController.text",
      "femaleCount": "femaleController.text",
      "sanchalanZaleKa": sanchalanZaleKa,
      "sanchalanSadandaZalKa": sanchalanSadandaZalKa,
      "sanchalanGhoshVadanZalKa": sanchalanGhoshVadanZalKa,
      "patGanAnyaEntries": "savedPatGanAnyaEntries",
      "presentMatrushakti": presentMatrushaktiController.text,
      "presentMale": presentMaleController.text,
    };
    String formattedJson = const JsonEncoder.withIndent('  ').convert(formData);
    log("Form Data (JSON):\n$formattedJson");
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
