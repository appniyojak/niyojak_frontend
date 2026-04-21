import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';
import 'package:intl/intl.dart';

import '../dialogs/levelwise_dropdown.dart';
import '../helpers/static_data.dart' as Statics;
import '../models/response_model/dropdown_level_responsemodel.dart';
import '../providers/bals.dart';
import '../screens/edit_join_rss.dart';
import '../utils/globals.dart';
import '../widgets/app_drawer.dart';
import '../widgets/join_rss_card.dart';
import '../widgets/legend.dart';
import 'home_screen/home_screen.dart';

class SearchJoinRss extends StatefulWidget {
  static const routeName = '/search-joinrss-screen';

  @override
  _SearchJoinRssState createState() => _SearchJoinRssState();
}

class _SearchJoinRssState extends State<SearchJoinRss> {
  final _searchController = TextEditingController();
  bool _isSearching = false;
  bool _showList = false;
  bool _isExpanded1 = false;
  bool _isExpanded = false;

  List<GeoUnitMasterBAL>? _bhaag;
  List<GeoUnitMasterBAL>? _shahar;
  List<GeoUnitMasterBAL>? _nagar;
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

  String? _linkedMahaanagarValue = '';
  String? _linkedVibhaagValue = '';
  String? _linkedbhaagValue = "";
  String? _linkedshaharValue = "";
  String? _linkednagarValue = "";
  String? _linkedmandalValue = "";
  String? _linkedgraamValue = "";
  String? _linkedvastiValue = "";
  String? type = "prant";
  String? _linkedupnagarValue = '';
  String? _selctedLevel = 'praant';
  String? _selctedLevelName = '';
  String _selctedLevelNames = '';
  List<String?> _selctedLevelNameList = [];
  String? _selectedGeoUnitId;

  List<StaticMasterBAL>? _status;

  String? _bhaagValue = "";
  String? _shaharValue = "";
  String? _nagarValue = "";
  String? _statusValue = "";
  String? fromAge;
  // String? geoUnitIDnew;
  String? toAge;
  int? isGender = 0;

  DateTime? _fromDate;
  var _fromDateCntrl = TextEditingController();

  DateTime? _toDate;
  var _toDateCntrl = TextEditingController();

  Future<List<dynamic>>? _joinRSSList;

  List<DataColumn>? _detailsColumns;
  List<DataRow>? _detailsRows;

  dynamic joinRSSData;

  final TextEditingController _fromAgeController = TextEditingController();
  final TextEditingController _toAgeController = TextEditingController();

