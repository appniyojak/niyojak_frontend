import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../helpers/static_data.dart' as Statics;
import '../../../models/response_model/dropdown_level_responsemodel.dart';
import '../../../models/response_model/sadbhav_baithak_resp_model.dart';
import '../../../providers/sadbhav_provider.dart';
import '../../../utils/globals.dart';
import '../../../utils/stable_geounit_class.dart';

class AllBaithakTableScreen extends StatefulWidget {
  static const routeName = '/all-baithak-table-screen';

  const AllBaithakTableScreen({super.key});

  @override
  State<AllBaithakTableScreen> createState() => _AllBaithakTableScreenState();
}

class _AllBaithakTableScreenState extends State<AllBaithakTableScreen> with AutomaticKeepAliveClientMixin {
// This override is what tells Flutter to keep the state alive.
  @override
  bool get wantKeepAlive => true;

  final controller = createGeoController();

  bool _searched = false;
  bool _isExpanded = true;

  String? _selectedGeoUnitId;
  List<String> _selectedNagarIds = [];
  int? _selectedKaryakramLevelId;

  List<Bhaitakdata> kendraBaithakList = [];

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) => populateDropdown());
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) => getAllData());
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => initData());
  }

  Future<void> initData() async {
    DropDownModel dm = await MyAppGlobals.getLevelLDB();

    setState(() {
      userLevelId = dm.levelID;
      userGeoUnitId = dm.geoUnitID;
      ddm = dm;
      _selectedKaryakramLevelId = dm.levelID == 7
          ? 1
          : dm.levelID == 6
              ? 5
              : dm.levelID == 13
                  ? 6
                  : dm.levelID == 4
                      ? 7
                      : null;
      karyakramLevelsListForSadbhav = getFilteredKaryakramLevels(dm.levelID ?? 0, isSadbhav: true);
    });
    await controller.loadHierarchyForUser();
    getAllData();
  }

  getAllData() async {
    FocusManager.instance.primaryFocus?.unfocus();

    var formData = {
      "levelid": _selectedKaryakramLevelId ?? 0,
      "geounitid": int.tryParse(_selectedGeoUnitId ?? "0") ?? 0,
      "appuserid": int.parse(Statics.userDetails['userID']),
    };

    final _data = await Statics.GetAllSadbhavBaithakListData(context: context, inputJson: formData, showLoader: true);

    if (_data != null) {
      kendraBaithakList = _data.bhaitakdata ?? [];
      setState(() {
        _searched = true;
        _isExpanded = false;
      });
    }
  }

  deleteSadbhavBaithakFun(String id) async {
    FocusManager.instance.primaryFocus?.unfocus();

    var formData = {
      "ids": id,
    };

    await Statics.DeleteSadbhavBaithakData(context: context, inputJson: formData, showLoader: true) ?? [];

    setState(() {
      _searched = true;
      _isExpanded = false;
    });
  }

  clearForm() async {
    setState(() {
      kendraBaithakList = [];
      _searched = false;
      _selectedKaryakramLevelId = _selectedGeoUnitId = null;
    });
    await initData();
  }

  //////////////////////////////////////////////////////////////////////////////////////

  List<String> headers = ["serialNo", "LevelName", "centreName", "date2", "anya_upastiti_male", "anya_upastiti_matrushakti", "Total", "sadbhavReportTable2"];

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final sadbhavProvider = context.watch<SadbhavProvider>();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${Statics.getLabel('baithakDataTitle')}",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 8),
          stharDropdown(),
          SizedBox(height: 16),
          kendraBaithakList.isEmpty
              ? SizedBox(
                  height: 170,
                  child: Center(
                    child: Text(
                      Statics.getLabel("baithakNotFound"),
                      style: TextStyle(fontWeight: FontWeight.w800),
                    ),
                  ),
                )
              // : baithakListExpandableTable(),
              : Expanded(
                  child: SingleChildScrollView(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        headingRowColor: MaterialStateColor.resolveWith((_) => Colors.purple.shade100),
                        columnSpacing: 18,
                        horizontalMargin: 12,
                        border: TableBorder.all(color: Colors.black26),
                        columns: headers
                            .map((e) => DataColumn(
                                  label: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 8),
                                    constraints: const BoxConstraints(minWidth: 30, maxWidth: 130),
                                    child: Text(
                                      Statics.getLabel(e),
                                      softWrap: true,
                                      maxLines: 2,
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ))
                            .toList(),
                        rows: kendraBaithakList.asMap().entries.map((e) {
                          final index = e.key;
                          final data = e.value;
                          return DataRow(
                            cells: [
                              DataCell(Center(child: Text((index + 1).toString()))),
                              DataCell(Center(child: Text(data.stharname ?? "--"))),
                              DataCell(Center(child: Text(data.kendraname ?? "--"))),
                              DataCell(Center(child: Text(data.programdate ?? "--"))),
                              DataCell(Center(child: Text((data.male ?? 0).toString()))),
                              DataCell(Center(child: Text((data.female ?? 0).toString()))),
                              DataCell(Center(child: Text((data.totmalefemale ?? 0).toString()))),
                              DataCell(Center(child: Text((data.peoplecount ?? 0).toString()))),
                              // DataCell(PopupMenuButton(
                              //   color: Colors.white,
                              //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              //   onSelected: (value) async {
                              //     if (value == "Delete") {
                              //       showDialog(
                              //         context: context,
                              //         builder: (ctx) => AlertDialog(
                              //           title: Text(Statics.getLabel('AskConfirmation')),
                              //           content: Text(Statics.getLabel('AreyouSureYouWantToDeleteBaithak')),
                              //           actions: <Widget>[
                              //             MaterialButton(
                              //               child: Text(Statics.getLabel('ConfirmationYes')),
                              //               onPressed: () async {
                              //                 var _res = await Statics.DeleteSadbhavBaithakData(context: context, inputJson: {"id": data.pkid, "type": "vrutta"});
                              //                 if (_res) {
                              //                   Statics.showToast(Statics.getLabel('BaithakDeletedSuccessfully'));
                              //                 } else
                              //                   Statics.showToast(Statics.getLabel('errorOccurred'));
                              //                 Navigator.of(ctx).pop();
                              //                 await getBaithakListData(selectedKendra?.pkid ?? 0);
                              //               },
                              //             ),
                              //             MaterialButton(
                              //               child: Text(Statics.getLabel('ConfirmationNo')),
                              //               onPressed: () {
                              //                 Navigator.of(ctx).pop();
                              //               },
                              //             )
                              //           ],
                              //         ),
                              //       );
                              //     } else if (value == "EditMenu") {
                              //       print("EDIT >>>>>>>>>>>>>>");
                              //       await _getForm(data.pkid);
                              //       showBaithakDetailPopup(data);
                              //       // Navigator.of(context).pushNamed(SadbhavCenterCreationScreen.routeName, arguments: {"id": 0, "viewOnly": true});
                              //       // } else if (value == "baithak") {
                              //       // sadbhavProvider.updateSadbhavVal(SadbhavCenter(centername: "नवीन केंद्र", geounitname: "कोळीवाडा", sthartype: Statics.getLabel("railwayStation")));
                              //
                              //       // Navigator.of(context).pushNamed(SadbhavFormTab.routeName); //, arguments: {"id": data.pkid});
                              //     } else {
                              //       showBaithakDetailPopup(data, viewOnly: true);
                              //       // Navigator.of(context).pushNamed(SadbhavCenterCreationScreen.routeName, arguments: {"id": 0, "viewOnly": true});
                              //       // Navigator.of(context).pushNamed(SadbhavCenterListScreen.routeName); //, arguments: {"id": data.pkid, "viewOnly": true});
                              //     }
                              //   },
                              //   itemBuilder: (BuildContext context) {
                              //     return [
                              //       // Statics.MenuItem(Statics.getLabel('addinSoochi'), Icons.list, 'AddinSoochi'),
                              //       // if (showEditMenu == true)
                              //       Statics.MenuItem(Statics.getLabel('baithakVrutta'), FontAwesomeIcons.edit, 'EditMenu'),
                              //       Statics.MenuItem(Statics.getLabel('ViewMenu'), FontAwesomeIcons.eye, 'ViewMenu'),
                              //       // if (showDeleteMenu == true)
                              //       Statics.MenuItem(Statics.getLabel('Delete'), Icons.delete, 'Delete'),
                              //       // Statics.MenuItem(Statics.getLabel('baithak'), Icons.edit_note_rounded, 'baithak'),
                              //     ].map((Statics.MenuItem menuItem) {
                              //       return PopupMenuItem(
                              //         value: menuItem.menuKey,
                              //         child: ListTile(
                              //           // tileColor: Colors.white,
                              //           leading: Icon(
                              //             menuItem.iconVal,
                              //             color: Colors.purple,
                              //           ),
                              //           title: Text(menuItem.menuVal),
                              //         ),
                              //       );
                              //     }).toList();
                              //   },
                              // )),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  Widget stharDropdown() {
    return ChangeNotifierProvider.value(
      value: controller,
      child: Consumer<GeoHierarchyController>(builder: (_, ctrl, __) {
        return Container(
          margin: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          // margin: EdgeInsets.symmetric(horizontal: 16),
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
                        items: karyakramLevelsListForSadbhav
                            .map((bg) => DropdownMenuItem(
                                  value: bg.values.first.toString(),
                                  child: Text(bg.keys.first),
                                ))
                            .toList(),
                        // onTap: dateController.text.isEmpty ? null : () {},
                        onChanged: (value) async {
                          await controller.loadHierarchyForUser();
                          _searched = false;
                          // dateController.clear();
                          setState(() => _selectedKaryakramLevelId = int.tryParse(value.toString()));
                          // print("baithakId >>>>>>>>>>>>>>>> ${baithakId}");
                          await getAllData();
                        },
                        isDisabled: false,
                      ),
                      SizedBox(height: 18),
                      nagarDropdown(ctrl),
                      SizedBox(height: 18),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (_selectedGeoUnitId != null && _selectedGeoUnitId!.isNotEmpty)
                            MaterialButton(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                              padding: EdgeInsets.symmetric(
                                horizontal: 35,
                                vertical: 5,
                              ),
                              color: Theme.of(context).primaryColor,
                              textColor: Theme.of(context).primaryTextTheme.labelMedium?.color,
                              onPressed: getAllData,
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
      }),
    );
  }

  Widget nagarDropdown(GeoHierarchyController ctrl) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        children: [
          if (![6, 7].contains(_selectedKaryakramLevelId))
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

          if ([5, 6, 7].contains(_selectedKaryakramLevelId) && ctrl.hasItems(GeoLevel.Nagar))
            GeoDropdownWidget(
              level: GeoLevel.Nagar,
              title: 'Nagar',
              controller: ctrl,
              onChanged: (v) => setState(() => _searched = false),
            ),
          if ([6, 7].contains(_selectedKaryakramLevelId) && ctrl.hasItems(GeoLevel.upnagarUpkhanda))
            GeoDropdownWidget(
              level: GeoLevel.upnagarUpkhanda,
              title: 'upnagarUpkhanda',
              controller: ctrl,
              onChanged: (v) => setState(() => _searched = false),
            ),
          if ([7].contains(_selectedKaryakramLevelId) && ctrl.hasItems(GeoLevel.Mandal))
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
  }
}
