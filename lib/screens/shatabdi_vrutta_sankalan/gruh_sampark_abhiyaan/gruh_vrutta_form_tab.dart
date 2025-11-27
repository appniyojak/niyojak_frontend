import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../../helpers/database_helper.dart';
import '../../../helpers/static_data.dart' as Statics;
import '../../../models/response_model/AbhiyaanLoginDataResponse.dart';
import '../../../models/response_model/gruh_abhiyaan_vrutta_data_model.dart';
import '../../../models/response_model/vasti_up_data_model.dart';
import '../../../models/response_model/vijayaDashamiInitModel.dart';
import '../../../providers/bals.dart';
import '../../edit_swayamsevak_screen.dart';
import '../vijayadashami/add_vishesh_vyakti.dart';
import 'add_abhiyaan_karyakarta_screen.dart';
import 'add_abhiyaan_pramukh.dart';

class GruhVruttaTab extends StatefulWidget {
  final AbhiyanSwayamsevakdata? initialData;

  const GruhVruttaTab({super.key, this.initialData});

  @override
  State<GruhVruttaTab> createState() => _GruhVruttaTabState();
}

class _GruhVruttaTabState extends State<GruhVruttaTab> with AutomaticKeepAliveClientMixin {
  // This override is what tells Flutter to keep the state alive.
  @override
  bool get wantKeepAlive => true;

  late ScrollController _scrollController;

  // List<GeoUnitMasterBAL>? abhiyaanGeoUnitList = [];

  late ScrollController _scrollController1;
  late ScrollController _scrollController2;
  late ScrollController _scrollController22;
  late ScrollController _scrollController3;
  late ScrollController _scrollController33;

  GruhAbhiyaanVruttaDataModel? gruhAbhiyaanVruttaData;
  List<AbhiyaanPeopleModel> abhiyaanSwayamsevakDataList = [];
  List<AbhiyaanPeopleModel> abhiyaanKaryakartaDataList = [];

  // List<AbhiyaanPeopleModel> selectedKaryakartaList = [];
  List<AbhiyaanPeopleModel> gruhAbhiyaanToliList = [];
  List<AbhiyaanPeopleModel> pramukhList = [];

  List<AbhiyaanPeopleModel> _selectedSwayamsevakIds = [];
  List<AbhiyaanPeopleModel> _selectedKaryakartaIds = [];
  List<AbhiyaanPeopleModel> _selectedTolisIds = [];

  // List<AbhiyanSwayamsevakList> selectedAbhiyaanSwayamsevakList = [];
  String? selectedSwayamAbhiyanValue = "";
  bool? _isSearching = false;
  String? selectedDayitvValue = "";
  bool _searched = false;
  TextEditingController dateController = TextEditingController();
  TextEditingController samparkitGhareController = TextEditingController();
  TextEditingController vitritKarpatrakController = TextEditingController();
  TextEditingController pustakVikriController = TextEditingController();
  TextEditingController samparkaSahabhagiController = TextEditingController();
  TextEditingController samparkaToliController = TextEditingController();

  List<String> strEmail = [];
  List<String> strMobile = [];
  List<LevelMasterBAL>? _level;
  List<GeoUnitMasterBAL>? _geoUnits;

  String? _selctedLevel = 'praant';
  String? _selctedLevelName = '';
  List<String?> _selctedLevelNameList = [];
  String? _selectedGeoUnitId = '';
  String? _levelValue = "";
  String? _geoUnitsValue = "";

  List<GeoUnitMasterBAL>? _linkedMahaanagar;
  List<GeoUnitMasterBAL>? _linkedVibhaag;
  List<GeoUnitMasterBAL>? _linkedbhaag;
  List<GeoUnitMasterBAL>? _linkedshahar;
  List<GeoUnitMasterBAL>? _linkednagar;
  List<GeoUnitMasterBAL>? _linkedmandal;
  List<GeoUnitMasterBAL>? _linkedgraam;
  List<GeoUnitMasterBAL>? _linkedvasti;

  bool? _linkedMahaanagarDisable = false;
  bool? _linkedVibhaagDisable = false;
  bool? _linkedbhaagDisable = false;
  bool? _linkedshaharDisable = false;
  bool? _linkednagarDisable = false;
  bool? _linkedmandalDisable = false;
  bool? _linkedgraamDisable = false;
  bool? _linkedvastiDisable = false;

  // String? _linkedMahaanagarName = '';
  // String? _linkedVibhaagName = '';
  String? _linkedbhaagName = "";
  String? _linkedshaharName = "";
  String? _linkednagarName = "";
  String? _linkedmandalName = "";
  String? _linkedgraamName = "";
  String? _linkedvastiName = "";

  String? _linkedMahaanagarValue = '';
  String? _linkedVibhaagValue = '';
  String? _linkedbhaagValue = "";
  String? _linkedshaharValue = "";
  String? _linkednagarValue = "";
  String? _linkedmandalValue = "";
  String? _linkedgraamValue = "";
  String? _linkedvastiValue = "";
  bool _isExpanded = false;
  bool _isEditing = false;
  bool _isEditingForPramukh = false;
  int? createdUserId;
  String? type;

  List<Vastisanyaprabhavi> selectedAnyaprabhaviItems = [];
  List<Vastisarsajjanshakti> selectedSajjanshaktiItems = [];

  List<int?> selectedUpnagarList = [];

  Vastisarsajjanshakti? selectedPerson;
  Vastisanyaprabhavi? selectedPrabhavi;

  AbhiyanSwayamsevakdata? initialData;

  GetVijayadashamiInitModel? data;

  VastiUpDataListModel? vastiUpDataListModel;

  bool get isSwayamsevakWithoutAbhiyaan {
    final levelIdStr = Statics.userDetails["LevelID"]?.toString() ?? "0";
    final levelId = int.tryParse(levelIdStr) ?? 0;

    final isEmptyFlag = Statics.abhiyaanUserDetails["isEmpty"] == true;

    return levelId >= 6 && levelId <= 12 && isEmptyFlag;
  }

  bool get isSwayamsevak {
    final levelIdStr = Statics.userDetails["LevelID"]?.toString() ?? "0";
    final levelId = int.tryParse(levelIdStr) ?? 0;

    final isEmptyFlag = Statics.abhiyaanUserDetails["isEmpty"] == true;

    return levelId >= 6 && levelId <= 12;
  }

  // bool get isSwayamsevakWithAbhiyaan {
  //   final levelIdStr = Statics.userDetails["LevelID"]?.toString() ?? "0";
  //   final levelId = int.tryParse(levelIdStr) ?? 0;
  //
  //   final isEmptyFlag = Statics.abhiyaanUserDetails["isEmpty"] == true;
  //
  //   return levelId >= 6 && levelId <= 12 && !isEmptyFlag;
  // }

  bool get isAbhiyaanButPramukh {
    final isEmptyFlag = Statics.abhiyaanUserDetails["isEmpty"] == true;

    final _isPramukh = (Statics.abhiyaanUserDetails["DaayityaName"] == "Abhiyaan Pramukh" || Statics.abhiyaanUserDetails["DaayityaName"] == "अभियान प्रमुख");

    return !isEmptyFlag && _isPramukh;
  }

  bool get isAbhiyaanButKaryakarta {
    final isEmptyFlag = Statics.abhiyaanUserDetails["isEmpty"] == true;

    final _isKaryakartaa = (Statics.abhiyaanUserDetails["DaayityaName"] == "Abhiyaan Karyakarta" || Statics.abhiyaanUserDetails["DaayityaName"] == "अभियान कार्यकर्ता");

    return !isEmptyFlag && _isKaryakartaa;
  }

  List<List<PreviousDay>> separatedLists = [];

  List<List<PreviousDay>> groupByUserID(List<PreviousDay> items) {
    final temp = <String, List<PreviousDay>>{};

    for (var item in items) {
      temp.putIfAbsent(item.abhiyaanDate!, () => []);
      temp[item.abhiyaanDate]!.add(item);
    }

    return temp.values.toList();
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    setDropDowns();
    // WidgetsBinding.instance.addPostFrameCallback((_) => setDropDowns());
  }

