import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

import '../helpers/static_data.dart' as Statics;
import '../providers/bals.dart';
import '../utils/globals.dart';
import '../utils/stable_geounit_class.dart';
import '../widgets/legend.dart';

class SewaVastiDetails extends StatefulWidget {
  var sewaVastiID;
  var onSaveDetails;
  var viewType;

  SewaVastiDetails({Key? key, this.sewaVastiID, this.onSaveDetails, this.viewType}) : super(key: key);

  @override
  _SewaVastiDetailsState createState() => _SewaVastiDetailsState();
}

class _SewaVastiDetailsState extends State<SewaVastiDetails> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  var _isLoading = false;
  bool _isfetingData = false;
  SewaVastiList? sDetails;

  var _sewaVastiNameCntrl = TextEditingController();
  var _population = TextEditingController();
  var _remarkCntrl = TextEditingController();

  List<NecessitiesBAL> _necessities = [];

  final controller = createGeoController();

  @override
  void initState() {
    super.initState();
    // populateBhaagDropdown();
    int sewaVastiID = int.parse(widget.sewaVastiID);
    if (sewaVastiID > 0) {
      // populateDropdown();
      getSewaVastiDetails(widget.sewaVastiID);
    } else {
      if (!mounted) return;
      setState(() {
        // sDetails = new SewaVastiList(0, sewaVastiID, "", null, null, null, "", "", "", "", "", "", "", "");
        sDetails = new SewaVastiList(
            bhaagName: "",
            bhaagID: 0,
            graamID: "",
            graamName: "",
            mahaanagarID: 0,
            mahaanagarName: "",
            mandalID: "",
            mandalName: "",
            nagarID: 0,
            nagarName: "",
            necessarySewaTypeIDs: "",
            population: "",
            praantID: 0,
            remark: "",
            sewaVastiID: 0,
            sewaVastiName: "",
            shaharID: "",
            shaharName: "",
            vastiID: 0,
            vastiName: "",
            vibhaagID: 0,
            vibhaagName: "");
      });
      populateAreaDetails();
    }
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => initData());
  }

  Future<void> initData() async {
    final dm = await MyAppGlobals.getLevelLDB();

    await controller.initialize(dm);

    setState(() {});
  }

  void populateAreaDetails() async {
    var svn = await Statics.getStaticLDB("SewaVastiNecessity");
    _necessities = [];
    var svnArr = (sDetails == null || sDetails!.necessarySewaTypeIDs == null) ? [] : sDetails!.necessarySewaTypeIDs!.split(',');
    for (var data in svn) {
      _necessities.add(new NecessitiesBAL(data.staticID, data.code, data.codeForDisplay, (svnArr.contains(data.staticID.toString()) ? true : false)));
    }
  }

  void getSewaVastiDetails(var theId) async {
    setState(() {
      _isfetingData = true;
    });

    bool isConnected = await Statics.isInternetConnected();
    if (!isConnected) {
      Statics.showMessageDialog(context, Statics.getLabel('internetNotConnected'));
      setState(() {
        _isfetingData = false;
      });
      return;
    }

    final strInput = json.encode({"AppUserID": Statics.userDetails["userID"].toString(), "BhaagID": null, "ShaharID": null, "NagarID": null, "SewaVastiID": theId});

    final dataList = await Statics.getSewaVastiForApp(strInput);

    if (!mounted) return;

    SewaVastiList? data;
    if (dataList.isNotEmpty && dataList[0].isNotEmpty) {
      data = SewaVastiList.fromJson(dataList[0]);
    }

    sDetails = data;

    final trail = await controller.getTrailFromGeoUnitId((data?.graamID ?? data?.vastiID ?? data?.mandalID ?? data?.nagarID ?? data?.bhaagID ?? data?.vibhaagID).toString());

    if (trail != null) await controller.setHierarchyFromTrail(trail: trail);
    setState(() {
      if (sDetails == null) {
        _isfetingData = false;
        return;
      }

      _sewaVastiNameCntrl.text = sDetails?.sewaVastiName ?? "";

      // Primary dropdown values
      _population.text = sDetails?.population?.toString() ?? "";
      _remarkCntrl.text = sDetails?.remark ?? "";

      // Populate dropdowns

      populateAreaDetails();
      _isfetingData = false;
    });
  }

  Future<void> _submit() async {
    print("_submit 1");
    if (!_formKey.currentState!.validate()) {
      // Invalid!
      return;
    }
    if (_necessities.where((e) => e.isSelected == true).length <= 0) {
      print("_submit 2");

      Statics.showToast(Statics.getLabel('NecessitiesValidationMessage'));
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    // try {
    print("_submit 3");

    bool isConnected = await Statics.isInternetConnected();
    if (!isConnected) {
      print("_submit 4");

      Statics.showMessageDialog(context, Statics.getLabel('internetNotConnected'));
    } else {
      print("_submit 5");

      await saveSwDetails();
    }
    print("_submit 6");

    // } on Exception catch (error) {
    //   print("_submit 7");
    //   log("error :-  $error");
    //   Statics.showErrorDialog(context, Statics.getLabel('unableToCompleteProcess'));
    // } catch (error) {
    //   print("_submit 8");
    //
    //   Statics.showErrorDialog(context, Statics.getLabel('unableToCompleteProcess'));
    // }
    print("_submit 9 ");

    setState(() {
      _isLoading = false;
    });
  }

  saveSwDetails() async {
    var necessitiesIDs = '';

    for (var data in _necessities) {
      if (data.isSelected!) necessitiesIDs = necessitiesIDs + data.staticID.toString() + ",";
    }

    if (necessitiesIDs.trim() != '') necessitiesIDs = necessitiesIDs.substring(0, necessitiesIDs.length - 1);

    var inputData = json.encode({
      "SewaVastiID": widget.sewaVastiID,
      "PraantID": 1,
      "BhaagID": int.tryParse(controller.hierarchyTrail.bhaagId ?? ""),
      "ShaharID": null,
      "NagarID": int.tryParse(controller.hierarchyTrail.nagarId ?? ""),
      "SewaVastiName": sDetails!.sewaVastiName,
      "Population": sDetails!.population,
      "NecessarySewaTypeIDs": necessitiesIDs == "" ? null : necessitiesIDs,
      "Remark": sDetails!.remark,
      "type": controller.deepestSelectedLevelName ?? "praant",
      "geounitid": int.tryParse(controller.deepestSelectedGeoUnitId ?? ""),
      "ModifiedBy": Statics.userDetails["userID"].toString()
    });
    var data = await Statics.saveSewaVastiForApp(inputData);
    setState(() {
      widget.sewaVastiID = data;
      widget.onSaveDetails(widget.sewaVastiID);
      Statics.showToast(Statics.getLabel('dataSavedSuccessfully'));
    });
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20),
            width: Statics.getDeviceSize(context).width,
            child: AbsorbPointer(
              absorbing: widget.viewType == "ViewMenu" ? true : false,
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Legend(legendString: "searchSewaVastiScreenLabel", fontsize: 18),
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      controller: _sewaVastiNameCntrl,
                      decoration: InputDecoration(
                        labelText: Statics.getLabel('SewaVastiName'),
                      ),
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value!.isEmpty) return (Statics.getLabel('SewaVastiNameValidationMessage'));
                        return null;
                      },
                      onSaved: (value) {
                        sDetails!.sewaVastiName = value!.trim();
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),

                    ///
                    dropdownSection(),

                    ///

                    Legend(legendString: 'Necessities', fontsize: 18),
                    Container(
                      width: Statics.getDeviceSize(context).width * 0.8,
                      child: ListView(
                        shrinkWrap: true,
                        children: _necessities.map((area) {
                          return new CheckboxListTile(
                            // dense: true,
                            controlAffinity: ListTileControlAffinity.leading,
                            title: new Text(area.codeForDisplay!),
                            value: area.isSelected,
                            activeColor: Colors.purple,
                            checkColor: Colors.white,
                            onChanged: (bool? value) {
                              setState(() {
                                area.isSelected = value;
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ),
                    SizedBox(height: 40),
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      controller: _population,
                      decoration: InputDecoration(labelText: Statics.getLabel('Population')),
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value!.isEmpty) return (Statics.getLabel('PopulationValidationMessage'));
                        return null;
                      },
                      onSaved: (value) {
                        sDetails!.population = value!.trim();
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      controller: _remarkCntrl,
                      decoration: InputDecoration(labelText: Statics.getLabel('Remark')),
                      keyboardType: TextInputType.emailAddress,
                      maxLength: 100,
                      onSaved: (value) {
                        if (value!.isNotEmpty)
                          sDetails!.remark = value;
                        else
                          sDetails!.remark = null;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    if (_isLoading)
                      CircularProgressIndicator()
                    else if (widget.viewType == "ViewMenu")
                      Text(Statics.getLabel('canNotMakeChanges'))
                    else
                      MaterialButton(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        padding: EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 8,
                        ),
                        color: Theme.of(context).primaryColor,
                        textColor: Theme.of(context).primaryTextTheme.labelMedium?.color,
                        onPressed: _submit,
                        child: Text(
                          Statics.getLabel('Submit'),
                          style: TextStyle(fontSize: 25),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
        inAsyncCall: _isfetingData);
  }

  Widget dropdownSection() {
    return ChangeNotifierProvider.value(
      value: controller,
      child: Consumer<GeoHierarchyController>(builder: (_, ctrl, __) {
        return Container(
          margin: EdgeInsets.all(10),
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
        );
      }),
    );
  }
}
