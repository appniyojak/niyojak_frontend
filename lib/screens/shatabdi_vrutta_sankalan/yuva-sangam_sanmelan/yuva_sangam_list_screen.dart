import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../helpers/static_data.dart' as Statics;
import '../../../models/response_model/dropdown_level_responsemodel.dart';
import '../../../models/response_model/sadbhav_baithak_resp_model.dart';
import '../../../models/response_model/sadbhav_baithak_vrutta_resp_model.dart';
import '../../../models/response_model/yuva_sangam_model.dart';
import '../../../utils/globals.dart';
import '../../../utils/stable_geounit_class.dart';
import 'add_new_karyakram_screen.dart';
import 'yuva_sangam_form_screen.dart';

class YuvaSangamListTab extends StatefulWidget {
  const YuvaSangamListTab({super.key});

  @override
  State<YuvaSangamListTab> createState() => _YuvaSangamListTabState();
}

class _YuvaSangamListTabState extends State<YuvaSangamListTab> with AutomaticKeepAliveClientMixin {
// This override is what tells Flutter to keep the state alive.
  @override
  bool get wantKeepAlive => true;

  final GlobalKey<FormState> _formKey = GlobalKey();
  SadbhavBaithakVruttaRespModel? vruttaData;

  final controller = createGeoController();

  bool _searched = false;
  bool _isExpanded = true;

  var kendraController = ExpansionTileController();
  var baithakController = ExpansionTileController();

  TextEditingController dateController = TextEditingController();
  TextEditingController txtGivenGroupNameController = TextEditingController();
  TextEditingController txtPramukhNameController = TextEditingController();
  TextEditingController txtPramukhMobileController = TextEditingController();
  TextEditingController txtCentreNameController = TextEditingController();

  // int? baithakId;
  bool _isViewOnly = false;
  bool dateWise = false;

  List<Map<String, dynamic>> _karyakramLevelsListYuva = [
    {"${Statics.getLabel("Bhaag")}": 1},
    // {"${Statics.getLabel("railwayStation")}": 2},
    // {"${Statics.getLabel("Shahar")}": 3},
    {"${Statics.getLabel("other")}": 4},
    {"${Statics.getLabel("Nagar")}": 5},
    {"${Statics.getLabel("upnagarUpkhanda")}": 6},
    {"${Statics.getLabel("Mandal")}": 7},
  ];
  int? _selectedKaryakramLevelId;

  // int? _selectedKendraId;

  List<Nagardata> nagarList = [];
  List<YuvaSangamData> kendraList = [];

  // List<Bhaitakdata> kendraBaithakList = [];
  SadbhavKendraMasterdata? selectedKendra;

