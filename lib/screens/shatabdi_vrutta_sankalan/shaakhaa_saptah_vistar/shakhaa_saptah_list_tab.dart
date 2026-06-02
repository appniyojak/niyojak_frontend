import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../helpers/static_data.dart' as Statics;
import '../../../models/response_model/shaakhaa_vistar_list_resp_model.dart';
import '../../../providers/bals.dart';
import '../../../utils/globals.dart';
import '../../../utils/stable_geounit_class.dart';
import '../../../widgets/shaakhaa_card.dart';
import '../../home_screen/home_screen.dart';
import 'add_new_shaakhaa_vistaar_screen.dart';
import 'shakhaa_saptah_form_screen.dart';

class ShakhaaSaptahListTab extends StatefulWidget {
  const ShakhaaSaptahListTab({super.key});

  @override
  State<ShakhaaSaptahListTab> createState() => _ShakhaaSaptahListTabState();
}

class _ShakhaaSaptahListTabState extends State<ShakhaaSaptahListTab> with AutomaticKeepAliveClientMixin {
// This override is what tells Flutter to keep the state alive.
  @override
  bool get wantKeepAlive => true;

  // static const String routeName = '/vijayadashami-form-view';
  final _searchController = TextEditingController();
  bool _isSearching = false;
  bool _searched = false;

  List<StaticMasterBAL>? _vayogat;

  // List<StaticMasterBAL>? _frequency;
  List shakhaSapMasSanghList = [];

  String? _vayogatValue;

  // String? _frequencyValue;

  bool _isExpanded = false;

  List<ShaakhaaList>? _shaakhaaList = [];
  List<ShaakhaaList> _sankalpitShaakhaaList = [];
  List<ShaakhaaList> _newShaakhaaList = [];
  List<Statics.cLatLong> _latLng = [];

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

    print("_shaakhaaList_shaakhaaList  --->>> $_shaakhaaList");

