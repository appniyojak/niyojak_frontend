import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../helpers/static_data.dart' as Statics;
import '../models/response_model/nirikshan_baithak_vrutta.dart';
import '../providers/bals.dart';
import '../utils/globals.dart';
import '../utils/stable_geounit_class.dart';

class NirikshanAnnualBaithakVrutta extends StatefulWidget {
  static const routeName = '/search-nirikshan-annual-baithak-vrutta';

  @override
  _NirikshanAnnualBaithakVruttaState createState() => _NirikshanAnnualBaithakVruttaState();
}

class _NirikshanAnnualBaithakVruttaState extends State<NirikshanAnnualBaithakVrutta> {
  bool _isLoading = false;
  bool _isSearching = false;
  bool _isExpanded = false;

  List<StaticMasterBAL>? _baithakTypes;

  String? _baithakTypeValue = '';

  int? _baithakType;
  String _selectedNagarAndBaithak = '';

  List<String> exportList = [];
  List<List<String>> donloadexportList = [];

  int? selectedViewOnly = 1;

  NIrikshanBiathakVruttaModel? nirikshanBaithakVrutta;
  List fullDataSubmit = [];
  List halfDataSubmit = [];
  List noDataSubmit = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
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

    populateDropdown();

    setState(() {});
  }

  Future<void> populateDropdown({bool fromClear = false}) async {
    var data = await Statics.getStaticLDB('AnnualBaithakType');
    if (!mounted) return;
    _baithakTypes = data;
    _baithakTypes = data!.where((element) => element.showAnnualBaithakkey!.contains('1')).toList();
    // _baithakTypes = _baithakTypes!.where((element) => element.code!.contains(DateTime.now().year.toString())).toList();
    setState(() {});
  }

  Future<dynamic> _getNirikshanVrutta(BuildContext context, String? _selctedLevel, int? baithakTypeID, String? _selectedGeoUnitId) async {
    bool isConnected = await Statics.isInternetConnected();
    if (isConnected) {
      String strInput = json.encode({
        "type": _selctedLevel,
        "AnnualBaithakTypeID": baithakTypeID,
        "locid": _selectedGeoUnitId,
        "AppUserID": Statics.userDetails["userID"],
      });
      nirikshanBaithakVrutta = await Statics.getNirikshanAnnualBaithakNagarVruttaForApp(strInput);
      setState(() {
        fullDataSubmit = nirikshanBaithakVrutta!.getbaithakvarshiklist!.where((e) => e.full == 1).toList();
        halfDataSubmit = nirikshanBaithakVrutta!.getbaithakvarshiklist!.where((e) => e.half == 1).toList();
        noDataSubmit = nirikshanBaithakVrutta!.getbaithakvarshiklist!.where((e) => e.notstarted == 1).toList();
      });

      print("fullDataSubmit ==> ${fullDataSubmit.length}");
      print("halfDataSubmit ==> ${halfDataSubmit.length}");
      print("noDataSubmit ==> ${noDataSubmit.length}");
      print("Complete data  ==> ${nirikshanBaithakVrutta!.getbaithakvarshiklist!.length}");
    } else {
      Statics.showMessageDialog(context, Statics.getLabel('internetNotConnected'));
      return null;
    }
    setState(() {
      _isSearching = false;
      _isLoading = false;
      _isExpanded = false;
    });
  }

  Future<void> _search(String? _selctedLevel, String? _selectedGeoUnitId) async {
    print("searching");
    setState(() {
      _isSearching = true;
      _isLoading = true;
      fullDataSubmit = [];
      halfDataSubmit = [];
      noDataSubmit = [];
    });

    _getNirikshanVrutta(context, _selctedLevel, _baithakType!, _selectedGeoUnitId);
  }

  @override
  Widget build(BuildContext context) {
    var fulllength = nirikshanBaithakVrutta?.getbaithakvarshiklist?.where((e) => e.full == 1).toList();
    var halflength = nirikshanBaithakVrutta?.getbaithakvarshiklist?.where((e) => e.half == 1).toList();
    var notstartlength = nirikshanBaithakVrutta?.getbaithakvarshiklist?.where((e) => e.notstarted == 1).toList();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          Statics.getLabel('nirikshanAnnualBaithakVruttaTitle'),
          style: TextStyle(fontSize: 20),
        ),
      ),
      // drawer: AppDrawer(),
      body: SingleChildScrollView(
          child: Container(
        padding: EdgeInsets.all(20),
        width: Statics.getDeviceSize(context).width,
        child: Column(
          children: <Widget>[
            Text(
              Statics.getLabel('nirikshanAnnualBaithakVruttaTitle'),
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 10),
            Consumer<GeoHierarchyController>(builder: (_, ctrl, __) {
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
                            spacing: 10,
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

                              ////////////////////////////////////////
                              /// CONDITIONAL

                              if (ctrl.hasItems(GeoLevel.upnagarUpkhanda))
                                GeoDropdownWidget(
                                  level: GeoLevel.upnagarUpkhanda,
                                  title: 'upnagarUpkhanda',
                                  controller: ctrl,
                                ),

                              if (_baithakTypes != null)
                                DropdownSearch<String>(
                                  popupProps: PopupProps.bottomSheet(
                                    showSearchBox: true,
                                    fit: FlexFit.tight,
                                    // Ensures the popup width matches the dropdown width
                                    itemBuilder: (context, item, isSelected, val) {
                                      return Container(
                                        margin: EdgeInsets.symmetric(horizontal: 8),
                                        decoration: !isSelected
                                            ? null
                                            : BoxDecoration(
                                                border: Border.all(color: Theme.of(context).primaryColor),
                                                borderRadius: BorderRadius.circular(5),
                                                color: Colors.grey[300],
                                              ),
                                        child: ListTile(
                                          title: Text(
                                            item,
                                            style: TextStyle(fontSize: 14), // Adjust the font size here
                                          ),
                                          contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 8), // Adjust padding here
                                          visualDensity: VisualDensity(vertical: -4), // Adjust density here
                                        ),
                                      );
                                    },
                                    searchFieldProps: TextFieldProps(
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                                      ),
                                    ),
                                    constraints: BoxConstraints.tightFor(
                                      width: double.infinity, // Ensures the popup width matches the dropdown width
                                    ),
                                    containerBuilder: (context, popupWidget) {
                                      return Stack(
                                        children: [
                                          popupWidget,
                                          Positioned(
                                            right: 10,
                                            top: 10,
                                            child: IconButton(
                                              icon: Icon(Icons.close),
                                              onPressed: () {
                                                Navigator.of(context).pop(); // Close the dropdown
                                              },
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                  items: (filter, loadProps) =>
                                      _baithakTypes?.map((e) => e.codeForDisplay.toString()).where((name) => name.toLowerCase().contains(filter.toLowerCase() ?? "")).toList() ?? [],
                                  decoratorProps: DropDownDecoratorProps(
                                    decoration: InputDecoration(
                                      labelText: Statics.getLabel('baithakType'),
                                    ),
                                  ),
                                  selectedItem: _baithakTypeValue == "" ? null : _baithakTypes?.firstWhere((element) => element.staticID.toString() == _baithakTypeValue).codeForDisplay,
                                  onChanged: (value) {
                                    print(value);
                                    setState(() {
                                      selectedViewOnly = _baithakTypes?.firstWhere((element) => element.codeForDisplay == value).ViewOnly;
                                      _baithakTypeValue = _baithakTypes?.firstWhere((element) => element.codeForDisplay == value).staticID.toString();
                                    });
                                    print(selectedViewOnly);
                                  },
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
                              onPressed: () async {
                                final trail = ctrl.hierarchyNameTrail;
                                _baithakType = _baithakTypeValue == null || _baithakTypeValue == "" ? null : int.parse(_baithakTypeValue!);
                                if (_baithakTypeValue != '') {
                                  _selectedNagarAndBaithak = (_baithakTypes?.firstWhere((element) => element.staticID == _baithakType).codeForDisplay ?? "--") +
                                      ' | ' +
                                      (trail.vibhaagName ?? "--") +
                                      ' | ' +
                                      (trail.bhaagName ?? "--") +
                                      ' | ' +
                                      (trail.nagarName ?? "--") +
                                      ' | ' +
                                      (trail.upnagarName ?? "--") +
                                      ' | ';
                                  await _search(ctrl.deepestSelectedLevelName, ctrl.deepestSelectedGeoUnitId);
                                } else {
                                  Statics.showMessageDialog(context, Statics.getLabel('baithakTypeNotSelected'));
                                }
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
                                onPressed: () {
                                  setState(() {
                                    _baithakType = null;
                                    _baithakTypeValue = _selectedNagarAndBaithak = '';
                                    _isSearching = false;
                                    exportList.clear();
                                    donloadexportList.clear();
                                    fullDataSubmit = [];
                                    halfDataSubmit = [];
                                    noDataSubmit = [];
                                    nirikshanBaithakVrutta = null;
                                  });
                                  populateDropdown();
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
            }),
            SizedBox(height: 20),
            Text(_selectedNagarAndBaithak!, style: TextStyle(fontSize: 18)),
            Divider(
              color: Colors.grey,
            ),
            _isLoading == true
                ? CircularProgressIndicator()
                : nirikshanBaithakVrutta?.getbaithakvarshiklist == null
                    ? Container()
                    : Column(
                        children: [
                          Card(
                            child: Container(
                              padding: EdgeInsets.all(10),
                              height: fullDataSubmit.length > 20 ? 500 : 250,
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("${Statics.getLabel('completeVrutta')}  :-  ", style: TextStyle(fontWeight: FontWeight.bold)),
                                      Text("${fullDataSubmit.length}"),
                                    ],
                                  ),
                                  Divider(color: Colors.grey),
                                  fullDataSubmit.length > 0
                                      ? Expanded(
                                          child: ListView.builder(
                                            itemCount: fulllength?.length ?? 0,
                                            itemBuilder: (context, index) {
                                              var data = fulllength![index];
                                              return ListTile(
                                                title: Wrap(
                                                  children: [
                                                    Text("${index + 1})"),
                                                    Text("${data.naav}"),
                                                    if (data.prakar != "") Text("/${data.prakar}"),
                                                    if (data.vayogat != "") Text("/${data.vayogat}"),
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        )
                                      : Container(
                                          child: Text("${Statics.getLabel('NoDataFound')}"),
                                        ),
                                ],
                              ),
                            ),
                          ),
                          Card(
                            child: Container(
                              padding: EdgeInsets.all(10),
                              height: halfDataSubmit.length > 20 ? 500 : 250,
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("${Statics.getLabel('incompleteVrutta')}  :-  ", style: TextStyle(fontWeight: FontWeight.bold)),
                                      Text("${halfDataSubmit.length}"),
                                    ],
                                  ),
                                  Divider(color: Colors.grey),
                                  halfDataSubmit.length > 0
                                      ? Expanded(
                                          child: ListView.builder(
                                            itemCount: halflength?.length ?? 0,
                                            itemBuilder: (context, index) {
                                              var data = halflength![index];
                                              return ListTile(
                                                title: Wrap(
                                                  children: [
                                                    Text("${index + 1})"),
                                                    Text("${data.naav}"),
                                                    if (data.prakar != "") Text("/${data.prakar}"),
                                                    if (data.vayogat != "") Text("/${data.vayogat}"),
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        )
                                      : Container(
                                          child: Text("${Statics.getLabel('NoDataFound')}"),
                                        ),
                                ],
                              ),
                            ),
                          ),
                          Card(
                            child: Container(
                              padding: EdgeInsets.all(10),
                              height: noDataSubmit.length > 20 ? 500 : 250,
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("${Statics.getLabel('notStartVrutta')}  :-  ", style: TextStyle(fontWeight: FontWeight.bold)),
                                      Text("${noDataSubmit.length}"),
                                    ],
                                  ),
                                  Divider(color: Colors.grey),
                                  noDataSubmit.length > 0
                                      ? Expanded(
                                          child: ListView.builder(
                                            itemCount: notstartlength?.length ?? 0,
                                            itemBuilder: (context, index) {
                                              var data = notstartlength![index];
                                              return ListTile(
                                                title: Wrap(
                                                  children: [
                                                    Text("${index + 1})"),
                                                    Text("${data.naav}"),
                                                    if (data.prakar != "") Text("/${data.prakar}"),
                                                    if (data.vayogat != "") Text("/${data.vayogat}"),
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        )
                                      : Container(
                                          child: Text("${Statics.getLabel('NoDataFound')}"),
                                        ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
          ],
        ),
      )),
    );
  }
}
