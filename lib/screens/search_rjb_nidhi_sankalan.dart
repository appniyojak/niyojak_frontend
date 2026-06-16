import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:intl/intl.dart';
import 'package:niyojak_prod/widgets/nidhi_sankalan_card.dart';
import 'package:provider/provider.dart';

import '../helpers/static_data.dart' as Statics;
import '../utils/globals.dart';
import '../utils/stable_geounit_class.dart';
import '../widgets/app_drawer.dart';

class SearchRamJanmaBhoomiNidhiSankalan extends StatefulWidget {
  static const routeName = '/search-ramjanmabhoomisankalan-screen';

  @override
  _SearchRamJanmaBhoomiNidhiSankalanState createState() => _SearchRamJanmaBhoomiNidhiSankalanState();
}

class _SearchRamJanmaBhoomiNidhiSankalanState extends State<SearchRamJanmaBhoomiNidhiSankalan> {
  final _searchController = TextEditingController();
  bool _isSearching = false;

  bool _isSahabhaagiOrVishesh = false;
  bool _isExpanded = false;

  Future<List<dynamic>>? _sankalanList;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => initData());
  }

  Future<void> initData() async {
    final dm = await MyAppGlobals.getLevelLDB();

    final controller = context.read<GeoHierarchyController>();

    await controller.initialize(dm);

    _sankalanList = _getSankalanVruttaList(-1, "", "get nothing");

    setState(() {});
  }

  Future<void> _search(GeoHierarchyController ctr, String strType, var ctx) async {
    setState(() {
      _isSearching = true;
    });

    if (strType == 'Search') {
      setState(() {
        _sankalanList = _getSankalanVruttaList(int.tryParse(ctr.deepestSelectedGeoUnitId ?? "0") ?? 0, _isSahabhaagiOrVishesh == true ? "VisheshVyakti" : "Participant", _searchController.text);
        _isSearching = false;
        _isExpanded = false;
      });
    } else {
      var datalist = await _getSankalanVruttaList(int.tryParse(ctr.deepestSelectedGeoUnitId ?? "0") ?? 0, _isSahabhaagiOrVishesh == true ? "VisheshVyakti" : "Participant", _searchController.text);
      _getCsv(datalist);
      setState(() {
        _isSearching = false;
        _isExpanded = false;
      });
    }
  }

  Future<List<dynamic>> _getSankalanVruttaList(int? geoUnitID, String strType, String searchString) async {
    bool isConnected = await Statics.isInternetConnected();
    if (isConnected) {
      String strInput = json.encode({"GeoUnitID": geoUnitID == null ? -1 : geoUnitID, "ParticipantOrVisheshVyakti": strType, "SearchString": searchString});
      log("strInput:----  $strInput");
      return Statics.getNidhiSankalanVruttaForApp(strInput);
    } else {
      Statics.showMessageDialog(context, Statics.getLabel('internetNotConnected'));
      return [];
    }
  }

  void _getCsv(dataList) {
    setState(() {
      _isSearching = true;
    });
    if (dataList == null || dataList.length == 0) {
      Statics.showMessageDialog(context, Statics.getLabel('noDataFoundTryAnotherSearch'));

      setState(() {
        _isSearching = false;
      });
      return;
    }
    List<List<dynamic>> rows = [];
    List<dynamic> header = [];
    header.add("GeoUnit Name");
    header.add("Name");
    header.add("Mobile");
    if (_isSahabhaagiOrVishesh == true) {
      header.add("Category");
      header.add("Remark");
      header.add("Created By");
    } else {
      header.add("Gender");
    }

    rows.add(header);
    for (int i = 0; i < dataList.length; i++) {
      var data = dataList[i];

      //row refer to each column of a row in csv file and rows refer to each row in a file
      List<dynamic> row = [];
      row.add(data["GeoUnitName"].toString());
      row.add(data["PersonName"].toString());
      row.add(data["MobileNumber"].toString());
      if (_isSahabhaagiOrVishesh == true) {
        row.add(data["CategoryCode"].toString());
        row.add(data["Remark"].toString());
        row.add(data["CreatedByName"].toString());
      } else {
        row.add(data["GenderCode"].toString());
      }

      rows.add(row);
    }

    if (rows.length > 1) {
      Statics.convertToCsv(rows, (_isSahabhaagiOrVishesh == true ? "VisheshVyakti" : "SahabhaagiKaaryakartaa") + "_" + DateFormat('ddmmyyyyHHmmss').format(DateTime.now()), context);
    }
    setState(() {
      _isSearching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          Statics.getLabel('searchRamJanmabhoomiNidhiSankalanVrutta'),
          style: TextStyle(fontSize: 24),
        ),
      ),
      drawer: AppDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(height: 10),
            Text(
              Statics.getLabel('searchSewaVastiScreenBanner'),
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 10),

            ///
            searchSection(),

            ///

            FutureBuilder<List<dynamic>>(
              future: _sankalanList,
              builder: (ctx, dataSnapshot) {
                print(dataSnapshot.connectionState.toString());
                print(dataSnapshot.hasData.toString());
                print(_isSearching.toString());
                if (dataSnapshot.connectionState != ConnectionState.done) {
                  return Center(child: CircularProgressIndicator());
                }
                if (dataSnapshot.hasError) {
                  print(dataSnapshot.error);
                  return Center(
                      child: Text(
                    'Server Error, Please Try Again Later',
                    style: TextStyle(color: Colors.red),
                  ));
                }
                return dataSnapshot.hasData && dataSnapshot.data!.length > 0
                    ? Column(
                        children: dataSnapshot.data!.map((sankalan) => NidhiSankalanCard(sankalan, (_isSahabhaagiOrVishesh == false ? 'SahabhaagiKaaryakartaa' : 'VisheshVyakti'), _search)).toList(),
                      )
                    : Center(child: Text(Statics.getLabel('noDataFoundTryAnotherSearch')));
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget searchSection() {
    return Consumer<GeoHierarchyController>(builder: (_, ctrl, __) {
      return Column(
        children: [
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
                    title: Text(Statics.getLabel('Filters')),
                  );
                },
                body: Container(
                  margin: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      GeoDropdownWidget(
                        level: GeoLevel.Mahaanagar,
                        title: 'Mahaanagar',
                        controller: ctrl,
                      ),

                      // if (ctrl.hasItems(GeoLevel.vibhaag))
                      GeoDropdownWidget(
                        level: GeoLevel.Vibhaag,
                        title: 'Vibhaag',
                        controller: ctrl,
                      ),

                      if (ctrl.hasItems(GeoLevel.Bhaag))
                        GeoDropdownWidget(
                          level: GeoLevel.Bhaag,
                          title: 'Bhaag',
                          controller: ctrl,
                        ),

                      if (ctrl.hasItems(GeoLevel.Nagar))
                        GeoDropdownWidget(
                          level: GeoLevel.Nagar,
                          title: 'Nagar',
                          controller: ctrl,
                        ),

                      if (ctrl.hasItems(GeoLevel.upnagarUpkhanda))
                        GeoDropdownWidget(
                          level: GeoLevel.upnagarUpkhanda,
                          title: 'upnagarUpkhanda',
                          controller: ctrl,
                        ),

                      if (ctrl.hasItems(GeoLevel.Mandal))
                        GeoDropdownWidget(
                          level: GeoLevel.Mandal,
                          title: 'Mandal',
                          controller: ctrl,
                        ),

                      if (ctrl.hasItems(GeoLevel.Graam))
                        GeoDropdownWidget(
                          level: GeoLevel.Graam,
                          title: 'Graam',
                          controller: ctrl,
                        ),

                      if (ctrl.hasItems(GeoLevel.Vasti))
                        GeoDropdownWidget(
                          level: GeoLevel.Vasti,
                          title: 'Vasti',
                          controller: ctrl,
                        ),
                      SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            alignment: Alignment.centerRight,
                            child: Text(
                              (_isSahabhaagiOrVishesh == false ? Statics.getLabel('SahabhaagiKaaryakartaa') : Statics.getLabel('VisheshVyakti')),
                            ),
                          ),
                          FlutterSwitch(
                            activeText: Statics.getLabel('VisheshVyakti'),
                            inactiveText: Statics.getLabel('SahabhaagiKaaryakartaa'),
                            value: _isSahabhaagiOrVishesh,
                            activeToggleColor: Color(0xFF6E40C9),
                            inactiveToggleColor: Color(0xFFffffff),
                            activeColor: Color(0xFFffffff),
                            inactiveColor: Color(0xFF6E40C9),
                            activeTextColor: Color(0xFF6E40C9),
                            inactiveTextColor: Color(0xFFffffff),
                            switchBorder: Border.all(
                              color: Color(0xFF6E40C9),
                            ),
                            valueFontSize: 10.0,
                            width: 110,
                            borderRadius: 30.0,
                            showOnOff: true,
                            onToggle: (val) {
                              setState(() {
                                _isSahabhaagiOrVishesh = val;
                              });
                            },
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: _searchController,
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(labelText: Statics.getLabel('searchRJBSVNameMobileLabel')),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
                isExpanded: _isExpanded,
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.all(20),
            child: Column(
              children: [
                if (_isSearching)
                  CircularProgressIndicator()
                else
                  Wrap(
                    children: [
                      MaterialButton(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        padding: EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 8,
                        ),
                        color: Theme.of(context).primaryColor,
                        textColor: Theme.of(context).primaryTextTheme.labelMedium?.color,
                        onPressed: () {
                          _search(ctrl, "Search", context);
                        },
                        child: Text(
                          Statics.getLabel('Search'),
                          style: TextStyle(fontSize: 25),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      MaterialButton(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        padding: EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 8,
                        ),
                        color: Theme.of(context).primaryColor,
                        textColor: Theme.of(context).primaryTextTheme.labelMedium?.color,
                        onPressed: () {
                          _search(ctrl, "ExportToExcel", context);
                        },
                        child: Wrap(
                          children: [
                            Text(
                              Statics.getLabel("ExportToExcel"),
                              style: TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      MaterialButton(
                          onPressed: () {
                            setState(() {
                              _searchController.text = "";
                              _sankalanList = Future.value(<dynamic>[]);
                              _isSahabhaagiOrVishesh = false;
                            });
                            ctrl.loadHierarchyForUser();
                          },
                          child: Text(Statics.getLabel('clear'))),
                    ],
                  ),
              ],
            ),
          ),
        ],
      );
    });
  }
}
