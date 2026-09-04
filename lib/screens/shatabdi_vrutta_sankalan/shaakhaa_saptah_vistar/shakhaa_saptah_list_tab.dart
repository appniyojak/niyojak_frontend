import 'dart:convert';
import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../helpers/static_data.dart' as Statics;
import '../../../models/response_model/shaakhaa_vistar_list_resp_model.dart';
import '../../../providers/bals.dart';
import '../../../utils/globals.dart';
import '../../../utils/stable_geounit_class.dart';
import '../../../widgets/shaakhaa_card.dart';
import 'add_new_shaakhaa_vistaar_screen.dart';
import 'shakhaa_saptah_form_screen.dart';

class ShakhaaSaptahListTab extends StatefulWidget {
  final bool hitApiWtoDropdown;

  const ShakhaaSaptahListTab({super.key, this.hitApiWtoDropdown = false});

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
  List<ShaakhaaList> _anyaShaakhaaList = [];
  Map<String, List<ShaakhaaList>> _groupedAnyaShaakhaaByTrail = {};

  final _controller = createGeoController();

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

    await _controller.initialize(dm);

    await populateDropdown();

    if (widget.hitApiWtoDropdown) _search(_controller.deepestSelectedGeoUnitId, context);

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
      _shaakhaaList = _sankalpitShaakhaaList = _newShaakhaaList = _anyaShaakhaaList = [];
      _groupedAnyaShaakhaaByTrail = {};
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

    _list.forEach((e) => log(jsonEncode(e.toJson())));

    // _shaakhaaList = _getshaakhaaList(
    //     geoUnitID, _searchController.text, frequencyVal, vayogatVal);

    final _isNotSankalpitList = _list.where((e) => e.isSankalpit == false && e.isnew != 1 && e.isanya != 1);
    final _isSankalpitList = _list.where((e) => e.isSankalpit == true && e.isnew != 1 && e.isanya != 1);
    final _isNewSankalpitList = _list.where((e) => e.isnew == 1);
    final _isAnyaSankalpitList = _list.where((e) => e.isanya == 1);

    _shaakhaaList = _isNotSankalpitList.toList();
    _sankalpitShaakhaaList = _isSankalpitList.toList();
    _newShaakhaaList = _isNewSankalpitList.toList();
    _anyaShaakhaaList = _isAnyaSankalpitList.toList();

    _groupedAnyaShaakhaaByTrail = groupBy(_anyaShaakhaaList, (ShaakhaaList item) => item.trail ?? Statics.getLabel("anyaKshetrache"));

