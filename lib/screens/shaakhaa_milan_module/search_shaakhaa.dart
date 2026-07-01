import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:niyojak_prod/screens/home_screen/home_screen.dart';
import 'package:provider/provider.dart';

import '../../helpers/static_data.dart' as Statics;
import '../../providers/bals.dart';
import '../../utils/globals.dart';
import '../../utils/stable_geounit_class.dart';
import '../../widgets/app_drawer.dart';
import '../../widgets/shaakhaa_card.dart';
import '../maps_display.dart';
import 'edit_shaakhaa.dart';

class SearchShaakhaaScreen extends StatefulWidget {
  static const routeName = '/search-shaakhaa-screen';

  @override
  _SearchSShaakhaaScreenState createState() => _SearchSShaakhaaScreenState();
}

class _SearchSShaakhaaScreenState extends State<SearchShaakhaaScreen> {
  // static const String routeName = '/vijayadashami-form-view';
  final _searchController = TextEditingController();
  bool _isSearching = false;

  List<StaticMasterBAL>? _vayogat;
  List<StaticMasterBAL>? _frequency;
  List shakhaSapMasSanghList = [];

  String? _vayogatValue;
  String? _frequencyValue;

  bool _isExpanded = false;

  List<dynamic>? _shaakhaaList;
  List<Statics.cLatLong> _latLng = [];

  final controller = createGeoController();

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

    await controller.initialize(dm);

