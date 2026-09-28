import 'dart:convert';
import 'dart:developer';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../helpers/static_data.dart' as Statics;
import '../../../models/response_model/new_search_swayamsevak_model.dart';
import '../../../models/response_model/shaakhaa_vistar_detail_resp_model.dart';
import '../../../providers/bals.dart';
import '../../../utils/globals.dart';
import '../../../utils/stable_geounit_class.dart';
import '../../swayamsevak_module/edit_module/edit_swayamsevak_screen.dart';

class AddNewShaakhaaVistaarScreen extends StatefulWidget {
  static const routeName = '/add-new-shakhaa-vistar-screen';

  const AddNewShaakhaaVistaarScreen({super.key});

  @override
  State<AddNewShaakhaaVistaarScreen> createState() => _AddNewShaakhaaVistaarScreenState();
}

enum KaryakartaSearchStage { search, searching, found, notfound, nameOnly }

class _AddNewShaakhaaVistaarScreenState extends State<AddNewShaakhaaVistaarScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  var _isLoading = false;
  bool _isfetchingData = false;
  Map<String, dynamic>? args;

  final controller = createGeoController();

  int? pkidPassed;
  int? geoidPassed;

  bool _isSankalpit = true;

  var _shaakhaanameCtrl = TextEditingController();

  List<StaticMasterBAL>? _vayogat;

  ShakhaaVistarDetail? shaakhaa;

  String? _vayogatValue;

  var bhaagID;

  // ===================== आधार कार्यकर्ता जोडा (new flow) =====================
  // Entries added via mobile-search have a non-null swayamSevakID (system match).
  // Entries added via "name only" / "add new person" have swayamSevakID == null.
  List<SwayamsevakNewData> _karyakartaList = [];

  KaryakartaSearchStage _karyakartaStage = KaryakartaSearchStage.search;

  // SwayamsevakNewData? _foundKaryakarta;
  List<SwayamsevakNewData> _foundKaryakartaList = [];

  final TextEditingController _mobileSearchCtrl = TextEditingController();
  final TextEditingController _nameOnlyCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => initData());
    // if (!mounted) return;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    pkidPassed = int.tryParse((args?["pkid"] ?? 0).toString());
    geoidPassed = int.tryParse((args?["geoid"] ?? 0).toString());
    // log("LOG >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> $args");
  }

  Future<void> initData() async {
    final dm = await MyAppGlobals.getLevelLDB();

    if (args != null && geoidPassed != null && geoidPassed != 0) {
      final trail = await controller.getTrailFromGeoUnitId((geoidPassed ?? 0).toString());
      if (trail != null) await controller.setHierarchyFromTrail(trail: trail, setMahanagar: false);
    } else {
      await controller.initialize(dm);
    }

    setState(() {});
    await populateDropdown();
    getShaakhaaDetails();
  }

  @override
  void dispose() {
    super.dispose();
    _shaakhaanameCtrl.dispose();
    _mobileSearchCtrl.dispose();
    _nameOnlyCtrl.dispose();
  }

  // 1. Prepare data to SEND to the API
  Map<String, dynamic> preparePayloadForApi(Map<String, dynamic> payload) {
    for (int i = 1; i <= 5; i++) {
      if (i <= _karyakartaList.length) {
        payload['aadhar$i'] = (_karyakartaList[i - 1].fullName ?? '').toString().trim();
      } else {
        payload['aadhar$i'] = ""; // Set empty if entry doesn't exist
      }
    }
    return payload;
  }

  Future<void> populateDropdown() async {
    var data = await Statics.getStaticLDB('ShaakhaaFrequency');
    var data2 = await Statics.getStaticLDB('ShaakhaaVayogat');
    var data3 = await Statics.getStaticLDB('ShaakhaaStatus');
    var data4 = await Statics.getStaticLDB('ShaaririkVishay');

    if (!mounted) return;
    setState(() {
      _vayogat = data2;
    });
  }

  void getShaakhaaDetails() async {
    log("Shakha IDDD :-  $pkidPassed");

    if (pkidPassed == null || pkidPassed == 0) return;

    setState(() {
      _isfetchingData = true;
    });
    bool isConnected = await Statics.isInternetConnected();
    if (!isConnected) {
      Statics.showMessageDialog(context, Statics.getLabel('internetNotConnected'));
    } else {
      var data = await Statics.getShaakhaaSaptahByIdData(context, (pkidPassed ?? 0).toString(), Statics.userDetails["userID"].toString());
      log("data -=-=-=>>>>>  $data");
      if (!mounted) return;
      shaakhaa = data;
      if (shaakhaa != null) {
        final trail = await controller.getTrailFromGeoUnitId((shaakhaa?.parentGraamID ?? shaakhaa?.parentVastiID).toString());

        if (trail != null) await controller.setHierarchyFromTrail(trail: trail);

        _shaakhaanameCtrl.text = data?.shaakhaaName ?? "";

        _karyakartaList = data?.shaakhaaVistarAadharList ?? [];

        setState(() {
          _vayogatValue = (shaakhaa?.vayogatID == null || shaakhaa?.vayogatID == 0) ? null : (shaakhaa?.vayogatID ?? "").toString();
        });
      }
    }
    setState(() {
      _isfetchingData = false;
    });
  }

  // 2. Load data received FROM the API (pre-existing saved names have no
  // swayamSevakID/mobile info stored against them, so they're loaded as
  // "name only" entries).
  void loadDataFromModel(ShakhaaVistarDetail model) {
    // setState(() {
    //   _karyakartaList.clear();
    //
    //   final apiFields = model.;
    //
    //   for (String? value in apiFields) {
    //     if (value != null && value.trim().isNotEmpty) {
    //       _karyakartaList.add(SwayamsevakNewData(fullName: value.trim()));
    //     }
    //   }
    // });
  }

  Future<List<SwayamsevakNewData>> populateSankalpAadhaarSwayamsevak(String pattern) async {
    if (pattern.length <= 2) return [];

    final inpt = {
      'AppUserID': Statics.userDetails["userID"],
      'GeounitId': controller.hierarchyTrail.vastiId ?? controller.hierarchyTrail.graamId,
      "SearchText": pattern.isEmpty ? "" : pattern,
      "From": "vistar",
    };

    var swList = await Statics.searchSwayamsevakNewData(inpt);

    return swList ?? [];
  }

  saveShaakhaaDetails() async {
    var inputData = {
      "PraantID": 1,
      "PkId": pkidPassed ?? 0,
      "ParentBhaagID": int.tryParse(controller.hierarchyTrail.bhaagId ?? ""),
      "ParentShaharID": null,
      //_shaharValue == null || _shaharValue!.isEmpty ? null : _shaharValue,
      "ParentNagarID": int.tryParse(controller.hierarchyTrail.nagarId ?? ""),
      "ParentMandalID": int.tryParse(controller.hierarchyTrail.mandalId ?? ""),
      "ParentGraamID": int.tryParse(controller.hierarchyTrail.graamId ?? ""),
      "ParentVastiID": int.tryParse(controller.hierarchyTrail.vastiId ?? ""),
      "ShaakhaaID": 0,
      "ShaakhaaName": _shaakhaanameCtrl.text,
      "ShaakhaaNameDevNaagari": _shaakhaanameCtrl.text,
      "VayogatID": int.tryParse(_vayogatValue ?? ""),
      "aadhardata": _karyakartaList.map((e) => e.toJson()).toList(),

      "FrequencyID": 36,

      "DaysOfWeek": shaakhaa?.daysOfWeek ?? '',
      "DayOfMonth": shaakhaa?.dayOfMonth ?? '',
      "Location": shaakhaa?.location,
      //"Timing": shaakhaa!.timing,
      /*"StartTimeStr": (_fromTime != null
          ? DateFormat("hh:mm").format(new DateFormat("yyyy-MM-dd hh:mm").parse("2021-02-01 " + _fromTime!.hour.toString() + ":" + _fromTime!.minute.toString())) +
              (_fromTime!.period == DayPeriod.am ? " AM" : " PM")
          : null),
      "EndTimeStr": (_toTime != null
          ? DateFormat("hh:mm").format(new DateFormat("yyyy-MM-dd hh:mm").parse("2021-02-01 " + _toTime!.hour.toString() + ":" + _toTime!.minute.toString())) +
              (_toTime!.period == DayPeriod.am ? " AM" : " PM")
          : null),*/
      "StartTimeStr": "",
      "EndTimeStr": "",
      "Remark": shaakhaa?.remark ?? "",
      "IsSankalpit": _isSankalpit == true ? true : false,
//========================= OLD REQ PARAM =============================================================================================================================================================================
      "SankalpAadhaar": null,
      //(_isSankalpit ? _sankalpAadhaarEnum.toString().split('.').last : null),
      "SankalpAadhaarSwayamsevakID": (_isSankalpit ? shaakhaa?.sankalpAadhaarSwayamsevakID : null),
      "SankalpAadhaarShaakhaaID": (_isSankalpit ? shaakhaa?.sankalpAadhaarShaakhaaID : null),
      "SankalpCompletionMonth": (_isSankalpit ? shaakhaa?.sankalpCompletionMonth : null),
      "SankalpCompletionYear": (_isSankalpit ? shaakhaa?.sankalpCompletionYear : null),

      "HasToli": false,
      "HasPaalak": false,
      "OtherOptionalVishay": shaakhaa?.otherOptionalVishay ?? "",
      "OptionalShaaririkVishayID": shaakhaa?.optionalShaaririkVishayID,
      "ModifiedBy": int.tryParse(Statics.userDetails["userID"]) ?? 0
    };

    log("inputData =-=->  ${json.encode(inputData)}");

    var data = await Statics.addNewShaakhaaVistarData(context, inputData);
    if (data == null) return;
    setState(() {});
    if (data == "200") {
      Statics.showToast(Statics.getLabel('dataSavedSuccessfully'));
      Navigator.of(context).pop(true);
    }
  }

  Future<void> _submit() async {
    print("_submit 1");
    if (!_formKey.currentState!.validate()) {
      print("_submit 2");

      // Invalid!
      return;
    }
    print("_submit 3");

    _formKey.currentState?.save();
    setState(() {
      _isLoading = true;
    });
    try {
      print("_submit 4");

      bool isConnected = await Statics.isInternetConnected();
      if (!isConnected) {
        print("_submit 5");

        Statics.showMessageDialog(context, Statics.getLabel('internetNotConnected'));
      } else {
        print("_submit 6");

        await saveShaakhaaDetails();
      }
      print("_submit 7");
    } catch (error) {
      print("_submit 9");

      Statics.showErrorDialog(context, Statics.getLabel('unableToCompleteProcess'));
    }
    print("_submit 10");

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Statics.getLabel('EditShaakhaaVistar')),
      ),
      body: ModalProgressHUD(
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(20),
              width: Statics.getDeviceSize(context).width,
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      controller: _shaakhaanameCtrl,
                      decoration: InputDecoration(labelText: Statics.getLabel('ShaakhaaNameVistar')),
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value!.isEmpty) return (Statics.getLabel('ShaakhaaNameVistarValidationMessage'));
                        return null;
                      },
                      onSaved: (value) {
                        shaakhaa?.shaakhaaName = value;
                      },
                    ),
                    SizedBox(height: 10),

                    ///
                    ChangeNotifierProvider.value(
                      value: controller,
                      child: Consumer<GeoHierarchyController>(builder: (_, ctrl, __) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (ctrl.hasItems(GeoLevel.Vibhaag))
                              GeoDropdownWidget(
                                level: GeoLevel.Vibhaag,
                                title: 'Vibhaag',
                                controller: ctrl,
                                isDisabled: (userLevelId ?? 0) < 8 || userLevelId == 13,
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
                                isDisabled: (userLevelId ?? 0) < 7 || userLevelId == 13,
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
                                isDisabled: (userLevelId ?? 0) < 6 || userLevelId == 13,
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
                                isDisabled: (userLevelId ?? 0) < 6 || userLevelId == 13,
                              ),

                            if (ctrl.hasItems(GeoLevel.Mandal))
                              GeoDropdownWidget(
                                level: GeoLevel.Mandal,
                                title: 'Mandal',
                                controller: ctrl,
                                isDisabled: (userLevelId ?? 0) < 4,
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
                                isDisabled: userLevelId == 3,
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
                                isDisabled: userLevelId == 2,
                                validator: (v) {
                                  if (v == null || v!.isEmpty) return (Statics.getLabel('VastiValidationMessage'));
                                  return null;
                                },
                              ),
                          ],
                        );
                      }),
                    ),

                    ///

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
                          print(value);
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) return (Statics.getLabel('VayogatValidationMessage'));
                          return null;
                        },
                        onSaved: (value) {
                          if (value != null && value.isNotEmpty)
                            shaakhaa?.vayogatID = int.parse(value);
                          else
                            shaakhaa?.vayogatID = null;
                        },
                      ),
                    SizedBox(height: 10),
                    /*IgnorePointer(
                      ignoring: true,
                      child: CheckboxListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 0),
                        controlAffinity: ListTileControlAffinity.leading,
                        title: Text(Statics.getLabel('IsSankalpit'), style: TextStyle(fontSize: 15)),
                        checkColor: Colors.white,
                        activeColor: Colors.purple,
                        value: _isSankalpit,
                        onChanged: (value) {
                          setState(() {
                            _isSankalpit = value!;
                          });
                        },
                      ),
                    ),*/

                    // ===== नवीन UI: आधार कार्यकर्ता जोडा (मोबाईल-शोध आधारित) =====
                    buildAadharKaryakartaSection(),

                    SizedBox(height: 21),

                    if (_isLoading)
                      CircularProgressIndicator()
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
          inAsyncCall: _isfetchingData),
    );
  }

  // ------------------- karyakarta search/add helpers -------------------

  bool _isDuplicateKaryakarta(String name) {
    return _karyakartaList.any((w) => (w.fullName ?? '').trim().toLowerCase() == name.trim().toLowerCase());
  }

  Future<void> _searchKaryakartaByMobile() async {
    final mobile = _mobileSearchCtrl.text.trim();
    if (mobile.length < 5) {
      Statics.showToast(Statics.getLabel('EnterValidMobileNumber'));
      return;
    }

    setState(() {
      _karyakartaStage = KaryakartaSearchStage.searching;
    });

    final results = await populateSankalpAadhaarSwayamsevak(mobile);

    // for (var item in results) {
    //   if (item.mobileNumber == mobile) {
    //     match = item;
    //     break;
    //   }
    // }

    if (!mounted) return;

    if (results.isNotEmpty) {
      setState(() {
        _foundKaryakartaList.addAll(results);
        _karyakartaStage = KaryakartaSearchStage.found;
      });
    } else {
      setState(() {
        // _foundKaryakarta = null;
        _foundKaryakartaList = [];
        _karyakartaStage = KaryakartaSearchStage.notfound;
      });
    }
  }

  void _resetKaryakartaSearch() {
    setState(() {
      _mobileSearchCtrl.clear();
      _foundKaryakartaList = [];
      _karyakartaStage = KaryakartaSearchStage.search;
    });
  }

  void _switchToNameOnlyKaryakarta() {
    Navigator.of(context).pushNamed(EditSwayamsevakScreen.routeName, arguments: Statics.ScreenArgumentsNew(0, Statics.getLabel('EditMenu'))).then((value) => initData());
  }

  void _confirmAddFoundKaryakarta(SwayamsevakNewData karyakarta) {
    if (_foundKaryakartaList.isEmpty) return;
    final name = (karyakarta.fullName ?? '').trim();

    if (name.isEmpty) return;

    if (_isDuplicateKaryakarta(name)) {
      Statics.showToast(Statics.getLabel('duplicationValidation'));
      return;
    }

    if (_karyakartaList.length >= 5) {
      Statics.showToast(Statics.getLabel('MaxKaryakartaLimitReached'));
      return;
    }

    setState(() {
      _karyakartaList.add(karyakarta);
    });

    _resetKaryakartaSearch();
  }

  void _addNameOnlyKaryakarta() {
    final name = _nameOnlyCtrl.text.trim();
    if (name.isEmpty) {
      Statics.showToast(Statics.getLabel('ShaakhaaNameVistarValidationMessage'));
      return;
    }

    if (_isDuplicateKaryakarta(name)) {
      Statics.showToast(Statics.getLabel('duplicationValidation'));
      return;
    }

    if (_karyakartaList.length >= 5) {
      Statics.showToast(Statics.getLabel('MaxKaryakartaLimitReached'));
      return;
    }

    setState(() {
      _karyakartaList.add(SwayamsevakNewData(fullName: name));
    });

    _resetKaryakartaSearch();
  }

  void _removeKaryakarta(int index) {
    setState(() {
      _karyakartaList.removeAt(index);
    });
  }

  void _savePersonAndReturnKaryakarta(String name, String mobile) {
    if (name.trim().isEmpty || mobile.trim().length != 10) {
      Statics.showToast(Statics.getLabel('unableToCompleteProcess'));
      return;
    }

    if (_isDuplicateKaryakarta(name.trim())) {
      Statics.showToast(Statics.getLabel('duplicationValidation'));
      Navigator.of(context).pop();
      return;
    }

    if (_karyakartaList.length >= 5) {
      Statics.showToast(Statics.getLabel('MaxKaryakartaLimitReached'));
      Navigator.of(context).pop();
      return;
    }

    Navigator.of(context).pop();

    setState(() {
      _karyakartaList.add(SwayamsevakNewData(
        fullName: name.trim(),
        mobileNumber: mobile.trim(),
      ));
    });

    _resetKaryakartaSearch();
  }

  // ------------------- karyakarta widget-building functions -------------------
  // (functions returning Widgets, not separate Widget classes)

  Widget buildSectionDivider(String title) {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.only(top: 32, bottom: 6),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          decoration: TextDecoration.underline,
          decorationThickness: 2,
        ),
      ),
    );
  }

  Widget buildKaryakartaTip(String tipKey, {Color? borderColor}) {
    return Container(
      margin: const EdgeInsets.only(top: 16, bottom: 22),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFBF8FC),
        borderRadius: BorderRadius.circular(8),
        border: Border(left: BorderSide(color: borderColor ?? Color(0xFF9C27B0), width: 4)),
      ),
      child: RichText(
        text: TextSpan(
          style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey.shade700, fontWeight: FontWeight.w600, fontSize: 13.5),
          children: [
            TextSpan(
              text: "* ${Statics.getLabel('Note')} : ",
              style: const TextStyle(color: Color(0xFFC23B3B), fontStyle: FontStyle.normal, fontWeight: FontWeight.w600, decoration: TextDecoration.underline, decorationColor: Color(0xFFC23B3B)),
            ),
            TextSpan(text: Statics.getLabel(tipKey)),
          ],
        ),
      ),
    );
  }

  Widget buildKaryakartaSearchStage() {
    if (_karyakartaList.length == 5) return SizedBox();
    final isSearching = _karyakartaStage == KaryakartaSearchStage.searching;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(Statics.getLabel('searchUsingMobile'), style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
        const SizedBox(height: 6),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: TextField(
                controller: _mobileSearchCtrl,
                keyboardType: TextInputType.phone,
                maxLength: 10,
                decoration: InputDecoration(
                  counterText: '',
                  hintText: Statics.getLabel('addAbhiyaanKaryakartaValidation2'),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
            const SizedBox(width: 10),
            ElevatedButton.icon(
              onPressed: isSearching ? null : _searchKaryakartaByMobile,
              icon: isSearching
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Icon(Icons.search, size: 18),
              label: isSearching ? const SizedBox.shrink() : Text(Statics.getLabel('Search')),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF9C27B0),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: _switchToNameOnlyKaryakarta,
          child: RichText(
            text: TextSpan(
              style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
              children: [
                TextSpan(text: "${Statics.getLabel('MobileNumberNotAvailable')} ?"),
                TextSpan(
                  text: Statics.getLabel('AddNewPerson'),
                  style: const TextStyle(color: Color(0xFF9C27B0), fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget buildKaryakartaFoundStage() {
    return Column(
      children: [
        Row(
          spacing: 12,
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                margin: const EdgeInsets.only(bottom: 14),
                decoration: BoxDecoration(color: const Color(0xFFE9F8EF), borderRadius: BorderRadius.circular(12)),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle, color: Color(0xFF1F9254), size: 18),
                    const SizedBox(width: 8),
                    Text(Statics.getLabel('KaryakartaFound'), style: const TextStyle(color: Color(0xFF1F9254))),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: GestureDetector(
                onTap: _resetKaryakartaSearch,
                child: Text("\u2190 ${Statics.getLabel('SearchAgain')}", style: const TextStyle(color: Color(0xFF9C27B0), fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
        for (int i = 0; i < _foundKaryakartaList.length; i++)
          if (_karyakartaList.any((e) => e.swayamSevakID == _foundKaryakartaList[i].swayamSevakID)) SizedBox() else buildKaryakartaListItem(i, _foundKaryakartaList),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget buildKaryakartaNotFoundStage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          margin: const EdgeInsets.only(bottom: 14),
          decoration: BoxDecoration(color: const Color(0xFFFCEDED), borderRadius: BorderRadius.circular(12)),
          child: Row(
            children: [
              const Icon(Icons.cancel, color: Color(0xFFC23B3B), size: 18),
              const SizedBox(width: 8),
              Expanded(child: Text(Statics.getLabel('MobileNumberNotFound'), style: const TextStyle(color: Color(0xFFC23B3B)))),
            ],
          ),
        ),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: _resetKaryakartaSearch,
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF9C27B0),
                  side: const BorderSide(color: Color(0xFF9C27B0), width: 1.5),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(Statics.getLabel('SearchAgain')),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ElevatedButton(
                onPressed: () =>
                    Navigator.of(context).pushNamed(EditSwayamsevakScreen.routeName, arguments: Statics.ScreenArgumentsNew(0, Statics.getLabel('EditMenu'), mobile: _mobileSearchCtrl.text.trim())),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF9C27B0),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(Statics.getLabel('AddNewPerson')),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget buildKaryakartaNameOnlyStage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(Statics.getLabel('KaryakartaName'), style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFE8E1EA), width: 1.5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: _nameOnlyCtrl,
            decoration: InputDecoration(border: InputBorder.none, hintText: Statics.getLabel('EnterName')),
          ),
        ),
        GestureDetector(
          onTap: _resetKaryakartaSearch,
          child: Text("\u2190 ${Statics.getLabel('searchUsingMobile')}", style: const TextStyle(color: Color(0xFF9C27B0), fontWeight: FontWeight.w600)),
        ),
        const SizedBox(height: 12),
        Align(
          alignment: Alignment.centerLeft,
          child: ElevatedButton(
            onPressed: _addNameOnlyKaryakarta,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF9C27B0),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text(Statics.getLabel('Add')),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget buildKaryakartaSearchFlow() {
    switch (_karyakartaStage) {
      case KaryakartaSearchStage.found:
        return buildKaryakartaFoundStage();
      case KaryakartaSearchStage.notfound:
        return buildKaryakartaNotFoundStage();
      case KaryakartaSearchStage.nameOnly:
        return buildKaryakartaNameOnlyStage();
      case KaryakartaSearchStage.search:
      case KaryakartaSearchStage.searching:
        return buildKaryakartaSearchStage();
    }
  }

  Widget buildKaryakartaListItem(int index, List<SwayamsevakNewData> karyaList, {bool isRemove = false}) {
    final worker = karyaList[index];
    final name = (worker.fullName ?? '').toString();
    final mobile = worker.mobileNumber;
    final level = worker.levelName;
    final daayitva = worker.daayitvaName;
    final isAnya = worker.isanya == 1;
    final initial = name.trim().isNotEmpty ? name.trim()[0] : '?';

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      decoration: BoxDecoration(
          color: isAnya ? Color(0xFFFADDCE) : Color(0xFFFBF8FC), border: Border.all(color: isAnya ? Colors.orange.shade300 : Colors.transparent, width: 1.2), borderRadius: BorderRadius.circular(14)),
      child: Row(
        children: [
          CircleAvatar(
            radius: 19,
            backgroundColor: const Color(0xFF9C27B0),
            child: Text(initial, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              spacing: 2,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                if (mobile != null && mobile.isNotEmpty)
                  RichText(
                      text: TextSpan(
                          text: mobile,
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              launch("tel://" + mobile.toString());
                            },
                          style: TextStyle(fontSize: 13.5, color: Colors.blue.shade600, fontWeight: FontWeight.w600))),
                Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: [
                    if (level != null && level.isNotEmpty)
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(color: Colors.orange.shade100, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.orange, width: 0.7)),
                        child: Text(level, style: TextStyle(fontSize: 12.5, color: Colors.orange.shade600, fontWeight: FontWeight.w700)),
                      ),
                    if (daayitva != null && daayitva.isNotEmpty)
                      Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(color: Colors.green.shade100, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.green, width: 0.7)),
                          child: Text(daayitva, style: TextStyle(fontSize: 12.5, color: Colors.green.shade600, fontWeight: FontWeight.w700))),
                  ],
                ),
              ],
            ),
          ),
          /*Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: verified ? const Color(0xFFE9F8EF) : const Color(0xFFFFF3D6),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              verified ? Statics.getLabel('Verified') : Statics.getLabel('NameOnly'),
              style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: verified ? const Color(0xFF1F9254) : const Color(0xFF9A6A00)),
            ),
          ),*/
          isRemove
              ? IconButton(
                  icon: Icon(Icons.close, color: Colors.grey.shade600, size: 20),
                  tooltip: Statics.getLabel('Remove'),
                  onPressed: () => _removeKaryakarta(index),
                )
              : ElevatedButton(
                  onPressed: () => _confirmAddFoundKaryakarta(worker),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1F9254),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text("+ ${Statics.getLabel('Add')}"),
                ),
        ],
      ),
    );
  }

  Widget buildKaryakartaList() {
    if (_karyakartaList.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(top: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(Statics.getLabel('AddedKaryakarta'), style: TextStyle(fontSize: 14, color: Colors.grey.shade600, fontWeight: FontWeight.w600)),
          const SizedBox(height: 10),
          for (int i = 0; i < _karyakartaList.length; i++) buildKaryakartaListItem(i, _karyakartaList, isRemove: true),
        ],
      ),
    );
  }

  Widget buildAadharKaryakartaSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildSectionDivider(Statics.getLabel('addAadharPerson')),
        buildKaryakartaTip('addAadharPersonTip'),
        buildKaryakartaTip('searchAadharPersonTip', borderColor: Color(0xFFB06C27)),
        buildKaryakartaSearchFlow(),
        buildKaryakartaList(),
        /*if (_karyakartaList.length < 5)
          GestureDetector(
            onTap: _resetKaryakartaSearch,
            child: Container(
              margin: const EdgeInsets.only(top: 14),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 22,
                    height: 22,
                    decoration: const BoxDecoration(color: Color(0xFF9C27B0), shape: BoxShape.circle),
                    child: const Icon(Icons.add, color: Colors.white, size: 15),
                  ),
                  const SizedBox(width: 6),
                  Text(Statics.getLabel('AddAnotherKaryakarta'), style: const TextStyle(color: Color(0xFF9C27B0), fontWeight: FontWeight.bold, fontSize: 14.5)),
                ],
              ),
            ),
          ),*/
      ],
    );
  }

  // builds the content of the "add new person" bottom sheet (function, not a class)
  Widget buildAddPersonSheetContent(BuildContext sheetCtx, TextEditingController nameCtrl, TextEditingController mobileCtrl) {
    return StatefulBuilder(
      builder: (ctx, setModalState) {
        return SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(Statics.getLabel('AddNewPerson'), style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                  GestureDetector(
                    onTap: () => Navigator.of(ctx).pop(),
                    child: Icon(Icons.close, color: Colors.grey.shade600),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                Statics.getLabel('AddNewPersonSubtitle'),
                style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 18),
              Text(Statics.getLabel('FullName'), style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
              const SizedBox(height: 6),
              TextField(
                controller: nameCtrl,
                decoration: InputDecoration(
                  hintText: Statics.getLabel('FullNameHint'),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 16),
              Text(Statics.getLabel('MobileNumber'), style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
              const SizedBox(height: 6),
              TextField(
                controller: mobileCtrl,
                keyboardType: TextInputType.phone,
                maxLength: 10,
                decoration: InputDecoration(
                  counterText: '',
                  hintText: Statics.getLabel('MobileNumberHint'),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 6),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _savePersonAndReturnKaryakarta(nameCtrl.text, mobileCtrl.text),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF9C27B0),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(Statics.getLabel('SaveAndReturn')),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

// =============================================================================
}