    // _shaakhaaList?.removeWhere((e) => e["IsSankalpit"] == true);
    setState(() {
      _shaakhaaList;
      _sankalpitShaakhaaList;
      _newShaakhaaList;
      _anyaShaakhaaList;
      _isSearching = false;
      _searched = true;
      _isExpanded = false;
    });
    print(_shaakhaaList?.length);
    print(_sankalpitShaakhaaList.length);
    print(_newShaakhaaList.length);
    print(_anyaShaakhaaList.length);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return DefaultTabController(
      length: widget.hitApiWtoDropdown
          ? 2
          : _anyaShaakhaaList.isEmpty
              ? 3
              : 4,
      child: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            /*Text(
              Statics.getLabel('searchShaakhaaScreenBanner'),
              style: TextStyle(fontSize: 20),
            ),*/
            SizedBox(height: 10),

            ///
            if (!widget.hitApiWtoDropdown) _dropdownSection(),

            ///

            if (_searched) ...[
              TabBar(labelColor: Colors.purple, labelPadding: EdgeInsets.symmetric(horizontal: 4), unselectedLabelColor: Colors.grey, tabs: [
                Tab(
                    child: Text(
                  Statics.getLabel("vartamaan"),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13.5),
                )),
                if (!widget.hitApiWtoDropdown)
                  Tab(
                      child: Text(
                    Statics.getLabel("sankalpit"),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 13.5),
                  )),
                if (!widget.hitApiWtoDropdown)
                  Tab(
                      child: Text(
                    Statics.getLabel("vistarShaakhaa"),
                    textAlign: TextAlign.center,
                    softWrap: true,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 13.5),
                  )),
                if (_anyaShaakhaaList.isNotEmpty)
                  Tab(
                      child: Text(
                    Statics.getLabel("anyaKshetrache"),
                    textAlign: TextAlign.center,
                    softWrap: true,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 13.5),
                  )),
              ]),
              Flexible(
                child: TabBarView(children: [
                  ///1
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
                          padding: EdgeInsets.only(bottom: 80, top: 16),
                          separatorBuilder: (context, index) => SizedBox(height: 8),
                          itemCount: _shaakhaaList?.length ?? 0,
                          itemBuilder: (context, index) {
                            return ShaakhaaCard(_shaakhaaList?[index].toJson(), false, _search,
                                showOther: false,
                                traillingIcon: IconButton(
                                    onPressed: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ShakhaaSaptahFormScreen(
                                                  shaakhaa: _shaakhaaList?[index],
                                                  viewType: "EditVrutta",
                                                ))),
                                    icon: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [Icon(Icons.edit), Text(Statics.getLabel("Vrutta"))],
                                    )));
                          },
                        ),

                  ///2
                  if (!widget.hitApiWtoDropdown)
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
                            padding: EdgeInsets.only(bottom: 80, top: 16),
                            itemBuilder: (context, index) {
                              return ShaakhaaCard(_sankalpitShaakhaaList[index].toJson(), _sankalpitShaakhaaList[index].isSankalpit, _search,
                                  showOther: false,
                                  traillingIcon: IconButton(
                                      onPressed: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => ShakhaaSaptahFormScreen(
                                                    shaakhaa: _sankalpitShaakhaaList[index],
                                                    viewType: "EditVrutta",
                                                  ))),
                                      icon: Column(
                                        children: [Icon(Icons.edit), Text(Statics.getLabel("Vrutta"))],
                                      )));
                            },
                          ),

                  ///3
                  if (!widget.hitApiWtoDropdown)
                    Scaffold(
                      floatingActionButton: FloatingActionButton(
                        onPressed: () => Navigator.pushNamed(context, AddNewShaakhaaVistaarScreen.routeName, arguments: {"geoid": _controller.deepestSelectedGeoUnitId}).then((value) {
                          if (value == true) _search(_controller.deepestSelectedGeoUnitId, context);
                        }),
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
                              padding: EdgeInsets.only(bottom: 80, top: 16),
                              // physics: NeverScrollableScrollPhysics(),
                              separatorBuilder: (context, index) => SizedBox(height: 8),
                              itemCount: _newShaakhaaList.length ?? 0,
                              itemBuilder: (context, index) {
                                return ShaakhaaCard(
                                  _newShaakhaaList[index].toJson(), false, _search,
                                  IsNew: true,
                                  showOther: false,
                                  traillingIcon: PopupMenuButton(
                                      itemBuilder: (context) => [
                                            PopupMenuItem(
                                                onTap: () => Navigator.of(context).pushNamed(AddNewShaakhaaVistaarScreen.routeName, arguments: {
                                                      "pkid": _newShaakhaaList[index].pkid,
                                                      "geoid": _newShaakhaaList[index].parentVastiID ?? _newShaakhaaList[index].parentGraamID
                                                    }).then((value) {
                                                      if (value == true) _search(_controller.deepestSelectedGeoUnitId, context);
                                                    }),
                                                child: ListTile(
                                                  // tileColor: Colors.white,
                                                  leading: Icon(
                                                    Icons.edit,
                                                    color: Colors.purple,
                                                  ),
                                                  title: Text(Statics.getLabel("EditMenu")),
                                                )),
                                            PopupMenuItem(
                                                onTap: () => Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) => ShakhaaSaptahFormScreen(
                                                              shaakhaa: _newShaakhaaList[index],
                                                              viewType: "EditVrutta",
                                                            ))),
                                                child: ListTile(
                                                  // tileColor: Colors.white,
                                                  leading: Icon(
                                                    Icons.edit_calendar,
                                                    color: Colors.purple,
                                                  ),
                                                  title: Text(Statics.getLabel("Vrutta")),
                                                )),
                                          ]),
                                  // traillingIcon: IconButton(
                                  //     onPressed: () => Navigator.push(
                                  //         context,
                                  //         MaterialPageRoute(
                                  //             builder: (context) => ShakhaaSaptahFormScreen(
                                  //                   shaakhaa: _newShaakhaaList[index],
                                  //                   viewType: "EditVrutta",
                                  //                 ))),
                                  //     icon: Column(
                                  //       children: [Icon(Icons.edit), Text(Statics.getLabel("Vrutta"))],
                                  //     )),
                                );
                              },
                            ),
                    ),

                  ///4
                  if (_groupedAnyaShaakhaaByTrail.isNotEmpty)
                    ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.only(top: 16),
                      separatorBuilder: (context, index) => SizedBox(height: 8),
                      itemCount: _groupedAnyaShaakhaaByTrail.length,
                      itemBuilder: (context, index) {
                        final trailName = _groupedAnyaShaakhaaByTrail.keys.elementAt(index);
                        final itemsInTrail = _groupedAnyaShaakhaaByTrail[trailName]!;

                        return Card(
                          clipBehavior: Clip.antiAlias,
                          child: ExpansionTile(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            title: Text(
                              trailName,
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            initiallyExpanded: true,
                            childrenPadding: EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 12),
                            children: [
                              ListView.separated(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                separatorBuilder: (context, i) => SizedBox(height: 8),
                                itemCount: itemsInTrail.length,
                                itemBuilder: (context, i) {
                                  final shaakhaa = itemsInTrail[i];
                                  return ShaakhaaCard(
                                    shaakhaa.toJson(),
                                    false,
                                    _search,
                                    showOther: false,
                                    IsAnya: true,
                                    traillingIcon: IconButton(
                                      onPressed: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => ShakhaaSaptahFormScreen(
                                                    shaakhaa: shaakhaa,
                                                    viewType: "EditVrutta",
                                                  ))),
                                      icon: Column(
                                        children: [Icon(Icons.edit), Text(Statics.getLabel("Vrutta"))],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                ]),
              )
            ],
          ],
        ),
      ),
    );
  }

  Widget _dropdownSection() {
    return ChangeNotifierProvider.value(
      value: _controller,
      child: Consumer<GeoHierarchyController>(builder: (_, ctrl, __) {
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
      }),
    );
  }
}
