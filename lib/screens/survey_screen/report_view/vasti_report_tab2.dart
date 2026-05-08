import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../helpers/static_data.dart' as Statics;
import '../../../models/response_model/dropdown_level_responsemodel.dart';
import '../../../models/response_model/vasti_survey_report_model.dart';
import '../../../providers/bals.dart';
import '../../../utils/globals.dart';
import '../../../widgets/single_column_row.dart';
import '../../../widgets/two_column_row.dart';

class VastiSurveyReportTab2 extends StatefulWidget {
  static const String routeName = '/vasti-survey-report-tab2';

  const VastiSurveyReportTab2({super.key});

  @override
  State<VastiSurveyReportTab2> createState() => _VastiSurveyReportTab2State();
}

class _VastiSurveyReportTab2State extends State<VastiSurveyReportTab2> {
  @override
  void initState() {
    super.initState();
    // populateDropdown();
    getGeoUnitID();
    // getMyDetailsColumnsAndRows();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => initData());
  }

  Future<void> initData() async {
    DropDownModel dm = await MyAppGlobals.getLevelLDB();

    setState(() {
      userLevelId = dm.levelID;
      userGeoUnitId = dm.geoUnitID;
      ddm = dm;
    });
    await populateDropdown();
  }

  bool _isExpanded = true;
  bool isVastiSearch = false;
  List<GeoUnitMasterBAL>? _linkedMahaanagar;
  List<GeoUnitMasterBAL>? _linkedVibhaag;
  List<GeoUnitMasterBAL>? _linkedBhaag;
  List<GeoUnitMasterBAL>? _linkedupnagar;
  List<GeoUnitMasterBAL>? _linkedNagar;
  List<GeoUnitMasterBAL>? _linkedvasti;
  List<StaticMasterBAL>? _baithakTypes;
  String? _linkedMahaanagarValue = '';
  String? _linkedVibhaagValue = '';
  String? _linkedBhaagValue = '';
  String? _linkedupnagarValue = '';
  String? _linkedNagarValue = '';
  String? _linkedvastiValue = '';
  String? mahanagarId = '';
  String? vibhagId = '';
  String? selctedLevel = 'praant';
  String? selctedLevelName = '';
  String? selctedLevelId = '';
  String? selctedLevelNameNew = '';
  String? selctedLevelIdNew = '';

  String? _linkedbhaagName = '';
  String? _linkedshaharName = '';
  String? _linkednagarName = '';
  String? _linkedupnagarName = '';
  String? _linkedmandalName = '';
  String? _linkedgraamName = '';
  String? _linkedvastiName = '';

  String? _selctedLevel = 'praant';
  String? _selctedLevelName = '';
  String _selctedLevelNames = '';
  List<String?> _selctedLevelNameList = [];
  String? _selectedGeoUnitId;

  //=====================================  NEW  ADD ========================================================================================
  final rowTitles = [
    "${Statics.getLabel('Shaakhaa')}",
    "${Statics.getLabel('SaaptaahikMilan')}",
    "${Statics.getLabel('MaasikMilan')}",
    "${Statics.getLabel('isNewSankalpitShakha')}",
    "${Statics.getLabel('isNewSankalpitSaptahikMilan')}",
    "${Statics.getLabel('isNewSankalpitMaasikMilan')}",
    "${Statics.getLabel('purviShakhaHoti')}",
    "${Statics.getLabel('isBeforeSaaptahikMilan')}",
  ];

  String getCellValueByRowIndex(SanghaKaryaStithiData e, int index) {
    switch (index) {
      case 0:
        return (e.shaakhaaCount ?? 0).toString();
      case 1:
        return (e.saaptaahikCount ?? 0).toString();
      case 2:
        return (e.maasikMilanCount ?? 0).toString();
      case 3:
        return (e.sankalpitShaakhaaCount ?? 0).toString();
      case 4:
        return (e.sankalpitSaaptaahikCount ?? 0).toString();
      case 5:
        return (e.sankalpitMaasikMilanCount ?? 0).toString();
      case 6:
        return e.purviShaakhaa?.isNotEmpty == true ? e.purviShaakhaa! : '-';
      case 7:
        return e.purviSaptahik?.isNotEmpty == true ? e.purviSaptahik! : '-';
      default:
        return '';
    }
  }

  var geoUnitID;
  var geoUnitName;

  Future<List<GeoUnitMasterBAL>> populatelinkedMahaanagarDropdown() async {
    final data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['MahaanagarLevelID'].toString(), '', '', '', isAbhiyaan: false);
    setState(() => _linkedMahaanagar = data);
    return data;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedVibhaagDropdown(String mahaanagarIDStr) async {
    _linkedBhaagValue = _linkedNagarValue = _linkedvastiValue = null;
    final data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['VibhaagLevelID'].toString(), mahaanagarIDStr, mahaanagarIDStr.isEmpty ? '' : 'Mahaanagar', '', isAbhiyaan: false);
    setState(() => _linkedVibhaag = data);
    return data;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedBhaagDropdown(String vibhaagIDStr) async {
    _linkedBhaagValue = _linkedNagarValue = _linkedvastiValue = null;
    _linkedbhaagName = _linkednagarName = _linkedmandalName = _linkedgraamName = _linkedvastiName = null;
    _linkedBhaag = _linkedNagar = _linkedvasti = [];
    final data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['BhaagLevelID'].toString(), vibhaagIDStr, 'Vibhaag', '', isAbhiyaan: false);
    setState(() => _linkedBhaag = data);
    return data;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedNagarDropdown(String? bhaagIDStr, String? shaharIDStr) async {
    _linkedNagarValue = _linkedvastiValue = null;
    _linkednagarName = _linkedmandalName = _linkedgraamName = _linkedvastiName = null;
    _linkedNagar = _linkedvasti = null;
    final parentID = shaharIDStr ?? bhaagIDStr!;
    final parentType = shaharIDStr != null ? 'Shahar' : 'Bhaag';
    final data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['NagarLevelID'].toString(), parentID, parentType, '', isAbhiyaan: false);
    setState(() => _linkedNagar = data.isNotEmpty ? data : null);
    return data;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedUpnagarDropdown(String? nagarIDStr) async {
    _linkedupnagarValue = _linkedvastiValue = null;
    _linkedupnagarName = _linkedmandalName = _linkedgraamName = null;
    _linkedupnagar = _linkedvasti = null;
    var mnDD;

    mnDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['UpaNagarLevelID'].toString(), nagarIDStr!, 'Nagar', '');

