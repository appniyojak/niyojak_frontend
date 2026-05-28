import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../helpers/static_data.dart' as Statics;
import '../../models/response_model/geounit_name_model.dart';
import '../../providers/bals.dart';
import '../../utils/globals.dart';
import '../../utils/stable_geounit_class.dart';

class UpdateMasterDataScreen extends StatefulWidget {
  static const routeName = '/master-data-update';

  @override
  _UpdateMasterDataScreenState createState() => _UpdateMasterDataScreenState();
}

class _UpdateMasterDataScreenState extends State<UpdateMasterDataScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => initData());
  }

  // ====================================  DATA TYPE ============================================
  bool _isSearching = false;
  bool viewcontainer = false;
  bool _isExpanded = true;

  List<StaticMasterBAL>? _baithakTypes;
  GetgeounitNameModel? getgeounitNameModel;

  TextEditingController marathiNameController = TextEditingController();
  TextEditingController hindiNameController = TextEditingController();
  TextEditingController englishNameController = TextEditingController();

  Future<void> initData() async {
    final dm = await MyAppGlobals.getLevelLDB();

    final controller = context.read<GeoHierarchyController>();

    await controller.initialize(dm);

    await populateDropdown();
    setState(() {});
  }

  final GlobalKey<FormState> _formKey = GlobalKey();

// ==================   DROP - DOWNS =================================

  Future<void> populateDropdown({bool fromClear = false}) async {
    setState(() => viewcontainer = false);
    var data = await Statics.getStaticLDB('AnnualBaithakType');
    if (!mounted) return;
    _baithakTypes = data;
    _baithakTypes = _baithakTypes!.where((element) => element.showAnnualBaithakkey!.contains('1')).toList();
    print("_baithakTypes :-- $_baithakTypes");
    setState(() {});
  }

  Future<void> getData(String? selectedGeoUnitId) async {
    var inputData = json.encode({
      "GeoUnitID": selectedGeoUnitId,
    });
    print("getData" + inputData);
    getgeounitNameModel = await Statics.getlevelUpdatedata(inputData);

    setState(() {
      marathiNameController.text = getgeounitNameModel!.geoUnitNameMarathi!;
      hindiNameController.text = getgeounitNameModel!.geoUnitNameHindi!;
      englishNameController.text = getgeounitNameModel!.geoUnitName!;
      viewcontainer = true;
      _isExpanded = false;
    });
  }

  void _submitForm(GeoHierarchyController controller) {
    var inputData = json.encode({
      "GeoUnitID": controller.deepestSelectedGeoUnitId,
      "ParentMahaanagarID": controller.hierarchyTrail.mahaanagarId,
      "ParentVibhaagID": controller.hierarchyTrail.vibhaagId,
      "ParentBhaagID": controller.hierarchyTrail.bhaagId,
      "ParentNagarID": controller.hierarchyTrail.nagarId,
      "ParentUpaNagarID": controller.hierarchyTrail.upnagarId,
      "ParentMandalID": controller.hierarchyTrail.mandalId,
      "ParentGraamID": controller.hierarchyTrail.graamId,
      "ParentVastiID": controller.hierarchyTrail.vastiId,
      "GeoUnitNameMarathi": marathiNameController.text,
      "GeoUnitNameHindi": hindiNameController.text,
      "GeoUnitName": englishNameController.text,
    });
    print("_submitForm" + inputData);
    Statics.savelevelUpdatedata(context, inputData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: SingleChildScrollView(
            child: Column(
          children: [
            vastiGraamDropdown(),
//======================================================   EDIT VIEW ===============================================================
            if (viewcontainer == true)
              Consumer<GeoHierarchyController>(builder: (_, ctrl2, __) {
                return Container(
                  width: double.infinity,
                  decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.all(Radius.circular(15))),
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
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
                              "${Statics.getLabel(ctrl2.deepestSelectedLevelName ?? "praant")}",
                              style: TextStyle(color: Colors.purpleAccent, fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            if (ctrl2.deepestSelectedGeoUnitName != null && ctrl2.deepestSelectedGeoUnitName!.isNotEmpty)
                              Text(
                                "  ->   ${ctrl2.deepestSelectedGeoUnitName}",
                                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 17),
                              ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              TextFormField(
                                controller: marathiNameController,
                                keyboardType: TextInputType.text,
                                textDirection: TextDirection.ltr,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: "मराठीत नाव",
                                  labelText: "मराठीत नाव",
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "कृपया मराठी नाव प्रविष्ट करा";
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 20),
                              TextFormField(
                                controller: hindiNameController,
                                keyboardType: TextInputType.text,
                                textDirection: TextDirection.ltr,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: "हिंदी में नाम",
                                  labelText: "हिंदी में नाम",
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "कृपया हिंदी नाम दर्ज करें";
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 20),
                              TextFormField(
                                controller: englishNameController,
                                keyboardType: TextInputType.text,
                                textDirection: TextDirection.ltr,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: "Name in English",
                                  labelText: "Name in English",
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Please enter the name in English";
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 20),
                              ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    _submitForm(ctrl2);
                                  }
                                },
                                child: Text(Statics.getLabel('Submit'), style: TextStyle(fontSize: 18)),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                );
              })
          ],
        )),
      ),
    );
  }

  Widget vastiGraamDropdown() {
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
                      onPressed: () => getData(ctrl.deepestSelectedGeoUnitId),
                      child: Text(
                        Statics.getLabel('ViewMenu'),
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    MaterialButton(
                        onPressed: () {
                          setState(() {
                            _isSearching = false;
                            marathiNameController.clear();
                            hindiNameController.clear();
                            englishNameController.clear();
                            viewcontainer = false;
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
    });
  }
}