  @override
  void didUpdateWidget(covariant GruhVruttaTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialData != oldWidget.initialData && widget.initialData != null) {
      setDropDowns();
    }
  }

  setDropDowns() async {
    dateController.text = DateFormat("dd/MM/yyyy").format(DateTime.now());
    _scrollController1 = ScrollController();
    _scrollController2 = ScrollController();
    _scrollController22 = ScrollController();
    _scrollController3 = ScrollController();
    _scrollController33 = ScrollController();

    await populateDropdown();
    setState(() {});
  }

  Future<void> _getSwList() async {
    print("calling");
    separatedLists = [];
    bool isConnected = await Statics.isInternetConnected();
    if (isConnected) {
      var inputData = {
        "AppUserID": Statics.abhiyaanUserDetails["isEmpty"] ? Statics.userDetails["userID"] : Statics.abhiyaanUserDetails["AbhiyanSwayamsevakID"],
        "GeoUnitID": int.parse(_linkedvastiValue != null && _linkedvastiValue!.isNotEmpty ? _linkedvastiValue! : _linkedgraamValue!),
        "AbhiyaanDate": DateFormat("dd-MM-yyyy").format(DateFormat("dd/MM/yyyy").parse(dateController.text)).toString(),
        "ispramukh": isAbhiyaanButPramukh ? 1 : 0,
        "isswayamsevak": Statics.abhiyaanUserDetails["isEmpty"] ? 1 : 0,
      };
      print(jsonEncode(inputData));
      print(Statics.userDetails["userID"]);
      print(Statics.abhiyaanUserDetails["AbhiyanSwayamsevakID"]);
      gruhAbhiyaanVruttaData = await Statics.getDataforGruhAbhiyaan(inputData, context: context);
      setState(() {});
      if (gruhAbhiyaanVruttaData?.abhiyaandata != null) {
        // if (!isAbhiyaanButPramukh)
        setState(() {
          samparkitGhareController.text = (gruhAbhiyaanVruttaData?.abhiyaandata?.samparkitghar ?? "").toString();
          vitritKarpatrakController.text = (gruhAbhiyaanVruttaData?.abhiyaandata?.vitaritkarpatra ?? "").toString();
          pustakVikriController.text = (gruhAbhiyaanVruttaData?.abhiyaandata?.pustakvikrisankhya ?? "").toString();
          samparkaSahabhagiController.text = (gruhAbhiyaanVruttaData?.abhiyaandata?.samparkhetusahbhagisankhya ?? "").toString();
          samparkaToliController.text = (gruhAbhiyaanVruttaData?.abhiyaandata?.samparkhetutolisankhya ?? "").toString();
        });
        abhiyaanSwayamsevakDataList = gruhAbhiyaanVruttaData?.swayamsevakList ?? [];
        abhiyaanKaryakartaDataList = gruhAbhiyaanVruttaData?.abhiyaanList ?? [];
        gruhAbhiyaanToliList = gruhAbhiyaanVruttaData?.abhiyanGruhToliList ?? [];
        pramukhList = gruhAbhiyaanVruttaData?.pramukhList ?? [];
        final _previousDaysList = gruhAbhiyaanVruttaData?.previousDay;
        if (_previousDaysList != null && _previousDaysList.isNotEmpty) {
          separatedLists = await groupByUserID(_previousDaysList);
        }
        setState(() {});

        if (data != null) {
          setState(() {
            selectedSajjanshaktiItems = data!.vastisarsajjanshakti!.where((e) => gruhAbhiyaanVruttaData!.abhiyaandata!.visititAtithiSajjanShaktiids!.split(",").contains(e.pkid.toString())).toList();
            selectedAnyaprabhaviItems =
                data!.vastisanyaprabhavi!.where((e) => gruhAbhiyaanVruttaData!.abhiyaandata!.visititAtithiAnyaprabhaViLokamids!.split(",").contains(e.pkId.toString())).toList();
          });
        }
      }
    }
  }

  addToToliListFun() async {
    try {
      bool isConnected = await Statics.isInternetConnected();
      if (isConnected) {
        var _data = {
          "GeoUnitID": int.parse(_linkedvastiValue != null && _linkedvastiValue!.isNotEmpty ? _linkedvastiValue! : _linkedgraamValue!),
          "SwayamsevakIDs": _selectedSwayamsevakIds.map((item) => item.swayamsevakID.toString()).join(","),
          "AbhiyanSwayamsevakIDs": _selectedKaryakartaIds.map((item) => item.swayamsevakID.toString()).join(","),
          // "AbhiyanSwayamsevakIDs": abhiyaanSwayamsevakDataList.where((e) => e.isSelected).map((item) => item.abhiyanSwayamsevakID.toString()).join(','), // comma-separated IDs
        };

        log(jsonEncode(_data));

        final _updatedToliList = await Statics.addToToliListData(_data, context: context);
        setState(() {});
        if (_updatedToliList != null) {
          final _swayamsevakList = _updatedToliList.swayamsevakList;
          final _abhiyaanList = _updatedToliList.abhiyaanList;
          final _gruhAbhiyaanToliList = _updatedToliList.abhiyanGruhToliList;
          if (_swayamsevakList != null && _swayamsevakList.isNotEmpty) {
            abhiyaanSwayamsevakDataList = _swayamsevakList;
          }
          if (_abhiyaanList != null && _abhiyaanList.isNotEmpty) {
            abhiyaanKaryakartaDataList = _abhiyaanList;
          }
          if (_gruhAbhiyaanToliList != null) {
            gruhAbhiyaanToliList = _gruhAbhiyaanToliList;
            samparkaSahabhagiController.text = gruhAbhiyaanToliList.where((e) => e.isdefault == 1).length.toString();
            samparkaToliController.text = gruhAbhiyaanToliList.length.toString();
          }
        } else {
          Statics.showToast(Statics.getLabel('unableToSaveData'));
        }
        _selectedSwayamsevakIds = [];
        _selectedKaryakartaIds = [];
        setState(() {});
      }
    } catch (e) {
      Statics.showToast(Statics.getLabel('unableToSaveData'));
      log(e.toString());
    }
  }

  saveGruhAbhiyaanDataFun() async {
    try {
      bool isConnected = await Statics.isInternetConnected();
      if (isConnected) {
        var _data = {
          "AbhiyaanDate": DateFormat("dd-MM-yyyy").format(DateFormat("dd/MM/yyyy").parse(dateController.text)).toString(), // e.g. "22-10-2025"
          "GeoUnitID": int.parse(_linkedvastiValue != null && _linkedvastiValue!.isNotEmpty ? _linkedvastiValue! : _linkedgraamValue!),
          "SamparkitGhar": int.tryParse(samparkitGhareController.text.isNotEmpty ? samparkitGhareController.text : "0"),
          "VitaritKarpatra": int.tryParse(vitritKarpatrakController.text.isNotEmpty ? vitritKarpatrakController.text : "0"),
          "PustakVikriSankhya": int.tryParse(pustakVikriController.text.isNotEmpty ? pustakVikriController.text : "0"),
          // "SamparkhetuSahbhagiSankhya": int.tryParse(samparkaSahabhagiController.text.isNotEmpty ? samparkaSahabhagiController.text : "0"),
          // "SamparkhetuToliSankhya": int.tryParse(samparkaToliController.text.isNotEmpty ? samparkaToliController.text : "0"),
          "VisititAtithiSajjanShaktiIDs": selectedSajjanshaktiItems.map((e) => e.pkid).join(","), // comma-separated IDs
          "VisititAtithiAnyaPrabhaviLokamIDs": selectedAnyaprabhaviItems.map((e) => e.pkId).join(","), // comma-separated IDs
          "AppUserID": _isEditing
              ? createdUserId.toString()
              : Statics.abhiyaanUserDetails["isEmpty"]
                  ? Statics.userDetails["userID"]
                  : Statics.abhiyaanUserDetails["AbhiyanSwayamsevakID"],
          "ispramukh": isAbhiyaanButPramukh ? 1 : 0,
          "isswayamsevak": Statics.abhiyaanUserDetails["isEmpty"] ? 1 : 0,
          // "AbhiyanSwayamsevakIDs": _selectedTolisIds.map((item) => item.swayamsevakID.toString()).join(','), // comma-separated IDs
        };

        log(jsonEncode(_data));

        var result = await Statics.saveDataforGruhAbhiyaan(_data, context: context);
        if (result != null) {
          if (Statics.abhiyaanUserDetails["isEmpty"]) {
            log("deleting from AbhiyanSwayamsevakData db >>>>>>>>>>>>>> ");
            await DatabaseHelper.executeQuery('DELETE FROM AbhiyanSwayamsevakData');

            log("inserting in AbhiyanSwayamsevakData db >>>>>>>>>>>>>> ");

            //await dbh.DatabaseHelper.reCreate('GeoUnitMaster', geoUnitData);
            // for (var data in result) {
            await DatabaseHelper.insertOrUpdateRecord('AbhiyanSwayamsevakData', result.toJson());
            await Statics.populateUserAbhiyaanDetailsMap();
            // }
          }

          setState(() {
            _isEditing = false;
            // dateController.text = DateFormat("dd/MM/yyyy").format(DateTime.now());
            samparkitGhareController.clear();
            vitritKarpatrakController.clear();
            pustakVikriController.clear();
            createdUserId = null;
            selectedSajjanshaktiItems = [];
          });
          await _getSwList();
          print("succeed");
        } else {
          Statics.showToast(Statics.getLabel('unableToSaveData'));
        }
      }
    } catch (e) {
      Statics.showToast(Statics.getLabel('unableToSaveData'));
      log(e.toString());
    }
  }

  saveGruhForPramukhFun() async {
    try {
      bool isConnected = await Statics.isInternetConnected();
      if (isConnected) {
        var _data = {
          "AbhiyaanDate": DateFormat("dd-MM-yyyy").format(DateFormat("dd/MM/yyyy").parse(dateController.text)).toString(), // e.g. "22-10-2025"
          "GeoUnitID": int.parse(_linkedvastiValue != null && _linkedvastiValue!.isNotEmpty ? _linkedvastiValue! : _linkedgraamValue!),
          "samparkhetusahbhagisankhya": int.tryParse(samparkaSahabhagiController.text.isNotEmpty ? samparkaSahabhagiController.text : "0"),
          "samparkhetutolisankhya": int.tryParse(samparkaToliController.text.isNotEmpty ? samparkaToliController.text : "0"),
          "iAppUserID ": Statics.abhiyaanUserDetails["AbhiyanSwayamsevakID"],
          "AbhiyanSwayamsevakIDs": _selectedTolisIds.map((item) => item.swayamsevakID.toString()).join(','), // comma-separated IDs
          "ispramukh": isAbhiyaanButPramukh ? 1 : 0,
          "isswayamsevak": Statics.abhiyaanUserDetails["isEmpty"] ? 1 : 0,
        };

        log(jsonEncode(_data));

        var result = await Statics.saveDataforPramukhGruhAbhiyaan(_data, context: context);
        if (result) {
          print("succeed");
        } else {
          Statics.showToast(Statics.getLabel('unableToSaveData'));
        }
      }
    } catch (e) {
      Statics.showToast(Statics.getLabel('unableToSaveData'));
      log(e.toString());
    }
  }

  //////////////////////////////////////////////////////////////////////////////////////

  Future<void> populateDropdown({bool isClear = false}) async {
    setState(() {
      _linkedMahaanagarValue = _linkedbhaagValue = _linkedshaharValue = _linkednagarValue = _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = null;
    });
    await populatelinkedMahaanagarDropdown();
    await populatelinkedVibhaagDropdown('');
    if (isClear) return;
    if (widget.initialData != null && !Statics.abhiyaanUserDetails["isEmpty"]) {
      if (widget.initialData!.parentMahaanagarID != null) {
        setState(() {
          _isExpanded = true;
          _linkedMahaanagarDisable = true;
          _linkedMahaanagarValue = widget.initialData!.parentMahaanagarID.toString();
          _selectedGeoUnitId = widget.initialData!.parentMahaanagarID.toString();
        });
      }
      await populatelinkedVibhaagDropdown('');

      if (widget.initialData!.parentVibhaagID != null) {
        await populatelinkedBhaagDropdown(widget.initialData!.parentVibhaagID.toString());
        setState(() {
          _isExpanded = true;
          _linkedVibhaagDisable = true;
          _linkedVibhaagValue = widget.initialData!.parentVibhaagID.toString();
          _selectedGeoUnitId = widget.initialData!.parentVibhaagID.toString();
        });
      }
      if (widget.initialData!.parentBhaagID != null) {
        await populatelinkedNagarDropdown(widget.initialData!.parentBhaagID.toString(), null);

        GeoUnitMasterBAL? selectedItem;
        if (_linkedbhaag != null && _linkedbhaag!.isNotEmpty) selectedItem = _linkedbhaag!.firstWhere((bg) => bg.geoUnitID.toString() == widget.initialData!.parentBhaagID.toString());

        setState(() {
          _isExpanded = true;
          _linkedbhaagDisable = true;
          _linkedbhaagValue = widget.initialData!.parentBhaagID.toString();
          _selectedGeoUnitId = widget.initialData!.parentBhaagID.toString();
          _linkedbhaagName = selectedItem?.name ?? "";
        });
      }
      if (widget.initialData!.parentNagarID != null) {
        await populatelinkedMandalDropdown(widget.initialData!.parentNagarID.toString());
        await populatelinkedVastiDropdown(widget.initialData!.parentNagarID.toString());

        GeoUnitMasterBAL? selectedItem;
        if (_linkednagar != null && _linkednagar!.isNotEmpty) selectedItem = _linkednagar!.firstWhere((bg) => bg.geoUnitID.toString() == widget.initialData!.parentNagarID.toString());

        setState(() {
          _isExpanded = true;
          _linkednagarDisable = true;
          _linkednagarValue = widget.initialData!.parentNagarID.toString();
          _selectedGeoUnitId = widget.initialData!.parentNagarID.toString();
          _linkednagarName = selectedItem?.name ?? "";
        });
      }
      setState(() {
        if (widget.initialData!.parentMandalID != null) {
          _isExpanded = true;
          _linkedmandalDisable = true;
          _linkedmandalValue = widget.initialData!.parentMandalID.toString();
          _selectedGeoUnitId = widget.initialData!.parentMandalID.toString();

          GeoUnitMasterBAL? selectedItem;
          if (_linkedmandal != null && _linkedmandal!.isNotEmpty) selectedItem = _linkedmandal!.firstWhere((bg) => bg.geoUnitID.toString() == widget.initialData!.parentMandalID.toString());

          _linkedmandalName = selectedItem?.name ?? "";
          populatelinkedGraamDropdown(_linkedmandalValue);
        }
        if (widget.initialData!.levelName == "Vasti" && widget.initialData!.geoUnitID != null) {
          _isExpanded = true;
          _linkedvastiDisable = true;
          _linkedvastiValue = widget.initialData!.geoUnitID.toString();
          _selectedGeoUnitId = widget.initialData!.geoUnitID.toString();

          GeoUnitMasterBAL? selectedItem;
          if (_linkedvasti != null && _linkedvasti!.isNotEmpty) selectedItem = _linkedvasti!.firstWhere((bg) => bg.geoUnitID.toString() == widget.initialData!.geoUnitID.toString());

          _linkedvastiName = selectedItem?.name ?? "";
        } else if (widget.initialData!.levelName == "Graam" && widget.initialData!.geoUnitID != null) {
          _isExpanded = true;
          _linkedgraamDisable = true;
          _linkedgraamValue = widget.initialData!.geoUnitID.toString();
          _selectedGeoUnitId = widget.initialData!.geoUnitID.toString();

          GeoUnitMasterBAL? selectedItem;
          if (_linkedgraam != null && _linkedgraam!.isNotEmpty) selectedItem = _linkedgraam!.firstWhere((bg) => bg.geoUnitID.toString() == widget.initialData!.geoUnitID.toString());

          _linkedgraamName = selectedItem?.name ?? "";
        } else if (widget.initialData!.levelName == "Mandal" && widget.initialData!.geoUnitID != null) {
          _isExpanded = true;
          _linkedmandalDisable = true;
          _linkedmandalValue = widget.initialData!.geoUnitID.toString();
          _selectedGeoUnitId = widget.initialData!.geoUnitID.toString();
          populatelinkedGraamDropdown(_linkedmandalValue);

          GeoUnitMasterBAL? selectedItem;
          if (_linkedmandal != null && _linkedmandal!.isNotEmpty) selectedItem = _linkedmandal!.firstWhere((bg) => bg.geoUnitID.toString() == widget.initialData!.geoUnitID.toString());

          _linkedmandalName = selectedItem?.name ?? "";
        } else if (widget.initialData!.levelName == "Nagar" && widget.initialData!.geoUnitID != null) {
          _isExpanded = true;
          _linkednagarDisable = true;
          _linkednagarValue = widget.initialData!.geoUnitID.toString();
          _selectedGeoUnitId = widget.initialData!.geoUnitID.toString();
          populatelinkedMandalDropdown(_linkednagarValue);
          populatelinkedVastiDropdown(_linkednagarValue);

          GeoUnitMasterBAL? selectedItem;
          if (_linkednagar != null && _linkednagar!.isNotEmpty) selectedItem = _linkednagar!.firstWhere((bg) => bg.geoUnitID.toString() == widget.initialData!.geoUnitID.toString());

          _linkednagarName = selectedItem?.name ?? "";
        } else if (widget.initialData!.levelName == "Bhaag" && widget.initialData!.geoUnitID != null) {
          _isExpanded = true;
          _linkedbhaagDisable = true;
          _linkedbhaagValue = widget.initialData!.geoUnitID.toString();
          _selectedGeoUnitId = widget.initialData!.geoUnitID.toString();
          populatelinkedNagarDropdown(_linkedbhaagValue, null);

          GeoUnitMasterBAL? selectedItem;
          if (_linkedbhaag != null && _linkedbhaag!.isNotEmpty) selectedItem = _linkedbhaag!.firstWhere((bg) => bg.geoUnitID.toString() == widget.initialData!.geoUnitID.toString());

          _linkedbhaagName = selectedItem?.name ?? "";
        } else {
          _isExpanded = true;
          // _linkedgraamDisable = true;
          _linkedbhaagValue = null;
          _linkedshaharValue = null;
          _linkednagarValue = null;
          _linkedmandalValue = null;
          _linkedgraamValue = null;
          _linkedvastiValue = null;
        }
      });
    } else {
      _isExpanded = true;
      _linkedMahaanagarValue = _linkedbhaagValue = _linkedbhaagValue = _linkedshaharValue = _linkednagarValue = _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = null;
    }
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedMahaanagarDropdown() async {
    _linkedVibhaagValue = _linkedbhaagValue = _linkednagarValue = _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = null;
    List<GeoUnitMasterBAL> data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['MahaanagarLevelID'].toString(), '', '', ''); //, isAbhiyaan: !Statics.abhiyaanUserDetails["isEmpty"]);
    setState(() {
      _linkedMahaanagar = data;
    });
    return data;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedVibhaagDropdown(String mahaanagarIDStr) async {
    _linkedbhaagValue = _linkednagarValue = _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = null;
    _linkedbhaagName = _linkednagarName = _linkedmandalName = _linkedgraamName = _linkedvastiName = null;
    print("populatelinkedVibhaagDropdown $mahaanagarIDStr");
    var data = await Statics.getGeoUnitsByLevelAndParent(
      Statics.levels['VibhaagLevelID'].toString(),
      mahaanagarIDStr,
      (mahaanagarIDStr.isEmpty ? '' : 'Mahaanagar'),
      '',
    ); //isAbhiyaan: !Statics.abhiyaanUserDetails["isEmpty"]);
    setState(() {
      _linkedVibhaag = data;
    });
    return data;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedBhaagDropdown(String vibhaagIDStr) async {
    _linkedbhaagValue = _linkednagarValue = _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = null;
    _linkedbhaagName = _linkednagarName = _linkedmandalName = _linkedgraamName = _linkedvastiName = null;
    _linkedbhaag = _linkednagar = _linkedmandal = _linkedgraam = _linkedvasti = [];
    var data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['BhaagLevelID'].toString(), vibhaagIDStr, 'Vibhaag', ''); //, isAbhiyaan: !Statics.abhiyaanUserDetails["isEmpty"]);
    setState(() {
      _linkedbhaag = data;
    });
    return data;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedShaharDropdown(String bhaagIDStr) async {
    _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = null;
    _linkedmandalName = _linkedgraamName = _linkedvastiName = null;
    var shDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['ShaharLevelID'].toString(), bhaagIDStr, 'Bhaag', ''); //, isAbhiyaan: !Statics.abhiyaanUserDetails["isEmpty"]);
    setState(() {
      _linkedshahar = (shDD.length > 0 ? shDD : null);
    });
    return shDD;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedNagarDropdown(String? bhaagIDStr, String? shaharIDStr) async {
// print("populatelinkedNagarDropdown ${bhaagIDStr} == ${shaharIDStr}  ");
    _linkednagarValue = _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = null;
    _linkednagarName = _linkedmandalName = _linkedgraamName = _linkedvastiName = null;
    _linkednagar = _linkedmandal = _linkedgraam = _linkedvasti = null;
    print("print LevelID > ${Statics.userDetails["LevelID"]}");
    print("shaharIDStr shaharIDStr $shaharIDStr");
    if (shaharIDStr != null) {
      var ngDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['NagarLevelID'].toString(), shaharIDStr!, 'Shahar', ''); //, isAbhiyaan: !Statics.abhiyaanUserDetails["isEmpty"]);
      setState(() {
        _linkednagar = (ngDD.length > 0 ? ngDD : null);
      });
      return ngDD;
    } else {
      var ngDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['NagarLevelID'].toString(), bhaagIDStr!, 'Bhaag', ''); //, isAbhiyaan: !Statics.abhiyaanUserDetails["isEmpty"]);
      setState(() {
        _linkednagar = (ngDD.length > 0 ? ngDD : null);
      });
      return ngDD;
    }
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedMandalDropdown(String? nagarIDStr) async {
    _linkedmandalValue = _linkedgraamValue = null;
    _linkedmandalName = _linkedgraamName = null;
    _linkedmandal = _linkedgraam = null;
    var mnDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['MandalLevelID'].toString(), nagarIDStr!, 'Nagar', ''); //, isAbhiyaan: !Statics.abhiyaanUserDetails["isEmpty"]);
    setState(() {
      _linkedmandal = (mnDD.length > 0 ? mnDD : null);
    });
    return mnDD;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedGraamDropdown(String? mandalIDStr) async {
    _linkedgraamValue = null;
    _linkedgraamName = null;
    var gmDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['GraamLevelID'].toString(), mandalIDStr!, 'Mandal', ''); //, isAbhiyaan: !Statics.abhiyaanUserDetails["isEmpty"]);
    setState(() {
      _linkedgraam = (gmDD.length > 0 ? gmDD : null);
    });
    return gmDD;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedVastiDropdown(String? nagarIDStr) async {
    _linkedvastiValue = null;
    _linkedvastiName = null;
    var vsDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['VastiLevelID'].toString(), nagarIDStr!, 'Nagar', ''); //, isAbhiyaan: !Statics.abhiyaanUserDetails["isEmpty"]);
    setState(() {
      _linkedvasti = (vsDD.length > 0 ? vsDD : null);
    });
    return vsDD;
  }

  /////////////////////////////////////////// AVAILABLE KARYAKARTA & SWAYAMSEVAK DATA /////////////////////////////////////////////
  showAvailableKaryakartaDialog() {
    showDialog(
      context: context,
      useSafeArea: true,
      builder: (ct) => StatefulBuilder(
        builder: (ctx, set) => Dialog(
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          // contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          insetPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 16),
          // titlePadding: const EdgeInsets.fromLTRB(20, 20, 12, 0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 12),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          Statics.getLabel('abhiyaanKaryakartaList'),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.redAccent),
                        onPressed: () {
                          set(() {
                            // selectedKaryakartaList = [];
                            _selectedSwayamsevakIds = [];
                            _selectedKaryakartaIds = [];
                          });
                          Navigator.pop(ctx);
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 6),
                  SizedBox(height: 16),
                  swayamsevakAndKaryakartaTable(ct, set),
                  SizedBox(height: 12),
                  // selectedKaryakartaTable(ct, set),
                  SizedBox(height: 12),
                  // Flexible(
                  //   child: Container(
                  //     constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * 0.58),
                  //     child: ListView.builder(
                  //       shrinkWrap: true,
                  //       padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                  //       itemCount: abhiyaanSwayamsevakDataList.length,
                  //       itemBuilder: (context, index) {
                  //         final swItem = abhiyaanSwayamsevakDataList[index];
                  //         return Card(
                  //           margin: EdgeInsets.all(5),
                  //           elevation: 5,
                  //           child: CheckboxListTile(
                  //             onChanged: (value) => set(() {
                  //               swItem.isSelected = !swItem.isSelected;
                  //             }),
                  //             value: swItem.isSelected,
                  //             contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  //             title: Text(swItem.participantName.toString()),
                  //             subtitle: Container(
                  //               child: Column(
                  //                 crossAxisAlignment: CrossAxisAlignment.start,
                  //                 children: [
                  //                   SizedBox(
                  //                     height: 5,
                  //                   ),
                  //                   Text(swItem.daayityaName.toString()),
                  //                   SizedBox(
                  //                     height: 5,
                  //                   ),
                  //                   Wrap(direction: Axis.vertical, spacing: 5, children: [
                  //                     RichText(
                  //                       text: TextSpan(
                  //                         text: 'M: ${swItem.participantNumber.toString()}${swItem.email.toString().isNotEmpty ? ',' : ''}',
                  //                         style: TextStyle(color: Colors.blue),
                  //                         recognizer: TapGestureRecognizer()
                  //                           ..onTap = () {
                  //                             UrlLauncher.launch("tel://" + swItem.participantNumber.toString());
                  //                           },
                  //                       ),
                  //                     ),
                  //                     if (swItem.email != null && swItem.email!.isNotEmpty)
                  //                       RichText(
                  //                         text: TextSpan(
                  //                           text: 'E: ${swItem.email.toString()}',
                  //                           style: TextStyle(color: Colors.blue),
                  //                           recognizer: TapGestureRecognizer()
                  //                             ..onTap = () {
                  //                               UrlLauncher.launch("mailto:" + swItem.email.toString());
                  //                             },
                  //                         ),
                  //                       ),
                  //                   ]),
                  //                 ],
                  //               ),
                  //             ),
                  //           ),
                  //         );
                  //       },
                  //     ),
                  //   ),
                  // ),
                  SizedBox(height: 8),
                  if (_selectedSwayamsevakIds.isNotEmpty)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.purpleAccent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            ),
                            onPressed: () async {
                              // Statics.showToast(Statics.getLabel("workInProgress"));
                              Navigator.pop(ctx);
                              await addToToliListFun();
                            },
                            child: Text(
                              Statics.getLabel('Submit'),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        // SizedBox(
                        //   width: 15,
                        // ),
                        // OutlinedButton(
                        //   style: OutlinedButton.styleFrom(
                        //     side: const BorderSide(color: Colors.purpleAccent, width: 1.5),
                        //     shape: RoundedRectangleBorder(
                        //       borderRadius: BorderRadius.circular(12),
                        //     ),
                        //     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        //   ),
                        //   onPressed: onAdd,
                        //   child: Text(
                        //     Statics.getLabel('fillNewRecord'),
                        //     style: const TextStyle(color: Colors.purpleAccent),
                        //   ),
                        // ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget selectedKaryakartaTable(BuildContext ct, void Function(void Function()) set) {
    final List<String> headers = [
      "",
      Statics.getLabel('Name'),
      Statics.getLabel('daayitvaName'),
      Statics.getLabel('Mobile'),
    ];

    if (_selectedSwayamsevakIds.isEmpty) return SizedBox();

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black54),
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(Statics.getLabel("selectedList"), softWrap: true, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 12),
          Scrollbar(
            controller: _scrollController1,
            thumbVisibility: true,
            interactive: true,
            thickness: 5,
            radius: Radius.circular(10),
            child: SingleChildScrollView(
              controller: _scrollController1,
              scrollDirection: Axis.horizontal,
              child: DataTable(
                showCheckboxColumn: false,
                headingRowColor: MaterialStatePropertyAll(Colors.purple.shade100),
                columnSpacing: 30,
                headingTextStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
                columns: headers
                    .map((header) => DataColumn(
                          label: Container(
                            constraints: BoxConstraints(minWidth: 30, maxWidth: header == headers.first ? 80 : 200),
                            // constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width * 0.2),
                            child: Text(header, softWrap: true, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ))
                    .toList(),
                rows: _selectedSwayamsevakIds.asMap().entries.map((entry) {
                      int index = entry.key;
                      var data = entry.value;
                      // bool isSelected = selectedGramVastiListRowIndex == index;
                      return DataRow(
                          selected: data.isSelected,
                          color: MaterialStateProperty.resolveWith<Color?>(
                            (Set<MaterialState> states) {
                              if (data.isSelected) return Colors.yellow.shade100;
                              return null;
                            },
                          ),
                          cells: [
                            DataCell(
                              InkWell(
                                onTap: () {
                                  set(() {
                                    _selectedSwayamsevakIds.remove(data);
                                  });
                                },
                                child: Icon(Icons.delete_forever_outlined, color: Colors.red, size: 21),
                              ),
                            ),
                            DataCell(Text(data.fullName == "" ? "--" : (data.fullName ?? "--"))),
                            DataCell(Text(data.daayitva == "" ? "--" : (data.daayitva ?? "--"))),
                            DataCell(Text(data.mobileno == "" ? "--" : (data.mobileno ?? "--"))),
                          ]);
                    }).toList() +
                    _selectedKaryakartaIds.asMap().entries.map((entry) {
                      int index = entry.key;
                      var data = entry.value;
                      // bool isSelected = selectedGramVastiListRowIndex == index;
                      return DataRow(
                          selected: data.isSelected,
                          color: MaterialStateProperty.resolveWith<Color?>(
                            (Set<MaterialState> states) {
                              if (data.isSelected) return Colors.yellow.shade100;
                              return null;
                            },
                          ),
                          cells: [
                            DataCell(
                              InkWell(
                                onTap: () {
                                  set(() {
                                    _selectedKaryakartaIds.remove(data);
                                  });
                                },
                                child: Icon(Icons.delete_forever_outlined, color: Colors.red, size: 21),
                              ),
                            ),
                            DataCell(Text(data.fullName == "" ? "--" : (data.fullName ?? "--"))),
                            DataCell(Text(data.daayitva == "" ? "--" : (data.daayitva ?? "--"))),
                            DataCell(Text(data.mobileno == "" ? "--" : (data.mobileno ?? "--"))),
                          ]);
                    }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget swayamsevakAndKaryakartaTable(BuildContext ct, void Function(void Function()) set) {
    final List<String> headers = [
      "",
      Statics.getLabel('Name'),
      Statics.getLabel('daayitvaName'),
      Statics.getLabel('Mobile'),
    ];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black54),
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(Statics.getLabel("SwayamsevaksList"), softWrap: true, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontWeight: FontWeight.bold))),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  side: const BorderSide(color: Colors.purpleAccent, width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                ),
                onPressed: () async {
                  // await saveGruhAbhiyaanDataFun();
                  Navigator.pop(ct);
                  Navigator.of(context).pushNamed(EditSwayamsevakScreen.routeName, arguments: Statics.ScreenArgumentsNew(0, Statics.getLabel('EditMenu'))).then((value) async {
                    data = await Statics.getSajjanAndAnyaGuestData(context, Statics.userDetails["userID"],
                        _linkedvastiValue != null && _linkedvastiValue!.isNotEmpty ? _linkedvastiValue! : _linkedgraamValue!, _linkedvastiValue != null && _linkedvastiValue!.isNotEmpty ? "2" : "3");
                    setState(() {});
                    // if(Statics.userDetails[])
                    await _getSwList();
                  });
                  // Navigator.of(context).pushNamed(EditSwayamsevakScreen.routeName, arguments: Statics.ScreenArgumentsNew(0, Statics.getLabel('EditMenu')));
                },
                child: Text(
                  Statics.getLabel('AddSwayamsevak'),
                  style: const TextStyle(color: Colors.purpleAccent),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Container(
            width: double.infinity,
            constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * 0.4),
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black54),
              borderRadius: const BorderRadius.all(Radius.circular(15)),
            ),
            child: Scrollbar(
              controller: _scrollController22,
              thumbVisibility: true,
              interactive: true,
              thickness: 5,
              radius: const Radius.circular(10),
              child: SingleChildScrollView(
                controller: _scrollController22,
                scrollDirection: Axis.vertical,
                child: Scrollbar(
                  controller: _scrollController2,
                  thumbVisibility: true,
                  interactive: true,
                  thickness: 5,
                  radius: const Radius.circular(10),
                  child: SingleChildScrollView(
                    controller: _scrollController2, // Horizontal controller for horizontal scrolling
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      showCheckboxColumn: false,
                      headingRowColor: MaterialStatePropertyAll(Colors.purple.shade100),
                      columnSpacing: 30,
                      headingTextStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
                      columns: headers
                          .map((header) => DataColumn(
                                label: Container(
                                  constraints: BoxConstraints(minWidth: 30, maxWidth: header == headers.first ? 80 : 200),
                                  // constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width * 0.2),
                                  child: Text(header, softWrap: true, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontWeight: FontWeight.bold)),
                                ),
                              ))
                          .toList(),
                      rows: abhiyaanSwayamsevakDataList.asMap().entries.map((entry) {
                        int index = entry.key;
                        var data = entry.value;
                        bool isSelected = ((data.isdefault == 1) || _selectedSwayamsevakIds.contains(data));
                        return DataRow(
                            selected: isSelected,
                            color: MaterialStateProperty.resolveWith<Color?>(
                              (Set<MaterialState> states) {
                                if (isSelected) return Colors.yellow.shade100;
                                return null;
                              },
                            ),
                            onSelectChanged: (bool? selected) {
                              if ((data.isdefault == 1)) {
                                return;
                              }
                              if (!isSelected) {
                                set(() {
                                  // selectedKaryakartaList.add(data);
                                  _selectedSwayamsevakIds.add(data);
                                });
                              } else {
                                set(() {
                                  // selectedKaryakartaList.add(data);
                                  _selectedSwayamsevakIds.remove(data);
                                });
                              }
                              log(_selectedSwayamsevakIds
                                  .map(
                                    (e) => e.swayamsevakID.toString(),
                                  )
                                  .join(','));
                            },
                            cells: [
                              DataCell(Icon(isSelected ? Icons.check_box_rounded : Icons.check_box_outline_blank_rounded, color: Colors.yellow.shade800, size: 18)),
                              DataCell(Text(data.fullName == "" ? "--" : (data.fullName ?? "--"))),
                              DataCell(Text(data.daayitva == "" ? "--" : (data.daayitva ?? "--"))),
                              DataCell(Text(data.mobileno == "" ? "--" : (data.mobileno ?? "--"))),
                            ]);
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 18),
          Row(
            children: [
              Expanded(child: Text(Statics.getLabel("KaaryakartaaList"), softWrap: true, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontWeight: FontWeight.bold))),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  side: const BorderSide(color: Colors.purpleAccent, width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                ),
                onPressed: () async {
                  // await saveGruhAbhiyaanDataFun();
                  Navigator.pop(ct);
                  Navigator.of(context).pushNamed(AddAbhiyaanKaryakartaScreen.routeName, arguments: {"geounitid": _selectedGeoUnitId, "isvasti": _selctedLevel == "Vasti"}).then((value) async {
                    data = await Statics.getSajjanAndAnyaGuestData(context, Statics.userDetails["userID"],
                        _linkedvastiValue != null && _linkedvastiValue!.isNotEmpty ? _linkedvastiValue! : _linkedgraamValue!, _linkedvastiValue != null && _linkedvastiValue!.isNotEmpty ? "2" : "3");
                    setState(() {});
                    // if(Statics.userDetails[])
                    await _getSwList();
                  });
                  // Fluttertoast.showToast(
                  //   msg: Statics.getLabel("workInProgress"),
                  //   toastLength: Toast.LENGTH_SHORT,
                  //   gravity: ToastGravity.BOTTOM,
                  // );
                },
                child: Text(
                  Statics.getLabel('addSahabhagiKaryakarta'),
                  style: const TextStyle(color: Colors.purpleAccent),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Container(
            width: double.infinity,
            constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * 0.4),
            padding: EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black54),
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
            child: Scrollbar(
              controller: _scrollController33,
              thumbVisibility: true,
              interactive: true,
              thickness: 5,
              radius: const Radius.circular(10),
              child: SingleChildScrollView(
                controller: _scrollController33,
                scrollDirection: Axis.vertical,
                child: Scrollbar(
                  controller: _scrollController3,
                  thumbVisibility: true,
                  interactive: true,
                  thickness: 5,
                  radius: const Radius.circular(10),
                  child: SingleChildScrollView(
                    controller: _scrollController3, // Horizontal controller for horizontal scrolling
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      showCheckboxColumn: false,
                      headingRowColor: MaterialStatePropertyAll(Colors.purple.shade100),
                      columnSpacing: 30,
                      headingTextStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
                      columns: headers
                          .map((header) => DataColumn(
                                label: Container(
                                  constraints: BoxConstraints(minWidth: 30, maxWidth: header == headers.first ? 80 : 200),
                                  // constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width * 0.2),
                                  child: Text(header, softWrap: true, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontWeight: FontWeight.bold)),
                                ),
                              ))
                          .toList(),
                      rows: abhiyaanKaryakartaDataList.asMap().entries.map((entry) {
                        int index = entry.key;
                        var data = entry.value;
                        bool isSelected = (data.isdefault == 1) || _selectedKaryakartaIds.contains(data);
                        return DataRow(
                            selected: isSelected,
                            color: MaterialStateProperty.resolveWith<Color?>(
                              (Set<MaterialState> states) {
                                if (isSelected) return Colors.yellow.shade100;
                                return null;
                              },
                            ),
                            onSelectChanged: (bool? selected) {
                              if ((data.isdefault == 1)) {
                                return;
                              }
                              if (!isSelected) {
                                set(() {
                                  // selectedKaryakartaList.add(data);
                                  _selectedKaryakartaIds.add(data);
                                });
                              } else {
                                set(() {
                                  // selectedKaryakartaList.add(data);
                                  _selectedKaryakartaIds.remove(data);
                                });
                              }
                              log(_selectedKaryakartaIds.map((e) => e.swayamsevakID.toString()).join(','));
                            },
                            cells: [
                              DataCell(Icon(isSelected ? Icons.check_box_rounded : Icons.check_box_outline_blank_rounded, color: Colors.yellow.shade900, size: 18)),
                              DataCell(Text(data.fullName == "" ? "--" : (data.fullName ?? "--"))),
                              DataCell(Text((data.daayitva == null || data.daayitva!.isEmpty) ? "--" : Statics.getLabel(data.daayitva!, returnKey: true))),
                              DataCell(Text(data.mobileno == "" ? "--" : (data.mobileno ?? "--"))),
                            ]);
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  /////////////////////////////////////////// AVAILABLE KARYAKARTA & SWAYAMSEVAK DATA /////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    // You must call super.build(context) when using AutomaticKeepAliveClientMixin
    super.build(context);

    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: _isSearching!,
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 15),
              SizedBox(height: 13),
              _buildExpansionPanel(),
              // if (!isSwayamsevakWithoutAbhiyaan)
              ...[
                SizedBox(height: 32),

                if (_searched)
                  Container(
                    // height: 40,
                    constraints: BoxConstraints(minHeight: 40),
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.purpleAccent, width: 1),
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Text(
                        //   "${Statics.getLabel(_selctedLevel ?? "Mahaanagar")}  ->  ",
                        //   style: TextStyle(color: Colors.purpleAccent, fontWeight: FontWeight.bold, fontSize: 16),
                        // ),
                        // Text(
                        //   " $_selctedLevelName",
                        //   style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 17),
                        // ),
                        Expanded(
                          child: Text(
                            _selctedLevelNameList
                                .where((e) => e != null && e.isNotEmpty) // remove null or empty strings
                                .cast<String>() // convert from String? to String
                                .join(' -> '),
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 17),
                          ),
                        ),
                      ],
                    ),
                  ),
                if (_searched) SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                if (_searched && isSwayamsevak)
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "${Statics.getLabel('vastiPramukhName')}",
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 15),
                    ),
                  ),
                if (_searched && isSwayamsevak)
                  Container(
                    margin: EdgeInsets.only(left: 21, right: 16, bottom: 27),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            "- ${pramukhList.isNotEmpty ? "${pramukhList.first.fullName} (${pramukhList.first.mobileno})" : "नियुक्त नाही"}",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: pramukhList.isEmpty ? Colors.red : Colors.purple,
                            ),
                          ),
                        ),
                        if (pramukhList.isEmpty)
                          InkWell(
                            onTap: () async {
                              Navigator.of(context).pushNamed(AddAbhiyaanPramukhScreen.routeName, arguments: _selectedGeoUnitId)!.then((value) => _getSwList());
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                              // width: 150,
                              // height: 35,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.purpleAccent.shade100),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Text(
                                Statics.getLabel("add"),
                                style: TextStyle(
                                  color: Colors.purpleAccent,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Text(
                              "${Statics.getLabel('date2')} : ",
                              style: TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              " *",
                              style: TextStyle(fontSize: 15, color: Colors.red, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      // SizedBox(width: 12),
                      Expanded(
                        child: SizedBox(
                          // width: MediaQuery.sizeOf(context).width * 0.4,
                          child: TextField(
                            controller: dateController,
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(10)],
                            style: TextStyle(fontSize: 14),
                            autofocus: false,
                            onTap: () async {
                              DateTime? date =
                                  await showDatePicker(context: context, initialDate: DateFormat("dd/MM/yyyy").parse(dateController.text), firstDate: DateTime(2000), lastDate: DateTime.now());
                              if (date != null) {
                                if (dateController.text != DateFormat("dd/MM/yyyy").format(date)) {
                                  _searched = false;
                                  _isExpanded = true;
                                  _isEditing = false;
                                  createdUserId = null;
                                }
                                dateController.text = DateFormat("dd/MM/yyyy").format(date);

                                setState(() {});
                                await _getSwList();

                                setState(() {
                                  _selectedTolisIds = [];
                                  _searched = true;
                                  _isExpanded = false;
                                });
                              }
                            },
                            readOnly: true,
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.done,
                            decoration: InputDecoration(
                                isDense: true,
                                hintText: "DD/MM/YYYY",
                                contentPadding: EdgeInsets.only(left: 12, right: 12, top: 14, bottom: 12),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                )),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (_searched) ...[
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                  customTextFields(title: "संपर्कित घरे : ", controller: samparkitGhareController, readOnly: isAbhiyaanButPramukh && !_isEditing),
                  customTextFields(title: "वितरित करपत्रक : ", controller: vitritKarpatrakController, readOnly: isAbhiyaanButPramukh && !_isEditing),
                  customTextFields(title: "पुस्तक विक्री संख्या : ", controller: pustakVikriController, readOnly: isAbhiyaanButPramukh && !_isEditing),

                  //
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      spacing: 8,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                "विशेष व्यक्ती संपर्क : ",
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                            ),
                            if (!(isAbhiyaanButPramukh && !_isEditing))
                              Expanded(
                                child: InkWell(
                                  onTap: isAbhiyaanButPramukh && !_isEditing
                                      ? null
                                      : () async {
                                          // if (_isSearching == false) {
                                          //   Fluttertoast.showToast(msg: "${Statics.getLabel('NagarSelectionImportant')}");

                                          // Fluttertoast.showToast(
                                          //   msg: Statics.getLabel("workInProgress"),
                                          //   toastLength: Toast.LENGTH_SHORT,
                                          //   gravity: ToastGravity.BOTTOM,
                                          // );
                                          // return;
                                          // }
                                          await showVisheshAtithiSelectionPopup(
                                            context,
                                            onAdd: () async {
                                              await saveGruhAbhiyaanDataFun();
                                              Navigator.of(context).pushReplacementNamed(
                                                AddVishisthaAtithi.routeName,
                                                arguments: {'geoUnitId': _selectedGeoUnitId},
                                              ).then(
                                                (value) async {
                                                  data = await Statics.getSajjanAndAnyaGuestData(
                                                      context,
                                                      Statics.userDetails["userID"],
                                                      _linkedvastiValue != null && _linkedvastiValue!.isNotEmpty ? _linkedvastiValue! : _linkedgraamValue!,
                                                      _linkedvastiValue != null && _linkedvastiValue!.isNotEmpty ? "2" : "3");
                                                  setState(() {});
                                                  // if(Statics.userDetails[])
                                                  await _getSwList();
                                                  setState(() {});
                                                },
                                              );
                                            },
                                          );
                                        },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 5),
                                    width: 150,
                                    height: 35,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.purpleAccent.shade100),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "${Statics.getLabel('addSpecialPerson')}",
                                        style: TextStyle(
                                          color: Colors.purpleAccent,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        // if (selectedSajjanshaktiItems.isNotEmpty || selectedAnyaprabhaviItems.isNotEmpty)
                        mainContainer(
                          "${Statics.getLabel('specialPerson')}",
                          Column(
                            children: [
                              // Button for popup
                              // Row(
                              //   mainAxisAlignment: MainAxisAlignment.end,
                              //   children: [
                              //     InkWell(
                              //       onTap: isAbhiyaanButPramukh && !_isEditing
                              //           ? null
                              //           : () async {
                              //               // if (_isSearching == false) {
                              //               //   Fluttertoast.showToast(msg: "${Statics.getLabel('NagarSelectionImportant')}");
                              //
                              //               // Fluttertoast.showToast(
                              //               //   msg: Statics.getLabel("workInProgress"),
                              //               //   toastLength: Toast.LENGTH_SHORT,
                              //               //   gravity: ToastGravity.BOTTOM,
                              //               // );
                              //               // return;
                              //               // }
                              //               await showVisheshAtithiSelectionPopup(
                              //                 context,
                              //                 onAdd: () async {
                              //                   await saveGruhAbhiyaanDataFun();
                              //                   Navigator.of(context).pushReplacementNamed(
                              //                     AddVishisthaAtithi.routeName,
                              //                     arguments: {'geoUnitId': _selectedGeoUnitId},
                              //                   ).then(
                              //                     (value) async {
                              //                       data = await Statics.getSajjanAndAnyaGuestData(
                              //                           context,
                              //                           Statics.userDetails["userID"],
                              //                           _linkedvastiValue != null && _linkedvastiValue!.isNotEmpty ? _linkedvastiValue! : _linkedgraamValue!,
                              //                           _linkedvastiValue != null && _linkedvastiValue!.isNotEmpty ? "2" : "3");
                              //                       setState(() {});
                              //                       // if(Statics.userDetails[])
                              //                       await _getSwList();
                              //                       setState(() {});
                              //                     },
                              //                   );
                              //                 },
                              //               );
                              //             },
                              //       child: Container(
                              //         padding: const EdgeInsets.symmetric(vertical: 5),
                              //         width: 150,
                              //         height: 35,
                              //         decoration: BoxDecoration(
                              //           border: Border.all(color: Colors.purpleAccent.shade100),
                              //           borderRadius: BorderRadius.circular(15),
                              //         ),
                              //         child: Center(
                              //           child: Text(
                              //             "${Statics.getLabel('addSpecialPerson')}",
                              //             style: TextStyle(
                              //               color: Colors.purpleAccent,
                              //               fontWeight: FontWeight.bold,
                              //             ),
                              //           ),
                              //         ),
                              //       ),
                              //     ),
                              //   ],
                              // ),

                              // const SizedBox(height: 20),

                              // Table for Sajjanshakti
                              if (selectedSajjanshaktiItems.isNotEmpty) ...[
                                Text("${Statics.getLabel('SajjanShakti')}", style: TextStyle(fontWeight: FontWeight.bold)),
                                Table(
                                  border: TableBorder.all(),
                                  columnWidths: const {
                                    0: FixedColumnWidth(40),
                                    1: FlexColumnWidth(),
                                    2: FlexColumnWidth(),
                                  },
                                  children: [
                                    TableRow(
                                      decoration: BoxDecoration(color: Color(0xFFE0E0E0)),
                                      children: [
                                        Padding(padding: EdgeInsets.all(4), child: Text("${Statics.getLabel('serialNo')}")),
                                        Padding(padding: EdgeInsets.all(4), child: Text("${Statics.getLabel('Name')}")),
                                        Padding(padding: EdgeInsets.all(4), child: Text("${Statics.getLabel('samparkSootraNaav')}")),
                                        Padding(padding: EdgeInsets.all(4), child: Text("${Statics.getLabel('ViewMenu')}")),
                                      ],
                                    ),
                                    ...selectedSajjanshaktiItems.asMap().entries.map((entry) {
                                      int srNo = entry.key + 1;
                                      final item = entry.value;
                                      return TableRow(
                                        children: [
                                          Padding(padding: const EdgeInsets.all(4), child: Text(srNo.toString())),
                                          Padding(padding: const EdgeInsets.all(4), child: Text(item.name ?? "")),
                                          Padding(padding: const EdgeInsets.all(4), child: Text(item.samparkasutranava ?? "")),
                                          IconButton(
                                            icon: Icon(Icons.remove_red_eye, size: 22, color: Colors.purpleAccent),
                                            onPressed: () {
                                              showPersonDetailsPopup(context, item, srNo);
                                            },
                                          ),
                                        ],
                                      );
                                    }).toList(),
                                  ],
                                ),
                              ],

                              const SizedBox(height: 20),

                              // Table for Anyaprabhavi
                              if (selectedAnyaprabhaviItems.isNotEmpty) ...[
                                Text("${Statics.getLabel('anyaPrabhaviLok')}", style: TextStyle(fontWeight: FontWeight.bold)),
                                Table(
                                  border: TableBorder.all(),
                                  columnWidths: const {
                                    0: FixedColumnWidth(40),
                                    1: FlexColumnWidth(),
                                    2: FlexColumnWidth(),
                                    3: FixedColumnWidth(50), // 👁 button column
                                  },
                                  children: [
                                    TableRow(
                                      decoration: BoxDecoration(color: Color(0xFFE0E0E0)),
                                      children: [
                                        Padding(padding: EdgeInsets.all(4), child: Text("${Statics.getLabel('serialNo')}")),
                                        Padding(padding: EdgeInsets.all(4), child: Text("${Statics.getLabel('Name')}")),
                                        Padding(padding: EdgeInsets.all(4), child: Text("${Statics.getLabel('samparkSootraNaav')}")),
                                        Padding(padding: EdgeInsets.all(4), child: Text("${Statics.getLabel('ViewMenu')}")), // 👁 column heading
                                      ],
                                    ),
                                    ...selectedAnyaprabhaviItems.asMap().entries.map((entry) {
                                      int srNo = entry.key + 1;
                                      final item = entry.value;

                                      return TableRow(
                                        children: [
                                          Padding(padding: const EdgeInsets.all(4), child: Text(srNo.toString())),
                                          Padding(padding: const EdgeInsets.all(4), child: Text(item.name ?? "")),
                                          Padding(padding: const EdgeInsets.all(4), child: Text(item.samparkAsutraNav ?? "")),
                                          IconButton(
                                            icon: Icon(Icons.remove_red_eye, size: 22, color: Colors.purpleAccent),
                                            onPressed: () {
                                              showPersonDetailsPopup(context, item, srNo);
                                            },
                                          ),
                                        ],
                                      );
                                    }).toList(),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        ),
                        // Container(
                        //   // height: 30,
                        //   width: MediaQuery.of(context).size.width * 0.45,
                        //   child: TextField(
                        //     controller: vitritKarpatrakController,
                        //     inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(10)],
                        //     style: TextStyle(
                        //       fontSize: 14,
                        //     ),
                        //     autofocus: false,
                        //     keyboardType: TextInputType.number,
                        //     textInputAction: TextInputAction.done,
                        //     decoration: InputDecoration(
                        //         isDense: true,
                        //         hintText: "0",
                        //         contentPadding: EdgeInsets.only(left: 12, right: 12, top: 14, bottom: 12),
                        //         border: OutlineInputBorder(
                        //           borderRadius: BorderRadius.circular(5),
                        //         )),
                        //   ),
                        // ),
                      ],
                    ),
                  ),

                  //
                  SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (!isAbhiyaanButPramukh || _isEditing)
                        MaterialButton(
                          minWidth: MediaQuery.sizeOf(context).width * 0.4,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          padding: EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          color: Theme.of(context).primaryColor,
                          textColor: Theme.of(context).primaryTextTheme.labelMedium?.color,
                          // onPressed: () {
                          //   Statics.showToast(Statics.getLabel("workInProgress"));
                          // },
                          onPressed: () async {
                            // if (isAbhiyaanButPramukh && !_isEditing) {
                            //   await saveGruhForPramukhFun();
                            //   return;
                            // }
                            if (dateController.text.isEmpty || samparkitGhareController.text.isEmpty || vitritKarpatrakController.text.isEmpty || pustakVikriController.text.isEmpty) {
                              Statics.showToast(Statics.getLabel("impInfoRequired"));
                              return null;
                              // } else if (!(abhiyaanSwayamsevakDataList.any((e) => e.isSelected))) {
                              //   print("स्तराचे नाव निवडा");
                              //   Statics.showToast("किमान एक अभियान कार्यकर्ता जोडावे");
                              //   return null;
                            } else {
                              print("saving data");
                              await saveGruhAbhiyaanDataFun();
                            }
                            // _submit(context);
                          },
                          child: Text(
                            Statics.getLabel('Submit'),
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      if (_isEditing)
                        MaterialButton(
                          minWidth: MediaQuery.sizeOf(context).width * 0.35,
                          onPressed: () async {
                            setState(() {
                              _isEditing = false;
                              dateController.text = DateFormat("dd/MM/yyyy").format(DateTime.now());
                              samparkitGhareController.clear();
                              vitritKarpatrakController.clear();
                              pustakVikriController.clear();
                              createdUserId = null;
                              selectedSajjanshaktiItems = [];
                              selectedAnyaprabhaviItems = [];
                            });
                            await _getSwList();
                            // await populateDropdown(isClear: true);
                          },
                          child: Text(
                            Statics.getLabel('clear'),
                          ),
                        ),
                    ],
                  ),
                ],
//
                if (_searched && isAbhiyaanButPramukh && !_isEditingForPramukh) ...[
                  Divider(height: 70, thickness: 2, color: Colors.grey.shade700),
                  customTextFields(title: "संपर्क हेतू सहभागी संख्या : ", controller: samparkaSahabhagiController, readOnly: true), //,gruhAbhiyaanVruttaData!.abhiyaandata!.ishide),
                  customTextFields(title: "संपर्क हेतू टोळी संख्या : ", controller: samparkaToliController, readOnly: true), //,gruhAbhiyaanVruttaData!.abhiyaandata!.ishide),
                  SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: MaterialButton(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 5,
                        ),
                        color: Theme.of(context).primaryColor,
                        textColor: Theme.of(context).primaryTextTheme.labelMedium?.color,
                        onPressed: showAvailableKaryakartaDialog,
                        child: Text(
                          "${Statics.getLabel('abhiyaanKaryakartaList')}",
                          // "अभियान कार्यकर्ता सुची",
                          style: TextStyle(fontSize: 14.5),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  isSelectedKaryakartaListWidget(),
                  SizedBox(height: 24),
                  Align(
                    alignment: Alignment.center,
                    child: MaterialButton(
                      minWidth: MediaQuery.sizeOf(context).width * 0.4,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      padding: EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      color: Theme.of(context).primaryColor,
                      textColor: Theme.of(context).primaryTextTheme.labelMedium?.color,
                      // onPressed: () {
                      //   Statics.showToast(Statics.getLabel("workInProgress"));
                      // },
                      onPressed: () async {
                        // if (isAbhiyaanButPramukh && !_isEditing) {
                        await saveGruhForPramukhFun();
                        return;
                        // }
                        // if (dateController.text.isEmpty || samparkitGhareController.text.isEmpty || vitritKarpatrakController.text.isEmpty || pustakVikriController.text.isEmpty) {
                        //   Statics.showToast(Statics.getLabel("impInfoRequired"));
                        //   return null;
                        //   // } else if (!(abhiyaanSwayamsevakDataList.any((e) => e.isSelected))) {
                        //   //   print("स्तराचे नाव निवडा");
                        //   //   Statics.showToast("किमान एक अभियान कार्यकर्ता जोडावे");
                        //   //   return null;
                        // } else {
                        //   print("saving data");
                        //   await saveGruhAbhiyaanDataFun();
                        // }
                        // _submit(context);
                      },
                      child: Text(
                        Statics.getLabel('Submit'),
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
                // SizedBox(height: 32),
                // if (!isSwayamsevakWithoutAbhiyaan)
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     MaterialButton(
                //       minWidth: MediaQuery.sizeOf(context).width * 0.4,
                //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                //       padding: EdgeInsets.symmetric(
                //         horizontal: 24,
                //         vertical: 12,
                //       ),
                //       color: Theme.of(context).primaryColor,
                //       textColor: Theme.of(context).primaryTextTheme.labelMedium?.color,
                //       // onPressed: () {
                //       //   Statics.showToast(Statics.getLabel("workInProgress"));
                //       // },
                //       onPressed: () async {
                //         // if (isAbhiyaanButPramukh && !_isEditing) {
                //         //   await saveGruhForPramukhFun();
                //         //   return;
                //         // }
                //         if (dateController.text.isEmpty || samparkitGhareController.text.isEmpty || vitritKarpatrakController.text.isEmpty || pustakVikriController.text.isEmpty) {
                //           Statics.showToast(Statics.getLabel("impInfoRequired"));
                //           return null;
                //           // } else if (!(abhiyaanSwayamsevakDataList.any((e) => e.isSelected))) {
                //           //   print("स्तराचे नाव निवडा");
                //           //   Statics.showToast("किमान एक अभियान कार्यकर्ता जोडावे");
                //           //   return null;
                //         } else {
                //           print("saving data");
                //           await saveGruhAbhiyaanDataFun();
                //         }
                //         // _submit(context);
                //       },
                //       child: Text(
                //         Statics.getLabel('Submit'),
                //         style: TextStyle(fontSize: 16),
                //       ),
                //     ),
                //     if (_isEditing)
                //       MaterialButton(
                //         minWidth: MediaQuery.sizeOf(context).width * 0.35,
                //         onPressed: () async {
                //           setState(() {
                //             _isEditing = false;
                //             dateController.text = DateFormat("dd/MM/yyyy").format(DateTime.now());
                //             samparkitGhareController.clear();
                //             vitritKarpatrakController.clear();
                //             pustakVikriController.clear();
                //             createdUserId = null;
                //             selectedSajjanshaktiItems = [];
                //           });
                //           // await populateDropdown(isClear: true);
                //         },
                //         child: Text(
                //           Statics.getLabel('clear'),
                //         ),
                //       ),
                //   ],
                // ),
                if (_searched && !isSwayamsevakWithoutAbhiyaan) SizedBox(height: 40),
                // if (isSwayamsevakWithoutAbhiyaan) showAbhiyaanPramukhListWidget(),
                SizedBox(height: 18),
                // Align(alignment: Alignment.centerLeft, child: Text("मागील दिवसाचा डेटा :")),
                // SizedBox(height: 8),
                if (_searched) (isAbhiyaanButPramukh) ? showPreviousDayDataTableForPramukh() : showPreviousDayDataTable(),
                SizedBox(height: 40),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget showAbhiyaanPramukhListWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "अभियान प्रमुख : ",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          mainContainer(
            "अभियान प्रमुख",
            Column(
              children: [
                // Button for popup
                if (pramukhList.isEmpty)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () async {
                          Navigator.of(context).pushNamed(AddAbhiyaanPramukhScreen.routeName, arguments: _selectedGeoUnitId)!.then((value) => _getSwList());
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          width: 150,
                          height: 35,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.purpleAccent.shade100),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Center(
                            child: Text(
                              "अभियान प्रमुख",
                              style: TextStyle(
                                color: Colors.purpleAccent,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                const SizedBox(height: 20),

                // Table for Sajjanshakti
                if (pramukhList.isNotEmpty) ...[
                  // Text("${Statics.getLabel('SajjanShakti')}", style: TextStyle(fontWeight: FontWeight.bold)),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columnSpacing: 12,
                      // dataRowMinHeight: 30,
                      // dataRowMaxHeight: 70,
                      showCheckboxColumn: false,
                      headingRowColor: MaterialStatePropertyAll(Colors.purple.shade50),
                      headingTextStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
                      columns: [
                        // DataColumn(
                        //     label: Text(
                        //       "",
                        //     )),
                        DataColumn(
                            label: Text(
                          "${Statics.getLabel('Name')}",
                        )),
                        DataColumn(
                            label: Text(
                          "${Statics.getLabel('mobileNumberLabel')}",
                        )),
                        // DataColumn(
                        //     label: Text(
                        //   "${Statics.getLabel('daayitvaName')}",
                        // )),
                      ],
                      rows: pramukhList.asMap().entries.map((entry) {
                        int index = entry.key;
                        var data = entry.value;
                        bool isSelected = (data.isdefault == 1) || _selectedTolisIds.contains(data);
                        return DataRow(cells: [
                          DataCell(Container(constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width * 0.4), child: Text(data.fullName ?? ''))),
                          DataCell(Text(data.mobileno ?? '')),
                          // DataCell(Text(Statics.getLabel(data.daayitva.toString(), returnKey: true))),
                        ]);
                      }).toList(),
                    ),
                  ),
                ],

                const SizedBox(height: 20),

                // Table for Anyaprabhavi
                if (selectedAnyaprabhaviItems.isNotEmpty) ...[
                  Text("${Statics.getLabel('anyaPrabhaviLok')}", style: TextStyle(fontWeight: FontWeight.bold)),
                  Table(
                    border: TableBorder.all(),
                    columnWidths: const {
                      0: FixedColumnWidth(40),
                      1: FlexColumnWidth(),
                      2: FlexColumnWidth(),
                      3: FixedColumnWidth(50), // 👁 button column
                    },
                    children: [
                      TableRow(
                        decoration: BoxDecoration(color: Color(0xFFE0E0E0)),
                        children: [
                          Padding(padding: EdgeInsets.all(4), child: Text("${Statics.getLabel('serialNo')}")),
                          Padding(padding: EdgeInsets.all(4), child: Text("${Statics.getLabel('Name')}")),
                          Padding(padding: EdgeInsets.all(4), child: Text("${Statics.getLabel('samparkSootraNaav')}")),
                          Padding(padding: EdgeInsets.all(4), child: Text("${Statics.getLabel('ViewMenu')}")), // 👁 column heading
                        ],
                      ),
                      ...selectedAnyaprabhaviItems.asMap().entries.map((entry) {
                        int srNo = entry.key + 1;
                        final item = entry.value;

                        return TableRow(
                          children: [
                            Padding(padding: const EdgeInsets.all(4), child: Text(srNo.toString())),
                            Padding(padding: const EdgeInsets.all(4), child: Text(item.name ?? "")),
                            Padding(padding: const EdgeInsets.all(4), child: Text(item.samparkAsutraNav ?? "")),
                            IconButton(
                              icon: Icon(Icons.remove_red_eye, size: 22, color: Colors.purpleAccent),
                              onPressed: () {
                                showPersonDetailsPopup(context, item, srNo);
                              },
                            ),
                          ],
                        );
                      }).toList(),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget showPreviousDayDataTable() {
    final _tableData = gruhAbhiyaanVruttaData?.previousDay;
    final List<String> headers = [
      // 'कार्यक्रम स्तर',
      Statics.getLabel('gruhSamarkitGhar'),
      Statics.getLabel('gruhVitaritKarpatra'),
      Statics.getLabel('gruhPustakVikti'),
      Statics.getLabel('gruhSpecialContact'),
      "",
    ];

    if (_tableData == null || _tableData.isEmpty) return SizedBox();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("${Statics.getLabel("otherDaysData")} :", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: Colors.purple.shade400,
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            ),
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text(
              _tableData.first.participantName.toString(),
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            ),
          ),
          Row(
            children: [
              DataTable(
                headingRowColor: MaterialStateColor.resolveWith((_) => Colors.purple.shade100),
                columnSpacing: 0,
                horizontalMargin: 16,
                border: TableBorder.all(color: Colors.black26),
                columns: [
                  DataColumn(
                    label: Center(
                      child: Text(
                        "अभियान तारखा",
                        softWrap: true,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
                rows: _tableData.map((level) {
                      return DataRow(cells: [
                        DataCell(Text(level.abhiyaanDate.toString())),
                      ]);
                    }).toList() +
                    [
                      DataRow(color: MaterialStatePropertyAll(Colors.yellow.shade100), cells: [
                        DataCell(Text(
                          Statics.getLabel("Total"),
                          style: TextStyle(fontWeight: FontWeight.w700),
                        )),
                      ])
                    ],
              ),
              Expanded(
                child: Scrollbar(
                  controller: _scrollController,
                  thumbVisibility: true,
                  interactive: true,
                  thickness: 5,
                  radius: Radius.circular(10),
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columnSpacing: 14,
                      horizontalMargin: 12,
                      headingRowColor: MaterialStateColor.resolveWith((_) => Colors.purple.shade100),
                      border: TableBorder(verticalInside: BorderSide(width: 0.7, color: Colors.grey.shade200)),
                      columns: headers
                          .map((header) => DataColumn(
                                label: Container(
                                  constraints: BoxConstraints(minWidth: 40, maxWidth: 200),
                                  // constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width * 0.2),
                                  child: Text(header, softWrap: true, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontWeight: FontWeight.bold)),
                                ),
                              ))
                          .toList(),
                      rows: _tableData.map((item) {
                            return DataRow(cells: [
                              DataCell(Center(child: Text(item.samparkitghar.toString()))),
                              DataCell(Center(child: Text(item.vitaritkarpatra.toString()))),
                              DataCell(Center(child: Text(item.pustakvikrisankhya.toString()))),
                              DataCell(Center(child: Text(item.totalAtithiCount.toString()))),
                              DataCell(Container(
                                constraints: BoxConstraints(
                                  minWidth: 30,
                                ),
                                child: InkWell(
                                    // onTap: () {
                                    //   Statics.showToast(Statics.getLabel("workInProgress"));
                                    // },
                                    onTap: () {
                                      log(jsonEncode(item));
                                      setState(() {
                                        _isEditing = true;
                                        if (item.createdUserID == Statics.abhiyaanUserDetails["AbhiyanSwayamsevakID"] && isAbhiyaanButPramukh) _isEditingForPramukh = true;
                                      });
                                      Future.delayed(
                                        Duration(milliseconds: 100),
                                        () => setState(() {
                                          dateController.text = DateFormat("dd/MM/yyyy").format(DateFormat("dd-MM-yyyy").parse(item.abhiyaanDate.toString()));
                                          samparkitGhareController.text = item.samparkitghar.toString();
                                          vitritKarpatrakController.text = item.vitaritkarpatra.toString();
                                          pustakVikriController.text = item.pustakvikrisankhya.toString();
                                          createdUserId = item.createdUserID;

                                          if (item.createdUserID == Statics.abhiyaanUserDetails["AbhiyanSwayamsevakID"] && isAbhiyaanButPramukh)
                                            samparkaSahabhagiController.text = item.samparkhetusahbhagisankhya.toString();
                                          if (item.createdUserID == Statics.abhiyaanUserDetails["AbhiyanSwayamsevakID"] && isAbhiyaanButPramukh)
                                            samparkaToliController.text = item.samparkhetutolisankhya.toString();

                                          if (data != null) {
                                            // setState(() {
                                            selectedSajjanshaktiItems = data!.vastisarsajjanshakti!.where((e) => item.visititAtithiSajjanShaktiids!.split(",").contains(e.pkid.toString())).toList();
                                            selectedAnyaprabhaviItems = data!.vastisanyaprabhavi!.where((e) => item.visititAtithiAnyaprabhaViLokamids!.split(",").contains(e.pkId.toString())).toList();
                                            // });
                                          }
                                          _scrollController.animateTo(
                                            0,
                                            duration: const Duration(milliseconds: 600),
                                            curve: Curves.easeInOutSine,
                                          );
                                        }),
                                      );
                                    },
                                    child: Icon(
                                      Icons.edit,
                                      color: Colors.green.shade700,
                                    )),
                              ))
                            ]);
                          }).toList() +
                          [
                            DataRow(color: MaterialStatePropertyAll(Colors.yellow.shade100), cells: [
                              //sanchalan
                              DataCell(Center(
                                  child: Text(
                                _tableData.fold(0, (sum, item) => sum + (item.samparkitghar ?? 0)).toString(),
                                style: TextStyle(fontWeight: FontWeight.w700),
                              ))),
                              DataCell(Center(
                                  child: Text(
                                _tableData.fold(0, (sum, item) => sum + (item.vitaritkarpatra ?? 0)).toString(),
                                style: TextStyle(fontWeight: FontWeight.w700),
                              ))),
                              DataCell(Center(
                                  child: Text(
                                _tableData.fold(0, (sum, item) => sum + (item.pustakvikrisankhya ?? 0)).toString(),
                                style: TextStyle(fontWeight: FontWeight.w700),
                              ))),
                              DataCell(Center(
                                  child: Text(
                                _tableData.fold(0, (sum, item) => sum + (item.totalAtithiCount ?? 0)).toString(),
                                style: TextStyle(fontWeight: FontWeight.w700),
                              ))),
                              DataCell.empty,
                            ])
                          ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget showPreviousDayDataTableForPramukh() {
    final _tableData = gruhAbhiyaanVruttaData?.previousDay;
    final List<String> headers = [
      // 'कार्यक्रम स्तर',
      Statics.getLabel('gruhSamarkitGhar'),
      Statics.getLabel('gruhVitaritKarpatra'),
      Statics.getLabel('gruhPustakVikti'),
      Statics.getLabel('gruhSpecialContact'),
      if (!isSwayamsevakWithoutAbhiyaan) "",
    ];

    if (_tableData == null || _tableData.isEmpty) return SizedBox();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[Text("मागील दिवसाचा डेटा :", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)), SizedBox(height: 8)] +
            separatedLists.map((group) {
              // group is List<PreviousDayModel> for one CreatedUserID
              final first = group.first;
              final vruttaDate = first.abhiyaanDate ?? '--';

              // compute totals for this group
              final totalSampark = group.fold<int>(0, (s, e) => s + (e.samparkitghar ?? 0));
              final totalVitarit = group.fold<int>(0, (s, e) => s + (e.vitaritkarpatra ?? 0));
              final totalPustak = group.fold<int>(0, (s, e) => s + (e.pustakvikrisankhya ?? 0));
              final totalSpecial = group.fold<int>(0, (s, e) => s + (e.totalAtithiCount ?? 0));

              // create a ScrollController for the horizontal scroll per tile (optional)
              final horizontalController = ScrollController();

              return Card(
                clipBehavior: Clip.antiAlias,
                margin: EdgeInsets.only(top: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                surfaceTintColor: Colors.transparent,
                child: ExpansionTile(
                  tilePadding: EdgeInsets.only(right: 16, left: 16),
                  childrenPadding: EdgeInsets.zero,
                  collapsedBackgroundColor: Colors.teal.shade100,
                  backgroundColor: Colors.teal.shade100,
                  initiallyExpanded: true,
                  shape: RoundedRectangleBorder(side: BorderSide.none, borderRadius: BorderRadius.circular(12)),
                  collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  title: Text(
                    vruttaDate,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent.shade700,
                    ),
                  ),
                  children: [
                    Container(
                      color: Colors.white,
                      padding: const EdgeInsets.only(left: 18.0, right: 18.0, bottom: 8.0, top: 12),
                      child: Container(
                        constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * 0.4),
                        decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade800)),
                        padding: EdgeInsets.all(4),
                        child: Scrollbar(
                          thumbVisibility: true,
                          radius: Radius.circular(8),
                          thickness: 5,
                          child: SingleChildScrollView(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                DataTable(
                                  headingRowColor: MaterialStateColor.resolveWith((_) => Colors.purple.shade100),
                                  columnSpacing: 0,
                                  horizontalMargin: 16,
                                  border: TableBorder.all(color: Colors.black26),
                                  columns: [
                                    DataColumn(
                                      label: Center(
                                        child: Text(
                                          "${Statics.getLabel('gruhKaryakartaName')}",
                                          softWrap: true,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ],
                                  // dataRowMinHeight: 40,
                                  // dataRowMaxHeight: 120,
                                  rows: [
                                    ...group.map((item) {
                                      return DataRow(cells: [
                                        DataCell(Text(item.participantName.toString())),
                                      ]);
                                    }),
                                    DataRow(
                                      color: MaterialStatePropertyAll(Colors.yellow.shade100),
                                      cells: [
                                        DataCell(Text(
                                          'Total',
                                          style: const TextStyle(fontWeight: FontWeight.w700),
                                        )),
                                      ],
                                    ),
                                  ],
                                ),

                                //
                                Expanded(
                                  child: Scrollbar(
                                    thumbVisibility: true,
                                    controller: horizontalController,
                                    child: SingleChildScrollView(
                                      controller: horizontalController,
                                      scrollDirection: Axis.horizontal,
                                      child: DataTable(
                                        columnSpacing: 14,
                                        horizontalMargin: 12,
                                        headingRowColor: MaterialStateColor.resolveWith((_) => Colors.purple.shade100),
                                        border: TableBorder(
                                          verticalInside: BorderSide(width: 0.7, color: Colors.grey.shade200),
                                        ),
                                        columns: headers
                                            .map((header) => DataColumn(
                                                  label: Container(
                                                    constraints: const BoxConstraints(minWidth: 30, maxWidth: 200),
                                                    child: Text(
                                                      header,
                                                      softWrap: true,
                                                      maxLines: 2,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                                    ),
                                                  ),
                                                ))
                                            .toList(),
                                        rows: [
                                          ...group.map((item) {
                                            return DataRow(cells: [
                                              DataCell(Center(child: Text((item.samparkitghar ?? 0).toString()))),
                                              DataCell(Center(child: Text((item.vitaritkarpatra ?? 0).toString()))),
                                              DataCell(Center(child: Text((item.pustakvikrisankhya ?? 0).toString()))),
                                              DataCell(Center(child: Text((item.totalAtithiCount ?? 0).toString()))),
                                              if (!isSwayamsevakWithoutAbhiyaan)
                                                DataCell(Container(
                                                  constraints: BoxConstraints(
                                                    minWidth: 30,
                                                  ),
                                                  child: InkWell(
                                                      // onTap: () {
                                                      //   Statics.showToast(Statics.getLabel("workInProgress"));
                                                      // },
                                                      onTap: () {
                                                        log(jsonEncode(item));
                                                        setState(() {
                                                          _isEditing = true;
                                                          if (item.createdUserID == Statics.abhiyaanUserDetails["AbhiyanSwayamsevakID"] && isAbhiyaanButPramukh) _isEditingForPramukh = true;
                                                        });
                                                        Future.delayed(
                                                          Duration(milliseconds: 100),
                                                          () => setState(() {
                                                            dateController.text = DateFormat("dd/MM/yyyy").format(DateFormat("dd-MM-yyyy").parse(item.abhiyaanDate.toString()));
                                                            samparkitGhareController.text = item.samparkitghar.toString();
                                                            vitritKarpatrakController.text = item.vitaritkarpatra.toString();
                                                            pustakVikriController.text = item.pustakvikrisankhya.toString();
                                                            createdUserId = item.createdUserID;

                                                            if (item.createdUserID == Statics.abhiyaanUserDetails["AbhiyanSwayamsevakID"] && isAbhiyaanButPramukh)
                                                              samparkaSahabhagiController.text = item.samparkhetusahbhagisankhya.toString();
                                                            if (item.createdUserID == Statics.abhiyaanUserDetails["AbhiyanSwayamsevakID"] && isAbhiyaanButPramukh)
                                                              samparkaToliController.text = item.samparkhetutolisankhya.toString();

                                                            if (data != null) {
                                                              // setState(() {
                                                              selectedSajjanshaktiItems =
                                                                  data!.vastisarsajjanshakti!.where((e) => item.visititAtithiSajjanShaktiids!.split(",").contains(e.pkid.toString())).toList();
                                                              selectedAnyaprabhaviItems =
                                                                  data!.vastisanyaprabhavi!.where((e) => item.visititAtithiAnyaprabhaViLokamids!.split(",").contains(e.pkId.toString())).toList();
                                                              // });
                                                            }
                                                            _scrollController.animateTo(
                                                              0,
                                                              duration: const Duration(milliseconds: 600),
                                                              curve: Curves.easeInOutSine,
                                                            );
                                                          }),
                                                        );
                                                      },
                                                      child: Icon(
                                                        Icons.edit,
                                                        color: Colors.green.shade700,
                                                      )),
                                                )),
                                            ]);
                                          }).toList(),
                                          // totals row
                                          DataRow(
                                            color: MaterialStatePropertyAll(Colors.yellow.shade100),
                                            cells: [
                                              DataCell(Center(
                                                  child: Text(
                                                totalSampark.toString(),
                                                style: const TextStyle(fontWeight: FontWeight.w700),
                                              ))),
                                              DataCell(Center(
                                                  child: Text(
                                                totalVitarit.toString(),
                                                style: const TextStyle(fontWeight: FontWeight.w700),
                                              ))),
                                              DataCell(Center(
                                                  child: Text(
                                                totalPustak.toString(),
                                                style: const TextStyle(fontWeight: FontWeight.w700),
                                              ))),
                                              DataCell(Center(
                                                  child: Text(
                                                totalSpecial.toString(),
                                                style: const TextStyle(fontWeight: FontWeight.w700),
                                              ))),
                                              if (!isSwayamsevakWithoutAbhiyaan) DataCell(SizedBox()),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
      ),
    );
  }

  Widget isSelectedKaryakartaListWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * 0.4),
        padding: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black54),
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        // width: MediaQuery.of(context).size.width,
        child: Scrollbar(
          thumbVisibility: true,
          radius: Radius.circular(8),
          thickness: 5,
          child: SingleChildScrollView(
            child: DataTable(
              columnSpacing: 12,
              // dataRowMinHeight: 30,
              // dataRowMaxHeight: 70,
              showCheckboxColumn: false,
              headingRowColor: MaterialStatePropertyAll(Colors.purple.shade50),
              headingTextStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
              columns: [
                if (!isSwayamsevakWithoutAbhiyaan)
                  DataColumn(
                      label: Text(
                    "",
                  )),
                DataColumn(
                    label: Text(
                  "${Statics.getLabel('Name')}",
                )),
                DataColumn(
                    label: Text(
                  "${Statics.getLabel('mobileNumberLabel')}",
                )),
                // DataColumn(
                //     label: Text(
                //   "${Statics.getLabel('daayitvaName')}",
                // )),
              ],
              rows: gruhAbhiyaanToliList.asMap().entries.map((entry) {
                int index = entry.key;
                var data = entry.value;
                bool isSelected = (data.isdefault == 1) || _selectedTolisIds.contains(data);
                return DataRow(
                    selected: isSelected,
                    color: MaterialStateProperty.resolveWith<Color?>(
                      (Set<MaterialState> states) {
                        if (isSelected) return Colors.yellow.shade100;
                        return null;
                      },
                    ),
                    onSelectChanged: (bool? selected) {
                      if (isSwayamsevakWithoutAbhiyaan) {
                        return;
                      }
                      if (gruhAbhiyaanVruttaData!.abhiyaandata!.ishide) {
                        return;
                      }
                      if ((data.isdefault == 1)) {
                        return;
                      }
                      if (!isSelected) {
                        setState(() {
                          // selectedKaryakartaList.add(data);
                          _selectedTolisIds.add(data);
                        });
                      } else {
                        setState(() {
                          // selectedKaryakartaList.add(data);
                          _selectedTolisIds.remove(data);
                        });
                      }
                      log(_selectedTolisIds.map((e) => e.swayamsevakID.toString()).join(','));
                    },
                    cells: [
                      if (!isSwayamsevakWithoutAbhiyaan) DataCell(Icon(isSelected ? Icons.check_box_rounded : Icons.check_box_outline_blank_rounded, color: Colors.yellow.shade900, size: 21)),
                      DataCell(Container(constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width * 0.4), child: Text(data.fullName ?? ''))),
                      DataCell(Text(data.mobileno ?? '')),
                      // DataCell(Text(Statics.getLabel(data.daayitva.toString(), returnKey: true))),
                    ]);
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  customTextFields({required String title, bool isRequired = false, required TextEditingController controller, String? hintText, bool readOnly = false, void Function()? onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold),
                ),
                if (isRequired)
                  Text(
                    " *",
                    style: TextStyle(fontSize: 15, color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                // TextSpan(
                //  text: " : ",
                //   style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                // ),
              ],
            ),
          ),
          // Text(
          //   " : ",
          //   style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          // ),
          Expanded(
            child: TextFormField(
              controller: controller,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(10)],
              style: TextStyle(fontSize: 14),
              autofocus: false,
              onTap: onTap,
              readOnly: readOnly,
              enabled: !readOnly,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                  // isDense: true,
                  hintText: hintText ?? "0",
                  contentPadding: EdgeInsets.only(left: 12, right: 12, top: 14, bottom: 12),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(5))),
            ),
          ),
        ],
      ),
    );
  }

  String? selectedSajjanshaktiItemsIds;
  String? selectedAnyaprabhaviItemsIds;

  Future<void> showPersonDetailsPopup(BuildContext context, dynamic item, int srNo) {
    List<Map<String, String>> details = [];

    // Agar Vastisarsajjanshakti ka object aaya
    if (item is Vastisarsajjanshakti) {
      details = [
        {"${Statics.getLabel('Vasti')} :": item.vastiname ?? ""},
        {"${Statics.getLabel('Name')} :": item.name ?? ""},
        {"${Statics.getLabel('Address')} :": item.address ?? ""},
        {"${Statics.getLabel('mobileNumberLabel')} :": item.doorabhaash ?? ""},
        {"${Statics.getLabel('shreni')}  :": item.selectedDropdownValueName ?? ""},
        {"${Statics.getLabel('OrganizationName')}  :": item.sanstheCheNaav ?? ""},
        {"${Statics.getLabel('sansthetKuthalaPadavar')}   :": item.sansthechaKuthalaPadavar ?? ""},
        {"${Statics.getLabel('samparkSthiti')}  :": item.selectedDropdownValueName1 ?? ""},
        {"${Statics.getLabel('special')} :": item.visheshname ?? ""},
        {"${Statics.getLabel('prabhavKshetra')} :": item.prabhaavkshetrName ?? ""},
        {"${Statics.getLabel('samparkSootraNaav')} :": item.samparkasutranava ?? ""},
        {"${Statics.getLabel('samparakSootraDoorbhash')} :": item.samparkasutraMobileNumber ?? ""},
      ];
    }

    // Agar Vastisanyaprabhavi ka object aaya
    else if (item is Vastisanyaprabhavi) {
      details = [
        {"${Statics.getLabel('Vasti')}  :": item.vastiName ?? ""},
        {"${Statics.getLabel('Name')} :": item.name ?? ""},
        {"${Statics.getLabel('Address')}:": item.address ?? ""},
        {"${Statics.getLabel('mobileNumberLabel')} :": item.doorabhaash ?? ""},
        {"${Statics.getLabel('shreni')}  :": item.shreneeName ?? ""},
        {"${Statics.getLabel('upshreni')} :": item.upshreneeName ?? ""},
        {"${Statics.getLabel('otherUpshreni')}  :": item.otherUpshrenee ?? ""},
        {"${Statics.getLabel('upshreni')}2 :": item.upshrenee2Name ?? ""},
        {"${Statics.getLabel('otherUpshreni')}2 :": item.otherUpshrenee2 ?? ""},
        {"${Statics.getLabel('special')}  :": item.visheshName ?? ""},
        {"${Statics.getLabel('prabhavKshetra')} :": item.prabhaavKshetreName ?? ""},
        {"${Statics.getLabel('other')} ${Statics.getLabel('special')}  :": item.anyaVishesMahiti ?? ""},
        {"${Statics.getLabel('samparkStithi')} :": item.samparkSthit ?? ""},
        {"${Statics.getLabel('samparkSootraNaav')} :": item.samparkAsutraNav ?? ""},
        {"${Statics.getLabel('samparakSootraDoorbhash')} :": item.samparkaSutraDoorbhash ?? ""},
      ];
    }

    return showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          insetPadding: const EdgeInsets.all(16),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 🔹 Header with gradient
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.purple, Colors.purpleAccent],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${Statics.getLabel('PersonalDetails')}",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),

                // 🔹 Details List
                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: details
                          .map(
                            (e) => Container(
                              margin: const EdgeInsets.symmetric(vertical: 6),
                              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 5,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Text(
                                      e.keys.first,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 5,
                                    child: Text(
                                      e.values.first.isEmpty ? "-" : e.values.first,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                // 🔹 Footer Button
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purpleAccent,
                      minimumSize: const Size.fromHeight(45),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.check_circle, color: Colors.white),
                    label: Text(
                      "${Statics.getLabel('bandKara')}",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> showVisheshAtithiSelectionPopup(BuildContext context, {required VoidCallback onAdd}) async {
    print("showVisheshAtithiSelectionPopup onTap >>>>>>>>>>>>>>> ");
    final _sarsajjanshaktiList = data?.vastisarsajjanshakti ?? [];
    final _sanyaprabhaviList = data?.vastisanyaprabhavi ?? [];

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        if (data == null) {
          return Center(child: CircularProgressIndicator());
        }
        return StatefulBuilder(
          builder: (ctnx, set) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              content: Container(
                // padding: const EdgeInsets.all(16),
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    /// Title with Close Button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          Statics.getLabel('selectSpecialPerson'),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.purpleAccent,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.red),
                          onPressed: () => Navigator.pop(ctnx),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    SizedBox(height: 6),
                    Align(
                        alignment: Alignment.centerRight,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.purpleAccent, width: 1.5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          ),
                          onPressed: onAdd,
                          child: Text(
                            Statics.getLabel('fillNewRecord'),
                            style: const TextStyle(color: Colors.purpleAccent),
                          ),
                        )),
                    SizedBox(height: 6),

                    Flexible(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            /// Content
                            const SizedBox(height: 12),
                            Text(
                              Statics.getLabel('SajjanShakti'),
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: Colors.blueGrey,
                              ),
                            ),
                            const Divider(),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black12),
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.white,
                              ),
                              child: Table(
                                border: TableBorder.symmetric(
                                  inside: const BorderSide(color: Colors.black12),
                                ),
                                columnWidths: const {
                                  0: FixedColumnWidth(50),
                                },
                                children: [
                                  // Header
                                  TableRow(
                                    decoration: BoxDecoration(
                                      color: Colors.blue.shade50,
                                    ),
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.all(8),
                                        child: Text("✔", style: TextStyle(fontWeight: FontWeight.bold)),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(8),
                                        child: Text(Statics.getLabel("Name"), style: TextStyle(fontWeight: FontWeight.bold)),
                                      ),
                                    ],
                                  ),
                                  ..._sarsajjanshaktiList.map((item) {
                                    return TableRow(
                                      children: [
                                        Center(
                                            child: Checkbox(
                                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                          value: selectedSajjanshaktiItems.any((x) => x.pkid == item.pkid),
                                          onChanged: (val) {
                                            set(() {
                                              if (val == true) {
                                                selectedSajjanshaktiItems.add(item);
                                              } else {
                                                selectedSajjanshaktiItems.removeWhere((x) => x.pkid == item.pkid);
                                              }
                                            });
                                            selectedSajjanshaktiItemsIds = selectedSajjanshaktiItems.map((e) => e.pkid.toString()).join(",");
                                            // String anyaIds = selectedAnyaprabhavi.map((e) => e.pkId.toString()).join(",");
                                            log(selectedSajjanshaktiItemsIds.toString());
                                            log("-----------------------------");
                                            // log(anyaIds);

                                            // onSubmit(sajIds, anyaIds, selectedSajjanshakti, selectedAnyaprabhavi);
                                            set(() {});
                                          },
                                        )),
                                        Padding(
                                          padding: const EdgeInsets.all(8),
                                          child: Text(item.name ?? "Unknown"),
                                        ),
                                      ],
                                    );
                                  }),
                                ],
                              ),
                            ),

                            const SizedBox(height: 12),

                            /// Anya Prabhavi Lok
                            Text(
                              Statics.getLabel('anyaPrabhaviLok'),
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: Colors.blueGrey,
                              ),
                            ),
                            const Divider(),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black12),
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.white,
                              ),
                              child: Table(
                                border: TableBorder.symmetric(
                                  inside: const BorderSide(color: Colors.black12),
                                ),
                                columnWidths: const {
                                  0: FixedColumnWidth(50),
                                },
                                children: [
                                  // Header
                                  TableRow(
                                    decoration: BoxDecoration(
                                      color: Colors.blue.shade50,
                                    ),
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.all(8),
                                        child: Text("✔", style: TextStyle(fontWeight: FontWeight.bold)),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(8),
                                        child: Text(Statics.getLabel("Name"), style: TextStyle(fontWeight: FontWeight.bold)),
                                      ),
                                    ],
                                  ),
                                  ..._sanyaprabhaviList.map((item) {
                                    return TableRow(
                                      children: [
                                        Center(
                                            child: Checkbox(
                                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                          value: selectedAnyaprabhaviItems.any((x) => x.pkId == item.pkId),
                                          onChanged: (val) {
                                            set(() {
                                              if (val == true) {
                                                selectedAnyaprabhaviItems.add(item);
                                              } else {
                                                selectedAnyaprabhaviItems.removeWhere((x) => x.pkId == item.pkId);
                                              }
                                            });
                                            // String sajIds = selectedSajjanshakti.map((e) => e.pkid.toString()).join(",");
                                            selectedAnyaprabhaviItemsIds = selectedAnyaprabhaviItems.map((e) => e.pkId.toString()).join(",");

                                            // onSubmit(sajIds, anyaIds, selectedSajjanshakti, selectedAnyaprabhavi);
                                            // log(sajIds);
                                            log(selectedAnyaprabhaviItemsIds.toString());
                                            set(() {});
                                          },
                                        )),
                                        Padding(
                                          padding: const EdgeInsets.all(8),
                                          child: Text(item.name ?? "Unknown"),
                                        ),
                                      ],
                                    );
                                  }),
                                ],
                              ),
                            ),

                            // ...filteredAnyaprabhavi.map((item) {
                            //   return CheckboxListTile(
                            //     dense: true,
                            //     contentPadding: EdgeInsets.zero,
                            //     title: Text(item.name ?? "Unknown"),
                            //     value: selectedAnyaprabhavi.any((x) => x.pkId == item.pkId),
                            //     onChanged: (val) {
                            //       set(() {
                            //         if (val == true) {
                            //           selectedAnyaprabhavi.add(item);
                            //         } else {
                            //           selectedAnyaprabhavi.removeWhere((x) => x.pkId == item.pkId);
                            //         }
                            //       });
                            //       String sajIds = selectedSajjanshakti.map((e) => e.pkid.toString()).join(",");
                            //       String anyaIds = selectedAnyaprabhavi.map((e) => e.pkId.toString()).join(",");
                            //
                            //       onSubmit(sajIds, anyaIds, selectedSajjanshakti, selectedAnyaprabhavi);
                            //       log(sajIds);
                            //       log(anyaIds);
                            //       set(() {});
                            //     },
                            //   );
                            // }),
                            // Expanded(
                            //   child: SingleChildScrollView(
                            //     child: Column(
                            //       crossAxisAlignment: CrossAxisAlignment.start,
                            //       children: [
                            //         /// Sajjan Shakti
                            //         Text(
                            //           Statics.getLabel('SajjanShakti'),
                            //           style: const TextStyle(
                            //             fontWeight: FontWeight.w600,
                            //             fontSize: 16,
                            //             color: Colors.blueGrey,
                            //           ),
                            //         ),
                            //         const Divider(),
                            //
                            //         ...filteredSajjanshakti.map((item) {
                            //           return CheckboxListTile(
                            //             dense: true,
                            //             contentPadding: EdgeInsets.zero,
                            //             title: Text(item.name ?? "Unknown"),
                            //             value: selectedSajjanshakti.any((x) => x.pkid == item.pkid),
                            //             onChanged: (val) {
                            //               set(() {
                            //                 if (val == true) {
                            //                   selectedSajjanshakti.add(item);
                            //                 } else {
                            //                   selectedSajjanshakti.removeWhere((x) => x.pkid == item.pkid);
                            //                 }
                            //               });
                            //               String sajIds = selectedSajjanshakti.map((e) => e.pkid.toString()).join(",");
                            //               String anyaIds = selectedAnyaprabhavi.map((e) => e.pkId.toString()).join(",");
                            //               log(sajIds);
                            //               log("-----------------------------");
                            //               log(anyaIds);
                            //
                            //               onSubmit(sajIds, anyaIds, selectedSajjanshakti, selectedAnyaprabhavi);
                            //               set(() {});
                            //             },
                            //           );
                            //         }),
                            //
                            //         const SizedBox(height: 12),
                            //
                            //         /// Anya Prabhavi Lok
                            //         Text(
                            //           Statics.getLabel('anyaPrabhaviLok'),
                            //           style: const TextStyle(
                            //             fontWeight: FontWeight.w600,
                            //             fontSize: 16,
                            //             color: Colors.blueGrey,
                            //           ),
                            //         ),
                            //         const Divider(),
                            //
                            //         ...filteredAnyaprabhavi.map((item) {
                            //           return CheckboxListTile(
                            //             dense: true,
                            //             contentPadding: EdgeInsets.zero,
                            //             title: Text(item.name ?? "Unknown"),
                            //             value: selectedAnyaprabhavi.any((x) => x.pkId == item.pkId),
                            //             onChanged: (val) {
                            //               set(() {
                            //                 if (val == true) {
                            //                   selectedAnyaprabhavi.add(item);
                            //                 } else {
                            //                   selectedAnyaprabhavi.removeWhere((x) => x.pkId == item.pkId);
                            //                 }
                            //               });
                            //               String sajIds = selectedSajjanshakti.map((e) => e.pkid.toString()).join(",");
                            //               String anyaIds = selectedAnyaprabhavi.map((e) => e.pkId.toString()).join(",");
                            //
                            //               onSubmit(sajIds, anyaIds, selectedSajjanshakti, selectedAnyaprabhavi);
                            //               log(sajIds);
                            //               log(anyaIds);
                            //               set(() {});
                            //             },
                            //           );
                            //         }),
                            //       ],
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.purpleAccent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () {
                              set(() {});
                              Navigator.pop(ctnx);
                              setState(() {});
                            },
                            child: Text(
                              Statics.getLabel('Submit'),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget mainContainer(String header, Widget child) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        // padding: EdgeInsets.all(10),
        decoration: BoxDecoration(border: Border.all(color: Colors.purpleAccent), borderRadius: BorderRadius.all(Radius.circular(10))),

        padding: EdgeInsets.symmetric(
          vertical: size.height * 0.01,
          horizontal: size.width * 0.03,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              header,
              style: TextStyle(
                color: Colors.purpleAccent,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            Divider(color: Colors.black87, thickness: 1),
            SizedBox(
              height: 10,
            ),
            // Container(margin: giveChildPadding ? EdgeInsets.symmetric(horizontal: size.width * 0.03) : null, child: child),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildExpansionPanel() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      margin: EdgeInsets.symmetric(horizontal: 20),
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
                  "${Statics.getLabel('vastiGramNivda')}",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              );
            },
            body: Container(
              margin: EdgeInsets.all(10),
              child: Column(
                children: [
                  if (_linkedMahaanagar != null)
                    _buildDropdownField(
                      label: Statics.getLabel('Mahaanagar'),
                      value: _linkedMahaanagarValue,
                      items: _linkedMahaanagar!
                          .map((bg) => DropdownMenuItem(
                                value: bg.geoUnitID.toString(),
                                child: Text(bg.name!),
                              ))
                          .toList(),
                      onChanged: (value) async {
                        final selectedItem = _linkedMahaanagar!.firstWhere((bg) => bg.geoUnitID.toString() == value);
                        setState(() {
                          _linkedMahaanagarValue = value;
                          _linkedVibhaagValue = null;
                          _selctedLevel = 'Mahanagar';
                          _selctedLevelName = selectedItem.name ?? "";
                          // _linkedMahaanagarName = selectedItem.name ?? "";
                          // _resetLinkedValues();
                        });
                        populatelinkedVibhaagDropdown(value!);
                        populatelinkedBhaagDropdown("");
                      },
                      isDisabled: false,
                    ),
                  if (_linkedVibhaag != null)
                    _buildDropdownField(
                      label: Statics.getLabel('Vibhaag'),
                      value: _linkedVibhaagValue,
                      items: _linkedVibhaag!
                          .map((bg) => DropdownMenuItem(
                                value: bg.geoUnitID.toString(),
                                child: Text(bg.name!),
                              ))
                          .toList(),
                      onChanged: (value) {
                        final selectedItem = _linkedVibhaag!.firstWhere((bg) => bg.geoUnitID.toString() == value);
                        setState(() {
                          _linkedVibhaagValue = value;
                          _selctedLevel = 'Vibhaag';
                          _selctedLevelName = selectedItem.name ?? "";
                          // _linkedVibhaagName = selectedItem.name ?? "";
                        });
                        populatelinkedBhaagDropdown(value!);
                      },
                      isDisabled: false,
                    ),
                  if (_linkedbhaag != null && _linkedbhaag!.isNotEmpty)
                    _buildDropdownField(
                      label: Statics.getLabel('Bhaag'),
                      value: _linkedbhaagValue,
                      items: _linkedbhaag!
                          .map((bg) => DropdownMenuItem(
                                value: bg.geoUnitID.toString(),
                                child: Text(bg.name!),
                              ))
                          .toList(),
                      onChanged: (value) {
                        final selectedItem = _linkedbhaag!.firstWhere((bg) => bg.geoUnitID.toString() == value);
                        setState(() {
                          _linkedbhaagValue = value;
                          _selctedLevel = 'Bhaag';
                          _selctedLevelName = selectedItem.name ?? "";
                          _linkedbhaagName = selectedItem.name ?? "";
                          populatelinkedShaharDropdown(value!);
                          populatelinkedNagarDropdown(value, null);
                        });
                      },
                      isDisabled: false,
                    ),
                  if (_linkedshahar != null && _linkedshahar!.isNotEmpty)
                    _buildDropdownField(
                      label: Statics.getLabel('Shahar'),
                      value: _linkedshaharValue,
                      items: _linkedshahar!
                          .map((bg) => DropdownMenuItem(
                                value: bg.geoUnitID.toString(),
                                child: Text(bg.name!),
                              ))
                          .toList(),
                      onChanged: (value) {
                        final selectedItem = _linkedshahar!.firstWhere((bg) => bg.geoUnitID.toString() == value);
                        setState(() {
                          _linkedshaharValue = value;
                          _selectedGeoUnitId = value.toString();
                          _selctedLevel = 'Shahar';
                          _selctedLevelName = selectedItem.name ?? "";
                          _linkedshaharName = selectedItem.name ?? "";
                          populatelinkedNagarDropdown(null, value);
                        });
                      },
                      isDisabled: false,
                    ),
                  if (_linkednagar != null && _linkednagar!.isNotEmpty)
                    _buildDropdownField(
                      label: Statics.getLabel('Nagar'),
                      value: _linkednagarValue,
                      items: _linkednagar!
                          .map((bg) => DropdownMenuItem(
                                value: bg.geoUnitID.toString(),
                                child: Text(bg.name!),
                              ))
                          .toList(),
                      onChanged: (value) {
                        final selectedItem = _linkednagar!.firstWhere((bg) => bg.geoUnitID.toString() == value);
                        setState(() {
                          _linkednagarValue = value;
                          _selectedGeoUnitId = value.toString();
                          _selctedLevel = 'Nagar';
                          _selctedLevelName = selectedItem.name ?? "";
                          _linkednagarName = selectedItem.name ?? "";
                          populatelinkedMandalDropdown(value);
                          populatelinkedVastiDropdown(value);
                        });
                      },
                      isDisabled: false,
                    ),
                  if (_linkedmandal != null && _linkedmandal!.isNotEmpty)
                    _buildDropdownField(
                      label: Statics.getLabel('Mandal'),
                      value: _linkedmandalValue,
                      items: _linkedmandal!
                          .map((bg) => DropdownMenuItem(
                                value: bg.geoUnitID.toString(),
                                child: Text(bg.name!),
                              ))
                          .toList(),
                      onChanged: (value) {
                        final selectedItem = _linkedmandal!.firstWhere((bg) => bg.geoUnitID.toString() == value);
                        setState(() {
                          _linkedmandalValue = value;
                          _selectedGeoUnitId = value.toString();
                          _selctedLevel = 'Mandal';
                          _selctedLevelName = selectedItem.name ?? "";
                          _linkedmandalName = selectedItem.name ?? "";
                          populatelinkedGraamDropdown(value);
                        });
                      },
                      isDisabled: false,
                    ),
                  if (_linkedgraam != null && _linkedgraam!.isNotEmpty)
                    _buildDropdownField(
                      label: Statics.getLabel('Graam'),
                      value: _linkedgraamValue,
                      items: _linkedgraam!
                          .map((bg) => DropdownMenuItem(
                                value: bg.geoUnitID.toString(),
                                child: Text(bg.name!),
                              ))
                          .toList(),
                      onChanged: (value) {
                        final selectedItem = _linkedgraam!.firstWhere((bg) => bg.geoUnitID.toString() == value);
                        setState(() {
                          _linkedgraamValue = value;
                          _selectedGeoUnitId = value.toString();
                          _selctedLevel = 'Graam';
                          _selctedLevelName = selectedItem.name ?? "";
                          _linkedgraamName = selectedItem.name ?? "";
                        });
                      },
                      isDisabled: false,
                    ),
                  if (_linkedvasti != null && _linkedvasti!.isNotEmpty)
                    _buildDropdownField(
                      label: Statics.getLabel('Vasti'),
                      value: _linkedvastiValue,
                      items: _linkedvasti!
                          .map((bg) => DropdownMenuItem(
                                value: bg.geoUnitID.toString(),
                                child: Text(bg.name!),
                              ))
                          .toList(),
                      onChanged: (value) {
                        final selectedItem = _linkedvasti!.firstWhere((bg) => bg.geoUnitID.toString() == value);
                        setState(() {
                          _linkedvastiValue = value;
                          _selectedGeoUnitId = value.toString();
                          _selctedLevel = 'Vasti';
                          _selctedLevelName = selectedItem.name ?? "";
                          _linkedvastiName = selectedItem.name ?? "";
                        });
                      },
                      isDisabled: false,
                    ),
                  SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if ((_linkedgraamValue != null && _linkedgraamValue!.isNotEmpty) || (_linkedvastiValue != null && _linkedvastiValue!.isNotEmpty))
                        MaterialButton(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                          padding: EdgeInsets.symmetric(
                            horizontal: 35,
                            vertical: 5,
                          ),
                          color: Theme.of(context).primaryColor,
                          textColor: Theme.of(context).primaryTextTheme.labelMedium?.color,
                          onPressed: () async {
                            _selctedLevelNameList = [];
                            setState(() {});
                            // _selctedLevelNameList.add(_linkedMahaanagarName);
                            // _selctedLevelNameList.add(_linkedVibhaagName);
                            _selctedLevelNameList.add(_linkedbhaagName);
                            _selctedLevelNameList.add(_linkedshaharName);
                            _selctedLevelNameList.add(_linkednagarName);
                            _selctedLevelNameList.add(_linkedmandalName);
                            _selctedLevelNameList.add(_linkedgraamName);
                            _selctedLevelNameList.add(_linkedvastiName);
                            setState(() {});

                            if (dateController.text.isEmpty) {
                              Statics.showToast(Statics.getLabel("selectDate"));
                              return;
                            }

                            data = await Statics.getSajjanAndAnyaGuestData(
                                context,
                                Statics.userDetails["userID"],
                                _linkedvastiValue != null && _linkedvastiValue!.isNotEmpty ? _linkedvastiValue! : _linkedgraamValue!,
                                _linkedvastiValue != null && _linkedvastiValue!.isNotEmpty ? "2" : "3");
                            setState(() {});
                            // if(Statics.userDetails[])
                            await _getSwList();

                            setState(() {
                              _selectedTolisIds = [];
                              _searched = true;
                              _isExpanded = false;
                            });
                          },
                          child: Text(
                            "${Statics.getLabel('search')}",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      MaterialButton(
                          onPressed: () async {
                            setState(() {
                              _searched = false;
                              _linkedMahaanagarValue = _linkedbhaagValue = _linkedshaharValue = _linkednagarValue = _linkedmandalValue = _linkedvastiValue = _linkedgraamValue = null;
                              _linkedVibhaagValue = _linkedbhaag = _linkedshahar = _linkedgraam = _linkedmandal = _linkedvasti = _linkednagar = null;
                              type = "praant";
                            });
                            await populateDropdown(isClear: true);
                          },
                          child: Text(Statics.getLabel('clear'))),
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
  }

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<DropdownMenuItem<String>> items,
    required ValueChanged<String?> onChanged,
    required bool isDisabled,
  }) {
    return IgnorePointer(
      ignoring: isDisabled,
      child: DropdownButtonFormField(
        decoration: InputDecoration(labelText: label),
        isExpanded: true,
        value: value == "" ? null : value,
        items: items,
        onChanged: onChanged,
      ),
    );
  }
}