  final GlobalKey<LevelWiseDropdownState> dropdownKey = GlobalKey<LevelWiseDropdownState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) =>  initData());
  }

  Future<void> initData() async {
    DropDownModel dm = await MyAppGlobals.getLevelLDB();

    setState(() {
      userLevelId = dm.levelID;
      userGeoUnitId = dm.geoUnitID;
      ddm = dm;
    });
    await populateDropdown();
    _searchNew('');
  }

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
    _fromDateCntrl.dispose();
    _toDateCntrl.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // _searchNew('Search');
  }

  GeoSelection prepareSelection(DropDownModel dm) {
    return GeoSelection(
      mahaanagar: dm.parentMahaanagarID?.toString() ?? '',
      vibhaag: dm.parentVibhaagID?.toString() ?? '',
      bhaag: dm.parentBhaagID?.toString() ?? '',
      nagar: dm.parentNagarID?.toString() ?? '',
      upnagar: dm.parentUpaNagarID?.toString() ?? '',
      mandal: dm.parentMandalID?.toString() ?? '',
      graam: dm.parentGraamID?.toString() ?? '',
      vasti: dm.parentVastiID?.toString() ?? '',
    );
  }

  Future<void> populateAllDropdowns(int level, DropDownModel dm) async {
    setState(() {
      _selectedGeoUnitId = _linkedMahaanagarValue = _linkedVibhaagValue = _linkedbhaagValue = _linkednagarValue = null;
    });
    final selection = prepareSelection(dm);

    // Step 1: Mahaanagar
    await populatelinkedMahaanagarDropdown();
    _selectedGeoUnitId = _linkedMahaanagarValue = (level == 9 ? (dm.geoUnitID ?? "").toString() : selection.mahaanagar) ?? '';
    _selctedLevel = 'Mahaanagar';

    // Step 2: Vibhaag
    await populatelinkedVibhaagDropdown(_linkedMahaanagarValue!);
    _selectedGeoUnitId = _linkedVibhaagValue = (level == 8 ? (dm.geoUnitID ?? "").toString() : selection.vibhaag) ?? '';
    _selctedLevel = 'Vibhaag';

    // Step 3: Bhaag
    await populatelinkedBhaagDropdown(_linkedVibhaagValue!);
    _selectedGeoUnitId = _linkedbhaagValue = (level == 7 ? (dm.geoUnitID ?? "").toString() : selection.bhaag) ?? '';
    _selctedLevel = 'Bhaag';

    // Step 4: Nagar
    await populatelinkedNagarDropdown(_linkedbhaagValue, null);
    _selectedGeoUnitId = _linkednagarValue = (level == 6 ? (dm.geoUnitID ?? "").toString() : selection.nagar) ?? '';
    _selctedLevel = 'Nagar';

    // if (_linkedVibhaag != null && _linkedVibhaag!.isNotEmpty) _linkedVibhaagName = _linkedVibhaag!.firstWhere((bg) => bg.geoUnitID.toString() == _linkedBhaagValue).name;
    // if (_linkedBhaag != null && _linkedBhaag!.isNotEmpty) _linkedbhaagName = _linkedBhaag!.firstWhere((bg) => bg.geoUnitID.toString() == _linkedBhaagValue).name;
    // if (_linkedNagar != null && _linkedNagar!.isNotEmpty) _linkednagarName = _linkedNagar!.firstWhere((bg) => bg.geoUnitID.toString() == _linkedBhaagValue).name;

    setState(() {});
  }

  Future<void> populateDropdown({bool fromClear = false}) async {
    var data1 = await Statics.getStaticLDB("JoinRSSStatus");

    if (!mounted) return;
    setState(() {
      _status = data1;
    });
    // setState(() {
    //   _linkedshaharValue = null;
    //   _linkednagarValue = null;
    //   _linkedmandalValue = null;
    //   _linkedgraamValue = null;
    //   _linkedvastiValue = null;
    // });
    setState(() {
      _linkedMahaanagarValue = _linkedVibhaagValue = _linkedbhaagValue = _linkednagarValue = null;
      _linkedMahaanagar = _linkedVibhaag = _linkedbhaag = _linkednagar = null;
      _selctedLevelName = _selectedGeoUnitId = null;
      _selctedLevel = "praant";
    });
    await populatelinkedMahaanagarDropdown();
    await populatelinkedVibhaagDropdown('');
    if (fromClear || userLevelId == null || ddm == null) {
      print("object is null");
      print("object is null ${userLevelId == null}");
      print("object is null ${ddm == null}");
      return;
    }
    print("object is not null >>>>>>>>>>>>>>>>>>>>>>");
    await populateAllDropdowns(userLevelId!, ddm!);
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedMahaanagarDropdown() async {
    final data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['MahaanagarLevelID'].toString(), '', '', '', isAbhiyaan: false);
    setState(() => _linkedMahaanagar = data);
    return data;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedVibhaagDropdown(String mahaanagarIDStr) async {
    _linkedbhaagValue = _linkednagarValue = null;
    final data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['VibhaagLevelID'].toString(), mahaanagarIDStr, mahaanagarIDStr.isEmpty ? '' : 'Mahaanagar', '', isAbhiyaan: false);
    setState(() => _linkedVibhaag = data);
    return data;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedBhaagDropdown(String vibhaagIDStr) async {
    _linkednagarValue = null;
    //_linkedbhaagName = _linkednagarName = _linkedmandalName = _linkedgraamName = _linkedvastiName = null;
    _linkedbhaag = _linkednagar = _linkedvasti = [];
    final data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['BhaagLevelID'].toString(), vibhaagIDStr, 'Vibhaag', '', isAbhiyaan: false);
    setState(() => _linkedbhaag = data);
    return data;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedNagarDropdown(String? bhaagIDStr, String? shaharIDStr) async {
    _linkednagarValue = null;
    //_linkednagarName = _linkedmandalName = _linkedgraamName = _linkedvastiName = null;
    _linkednagar = _linkedvasti = null;
    final parentID = shaharIDStr ?? bhaagIDStr!;
    final parentType = shaharIDStr != null ? 'Shahar' : 'Bhaag';
    final data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['NagarLevelID'].toString(), parentID, parentType, '', isAbhiyaan: false);
    setState(() => _linkednagar = data.isNotEmpty ? data : null);
    return data;
  }

  // populatelinkedMahaanagarDropdown() async {
  //   _linkedVibhaagValue = _linkedbhaagValue = _linkednagarValue = _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = null;
  //   var data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['MahaanagarLevelID'].toString(), '', '', '');
  //   setState(() {
  //     _linkedMahaanagar = data;
  //   });
  // }
  //
  // populatelinkedVibhaagDropdown(String? mahaanagarIDStr) async {
  //   _linkedbhaagValue = _linkednagarValue = _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = null;
  //   var data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['VibhaagLevelID'].toString(), mahaanagarIDStr!, (mahaanagarIDStr.isEmpty ? '' : 'Mahaanagar'), '');
  //   setState(() {
  //     _linkedVibhaag = data;
  //   });
  // }
  //
  // void populatelinkedBhaagDropdown(String? vibhaagIDStr) async {
  //   _linkedbhaagValue = _linkednagarValue = _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = null;
  //   _linkedbhaag = _linkednagar = _linkedmandal = _linkedgraam = _linkedvasti = [];
  //   var data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['BhaagLevelID'].toString(), vibhaagIDStr!, 'Vibhaag', '');
  //   setState(() {
  //     _linkedbhaag = data;
  //   });
  // }
  //
  // void populatelinkedShaharDropdown(String? bhaagIDStr) async {
  //   _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = null;
  //   var shDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['ShaharLevelID'].toString(), bhaagIDStr!, 'Bhaag', '');
  //   setState(() {
  //     _linkedshahar = (shDD.length > 0 ? shDD : null);
  //   });
  // }
  //
  // void populatelinkedNagarDropdown(String? bhaagIDStr, String? shaharIDStr) async {
  //   _linkednagarValue = _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = null;
  //   _linkednagar = _linkedmandal = _linkedgraam = _linkedvasti = null;
  //   if (shaharIDStr != null) {
  //     var ngDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['NagarLevelID'].toString(), shaharIDStr, 'Shahar', '');
  //     setState(() {
  //       _linkednagar = (ngDD.length > 0 ? ngDD : null);
  //     });
  //   } else {
  //     var ngDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['NagarLevelID'].toString(), bhaagIDStr!, 'Bhaag', '');
  //     setState(() {
  //       _linkednagar = (ngDD.length > 0 ? ngDD : null);
  //     });
  //   }
  // }
  //
  // void populatelinkedMandalDropdown(String? nagarIDStr) async {
  //   _linkedmandalValue = _linkedgraamValue = null;
  //   _linkedmandal = _linkedgraam = null;
  //   var mnDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['MandalLevelID'].toString(), nagarIDStr!, 'Nagar', '');
  //   setState(() {
  //     _linkedmandal = (mnDD.length > 0 ? mnDD : null);
  //   });
  // }
  //
  // void populatelinkedGraamDropdown(String? mandalIDStr) async {
  //   _linkedgraamValue = null;
  //   var gmDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['GraamLevelID'].toString(), mandalIDStr!, 'Mandal', '');
  //   setState(() {
  //     _linkedgraam = (gmDD.length > 0 ? gmDD : null);
  //   });
  // }
  //
  // void populatelinkedVastiDropdown(String? nagarIDStr) async {
  //   _linkedvastiValue = null;
  //   var vsDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['VastiLevelID'].toString(), nagarIDStr!, 'Nagar', '');
  //   setState(() {
  //     _linkedvasti = (vsDD.length > 0 ? vsDD : null);
  //   });
  // }

  void _getCsv(var list) async {
    setState(() {
      _isSearching = true;
    });
    List<dynamic> dataList = list;
    if (dataList.length == 0) {
      Statics.showMessageDialog(context, Statics.getLabel('noDataFoundTryAnotherSearch'));

      setState(() {
        _isSearching = false;
      });
      return;
    }
    List<List<dynamic>> rows = [];
    List<dynamic> header = [];
    header.add("Full Name");
    header.add("Mobile Number");
    header.add("E-mail");
    header.add("Gender");
    header.add("Age");
    header.add("Address");
    header.add("City");
    header.add("District");
    header.add("State");
    header.add("Country");
    header.add("Bhaag");
    header.add("Nagar");
    header.add("Shahar");
    header.add("Occupation");
    header.add("Remark");
    header.add("Joining Date");
    header.add("Join RSS Sanyojak Remark");
    header.add("Status");
    header.add("Status Date");
    header.add("Status Remark");

    rows.add(header);
    for (int i = 0; i < dataList.length; i++) {
      var data = dataList[i];
      List<dynamic> row = [];
      row.add(data["Name"].toString());
      row.add(data["MobileNumber"].toString());
      row.add(data["Email"].toString());
      row.add(data["GenderCode"].toString());
      row.add(data["Age"] == null ? "" : data["Age"].toString());
      row.add(data["Address"] == null ? "" : data["Address"].toString());
      row.add(data["CityName"] == null ? "" : data["CityName"].toString());
      row.add(data["DistrictName"] == null ? "" : data["DistrictName"].toString());
      row.add(data["StateName"] == null ? "" : data["StateName"].toString());
      row.add(data["Country"] == null ? "" : data["Country"].toString());
      row.add(data["BhaagName"] == null ? "" : data["BhaagName"].toString());
      row.add(data["NagarName"] == null ? "" : data["NagarName"].toString());
      row.add(data["ShaharName"] == null ? "" : data["ShaharName"].toString());
      row.add(data["Occupation"] == null ? "" : data["Occupation"].toString());
      row.add(data["Remark"] == null ? "" : data["Remark"].toString());
      row.add(data["JoiningDateStr"] == null ? "" : data["JoiningDateStr"].toString());
      row.add(data["JRSRemark"] == null ? "" : data["JRSRemark"].toString());
      row.add(data["StatusCode"] == null ? "" : data["StatusCode"].toString());
      row.add(data["StatusDateStr"] == null ? "" : data["StatusDateStr"].toString());
      row.add(data["StatusRemark"] == null ? "" : data["StatusRemark"].toString());

      rows.add(row);
    }

    if (rows.length > 1) {
      Statics.convertToCsv(rows, "JoinRssList" + "_" + DateFormat('ddmmyyyyHHmmss').format(DateTime.now()), context);
    }
    setState(() {
      _isSearching = false;
    });
  }

  _pickFromDate() async {
    DateTime? date = await showDatePicker(
        context: context,
        initialDate: _fromDate == null ? DateTime.now() : _fromDate!,
        firstDate: DateTime((_fromDate == null ? DateTime.now().year : _fromDate!.year) - 80),
        lastDate: DateTime((_fromDate == null ? DateTime.now().year : _fromDate!.year) + 80));

    if (_toDate != null) {
      if (_toDate!.year < date!.year || _toDate!.month < date.month || _toDate!.day < date.day) {
        Statics.showToast("From date should be less than To Date");
        return;
      }
    }
    setState(() {
      _fromDate = date;
      _fromDateCntrl.text = DateFormat('dd-MMM-yyyy').format(date!);
    });
  }

  _pickToDate() async {
    DateTime? date = await showDatePicker(
        context: context,
        initialDate: _toDate == null ? DateTime.now() : _toDate!,
        firstDate: DateTime((_toDate == null ? DateTime.now().year : _toDate!.year) - 80),
        lastDate: DateTime((_toDate == null ? DateTime.now().year : _toDate!.year) + 80));

    if (_fromDate != null) {
      if (date!.year < _fromDate!.year || date.month < _fromDate!.month || date.day < _fromDate!.day) {
        Statics.showToast("From date should be less than To Date");
        return;
      }
    }
    setState(() {
      _toDate = date;
      _toDateCntrl.text = DateFormat('dd-MMM-yyyy').format(date!);
    });
  }

  var setSummerData;
  late List<dynamic> setStatusCodes;
  late List<dynamic> setNaavList;
  Map<String, Map<String, Map<String, int>>>? setGroupedData;

  Future<void> _searchNew(var outputType) async {
    setState(() {
      _isSearching = true;
    });

    int? bhaagVal = _bhaagValue == null || _bhaagValue == "" ? null : int.parse(_bhaagValue!);
    int? shaharVal = _shaharValue == null || _shaharValue == "" ? null : int.parse(_shaharValue!);
    int? nagarVal = _nagarValue == null || _nagarValue == "" ? null : int.parse(_nagarValue!);
    int? statusVal = _statusValue == null || _statusValue == "" ? null : int.parse(_statusValue!);
    int? geoUnitID;
    geoUnitID = nagarVal != null
        ? nagarVal
        : shaharVal != null
            ? shaharVal
            : bhaagVal != null
                ? bhaagVal
                : null;
    var fromDate = _fromDate == null ? null : DateFormat('dd-MM-yyyy').format(_fromDate!);
    var toDate = _toDate == null ? null : DateFormat('dd-MM-yyyy').format(_toDate!);

    String strInput = json.encode({
      "AppUserID": Statics.userDetails['userID'],
      "SearchCriteria": _searchController.text,
      "GeoUnitID": _selectedGeoUnitId,
      "StatusID": statusVal,
      "JoiningDateFrom": fromDate,
      "JoiningDateTo": toDate,
      "fromage": int.parse(_fromAgeController.text == '' ? '0' : _fromAgeController.text),
      "toage": int.parse(_toAgeController.text == '' ? '0' : _toAgeController.text),
      "isgender": isGender,
      "type": type,
    });
    print("Join RSS search Request :-- $strInput");
    try {
      joinRSSData = await Statics.getJoinRSSData(strInput);
      setState(() {
        _isSearching = false;
      });
    } catch (e) {
      print("Catch exception --->   $e");
      setState(() {
        _isSearching = false;
      });
    }

    if (outputType == "Export") {
      _getCsv(joinRSSData['ListJoinRSS']);
    } else {
      //  commented on 27-2-2025   horizon data table add kiya isliye by dom
      // var summaryData = joinRSSData['ListJoinRSSByStatustypewise'];
      // List<dynamic> naavList = summaryData.map((e) => e['naav']).toSet().toList();
      // List<dynamic> statusCodes = summaryData.map((e) => e['StatusCode']).toSet().toList();
      //
      // Map<String, Map<String, Map<String, int>>> groupedData = {};
      // for (var entry in summaryData) {
      //   String naav = entry['naav'];
      //   String statusCode = entry['StatusCode'];
      //   int femaleCount = entry['FemaleCountByStatus'];
      //   int maleCount = entry['MaleCountByStatus'];
      //
      //   groupedData.putIfAbsent(naav, () => {});
      //   groupedData[naav]!.putIfAbsent(statusCode, () => {"female": 0, "male": 0});
      //   groupedData[naav]![statusCode]!["female"] = femaleCount;
      //   groupedData[naav]![statusCode]!["male"] = maleCount;
      // }
      // int totalFemaleAllNaav = 0;
      // int totalMaleAllNaav = 0;
      //
      // for (var naav in naavList) {
      //   int totalFemaleForNaav = 0;
      //   int totalMaleForNaav = 0;
      //
      //   statusCodes.forEach((status) {
      //     var counts = groupedData[naav]?[status] ?? {"female": 0, "male": 0};
      //     totalFemaleForNaav += counts['female'] ?? 0;
      //     totalMaleForNaav += counts['male'] ?? 0;
      //   });
      //
      //   totalFemaleAllNaav += totalFemaleForNaav;
      //   totalMaleAllNaav += totalMaleForNaav;
      // }
      //
      //
      //
      // List<DataColumn> summaryCols = [
      //   DataColumn(label: Text(Statics.getLabel('Level'))),
      //   ...statusCodes.map((status) => DataColumn(label: Text(status))),
      //   DataColumn(label: Text(Statics.getLabel('Total'))),
      // ];
      //
      // List<DataRow> summaryRows = naavList.map((naav) {
      //   int totalFemale = 0;
      //   int totalMale = 0;
      //
      //   return DataRow(
      //     cells: [
      //       DataCell(Text(naav)),
      //       ...statusCodes.map((status) {
      //         var counts = groupedData[naav]?[status] ?? {"female": 0, "male": 0};
      //         totalFemale += counts['female'] ?? 0;
      //         totalMale += counts['male'] ?? 0;
      //
      //         return DataCell(Text(
      //             "${Statics.getLabel('Women')}: ${counts['female']}\n${Statics.getLabel('Men')}: ${counts['male']}"));
      //       }),
      //       DataCell(Text(
      //           "${Statics.getLabel('Total')} ${Statics.getLabel('Women')}: $totalFemale\n${Statics.getLabel('Total')} ${Statics.getLabel('Men')}: $totalMale")),
      //     ],
      //   );
      // }).toList();
      //
      //
      // Map<String, Map<String, int>> totalCounts = {};
      // for (var entry in summaryData) {
      //   String statusCode = entry['StatusCode'];
      //   totalCounts.putIfAbsent(statusCode, () => {"female": 0, "male": 0});
      //   totalCounts[statusCode]?['female'] = ((totalCounts[statusCode]?['female'] ?? 0) as int) + (entry['FemaleCountByStatus'] as int);
      //   totalCounts[statusCode]?['male'] = ((totalCounts[statusCode]?['male'] ?? 0) as int) + (entry['MaleCountByStatus'] as int);
      //
      // }
      // summaryRows.add(
      //   DataRow(
      //     cells: [
      //       DataCell(Text(Statics.getLabel('Total'))),
      //       ...statusCodes.map((status) {
      //         var total = totalCounts[status] ?? {"female": 0, "male": 0};
      //         return DataCell(Text(
      //             "${Statics.getLabel('Women')}: ${total['female']}\n${Statics.getLabel('Men')}: ${total['male']}"));
      //       }),
      //       DataCell(Text(
      //           "${Statics.getLabel('Total')} ${Statics.getLabel('Women')}: $totalFemaleAllNaav\n${Statics.getLabel('Total')} ${Statics.getLabel('Men')}: $totalMaleAllNaav")),
      //     ],
      //   ),
      // );

// ======  horizntal data table viewww code ================
      var summaryData = joinRSSData['ListJoinRSSByStatustypewise'];
      List<dynamic> naavList = summaryData.map((e) => e['naav']).toSet().toList();
      List<dynamic> statusCodes = summaryData.map((e) => e['StatusCode']).toSet().toList();
      Map<String, Map<String, Map<String, int>>> groupedData = {};
      for (var entry in summaryData) {
        String naav = entry['naav'];
        String statusCode = entry['StatusCode'];
        int femaleCount = entry['FemaleCountByStatus'];
        int maleCount = entry['MaleCountByStatus'];

        groupedData.putIfAbsent(naav, () => {});
        groupedData[naav]!.putIfAbsent(statusCode, () => {"female": 0, "male": 0});
        groupedData[naav]![statusCode]!["female"] = femaleCount;
        groupedData[naav]![statusCode]!["male"] = maleCount;
      }

      setState(() {
        setSummerData = summaryData;
        setNaavList = naavList;
        setStatusCodes = statusCodes;
        setGroupedData = groupedData;
        _joinRSSList = getDetailData();
        _isSearching = false;
        _isExpanded1 = false;
        _isExpanded = false;
      });

      // HorizontalDataTable(
      //   leftHandSideColumnWidth: 100,
      //   rightHandSideColumnWidth: 450,
      //   isFixedHeader: true,
      //   headerWidgets:  /* 1st column ka header rahega "level" baki column ka header "StatusCode" rakhana hai resnce mese */,
      //   leftSideItemBuilder: /* 1st column me "naav" rahega */,
      //   rightSideItemBuilder: /* baki column amle female ka data data rahega according to naav and level  */,
      //   itemCount:/* ye nhi pata muze kaha se aayega*/ ,
      //   rowSeparatorWidget: const Divider(
      //     color: Colors.black54,
      //     height: 1.0,
      //     thickness: 0.0,
      //   ),
      //   leftHandSideColBackgroundColor: Color(0xFFFFFFFF),
      //   rightHandSideColBackgroundColor: Color(0xFFFFFFFF),
      // )
    }
    // setState(() {
    //   _isSearching = false;
    //   _isExpanded1 = false;
    //   _isExpanded = false;
    // });
    if (outputType == "Search") {
      setState(() {
        _showList = true;
        _isSearching = false;
      });
    }
  }

  Future<List<dynamic>> getDetailData() async {
    return joinRSSData['ListJoinRSS'];
  }

  @override
  Widget build(BuildContext context) {
    double rowHeight = 70;
    double columnWidth = 140;
    double leftColumnWidth = 120;

    return WillPopScope(
      onWillPop: () async {
        Navigator.popAndPushNamed(context, HomeScreen.routeName);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Text(
                Statics.getLabel('searchJoinRSSScreenLabel'),
                style: TextStyle(fontSize: 24),
              ),
            ],
          ),
          actions: <Widget>[
            if ((Statics.userDetails["LevelName"] == "Praant" ||
                Statics.userDetails["LevelName"] == "प्रांत" && Statics.userDetails["DaayitvaName"] == "Join RSS Sanyojak" ||
                Statics.userDetails["DaayitvaName"] == "जॉयन आर.एस.एस. संयोजक" ||
                Statics.userDetails["DaayitvaName"] == "Join RSS Pramukh" ||
                Statics.userDetails["DaayitvaName"] == "जॉयन आर.एस.एस. प्रमुख"))
              IconButton(
                padding: EdgeInsets.all(8),
                icon: const Icon(Icons.add),
                onPressed: () {
                  Navigator.of(context).pushNamed(EditJoinRss.routeName, arguments: Statics.ScreenArguments(0, Statics.getLabel('EditMenu')));
                },
              ),
          ],
        ),
        drawer: AppDrawer(),
        body: Container(
          margin: EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                ExpansionPanelList(
                  expansionCallback: (int index, bool isExpanded) {
                    setState(() {
                      _isExpanded1 = isExpanded;
                    });
                  },
                  children: [
                    ExpansionPanel(
                      headerBuilder: (BuildContext context, bool isExpanded) {
                        return ListTile(
                          title: Text(Statics.getLabel('StatusWiseDetails')),
                        );
                      },
                      body: Container(
                        child: Column(
                          children: [
                            if (setSummerData == null)
                              Container(
                                height: Statics.getDeviceSize(context).height * 0.30,
                                width: Statics.getDeviceSize(context).width,
                                alignment: Alignment.center,
                                child: CircularProgressIndicator(),
                              )
                            else if (setSummerData.isEmpty)
                              Container(
                                height: Statics.getDeviceSize(context).height * 0.30,
                                width: Statics.getDeviceSize(context).width,
                                alignment: Alignment.center,
                                child: Text('No Data Found'),
                              )
                            else
                              Container(
                                height: Statics.getDeviceSize(context).height * 0.50,
                                width: Statics.getDeviceSize(context).width,
                                child: HorizontalDataTable(
                                  leftHandSideColumnWidth: leftColumnWidth,
                                  rightHandSideColumnWidth: setStatusCodes.length * columnWidth + columnWidth,
                                  isFixedHeader: true,
                                  headerWidgets: [
                                    Container(
                                      width: leftColumnWidth,
                                      height: rowHeight + 40,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
                                      child: Text(Statics.getLabel('Level'), textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
                                    ),
                                    Container(
                                      width: columnWidth,
                                      height: rowHeight + 40,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(border: Border.symmetric(horizontal: BorderSide(color: Colors.grey))),
                                      child: Text(Statics.getLabel('Total'), textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
                                    ),
                                    ...setStatusCodes!.map((status) => Container(
                                          width: columnWidth,
                                          height: rowHeight + 40,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(border: Border.symmetric(horizontal: BorderSide(color: Colors.grey))),
                                          child: Text(status, textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
                                        )),
                                  ],
                                  leftSideItemBuilder: (context, index) {
                                    if (index == setNaavList!.length) {
                                      return Container(
                                        width: leftColumnWidth,
                                        height: rowHeight,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(border: Border.all(color: Colors.grey), color: Colors.grey[300]),
                                        child: Text(
                                          Statics.getLabel('Total'),
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                      );
                                    }
                                    return Container(
                                      width: leftColumnWidth,
                                      height: rowHeight,
                                      padding: EdgeInsets.all(8),
                                      alignment: Alignment.centerLeft,
                                      decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
                                      child: Text(setNaavList![index]),
                                    );
                                  },
                                  rightSideItemBuilder: (context, index) {
                                    if (index == setNaavList!.length) {
                                      return Row(
                                        children: [
                                          Container(
                                            width: columnWidth,
                                            height: rowHeight,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(border: Border.all(color: Colors.grey), color: Colors.grey[400]),
                                            child: Text(
                                              "${Statics.getLabel('Total')} ${Statics.getLabel('Women')}: ${setNaavList!.fold(0, (sum, naav) => sum + setStatusCodes!.fold(0, (s, status) => s + (setGroupedData![naav]?[status]?['female'] ?? 0)))}\n"
                                              "${Statics.getLabel('Total')} ${Statics.getLabel('Men')}: ${setNaavList!.fold(0, (sum, naav) => sum + setStatusCodes!.fold(0, (s, status) => s + (setGroupedData![naav]?[status]?['male'] ?? 0)))}",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          ...setStatusCodes!.map((status) {
                                            int totalFemale = setNaavList!.fold(0, (sum, naav) => sum + (setGroupedData![naav]?[status]?['female'] ?? 0));
                                            int totalMale = setNaavList!.fold(0, (sum, naav) => sum + (setGroupedData![naav]?[status]?['male'] ?? 0));

                                            return Container(
                                              width: columnWidth,
                                              height: rowHeight,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(border: Border.all(color: Colors.grey), color: Colors.grey[300]),
                                              child: Text(
                                                "${Statics.getLabel('Women')}: $totalFemale\n${Statics.getLabel('Men')}: $totalMale",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(fontWeight: FontWeight.bold),
                                              ),
                                            );
                                          }),
                                        ],
                                      );
                                    }

                                    String naav = setNaavList![index];
                                    int totalFemale = 0;
                                    int totalMale = 0;

                                    List<Widget> rowCells = setStatusCodes!.map((status) {
                                      var counts = setGroupedData![naav]?[status] ?? {"female": 0, "male": 0};
                                      totalFemale += counts['female'] ?? 0;
                                      totalMale += counts['male'] ?? 0;

                                      return Container(
                                        width: columnWidth,
                                        height: rowHeight,
                                        padding: EdgeInsets.all(8),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(border: Border.symmetric(horizontal: BorderSide(color: Colors.grey))),
                                        child: Text(
                                          "${Statics.getLabel('Women')}: ${counts['female']}\n${Statics.getLabel('Men')}: ${counts['male']}",
                                          textAlign: TextAlign.center,
                                        ),
                                      );
                                    }).toList();

                                    // rowCells.add(Container(
                                    //   width: columnWidth,
                                    //   height: rowHeight,
                                    //   padding: EdgeInsets.all(8),
                                    //   alignment: Alignment.center,
                                    //   decoration: BoxDecoration(
                                    //       border: Border.symmetric(
                                    //           horizontal: BorderSide(
                                    //               color: Colors.grey))),
                                    //   child: Text(
                                    //     "${Statics.getLabel('Total')} ${Statics.getLabel('Women')}: $totalFemale\n${Statics.getLabel('Total')} ${Statics.getLabel('Men')}: $totalMale",
                                    //     textAlign: TextAlign.center,
                                    //   ),
                                    // ));

                                    return Row(
                                        children: <Widget>[
                                              Container(
                                                width: columnWidth,
                                                height: rowHeight,
                                                padding: EdgeInsets.all(8),
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(border: Border.symmetric(horizontal: BorderSide(color: Colors.grey))),
                                                child: Text(
                                                  "${Statics.getLabel('Total')} ${Statics.getLabel('Women')}: $totalFemale\n${Statics.getLabel('Total')} ${Statics.getLabel('Men')}: $totalMale",
                                                  textAlign: TextAlign.center,
                                                ),
                                              )
                                            ] +
                                            rowCells);
                                  },
                                  itemCount: setNaavList!.length + 1,
                                  rowSeparatorWidget: Divider(color: Colors.grey, height: 1.0, thickness: 0.5),
                                  leftHandSideColBackgroundColor: Color(0xFFFFFFFF),
                                  rightHandSideColBackgroundColor: Color(0xFFFFFFFF),
                                ),
                              ),
                          ],
                        ),
                      ),
                      isExpanded: _isExpanded1,
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Legend(
                  legendString: 'searchJoinRSSScreenBanner',
                  fontsize: 20,
                ),
                SingleChildScrollView(
                  child: ExpansionPanelList(
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
                              TextFormField(
                                controller: _searchController,
                                textInputAction: TextInputAction.done,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(labelText: Statics.getLabel('Name') + "/" + Statics.getLabel('mobileNumberLabel')),
                              ),
                              SizedBox(height: 10),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "${Statics.getLabel('agegroup')}",
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      controller: _fromAgeController,
                                      decoration: InputDecoration(
                                        labelText: "${Statics.getLabel('fromAge')}",
                                        border: OutlineInputBorder(),
                                      ),
                                      keyboardType: TextInputType.number,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: TextFormField(
                                      controller: _toAgeController,
                                      decoration: InputDecoration(
                                        labelText: "${Statics.getLabel('toAge')}",
                                        border: OutlineInputBorder(),
                                      ),
                                      keyboardType: TextInputType.number,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${Statics.getLabel('Gender')}",
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      ChoiceChip(
                                        selectedColor: Colors.purple,
                                        label: Text(
                                          Statics.getLabel('Male'),
                                          style: TextStyle(color: isGender == 1 ? Colors.white : Colors.black),
                                        ),
                                        selected: isGender == 1,
                                        onSelected: (bool selected) {
                                          setState(() {
                                            isGender = selected ? 1 : 0;
                                          });
                                        },
                                      ),
                                      ChoiceChip(
                                        selectedColor: Colors.purple,
                                        label: Text(
                                          Statics.getLabel('Female'),
                                          style: TextStyle(color: isGender == 2 ? Colors.white : Colors.black),
                                        ),
                                        selected: isGender == 2,
                                        onSelected: (bool selected) {
                                          setState(() {
                                            isGender = selected ? 2 : 0;
                                          });
                                        },
                                      ),
                                      // ChoiceChip(
                                      //   label: const Text("None"),
                                      //   selected: isGender == 0,
                                      //   onSelected: (bool selected) {
                                      //     setState(() {
                                      //       isGender = 0;
                                      //     });
                                      //   },
                                      // ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              // LevelWiseDropdown(
                              //   key: dropdownKey,
                              //   onFinalSelection: (String level,String? geoUnitID) {
                              //   print("geoUnitID :- $geoUnitID");
                              // setState(() {
                              //   geoUnitIDnew = geoUnitID;
                              // });},),
                              Container(
                                margin: EdgeInsets.all(10),
                                child: Column(
                                  children: [
                                    if (_linkedMahaanagar != null)
                                      IgnorePointer(
                                        ignoring: _linkedMahaanagarDisable!,
                                        child: DropdownButtonFormField<String>(
                                          decoration: InputDecoration(labelText: Statics.getLabel('Mahaanagar')),
                                          isExpanded: true,
                                          value: _linkedMahaanagarValue == "" ? null : _linkedMahaanagarValue,
                                          items: _linkedMahaanagar!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                                          onChanged: MyAppGlobals.isDropdownDisabled('Mahaanagar')
                                              ? null
                                              : (value) {
                                                  print(value);
                                                  setState(() {
                                                    _linkedMahaanagarValue = value;
                                                    _selectedGeoUnitId = value;
                                                    _linkedVibhaagValue = null;
                                                    _linkedMahaanagarDisable = false;
                                                    _linkedVibhaagDisable = false;
                                                    _linkedbhaagDisable = false;
                                                    _linkednagarDisable = false;

                                                    _linkedVibhaag = _linkedbhaag = _linkednagar = _linkedmandal = _linkedgraam = _linkedvasti = null;
                                                    type = "mahanagar";
                                                    populatelinkedVibhaagDropdown(value!);
                                                  });
                                                },
                                        ),
                                      ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    if (_linkedVibhaag != null && _linkedVibhaag!.length > 0)
                                      IgnorePointer(
                                        ignoring: false,
                                        child: DropdownButtonFormField<String>(
                                          decoration: InputDecoration(labelText: Statics.getLabel('Vibhaag')),
                                          isExpanded: true,
                                          value: _linkedVibhaagValue == "" ? null : _linkedVibhaagValue,
                                          items: _linkedVibhaag!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                                          onChanged: MyAppGlobals.isDropdownDisabled('Vibhaag')
                                              ? null
                                              : (value) {
                                                  setState(() {
                                                    _linkedVibhaagValue = value;
                                                    populatelinkedBhaagDropdown(value!);
                                                    type = "vibhag";
                                                    _selectedGeoUnitId = value;
                                                  });
                                                },
                                        ),
                                      ),
                                    if (_linkedVibhaag != null && _linkedVibhaag!.length > 0)
                                      SizedBox(
                                        height: 10,
                                      ),
                                    if (_linkedbhaag != null && _linkedbhaag!.length > 0)
                                      IgnorePointer(
                                        ignoring: _linkedbhaagDisable!,
                                        child: DropdownButtonFormField<String>(
                                          decoration: InputDecoration(labelText: Statics.getLabel('Bhaag')),
                                          isExpanded: true,
                                          value: _linkedbhaagValue == "" ? null : _linkedbhaagValue,
                                          items: _linkedbhaag!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                                          onChanged: MyAppGlobals.isDropdownDisabled('Bhaag')
                                              ? null
                                              : (value) {
                                                  setState(() {
                                                    _linkedbhaagValue = value;
                                                    populatelinkedNagarDropdown(value, null);
                                                    type = "bhag";
                                                    _selectedGeoUnitId = value;
                                                  });
                                                },
                                        ),
                                      ),
                                    if (_linkedbhaag != null && _linkedbhaag!.length > 0)
                                      SizedBox(
                                        height: 10,
                                      ),
                                    // if (_linkedshahar != null && _linkedshahar!.length > 0)
                                    //   IgnorePointer(
                                    //     ignoring: _linkedshaharDisable!,
                                    //     child: DropdownButtonFormField(
                                    //       decoration: InputDecoration(labelText: Statics.getLabel('Shahar')),
                                    //       isExpanded: true,
                                    //       value: _linkedshaharValue == "" ? null : _linkedshaharValue,
                                    //       items: _linkedshahar!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                                    //       onChanged: (value) {
                                    //         setState(() {
                                    //           _linkedshaharValue = value;
                                    //           populatelinkedNagarDropdown(null, value);
                                    //           type = "shahar";
                                    //           geoUnitIDnew = value;
                                    //         });
                                    //       },
                                    //     ),
                                    //   ),
                                    // if (_linkedshahar != null && _linkedshahar!.length > 0)
                                    //   SizedBox(
                                    //     height: 10,
                                    //   ),
                                    if (_linkednagar != null && _linkednagar!.length > 0)
                                      IgnorePointer(
                                        ignoring: _linkednagarDisable!,
                                        child: DropdownButtonFormField<String>(
                                          decoration: InputDecoration(labelText: Statics.getLabel('Nagar')),
                                          isExpanded: true,
                                          value: _linkednagarValue == "" ? null : _linkednagarValue,
                                          items: _linkednagar!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                                          onChanged: MyAppGlobals.isDropdownDisabled('Nagar')
                                              ? null
                                              : (value) {
                                                  setState(() {
                                                    _linkednagarValue = value;

                                                    type = "nagar";
                                                    _selectedGeoUnitId = value;
                                                  });
                                                },
                                        ),
                                      ),
                                    if (_linkednagar != null && _linkednagar!.length > 0)
                                      SizedBox(
                                        height: 10,
                                      ),
                                    /*if (_linkedmandal != null && _linkedmandal!.length > 0)
                                      IgnorePointer(
                                        ignoring: _linkedmandalDisable!,
                                        child: DropdownButtonFormField(
                                          decoration: InputDecoration(labelText: Statics.getLabel('Mandal')),
                                          isExpanded: true,
                                          value: _linkedmandalValue == "" ? null : _linkedmandalValue,
                                          items: _linkedmandal!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                                          onChanged: (value) {
                                            setState(() {
                                              _linkedmandalValue = value;
                                              populatelinkedGraamDropdown(value);
                                              type = "mandal";
                                              geoUnitIDnew = value;
                                            });
                                          },
                                        ),
                                      ),
                                    if (_linkedmandal != null && _linkedmandal!.length > 0)
                                      SizedBox(
                                        height: 10,
                                      ),
                                    if (_linkedgraam != null && _linkedgraam!.length > 0)
                                      IgnorePointer(
                                        ignoring: _linkedgraamDisable!,
                                        child: DropdownButtonFormField(
                                          decoration: InputDecoration(labelText: Statics.getLabel('Graam')),
                                          isExpanded: true,
                                          value: _linkedgraamValue == "" ? null : _linkedgraamValue,
                                          items: _linkedgraam!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                                          onChanged: (value) {
                                            setState(() {
                                              _linkedgraamValue = value;
                                              type = "gram";
                                              geoUnitIDnew = value;
                                            });
                                          },
                                        ),
                                      ),
                                    if (_linkedvasti != null && _linkedvasti!.length > 0)
                                      IgnorePointer(
                                        ignoring: _linkedvastiDisable!,
                                        child: DropdownButtonFormField(
                                          decoration: InputDecoration(labelText: Statics.getLabel('Vasti')),
                                          isExpanded: true,
                                          value: _linkedvastiValue == "" ? null : _linkedvastiValue,
                                          items: _linkedvasti!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                                          onChanged: (value) {
                                            setState(() {
                                              _linkedvastiValue = value;
                                              type = "vasti";
                                              geoUnitIDnew = value;
                                            });
                                          },
                                        ),
                                      ),*/
                                  ],
                                ),
                              ),
                              if (_status != null)
                                DropdownButtonFormField(
                                  decoration: InputDecoration(labelText: Statics.getLabel('Status')),
                                  isExpanded: true,
                                  value: _statusValue == "" ? null : _statusValue,
                                  items: _status!.map((bg) => DropdownMenuItem(value: bg.staticID.toString(), child: Text(bg.codeForDisplay!))).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      _statusValue = value;
                                    });
                                  },
                                ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    width: Statics.getDeviceSize(context).width * 0.7,
                                    child: TextField(
                                      enabled: false,
                                      controller: _fromDateCntrl,
                                      decoration: InputDecoration(labelText: Statics.getLabel('FromDate')),
                                      textInputAction: TextInputAction.done,
                                    ),
                                  ),
                                  IconButton(
                                    color: Colors.purple,
                                    icon: FaIcon(FontAwesomeIcons.solidCalendarAlt),
                                    onPressed: _pickFromDate,
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    width: Statics.getDeviceSize(context).width * 0.7,
                                    child: TextField(
                                      enabled: false,
                                      controller: _toDateCntrl,
                                      decoration: InputDecoration(labelText: Statics.getLabel('ToDate')),
                                      textInputAction: TextInputAction.done,
                                    ),
                                  ),
                                  IconButton(
                                    color: Colors.purple,
                                    icon: FaIcon(FontAwesomeIcons.solidCalendarAlt),
                                    onPressed: _pickToDate,
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        ),
                        isExpanded: _isExpanded,
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(20),
                  child: Column(
                    children: [
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
                              onPressed: () {
                                _searchNew("Search");
                              },
                              child: Text(
                                Statics.getLabel('Search'),
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            MaterialButton(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                              padding: EdgeInsets.symmetric(
                                horizontal: 15,
                                vertical: 8,
                              ),
                              color: Theme.of(context).primaryColor,
                              textColor: Theme.of(context).primaryTextTheme.labelMedium?.color,
                              onPressed: () {
                                _searchNew("Export");
                              },
                              child: Text(
                                Statics.getLabel('ExportToExcel'),
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            MaterialButton(
                                onPressed: () {
                                  _selectedGeoUnitId = null;
                                  type = "prant";
                                  setState(() {
                                    _bhaagValue = _shaharValue = _nagarValue = null;
                                    _bhaag = _shahar = _statusValue = _nagar = _fromDate = _toDate = null;
                                    _searchController.text = _toDateCntrl.text = _fromDateCntrl.text = _fromAgeController.text = _toAgeController.text = "";
                                    isGender = 0;
                                    dropdownKey.currentState?.clearSelections();
                                    _linkedMahaanagarValue = _linkedbhaagValue = _linkedshaharValue = _linkednagarValue = _linkedmandalValue = _linkedvastiValue = _linkedgraamValue = null;
                                    _linkedVibhaagValue = _linkedbhaag = _linkedshahar = _linkedgraam = _linkedmandal = _linkedvasti = _linkednagar = null;
                                    type = "prant";
                                  });
                                  populateDropdown();
                                },
                                child: Text(Statics.getLabel('clear'))),
                          ],
                        ),
                    ],
                  ),
                ),
                if (_showList == true)
                  Container(
                    height: 600,
                    child: FutureBuilder<List<dynamic>>(
                      future: _joinRSSList,
                      builder: (ctx, dataSnapshot) {
                        if (dataSnapshot.connectionState != ConnectionState.done) {
                          return Center(child: CircularProgressIndicator());
                        }
                        if (dataSnapshot.hasError) {
                          return Center(
                              child: Text(
                            'Server Error, Please Try Again Later',
                            style: TextStyle(color: Colors.red),
                          ));
                        }
                        _isSearching = false;
                        return dataSnapshot.hasData && dataSnapshot.data!.length > 0
                            ? ListView.builder(
                                shrinkWrap: true,
                                itemCount: dataSnapshot.data!.length,
                                itemBuilder: (context, index) {
                                  return JoinRSSCard(dataSnapshot.data![index], _searchNew);
                                })
                            // Column(
                            //         children: dataSnapshot.data!.map((joinRSSItem) =>
                            //
                            //             JoinRSSCard(joinRSSItem , _searchNew)
                            //         ).toList(),
                            //       )
                            : Center(child: Text(Statics.getLabel('noDataFoundTryAnotherSearch')));
                      },
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Future<List<dynamic>> _getJoinRSSLst(int geoUnitID, int statusID,
//     String searchString, String fromDate, String toDate) async {
//   bool isConnected = await Statics.isInternetConnected();
//   if (isConnected) {
//     String strInput = json.encode({
//       "AppUserID": Statics.userDetails['userID'],
//       "SearchCriteria": searchString,
//       "GeoUnitID": geoUnitID,
//       "StatusID": statusID,
//       "JoiningDateFrom": fromDate,
//       "JoiningDateTo": toDate
//     });
//     return Statics.getJoinRSSList(strInput);
//   } else {
//     Statics.showMessageDialog(
//         context, Statics.getLabel('internetNotConnected'));
//     return null;
//   }
// }

// Future<void> _search(var outputType) async {
//   setState(() {
//     _isSearching = true;
//   });
//   int bhaagVal = _bhaagValue == null || _bhaagValue == ""
//       ? null
//       : int.parse(_bhaagValue);
//   int shaharVal = _shaharValue == null || _shaharValue == ""
//       ? null
//       : int.parse(_shaharValue);
//   int nagarVal = _nagarValue == null || _nagarValue == ""
//       ? null
//       : int.parse(_nagarValue);
//   int statusVal = _statusValue == null || _statusValue == ""
//       ? null
//       : int.parse(_statusValue);
//   int geoUnitID;
//   geoUnitID = nagarVal != null
//       ? nagarVal
//       : shaharVal != null
//           ? shaharVal
//           : bhaagVal != null
//               ? bhaagVal
//               : null;
//   var frmDate =
//       _fromDate == null ? null : DateFormat('yyyy-MM-dd').format(_fromDate);
//   var toDate =
//       _toDate == null ? null : DateFormat('yyyy-MM-dd').format(_toDate);
//   if (outputType == "Export") {
//     var list = await _getJoinRSSLst(
//         geoUnitID, statusVal, _searchController.text, frmDate, toDate);
//     _getCsv(list);
//     _isSearching = false;
//     _isExpanded = false;
//   } else {
//     setState(() {
//       _joinRSSList = _getJoinRSSLst(
//         geoUnitID, statusVal, _searchController.text, frmDate, toDate);
//       _isSearching = false;
//       _isExpanded = false;
//     });
//     _getStatuswiseCount(
//         geoUnitID, statusVal, _searchController.text, frmDate, toDate);
//   }
// }
// Future<void> _getStatuswiseCount(int geoUnitID, int statusID,
//     String searchString, String fromDate, String toDate) async {
//   bool isConnected = await Statics.isInternetConnected();

//   if (!isConnected) {
//     Statics.showMessageDialog(
//         context, Statics.getLabel('internetNotConnected'));
//   } else {
//     var data = await Statics.getJoinRSSGridByStatus(geoUnitID, statusID,
//         searchString == "" ? null : searchString, fromDate, toDate);
//     if (data != null && data.length > 0) {
//       await getDetailsColumnsandRows(data);
//     } else {
//       if (!mounted) return;
//       setState(() {
//         _detailsColumns = null;
//         _detailsRows = null;
//       });
//     }
//   }
// }

// void getDetailsColumnsandRows(List<dynamic> dataList) async {
//   List<DataColumn> cols = [];

//   cols.add(new DataColumn(label: Text('Status')));
//   cols.add(new DataColumn(label: Text('Male Count')));
//   cols.add(new DataColumn(label: Text('Female Count')));

//   List<DataRow> row = [];
//   int totMen = 0;
//   int totWomen = 0;
//   for (var data in dataList) {
//     List<DataCell> cells = [];

//     cells.add(new DataCell(Text(data["StatusCode"].toString())));
//     cells.add(new DataCell(Text(data["MaleCountByStatus"] == null
//         ? "-"
//         : data["MaleCountByStatus"].toString())));
//     cells.add(new DataCell(Text(data["FemaleCountByStatus"] == null
//         ? "-"
//         : data["FemaleCountByStatus"].toString())));

//     row.add(new DataRow(cells: cells));
//     totMen = totMen +
//         (data["MaleCountByStatus"] == null ? 0 : data["MaleCountByStatus"]);
//     totWomen = totWomen +
//         (data["FemaleCountByStatus"] == null
//             ? 0
//             : data["FemaleCountByStatus"]);
//   }
//   List<DataCell> cells = [];
//   cells.add(new DataCell(Text("Total",
//       style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15))));
//   cells.add(new DataCell(Text(
//       totMen.toString() + "-M & " + totWomen.toString() + "-F",
//       style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15))));
//   cells.add(new DataCell(Text("Total: " + (totMen + totWomen).toString(),
//       style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15))));
//   row.add(new DataRow(cells: cells));
//   if (!mounted) return;
//   setState(() {
//     _detailsColumns = cols;
//     _detailsRows = row;
//   });
// }
