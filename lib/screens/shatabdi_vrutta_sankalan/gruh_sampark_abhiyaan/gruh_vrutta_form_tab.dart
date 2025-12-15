import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_expandable_table/flutter_expandable_table.dart';
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
  List<AbhiyaanPeopleModel> filteredAbhiyaanSwayamsevakDataList = [];
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

  // TextEditingController samparkitGhareController = TextEditingController();
  TextEditingController vitritKarpatrakController = TextEditingController();
  TextEditingController pustakVikriController = TextEditingController();

  // TextEditingController samparkaSahabhagiController = TextEditingController();
  // TextEditingController samparkaToliController = TextEditingController();

  TextEditingController _searchController = TextEditingController();

  List<String> strEmail = [];
  List<String> strMobile = [];

  String? _selctedLevel = 'praant';
  String? _selctedLevelName = '';
  List<String?> _selctedLevelNameList = [];
  String? _selectedGeoUnitId = '';

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
  bool _markAtt = false;
  int? createdUserId;
  String? type;

  List<Vastisanyaprabhavi> selectedAnyaprabhaviItems = [];
  List<Vastisarsajjanshakti> selectedSajjanshaktiItems = [];
  List<AbhiyaanPeopleModel> selectedVisitedSwayamsevak = [];

  List<int?> selectedUpnagarList = [];

  Vastisarsajjanshakti? selectedPerson;
  Vastisanyaprabhavi? selectedPrabhavi;

  AbhiyanSwayamsevakdata? initialData;

  GetVijayadashamiInitModel? data;

  VastiUpDataListModel? vastiUpDataListModel;

  bool get isAbhiyaanButPramukh {
    // final isEmptyFlag = Statics.abhiyaanUserDetails["isEmpty"] == true;

    final _isPramukh = (Statics.userDetails["DaayitvaName"] == "Vasti Pramukh" || Statics.userDetails["DaayitvaName"] == "वस्ती प्रमुख");

    return _isPramukh;
  }

  List<List<PreviousDay>> separatedLists = [];

  List<List<PreviousDay>> groupByUserID(List<PreviousDay> items) {
    final temp = <int, List<PreviousDay>>{};

    for (var item in items) {
      temp.putIfAbsent(item.createdUserID!, () => []);
      temp[item.createdUserID]!.add(item);
    }

    return temp.values.toList();
  }

  List<List<PreviousDay>> separatedPreviousLists = [];

  List<List<PreviousDay>> groupByGeoUnitID(List<PreviousDay> items) {
    final temp = <String, List<PreviousDay>>{};

    for (var item in items) {
      temp.putIfAbsent(item.geoUnitID.toString(), () => []);
      temp[item.geoUnitID.toString()]!.add(item);
    }

    return temp.values.toList();
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    log("initState runnn >>>>>>>>>>>>>> ");
    setDropDowns();
    // if (!isAbhiyaanButPramukh) WidgetsBinding.instance.addPostFrameCallback((_) => _getPreviousDayDataList());
  }

  @override
  void didUpdateWidget(covariant GruhVruttaTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    // if (widget.initialData != oldWidget.initialData && widget.initialData != null) {
    log("didUpdateWidget runnn >>>>>>>>>>>>>> ");
    setDropDowns();
    // }
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

  Future<void> _getPreviousDayDataList() async {
    print("calling _getPreviousDayDataList");
    setState(() {
      _isEditing = false;
      separatedPreviousLists = [];
      separatedLists = [];
    });
    bool isConnected = await Statics.isInternetConnected();
    if (isConnected) {
      var inputData = {
        "AppUserID": Statics.abhiyaanUserDetails["isEmpty"] ? Statics.userDetails["userID"] : Statics.abhiyaanUserDetails["AbhiyanSwayamsevakID"],
        "GeoUnitID": int.parse(_linkedvastiValue != null && _linkedvastiValue!.isNotEmpty ? _linkedvastiValue! : _linkedgraamValue!),
      };
      print(jsonEncode(inputData));
      print(Statics.userDetails["userID"]);
      print(Statics.abhiyaanUserDetails["AbhiyanSwayamsevakID"]);
      final _result = await Statics.getPreviousDataforGruhAbhiyaan(inputData, context: context);
      log(_result?.previousDayOther.toString() ?? "ascascasc");
      if (_result != null) {
        setState(() {
          separatedPreviousLists = groupByGeoUnitID(_result.previousDay ?? []);
          separatedLists = groupByUserID(_result.previousDayOther ?? []);
        });
      }
      log(separatedLists.toString());
    }
  }

  Future<void> _getSwList() async {
    print("calling");
    _isEditing = false;
    bool isConnected = await Statics.isInternetConnected();
    if (isConnected) {
      var inputData = {
        "AppUserID": Statics.abhiyaanUserDetails["isEmpty"] ? Statics.userDetails["userID"] : Statics.abhiyaanUserDetails["AbhiyanSwayamsevakID"],
        "GeoUnitID": int.parse(_linkedvastiValue != null && _linkedvastiValue!.isNotEmpty ? _linkedvastiValue! : _linkedgraamValue!),
        "AbhiyaanDate": DateFormat("dd-MM-yyyy").format(DateFormat("dd/MM/yyyy").parse(dateController.text)).toString(),
        "ispramukh": 0, // ? 1 : 0,
        "isswayamsevak": Statics.abhiyaanUserDetails["isEmpty"] ? 1 : 0,
      };
      log(jsonEncode(inputData));
      log(Statics.userDetails["userID"]);
      // log(Statics.abhiyaanUserDetails["AbhiyanSwayamsevakID"]);
      gruhAbhiyaanVruttaData = await Statics.getDataforGruhAbhiyaan(inputData, context: context);
      await _getPreviousDayDataList();
      setState(() {});
      if (gruhAbhiyaanVruttaData?.abhiyaandata != null) {
        // if (!isAbhiyaanButPramukh)
        setState(() {
          _isEditing = false;
          // samparkitGhareController.text = (gruhAbhiyaanVruttaData?.abhiyaandata?.samparkitghar ?? "").toString();
          vitritKarpatrakController.text = (gruhAbhiyaanVruttaData?.abhiyaandata?.vitaritkarpatra ?? "").toString();
          pustakVikriController.text = (gruhAbhiyaanVruttaData?.abhiyaandata?.pustakvikrisankhya ?? "").toString();
          // samparkaSahabhagiController.text = (gruhAbhiyaanVruttaData?.abhiyaandata?.samparkhetusahbhagisankhya ?? "").toString();
          // samparkaToliController.text = (gruhAbhiyaanVruttaData?.abhiyaandata?.samparkhetutolisankhya ?? "").toString();
        });
        abhiyaanSwayamsevakDataList = gruhAbhiyaanVruttaData?.swayamsevakList ?? [];
        filteredAbhiyaanSwayamsevakDataList = gruhAbhiyaanVruttaData?.swayamsevakList ?? [];
        abhiyaanKaryakartaDataList = gruhAbhiyaanVruttaData?.abhiyaanList ?? [];
        gruhAbhiyaanToliList = gruhAbhiyaanVruttaData?.abhiyanGruhToliList ?? [];
        pramukhList = gruhAbhiyaanVruttaData?.pramukhList ?? [];
        setState(() {});

        if (data != null) {
          setState(() {
            selectedSajjanshaktiItems = data!.vastisarsajjanshakti!.where((e) => gruhAbhiyaanVruttaData!.abhiyaandata!.visititAtithiSajjanShaktiids!.split(",").contains(e.pkid.toString())).toList();
            selectedAnyaprabhaviItems =
                data!.vastisanyaprabhavi!.where((e) => gruhAbhiyaanVruttaData!.abhiyaandata!.visititAtithiAnyaprabhaViLokamids!.split(",").contains(e.pkId.toString())).toList();
            if (data!.swayamsevaklistforgruh != null)
              selectedVisitedSwayamsevak = data!.swayamsevaklistforgruh!.where((e) => gruhAbhiyaanVruttaData!.abhiyaandata!.swayamsevakIds!.split(",").contains(e.swayamsevakID.toString())).toList();
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
            filteredAbhiyaanSwayamsevakDataList = _swayamsevakList;
          }
          if (_abhiyaanList != null && _abhiyaanList.isNotEmpty) {
            abhiyaanKaryakartaDataList = _abhiyaanList;
          }
          if (_gruhAbhiyaanToliList != null) {
            gruhAbhiyaanToliList = _gruhAbhiyaanToliList;
            // samparkaSahabhagiController.text = gruhAbhiyaanToliList.where((e) => e.isdefault == 1).length.toString();
            // samparkaToliController.text = gruhAbhiyaanToliList.length.toString();
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
          "GeoUnitID": int.parse(_selectedGeoUnitId!),
          "SamparkitGhar": 0, // int.tryParse(samparkitGhareController.text.isNotEmpty ? samparkitGhareController.text : "0"),
          "VitaritKarpatra": int.tryParse(vitritKarpatrakController.text.isNotEmpty ? vitritKarpatrakController.text : "0"),
          "PustakVikriSankhya": int.tryParse(pustakVikriController.text.isNotEmpty ? pustakVikriController.text : "0"),
          "SamparkhetuSahbhagiSankhya": 0, //int.tryParse(samparkaSahabhagiController.text.isNotEmpty ? samparkaSahabhagiController.text : "0"),
          "SamparkhetuToliSankhya": 0, //int.tryParse(samparkaToliController.text.isNotEmpty ? samparkaToliController.text : "0"),
          "swayamsevakIds": selectedVisitedSwayamsevak.map((e) => e.swayamsevakID).join(","), // comma-separated IDs
          "AppUserID": _isEditing
              ? createdUserId.toString()
              : Statics.abhiyaanUserDetails["isEmpty"]
                  ? Statics.userDetails["userID"]
                  : Statics.abhiyaanUserDetails["AbhiyanSwayamsevakID"],
          "ispramukh": 0, // ? 1 : 0,
          "isswayamsevak": Statics.abhiyaanUserDetails["isEmpty"] ? 1 : 0,
        };

        log(jsonEncode(_data));

        var result = await Statics.saveDataforGruhAbhiyaan(_data, context: context);
        if (result != null) {
          if (Statics.abhiyaanUserDetails["isEmpty"] && !_isEditing) {
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
            _isEditingForPramukh = false;
            // dateController.text = DateFormat("dd/MM/yyyy").format(DateTime.now());
            // samparkitGhareController.clear();
            vitritKarpatrakController.clear();
            pustakVikriController.clear();
            createdUserId = null;
            selectedSajjanshaktiItems = [];
          });
          await _getSwList();
          // await Future.wait(<Future>[_getSwList(), _getPreviousDayDataList()]);
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

  saveVisheshVyaktiFun({bool refresh = false}) async {
    try {
      bool isConnected = await Statics.isInternetConnected();
      if (isConnected) {
        var _data = {
          "AbhiyaanDate": DateFormat("dd-MM-yyyy").format(DateFormat("dd/MM/yyyy").parse(dateController.text)).toString(), // e.g. "22-10-2025"
          "GeoUnitID": int.parse(_selectedGeoUnitId!),
          "VisititAtithiSajjanShaktiIDs": selectedSajjanshaktiItems.map((e) => e.pkid).join(","), // comma-separated IDs
          "VisititAtithiAnyaPrabhaviLokamIDs": selectedAnyaprabhaviItems.map((e) => e.pkId).join(","), // comma-separated IDs
          "AppUserID": _isEditing
              ? createdUserId.toString()
              : Statics.abhiyaanUserDetails["isEmpty"]
                  ? Statics.userDetails["userID"]
                  : Statics.abhiyaanUserDetails["AbhiyanSwayamsevakID"],
          "ispramukh": 0, // ? 1 : 0,
          "isswayamsevak": Statics.abhiyaanUserDetails["isEmpty"] ? 1 : 0,
        };

        log(jsonEncode(_data));

        var result = await Statics.saveVisheshVyaktiDataforGruhAbhiyaan(_data, context: context);
        if (result != null && result) {
          setState(() {
            _isEditing = false;
            _isEditingForPramukh = false;
            // dateController.text = DateFormat("dd/MM/yyyy").format(DateTime.now());
            // samparkitGhareController.clear();
            vitritKarpatrakController.clear();
            pustakVikriController.clear();
            createdUserId = null;
            selectedSajjanshaktiItems = [];
          });
          if (refresh) await _getSwList();
          // await Future.wait(<Future>[_getSwList(), _getPreviousDayDataList()]);
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

  Future<void> populateDropdownForEdit(_geounitid, _levelid, _parentMahaanagarID, _parentVibhaagID, _parentBhaagID, _parentNagarID, _parentMandalID, {bool isClear = false}) async {
    // setState(() {
    //   _isExpanded = false;
    //   _linkedMahaanagarValue = _linkedbhaagValue = _linkedshaharValue = _linkednagarValue = _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = null;
    // });
    _selctedLevelNameList = [];
    await populatelinkedMahaanagarDropdown();
    await populatelinkedVibhaagDropdown('');
    if (isClear) return;
    if (_geounitid != null && _geounitid != 0) {
      if (_parentMahaanagarID != null && _parentMahaanagarID != 0) {
        setState(() {
          _isExpanded = true;
          _linkedMahaanagarDisable = true;
          _linkedMahaanagarValue = _parentMahaanagarID.toString();
          _selectedGeoUnitId = (_parentMahaanagarID ?? _geounitid).toString();
        });
      }
      await populatelinkedVibhaagDropdown('');

      if (_parentVibhaagID != null && _parentVibhaagID != 0) {
        await populatelinkedBhaagDropdown(_parentVibhaagID.toString());
        setState(() {
          _isExpanded = true;
          _linkedVibhaagDisable = true;
          _linkedVibhaagValue = _parentVibhaagID.toString();
          _selectedGeoUnitId = (_parentVibhaagID ?? _geounitid).toString();
        });
      }
      if (_parentBhaagID != null && _parentBhaagID != 0) {
        await populatelinkedNagarDropdown(_parentBhaagID.toString(), null);

        GeoUnitMasterBAL? selectedItem;
        if (_linkedbhaag != null && _linkedbhaag!.isNotEmpty) selectedItem = _linkedbhaag!.firstWhere((bg) => bg.geoUnitID.toString() == (_parentBhaagID ?? _geounitid).toString());

        setState(() {
          _isExpanded = true;
          _linkedbhaagDisable = true;
          _linkedbhaagValue = _parentBhaagID.toString();
          _selectedGeoUnitId = (_parentBhaagID ?? _geounitid).toString();
          _linkedbhaagName = selectedItem?.name ?? "";
        });
      }
      if (_parentNagarID != null && _parentNagarID != 0) {
        await populatelinkedMandalDropdown(_parentNagarID.toString());
        await populatelinkedVastiDropdown(_parentNagarID.toString());

        GeoUnitMasterBAL? selectedItem;
        if (_linkednagar != null && _linkednagar!.isNotEmpty) selectedItem = _linkednagar!.firstWhere((bg) => bg.geoUnitID.toString() == (_parentNagarID ?? _geounitid).toString());

        setState(() {
          _isExpanded = true;
          _linkednagarDisable = true;
          _linkednagarValue = _parentNagarID.toString();
          _selectedGeoUnitId = (_parentNagarID ?? _geounitid).toString();
          _linkednagarName = selectedItem?.name ?? "";
        });
      }
      setState(() {
        if (_parentMandalID != null && _parentMandalID != 0) {
          _isExpanded = true;
          _linkedmandalDisable = true;
          _linkedmandalValue = _parentMandalID.toString();
          _selectedGeoUnitId = (_parentMandalID ?? _geounitid).toString();

          GeoUnitMasterBAL? selectedItem;
          if (_linkedmandal != null && _linkedmandal!.isNotEmpty) selectedItem = _linkedmandal!.firstWhere((bg) => bg.geoUnitID.toString() == (_parentMandalID ?? _geounitid).toString());

          _linkedmandalName = selectedItem?.name ?? "";
          populatelinkedGraamDropdown(_parentMandalID.toString());
        }
        if (_levelid == 2 && _geounitid != 0) {
          _isExpanded = true;
          _linkedvastiDisable = true;
          _linkedvastiValue = _geounitid.toString();
          _selectedGeoUnitId = _geounitid.toString();

          GeoUnitMasterBAL? selectedItem;
          if (_linkedvasti != null && _linkedvasti!.isNotEmpty) selectedItem = _linkedvasti!.firstWhere((bg) => bg.geoUnitID.toString() == _geounitid.toString());

          _linkedvastiName = selectedItem?.name ?? "";
        } else if (_levelid == 3 && _geounitid != 0) {
          _isExpanded = true;
          _linkedgraamDisable = true;
          _linkedgraamValue = _geounitid.toString();
          _selectedGeoUnitId = _geounitid.toString();

          GeoUnitMasterBAL? selectedItem;
          if (_linkedgraam != null && _linkedgraam!.isNotEmpty) selectedItem = _linkedgraam!.firstWhere((bg) => bg.geoUnitID.toString() == _geounitid.toString());

          _linkedgraamName = selectedItem?.name ?? "";
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

  Future<void> populateDropdown() async {
    setState(() {
      _isExpanded = true;
      _selctedLevelNameList = [];
      _linkedMahaanagarValue = _linkedbhaagValue = _linkedshaharValue = _linkednagarValue = _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = null;
    });
    await populatelinkedMahaanagarDropdown();
    await populatelinkedVibhaagDropdown('');
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedMahaanagarDropdown() async {
    _linkedVibhaagValue = _linkedbhaagValue = _linkednagarValue = _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = null;
    List<GeoUnitMasterBAL> data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['MahaanagarLevelID'].toString(), '', '', '', isAbhiyaan: true);
    setState(() {
      _linkedMahaanagar = data;
    });
    return data;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedVibhaagDropdown(String mahaanagarIDStr) async {
    _linkedbhaagValue = _linkednagarValue = _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = null;
    _linkedbhaagName = _linkednagarName = _linkedmandalName = _linkedgraamName = _linkedvastiName = null;
    print("populatelinkedVibhaagDropdown $mahaanagarIDStr");
    var data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['VibhaagLevelID'].toString(), mahaanagarIDStr, (mahaanagarIDStr.isEmpty ? '' : 'Mahaanagar'), '', isAbhiyaan: true);
    setState(() {
      _linkedVibhaag = data;
    });
    return data;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedBhaagDropdown(String vibhaagIDStr) async {
    _linkedbhaagValue = _linkednagarValue = _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = null;
    _linkedbhaagName = _linkednagarName = _linkedmandalName = _linkedgraamName = _linkedvastiName = null;
    _linkedbhaag = _linkednagar = _linkedmandal = _linkedgraam = _linkedvasti = [];
    var data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['BhaagLevelID'].toString(), vibhaagIDStr, 'Vibhaag', '', isAbhiyaan: true);
    setState(() {
      _linkedbhaag = data;
    });
    return data;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedShaharDropdown(String bhaagIDStr) async {
    _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = null;
    _linkedmandalName = _linkedgraamName = _linkedvastiName = null;
    var shDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['ShaharLevelID'].toString(), bhaagIDStr, 'Bhaag', '', isAbhiyaan: true);
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
      var ngDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['NagarLevelID'].toString(), shaharIDStr!, 'Shahar', '', isAbhiyaan: true);
      setState(() {
        _linkednagar = (ngDD.length > 0 ? ngDD : null);
      });
      return ngDD;
    } else {
      var ngDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['NagarLevelID'].toString(), bhaagIDStr!, 'Bhaag', '', isAbhiyaan: true);
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
    var mnDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['MandalLevelID'].toString(), nagarIDStr!, 'Nagar', '', isAbhiyaan: true);
    setState(() {
      _linkedmandal = (mnDD.length > 0 ? mnDD : null);
    });
    return mnDD;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedGraamDropdown(String? mandalIDStr) async {
    _linkedgraamValue = null;
    _linkedgraamName = null;
    var gmDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['GraamLevelID'].toString(), mandalIDStr!, 'Mandal', '', isAbhiyaan: true);
    setState(() {
      _linkedgraam = (gmDD.length > 0 ? gmDD : null);
    });
    return gmDD;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedVastiDropdown(String? nagarIDStr) async {
    _linkedvastiValue = null;
    _linkedvastiName = null;
    var vsDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['VastiLevelID'].toString(), nagarIDStr!, 'Nagar', '', isAbhiyaan: true);
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
                          _searchController.clear();
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
                  SizedBox(height: 8),
                  if (_selectedSwayamsevakIds.isNotEmpty || _selectedKaryakartaIds.isNotEmpty)
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
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(right: 8, left: 8, bottom: 8),
                  child: TextField(
                    controller: _searchController,
                    style: TextStyle(fontSize: 16),
                    autofocus: false,
                    onChanged: (v) {
                      if (v.isEmpty) {
                        filteredAbhiyaanSwayamsevakDataList = abhiyaanSwayamsevakDataList;
                      } else {
                        filteredAbhiyaanSwayamsevakDataList = abhiyaanSwayamsevakDataList
                            .where(
                              (e) => e.fullName.toString().toLowerCase().contains(v.toLowerCase()) || e.mobileno.toString().contains(v),
                            )
                            .toList();
                      }
                      set(() {});
                    },
                    // inputFormatters: [LengthLimitingTextInputFormatter(10), FilteringTextInputFormatter.digitsOnly],
                    // keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      isDense: true,
                      prefixIcon: Icon(Icons.search),
                      hintText: "नाव किंवा नंबरने शोधा",
                      contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                      // suffixIcon: InkWell(
                      //   onTap: () async {
                      //     FocusScope.of(context).unfocus();
                      //     if (_searchController.text.length < 10) {
                      //       Statics.showToast(Statics.getLabel('MobileValidationMessage'));
                      //       return null;
                      //     }
                      //     await _search("Search");
                      //     setState(() {});
                      //   },
                      //   borderRadius: BorderRadius.circular(30),
                      //   child: Icon(
                      //     Icons.search,
                      //     size: 25,
                      //   ),
                      // ),
                      border: OutlineInputBorder(borderSide: BorderSide(width: 0.7, color: Colors.grey.shade700), borderRadius: BorderRadius.circular(5)),
                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.7, color: Colors.grey.shade700), borderRadius: BorderRadius.circular(5)),
                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.7, color: Colors.grey.shade700), borderRadius: BorderRadius.circular(5)),
                    ),
                  ),
                ),
                Flexible(
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
                            rows: filteredAbhiyaanSwayamsevakDataList.asMap().entries.map((entry) {
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
              ],
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

  /////////////////////////////////////////// Form 1 /////////////////////////////////////////////
  showGruhAbhiyaanForm1() {
    return showDialog(
      context: context,
      useSafeArea: true,
      builder: (ct) => StatefulBuilder(
        builder: (ctx, set) => Dialog(
          surfaceTintColor: Colors.transparent,
          backgroundColor: Colors.white,
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          insetPadding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              children: [
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
                        "वृत्त भरणे",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () => Navigator.pop(ct),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 12),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Expanded(
                              flex: 4,
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
                              flex: 3,
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
                                        _isEditingForPramukh = false;
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
                      // customTextFields(title: "संपर्कित घरे : ", controller: samparkitGhareController),
                      customTextFields(title: Statics.getLabel("gruhVitaritKarpatra") + ": ", controller: vitritKarpatrakController),
                      customTextFields(title: Statics.getLabel("gruhPustakVikti") + ": ", controller: pustakVikriController),
                      // customTextFields(title: "सहभागी कार्यकर्ते संख्या" + ": ", controller: samparkaSahabhagiController), //,gruhAbhiyaanVruttaData!.abhiyaandata!.ishide),
                      // customTextFields(title: "संपर्क हेतू टोळी संख्या : ", controller: samparkaToliController), //,gruhAbhiyaanVruttaData!.abhiyaandata!.ishide),
                      // SizedBox(height: 10),
                      SizedBox(height: 21),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // if (!isAbhiyaanButPramukh || _isEditing)
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
                              // if (dateController.text.isEmpty || samparkitGhareController.text.isEmpty || vitritKarpatrakController.text.isEmpty || pustakVikriController.text.isEmpty) {
                              if (dateController.text.isEmpty || vitritKarpatrakController.text.isEmpty || pustakVikriController.text.isEmpty) {
                                Statics.showToast(Statics.getLabel("impInfoRequired"));
                                return null;
                                // } else if (!(abhiyaanSwayamsevakDataList.any((e) => e.isSelected))) {
                                //   print("स्तराचे नाव निवडा");
                                //   Statics.showToast("किमान एक अभियान कार्यकर्ता जोडावे");
                                //   return null;
                              } else {
                                print("saving data");
                                await saveGruhAbhiyaanDataFun();
                                Navigator.pop(ct);
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
                                  _isEditingForPramukh = false;
                                  dateController.text = DateFormat("dd/MM/yyyy").format(DateTime.now());
                                  // samparkitGhareController.clear();
                                  vitritKarpatrakController.clear();
                                  pustakVikriController.clear();
                                  createdUserId = null;
                                  selectedSajjanshaktiItems = [];
                                  selectedAnyaprabhaviItems = [];
                                  selectedVisitedSwayamsevak = [];
                                  _selctedLevelNameList = [];
                                });
                                Navigator.pop(ct);
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
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /////////////////////////////////////////// Form 2 /////////////////////////////////////////////
  showGruhAbhiyaanForm2() {
    final _swayamsevakListGruh = data?.swayamsevaklistforgruh ?? [];
    log(_swayamsevakListGruh.length.toString());
    return showDialog(
      context: context,
      useSafeArea: true,
      builder: (ct) => StatefulBuilder(
        builder: (ctx, set) => Dialog(
          surfaceTintColor: Colors.transparent,
          backgroundColor: Colors.white,
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          insetPadding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
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
                      Statics.getLabel("AddNewSwayamsevak"),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.pop(ct),
                    ),
                  ],
                ),
              ),
              Container(
                constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * 0.3),
                padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black12),
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                ),
                child: SingleChildScrollView(
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
                      ..._swayamsevakListGruh.map((item) {
                        return TableRow(
                          children: [
                            Center(
                                child: Checkbox(
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              value: selectedVisitedSwayamsevak.any((x) => x.swayamsevakID == item.swayamsevakID),
                              onChanged: (val) {
                                set(() {
                                  if (val == true) {
                                    selectedVisitedSwayamsevak.add(item);
                                  } else {
                                    selectedVisitedSwayamsevak.removeWhere((x) => x.swayamsevakID == item.swayamsevakID);
                                  }
                                });
                                final _selectedswayamsevakIds = selectedVisitedSwayamsevak.map((e) => e.swayamsevakID.toString()).join(",");
                                // String anyaIds = selectedAnyaprabhavi.map((e) => e.pkId.toString()).join(",");
                                log(_selectedswayamsevakIds.toString());
                                log("-----------------------------");
                                // log(anyaIds);

                                // onSubmit(sajIds, anyaIds, selectedSajjanshakti, selectedAnyaprabhavi);
                                set(() {});
                              },
                            )),
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: Text(item.fullName ?? "Unknown"),
                            ),
                          ],
                        );
                      }),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 21),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // if (!isAbhiyaanButPramukh || _isEditing)
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
                      // if (dateController.text.isEmpty || samparkitGhareController.text.isEmpty || vitritKarpatrakController.text.isEmpty || pustakVikriController.text.isEmpty) {
                      if (dateController.text.isEmpty || vitritKarpatrakController.text.isEmpty || pustakVikriController.text.isEmpty) {
                        Statics.showToast("अधि वृत्त जोडावे");
                        // Statics.showToast(Statics.getLabel("impInfoRequired"));
                        return null;
                      } else if (selectedVisitedSwayamsevak.isEmpty) {
                        print("स्तराचे नाव निवडा");
                        Statics.showToast("किमान एक स्वयंसेवक जोडावे");
                        return null;
                      } else {
                        print("saving data");
                        await saveGruhAbhiyaanDataFun();
                        Navigator.pop(ct);
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
                          _isEditingForPramukh = false;
                          dateController.text = DateFormat("dd/MM/yyyy").format(DateTime.now());
                          // samparkitGhareController.clear();
                          vitritKarpatrakController.clear();
                          pustakVikriController.clear();
                          createdUserId = null;
                          selectedSajjanshaktiItems = [];
                          selectedAnyaprabhaviItems = [];
                          selectedVisitedSwayamsevak = [];
                        });
                        Navigator.pop(ct);
                        await _getSwList();
                        // await populateDropdown(isClear: true);
                      },
                      child: Text(
                        Statics.getLabel('clear'),
                      ),
                    ),
                ],
              ),
              SizedBox(height: 21),
            ],
          ),
        ),
      ),
    );
  }

  /////////////////////////////////////////// Form 3 /////////////////////////////////////////////
  showEditableGruhAbhiyaanForm() {
    print("showEditableGruhAbhiyaanForm onTap >>>>>>>>>>>>>>> ");
    final _sarsajjanshaktiList = data?.vastisarsajjanshakti ?? [];
    final _sanyaprabhaviList = data?.vastisanyaprabhavi ?? [];

    return showDialog(
      context: context,
      useSafeArea: true,
      builder: (ct) => StatefulBuilder(
        builder: (ctx, set) => Dialog(
          surfaceTintColor: Colors.transparent,
          backgroundColor: Colors.white,
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          insetPadding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
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
                        Statics.getLabel("AddSwayamsevak"),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () => Navigator.pop(ct),
                      ),
                    ],
                  ),
                ),

                //
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // customTextFields(title: "संपर्कित घरे : ", controller: samparkitGhareController, readOnly: isAbhiyaanButPramukh && !_isEditing),
                      customTextFields(title: Statics.getLabel("gruhVitaritKarpatra") + ": ", controller: vitritKarpatrakController, readOnly: isAbhiyaanButPramukh && !_isEditing),
                      customTextFields(title: Statics.getLabel("gruhPustakVikti") + ": ", controller: pustakVikriController, readOnly: isAbhiyaanButPramukh && !_isEditing),
                      // customTextFields(title: "सहभागी कार्यकर्ते संख्या" + ": ", controller: samparkaSahabhagiController), //,gruhAbhiyaanVruttaData!.abhiyaandata!.ishide),
                      // customTextFields(title: "संपर्क हेतू टोळी संख्या : ", controller: samparkaToliController), //,gruhAbhiyaanVruttaData!.abhiyaandata!.ishide),
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
                      Flexible(
                        child: Container(
                          constraints: BoxConstraints(maxHeight: 200),
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
                      Flexible(
                        child: Container(
                          constraints: BoxConstraints(maxHeight: 200),
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
                      ),
                      SizedBox(height: 21),
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
                                // if (dateController.text.isEmpty || samparkitGhareController.text.isEmpty || vitritKarpatrakController.text.isEmpty || pustakVikriController.text.isEmpty) {
                                if (dateController.text.isEmpty || vitritKarpatrakController.text.isEmpty || pustakVikriController.text.isEmpty) {
                                  Statics.showToast(Statics.getLabel("impInfoRequired"));
                                  return null;
                                  // } else if (selectedSajjanshaktiItems.isEmpty || selectedAnyaprabhaviItems.isEmpty) {
                                  //   print("किमान एक विशेष व्यक्ती जोडावे");
                                  //   Statics.showToast("किमान एक विशेष व्यक्ती जोडावे");
                                  //   return null;
                                } else {
                                  print("saving data");
                                  await saveVisheshVyaktiFun();
                                  await saveGruhAbhiyaanDataFun();
                                  Navigator.pop(ct);
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
                                  _isEditingForPramukh = false;
                                  dateController.text = DateFormat("dd/MM/yyyy").format(DateTime.now());
                                  // samparkitGhareController.clear();
                                  vitritKarpatrakController.clear();
                                  pustakVikriController.clear();
                                  createdUserId = null;
                                  selectedSajjanshaktiItems = [];
                                  selectedAnyaprabhaviItems = [];
                                  selectedVisitedSwayamsevak = [];
                                  _selctedLevelNameList = [];
                                });
                                Navigator.pop(ct);
                                await _getSwList();
                                // await populateDropdown(isClear: true);
                              },
                              child: Text(
                                Statics.getLabel('clear'),
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: 21),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /////////////////////////////////////////// Form 3 /////////////////////////////////////////////

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
              SizedBox(height: 32),
              if (_searched) ...[
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
                SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "${Statics.getLabel('vastiPramukhName')}",
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 15),
                  ),
                ),
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
                    ],
                  ),
                ),

                SizedBox(height: MediaQuery.of(context).size.height * 0.03),

                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.purpleAccent, width: 1),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
                  margin: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: Column(
                    spacing: 12,
                    children: [
                      InkWell(
                        borderRadius: BorderRadius.circular(15),
                        onTap: showGruhAbhiyaanForm1,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
                          // width: 150,
                          height: 35,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.purpleAccent.shade100),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Center(
                            child: Text(
                              "${Statics.getLabel('fillVrutta')}",
                              style: TextStyle(
                                color: Colors.purpleAccent,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        borderRadius: BorderRadius.circular(15),
                        onTap: () => Navigator.of(context).pushNamed(EditSwayamsevakScreen.routeName, arguments: Statics.ScreenArgumentsNew(0, Statics.getLabel('EditMenu'))).then((value) async {
                          data = await Statics.getSajjanAndAnyaGuestData(
                              context,
                              Statics.userDetails["userID"],
                              _linkedvastiValue != null && _linkedvastiValue!.isNotEmpty ? _linkedvastiValue! : _linkedgraamValue!,
                              _linkedvastiValue != null && _linkedvastiValue!.isNotEmpty ? "2" : "3");
                          setState(() {});
                          // if(Statics.userDetails[])
                          await _getSwList();
                        }),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
                          // width: 150,
                          height: 35,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.purpleAccent.shade100),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Center(
                            child: Text(
                              "${Statics.getLabel('AddNewSwayamsevak')}",
                              style: TextStyle(
                                color: Colors.purpleAccent,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        borderRadius: BorderRadius.circular(15),
                        onTap: () async {
                          if (_isEditing) {
                            data = await Statics.getSajjanAndAnyaGuestData(
                                context,
                                Statics.userDetails["userID"],
                                _linkedvastiValue != null && _linkedvastiValue!.isNotEmpty ? _linkedvastiValue! : _linkedgraamValue!,
                                _linkedvastiValue != null && _linkedvastiValue!.isNotEmpty ? "2" : "3");
                          }
                          setState(() {});
                          await showVisheshAtithiSelectionPopup(
                            context,
                            onAdd: () async {
                              await saveVisheshVyaktiFun();
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
                          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
                          // width: 150,
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
                    ],
                  ),
                ),
                SizedBox(height: 24),
//
//                 Divider(height: 70, thickness: 2, color: Colors.grey.shade700),
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
                SizedBox(height: 40),
                otherDaysExpandableTable(),
                SizedBox(height: MediaQuery.sizeOf(context).height * 0.2),
              ]
            ],
          ),
        ),
      ),
    );
  }

  // UI Helper for Header Cells
  ExpandableTableCell _buildHeaderCell(String text) {
    return ExpandableTableCell(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(color: Colors.purple.shade100, border: Border.all(color: Colors.grey.shade700, width: 0.7)),
        alignment: Alignment.center,
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  // UI Helper for Body Cells
  ExpandableTableCell _buildCell(String text, {Color? color, bool showBorder = true, Widget? child, FontWeight? fontWeight}) {
    return ExpandableTableCell(
      builder: (context, details) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        decoration: BoxDecoration(color: color ?? Colors.white, border: showBorder ? Border.all(color: Colors.grey.shade700, width: 0.7) : null),
        alignment: child != null ? null : Alignment.center,
        child: child ??
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (details.row?.children != null)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: AnimatedRotation(
                      duration: const Duration(milliseconds: 500),
                      turns: details.row?.childrenExpanded == true ? 0.25 : 0,
                      child: const Icon(
                        Icons.keyboard_arrow_right,
                        color: Colors.black,
                      ),
                    ),
                  ),
                Expanded(
                  child: Text(
                    text,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: fontWeight ?? FontWeight.w600),
                  ),
                ),
              ],
            ),
      ),
    );
  }

  Widget otherDaysExpandableTable() {
    final List<String> _headers = [
      // 'कार्यक्रम स्तर',
      // Statics.getLabel('gruhSamarkitGhar'),
      Statics.getLabel('gruhVitaritKarpatra'),
      Statics.getLabel('gruhPustakVikti'),
      Statics.getLabel('gruhSpecialContact'),
      "",
    ];
    final List<String> _headersOthers = [
      // 'कार्यक्रम स्तर',
      // Statics.getLabel('gruhSamarkitGhar'),
      Statics.getLabel('gruhVitaritKarpatra'),
      Statics.getLabel('gruhPustakVikti'),
      Statics.getLabel('gruhSpecialContact'),
      if (isAbhiyaanButPramukh) "",
    ];
    // if (separatedPreviousLists.isEmpty) return SizedBox();

    // final _totalSampark = separatedPreviousLists.expand((inner) => inner).fold(0.0, (prev, item) => prev + (item.samparkitghar ?? 0)).toInt();
    final _totalVitarit = separatedPreviousLists.expand((inner) => inner).fold(0.0, (prev, item) => prev + (item.vitaritkarpatra ?? 0)).toInt();
    final _totalPustak = separatedPreviousLists.expand((inner) => inner).fold(0.0, (prev, item) => prev + (item.pustakvikrisankhya ?? 0)).toInt();
    final _totalSpecial = separatedPreviousLists.expand((inner) => inner).fold(0.0, (prev, item) => prev + (item.totalAtithiCount ?? 0)).toInt();

    // final _totalOthersSampark = separatedLists.expand((inner) => inner).fold(0.0, (prev, item) => prev + (item.samparkitghar ?? 0)).toInt();
    final _totalOthersVitarit = separatedLists.expand((inner) => inner).fold(0.0, (prev, item) => prev + (item.vitaritkarpatra ?? 0)).toInt();
    final _totalOthersPustak = separatedLists.expand((inner) => inner).fold(0.0, (prev, item) => prev + (item.pustakvikrisankhya ?? 0)).toInt();
    final _totalOthersSpecial = separatedLists.expand((inner) => inner).fold(0.0, (prev, item) => prev + (item.totalAtithiCount ?? 0)).toInt();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (separatedPreviousLists.isNotEmpty) ...[
            Text("${Statics.getLabel("yoursPreviousDaysData")} :", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Container(
              constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * 0.7),
              // padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ExpandableTable(
                expanded: false,
                thumbVisibilityScrollbar: true,
                visibleScrollbar: true,
                // --- Dimensions ---
                firstColumnWidth: 140,
                headerHeight: 50,
                // rowsCount: totalRows,

                // --- Header ---
                firstHeaderCell: _buildHeaderCell(Statics.getLabel('LevelName')),
                headers: _headers.map((e) => ExpandableTableHeader(cell: _buildHeaderCell(e))).toList(),

                // --- Body Rows ---
                rows: separatedPreviousLists.map(
                      (group) {
                        // group is List<PreviousDayModel> for one CreatedUserID
                        final _first = group.first;
                        final _geoUnitName = (isAbhiyaanButPramukh ? _first.participantName : _first.geoUnitName) ?? '--';

                        // compute totals for this group
                        final totalSampark = group.fold<int>(0, (s, e) => s + (e.samparkitghar ?? 0));
                        final totalVitarit = group.fold<int>(0, (s, e) => s + (e.vitaritkarpatra ?? 0));
                        final totalPustak = group.fold<int>(0, (s, e) => s + (e.pustakvikrisankhya ?? 0));
                        final totalSpecial = group.fold<int>(0, (s, e) => s + (e.totalAtithiCount ?? 0));

                        // return group.length > 1
                        //     ?
                        return ExpandableTableRow(
                          height: 50,

                          // childrenExpanded: true,
                          legend: Container(
                            decoration: BoxDecoration(color: Colors.red.shade100),
                            child: Text(
                              "",
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                          firstCell: _buildCell(_geoUnitName, color: Colors.red.shade100),
                          children: group
                              .map((item) => ExpandableTableRow(
                                    height: 50,
                                    firstCell: _buildCell(item.abhiyaanDate.toString()),
                                    cells: [
                                      // _buildCell(item.samparkitghar.toString()),
                                      _buildCell(item.vitaritkarpatra.toString()),
                                      _buildCell(item.pustakvikrisankhya.toString()),
                                      _buildCell(item.totalAtithiCount.toString()),
                                      _buildCell("",
                                          child: Container(
                                            constraints: BoxConstraints(maxWidth: 30),
                                            child: InkWell(
                                                // onTap: () {
                                                //   Statics.showToast(Statics.getLabel("workInProgress"));
                                                // },
                                                onTap: () async {
                                                  log(jsonEncode(item));
                                                  _selctedLevelNameList = [];
                                                  await Future.delayed(
                                                      Duration(milliseconds: 100),
                                                      () => setState(() {
                                                            dateController.text = DateFormat("dd/MM/yyyy").format(DateFormat("dd-MM-yyyy").parse(item.abhiyaanDate.toString()));
                                                            // samparkitGhareController.text = item.samparkitghar.toString();
                                                            vitritKarpatrakController.text = item.vitaritkarpatra.toString();
                                                            pustakVikriController.text = item.pustakvikrisankhya.toString();
                                                            createdUserId = item.createdUserID;

                                                            // if (item.createdUserID == Statics.abhiyaanUserDetails["AbhiyanSwayamsevakID"] && isAbhiyaanButPramukh)
                                                            //   samparkaSahabhagiController.text = item.samparkhetusahbhagisankhya.toString();
                                                            // if (item.createdUserID == Statics.abhiyaanUserDetails["AbhiyanSwayamsevakID"] && isAbhiyaanButPramukh)
                                                            //   samparkaToliController.text = item.samparkhetutolisankhya.toString();
                                                          }));
                                                  if (!isAbhiyaanButPramukh) {
                                                    await populateDropdownForEdit(
                                                      item.geoUnitID,
                                                      item.levelID,
                                                      item.parentMahaanagarID,
                                                      item.parentVibhaagID,
                                                      item.parentBhaagID,
                                                      item.parentNagarID,
                                                      item.parentMandalID,
                                                    );
                                                  } else {
                                                    setState(() {
                                                      _selectedGeoUnitId = item.geoUnitID.toString();
                                                    });
                                                  }

                                                  // if ((item.visititAtithiSajjanShaktiids != null && item.visititAtithiSajjanShaktiids!.isNotEmpty) ||
                                                  //     (item.visititAtithiAnyaprabhaViLokamids != null && item.visititAtithiAnyaprabhaViLokamids!.isNotEmpty)) {
                                                  data = await Statics.getSajjanAndAnyaGuestData(context, Statics.userDetails["userID"], item.geoUnitID.toString(),
                                                      item.parentMandalID != null && item.parentMandalID.toString().isNotEmpty ? "3" : "2");
                                                  // }
                                                  setState(() {
                                                    _isExpanded = false;
                                                    _selctedLevelNameList.add(_linkedbhaagName);
                                                    _selctedLevelNameList.add(_linkedshaharName);
                                                    _selctedLevelNameList.add(_linkednagarName);
                                                    _selctedLevelNameList.add(_linkedmandalName);
                                                    _selctedLevelNameList.add(_linkedgraamName);
                                                    _selctedLevelNameList.add(_linkedvastiName);
                                                  });
                                                  setState(() {
                                                    if (data != null) {
                                                      // setState(() {
                                                      selectedSajjanshaktiItems =
                                                          data!.vastisarsajjanshakti!.where((e) => item.visititAtithiSajjanShaktiids!.split(",").contains(e.pkid.toString())).toList();
                                                      selectedAnyaprabhaviItems =
                                                          data!.vastisanyaprabhavi!.where((e) => item.visititAtithiAnyaprabhaViLokamids!.split(",").contains(e.pkId.toString())).toList();
                                                      // if (data!.swayamsevaklistforgruh != null)
                                                      //   selectedVisitedSwayamsevak =
                                                      //       data!.swayamsevaklistforgruh!.where((e) => item.swayamsevakIds!.split(",").contains(e.swayamsevakID.toString())).toList();
                                                      // });
                                                    }
                                                  });
                                                  // await _scrollController.animateTo(
                                                  //   0,
                                                  //   duration: const Duration(milliseconds: 600),
                                                  //   curve: Curves.easeInOutSine,
                                                  // );
                                                  setState(() {
                                                    _isEditing = true;
                                                    _searched = true;
                                                    if (item.createdUserID == Statics.abhiyaanUserDetails["AbhiyanSwayamsevakID"] && isAbhiyaanButPramukh) _isEditingForPramukh = true;
                                                  });

                                                  showEditableGruhAbhiyaanForm();
                                                },
                                                child: Icon(
                                                  Icons.edit,
                                                  color: Colors.green.shade700,
                                                )),
                                          )),
                                    ],
                                  ))
                              .toList(),
                        );
                      },
                    ).toList() +
                    [
                      ExpandableTableRow(
                        height: 50,
                        firstCell: _buildCell(Statics.getLabel("Total"), color: Colors.yellow.shade100),
                        cells: [
                          // _buildCell(_totalSampark.toString(), fontWeight: FontWeight.bold, color: Colors.yellow.shade50),
                          _buildCell(_totalVitarit.toString(), fontWeight: FontWeight.bold, color: Colors.yellow.shade50),
                          _buildCell(_totalPustak.toString(), fontWeight: FontWeight.bold, color: Colors.yellow.shade50),
                          _buildCell(_totalSpecial.toString(), fontWeight: FontWeight.bold, color: Colors.yellow.shade50),
                          _buildCell("", fontWeight: FontWeight.bold, color: Colors.yellow.shade50),
                        ],
                      )
                    ],
              ),
            ),
          ],

          //
          if (separatedPreviousLists.isNotEmpty && separatedLists.isNotEmpty) Divider(color: Colors.grey.shade600, height: 90),

          //
          if (separatedLists.isNotEmpty) ...[
            Text("${Statics.getLabel("othersPreviousDaysData")} :", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Container(
              constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * 0.7),
              // padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ExpandableTable(
                expanded: false,
                thumbVisibilityScrollbar: true,
                visibleScrollbar: true,
                // --- Dimensions ---
                firstColumnWidth: 140,
                headerHeight: 50,
                // rowsCount: totalRows,

                // --- Header ---
                firstHeaderCell: _buildHeaderCell(Statics.getLabel('LevelName')),
                headers: _headersOthers.map((e) => ExpandableTableHeader(cell: _buildHeaderCell(e))).toList(),

                // --- Body Rows ---
                rows: separatedLists.asMap().entries.map(
                      (entry) {
                        final index = entry.key;
                        final group = entry.value;
                        // group is List<PreviousDayModel> for one CreatedUserID
                        final _first = group.first;
                        final _participantName = _first.participantName ?? '--';

                        // // compute totals for this group
                        // final totalSampark = group.fold<int>(0, (s, e) => s + (e.samparkitghar ?? 0));
                        // final totalVitarit = group.fold<int>(0, (s, e) => s + (e.vitaritkarpatra ?? 0));
                        // final totalPustak = group.fold<int>(0, (s, e) => s + (e.pustakvikrisankhya ?? 0));
                        // final totalSpecial = group.fold<int>(0, (s, e) => s + (e.totalAtithiCount ?? 0));

                        // return group.length > 1
                        //     ?
                        return ExpandableTableRow(
                          height: 50,

                          // childrenExpanded: true,
                          legend: Container(
                            decoration: BoxDecoration(color: index.isEven ? Colors.red.shade50 : Colors.red.shade100),
                            child: Text(
                              "",
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                          firstCell: _buildCell(_participantName, color: index.isEven ? Colors.red.shade50 : Colors.red.shade100),
                          children: group
                              .map((item) => ExpandableTableRow(
                                    height: 50,
                                    firstCell: _buildCell(item.abhiyaanDate.toString()),
                                    cells: [
                                      // _buildCell(item.samparkitghar.toString()),
                                      _buildCell(item.vitaritkarpatra.toString()),
                                      _buildCell(item.pustakvikrisankhya.toString()),
                                      _buildCell(item.totalAtithiCount.toString()),
                                      if (isAbhiyaanButPramukh)
                                        _buildCell("",
                                            child: Container(
                                              constraints: BoxConstraints(maxWidth: 30),
                                              child: InkWell(
                                                  // onTap: () {
                                                  //   Statics.showToast(Statics.getLabel("workInProgress"));
                                                  // },
                                                  onTap: () async {
                                                    log(jsonEncode(item));
                                                    _selctedLevelNameList = [];
                                                    await Future.delayed(
                                                        Duration(milliseconds: 100),
                                                        () => setState(() {
                                                              dateController.text = DateFormat("dd/MM/yyyy").format(DateFormat("dd-MM-yyyy").parse(item.abhiyaanDate.toString()));
                                                              // samparkitGhareController.text = item.samparkitghar.toString();
                                                              vitritKarpatrakController.text = item.vitaritkarpatra.toString();
                                                              pustakVikriController.text = item.pustakvikrisankhya.toString();
                                                              createdUserId = item.createdUserID;

                                                              // if (item.createdUserID == Statics.abhiyaanUserDetails["AbhiyanSwayamsevakID"] && isAbhiyaanButPramukh)
                                                              //   samparkaSahabhagiController.text = item.samparkhetusahbhagisankhya.toString();
                                                              // if (item.createdUserID == Statics.abhiyaanUserDetails["AbhiyanSwayamsevakID"] && isAbhiyaanButPramukh)
                                                              //   samparkaToliController.text = item.samparkhetutolisankhya.toString();
                                                              _selectedGeoUnitId = item.geoUnitID.toString();
                                                            }));
                                                    // if ((item.visititAtithiSajjanShaktiids != null && item.visititAtithiSajjanShaktiids!.isNotEmpty) ||
                                                    //     (item.visititAtithiAnyaprabhaViLokamids != null && item.visititAtithiAnyaprabhaViLokamids!.isNotEmpty)) {
                                                    // if (!isAbhiyaanButPramukh) {
                                                    data = await Statics.getSajjanAndAnyaGuestData(context, Statics.userDetails["userID"], item.geoUnitID.toString(),
                                                        item.parentMandalID != null && item.parentMandalID.toString().isNotEmpty ? "3" : "2");
                                                    // }
                                                    setState(() {
                                                      _isExpanded = false;
                                                      _selctedLevelNameList.add(_linkedbhaagName);
                                                      _selctedLevelNameList.add(_linkedshaharName);
                                                      _selctedLevelNameList.add(_linkednagarName);
                                                      _selctedLevelNameList.add(_linkedmandalName);
                                                      _selctedLevelNameList.add(_linkedgraamName);
                                                      _selctedLevelNameList.add(_linkedvastiName);
                                                    });
                                                    setState(() {
                                                      if (data != null) {
                                                        // setState(() {
                                                        selectedSajjanshaktiItems =
                                                            data!.vastisarsajjanshakti!.where((e) => item.visititAtithiSajjanShaktiids!.split(",").contains(e.pkid.toString())).toList();
                                                        selectedAnyaprabhaviItems =
                                                            data!.vastisanyaprabhavi!.where((e) => item.visititAtithiAnyaprabhaViLokamids!.split(",").contains(e.pkId.toString())).toList();
                                                        // if (data!.swayamsevaklistforgruh != null)
                                                        //   selectedVisitedSwayamsevak =
                                                        //       data!.swayamsevaklistforgruh!.where((e) => item.swayamsevakIds!.split(",").contains(e.swayamsevakID.toString())).toList();
                                                        // });
                                                      }
                                                    });
                                                    // await _scrollController.animateTo(
                                                    //   0,
                                                    //   duration: const Duration(milliseconds: 600),
                                                    //   curve: Curves.easeInOutSine,
                                                    // );
                                                    setState(() {
                                                      _isEditing = true;
                                                      _searched = true;
                                                      if (item.createdUserID == Statics.abhiyaanUserDetails["AbhiyanSwayamsevakID"] && isAbhiyaanButPramukh) _isEditingForPramukh = true;
                                                    });

                                                    showEditableGruhAbhiyaanForm();
                                                  },
                                                  child: Icon(
                                                    Icons.edit,
                                                    color: Colors.green.shade700,
                                                  )),
                                            )),
                                    ],
                                  ))
                              .toList(),
                        );
                      },
                    ).toList() +
                    [
                      ExpandableTableRow(
                        height: 50,
                        firstCell: _buildCell(Statics.getLabel("Total"), color: Colors.yellow.shade100),
                        cells: [
                          // _buildCell(_totalOthersSampark.toString(), fontWeight: FontWeight.bold, color: Colors.yellow.shade50),
                          _buildCell(_totalOthersVitarit.toString(), fontWeight: FontWeight.bold, color: Colors.yellow.shade50),
                          _buildCell(_totalOthersPustak.toString(), fontWeight: FontWeight.bold, color: Colors.yellow.shade50),
                          _buildCell(_totalOthersSpecial.toString(), fontWeight: FontWeight.bold, color: Colors.yellow.shade50),
                          if (isAbhiyaanButPramukh) _buildCell("", fontWeight: FontWeight.bold, color: Colors.yellow.shade50),
                        ],
                      )
                    ],
              ),
            ),
          ]
        ],
      ),
    );
  }

  Widget isSelectedKaryakartaListWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        spacing: 12,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // if (isAbhiyaanButPramukh)
          //   _markAtt
          //       ? MaterialButton(
          //           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          //           padding: EdgeInsets.symmetric(
          //             horizontal: 12,
          //             vertical: 5,
          //           ),
          //           color: Theme.of(context).primaryColor,
          //           textColor: Theme.of(context).primaryTextTheme.labelMedium?.color,
          //           onPressed: () => setState(() => _markAtt = false),
          //           child: Text(
          //             "${Statics.getLabel('Submit')}",
          //             // "अभियान कार्यकर्ता सुची",
          //             style: TextStyle(fontSize: 14.5),
          //           ),
          //         )
          //       : OutlinedButton(
          //           onPressed: () => setState(() => _markAtt = true),
          //           style: OutlinedButton.styleFrom(
          //               side: BorderSide(color: Colors.purple, width: 2), foregroundColor: Colors.purple, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
          //           child: Text("उपस्थिती लावा")),
          Container(
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
                  showCheckboxColumn: _markAtt,
                  headingRowColor: MaterialStatePropertyAll(Colors.purple.shade50),
                  headingTextStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
                  columns: [
                    // if (!isAbhiyaanButPramukh) DataColumn(label: SizedBox()),
                    DataColumn(
                        label: Text(
                      "${Statics.getLabel('Name')}",
                    )),
                    DataColumn(
                        label: Text(
                      "${Statics.getLabel('mobileNumberLabel')}",
                    )),
                  ],
                  rows: gruhAbhiyaanToliList.asMap().entries.map((entry) {
                    int index = entry.key;
                    var data = entry.value;
                    bool isSelected = (data.isdefault == 1) || _selectedTolisIds.contains(data);
                    return DataRow(
                        // selected: isSelected,
                        // color: MaterialStateProperty.resolveWith<Color?>(
                        //   (Set<MaterialState> states) {
                        //     if (isSelected) return Colors.yellow.shade100;
                        //     return null;
                        //   },
                        // ),
                        // onSelectChanged: (value) {
                        //   if (!_markAtt) {
                        //     return;
                        //   }
                        //   if (!isAbhiyaanButPramukh) {
                        //     return;
                        //   }
                        //   // if (gruhAbhiyaanVruttaData!.abhiyaandata!.ishide) {
                        //   //   return;
                        //   // }
                        //   if ((data.isdefault == 1)) {
                        //     return;
                        //   }
                        //   if (!isSelected) {
                        //     setState(() {
                        //       // selectedKaryakartaList.add(data);
                        //       data.isSelected = true;
                        //       _selectedTolisIds.add(data);
                        //     });
                        //   } else {
                        //     setState(() {
                        //       data.isSelected = false;
                        //       // selectedKaryakartaList.add(data);
                        //       _selectedTolisIds.remove(data);
                        //     });
                        //   }
                        //   setState(() {
                        //     samparkaSahabhagiController.text = gruhAbhiyaanToliList.where((e) => e.isdefault == 1 || e.isSelected).length.toString();
                        //   });
                        //   log(_selectedTolisIds.map((e) => e.swayamsevakID.toString()).join(','));
                        // },
                        cells: [
                          // if (!isAbhiyaanButPramukh) DataCell(Icon(isSelected ? Icons.check_box_rounded : Icons.check_box_outline_blank_rounded, color: Colors.yellow.shade900, size: 21)),
                          DataCell(Container(constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width * 0.4), child: Text(data.fullName ?? ''))),
                          DataCell(Text(data.mobileno ?? '')),
                          // DataCell(Text(Statics.getLabel(data.daayitva.toString(), returnKey: true))),
                        ]);
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
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
            flex: 4,
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
            flex: 3,
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
                    onPressed: () async {
                      Navigator.pop(context);
                    },
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
              clipBehavior: Clip.antiAlias,
              contentPadding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              content: Container(
                // padding: const EdgeInsets.all(16),
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    /// Title with Close Button
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
                            Statics.getLabel('selectSpecialPerson'),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.white),
                            onPressed: () => Navigator.pop(ctnx),
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
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
                                    onPressed: () async {
                                      set(() {});
                                      if (selectedSajjanshaktiItems.isEmpty && selectedAnyaprabhaviItems.isEmpty) {
                                        print("किमान एक विशेष व्यक्ती जोडावे");
                                        Statics.showToast("किमान एक विशेष व्यक्ती जोडावे");
                                        return null;
                                      }
                                      await saveVisheshVyaktiFun(refresh: true);
                                      Navigator.pop(ctx);
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
                              _isEditing = false;
                              _isEditingForPramukh = false;
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
                              _isEditing = false;
                              _searched = false;
                              _linkedMahaanagarValue = _linkedbhaagValue = _linkedshaharValue = _linkednagarValue = _linkedmandalValue = _linkedvastiValue = _linkedgraamValue = null;
                              _linkedVibhaagValue = _linkedbhaag = _linkedshahar = _linkedgraam = _linkedmandal = _linkedvasti = _linkednagar = null;
                              type = "praant";
                            });
                            await populateDropdown();
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