    // if(int.parse(Statics.userDetails['LevelID']) <= 2){
    //   _shaakhaaList = _getshaakhaaList(-1, "get nothing", null, null);
    //   print("_shaakhaaList_shaakhaaList  --->>> $_shaakhaaList");
    // }
    if ((int.parse(Statics.userDetails['LevelID']) > 1)) {
      // &&
      //   !(Statics.userDetails['DaayitvaName'] == 'Mukhya Shikshak' ||
      //       Statics.userDetails['DaayitvaName'] == 'मुख्य शिक्षक' ||
      //       Statics.userDetails['DaayitvaName'] == 'Kaaryavaah' ||
      //       Statics.userDetails['DaayitvaName'] == 'कार्यवाह')) {
      print("jfhdjkfh asjkhjkfhd sjkahjkhk f shkjshfk f");
    } else {
      // _shaakhaaList = await _getshaakhaaList(-1, "get nothing", null, null);
      // _shaakhaaList = await _getshaakhaaList(-1, "get nothing", null, null);
    }
  }

  Future<void> initData() async {
    final dm = await MyAppGlobals.getLevelLDB();

    final controller = context.read<GeoHierarchyController>();

    await controller.initialize(dm);

    await populateDropdown();

    setState(() {});
  }

  Future<void> populateDropdown({bool fromClear = false}) async {
    var data = await Statics.getStaticLDB('ShaakhaaVayogat');
    var data1 = await Statics.getStaticLDB('ShaakhaaFrequency');
    if (!mounted) return;
    setState(() {
      _vayogat = data;
      // _frequency = data1;
    });
  }

  Future<void> _search(String? selectedGeoUnitId, var ctx) async {
    setState(() {
      _shaakhaaList = _sankalpitShaakhaaList = _newShaakhaaList = [];
      _isSearching = true;
    });

    // int? frequencyVal = _frequencyValue == null || _frequencyValue == "" ? null : int.parse(_frequencyValue!);
    // int? vayogatVal = _vayogatValue == null || _vayogatValue == "" ? null : int.parse(_vayogatValue!);

    Map<String, dynamic> formData = {
      "GeoUnitID": int.tryParse(selectedGeoUnitId ?? "0") ?? 0,
      "AppUserID": int.tryParse(Statics.userDetails['userID']) ?? null,
      "ShaakhaaName": "",
    };

    final _list = await Statics.getShaakhaaSaptahListData(context, formData) ?? [];

    // _shaakhaaList = _getshaakhaaList(
    //     geoUnitID, _searchController.text, frequencyVal, vayogatVal);

    final _isNotSankalpitList = _list.where((e) => e.isSankalpit == false);
    final _isSankalpitList = _list.where((e) => e.isSankalpit == true);
    final _isNewSankalpitList = _list.where((e) => e.isnew == 1);

    _shaakhaaList = _isNotSankalpitList.toList();
    _sankalpitShaakhaaList = _isSankalpitList.toList();
    _newShaakhaaList = _isNewSankalpitList.toList();

    // _shaakhaaList?.removeWhere((e) => e["IsSankalpit"] == true);
    setState(() {
      _shaakhaaList;
      _sankalpitShaakhaaList;
      _newShaakhaaList;
      _isSearching = false;
      _searched = true;
      _isExpanded = false;
    });
    print(_shaakhaaList?.length);
    print(_sankalpitShaakhaaList.length);
    print(_newShaakhaaList.length);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return PopScope(
      canPop: false,
      onPopInvoked: (didpop) {
        if (didpop) return;
        Navigator.pushNamedAndRemoveUntil(context, Navigator.of(context).pushNamed(HomeScreen.routeName).toString(), (route) => false);
      },
      child: DefaultTabController(
        length: 3,
        child: Container(
          padding: EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
              Text(
                Statics.getLabel('searchShaakhaaScreenBanner'),
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 10),

              ///
              _dropdownSection(),

              ///

              if (_searched) ...[
                TabBar(labelColor: Colors.purple, unselectedLabelColor: Colors.grey, tabs: [
                  Tab(
                      child: Text(
                    Statics.getLabel("Shaakhaa"),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15),
                  )),
                  Tab(
                      child: Text(
                    Statics.getLabel("Consolidated"),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15),
                  )),
                  Tab(
                      child: Text(
                    Statics.getLabel("new"),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15),
                  )),
                ]),
                Flexible(
                  child: TabBarView(children: [
                    _shaakhaaList == null || (_shaakhaaList?.isEmpty == true)
                        ? SizedBox(
                            height: 120,
                            child: Center(
                              child: Text(Statics.getLabel("noDataFoundTryAnotherSearch")),
                            ),
                          )
                        : ListView.separated(
                            shrinkWrap: true,
                            // physics: NeverScrollableScrollPhysics(),
                            separatorBuilder: (context, index) => SizedBox(height: 8),
                            itemCount: _shaakhaaList?.length ?? 0,
                            itemBuilder: (context, index) {
                              return ShaakhaaCard(_shaakhaaList?[index].toJson(), false, _search,
                                  traillingIcon: IconButton(
                                      onPressed: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => ShakhaaSaptahFormScreen(
                                                    shaakhaa: _shaakhaaList?[index],
                                                    viewType: "EditVrutta",
                                                  ))),
                                      icon: Icon(Icons.edit)));
                            },
                          ),
                    (_sankalpitShaakhaaList.isEmpty)
                        ? SizedBox(
                            height: 120,
                            child: Center(
                              child: Text(Statics.getLabel("noDataFoundTryAnotherSearch")),
                            ),
                          )
                        : ListView.separated(
                            shrinkWrap: true,
                            // physics: NeverScrollableScrollPhysics(),
                            separatorBuilder: (context, index) => SizedBox(height: 8),
                            itemCount: _sankalpitShaakhaaList.length ?? 0,
                            itemBuilder: (context, index) {
                              return ShaakhaaCard(_sankalpitShaakhaaList[index].toJson(), _sankalpitShaakhaaList[index].isSankalpit, _search,
                                  traillingIcon: IconButton(
                                      onPressed: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => ShakhaaSaptahFormScreen(
                                                    shaakhaa: _sankalpitShaakhaaList[index],
                                                    viewType: "EditVrutta",
                                                  ))),
                                      icon: Icon(Icons.edit)));
                            },
                          ),
                    Scaffold(
                      floatingActionButton: FloatingActionButton(
                        onPressed: () => Navigator.pushNamed(context, AddNewShaakhaaVistaarScreen.routeName),
                        child: Icon(Icons.add, color: Colors.blueAccent.shade700),
                      ),
                      body: (_newShaakhaaList.isEmpty)
                          ? SizedBox(
                              height: 120,
                              child: Center(
                                child: Text(Statics.getLabel("noDataFoundTryAnotherSearch")),
                              ),
                            )
                          : ListView.separated(
                              shrinkWrap: true,
                              padding: EdgeInsets.only(bottom: 80),
                              // physics: NeverScrollableScrollPhysics(),
                              separatorBuilder: (context, index) => SizedBox(height: 8),
                              itemCount: _newShaakhaaList.length ?? 0,
                              itemBuilder: (context, index) {
                                return ShaakhaaCard(_newShaakhaaList[index].toJson(), false, _search,
                                    IsNew: true,
                                    traillingIcon: IconButton(
                                        onPressed: () => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => ShakhaaSaptahFormScreen(
                                                      shaakhaa: _newShaakhaaList[index],
                                                      viewType: "EditVrutta",
                                                    ))),
                                        icon: Column(
                                          children: [Icon(Icons.edit), Text(Statics.getLabel("Vrutta"))],
                                        )));
                              },
                            ),
                    ),
                  ]),
                )
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _dropdownSection() {
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
              if ((int.parse(Statics.userDetails['LevelID']) > 1))
                // &&
                // !(Statics.userDetails['DaayitvaName'] == 'Mukhya Shikshak' ||
                //     Statics.userDetails['DaayitvaName'] == 'मुख्य शिक्षक' ||
                //     Statics.userDetails['DaayitvaName'] == 'Kaaryavaah' ||
                //     Statics.userDetails['DaayitvaName'] == 'कार्यवाह'))
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

                        if (ctrl.hasItems(GeoLevel.Nagar))
                          GeoDropdownWidget(
                            level: GeoLevel.Nagar,
                            title: 'Nagar',
                            controller: ctrl,
                            onChanged: (v) => setState(() => _searched = false),
                          ),

                        /// CONDITIONAL
                        if (ctrl.hasItems(GeoLevel.upnagarUpkhanda))
                          GeoDropdownWidget(
                            level: GeoLevel.upnagarUpkhanda,
                            title: 'upnagarUpkhanda',
                            controller: ctrl,
                            onChanged: (v) => setState(() => _searched = false),
                          ),

                        if (ctrl.hasItems(GeoLevel.Mandal))
                          GeoDropdownWidget(
                            level: GeoLevel.Mandal,
                            title: 'Mandal',
                            controller: ctrl,
                            onChanged: (v) => setState(() => _searched = false),
                          ),

                        if (ctrl.hasItems(GeoLevel.Graam))
                          GeoDropdownWidget(
                            level: GeoLevel.Graam,
                            title: 'Graam',
                            controller: ctrl,
                            onChanged: (v) => setState(() => _searched = false),
                          ),

                        if (ctrl.hasItems(GeoLevel.Vasti))
                          GeoDropdownWidget(
                            level: GeoLevel.Vasti,
                            title: 'Vasti',
                            controller: ctrl,
                            onChanged: (v) => setState(() => _searched = false),
                          ),
                        SizedBox(height: 12),
                        /*if (_vayogat != null)
                            DropdownButtonFormField(
                              decoration: InputDecoration(labelText: Statics.getLabel('Vayogat')),
                              isExpanded: true,
                              value: _vayogatValue == "" ? null : _vayogatValue,
                              items: _vayogat!.map((bg) => DropdownMenuItem(value: bg.staticID.toString(), child: Text(bg.codeForDisplay!))).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _vayogatValue = value;
                                });
                              },
                            ),*/
                        SizedBox(height: 21),
                      ],
                    ),
                  ),
                  isExpanded: _isExpanded,
                ),
            ],
          ),
          if ((int.parse(Statics.userDetails['LevelID']) > 1))
            Container(
              margin: EdgeInsets.all(20),
              child: _isSearching == true
                  ? CircularProgressIndicator()
                  : Wrap(
                      spacing: 10,
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
                            _search(ctrl.deepestSelectedGeoUnitId, context);
                          },
                          child: Text(
                            Statics.getLabel('Search'),
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        MaterialButton(
                            onPressed: () {
                              print("clear button pressed");
                              setState(() {
                                _searchController.text = "";
                                _isSearching = _searched = false;
                              });
                              // _frequencyValue = null;
                              _vayogatValue = null;
                              // _shaakhaaList = _getshaakhaaList(-1, "get nothing", null, null);
                              _isExpanded = false;
                              _shaakhaaList = [];
                              populateDropdown();
                              ctrl.loadHierarchyForUser();
                            },
                            child: Text(Statics.getLabel('clear'))),
                      ],
                    ),
            ),
        ],
      );
    });
  }
}