    setState(() {
      _linkedupnagar = (mnDD.length > 0 ? mnDD : null);
      //_linkedupnagarValue = (userparentUpanagarid ?? userGeoUnitId).toString();
    });
    return mnDD;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedVastiDropdown(String? nagarIDStr) async {
    _linkedvastiValue = null;
    _linkedvastiName = null;
    final data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['VastiLevelID'].toString(), nagarIDStr!, 'Nagar', '', isAbhiyaan: false);
    setState(() => _linkedvasti = data.isNotEmpty ? data : null);
    return data;
  }

  void resetData() async {
    setState(() {
      _linkedMahaanagarValue = null;
      _linkedVibhaagValue = null;
      _linkedBhaagValue = null;
      _linkedNagarValue = null;
      mahanagarId = '';
      selctedLevelName = "";
      selctedLevel = 'praant';
      _linkedvastiValue = '';
      selctedLevelId = '';
      selctedLevelName = "";
      _linkedBhaag = null;
      _linkedNagar = null;
      _linkedvasti = null;
      isVastiSearch = false;
      selctedLevelName = '';
      _isExpanded = false;
      populateDropdown();
    });
  }

  void getGeoUnitID() async {
    setState(() {
      geoUnitID = Statics.userDetails["DaayitvaGeoUnitID"];
      geoUnitName = Statics.userDetails["DaayitvaGeoUnitName"] + "-" + Statics.userDetails["LevelName"];
    });
  }

  VastiSurveyReportModel? vastiSurveyReportModel;
  Vastisarvekshan? data;

  void getMyDetailsColumnsAndRows() async {
    vastiSurveyReportModel = await Statics.vastisarvekshanReportData(context, Statics.userDetails["userID"], selctedLevelId);
    setState(() {
      data = vastiSurveyReportModel!.vastisarvekshan;
    });
  }

  Future<void> populateAllDropdowns(int level, DropDownModel dm) async {
    setState(() {
      _selectedGeoUnitId = _linkedMahaanagarValue = _linkedBhaagValue = _linkedNagarValue = _linkedvastiValue = null;
    });
    final selection = prepareSelection(dm);

    // Step 1: Mahaanagar
    await populatelinkedMahaanagarDropdown();
    _linkedMahaanagarValue = (level == 9 ? (dm.geoUnitID ?? 0).toString() : selection.mahaanagar) ?? _linkedMahaanagarValue;
    if (level == 9) {
      _selectedGeoUnitId = (dm.geoUnitID ?? selection.mahaanagar).toString();
      _selctedLevel = 'Mahaanagar';
    }

    // Step 2: Vibhaag
    await populatelinkedVibhaagDropdown(_linkedMahaanagarValue!);
    _linkedVibhaagValue = (level == 8 ? (dm.geoUnitID ?? 0).toString() : selection.vibhaag) ?? _linkedVibhaagValue;
    if (level == 8) {
      _selectedGeoUnitId = (dm.geoUnitID ?? selection.vibhaag).toString();
      _selctedLevel = 'Vibhaag';
    }

    // Step 3: Bhaag
    await populatelinkedBhaagDropdown(_linkedVibhaagValue!);
    _linkedBhaagValue = (level == 7 ? (dm.geoUnitID ?? 0).toString() : selection.bhaag) ?? _linkedBhaagValue;
    if (level == 7) {
      _selectedGeoUnitId = (dm.geoUnitID ?? selection.bhaag).toString();
      _selctedLevel = 'Bhaag';
    }

    // Step 4: Nagar
    await populatelinkedNagarDropdown(_linkedBhaagValue, null);
    _linkedNagarValue = (level == 6 ? (dm.geoUnitID ?? 0).toString() : selection.nagar) ?? _linkedNagarValue;
    if (level == 6) {
      _selectedGeoUnitId = (dm.geoUnitID ?? selection.nagar).toString();
      _selctedLevel = 'Nagar';
    }

    // Step 5: Upnagar (conditional)
    if (selection.upnagar != null && selection.upnagar!.isNotEmpty) {
      await populatelinkedUpnagarDropdown(_linkedNagarValue);
      _linkedupnagarValue = (level == 13 ? (dm.geoUnitID ?? 0).toString() : selection.upnagar) ?? _linkedupnagarValue;
      if (level == 13) {
        _selectedGeoUnitId = (dm.geoUnitID ?? selection.upnagar).toString();
        _selctedLevel = 'Upnagar';
      }
    }
    // // Step 7: Graam
    // await populatelinkedGraamDropdown(_linkedmandalValue);
    // _selectedGeoUnitId = _linkedgraamValue = (level == 3 ? (dm.geoUnitID ?? "").toString() : selection.graam) ?? '';
    //
    // // Step 8: Vasti
    // await populatelinkedVastiDropdown(_linkedNagarValue);
    // _selectedGeoUnitId = _linkedvastiValue = (level == 2 ? (dm.geoUnitID ?? "").toString() : selection.vasti) ?? '';

    // if (_linkedVibhaag != null && _linkedVibhaag!.isNotEmpty) _linkedVibhaagName = _linkedVibhaag!.firstWhere((bg) => bg.geoUnitID.toString() == _linkedBhaagValue).name;
    // if (_linkedBhaag != null && _linkedBhaag!.isNotEmpty) _linkedbhaagName = _linkedBhaag!.firstWhere((bg) => bg.geoUnitID.toString() == _linkedBhaagValue).name;
    // if (_linkedNagar != null && _linkedNagar!.isNotEmpty) _linkednagarName = _linkedNagar!.firstWhere((bg) => bg.geoUnitID.toString() == _linkedBhaagValue).name;

    setState(() {});
  }

  Future<void> populateDropdown({bool fromClear = false}) async {
    setState(() {
      _linkedMahaanagarValue = _linkedBhaagValue = _linkedNagarValue = _linkedvastiValue = null;
      _linkedMahaanagar = _linkedVibhaag = _linkedBhaag = _linkedNagar = _linkedupnagar = null;
      _selctedLevelName = _selectedGeoUnitId = null;
      _selctedLevel = "praant";
    });
    await populatelinkedMahaanagarDropdown();
    await populatelinkedVibhaagDropdown('');
    if (fromClear || userLevelId == null || ddm == null) {
      print("object is null");
      return;
    }
    print("object is not null >>>>>>>>>>>>>>>>>>>>>>");
    await populateAllDropdowns(userLevelId!, ddm!);
    var data = await Statics.getStaticLDB('AnnualBaithakType');
    // populatelinkedMahaanagarDropdown();
    // populatelinkedVibhaagDropdown('');
    if (!mounted) return;
    _baithakTypes = data;
    _baithakTypes = _baithakTypes!.where((element) => element.showAnnualBaithakkey!.contains('1')).toList();
    print("_baithakTypes :-- $_baithakTypes");
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final sanghaData = data?.sanghaKaryaStithiData ?? [];
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Container(
              //   decoration: BoxDecoration(
              //       border: Border.all(
              //         color: Colors.grey,
              //       ),
              //       borderRadius: BorderRadius.all(Radius.circular(15))),
              //   child: ExpansionPanelList(
              //     expansionCallback: (int index, bool isExpanded) {
              //       setState(() {
              //         _isExpanded = isExpanded;
              //       });
              //     },
              //     dividerColor: Colors.black,
              //     expandIconColor: Colors.purpleAccent,
              //     elevation: 0,
              //     children: [
              //       ExpansionPanel(
              //         backgroundColor: Colors.transparent,
              //         headerBuilder: (BuildContext context, bool isExpanded) {
              //           return ListTile(
              //             title: Text("${Statics.getLabel('selectStar')}", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
              //             trailing: IconButton(
              //                 onPressed: () {
              //                   resetData();
              //                 },
              //                 icon: Icon(
              //                   Icons.refresh,
              //                   color: Colors.purpleAccent,
              //                 )),
              //           );
              //         },
              //         body: Container(
              //           margin: EdgeInsets.symmetric(horizontal: 20),
              //           child: Column(
              //             children: [
              //               if (_linkedMahaanagar != null)
              //                 DropdownButtonFormField(
              //                   decoration: InputDecoration(labelText: "${Statics.getLabel('mahaanagar')}"),
              //                   isExpanded: true,
              //                   value: _linkedMahaanagarValue == "" ? null : _linkedMahaanagarValue,
              //                   items: _linkedMahaanagar!
              //                       .map((bg) => DropdownMenuItem(
              //                             value: bg.geoUnitID.toString(),
              //                             child: Text(bg.name!),
              //                           ))
              //                       .toList(),
              //                   onChanged: (value) {
              //                     final selectedItem = _linkedMahaanagar!.firstWhere((bg) => bg.geoUnitID.toString() == value);
              //                     setState(() {
              //                       _linkedMahaanagarValue = value;
              //                       _linkedVibhaagValue = null;
              //                       _linkedBhaagValue = null;
              //                       _linkedNagarValue = null;
              //                       populatelinkedVibhaagDropdown(value!);
              //                       mahanagarId = value;
              //                       selctedLevelId = value;
              //                       selctedLevelName = selectedItem.name ?? "";
              //                       selctedLevel = 'Mahanagar';
              //                     });
              //                     print("Selected Id: $value");
              //                     print("Selected Level Name: ${selectedItem.name}");
              //                   },
              //                 ),
              //               SizedBox(
              //                 height: 10,
              //               ),
              //               if (_linkedVibhaag != null)
              //                 DropdownButtonFormField(
              //                   decoration: InputDecoration(labelText: "${Statics.getLabel('vibhaag')}"),
              //                   isExpanded: true,
              //                   value: _linkedVibhaagValue == "" ? null : _linkedVibhaagValue,
              //                   items: _linkedVibhaag!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
              //                   onChanged: (value) {
              //                     final selectedItem = _linkedVibhaag!.firstWhere((bg) => bg.geoUnitID.toString() == value);
              //                     print(value);
              //                     setState(() {
              //                       _linkedVibhaagValue = value;
              //                       populatelinkedBhaagDropdown(value!);
              //                       vibhagId = value;
              //                       _linkedBhaagValue = _linkedNagarValue = null;
              //                       _linkedBhaag = _linkedNagar = null;
              //                       selctedLevelId = value;
              //                       selctedLevelName = selectedItem.name ?? "";
              //                       selctedLevel = 'Vibhaag';
              //                     });
              //                     print("Selected Id: $value");
              //                     print("Selected Level Name: ${selectedItem.name}");
              //                   },
              //                 ),
              //               SizedBox(
              //                 height: 10,
              //               ),
              //               if (_linkedBhaag != null)
              //                 DropdownButtonFormField(
              //                   decoration: InputDecoration(labelText: Statics.getLabel('Bhaag')),
              //                   isExpanded: true,
              //                   value: _linkedBhaagValue == "" ? null : _linkedBhaagValue,
              //                   items: _linkedBhaag!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
              //                   onChanged: (value) {
              //                     final selectedItem = _linkedBhaag!.firstWhere((bg) => bg.geoUnitID.toString() == value);
              //                     setState(() {
              //                       _linkedBhaagValue = value;
              //                       populatelinkedNagarDropdown(value, null);
              //                       selctedLevelId = value;
              //                       selctedLevelName = selectedItem.name ?? "";
              //                       selctedLevel = 'Bhaag';
              //                     });
              //                     print("Selected Id: $value");
              //                     print("Selected Level Name: ${selectedItem.name}");
              //                   },
              //                 ),
              //               SizedBox(
              //                 height: 10,
              //               ),
              //               if (_linkedNagar != null && _linkedNagar!.length > 0)
              //                 DropdownButtonFormField(
              //                   decoration: InputDecoration(labelText: "${Statics.getLabel('NagarShahari')}"),
              //                   isExpanded: true,
              //                   value: _linkedNagarValue == "" ? null : _linkedNagarValue,
              //                   items: _linkedNagar!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
              //                   onChanged: (value) {
              //                     final selectedItem = _linkedNagar!.firstWhere((bg) => bg.geoUnitID.toString() == value);
              //                     setState(() {
              //                       _linkedNagarValue = value;
              //                       populatelinkedVastiDropdown(value!);
              //                       selctedLevelId = value;
              //                       selctedLevelName = selectedItem.name ?? "";
              //                       selctedLevel = 'Nagar';
              //                     });
              //                     print("Selected Id: $value");
              //                     print("Selected Level Name: ${selectedItem.name}");
              //                   },
              //                 ),
              //               if (_linkedNagar != null && _linkedNagar!.length > 0)
              //                 SizedBox(
              //                   height: 10,
              //                 ),
              //               if (_linkedvasti != null && _linkedvasti!.length > 0)
              //                 DropdownButtonFormField(
              //                   decoration: InputDecoration(labelText: "${Statics.getLabel('vastiLabel')}"),
              //                   isExpanded: true,
              //                   value: _linkedvastiValue == "" ? null : _linkedvastiValue,
              //                   items: _linkedvasti!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
              //                   onChanged: (value) {
              //                     final selectedItem = _linkedvasti!.firstWhere((bg) => bg.geoUnitID.toString() == value);
              //                     setState(() {
              //                       _linkedvastiValue = value;
              //                       selctedLevelId = value;
              //                       selctedLevelName = selectedItem.name ?? "";
              //                       selctedLevel = 'Vasti';
              //                     });
              //                     print("Selected Id: $value");
              //                     print("Selected Level Name: ${selectedItem.name}");
              //                   },
              //                 ),
              //               if (_linkedvasti != null && _linkedvasti!.length > 0)
              //                 SizedBox(
              //                   height: 10,
              //                 ),
              //               if (selctedLevel == "Vasti")
              //                 Align(
              //                   alignment: Alignment.center,
              //                   child: ElevatedButton(
              //                     style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.purpleAccent)),
              //                     onPressed: () {
              //                       if (selctedLevel == "Vasti" || selctedLevel == "Graam") {
              //                         setState(() {
              //                           isVastiSearch = true;
              //                           _isExpanded = false;
              //                         });
              //                         print("selctedLevel $selctedLevel -- selctedLevelId $selctedLevelId -- selctedLevelName $selctedLevelName");
              //                         getMyDetailsColumnsAndRows();
              //                       } else {
              //                         Statics.showToast(Statics.getLabel('vastiGramValidation'));
              //                       }
              //                     },
              //                     child: Text("${Statics.getLabel('Filters')}", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              //                   ),
              //                 )
              //             ],
              //           ),
              //         ),
              //         isExpanded: _isExpanded,
              //       ),
              //     ],
              //   ),
              // ),
              vastiMandalDropdown(),
              if (selctedLevel == "Vasti" && selctedLevelName != "" && isVastiSearch == true)
                SizedBox(
                  height: 20,
                ),
              if (selctedLevel == "Vasti" && selctedLevelName != "" && isVastiSearch == true)
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
                          "${Statics.getLabel('Vasti')} ->  ",
                          style: TextStyle(color: Colors.purpleAccent, fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        Text(
                          " $selctedLevelName",
                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 17),
                        ),
                      ],
                    )),
              SizedBox(
                height: 20,
              ),
              Container(
                margin: EdgeInsets.symmetric(
                  horizontal: 10,
                ),
                child: Column(
                  children: [
                    commonExpansionTile(
                      title: 'VastiInfo',
                      children: [
                        SingleColumnRow(txtString: "${Statics.getLabel('vastiPramukhName')}", value: data?.vastiPramukhName, fontsize: 15),
                        SingleColumnRow(txtString: "${Statics.getLabel('vastiSamitiSadasyaCount')}", value: data?.vastiSamitiSadhyasyaCount.toString(), fontsize: 15),
                        SingleColumnRow(txtString: "${Statics.getLabel('vastitSewaVastiCount')}", value: data?.vastiSewaVastiCount.toString(), fontsize: 15),
                        SingleColumnRow(txtString: "${Statics.getLabel('vastichiLoksankhya')}", value: data?.vastichiLoksankhyaCount, fontsize: 15),
                        SingleColumnRow(txtString: "${Statics.getLabel('vastiBhougolikSima')}", value: data?.vastiBhougolikSima, fontsize: 15),
                        Column(
                          children: [
                            Center(
                              child: Container(
                                width: Statics.getDeviceSize(context).width * 0.84,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      child: Text("${Statics.getLabel('vastichhaNakashaa')}", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
                                    ),
                                    data?.vastichaNakasha != ""
                                        ? IconButton(
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return Container(
                                                    color: Colors.transparent,
                                                    padding: const EdgeInsets.all(20),
                                                    child: Column(
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        Align(
                                                          alignment: Alignment.topRight,
                                                          child: Container(
                                                            decoration: BoxDecoration(
                                                              color: Colors.red,
                                                              borderRadius: BorderRadius.circular(20),
                                                            ),
                                                            child: IconButton(
                                                              onPressed: () {
                                                                Navigator.of(context).pop();
                                                              },
                                                              icon: Icon(Icons.close, color: Colors.white),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(height: 10),
                                                        Expanded(
                                                          child: Image.network(
                                                            '${Statics.baseUrl}/Files/Vastisarvekshanforms/${data?.vastichaNakasha}',
                                                            fit: BoxFit.contain,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                            icon: Icon(
                                              FontAwesomeIcons.eye,
                                              color: Colors.purpleAccent,
                                              size: 20,
                                            ))
                                        : Text("-", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.red)),
                                  ],
                                ),
                              ),
                            ),
                            Center(
                              child: Container(
                                width: Statics.getDeviceSize(context).width,
                                child: Divider(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SingleColumnRow(
                            txtString: "${Statics.getLabel('fireBrigateCenterCount')}",
                            value: data?.vastiFireBrigade == 1
                                ? "${Statics.getLabel('ConfirmationYes')}"
                                : data?.vastiFireBrigade == 0
                                    ? "${Statics.getLabel('ConfirmationNo')}"
                                    : "-",
                            fontsize: 15),
                        SingleColumnRow(
                            txtString: "${Statics.getLabel('policeThaneChowki')}",
                            value: data?.vastiPoliceStation == 1
                                ? "${Statics.getLabel('ConfirmationYes')}"
                                : data?.vastiPoliceStation == 0
                                    ? "${Statics.getLabel('ConfirmationNo')}"
                                    : "-",
                            fontsize: 15),
                      ],
                    ),
//-----------------------------------------------------------------------------------------------------------------------
                    commonExpansionTile(
                      title: 'SwayamsevakCount',
                      children: [
                        SingleColumnRow(txtString: Statics.getLabel('TotalKaaryakartaaCount'), value: data?.totalSwayamsevakCount.toString(), fontsize: 15),
                        SingleColumnRow(txtString: Statics.getLabel('PratidnyitCount'), value: data?.pratidnyitCount.toString(), fontsize: 15),
                      ],
                    ),
                    commonExpansionTile(
                      title: 'SwayamsevakCountByAge',
                      children: [
                        SingleColumnRow(txtString: Statics.getLabel('Shishu'), value: data?.shishuCount.toString(), fontsize: 15),
                        SingleColumnRow(txtString: Statics.getLabel('Baal'), value: data?.baalCount.toString(), fontsize: 15),
                        SingleColumnRow(txtString: Statics.getLabel('TarunVidyaarthi'), value: data?.tarunVidyaarthiCount.toString(), fontsize: 15),
                        SingleColumnRow(txtString: Statics.getLabel('TarunVyavasaayee'), value: data?.tarunVyavasaayeeCount.toString(), fontsize: 15),
                        SingleColumnRow(txtString: Statics.getLabel('ProudhVyavasaayee'), value: data?.proudhaVyavasaayeeCount.toString(), fontsize: 15),
                        SingleColumnRow(txtString: Statics.getLabel('UnkownAge'), value: data?.unknownAgeCount.toString(), fontsize: 15),
                      ],
                    ),
                    commonExpansionTile(
                      title: 'ShikshitSwayamsevakCount',
                      children: [
                        SingleColumnRow(txtString: Statics.getLabel('PrarambhikShikshit'), value: data?.prarambhikShikshitCount.toString(), fontsize: 15),
                        SingleColumnRow(txtString: Statics.getLabel('PraathamikShikshit'), value: data?.praathamikShikshitCount.toString(), fontsize: 15),
                        SingleColumnRow(txtString: Statics.getLabel('PrathamVarshShikshit'), value: data?.prathamVarshaShikshitCount.toString(), fontsize: 15),
                        SingleColumnRow(txtString: Statics.getLabel('DwitiyaVarshShikshit'), value: data?.dwitiyaVarshaShikshitCount.toString(), fontsize: 15),
                        SingleColumnRow(txtString: Statics.getLabel('TrutiyaVarshShikshit'), value: data?.trutiyaVarshaShikshitCount.toString(), fontsize: 15),
                        SingleColumnRow(txtString: Statics.getLabel('NoShikshan'), value: data?.noShikshanCount.toString(), fontsize: 15),
                      ],
                    ),
                    commonExpansionTile(
                      title: 'KaaryakartaaCountByLevel',
                      children: [
                        TwoColumnRow(
                          txtString: Statics.getLabel('Shaakhaa'),
                          value: data?.dailyShaakhaaKaaryakartaaCount.toString(),
                          txtString2: Statics.getLabel('SaaptaahikLabelShort'),
                          value2: data?.saaptaahikMilanKaaryakartaaCount.toString(),
                          fontsize: 15,
                        ),
                        TwoColumnRow(
                          txtString: Statics.getLabel('MilanMandali'),
                          value: data?.maasikMilanKaaryakartaaCount.toString(),
                          txtString2: Statics.getLabel('VastiKaaryakartaaCount'),
                          value2: data?.vastiKaaryakartaaCount.toString(),
                          fontsize: 15,
                        ),
                        TwoColumnRow(
                          txtString: Statics.getLabel('GraamKaaryakartaaCount'),
                          value: data?.graamKaaryakartaaCount.toString(),
                          txtString2: Statics.getLabel('MandalKaaryakartaaCount'),
                          value2: data?.mandalKaaryakartaaCount.toString(),
                          fontsize: 15,
                        ),
                        TwoColumnRow(
                          txtString: Statics.getLabel('NagarKaaryakartaaCount'),
                          value: data?.nagarKaaryakartaaCount.toString(),
                          txtString2: Statics.getLabel('ShaharKaaryakartaaCount'),
                          value2: data?.shaharKaaryakartaaCount.toString(),
                          fontsize: 15,
                        ),
                        TwoColumnRow(
                          txtString: Statics.getLabel('BhaagKaaryakartaaCount'),
                          value: data?.bhaagKaaryakartaaCount.toString(),
                          txtString2: Statics.getLabel('VibhaagKaaryakartaaCount'),
                          value2: data?.vibhaagKaaryakartaaCount.toString(),
                          fontsize: 15,
                        ),
                        TwoColumnRow(
                          txtString: Statics.getLabel('MahaanagarKaaryakartaaCount'),
                          value: data?.mahaanagarKaaryakartaaCount.toString(),
                          txtString2: Statics.getLabel('PraantKaaryakartaaCount'),
                          value2: data?.praantKaaryakartaaCount.toString(),
                          fontsize: 15,
                        ),
                        TwoColumnRow(
                          txtString: Statics.getLabel('KshetraKaaryakartaaCount'),
                          value: data?.kshetraKaaryakartaaCount.toString(),
                          txtString2: Statics.getLabel('AkhilBhaaratiyaKaaryakartaaCount'),
                          value2: data?.akhilBhaaratiyaKaaryakartaaCount.toString(),
                          fontsize: 15,
                        ),
                        TwoColumnRow(
                          txtString: Statics.getLabel('PravaaseeKaaryakartaaCount'),
                          value: data?.pravaaseeKaaryakartaaCount.toString(),
                          txtString2: Statics.getLabel('TotalKaaryakartaaCount'),
                          value2: data?.totalKaaryakartaaCount.toString(),
                          fontsize: 15,
                        ),
                      ],
                    ),
//--------------------------------------------------------------------------------------------------------------------------
                    commonExpansionTile(
                      title: 'GatividhiAayaamSansthaaKaaryakartaaCount',
                      children: [
                        SingleColumnRow(txtString: Statics.getLabel('GatividhiKaaryakartaaCount'), value: data?.gatividhiKaaryakartaaCount.toString(), fontsize: 15),
                        SingleColumnRow(txtString: Statics.getLabel('AayaamKaaryakartaaCount'), value: data?.aayaamKaaryakartaaCount.toString(), fontsize: 15),
                        SingleColumnRow(txtString: Statics.getLabel('SanghaPreritSansthaaKaaryakartaaCount'), value: data?.sanghaPreritSansthaaKaaryakartaaCount.toString(), fontsize: 15),
                        SingleColumnRow(txtString: Statics.getLabel('SocialOrganizationKaaryakartaaCount'), value: data?.socialOrganizationKaaryakartaaCount.toString(), fontsize: 15),
                      ],
                    ),
                    commonExpansionTile(
                      title: 'Gatividhi',
                      children: [
                        if (data != null && data!.listKaaryakartaaCountByGatividhi != null)
                          Container(
                            // margin: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: DataTable(
                                headingRowColor: MaterialStateProperty.resolveWith(
                                  (states) => Colors.purpleAccent[200],
                                ),
                                headingTextStyle: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                                columns: [
                                  DataColumn(label: Text("${Statics.getLabel('Gatividhi')}")),
                                  DataColumn(label: Text("${Statics.getLabel('KaaryakartaaCount')}")),
                                ],
                                rows: data!.listKaaryakartaaCountByGatividhi!.map((item) {
                                  return DataRow(
                                    cells: [
                                      DataCell(Text(item.gatividhiName ?? '')),
                                      DataCell(Center(child: Text(item.kaaryakartaaCount.toString() ?? "0"))),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                      ],
                    ),
                    commonExpansionTile(
                      title: 'Aayaam',
                      children: [
                        if (data != null && data!.listKaaryakartaaCountByAayaam != null)
                          Container(
                            // margin: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: DataTable(
                                headingRowColor: MaterialStateProperty.resolveWith(
                                  (states) => Colors.purpleAccent[200],
                                ),
                                headingTextStyle: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                                columns: [
                                  DataColumn(label: Text("${Statics.getLabel('Aayaam')}")),
                                  DataColumn(label: Text("${Statics.getLabel('KaaryakartaaCount')}")),
                                ],
                                rows: data!.listKaaryakartaaCountByAayaam!.map((item) {
                                  return DataRow(
                                    cells: [
                                      DataCell(Text(item.aayaamName ?? '')),
                                      DataCell(Center(child: Text(item.kaaryakartaaCount.toString() ?? "0"))),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                      ],
                    ),
                    commonExpansionTile(
                      title: 'Sangha-PreritSansthaa',
                      children: [
                        if (data != null && data!.listSanghaPreritSansthaaKaaryakartaaCountByAreaOfOperation != null)
                          Container(
                            // margin: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: DataTable(
                                headingRowColor: MaterialStateProperty.resolveWith(
                                  (states) => Colors.purpleAccent[200],
                                ),
                                headingTextStyle: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                                columns: [
                                  DataColumn(label: Text("${Statics.getLabel('sanghaPreritSanghatana')}")),
                                  DataColumn(label: Text("${Statics.getLabel('KaaryakartaaCount')}")),
                                ],
                                rows: data!.listSanghaPreritSansthaaKaaryakartaaCountByAreaOfOperation!.map((item) {
                                  return DataRow(
                                    cells: [
                                      DataCell(Text(item.areaOfOperation ?? '')),
                                      DataCell(Center(child: Text(item.kaaryakartaaCount.toString() ?? "0"))),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                      ],
                    ),
                    commonExpansionTile(
                      title: 'OtherSocialOrganization',
                      children: [
                        if (data != null && data!.listSocialOrganizationKaaryakartaaCountByAreaOfOperation != null)
                          Container(
                            // margin: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: DataTable(
                                headingRowColor: MaterialStateProperty.resolveWith(
                                  (states) => Colors.purpleAccent[200],
                                ),
                                headingTextStyle: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                                columns: [
                                  DataColumn(label: Text("${Statics.getLabel('OtherSocialOrganization')}")),
                                  DataColumn(label: Text("${Statics.getLabel('count')}")),
                                ],
                                rows: data!.listSocialOrganizationKaaryakartaaCountByAreaOfOperation!.map((item) {
                                  return DataRow(
                                    cells: [
                                      DataCell(Text(item.areaOfOperation ?? '')),
                                      DataCell(Center(child: Text(item.kaaryakartaaCount.toString() ?? "0"))),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                      ],
                    ),
                    commonExpansionTile(
                      title: 'StudentCategory',
                      children: [
                        if (data != null && data!.listSwayamsevakCountByStudentCategory != null)
                          Container(
                            // margin: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: DataTable(
                                headingRowColor: MaterialStateProperty.resolveWith(
                                  (states) => Colors.purpleAccent[200],
                                ),
                                headingTextStyle: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                                columns: [
                                  DataColumn(label: Text("${Statics.getLabel('StudentCategory')}")),
                                  DataColumn(label: Text("${Statics.getLabel('count')}")),
                                ],
                                rows: data!.listSwayamsevakCountByStudentCategory!.map((item) {
                                  return DataRow(
                                    cells: [
                                      DataCell(Text(item.studentCategoryName ?? '')),
                                      DataCell(Center(child: Text(item.countByStudentCategory.toString() ?? "0"))),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                      ],
                    ),
                    commonExpansionTile(
                      title: 'VyavasaayeeCategory',
                      children: [
                        Container(
                          // height: 300,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: SingleChildScrollView(
                              child: Column(
                            children: [
                              if (data != null && data!.listSwayamsevakCountByVyavasaayeeCategory != null)
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey.shade300),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal, // horizontal scroll
                                    child: SizedBox(
                                      width: 320,
                                      child: DataTable(
                                        headingRowColor: MaterialStateProperty.resolveWith(
                                          (states) => Colors.purpleAccent[200],
                                        ),
                                        headingTextStyle: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        columns: [
                                          DataColumn(
                                            label: Expanded(
                                              child: Center(
                                                child: Text(
                                                  "${Statics.getLabel('VyavasaayeeCategory')}",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(fontWeight: FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                          ),
                                          DataColumn(
                                            label: Expanded(
                                              child: Center(
                                                child: Text(
                                                  "${Statics.getLabel('count')}",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(fontWeight: FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                        rows: data!.listSwayamsevakCountByVyavasaayeeCategory!.map((item) {
                                          return DataRow(
                                            cells: [
                                              DataCell(Center(child: Text(item.vyavasaayeeCategoryName ?? ''))),
                                              DataCell(Center(child: Text(item.countByVyavasaayeeCategory.toString()))),
                                            ],
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          )),
                        ),
                      ],
                    ),
//----------------------------------------------------------------------------------------------------------------------
                    commonExpansionTile(
                      title: 'sanghaKaryaStithi',
                      children: [
                        if (data != null && data!.sanghaKaryaStithiData != null)
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Fixed First Column
                              DataTable(
                                headingRowColor: MaterialStateProperty.all(Colors.purpleAccent[200]),
                                headingTextStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                                columns: [
                                  DataColumn(label: Text("${Statics.getLabel('sanghaKaryaStithi')}")),
                                ],
                                rows: List<DataRow>.generate(
                                  rowTitles.length,
                                  (index) => DataRow(
                                    cells: [DataCell(Text(rowTitles[index]))],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: DataTable(
                                    headingRowColor: MaterialStateProperty.all(Colors.purpleAccent[200]),
                                    headingTextStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                                    columns: sanghaData.map((e) => DataColumn(label: Text(e.vayogatCode ?? ''))).toList(),
                                    rows: List<DataRow>.generate(
                                      rowTitles.length,
                                      (index) => DataRow(
                                        cells: sanghaData.map((e) {
                                          final value = getCellValueByRowIndex(e, index);
                                          return DataCell(Text(value));
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                      ],
                    ),
                    commonExpansionTile(
                      title: 'vasahatPrakar',
                      children: [
                        if (data != null && data!.vastiVasahatPrakar != null)
                          Container(
                            // margin: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal, // horizontal scroll
                              child: SizedBox(
                                width: 900, // total width of all columns
                                child: DataTable(
                                  headingRowColor: MaterialStateProperty.resolveWith(
                                    (states) => Colors.purpleAccent[200],
                                  ),
                                  columnSpacing: 20,
                                  headingTextStyle: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  columns: [
                                    DataColumn(label: Text("${Statics.getLabel('SelectFrequency')}")),
                                    DataColumn(label: Text("${Statics.getLabel('bhavanachenav')}")),
                                    DataColumn(label: Text("${Statics.getLabel('samparkSthiti')}")),
                                    DataColumn(label: Text("${Statics.getLabel('samparkSootraNaav')}")),
                                    DataColumn(label: Text("${Statics.getLabel('doorBhash')}")),
                                  ],
                                  rows: data!.vastiVasahatPrakar!.map((item) {
                                    return DataRow(
                                      cells: [
                                        DataCell(Text(item.selectedDropdownValueName ?? '')),
                                        DataCell(Text(item.bhavanachenav ?? '')),
                                        DataCell(Text(item.selectedDropdownValueName1 ?? '')),
                                        DataCell(Text(item.samparksootr ?? '')),
                                        DataCell(Text(item.doorabhaash ?? '')),
                                      ],
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    commonExpansionTile(
                      title: 'BhashaaBolnare',
                      children: [
                        if (data != null && data!.vastiVividhBhashaBolnare != null)
                          Container(
                            // margin: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal, // horizontal scroll
                              child: DataTable(
                                headingRowColor: MaterialStateProperty.resolveWith(
                                  (states) => Colors.purpleAccent[200],
                                ),
                                headingTextStyle: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                                columns: [
                                  DataColumn(label: Text("${Statics.getLabel('onlyBhasha')}")),
                                  DataColumn(label: Text("${Statics.getLabel('avgPersent')}")),
                                ],
                                rows: data!.vastiVividhBhashaBolnare!.map((item) {
                                  return DataRow(
                                    cells: [
                                      DataCell(Text(item.selectedDropdownValueName ?? '')),
                                      DataCell(Text(item.andaje ?? '')),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                      ],
                    ),

                    commonExpansionTile(
                      title: 'kontyaPraantChe',
                      children: [
                        if (data != null && data!.vastiKontyaPraantache != null)
                          Container(
                            // margin: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal, // horizontal scroll
                              child: DataTable(
                                headingRowColor: MaterialStateProperty.resolveWith(
                                  (states) => Colors.purpleAccent[200],
                                ),
                                headingTextStyle: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                                columns: [
                                  DataColumn(label: Text("${Statics.getLabel('praant')}")),
                                  DataColumn(label: Text("${Statics.getLabel('avgPersent')}")),
                                ],
                                rows: data!.vastiKontyaPraantache!.map((item) {
                                  return DataRow(
                                    cells: [
                                      DataCell(Text(item.selectedDropdownValueName ?? '')),
                                      DataCell(Text(item.andaje ?? '')),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                      ],
                    ),
                    commonExpansionTile(
                      title: 'religion',
                      children: [
                        Container(
                          // height: 500,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: SingleChildScrollView(
                              child: Column(
                            children: [
                              if (data != null && data!.vastiKontyaReligion != null)
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey.shade300),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal, // horizontal scroll
                                    child: DataTable(
                                      headingRowColor: MaterialStateProperty.resolveWith(
                                        (states) => Colors.purpleAccent[200],
                                      ),
                                      headingTextStyle: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      columns: [
                                        DataColumn(
                                          label: Expanded(
                                            child: Center(
                                              child: Text(
                                                "${Statics.getLabel('religion')}",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Expanded(
                                            child: Center(
                                              child: Text(
                                                "${Statics.getLabel('avgPersent')}",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                      rows: data!.vastiKontyaReligion!.map((item) {
                                        return DataRow(
                                          cells: [
                                            DataCell(Center(child: Text(item.selectedDropdownValueName ?? ''))),
                                            DataCell(Center(child: Text(item.andaje.toString()))),
                                          ],
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                            ],
                          )),
                        ),
                      ],
                    ),
                    commonExpansionTile(
                      title: 'UpsanaSthal',
                      children: [
                        if (data != null && data!.vastiUpasanaSthalInfo != null)
                          Container(
                            // margin: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal, // horizontal scroll
                              child: SizedBox(
                                width: 300,
                                child: DataTable(
                                  headingRowColor: MaterialStateProperty.resolveWith(
                                    (states) => Colors.purpleAccent[200],
                                  ),
                                  headingTextStyle: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  columns: [
                                    DataColumn(label: Text("${Statics.getLabel('UpasanaSthal')}")),
                                    DataColumn(label: Text("${Statics.getLabel('SelectFrequency')}")),
                                    DataColumn(label: Text("${Statics.getLabel('count')}")),
                                  ],
                                  rows: data!.vastiUpasanaSthalInfo!.map((item) {
                                    return DataRow(
                                      cells: [
                                        DataCell(Text(item.selectedDropdownValueName ?? '')),
                                        DataCell(Text(item.selectedDropdownValueName1 ?? '')),
                                        DataCell(Text(item.sankhya ?? '')),
                                      ],
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    commonExpansionTile(
                      title: 'sajareHonareSan',
                      children: [
                        if (data != null && data!.vastitSajareHonareSan != null)
                          Container(
                            // margin: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal, // horizontal scroll
                              child: SizedBox(
                                // width: 300,
                                child: DataTable(
                                  headingRowColor: MaterialStateProperty.resolveWith(
                                    (states) => Colors.purpleAccent[200],
                                  ),
                                  headingTextStyle: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  columns: [
                                    DataColumn(label: Text("${Statics.getLabel('SelectFrequency')}")),
                                    DataColumn(label: Text("${Statics.getLabel('aayojakSansthachiNave')}")),
                                    DataColumn(label: Text("${Statics.getLabel('aayojakNaav')}")),
                                  ],
                                  rows: data!.vastitSajareHonareSan!.map((item) {
                                    return DataRow(
                                      cells: [
                                        DataCell(Text("${item.selectedDropdownValueName} ${item.otherSajareSan != "" ? "- ${item.otherSajareSan}" : ""}")),
                                        DataCell(Text(item.ayojakasansthacinave ?? '')),
                                        DataCell(Text(item.ayojakancinave ?? '')),
                                      ],
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    commonExpansionTile(
                      title: 'sajareHonareKaryakram',
                      children: [
                        if (data != null && data!.vastiSamajikKaryakram != null)
                          Container(
                            // margin: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal, // horizontal scroll
                              child: SizedBox(
                                // width: 300,
                                child: DataTable(
                                  headingRowColor: MaterialStateProperty.resolveWith(
                                    (states) => Colors.purpleAccent[200],
                                  ),
                                  headingTextStyle: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  columns: [
                                    DataColumn(label: Text("${Statics.getLabel('SelectFrequency')}")),
                                    DataColumn(label: Text("${Statics.getLabel('aayojakSansthachiNave')}")),
                                    DataColumn(label: Text("${Statics.getLabel('aayojakNaav')}")),
                                  ],
                                  rows: data!.vastiSamajikKaryakram!.map((item) {
                                    return DataRow(
                                      cells: [
                                        DataCell(Text("${item.selectedDropdownValueName} ${item.otherKaryakram != "" ? "- ${item.otherKaryakram}" : ""}")),
                                        DataCell(Text(item.ayojakasansthacinave ?? '')),
                                        DataCell(Text(item.ayojakancinave ?? '')),
                                      ],
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    commonExpansionTile(
                      title: 'gatividhiUpakraam',
                      children: [
                        if (data != null && data!.vastiGatividhiUpkram != null)
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal, // horizontal scroll
                              child: SizedBox(
                                // width: 300,
                                child: DataTable(
                                  headingRowColor: MaterialStateProperty.resolveWith(
                                    (states) => Colors.purpleAccent[200],
                                  ),
                                  headingTextStyle: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  columns: [
                                    DataColumn(label: Text("${Statics.getLabel('Gatividhi')}")),
                                    DataColumn(label: Text("${Statics.getLabel('upkram')}")),
                                    DataColumn(label: Text("${Statics.getLabel('varamvarita')}")),
                                  ],
                                  rows: data!.vastiGatividhiUpkram!.map((item) {
                                    return DataRow(
                                      cells: [
                                        DataCell(Text(item.selectedDropdownValueName ?? '')),
                                        DataCell(Text(item.niyamitacalanareupakrama ?? '')),
                                        DataCell(Text("${item.selectedDropdownValueName1} ${item.otherVaranvarita != "" ? "- ${item.otherVaranvarita}" : ""}")),
                                      ],
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    commonExpansionTile(
                      title: 'JagranShreniUpkram',
                      children: [
                        if (data != null && data!.vastiJagranshreniInfo != null)
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal, // horizontal scroll
                              child: SizedBox(
                                // width: 300,
                                child: DataTable(
                                  headingRowColor: MaterialStateProperty.resolveWith(
                                    (states) => Colors.purpleAccent[200],
                                  ),
                                  headingTextStyle: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  columns: [
                                    DataColumn(label: Text("${Statics.getLabel('KaryaVibhaag')}")),
                                    DataColumn(label: Text("${Statics.getLabel('upkram')}")),
                                    DataColumn(label: Text("${Statics.getLabel('varamvarita')}")),
                                  ],
                                  rows: data!.vastiJagranshreniInfo!.map((item) {
                                    return DataRow(
                                      cells: [
                                        DataCell(Text(item.selectedDropdownValueName ?? '')),
                                        DataCell(Text(item.niyamitacalanareupakrama ?? '')),
                                        DataCell(Text("${item.selectedDropdownValueName1} ${item.otherVaranvarita != "" ? "- ${item.otherVaranvarita}" : ""}")),
                                      ],
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    commonExpansionTile(
                      title: 'BalopasanaKendra',
                      children: [
                        if (data != null && data!.vastiBalopasanaCenterInfo != null)
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal, // horizontal scroll
                              child: SizedBox(
                                // width: 300,
                                child: DataTable(
                                  headingRowColor: MaterialStateProperty.resolveWith(
                                    (states) => Colors.purpleAccent[200],
                                  ),
                                  headingTextStyle: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  columns: [
                                    DataColumn(label: Text("${Statics.getLabel('Name')}")),
                                    DataColumn(label: Text("${Statics.getLabel('Konasathi')}")),
                                    DataColumn(label: Text("${Statics.getLabel('shreni')}")),
                                  ],
                                  rows: data!.vastiBalopasanaCenterInfo!.map((item) {
                                    return DataRow(
                                      cells: [
                                        DataCell(Text(item.name ?? '')),
                                        DataCell(Text(item.konasathi ?? '')),
                                        DataCell(Text(item.selectedDropdownValueName ?? '')),
                                      ],
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),

                    commonExpansionTile(
                      title: 'SajjanShakti',
                      children: [
                        if (data != null && data!.vastiSajjanShaktiData != null)
                          Container(
                            // margin: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal, // horizontal scroll
                              child: SizedBox(
                                // width: 300,
                                child: DataTable(
                                  headingRowColor: MaterialStateProperty.resolveWith(
                                    (states) => Colors.purpleAccent[200],
                                  ),
                                  headingTextStyle: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  columns: [
                                    DataColumn(label: Text("${Statics.getLabel('Name')}")),
                                    DataColumn(label: Text("${Statics.getLabel('Address')}")),
                                    DataColumn(label: Text("${Statics.getLabel('doorBhash')}")),
                                    DataColumn(label: Text("${Statics.getLabel('shreni')}")),
                                    DataColumn(label: Text("${Statics.getLabel('sanstha')}")),
                                    DataColumn(label: Text("${Statics.getLabel('samparkSthiti')}")),
                                    DataColumn(label: Text("${Statics.getLabel('prbhaavkshetra')}")),
                                    DataColumn(label: Text("${Statics.getLabel('samparkSootraNaav')}")),
                                  ],
                                  rows: data!.vastiSajjanShaktiData!.map((item) {
                                    return DataRow(
                                      cells: [
                                        DataCell(Text(item.name ?? '')),
                                        DataCell(Text(item.address ?? '')),
                                        DataCell(Text(item.doorabhaash ?? '')),
                                        DataCell(Text(item.selectedDropdownValueName ?? '')),
                                        DataCell(Text(item.sanstheCheNaav ?? '')),
                                        DataCell(Text(item.selectedDropdownValueName1 ?? '')),
                                        DataCell(Text(item.selectedDropdownValueName2 ?? '')),
                                        DataCell(Text(item.samparkasutranava ?? '')),
                                      ],
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    commonExpansionTile(
                      title: 'anyaPrabhaviLok',
                      children: [
                        if (data != null && data!.vastiAnyaPrabhaviLok != null)
                          Container(
                            // margin: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal, // horizontal scroll
                              child: SizedBox(
                                // width: 300,
                                child: DataTable(
                                  headingRowColor: MaterialStateProperty.resolveWith(
                                    (states) => Colors.purpleAccent[200],
                                  ),
                                  headingTextStyle: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  columns: [
                                    DataColumn(label: Text("${Statics.getLabel('Name')}")),
                                    DataColumn(label: Text("${Statics.getLabel('Address')}")),
                                    DataColumn(label: Text("${Statics.getLabel('doorBhash')}")),
                                    DataColumn(label: Text("${Statics.getLabel('shreni')}")),
                                    DataColumn(label: Text("${Statics.getLabel('upshreni')}")),
                                    DataColumn(label: Text("${Statics.getLabel('upshreni2')}")),
                                    DataColumn(label: Text("${Statics.getLabel('samparkSthiti')}")),
                                    DataColumn(label: Text("${Statics.getLabel('prbhaavkshetra')}")),
                                    DataColumn(label: Text("${Statics.getLabel('samparkSootraNaav')}")),
                                  ],
                                  rows: data!.vastiAnyaPrabhaviLok!.map((item) {
                                    return DataRow(
                                      cells: [
                                        DataCell(Text(item.name ?? '')),
                                        DataCell(Text(item.address ?? '')),
                                        DataCell(Text(item.doorabhaash ?? '')),
                                        DataCell(Text(item.selectedDropdownValueName ?? '')),
                                        DataCell(Text("${item.selectedDropdownValueName1} ${item.otherupshrenee != "" ? "- ${item.otherupshrenee}" : ""}")),
                                        DataCell(Text("${item.selectedDropdownValueName2} ${item.otherupshrenee2 != "" ? "- ${item.otherupshrenee2}" : ""}")),
                                        DataCell(Text(item.selectedDropdownValueName3 ?? '')),
                                        DataCell(Text(item.selectedDropdownValueName4 ?? '')),
                                        DataCell(Text(item.samparkasutranav ?? '')),
                                      ],
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),

                    commonExpansionTile(
                      title: 'MotheVyasaayiKendra',
                      children: [
                        if (data != null && data!.vastiMotheVyasayikCenterInfo != null)
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal, // horizontal scroll
                              child: SizedBox(
                                // width: 300,
                                child: DataTable(
                                  headingRowColor: MaterialStateProperty.resolveWith(
                                    (states) => Colors.purpleAccent[200],
                                  ),
                                  headingTextStyle: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  columns: [
                                    DataColumn(label: Text("${Statics.getLabel('Name')}")),
                                    DataColumn(label: Text("${Statics.getLabel('SelectFrequency')}")),
                                  ],
                                  rows: data!.vastiMotheVyasayikCenterInfo!.map((item) {
                                    return DataRow(
                                      cells: [
                                        DataCell(Text(item.name ?? '')),
                                        DataCell(Text(item.selectedDropdownValueName ?? '')),
                                      ],
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    commonExpansionTile(
                      title: 'MotheRugnalay',
                      children: [
                        if (data != null && data!.vastiMotheHospitalInfo != null)
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal, // horizontal scroll
                              child: SizedBox(
                                // width: 300,
                                child: DataTable(
                                  headingRowColor: MaterialStateProperty.resolveWith(
                                    (states) => Colors.purpleAccent[200],
                                  ),
                                  headingTextStyle: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  columns: [
                                    DataColumn(label: Text("${Statics.getLabel('Name')}")),
                                    DataColumn(label: Text("${Statics.getLabel('SelectFrequency')}")),
                                  ],
                                  rows: data!.vastiMotheHospitalInfo!.map((item) {
                                    return DataRow(
                                      cells: [
                                        DataCell(Text(item.name ?? '')),
                                        DataCell(Text(item.selectedDropdownValueName ?? '')),
                                      ],
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    commonExpansionTile(
                      title: 'shaikshaniksansthaan',
                      children: [
                        Text(
                          "${Statics.getLabel('school1')}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.black,
                          ),
                        ),
                        Divider(),
                        if (data != null && data!.vastiShaikshanikSansthaData != null)
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal, // horizontal scroll
                              child: SizedBox(
                                // width: 300,
                                child: DataTable(
                                  headingRowColor: MaterialStateProperty.resolveWith(
                                    (states) => Colors.purpleAccent[200],
                                  ),
                                  headingTextStyle: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  columns: [
                                    DataColumn(label: Text("${Statics.getLabel('Name')}")),
                                    DataColumn(label: Text("${Statics.getLabel('school1')}")),
                                    // DataColumn(label: Text('शाळा प्रकार')),
                                    DataColumn(label: Text("${Statics.getLabel('shikshanacheMadhyam')}")),
                                    DataColumn(label: Text("${Statics.getLabel('sansthaCHalakPrakar')}")),
                                    DataColumn(label: Text("${Statics.getLabel('milkat')}")),
                                  ],
                                  rows: data!.vastiShaikshanikSansthaData!.asMap().entries.where((item) => item.value.shaikshaniksansthaan == 315).map((item) {
                                    var data = item.value;
                                    return DataRow(
                                      cells: [
                                        DataCell(Text(data.name ?? '')),
                                        DataCell(Text(data.selectedDropdownValueName1 ?? '')),
                                        // DataCell(Text(data.selectedDropdownValueName2 ?? '')),
                                        DataCell(Text(data.selectedDropdownValueName2 ?? '')),
                                        DataCell(Text(data.selectedDropdownValueName3 ?? '')),
                                        DataCell(Text(data.selectedDropdownValueName4 ?? '')),
                                      ],
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "${Statics.getLabel('College')}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.black,
                          ),
                        ),
                        Divider(),
                        if (data != null && data!.vastiShaikshanikSansthaData != null)
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal, // horizontal scroll
                              child: SizedBox(
                                // width: 300,
                                child: DataTable(
                                  headingRowColor: MaterialStateProperty.resolveWith(
                                    (states) => Colors.purpleAccent[200],
                                  ),
                                  headingTextStyle: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  columns: [
                                    DataColumn(label: Text("${Statics.getLabel('Name')}")),
                                    // DataColumn(label: Text("${Statics.getLabel('College')}")),
                                    DataColumn(label: Text("${Statics.getLabel('College')}")),
                                    DataColumn(label: Text("${Statics.getLabel('milkat')}")),
                                  ],
                                  rows: data!.vastiShaikshanikSansthaData!.asMap().entries.where((item) => item.value.shaikshaniksansthaan == 316).map((item) {
                                    var data = item.value;
                                    return DataRow(
                                      cells: [
                                        DataCell(Text(data.name ?? '')),
                                        // DataCell(Text(data.selectedDropdownValueName ?? '')),
                                        DataCell(Text(data.selectedDropdownValueName1 ?? '')),
                                        DataCell(Text(data.selectedDropdownValueName4 ?? '')),
                                      ],
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "${Statics.getLabel('vishisthaSansthan')}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.black,
                          ),
                        ),
                        Divider(),
                        if (data != null && data!.vastiShaikshanikSansthaData != null)
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal, // horizontal scroll
                              child: SizedBox(
                                // width: 300,
                                child: DataTable(
                                  headingRowColor: MaterialStateProperty.resolveWith(
                                    (states) => Colors.purpleAccent[200],
                                  ),
                                  headingTextStyle: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  columns: [
                                    DataColumn(label: Text("${Statics.getLabel('Name')}")),
                                    DataColumn(label: Text("${Statics.getLabel('milkat')}")),
                                  ],
                                  rows: data!.vastiShaikshanikSansthaData!.asMap().entries.where((item) => item.value.shaikshaniksansthaan == 317).map((item) {
                                    var data = item.value;
                                    return DataRow(
                                      cells: [
                                        DataCell(Text(data.name ?? '')),
                                        DataCell(Text(data.selectedDropdownValueName4 ?? '')),
                                      ],
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    commonExpansionTile(
                      title: 'MaidaanUdyan',
                      children: [
                        Container(
                          // height: 300,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: SingleChildScrollView(
                              child: Column(
                            children: [
                              if (data != null && data!.vastiMaidanListData != null)
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey.shade300),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal, // horizontal scroll
                                    child: DataTable(
                                      headingRowColor: MaterialStateProperty.resolveWith(
                                        (states) => Colors.purpleAccent[200],
                                      ),
                                      headingTextStyle: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      columns: [
                                        DataColumn(
                                          label: Expanded(
                                            child: Center(
                                              child: Text(
                                                "${Statics.getLabel('maiddanUdyyanNaav')}",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                      rows: data!.vastiMaidanListData!.map((item) {
                                        return DataRow(
                                          cells: [
                                            DataCell(Center(child: Text(item.name.toString()))),
                                          ],
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                            ],
                          )),
                        ),
                      ],
                    ),
                    commonExpansionTile(
                      title: 'karyakramKarnyacheThikaan',
                      children: [
                        if (data != null && data!.vastiKaryakramcheThikanData != null)
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal, // horizontal scroll
                              child: SizedBox(
                                // width: 300,
                                child: DataTable(
                                  headingRowColor: MaterialStateProperty.resolveWith(
                                    (states) => Colors.purpleAccent[200],
                                  ),
                                  headingTextStyle: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  columns: [
                                    DataColumn(label: Text("${Statics.getLabel('Name')}")),
                                    DataColumn(label: Text("${Statics.getLabel('SelectFrequency')}")),
                                    DataColumn(label: Text("${Statics.getLabel('shamta')}")),
                                    DataColumn(label: Text("${Statics.getLabel('NnivaasAvailable')}")),
                                    DataColumn(label: Text("${Statics.getLabel('nivaasShamta')}")),
                                  ],
                                  rows: data!.vastiKaryakramcheThikanData!.map((item) {
                                    return DataRow(
                                      cells: [
                                        DataCell(Text(item.name ?? '')),
                                        DataCell(Text(item.selectedDropdownValueName ?? '')),
                                        DataCell(Text(item.shamta ?? '')),
                                        DataCell(Text(item.nivasasathiupalabdha == 1
                                            ? "${Statics.getLabel('ConfirmationYes')}"
                                            : item.nivasasathiupalabdha == 0
                                                ? "${Statics.getLabel('ConfirmationNo')}"
                                                : "")),
                                        DataCell(Text(item.nivaaskshamata ?? '')),
                                      ],
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    commonExpansionTile(
                      title: 'VastiSamajikGarja',
                      children: [
                        if (data != null && data!.vastiSamajikGarajaData != null)
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal, // horizontal scroll
                              child: SizedBox(
                                // width: 300,
                                child: DataTable(
                                  headingRowColor: MaterialStateProperty.resolveWith(
                                    (states) => Colors.purpleAccent[200],
                                  ),
                                  headingTextStyle: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  columns: [
                                    DataColumn(label: Text("${Statics.getLabel('VastiSamajikGarja')}")),
                                    DataColumn(label: Text("${Statics.getLabel('tapshil')}")),
                                  ],
                                  rows: data!.vastiSamajikGarajaData!.map((item) {
                                    return DataRow(
                                      cells: [
                                        DataCell(Center(child: Text(item.name ?? ''))),
                                        DataCell(Text(item.selectedDropdownValueName ?? '')),
                                      ],
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    commonExpansionTile(
                      title: 'DharmikNetrutwa',
                      children: [
                        if (data != null && data!.vastiDharmiknetData != null)
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal, // horizontal scroll
                              child: SizedBox(
                                // width: 300,
                                child: DataTable(
                                  headingRowColor: MaterialStateProperty.resolveWith(
                                    (states) => Colors.purpleAccent[200],
                                  ),
                                  headingTextStyle: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  columns: [
                                    DataColumn(label: Text("${Statics.getLabel('Name')}")),
                                    DataColumn(label: Text("${Statics.getLabel('religion')}")),
                                  ],
                                  rows: data!.vastiDharmiknetData!.map((item) {
                                    return DataRow(
                                      cells: [
                                        DataCell(Center(child: Text(item.name ?? ''))),
                                        DataCell(Text(item.selectedDropdownValueName ?? '')),
                                      ],
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    commonExpansionTile(
                      title: 'DurjanShakti',
                      children: [
                        if (data != null && data!.vastiDurjanShaktiData != null)
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal, // horizontal scroll
                              child: SizedBox(
                                // width: 300,
                                child: DataTable(
                                  headingRowColor: MaterialStateProperty.resolveWith(
                                    (states) => Colors.purpleAccent[200],
                                  ),
                                  headingTextStyle: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  columns: [
                                    DataColumn(label: Text("${Statics.getLabel('Name')}")),
                                    DataColumn(label: Text("${Statics.getLabel('SelectFrequency')}")),
                                    DataColumn(label: Text("${Statics.getLabel('shiksha')}")),
                                    DataColumn(label: Text("${Statics.getLabel('crime')}")),
                                  ],
                                  rows: data!.vastiDurjanShaktiData!.map((item) {
                                    return DataRow(
                                      cells: [
                                        DataCell(Center(child: Text(item.name ?? ''))),
                                        DataCell(Text(item.selectedDropdownValueName ?? '')),
                                        DataCell(Text(item.selectedDropdownValueName1 ?? '')),
                                        DataCell(Text(item.selectedDropdownValueName2 ?? '')),
                                      ],
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    commonExpansionTile(
                      title: 'HinduVeerYaadi',
                      children: [
                        if (data != null && data!.vastiHinduVeerListData != null)
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal, // horizontal scroll
                              child: SizedBox(
                                width: 250,
                                child: DataTable(
                                  headingRowColor: MaterialStateProperty.resolveWith(
                                    (states) => Colors.purpleAccent[200],
                                  ),
                                  headingTextStyle: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  columns: [
                                    DataColumn(
                                      label: Expanded(
                                        // ensures center works properly
                                        child: Center(
                                          child: Text(
                                            "${Statics.getLabel('Name')}",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                  rows: data!.vastiHinduVeerListData!.map((item) {
                                    return DataRow(
                                      cells: [
                                        DataCell(Center(child: Text(item.name ?? ''))),
                                      ],
                                    );
                                  }).toList(),
                                ),
                              ),
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
    );
  }

  Widget vastiMandalDropdown() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(width: 0.7, color: Colors.grey.shade700),
      ),
      child: ExpansionPanelList(
        elevation: 0,
        expandedHeaderPadding: EdgeInsets.zero,
        expansionCallback: (_, isExpanded) => setState(() => _isExpanded = isExpanded),
        children: [
          ExpansionPanel(
            backgroundColor: Colors.transparent,
            headerBuilder: (_, __) => ListTile(
              title: Text(Statics.getLabel('selectVastiMandal'), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            ),
            body: Container(
              margin: const EdgeInsets.all(10),
              child: Column(
                children: [
                  if (_linkedMahaanagar != null)
                    buildDropdownField(
                      isDisabled: MyAppGlobals.isDropdownDisabled('Mahaanagar'),
                      label: Statics.getLabel('Mahaanagar'),
                      value: _linkedMahaanagarValue,
                      items: _linkedMahaanagar!.map((g) => DropdownMenuItem(value: g.geoUnitID.toString(), child: Text(g.name!))).toList(),
                      onChanged: (value) async {
                        final item = _linkedMahaanagar!.firstWhere((g) => g.geoUnitID.toString() == value);
                        setState(() {
                          _linkedMahaanagarValue = value;
                          _linkedVibhaagValue = null;
                          _selctedLevel = 'Mahanagar';
                          _selctedLevelName = item.name ?? "";
                          _selectedGeoUnitId = value;
                          selctedLevelId = value;
                        });
                        populatelinkedVibhaagDropdown(value!);
                        populatelinkedBhaagDropdown("");
                      },
                    ),
                  if (_linkedVibhaag != null)
                    buildDropdownField(
                      isDisabled: MyAppGlobals.isDropdownDisabled('Vibhaag'),
                      label: Statics.getLabel('Vibhaag'),
                      value: _linkedVibhaagValue,
                      items: _linkedVibhaag!.map((g) => DropdownMenuItem(value: g.geoUnitID.toString(), child: Text(g.name!))).toList(),
                      onChanged: (value) {
                        final item = _linkedVibhaag!.firstWhere((g) => g.geoUnitID.toString() == value);
                        setState(() {
                          _linkedVibhaagValue = value;
                          _selctedLevel = 'Vibhaag';
                          selctedLevelId = value;
                          _selctedLevelName = item.name ?? "";
                          _selectedGeoUnitId = value;
                        });
                        populatelinkedBhaagDropdown(value!);
                      },
                    ),
                  if (_linkedBhaag != null && _linkedBhaag!.isNotEmpty)
                    buildDropdownField(
                      isDisabled: MyAppGlobals.isDropdownDisabled('Bhaag'),
                      label: Statics.getLabel('Bhaag'),
                      value: _linkedBhaagValue,
                      items: _linkedBhaag!.map((g) => DropdownMenuItem(value: g.geoUnitID.toString(), child: Text(g.name!))).toList(),
                      onChanged: (value) {
                        final item = _linkedBhaag!.firstWhere((g) => g.geoUnitID.toString() == value);
                        setState(() {
                          _linkedBhaagValue = value;
                          _selctedLevel = 'Bhaag';
                          selctedLevelId = value;
                          _selctedLevelName = item.name ?? "";
                          _linkedbhaagName = item.name ?? "";
                          _selectedGeoUnitId = value;
                          populatelinkedNagarDropdown(value, null);
                        });
                      },
                    ),
                  // if (_linkedshahar != null && _linkedshahar!.isNotEmpty)
                  //   buildDropdownField(
                  //     isDisabled: MyAppGlobals.isDropdownDisabled('Nagar'),
                  //     label: Statics.getLabel('Shahar'),
                  //     value: _linkedshaharValue,
                  //     items: _linkedshahar!.map((g) => DropdownMenuItem(value: g.geoUnitID.toString(), child: Text(g.name!))).toList(),
                  //     onChanged: (value) {
                  //       final item = _linkedshahar!.firstWhere((g) => g.geoUnitID.toString() == value);
                  //       setState(() {
                  //         _linkedshaharValue = value;
                  //         _selectedGeoUnitId = value;
                  //         _selctedLevel = 'Shahar';
                  //         _selctedLevelName = item.name ?? "";
                  //         _linkedshaharName = item.name ?? "";
                  //         populatelinkedNagarDropdown(null, value);
                  //       });
                  //     },
                  //   ),
                  if (_linkedNagar != null && _linkedNagar!.isNotEmpty)
                    buildDropdownField(
                      isDisabled: MyAppGlobals.isDropdownDisabled('Nagar'),
                      label: Statics.getLabel('Nagar'),
                      value: _linkedNagarValue,
                      items: _linkedNagar!.map((g) => DropdownMenuItem(value: g.geoUnitID.toString(), child: Text(g.name!))).toList(),
                      onChanged: (value) {
                        final item = _linkedNagar!.firstWhere((g) => g.geoUnitID.toString() == value);
                        setState(() {
                          _linkedNagarValue = value;
                          _selectedGeoUnitId = value;
                          _selctedLevel = 'Nagar';
                          selctedLevelId = value;
                          _selctedLevelName = item.name ?? "";
                          _linkednagarName = item.name ?? "";
                          populatelinkedVastiDropdown(value!);
                        });
                      },
                    ),
                  if (_linkedupnagar != null && _linkedupnagar!.isNotEmpty)
                    buildDropdownField(
                      isDisabled: MyAppGlobals.isDropdownDisabled('upnagarUpkhanda'),
                      label: Statics.getLabel('upnagarUpkhanda'),
                      value: _linkedupnagarValue,
                      items: _linkedupnagar!
                          .map((bg) => DropdownMenuItem(
                                value: bg.geoUnitID.toString(),
                                child: Text(bg.name!),
                              ))
                          .toList(),
                      onChanged: MyAppGlobals.isDropdownDisabled('upnagarUpkhanda')
                          ? null
                          : (value) {
                              final selectedItem = _linkedupnagar!.firstWhere((bg) => bg.geoUnitID.toString() == value);
                              setState(() {
                                _linkedupnagarValue = value;
                                _selectedGeoUnitId = value;
                                _selctedLevel = 'upnagarUpkhanda';
                                selctedLevelId = value;
                                _selctedLevelName = selectedItem.name ?? "";
                                populatelinkedVastiDropdown(value!);

                                // populatelinkedNagarDropdown(null, value);
                              });
                            },
                    ),
                  if (_linkedvasti != null && _linkedvasti!.isNotEmpty)
                    buildDropdownField(
                      isDisabled: MyAppGlobals.isDropdownDisabled('Vasti'),
                      label: Statics.getLabel('Vasti'),
                      value: _linkedvastiValue,
                      items: _linkedvasti!.map((g) => DropdownMenuItem(value: g.geoUnitID.toString(), child: Text(g.name!))).toList(),
                      onChanged: (value) {
                        final item = _linkedvasti!.firstWhere((g) => g.geoUnitID.toString() == value);
                        setState(() {
                          _linkedvastiValue = value;
                          _selectedGeoUnitId = value.toString();
                          _selctedLevel = 'Vasti';
                          selctedLevelId = value;
                          _selctedLevelName = item.name ?? "";
                          _linkedvastiName = item.name ?? "";
                        });
                      },
                    ),
                  if (_linkedvasti != null && _linkedvasti!.length > 0)
                    SizedBox(
                      height: 10,
                    ),
                  if (_selctedLevel == "Vasti")
                    Align(
                      alignment: Alignment.center,
                      child: ElevatedButton(
                        style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.purpleAccent)),
                        onPressed: () {
                          if (_selctedLevel == "Vasti" || _selctedLevel == "Graam") {
                            setState(() {
                              isVastiSearch = true;
                              _isExpanded = false;
                            });
                            print("selctedLevel $_selctedLevel -- selctedLevelId $selctedLevelId -- selctedLevelName $selctedLevelName");
                            getMyDetailsColumnsAndRows();
                          } else {
                            Statics.showToast(Statics.getLabel('vastiGramValidation'));
                          }
                        },
                        child: Text("${Statics.getLabel('Filters')}", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    )
                ],
              ),
            ),
            isExpanded: _isExpanded,
          ),
        ],
      ),
    );
  }

  Widget commonExpansionTile({
    required String title,
    required List<Widget> children,
    bool initiallyExpanded = false,
  }) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Theme(
        data: ThemeData().copyWith(
          dividerColor: Colors.transparent, // removes the expansion line
        ),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16.0),
          title: Text(
            Statics.getLabel(title),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.purple,
            ),
          ),
          initiallyExpanded: initiallyExpanded,
          backgroundColor: Colors.transparent,
          collapsedBackgroundColor: Colors.transparent,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: children,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