    setState(() {});
    await populateDropdown();

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
      _shaakhaaList = await _getshaakhaaList(-1, "get nothing", null, null);
    }
    setState(() {});
  }

  Future<void> populateDropdown({bool fromClear = false}) async {
    var data = await Statics.getStaticLDB('ShaakhaaVayogat');
    var data1 = await Statics.getStaticLDB('ShaakhaaFrequency');
    if (!mounted) return;
    setState(() {
      _vayogat = data;
      _frequency = data1;
    });
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedMahaanagarDropdown() async {
    final data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['MahaanagarLevelID'].toString(), '', '', '', isAbhiyaan: false);
    setState(() {});
    return data;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedVibhaagDropdown(String mahaanagarIDStr) async {
    final data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['VibhaagLevelID'].toString(), mahaanagarIDStr, mahaanagarIDStr.isEmpty ? '' : 'Mahaanagar', '', isAbhiyaan: false);
    setState(() {});
    return data;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedBhaagDropdown(String vibhaagIDStr) async {
    final data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['BhaagLevelID'].toString(), vibhaagIDStr, 'Vibhaag', '', isAbhiyaan: false);
    setState(() {});
    return data;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedNagarDropdown(String? bhaagIDStr, String? shaharIDStr) async {
    final parentID = shaharIDStr ?? bhaagIDStr!;
    final parentType = shaharIDStr != null ? 'Shahar' : 'Bhaag';
    final data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['NagarLevelID'].toString(), parentID, parentType, '', isAbhiyaan: false);
    setState(() {});
    return data;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedUpnagarDropdown(String? nagarIDStr) async {
    var mnDD;

    mnDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['UpaNagarLevelID'].toString(), nagarIDStr!, 'Nagar', '');

    setState(() {});
    return mnDD;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedVastiDropdown(bool haveParentUp, String? nagarIDStr) async {
    var data;
    if (haveParentUp) {
      print("i am in parents upnagar");
      data = await Statics.getGeoUnitsByLevelAndParentForUpnagar(Statics.levels['VastiLevelID'].toString(), nagarIDStr!, "Upnagar", '');
      // print("${mnDD}");
    } else {
      data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['VastiLevelID'].toString(), nagarIDStr!, "Nagar", '');
    }
    setState(() {});
    return data;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedMandalDropdown(bool haveParentUp, String nagarIDStr) async {
    var data;
    if (haveParentUp) {
      data = await Statics.getGeoUnitsByLevelAndParentForUpnagar(Statics.levels['MandalLevelID'].toString(), nagarIDStr, "Upnagar", '');
    } else {
      data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['MandalLevelID'].toString(), nagarIDStr, "Nagar", '');
    }
    setState(() {});
    return data;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedGraamDropdown(String mandalIDStr) async {
    //setState(() => viewcontainer = false);
    // _linkedgraamValue = null;
    print("mandalIDStr mandalIDStr ==> $mandalIDStr");
    var data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['GraamLevelID'].toString(), mandalIDStr, 'Mandal', '');
    setState(() {});
    return data;
  }

  Future<void> _search(String strType, var ctx) async {
    setState(() {
      _isSearching = true;
    });
    int? frequencyVal = _frequencyValue == null || _frequencyValue == "" ? null : int.parse(_frequencyValue!);

    int? vayogatVal = _vayogatValue == null || _vayogatValue == "" ? null : int.parse(_vayogatValue!);

    if (strType == "Search") {
      _shaakhaaList = await _getshaakhaaList(int.parse(controller.deepestSelectedGeoUnitId ?? "0"), _searchController.text, frequencyVal, vayogatVal);
      setState(() {
        // _shaakhaaList = _getshaakhaaList(
        //     geoUnitID, _searchController.text, frequencyVal, vayogatVal);
        _isSearching = false;
        _isExpanded = false;
        print(_shaakhaaList);
      });
    } else {
      var dataList = await _getshaakhaaList(int.parse(controller.deepestSelectedGeoUnitId ?? "0"), _searchController.text, frequencyVal, vayogatVal);
      print("dataList $dataList");
      if (dataList.isEmpty) {
        Statics.showErrorDialog(context, Statics.getLabel("noDataFoundTryAnotherSearch"));
        setState(() {
          _isSearching = false;
        });
        return;
      }
      setState(() {
        _isSearching = false;
        _isExpanded = false;
      });
      viewLocation(dataList, ctx);
    }
  }

  void _getCsv() async {
    // setState(() {
    //   _isfetingData = true;
    // });

    // Await the future resolution to get the actual list
    List<dynamic> dataList = await _shaakhaaList!;

    // Prepare the CSV headers
    List<List<dynamic>> rows = [];
    List<dynamic> header = [];
    header.add(Statics.getLabel('SelectShaakhaa'));
    header.add(Statics.getLabel('Vayogat'));
    header.add(Statics.getLabel('IsSankalpit'));
    header.add(Statics.getLabel('FrequencyCode'));
    // header.add(Statics.getLabel('Location'));
    header.add(Statics.getLabel('FromTime'));
    header.add(Statics.getLabel('ToTime'));
    header.add(Statics.getLabel('HasToli'));
    header.add(Statics.getLabel('HasPaalak'));
    header.add(Statics.getLabel('OptionalShaaririkVishay'));
    header.add(Statics.getLabel('OtherOptionalVishay'));
    // header.add(Statics.getLabel('OtherInfo'));
    header.add(Statics.getLabel('Bhaag'));
    header.add(Statics.getLabel('Graam'));
    header.add(Statics.getLabel('Mandal'));
    header.add(Statics.getLabel('Nagar'));
    header.add(Statics.getLabel('Shahar'));
    header.add(Statics.getLabel('Vasti'));

    rows.add(header);

    // Loop through the data list
    for (var data in dataList) {
      // List<GeoUnitMasterBAL> mahanagarList = await populatelinkedMahaanagarDropdown() ;
      // List<GeoUnitMasterBAL>  vibhagList = await populatelinkedVibhaagDropdown(data.parentMahaanagarID.toString()== "0"?"":data.parentMahaanagarID.toString());
      List<GeoUnitMasterBAL> bhagList = await populatelinkedBhaagDropdown(data["ParentVibhaagID"].toString()) ?? [];
      List<GeoUnitMasterBAL> nagarList = await populatelinkedNagarDropdown(data["ParentBhaagID"].toString(), null);
      List<GeoUnitMasterBAL> mandalList = await populatelinkedMandalDropdown(false, data["ParentNagarID"].toString()) ?? [];
      List<GeoUnitMasterBAL> gramList = await populatelinkedGraamDropdown(data["ParentMandalID"].toString()) ?? [];
      List<GeoUnitMasterBAL> vastiList = await populatelinkedVastiDropdown(false, data["ParentNagarID"].toString()) ?? [];
      // print("vibhagListvibhagList  ${jsonEncode(vibhagList)}");

      List<dynamic> row = [];
      row.add(data["GeoUnitName"].toString());
      row.add(data["VayogatCode"].toString());
      row.add(data["IsSankalpit"].toString());
      row.add(data["FrequencyCode"].toString());
      // row.add(data["ParentShaharID"].toString());
      row.add(data["StartTimeStr"].toString());
      row.add(data["EndTimeStr"].toString());
      row.add(data["HasToli"].toString());
      row.add(data["HasPaalak"].toString());
      row.add(data["OptionalShaaririkVishayCode"].toString());
      row.add(data["OtherOptionalVishay"].toString());
      // row.add(data["DaayitvaLevelName"].toString());
      // row.add(data["DaayitvaName"].toString());
      row.add("${bhagList.where((element) => element.geoUnitID == data["ParentBhaagID"]).isNotEmpty ? bhagList.firstWhere((element) => element.geoUnitID == data["ParentBhaagID"]).name : "-"}");
      row.add("${gramList.where((element) => element.geoUnitID == data["ParentGraamID"]).isNotEmpty ? gramList.firstWhere((element) => element.geoUnitID == data["ParentGraamID"]).name : "-"}");
      row.add("${mandalList.where((element) => element.geoUnitID == data["ParentMandalID"]).isNotEmpty ? mandalList.firstWhere((element) => element.geoUnitID == data["ParentMandalID"]).name : "-"}");
      row.add("${nagarList.where((element) => element.geoUnitID == data["ParentNagarID"]).isNotEmpty ? nagarList.firstWhere((element) => element.geoUnitID == data["ParentNagarID"]).name : "-"}");
      row.add("${vastiList.where((element) => element.geoUnitID == data["ParentShaharID"]).isNotEmpty ? vastiList.firstWhere((element) => element.geoUnitID == data["ParentShaharID"]).name : "-"}");
      row.add("${vastiList.where((element) => element.geoUnitID == data["ParentVastiID"]).isNotEmpty ? vastiList.firstWhere((element) => element.geoUnitID == data["ParentVastiID"]).name : "-"}");

      // Mahanagar //9
      //   "${mahanagarList.where((element) =>  element.geoUnitID == data.parentMahaanagarID).isNotEmpty ? mahanagarList.firstWhere((element) => element.geoUnitID == data.parentMahaanagarID).name  : "-" }",
      // "${vibhagList.where((element) =>  element.geoUnitID == data.parentVibhaagID).isNotEmpty ? vibhagList.firstWhere((element) => element.geoUnitID == data.parentVibhaagID).name  : "-" }",

      rows.add(row);
    }

    if (rows.length > 1) {
      Statics.convertToCsv(rows, "SoochiMembersList" + "_" + DateFormat('ddMMyyyyHHmmss').format(DateTime.now()), context);
    }

    setState(() {
      // _isfetingData = false;
    });
  }

  void viewLocation(var dataList, var ctx) async {
    _latLng = [];
    for (var shaakhaaItem in dataList) {
      if (shaakhaaItem["ShaakhaaLatitude"] != null && shaakhaaItem["ShaakhaaLatitude"].toString() != "") {
        _latLng.add(Statics.cLatLong(
            shaakhaaItem["ShaakhaaID"], shaakhaaItem["GeoUnitName"].toString(), shaakhaaItem["FrequencyCode"].toString(), LatLng(shaakhaaItem["ShaakhaaLatitude"], shaakhaaItem["ShaakhaaLongitude"])));
      }
    }
    print("viewLocation -> dataList -> _latLng :- $_latLng");
    if (_latLng.length > 0) {
      Navigator.of(ctx).pushNamed(MapDisplay.routeName, arguments: _latLng);
    } else
      Statics.showErrorDialog(ctx, Statics.getLabel("LocationNotAvailableForSearch"));
  }

  Future<List<dynamic>> _getshaakhaaList(int? geoUnitID, String searchString, int? frequencyID, int? vayogatID) async {
    bool isConnected = await Statics.isInternetConnected();
    if (isConnected) {
      String strInput = json.encode({"AppUserID": Statics.userDetails['userID'], "GeoUnitID": geoUnitID, "FrequencyID": frequencyID, "VayogatID": vayogatID});
      print("strInput:- $strInput");
      return Statics.getShaakhaaList(strInput);
    } else {
      Statics.showMessageDialog(context, Statics.getLabel('internetNotConnected'));
      return [];
    }
  }

  // Future<List<dynamic>> _getshaakhaaList(int? geoUnitID, String searchString, int? frequencyID, int? vayogatID) async {
  //   bool isConnected = await Statics.isInternetConnected();
  //   if (isConnected) {
  //     String strInput = json.encode({
  //       "AppUserID": Statics.userDetails['userID'],
  //       "GeoUnitID": geoUnitID,
  //       "FrequencyID": frequencyID,
  //       "VayogatID": vayogatID,
  //     });
  //     print("strInput:- $strInput");
  //
  //     // Show the popup with the strInput value
  //     _showPopup(context, strInput);
  //
  //     return Statics.getShaakhaaList(strInput);
  //   } else {
  //     Statics.showMessageDialog(context, Statics.getLabel('internetNotConnected'));
  //     return [];
  //   }
  // }
  Future<void> _showPopup(BuildContext context, String strInput) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Input Value'),
          content: Text(strInput),
          actions: <Widget>[
            TextButton(
              child: Text('bandKara'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          Statics.getLabel('searchShaakhaaScreenLabel'),
          style: TextStyle(fontSize: 24),
        ),
        actions: <Widget>[
          if (Statics.levelId > 3)
            Row(
              children: [
                IconButton(
                  padding: EdgeInsets.all(8),
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    Navigator.of(context).pushNamed(EditShaakhaaScreen.routeName, arguments: Statics.ScreenArguments(0, Statics.getLabel('EditMenu')));
                  },
                ),
              ],
            ),
        ],
      ),
      drawer: AppDrawer(),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            mini: true,
            tooltip: Statics.getLabel("ExportToExcel"),
            onPressed: _getCsv,
            child: Icon(Icons.download_sharp),
            backgroundColor: Colors.green,
          ),
          FloatingActionButton(
            mini: true,
            tooltip: Statics.getLabel("fillNewRecord"),
            onPressed: () async {
              Navigator.of(context).pushNamed(EditShaakhaaScreen.routeName, arguments: Statics.ScreenArguments(0, Statics.getLabel('EditMenu')));
            },
            child: Icon(Icons.download_sharp),
            backgroundColor: Colors.green,
          ),
        ],
      ),
      body: PopScope(
        canPop: false,
        onPopInvoked: (didpop) {
          if (didpop) return;
          Navigator.pushNamedAndRemoveUntil(context, Navigator.of(context).pushNamed(HomeScreen.routeName).toString(), (route) => false);
        },
        child: Container(
          padding: EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text(
                  Statics.getLabel('searchShaakhaaScreenBanner'),
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 10),

                ///
                dropDownSection(),

                ///
                SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.7,
                  child: _shaakhaaList == null || (_shaakhaaList?.isEmpty == true)
                      ? Center(
                          child: Text(Statics.getLabel("noDataFoundTryAnotherSearch")),
                        )
                      : ListView.separated(
                          shrinkWrap: true,
                          // physics: NeverScrollableScrollPhysics(),
                          separatorBuilder: (context, index) => SizedBox(height: 8),
                          itemCount: _shaakhaaList?.length ?? 0,
                          itemBuilder: (context, index) {
                            return ShaakhaaCard(_shaakhaaList?[index], _shaakhaaList?[index]["IsSankalpit"], _search);
                          },
                        ),
                )
                /*FutureBuilder<List<dynamic>>(
                    future: _shaakhaaList,
                    builder: (ctx, dataSnapshot) {
                      if (dataSnapshot.connectionState != ConnectionState.done) {
                        return _isSearching == true ? CircularProgressIndicator() : Container();
                      }
                      if (dataSnapshot.hasError) {
                        print("  dataSnapshot  ${dataSnapshot}  ");
                        return Center(child: Text(Statics.getLabel('noDataFoundTryAnotherSearch')));
                      }
                      return dataSnapshot.hasData && dataSnapshot.data!.length > 0
                          ? Column(
                              children: dataSnapshot.data!.map((shaakhaa) => ShaakhaaCard(shaakhaa, shaakhaa['IsSankalpit'], _search)).toList(),
                            )
                          : Center(child: Text(Statics.getLabel('noDataFoundTryAnotherSearch')));
                    },
                  ),*/
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget dropDownSection() {
    return ChangeNotifierProvider.value(
      value: controller,
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
                            validator: (v) {
                              if (v == null || v!.isEmpty) return (Statics.getLabel('GeoUnitValidationMessage'));
                              return null;
                            },
                          ),
                          if (ctrl.hasItems(GeoLevel.Vibhaag))
                            GeoDropdownWidget(
                              level: GeoLevel.Vibhaag,
                              title: 'Vibhaag',
                              controller: ctrl,
                              validator: (v) {
                                if (v == null || v!.isEmpty) return (Statics.getLabel('GeoUnitValidationMessage'));
                                return null;
                              },
                            ),
                          if (ctrl.hasItems(GeoLevel.Bhaag))
                            GeoDropdownWidget(
                              level: GeoLevel.Bhaag,
                              title: 'Bhaag',
                              controller: ctrl,
                              validator: (v) {
                                if (v == null || v!.isEmpty) return (Statics.getLabel('SelectBhaagValidationMessage'));
                                return null;
                              },
                            ),

                          if (ctrl.hasItems(GeoLevel.Nagar))
                            GeoDropdownWidget(
                              level: GeoLevel.Nagar,
                              title: 'Nagar',
                              controller: ctrl,
                              validator: (v) {
                                if (v == null || v!.isEmpty) return (Statics.getLabel('SelectNagarValidationMessage'));
                                return null;
                              },
                            ),

                          /// CONDITIONAL
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
                              validator: (v) {
                                if (v == null || v!.isEmpty) return (Statics.getLabel('SelectMandalValidationMessage'));
                                return null;
                              },
                            ),

                          if (ctrl.hasItems(GeoLevel.Graam))
                            GeoDropdownWidget(
                              level: GeoLevel.Graam,
                              title: 'Graam',
                              controller: ctrl,
                              validator: (v) {
                                if (v == null || v!.isEmpty) return (Statics.getLabel('SelectGraamValidationMessage'));
                                return null;
                              },
                            ),

                          if (ctrl.hasItems(GeoLevel.Vasti))
                            GeoDropdownWidget(
                              level: GeoLevel.Vasti,
                              title: 'Vasti',
                              controller: ctrl,
                              validator: (v) {
                                if (v == null || v!.isEmpty) return (Statics.getLabel('VastiValidationMessage'));
                                return null;
                              },
                            ),

                          //======================================================================================================================
                          if (_frequency != null)
                            DropdownButtonFormField<StaticMasterBAL>(
                              decoration: InputDecoration(labelText: Statics.getLabel('SelectFrequency')),
                              isExpanded: true,
                              value: _frequencyValue == null
                                  ? null
                                  : _frequency == null
                                      ? null
                                      : _frequency![_frequency!.indexWhere((p) => p.staticID.toString() == _frequencyValue.toString())],
                              items: _frequency!.map((bg) => DropdownMenuItem(value: bg, child: Text(bg.codeForDisplay!))).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _frequencyValue = value!.staticID.toString();
                                });
                              },
                            ),
                          SizedBox(
                            height: 10,
                          ),
                          if (_vayogat != null)
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
            if ((int.parse(Statics.userDetails['LevelID']) > 1))
              // &&
              //   !(Statics.userDetails['DaayitvaName'] == 'Mukhya Shikshak' ||
              //       Statics.userDetails['DaayitvaName'] == 'मुख्य शिक्षक' ||
              //       Statics.userDetails['DaayitvaName'] == 'Kaaryavaah' ||
              //       Statics.userDetails['DaayitvaName'] == 'कार्यवाह'))
              Container(
                margin: EdgeInsets.all(20),
                child: Column(
                  children: [
                    if (_isSearching == true)
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
                              _search("Search", context);
                            },
                            child: Text(
                              Statics.getLabel('Search'),
                              style: TextStyle(fontSize: 25),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          // Text(
                          //     "${Statics.userDetails['LevelID']} ---${Statics.userDetails['LevelName']} --- $geoUnitIDnew"),
                          MaterialButton(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                            padding: EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 8,
                            ),
                            color: Theme.of(context).primaryColor,
                            textColor: Theme.of(context).primaryTextTheme.labelMedium?.color,
                            onPressed: () {
                              _search("ViewLocation", context);
                            },
                            child: Wrap(
                              children: [
                                Icon(
                                  Icons.location_pin,
                                  color: Theme.of(context).primaryTextTheme.labelMedium?.color,
                                ),
                                Text(
                                  Statics.getLabel("MapView"),
                                  style: TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                        ],
                      ),
                    MaterialButton(
                        onPressed: () {
                          print("clear button pressed");
                          setState(() {
                            _searchController.text = "";
                            _isSearching = false;
                          });
                          _frequencyValue = null;
                          _vayogatValue = null;
                          // _shaakhaaList = _getshaakhaaList(-1, "get nothing", null, null);
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
