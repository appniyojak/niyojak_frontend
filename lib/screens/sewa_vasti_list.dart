import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../helpers/static_data.dart' as Statics;
import '../screens/edit_sewa_vasti.dart';
import '../utils/globals.dart';
import '../utils/stable_geounit_class.dart';
import '../widgets/app_drawer.dart';
import '../widgets/sewa_vasti_card.dart';
import 'home_screen/home_screen.dart';

class SearchSewaVasti extends StatefulWidget {
  static const routeName = '/search-sewavasti-screen';

  @override
  _SearchSewaVastiState createState() => _SearchSewaVastiState();
}

class _SearchSewaVastiState extends State<SearchSewaVasti> {
  List<dynamic>? _sewaVastiList;
  bool _isSearching = false;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => initData());
  }

  Future<void> initData() async {
    final dm = await MyAppGlobals.getLevelLDB();

    final controller = context.read<GeoHierarchyController>();

    await controller.initialize(dm);

    setState(() {});
  }

  void onSaveDetails() async {
    var data = await _getSewaVastiLst(null);
    setState(() {
      _sewaVastiList = data;
    });
  }

  Future<List<dynamic>> _getSewaVastiLst(int? sewaVastiID) async {
    final controller = context.read<GeoHierarchyController>();

    bool isConnected = await Statics.isInternetConnected();
    if (isConnected) {
      String strInput = json.encode({
        "AppUserID": Statics.userDetails['userID'],
        "MahanagarID": controller.hierarchyTrail.mahaanagarId,
        "VibhaagID": controller.hierarchyTrail.vibhaagId,
        "BhaagID": controller.hierarchyTrail.bhaagId,
        "ShaharID": null,
        "NagarID": controller.hierarchyTrail.nagarId,
        "VastiID": controller.hierarchyTrail.vastiId,
        "GraamID": controller.hierarchyTrail.graamId,
        "MandalID": controller.hierarchyTrail.mandalId,
        "SewaVastiID": sewaVastiID,
        "GeoUnitId": controller.deepestSelectedGeoUnitId,
      });

      return Statics.getSewaVastiForApp(strInput);
    } else {
      Statics.showMessageDialog(context, Statics.getLabel('internetNotConnected'));
      return [];
    }
  }

  Future<void> _search() async {
    setState(() {
      _isSearching = true;
    });

    _sewaVastiList = await _getSewaVastiLst(null);
    setState(() {
      _isSearching = false;
      _isExpanded = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.popAndPushNamed(context, HomeScreen.routeName);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            Statics.getLabel('searchSewaVastiScreenLabel'),
            style: TextStyle(fontSize: 24),
          ),
          actions: <Widget>[
            // if ((Statics.userDetails['LevelName'] == 'Praant' ||
            //         Statics.userDetails['LevelName'] == 'Mahaanagar' ||
            //         Statics.userDetails['LevelName'] == 'Bhaag' ||
            //         Statics.userDetails['LevelName'] == 'Vibhaag' ||
            //         Statics.userDetails['LevelName'] == 'प्रांत' ||
            //         Statics.userDetails['LevelName'] == 'महानगर' ||
            //         Statics.userDetails['LevelName'] == 'भाग/जिल्हा' ||
            //         Statics.userDetails['LevelName'] == 'Nagar\/Taalukaa' ||
            //         Statics.userDetails['LevelName'] == 'Nagar' ||
            //         Statics.userDetails["LevelName"] == "नगर/तालुका" ||
            //         Statics.userDetails['LevelName'] == 'विभाग' ||
            //         Statics.userDetails["LevelName"] == "Bhaag" ||
            //         Statics.userDetails["LevelName"] == "भाग/जिला" ||
            //         Statics.userDetails["LevelName"] == "भाग/जिल्हा")
            //     // &&
            //     // (Statics.userDetails["DaayitvaName"] == "Join RSS Sanyojak" ||
            //     //     Statics.userDetails["DaayitvaName"] == "जॉयन आर.एस.एस. संयोजक" ||
            //     //     Statics.userDetails["DaayitvaName"] == "Join RSS Pramukh" ||
            //     //     Statics.userDetails["DaayitvaName"] == "जॉयन आर.एस.एस. प्रमुख" ||
            //     //     Statics.userDetails["DaayitvaName"] == "Baal Vidyaarthi Pramukh" ||
            //     //     Statics.userDetails["DaayitvaName"] == "बाल विद्यार्थी प्रमुख" ||
            //     //     Statics.userDetails["DaayitvaName"] == "बाल विद्यार्थी प्रमुख" ||
            //     //     Statics.userDetails["DaayitvaName"] == "Mahaavidyaalayeen Vidyaarthi Pramukh" ||
            //     //     Statics.userDetails["DaayitvaName"] == "महाविद्यालयीन प्रमुख" ||
            //     //     Statics.userDetails["DaayitvaName"] == "महाविद्यालयीन प्रमुख" ||
            //     //     Statics.userDetails["DaayitvaName"] == "Vyavasaayee Pramukh" ||
            //     //     Statics.userDetails["DaayitvaName"] == "व्यवसायी प्रमुख" ||
            //     //     Statics.userDetails["DaayitvaName"] == "व्यवसायी प्रमुख" ||
            //     //     Statics.userDetails["DaayitvaName"] == "Vyavasaayee Saha-Pramukh" ||
            //     //     Statics.userDetails["DaayitvaName"] == "व्यवसायी सह प्रमुख" ||
            //     //     Statics.userDetails["DaayitvaName"] == "व्यवसायी सह प्रमुख" ||
            //     //     Statics.userDetails["DaayitvaName"] == "Tarun Vyavsayee Pramukh" ||
            //     //     Statics.userDetails["DaayitvaName"] == "तरुण व्यवसायी प्रमुख" ||
            //     //     Statics.userDetails["DaayitvaName"] == "तरुण व्यवसायी प्रमुख" ||
            //     //     Statics.userDetails["DaayitvaName"] == "Praudh Vyavsayee Pramukh" ||
            //     //     Statics.userDetails["DaayitvaName"] == "प्रौढ व्यवसायी प्रमुख" ||
            //     //     Statics.userDetails["DaayitvaName"] == "प्रौढ व्यवसायी प्रमुख" ||
            //     //     Statics.userDetails["DaayitvaName"] == "Tarun Vyavsayee Sah Pramukh" ||
            //     //     Statics.userDetails["DaayitvaName"] == "तरुण व्यवसायी सह प्रमुख" ||
            //     //     Statics.userDetails["DaayitvaName"] == "तरुण व्यवसायी सह प्रमुख" ||
            //     //     Statics.userDetails["DaayitvaName"] == "Praudh Vyavsayee Sah Pramukh" ||
            //     //     Statics.userDetails["DaayitvaName"] == "प्रौढ व्यवसायी सह प्रमुख" ||
            //     //     Statics.userDetails["DaayitvaName"] == "प्रौढ व्यवसायी सह प्रमुख" ||
            //     //     Statics.userDetails["DaayitvaName"] == "Bal Vidyarthi Sah Pramukh" ||
            //     //     Statics.userDetails["DaayitvaName"] == "बाल विद्यार्थी सह प्रमुख" ||
            //     //     Statics.userDetails["DaayitvaName"] == "बाल विद्यार्थी सह प्रमुख" ||
            //     //     Statics.userDetails["DaayitvaName"] == "Mahavidyaleen Vidyarthi Sah Pramukh" ||
            //     //     Statics.userDetails["DaayitvaName"] == "महाविद्यालयीन विद्यार्थी सह प्रमुख" ||
            //     //     Statics.userDetails["DaayitvaName"] == "महाविद्यालयीन विद्यार्थी सह प्रमुख" ||
            //     //     Statics.userDetails["DaayitvaName"] == "App Sanyojak" ||
            //     //     Statics.userDetails["DaayitvaName"] == "एप संयोजक" ||
            //     //     Statics.userDetails["DaayitvaName"] == "Kaaryavaah" ||
            //     //     Statics.userDetails["DaayitvaName"] == "कार्यवाह" ||
            //     //     Statics.userDetails["DaayitvaName"] == "karyalay sachiv" ||
            //     //     Statics.userDetails["DaayitvaName"] == "कार्यालय सचिव" ||
            //     //     Statics.userDetails["DaayitvaName"] == "Saha-Kaaryavaah" ||
            //     //     Statics.userDetails["DaayitvaName"] == "सह कार्यवाह" ||
            //     //     Statics.userDetails["DaayitvaName"] == "Sewa Pramukh" ||
            //     //     Statics.userDetails["DaayitvaName"] == "सेवा प्रमुख" ||
            //     //     Statics.userDetails["DaayitvaName"] == "Saha-SewaPramukh" ||
            //     //     Statics.userDetails["DaayitvaName"] == "Sewa Vibhaag - Toli Sadasya" ||
            //     //     Statics.userDetails["DaayitvaName"] == "सेवा विभाग टोली सदस्य" ||
            //     //     Statics.userDetails["DaayitvaName"] == "Sewa Saha-Pramukh" ||
            //     //     Statics.userDetails["DaayitvaName"] == "सेवा सह प्रमुख" ||
            //     //     Statics.userDetails["DaayitvaName"] == "सेवा सह प्रमुख" ||
            //     //     Statics.userDetails['DaayitvaName'] == 'Kaaryaalay Pramukh' ||
            //     //     Statics.userDetails['DaayitvaName'] == 'कार्यालय प्रमुख' ||
            //     //     Statics.userDetails['DaayitvaName'] == 'Prachaarak' ||
            //     //     Statics.userDetails['DaayitvaName'] == 'प्रचारक' ||
            //     //     Statics.userDetails['DaayitvaName'] == 'Saha-Prachaarak' ||
            //     //     Statics.userDetails['DaayitvaName'] == 'सह प्रचारक' ||
            //     //     Statics.userDetails["DaayitvaName"] == "Kaaryavaah" ||
            //     //     Statics.userDetails["DaayitvaName"] == "कार्यवाह" ||
            //     //     Statics.userDetails["DaayitvaName"] == "karyalay sachiv" ||
            //     //     Statics.userDetails["DaayitvaName"] == "कार्यालय सचिव")
            //     )
            if ((int.tryParse(Statics.userDetails["LevelID"]?.toString() ?? "0") ?? 0) > 1)
              IconButton(
                padding: EdgeInsets.all(8),
                icon: const Icon(Icons.add),
                onPressed: () {
                  Navigator.of(context).pushNamed(EditSewaVasti.routeName, arguments: Statics.ScreenArguments(0, Statics.getLabel('EditMenu')));
                },
              ),
          ],
        ),
        drawer: AppDrawer(),
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(10),
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

                SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.75,
                  child: _isSearching
                      ? Center(child: CircularProgressIndicator())
                      : _sewaVastiList != null && _sewaVastiList!.length > 0
                          ? ListView.separated(
                              separatorBuilder: (context, index) => SizedBox(height: 8),
                              itemCount: _sewaVastiList!.length,
                              itemBuilder: (context, index) => SewaVastiCard(_sewaVastiList![index], onSaveDetails),
                            )
                          : Padding(
                              padding: const EdgeInsets.only(bottom: 178.0),
                              child: Center(child: Text(Statics.getLabel('noDataFoundTryAnotherSearch'))),
                            ),
                ),
              ],
            ),
          ),
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
                    ],
                  ),
                ),
                isExpanded: _isExpanded,
              ),
            ],
          ),
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
                  onPressed: _search,
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
                        _sewaVastiList = [];
                      });
                      ctrl.loadHierarchyForUser();
                    },
                    child: Text(Statics.getLabel('clear'))),
              ],
            ),
        ],
      );
    });
  }
}