  // AbhiyanSwayamsevakdata? initialData;

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) => populateDropdown());
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) => getKendraListData());
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => initData());
  }

  Future<void> initData() async {
    DropDownModel dm = await MyAppGlobals.getLevelLDB();

    await controller.initialize(dm);

    setState(() {
      userLevelId = dm.levelID;
      userGeoUnitId = dm.geoUnitID;
      ddm = dm;
      /* _selectedKaryakramLevelId = dm.levelID == 7
          ? 1
          : dm.levelID == 6
              ? 5
              : dm.levelID == 13
                  ? 6
                  : dm.levelID == 4
                      ? 7
                      : null;*/
      _karyakramLevelsListYuva = getFilteredKaryakramLevels(dm.levelID ?? 0);
    });
    getKendraListData();
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
  //   _isViewOnly = args?["viewOnly"] ?? false;
  //   baithakId = args?["id"] ?? 0;
  //   // getData();
  //   // viewType = args!.viewType;
  // }

  getKendraListData() async {
    kendraList = [];
    setState(() {});
    var formData = {
      "levelid": _selectedKaryakramLevelId ?? 0,
      "geounitid": int.tryParse(controller.deepestSelectedGeoUnitId ?? "0") ?? 0,
      "appuserid": int.parse(Statics.userDetails['userID']),
      "isdatewise": dateWise ? 1 : 0,
    };

    final _baithak = await Statics.GetYuvaSangamListData(context: context, inputJson: formData, showLoader: true);
    print("getData api HiTttttt >>>>>>>>>>>>>>>>>");

    kendraList = _baithak ?? [];
    selectedKendra = null;

    if (mounted)
      setState(() {
        _searched = true;
        _isExpanded = false;
      });
  }

  // createSadbhavBaithakFun() async {
  //   Map<String, dynamic> formData = {
  //     "id": selectedKendra?.pkid ?? 0,
  //     "date": dateController.text,
  //     "appuserid": int.parse(Statics.userDetails['userID']),
  //   };
  //
  //   String formattedJson = const JsonEncoder.withIndent('  ').convert(formData);
  //   log("Form Data (JSON):\n$formattedJson");
  //   final _res = await Statics.CreatePramukhJanData(context: context, inputJson: formData, showLoader: true);
  //   if (_res) {
  //     Statics.showToast(Statics.getLabel('dataSavedSuccessfully'));
  //     Navigator.pop(context);
  //     await getBaithakListData(selectedKendra?.pkid ?? 0);
  //   }
  //   // getFormData();
  // }

  showEditDatePopup(String date, int? id) {
    dateController.text = date;
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, set) {
          return AlertDialog(
            insetPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 24),
            title: Text(Statics.getLabel("changeDate")),
            content: SizedBox(
              width: double.infinity,
              child: TextField(
                controller: dateController,
                style: TextStyle(fontSize: 14),
                autofocus: false,
                onTap: () async {
                  DateTime? date = await showDatePicker(
                    context: context,
                    initialDate: dateController.text.isEmpty ? DateTime.now() : DateFormat("dd/MM/yyyy").parse(dateController.text),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (date != null) {
                    dateController.text = DateFormat("dd/MM/yyyy").format(date);
                    set(() {});
                  }
                },
                readOnly: true,
                decoration: InputDecoration(
                    isDense: true,
                    hintText: "DD/MM/YYYY",
                    contentPadding: EdgeInsets.only(left: 12, right: 12, top: 14, bottom: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    )),
              ),
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // if ((_linkedgraamValue != "" && _linkedgraamValue != null) || (_linkedvastiValue != "" && _linkedvastiValue != null))
                  MaterialButton(
                    minWidth: MediaQuery.sizeOf(context).width * 0.4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    padding: EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    color: Theme.of(context).primaryColor,
                    disabledColor: Colors.grey,
                    textColor: Theme.of(context).primaryTextTheme.labelMedium?.color,
                    onPressed: dateController.text.trim().isEmpty ? null : () => changeDateData(id),
                    child: Text(
                      Statics.getLabel('Submit'),
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  MaterialButton(onPressed: () => Navigator.pop(context), child: Text(Statics.getLabel('clear'))),
                ],
              ),
            ],
          );
        });
      },
    );
  }

  changeDateData(int? id) async {
    Map<String, dynamic> formData = {
      "id": id ?? 0,
      "date": dateController.text,
      "appuserid": int.parse(Statics.userDetails['userID']),
    };

    String formattedJson = const JsonEncoder.withIndent('  ').convert(formData);
    log("Form Data (JSON):\n$formattedJson");
    final _res = await Statics.UpdateYuvaSangamDateData(context: context, inputJson: formData, showLoader: true);
    if (_res) {
      Statics.showToast(Statics.getLabel('dataSavedSuccessfully'));
      Navigator.pop(context);
      // await getBaithakListData(selectedKendra?.pkid ?? 0);
    }
    await getKendraListData();
  }

  deleteYuvaSangam(int id) async {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(Statics.getLabel('AskConfirmation')),
        content: Text(Statics.getLabel('AreyouSureYouWantToDeleteSanmelan')),
        actions: <Widget>[
          MaterialButton(
            child: Text(Statics.getLabel('ConfirmationYes')),
            onPressed: () async {
              Navigator.of(ctx).pop();
              var _res = await Statics.DeleteYuvaSangamData(context: context, inputJson: {"id": id});
              if (_res) {
                Statics.showToast(Statics.getLabel('KendraDeletedSuccessfully'));
                kendraList.removeWhere((e) => e.pkid == id);
                setState(() {});
              } else {
                Statics.showToast(Statics.getLabel('errorOccurred'));
              }
              clearForm();
              // await getKendraListData();
            },
          ),
          MaterialButton(
            child: Text(Statics.getLabel('ConfirmationNo')),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  clearForm() async {
    setState(() {
      _searched = false;
      nagarList = [];
      selectedKendra = null;
      _selectedKaryakramLevelId = null;
      dateController.clear();
      txtGivenGroupNameController.clear();
    });
    // clearForm();
    await initData();
  }

  //////////////////////////////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      // appBar: AppBar(
      //   title: Text(
      //     "${Statics.getLabel('selectKaryakramLevel')}",
      //     style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
      //   ),
      // ),
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: () => Navigator.of(context).pushNamed(SadbhavCenterCreationScreen.routeName),
      //   backgroundColor: Colors.green.shade400,
      //   label: Icon(Icons.add),
      // ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Column(
            children: [
              SizedBox(height: 12),
              stharDropdown(),
              SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    buildFilterChips(),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), side: BorderSide(color: Colors.purple, width: 0.7)),
                      onPressed: () => Navigator.of(context).pushNamed(AddNewKaryakramScreen.routeName).then(
                            (value) => getKendraListData(),
                          ),
                      child: Text("+  " + Statics.getLabel("addKaryakram")),
                    )
                  ],
                ),
              ),
              SizedBox(height: 24),
              // myAreaReport(),
              kendraList.isEmpty
                  ? SizedBox(
                      height: 270,
                      child: Center(
                        child: Text(
                          Statics.getLabel("NoDataFound"),
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                    )
                  : kendraTable(),
              /* : ListView.separated(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      padding: EdgeInsets.only(bottom: 24, top: 16),
                      itemCount: kendraList.length,
                      separatorBuilder: (context, index) => SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final _item = kendraList[index];
                        return Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // ── Top Row ──────────────────────────────────────────────
                                Row(
                                  children: [
                                    // District tag
                                    Expanded(
                                      child: Wrap(
                                        children: [
                                          _TagChip(label: _karyakramLevelsListYuva.firstWhere((e) => e.values.first == _item.shatapdistharlevelid).keys.first),
                                          const SizedBox(width: 6),

                                          // // Taluka tag
                                          // _TagChip(label: _item.taluka),
                                          // const SizedBox(width: 6),

                                          // Date tag
                                          _TagChip(
                                              label: _item.yuvadate ?? "--",
                                              icon: Icons.calendar_today,
                                              iconColor: Colors.grey,
                                              onEditTap: () => showEditDatePopup(_item.yuvadate.toString(), _item.pkid)),
                                        ],
                                      ),
                                    ),

                                    // Fill button
                                    InkWell(
                                      onTap: () => deleteYuvaSangam(_item.pkid ?? 0),
                                      child: Container(
                                        padding: EdgeInsets.all(6),
                                        decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.red.withOpacity(0.4)),
                                        child: Icon(
                                          Icons.delete_forever_outlined,
                                          color: Colors.red,
                                          size: 16,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 12),

                                // ── Location Name Row ─────────────────────────────────────
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.location_on,
                                      color: Color(0xFF3B82F6),
                                      size: 20,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      _item.trailNames ?? _item.name ?? "--",
                                      style: const TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF1E293B),
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 12),

                                // ── Divider ───────────────────────────────────────────────
                                const Divider(height: 1, color: Color(0xFFE2E8F0)),

                                const SizedBox(height: 10),

                                // ── Edit Button ───────────────────────────────────────────
                                Center(
                                  child: GestureDetector(
                                    onTap: () => Navigator.of(context).pushNamed(YuvaSangamFormScreen.routeName, arguments: {
                                      "pkid": _item.pkid,
                                      "type": _karyakramLevelsListYuva.firstWhere((e) => e.values.first == _item.shatapdistharlevelid).keys.first,
                                      "date": _item.yuvadate,
                                      "geo": _item.trailNames,
                                    }).then((value) => getKendraListData()),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.edit_outlined,
                                          size: 16,
                                          color: _item.isstarted == 0 ? Color(0xFF008719) : Color(0xFFD37B31),
                                        ),
                                        SizedBox(width: 5),
                                        Text(
                                          Statics.getLabel(_item.isstarted == 0 ? "vruttaFillTitle" : "vruttaEditTitle"),
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: _item.isstarted == 0 ? Color(0xFF008719) : Color(0xFFD37B31),
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),*/
              // SizedBox(height: 18),
              // Row(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   children: [
              //     Text(
              //       "* " + Statics.getLabel('Note') + " : ",
              //       style: TextStyle(color: Colors.red.shade700, fontWeight: FontWeight.w600, decoration: TextDecoration.underline, decorationColor: Colors.red, fontStyle: FontStyle.italic),
              //     ),
              //     Expanded(
              //       child: Text(
              //         Statics.getLabel('sanvaadTip'),
              //         style: TextStyle(color: Colors.grey.shade700, fontWeight: FontWeight.w600, fontStyle: FontStyle.italic),
              //       ),
              //     ),
              //   ],
              // ),
              // SizedBox(height: 12),
              // otherAreaReport(),
              // SizedBox(height: 90),
            ],
          ),
        ),
      ),
    );
  }

  Widget kendraTable() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      scrollDirection: Axis.horizontal,
      child: DataTable(
        showCheckboxColumn: false,
        headingRowColor: MaterialStateColor.resolveWith((_) => Colors.purple.shade100),
        columnSpacing: 16,
        horizontalMargin: 12,
        border: TableBorder.all(color: Colors.black26),
        columns: [
          DataColumn(
            label: Container(
              padding: EdgeInsets.symmetric(horizontal: 8),
              constraints: const BoxConstraints(minWidth: 30, maxWidth: 130),
              child: Text(
                Statics.getLabel('serialNo'),
                softWrap: true,
                maxLines: 2,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          DataColumn(label: SizedBox()),
          DataColumn(
            label: Container(
              padding: EdgeInsets.symmetric(horizontal: 8),
              constraints: const BoxConstraints(minWidth: 30, maxWidth: 130),
              child: Text(
                Statics.getLabel('SelectLevelName'),
                softWrap: true,
                maxLines: 2,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          DataColumn(
            label: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 8),
              constraints: const BoxConstraints(minWidth: 30, maxWidth: 150),
              child: Text(
                Statics.getLabel('yuvaSangamLevel'),
                softWrap: true,
                maxLines: 2,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          DataColumn(
            label: Container(
              padding: EdgeInsets.symmetric(horizontal: 8),
              constraints: const BoxConstraints(minWidth: 30, maxWidth: 150),
              child: Text(
                Statics.getLabel('date2'),
                softWrap: true,
                maxLines: 2,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          DataColumn(label: SizedBox()),
        ],
        rows: kendraList.asMap().entries.map(
          (e) {
            final index = e.key;
            final data = e.value;
            return DataRow(
              cells: [
                DataCell(Center(child: Text((index + 1).toString()))),
                DataCell(
                  InkWell(
                    onTap: () => Navigator.of(context).pushNamed(YuvaSangamFormScreen.routeName, arguments: {
                      "pkid": data.pkid,
                      "type": _karyakramLevelsListYuva.firstWhere((e) => e.values.first == data.shatapdistharlevelid).keys.first,
                      "date": data.yuvadate,
                      "geo": data.trailNames,
                    }).then((value) => getKendraListData()),
                    child: Container(
                      padding: EdgeInsets.all(6),
                      decoration: BoxDecoration(shape: BoxShape.circle, color: (data.isstarted == 0 ? Color(0xFF008719) : Color(0xFFD37B31)).withOpacity(0.4)),
                      child: Icon(
                        Icons.edit_calendar,
                        size: 16,
                        color: data.isstarted == 0 ? Color(0xFF008719) : Color(0xFFD37B31),
                      ),
                    ),
                  ),
                ),
                DataCell(Center(child: Text(_karyakramLevelsListYuva.firstWhere((e) => e.values.first == data.shatapdistharlevelid).keys.first))),
                DataCell(Center(child: Text(data.trailNames ?? data.name ?? "--"))),
                DataCell(Center(child: Text(data.yuvadate ?? "--"))),
                DataCell(
                  InkWell(
                    onTap: () => deleteYuvaSangam(data.pkid ?? 0),
                    child: Container(
                      padding: EdgeInsets.all(6),
                      decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.red.withOpacity(0.4)),
                      child: Icon(
                        Icons.delete_forever_outlined,
                        color: Colors.red,
                        size: 16,
                      ),
                    ),
                  ),
                ),
                // DataCell(OutlinedButton(
                //   style: OutlinedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), side: BorderSide(color: Colors.purple, width: 0.7)),
                //   onPressed: () {
                //     // sadbhavProvider.updateSadbhavVal(SadbhavCenter(centername: "पार्ले", geounitname: "पार्ले", sthartype: Statics.getLabel("railwayStation")));
                //   },
                //   child: Text("+  " + Statics.getLabel("baithak")),
                // )),
              ],
            );
          },
        ).toList(),
      ),
    );
  }

  Widget buildFilterChips() {
    return Row(
      children: [
        FilterChip(
          label: Text(Statics.getLabel("Level")),
          selected: !dateWise,
          onSelected: (selected) {
            if (selected) {
              setState(() {
                dateWise = false;
              });
              getKendraListData();
            }
          },
        ),
        const SizedBox(width: 10),
        FilterChip(
          label: Text(Statics.getLabel("date2")),
          selected: dateWise,
          onSelected: (selected) {
            if (selected) {
              setState(() {
                dateWise = true;
              });
              getKendraListData();
            }
          },
        ),
      ],
    );
  }

  Widget stharDropdown() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24),
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
              margin: EdgeInsets.all(16),
              child: Column(
                children: [
                  buildDropdownField(
                    // ignoring: dateController.text.isEmpty || (baithakId != null && baithakId != 0),
                    label: Statics.getLabel('selectStar'),
                    value: _selectedKaryakramLevelId == null ? null : _selectedKaryakramLevelId.toString(),
                    items: _karyakramLevelsListYuva
                        .map((bg) => DropdownMenuItem(
                              value: bg.values.first.toString(),
                              child: Text(bg.keys.first),
                            ))
                        .toList(),
                    // onTap: dateController.text.isEmpty ? null : () {},
                    onChanged: (value) async {
                      _searched = false;
                      // dateController.clear();
                      setState(() => _selectedKaryakramLevelId = int.tryParse(value.toString()));
                      nagarList = [];
                      // print("baithakId >>>>>>>>>>>>>>>> ${baithakId}");
                      controller.loadHierarchyForUser();
                      await getKendraListData();
                    },
                    isDisabled: false,
                  ),
                  SizedBox(height: 18),
                  nagarDropdown(),
                  SizedBox(height: 18),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MaterialButton(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                        padding: EdgeInsets.symmetric(
                          horizontal: 35,
                          vertical: 5,
                        ),
                        color: Theme.of(context).primaryColor,
                        textColor: Theme.of(context).primaryTextTheme.labelMedium?.color,
                        onPressed: getKendraListData,
                        child: Text(
                          Statics.getLabel('search'),
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      MaterialButton(onPressed: clearForm, child: Text(Statics.getLabel('clear'))),
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

  Widget nagarDropdown() {
    final levelID = userLevelId == 7
        ? 1
        : userLevelId == 6
            ? 5
            : userLevelId == 13
                ? 6
                : userLevelId == 4
                    ? 7
                    : null;
    return ChangeNotifierProvider.value(
      value: controller,
      child: Consumer<GeoHierarchyController>(builder: (_, ctrl, __) {
        return Container(
          width: MediaQuery.of(context).size.width * 0.9,
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            children: [
              if (![6, 7].contains(_selectedKaryakramLevelId ?? levelID))
                GeoDropdownWidget(
                  level: GeoLevel.Mahaanagar,
                  title: 'Mahaanagar',
                  controller: ctrl,
                  onChanged: (v) => setState(() => _searched = false),
                ),

              // if (ctrl.hasItems(GeoLevel.vibhaag))
              GeoDropdownWidget(
                level: GeoLevel.Vibhaag,
                title: 'Vibhaag',
                controller: ctrl,
                onChanged: (v) => setState(() => _searched = false),
              ),

              if (ctrl.hasItems(GeoLevel.Bhaag))
                GeoDropdownWidget(
                  level: GeoLevel.Bhaag,
                  title: 'Bhaag',
                  controller: ctrl,
                  onChanged: (v) => setState(() => _searched = false),
                ),

              if ([5, 6, 7].contains(_selectedKaryakramLevelId ?? levelID) && ctrl.hasItems(GeoLevel.Nagar))
                GeoDropdownWidget(
                  level: GeoLevel.Nagar,
                  title: 'Nagar',
                  controller: ctrl,
                  onChanged: (v) => setState(() => _searched = false),
                ),

              /// CONDITIONAL
              if ([6, 7].contains(_selectedKaryakramLevelId ?? levelID) && ctrl.hasItems(GeoLevel.upnagarUpkhanda))
                GeoDropdownWidget(
                  level: GeoLevel.upnagarUpkhanda,
                  title: 'upnagarUpkhanda',
                  controller: ctrl,
                  onChanged: (v) => setState(() => _searched = false),
                ),

              if ([7].contains(_selectedKaryakramLevelId ?? levelID) && ctrl.hasItems(GeoLevel.Mandal))
                GeoDropdownWidget(
                  level: GeoLevel.Mandal,
                  title: 'Mandal',
                  controller: ctrl,
                  onChanged: (v) => setState(() => _searched = false),
                ),
              SizedBox(height: 15),
            ],
          ),
        );
      }),
    );
  }
}

class LocationCard {
  final String district;
  final String taluka;
  final String date;
  final String locationName;

  const LocationCard({
    required this.district,
    required this.taluka,
    required this.date,
    required this.locationName,
  });
}

// ── Reusable Tag Chip ─────────────────────────────────────────────────────────
class _TagChip extends StatelessWidget {
  final String label;
  final IconData? icon;
  final Color? iconColor;
  final VoidCallback? onEditTap;

  const _TagChip({
    required this.label,
    this.icon,
    this.iconColor,
    this.onEditTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onEditTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Row(
          spacing: 4,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) Icon(icon, size: 11, color: iconColor ?? Colors.grey),
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                color: Color(0xFF475569),
                fontWeight: FontWeight.w500,
              ),
            ),
            if (onEditTap != null) Icon(Icons.edit, size: 11, color: Colors.blueGrey.shade700),
          ],
        ),
      ),
    );
  }
}

// ── Fill Button ───────────────────────────────────────────────────────────────
class _FillButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _FillButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        decoration: BoxDecoration(
          color: const Color(0xFF3B82F6),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
