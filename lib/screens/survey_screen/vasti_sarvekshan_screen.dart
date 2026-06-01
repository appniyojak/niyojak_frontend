import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:excel/excel.dart' as exc;
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../helpers/static_data.dart' as Statics;
import '../../models/response_model/vasti_sarvekshan_resp_model.dart';
import '../../utils/globals.dart';
import '../../utils/stable_geounit_class.dart';

class VastiSarvekshanScreen extends StatefulWidget {
  static const String routeName = '/vasti-sarvekshan-view';

  const VastiSarvekshanScreen({super.key});

  @override
  State<VastiSarvekshanScreen> createState() => _VastiSarvekshanScreenState();
}

class _VastiSarvekshanScreenState extends State<VastiSarvekshanScreen> {
  bool _isExpanded = true;
  bool _searched = false;
  bool fromVasti = false;

  String? selectedType;

  VastiSarvekshanRespModel? data;

  List<String> typeList = [
    "vasahat",
    "sajjan",
    "anya",
    "mahatvacesana",
    "samajikkaryakram",
    "mothevyavasayi",
    "motherugnalaya",
    "school",
    "maidan",
    "karyakram",
    "dhaarmik",
    "durjan",
    "hinduvirayadi",
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => initData());
  }

  Future<void> initData() async {
    final dm = await MyAppGlobals.getLevelLDB();

    final controller = context.read<GeoHierarchyController>();

    await controller.initialize(dm, fetchMode: fromVasti ? GeoHierarchyFetchMode.vastiOnly : GeoHierarchyFetchMode.mandalOnly);

    setState(() {});
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fromVasti = ModalRoute.of(context)?.settings.arguments as bool? ?? false;

    print("fromVasti :----$fromVasti");
  }

  //////////////////////////////////////////////////////////////////////////////////////

  getReportDataFun() async {
    final _controller = context.read<GeoHierarchyController>();
    setState(() {
      data = null;
      // _isLoading = true;
    });
    Map<String, dynamic> formData = {
      "GeoUnitID": int.tryParse(_controller.deepestSelectedGeoUnitId ?? "0") ?? 0,
      "type": selectedType,
      "AppUserID": int.tryParse(Statics.userDetails['userID']) ?? null,
    };

    String formattedJson = const JsonEncoder.withIndent('  ').convert(formData);
    log("Form Data (JSON):\n$formattedJson");
    data = await Statics.getVastiSarvekshanDataDump(context, formData);
    // log("vijayadashamiReport >>>>>>>>>>>>>>>>> ${jsonDecode(jsonEncode(vijayadashamiReport))}");
    setState(() {
      data;
    });
  }

  List<dynamic> getSelectedList() {
    if (data == null || selectedType == null) return [];

    switch (selectedType) {
      case "vasahat":
        return data?.vasahatList ?? [];
      case "sajjan":
        return data?.sajjanList ?? [];
      case "anya":
        return data?.anyaList ?? [];
      case "mahatvacesana":
        return data?.mahatvaCesanaList ?? [];
      case "samajikkaryakram":
        return data?.samajikKaryakramList ?? [];
      case "mothevyavasayi":
        return data?.motheVyavasayiList ?? [];
      case "motherugnalaya":
        return data?.motherUgnalayaList ?? [];
      case "school":
        return data?.schoolList ?? [];
      case "maidan":
        return data?.maidanList ?? [];
      case "karyakram":
        return data?.karyakramList ?? [];
      case "dhaarmik":
        return data?.dharmikList ?? [];
      case "durjan":
        return data?.durjanList ?? [];
      case "hinduvirayadi":
        return data?.hinduVirayadiList ?? [];
      default:
        return [];
    }
  }

  List<dynamic> selectedList = [];

  Future<void> exportSelectedTypeToExcel() async {
    final list = getSelectedList();

    if (list.isEmpty) {
      print("No data to export");
      return;
    }

    // Ask storage permission
    await Permission.storage.request();

    var excel = exc.Excel.createExcel();
    exc.Sheet sheet = excel['Report'];

    // Original keys
    final keys = list.first.toJson().keys.toList();

    // Formatted headers
    final translatedHeader = keys.map((k) => Statics.getLabel(k.toString().toLowerCase(), returnKey: true)).toList();

    // 🔹 Header row
    sheet.appendRow(translatedHeader);

    // 🔹 Blank row (space between header & data)
    sheet.appendRow(List.filled(translatedHeader.length, ""));

    // Generate headers
    final headers = list.first.toJson().keys.toList();

    // Data rows
    for (var item in list) {
      final json = item.toJson();
      sheet.appendRow(headers.map((h) => json[h]?.toString() ?? "").toList());
    }

    // Save file
    Directory directory;

    if (Platform.isAndroid) {
      directory = (await getExternalStorageDirectory())!;
    } else {
      directory = await getApplicationDocumentsDirectory();
    }

    final filePath = "${directory.path}/${selectedType}_${DateTime.now().millisecondsSinceEpoch}.xlsx";

    final fileBytes = excel.encode();
    final file = File(filePath);
    await file.writeAsBytes(fileBytes!);

    print("Excel Exported: $filePath");

    // 🔹 Open the file using OpenFilex
    await OpenFilex.open(filePath);
  }

  /////////////////////////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          Statics.getLabel(fromVasti ? 'vastiSurveyReport' : 'mandalSurveyReport'),
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      // drawer: AppDrawer(),
      floatingActionButton: _searched && selectedList.isNotEmpty
          ? FloatingActionButton(
              tooltip: Statics.getLabel("ExportToExcel"),
              onPressed: exportSelectedTypeToExcel,
              child: Icon(Icons.download_sharp),
              backgroundColor: Colors.green,
            )
          : null,
      body: Column(
        children: [
          vastiMandalDropdown(),
          if (_searched) ...[
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Divider(color: Colors.black),
            ),
            SizedBox(height: 18),
            Expanded(
              child: selectedList.isEmpty
                  ? Center(
                      child: Text("No Data Found"),
                    )
                  : Scrollbar(
                      thumbVisibility: true,
                      child: ListView.builder(
                        padding: EdgeInsets.only(right: 16, left: 16, top: 8, bottom: 90),
                        itemCount: selectedList.length,
                        itemBuilder: (context, index) {
                          final item = selectedList[index];

                          return commonInfoCard(
                            item,
                            () => showPersonDetailsPopup(context, item, index + 1),
                          );
                        },
                      ),
                    ),
            )
          ]
        ],
      ),
    );
  }

  Widget vastiMandalDropdown() {
    return Consumer<GeoHierarchyController>(builder: (_, ctrl, __) {
      return Column(
        children: [
          Container(
            // margin: EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(width: 0.7, color: Colors.grey.shade700),
            ),
            margin: EdgeInsets.only(left: 16, right: 16, top: 24),
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
                        GeoDropdownWidget(
                          level: GeoLevel.Mahaanagar,
                          title: 'Mahaanagar',
                          controller: ctrl,
                          fetchMode: fromVasti ? GeoHierarchyFetchMode.vastiOnly : GeoHierarchyFetchMode.mandalOnly,
                          onChanged: (p0) => setState(() => _searched = false),
                        ),

                        // if (ctrl.hasItems(GeoLevel.vibhaag))
                        GeoDropdownWidget(
                          level: GeoLevel.Vibhaag,
                          title: 'Vibhaag',
                          controller: ctrl,
                          fetchMode: fromVasti ? GeoHierarchyFetchMode.vastiOnly : GeoHierarchyFetchMode.mandalOnly,
                          onChanged: (p0) => setState(() => _searched = false),
                        ),

                        if (ctrl.hasItems(GeoLevel.Bhaag))
                          GeoDropdownWidget(
                            level: GeoLevel.Bhaag,
                            title: 'Bhaag',
                            controller: ctrl,
                            fetchMode: fromVasti ? GeoHierarchyFetchMode.vastiOnly : GeoHierarchyFetchMode.mandalOnly,
                            onChanged: (p0) => setState(() => _searched = false),
                          ),

                        if (ctrl.hasItems(GeoLevel.Nagar))
                          GeoDropdownWidget(
                            level: GeoLevel.Nagar,
                            title: 'Nagar',
                            controller: ctrl,
                            fetchMode: fromVasti ? GeoHierarchyFetchMode.vastiOnly : GeoHierarchyFetchMode.mandalOnly,
                            onChanged: (p0) => setState(() => _searched = false),
                          ),

                        /// CONDITIONAL

                        if (ctrl.hasItems(GeoLevel.upnagarUpkhanda))
                          GeoDropdownWidget(
                            level: GeoLevel.upnagarUpkhanda,
                            title: 'upnagarUpkhanda',
                            controller: ctrl,
                            fetchMode: fromVasti ? GeoHierarchyFetchMode.vastiOnly : GeoHierarchyFetchMode.mandalOnly,
                            onChanged: (p0) => setState(() => _searched = false),
                          ),

                        if (ctrl.hasItems(GeoLevel.Mandal))
                          GeoDropdownWidget(
                            level: GeoLevel.Mandal,
                            title: 'Mandal',
                            controller: ctrl,
                            onChanged: (p0) => setState(() => _searched = false),
                          ),

                        if (ctrl.hasItems(GeoLevel.Graam))
                          GeoDropdownWidget(
                            level: GeoLevel.Graam,
                            title: 'Graam',
                            controller: ctrl,
                            onChanged: (p0) => setState(() => _searched = false),
                          ),

                        if (ctrl.hasItems(GeoLevel.Vasti))
                          GeoDropdownWidget(
                            level: GeoLevel.Vasti,
                            title: 'Vasti',
                            controller: ctrl,
                            onChanged: (p0) => setState(() => _searched = false),
                          ),
                        SizedBox(height: 15),
                        _buildDropdownField(
                          label: Statics.getLabel('SelectFrequency'),
                          value: selectedType,
                          items: typeList
                              .map((v) => DropdownMenuItem(
                                    value: v.toString(),
                                    child: Text(Statics.getLabel(v)),
                                  ))
                              .toList(),
                          onChanged: (value) => setState(() {
                            selectedType = value;
                            _searched = false;
                          }),
                          isDisabled: false,
                        ),
                        SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // if ( selectedType != null)
                            MaterialButton(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                              padding: EdgeInsets.symmetric(
                                horizontal: 35,
                                vertical: 5,
                              ),
                              color: Theme.of(context).primaryColor,
                              textColor: Theme.of(context).primaryTextTheme.labelMedium?.color,
                              onPressed: () async {
                                if (selectedType == null) {
                                  Statics.showToast("please select type");
                                  return;
                                }
                                setState(() {});

                                await getReportDataFun();

                                setState(() {
                                  selectedList = getSelectedList();
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
                                    selectedType = null;
                                  });
                                  ctrl.loadHierarchyForUser();
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
          ),
          SizedBox(height: 18),
          if (_searched)
            Container(
              height: 40,
              margin: EdgeInsets.symmetric(horizontal: 16),
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
                    "${Statics.getLabel(ctrl.deepestSelectedLevelName ?? "praant")}",
                    style: TextStyle(color: Colors.purpleAccent, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  if (ctrl.deepestSelectedGeoUnitName != null && ctrl.deepestSelectedGeoUnitName != "")
                    Text(
                      "   ->   ${ctrl.deepestSelectedGeoUnitName}",
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 17),
                    ),
                ],
              ),
            ),
        ],
      );
    });
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

  Widget commonInfoCard(dynamic item, VoidCallback onView) {
    final json = item.toJson();

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        title: Text(
          MyAppGlobals.checkTextNullEmpty(json["Name"] ?? json["BhavanacheNav"] ?? json["Saan"] ?? json["ShaikshanikSansthaan"]),
        ),
        subtitle: Text(json["VastigramName"] ?? ""),
        trailing: IconButton(
          icon: const Icon(Icons.remove_red_eye, color: Colors.purple),
          onPressed: onView,
        ),
      ),
    );
  }

  List<Map<String, String>> buildDetails(dynamic item) {
    final Map<String, dynamic> jsonMap = item.toJson();

    return jsonMap.entries.map((entry) {
      return {entry.key: entry.value?.toString() ?? "--"};
    }).toList();
  }

  Future<void> showPersonDetailsPopup(BuildContext context, dynamic item, int srNo) {
    List<Map<String, String>> details = buildDetails(item);

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
                // Header
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
                        "${Statics.getLabel('moreInfo')}",
                        style: const TextStyle(
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

                // Details
                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: details.map((e) {
                        return Container(
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
                            spacing: 8,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 3,
                                child: Text(
                                  Statics.getLabel(e.keys.first.toLowerCase(), returnKey: true),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 5,
                                child: Text(
                                  e.values.first.isEmpty ? "--" : e.values.first,
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
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
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.check_circle, color: Colors.white),
                    label: Text(
                      "${Statics.getLabel('bandKara')}",
                      style: const TextStyle(fontSize: 16, color: Colors.white),
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
