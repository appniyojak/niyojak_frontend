import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../helpers/static_data.dart' as Statics;
import '../../../models/response_model/get_vijayadashmi_report_resp_model.dart';
import '../../../providers/bals.dart';
import '../../../utils/cust_painters.dart';
import '../../../widgets/single_column_row.dart';

class HinduSanmelanReport extends StatefulWidget {
  static const String routeName = '/hindu_sanmelan-report-view';

  const HinduSanmelanReport({super.key});

  @override
  State<HinduSanmelanReport> createState() => _HinduSanmelanReportState();
}

class _HinduSanmelanReportState extends State<HinduSanmelanReport> {
  late ScrollController _scrollController;
  bool _searched = false;
  bool _isExpanded = true;
  bool _isLoading = false;

  List<GeoUnitMasterBAL>? _linkedMahaanagar;
  List<GeoUnitMasterBAL>? _linkedVibhaag;
  List<GeoUnitMasterBAL>? _linkedbhaag;
  List<GeoUnitMasterBAL>? _linkedshahar;
  List<GeoUnitMasterBAL>? _linkednagar;
  List<GeoUnitMasterBAL>? _linkedmandal;
  List<GeoUnitMasterBAL>? _linkedgraam;
  List<GeoUnitMasterBAL>? _linkedvasti;

  String? _linkedMahaanagarValue = '';
  String? _linkedVibhaagValue = '';
  String? _linkedbhaagValue = "";
  String? _linkedshaharValue = "";
  String? _linkednagarValue = "";
  String? _linkedNagarValuePopup = '';
  String? _linkedmandalValue = "";
  String? _linkedgraamValue = "";
  String? _linkedvastiValue = "";

  // String? _linkedMahaanagarName = '';
  // String? _linkedVibhaagName = '';
  String? _linkedbhaagName = "";
  String? _linkedshaharName = "";
  String? _linkednagarName = "";
  String? _linkedmandalName = "";
  String? _linkedgraamName = "";
  String? _linkedvastiName = "";

  String? _selctedLevel = 'praant';
  String? _selctedLevelName = '';
  String _selctedLevelNames = '';
  List<String?> _selctedLevelNameList = [];
  String? _selectedGeoUnitId;

  GetVijayadashamiReportModel? vijayadashamiReport;

  final List<bool> _expanded = List.generate(3, (_) => true);

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    populateDropdown();
  }

  //////////////////////////////////////////////////////////////////////////////////////

  Future<void> populateDropdown() async {
    setState(() {
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

  //////////////////////////////////////////////////////////////////////////////////////

  getReportDataFun() async {
    setState(() {
      vijayadashamiReport = null;
      _isLoading = true;
    });
    Map<String, dynamic> formData = {
      "GeoUnitID": int.tryParse(_selectedGeoUnitId.toString()) ?? null,
      "AppUserID": int.tryParse(Statics.userDetails['userID']) ?? null,
    };

    String formattedJson = const JsonEncoder.withIndent('  ').convert(formData);
    log("Form Data (JSON):\n$formattedJson");
    vijayadashamiReport = await Statics.getVijayaDashamiUtsavReportData(context, formData);
    // log("vijayadashamiReport >>>>>>>>>>>>>>>>> ${jsonDecode(jsonEncode(vijayadashamiReport))}");
    setState(() {
      _isLoading = false;
      vijayadashamiReport;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          Statics.getLabel('hinduSammelanReport'),
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        // actions: [IconButton(onPressed: getExcelReportDataFun, icon: Icon(Icons.download))],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          children: [
            SizedBox(height: 20),
            _buildExpansionPanel(),
            SizedBox(height: 20),
            if (_selctedLevel != "" && _selctedLevelName != "")
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
                        "${Statics.getLabel(_selctedLevel ?? "Mahaanagar")}  ->  ",
                        style: TextStyle(color: Colors.purpleAccent, fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Text(
                        " $_selctedLevelName",
                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 17),
                      ),
                    ],
                  )),
            SizedBox(height: 10),
            Divider(color: Colors.black),
            SizedBox(height: 10),
            if (_isLoading) SizedBox(height: MediaQuery.sizeOf(context).height * 0.2, child: Center(child: CircularProgressIndicator())),
            if (vijayadashamiReport?.vijayadashaminagarlist != null && vijayadashamiReport?.vijayadashaminagarlist != []) buildMarathiDataTable(vijayadashamiReport!.vijayadashaminagarlist!),
            SizedBox(height: 18),
            if (vijayadashamiReport?.vijayadashamiReport != null) buildCountCards(vijayadashamiReport!.vijayadashamiReport!),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget buildCountCards(VijayadashamiReport data) {
    int calculateTotalMale() {
      final total = (data.mukhyaatithimale ?? 0) + (data.sadbavkaryamale ?? 0) + (data.sajjanskhatiuppasstitimale ?? 0) + (data.pramukhjhanuppasstitimale ?? 0) + (data.anyauppasstitimale ?? 0);
      return total;
    }

    int calculateTotalFemale() {
      final total =
          (data.mukhyaatithifemale ?? 0) + (data.sadbavkaryafemale ?? 0) + (data.sajjanskhatiuppasstitifemale ?? 0) + (data.pramukhjhanuppasstitifemale ?? 0) + (data.anyanuppasstitifemale ?? 0);
      return total;
    }

    return Column(
      children: [
        ExpansionPanelList(
          expansionCallback: (index, isExpanded) {
            setState(() {
              _expanded[index] = !_expanded[index];
            });
          },
          children: [
            _buildPanel(
              Statics.getLabel("searchSwayamsevakScreenLabel"),
              0,
              Column(
                children: [
                  SingleColumnRow(
                    txtString: Statics.getLabel('present'),
                    fontWeight: FontWeight.w700,
                    value: "",
                    fontsize: 16,
                    rowColor: Colors.purple.shade50,
                    subChild: Column(
                      children: [
                        Row(children: [
                          Expanded(child: Text(Statics.getLabel('totalPat'))),
                          Container(
                            margin: EdgeInsets.only(left: 8),
                            child: Text((data.ekunpat ?? 0).toString()),
                          ),
                        ]),
                        // SizedBox(height: 8),
                        // SizedBox(width: MediaQuery
                        //     .sizeOf(context)
                        //     .width, child: CustomPaint(painter: DashedLinePainter(dashWidth: 7, thickness: 0.7))),
                        // SizedBox(height: 8),
                        // Row(children: [
                        //   Expanded(child: Text(Statics.getLabel('presentGanveshatTotal'))),
                        //   Container(
                        //     margin: EdgeInsets.only(left: 8),
                        //     child: Text((data.ekungan ?? 0).toString()),
                        //   ),
                        // ]),
                        // SizedBox(height: 8),
                        // Row(children: [
                        //   Expanded(child: Text(Statics.getLabel('presentSanchalanatTotal'))),
                        //   Container(
                        //     margin: EdgeInsets.only(left: 8),
                        //     child: Text((data.ekunsanchalan ?? 0).toString()),
                        //   ),
                        // ]),
                        SizedBox(height: 8),
                        Row(children: [
                          Expanded(child: Text(Statics.getLabel('anyaUpasthit') + " " + Statics.getLabel('searchSwayamsevakScreenLabel'))),
                          Container(
                            margin: EdgeInsets.only(left: 8),
                            child: Text((data.ekunupastiti ?? 0).toString()),
                          ),
                        ]),
                        SizedBox(height: 6),
                        SizedBox(width: MediaQuery.sizeOf(context).width, child: CustomPaint(painter: DashedLinePainter(dashWidth: 7, thickness: 0.7))),
                        SizedBox(height: 6),
                        Row(children: [
                          Expanded(child: Text(Statics.getLabel('presentTotal') + " " + Statics.getLabel('searchSwayamsevakScreenLabel'))),
                          Container(
                            margin: EdgeInsets.only(left: 8),
                            child: Text(((data.ekungan ?? 0) + (data.ekunupastiti ?? 0)).toString()),
                          ),
                        ]),
                      ],
                    ),
                  ),
                  SingleColumnRow(
                    txtString: Statics.getLabel('gramPratinidhitwa'),
                    fontWeight: FontWeight.w700,
                    value: "",
                    fontsize: 16,
                    rowColor: Colors.purple.shade50,
                    subChild: Column(
                      children: [
                        Row(children: [
                          Expanded(child: Text(Statics.getLabel('gramPratinidhitwa'))),
                          Container(
                            margin: EdgeInsets.only(left: 8),
                            child: Text((data.gramcountpratinidhatva ?? 0).toString()),
                          ),
                        ]),
                      ],
                    ),
                  ),
                  // SingleColumnRow(
                  //   txtString: "एकूण पट",
                  //   value: data.ekunpat,
                  // ),
                  // SingleColumnRow(
                  //   txtString: "गणवेशात उपस्थित",
                  //   value: data.ekungan,
                  // ),
                  // SingleColumnRow(txtString: "संचलनात उपस्थित", value: data.ekunsanchalan),
                  // SingleColumnRow(txtString: "अन्य उपस्थित", value: data.ekunupastiti),
                  // SingleColumnRow(txtString: "वर्तमान शाखा प्रतिनिधित्व", value: data.vartamansaakhapratinidhatva),
                  // SingleColumnRow(txtString: "वर्तमान साप्ताहिक मिलन प्रतिनिधित्व", value: data.vartamansapthahikpratinidhatva),
                  // SingleColumnRow(txtString: "वर्तमान मासिक मिलन प्रतिनिधित्व", value: data.vartamansanghmandalipratinidhatva),
                  // // SingleColumnRow(txtString: "वर्तमान संघ मंडली प्रतिनिधित्व", value: data.),
                  // // SingleColumnRow(txtString: "नवीन संकल्पित शाखा प्रतिनिधित्व", value: "5"),
                  // // SingleColumnRow(txtString: "नवीन संकल्पित साप्ताहिक मिलन प्रतिनिधित्व", value: "3"),
                  // // SingleColumnRow(txtString: "नवीन संकल्पित संघ मंडली प्रतिनिधित्व", value: "2"),
                  // SingleColumnRow(txtString: "वस्ती प्रतिनिधित्व", value: data.vasticountpratinidhatva),
                  // SingleColumnRow(txtString: "मंडल प्रतिनिधित्व", value: data.mandalcountpratinidhatva),
                  // SingleColumnRow(txtString: "ग्राम प्रतिनिधित्व", value: data.gramcountpratinidhatva),
                ],
              ),
            ),
            _buildPanel(
              Statics.getLabel("samajScreenLabel"),
              1,
              Column(
                children: [
                  SingleColumnRow(
                    txtString: Statics.getLabel('mukhyaAtithi'),
                    value: "",
                    fontsize: 16,
                    fontWeight: FontWeight.w600,
                    rowColor: Colors.purple.shade50,
                    subChild: Column(
                      children: [
                        Row(children: [
                          Expanded(child: Text(Statics.getLabel('Male'))),
                          Container(
                            margin: EdgeInsets.only(left: 8),
                            child: Text((data.mukhyaatithimale ?? 0).toString()),
                          ),
                        ]),
                        SizedBox(height: 8),
                        Row(children: [
                          Expanded(child: Text(Statics.getLabel('Female'))),
                          Container(
                            margin: EdgeInsets.only(left: 8),
                            child: Text((data.mukhyaatithifemale ?? 0).toString()),
                          ),
                        ]),
                        SizedBox(height: 6),
                        SizedBox(width: MediaQuery.sizeOf(context).width, child: CustomPaint(painter: DashedLinePainter(dashWidth: 7, thickness: 0.7))),
                        SizedBox(height: 6),
                        Row(children: [
                          Expanded(child: Text(Statics.getLabel('Total'))),
                          Container(
                            margin: EdgeInsets.only(left: 8),
                            child: Text(((data.mukhyaatithimale ?? 0) + (data.mukhyaatithifemale ?? 0)).toString()),
                          ),
                        ]),
                      ],
                    ),
                  ),
                  SingleColumnRow(
                    txtString: Statics.getLabel('sadhbhavKarya'),
                    value: "",
                    fontsize: 16,
                    fontWeight: FontWeight.w600,
                    rowColor: Colors.purple.shade50,
                    subChild: Column(
                      children: [
                        Row(children: [
                          Expanded(child: Text(Statics.getLabel('Male'))),
                          Container(
                            margin: EdgeInsets.only(left: 8),
                            child: Text((data.sadbavkaryamale ?? 0).toString()),
                          ),
                        ]),
                        SizedBox(height: 8),
                        Row(children: [
                          Expanded(child: Text(Statics.getLabel('Female'))),
                          Container(
                            margin: EdgeInsets.only(left: 8),
                            child: Text((data.sadbavkaryafemale ?? 0).toString()),
                          ),
                        ]),
                        SizedBox(height: 6),
                        SizedBox(width: MediaQuery.sizeOf(context).width, child: CustomPaint(painter: DashedLinePainter(dashWidth: 7, thickness: 0.7))),
                        SizedBox(height: 6),
                        Row(children: [
                          Expanded(child: Text(Statics.getLabel('Total'))),
                          Container(
                            margin: EdgeInsets.only(left: 8),
                            child: Text(((data.sadbavkaryamale ?? 0) + (data.sadbavkaryafemale ?? 0)).toString()),
                          ),
                        ]),
                      ],
                    ),
                  ),
                  SingleColumnRow(
                    txtString: Statics.getLabel("SajjanShakti"),
                    value: "",
                    fontsize: 16,
                    fontWeight: FontWeight.w600,
                    rowColor: Colors.purple.shade50,
                    subChild: Column(
                      children: [
                        Row(children: [
                          Expanded(child: Text(Statics.getLabel('Male'))),
                          Container(
                            margin: EdgeInsets.only(left: 8),
                            child: Text((data.sajjanskhatiuppasstitimale ?? 0).toString()),
                          ),
                        ]),
                        SizedBox(height: 8),
                        Row(children: [
                          Expanded(child: Text(Statics.getLabel('Female'))),
                          Container(
                            margin: EdgeInsets.only(left: 8),
                            child: Text((data.sajjanskhatiuppasstitifemale ?? 0).toString()),
                          ),
                        ]),
                        SizedBox(height: 6),
                        SizedBox(width: MediaQuery.sizeOf(context).width, child: CustomPaint(painter: DashedLinePainter(dashWidth: 7, thickness: 0.7))),
                        SizedBox(height: 6),
                        Row(children: [
                          Expanded(child: Text(Statics.getLabel('Total'))),
                          Container(
                            margin: EdgeInsets.only(left: 8),
                            child: Text(((data.sajjanskhatiuppasstitimale ?? 0) + (data.sajjanskhatiuppasstitifemale ?? 0)).toString()),
                          ),
                        ]),
                      ],
                    ),
                  ),
                  // SingleColumnRow(
                  //   txtString: "पुरुष",
                  //   value: "22",
                  // ),
                  // SingleColumnRow(
                  //   txtString: "महिला",
                  //   value: "11",
                  // ),
                  // SingleColumnRow(
                  //   txtString: "एकूण",
                  //   value: "33",
                  // ),
                  SingleColumnRow(
                    txtString: Statics.getLabel("PramukhJan"),
                    value: "",
                    fontsize: 16,
                    fontWeight: FontWeight.w600,
                    rowColor: Colors.purple.shade50,
                    subChild: Column(
                      children: [
                        Row(children: [
                          Expanded(child: Text(Statics.getLabel('Male'))),
                          Container(
                            margin: EdgeInsets.only(left: 8),
                            child: Text((data.pramukhjhanuppasstitimale ?? 0).toString()),
                          ),
                        ]),
                        SizedBox(height: 8),
                        Row(children: [
                          Expanded(child: Text(Statics.getLabel('Female'))),
                          Container(
                            margin: EdgeInsets.only(left: 8),
                            child: Text((data.pramukhjhanuppasstitifemale ?? 0).toString()),
                          ),
                        ]),
                        SizedBox(height: 6),
                        SizedBox(width: MediaQuery.sizeOf(context).width, child: CustomPaint(painter: DashedLinePainter(dashWidth: 7, thickness: 0.7))),
                        SizedBox(height: 6),
                        Row(children: [
                          Expanded(child: Text(Statics.getLabel('Total'))),
                          Container(
                            margin: EdgeInsets.only(left: 8),
                            child: Text(((data.pramukhjhanuppasstitimale ?? 0) + (data.pramukhjhanuppasstitifemale ?? 0)).toString()),
                          ),
                        ]),
                      ],
                    ),
                  ),
                  SingleColumnRow(
                    txtString: Statics.getLabel("anyaUpasthit"),
                    value: "",
                    fontsize: 16,
                    fontWeight: FontWeight.w600,
                    rowColor: Colors.purple.shade50,
                    subChild: Column(
                      children: [
                        Row(children: [
                          Expanded(child: Text(Statics.getLabel('Male'))),
                          Container(
                            margin: EdgeInsets.only(left: 8),
                            child: Text((data.anyauppasstitimale ?? 0).toString()),
                          ),
                        ]),
                        SizedBox(height: 8),
                        Row(children: [
                          Expanded(child: Text(Statics.getLabel('Female'))),
                          Container(
                            margin: EdgeInsets.only(left: 8),
                            child: Text((data.anyanuppasstitifemale ?? 0).toString()),
                          ),
                        ]),
                        SizedBox(height: 6),
                        SizedBox(width: MediaQuery.sizeOf(context).width, child: CustomPaint(painter: DashedLinePainter(dashWidth: 7, thickness: 0.7))),
                        SizedBox(height: 6),
                        Row(children: [
                          Expanded(child: Text(Statics.getLabel('Total'))),
                          Container(
                            margin: EdgeInsets.only(left: 8),
                            child: Text(((data.anyauppasstitimale ?? 0) + (data.anyanuppasstitifemale ?? 0)).toString()),
                          ),
                        ]),
                      ],
                    ),
                  ),
                  SingleColumnRow(
                    txtString: Statics.getLabel("presentTotal"),
                    value: "",
                    fontsize: 16,
                    fontWeight: FontWeight.w600,
                    rowColor: Colors.purple.shade50,
                    subChild: Column(
                      children: [
                        Row(children: [
                          Expanded(child: Text(Statics.getLabel('Male'))),
                          Container(
                            margin: EdgeInsets.only(left: 8),
                            child: Text(calculateTotalMale().toString()),
                          ),
                        ]),
                        SizedBox(height: 8),
                        Row(children: [
                          Expanded(child: Text(Statics.getLabel('Female'))),
                          Container(
                            margin: EdgeInsets.only(left: 8),
                            child: Text(calculateTotalFemale().toString()),
                          ),
                        ]),
                        SizedBox(height: 6),
                        SizedBox(width: MediaQuery.sizeOf(context).width, child: CustomPaint(painter: DashedLinePainter(dashWidth: 7, thickness: 0.7))),
                        SizedBox(height: 6),
                        Row(children: [
                          Expanded(child: Text(Statics.getLabel('Total'))),
                          Container(
                            margin: EdgeInsets.only(left: 8),
                            child: Text((calculateTotalMale() + calculateTotalFemale()).toString()),
                          ),
                        ]),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // _buildPanel(
            //     Statics.getLabel("anyaUpstithSummary"),
            //     2,
            //     Padding(
            //       padding: const EdgeInsets.symmetric(horizontal: 8.0),
            //       child: Column(
            //         children: [
            //           Row(children: [
            //             Expanded(child: Text(Statics.getLabel('Male'))),
            //             Container(
            //               margin: EdgeInsets.only(left: 8),
            //               child: Text((data.ekunmale ?? 0).toString()),
            //             ),
            //           ]),
            //           SizedBox(height: 8),
            //           Row(children: [
            //             Expanded(child: Text(Statics.getLabel('Female'))),
            //             Container(
            //               margin: EdgeInsets.only(left: 8),
            //               child: Text((data.ekunfemale ?? 0).toString()),
            //             ),
            //           ]),
            //           SizedBox(height: 6),
            //           SizedBox(width: MediaQuery.sizeOf(context).width, child: CustomPaint(painter: DashedLinePainter(dashWidth: 7, thickness: 0.7))),
            //           SizedBox(height: 6),
            //           Row(children: [
            //             Expanded(child: Text(Statics.getLabel('presentTotalMaleFemale2'))),
            //             Container(
            //               margin: EdgeInsets.only(left: 8),
            //               child: Text((data.ekumalenfemale ?? 0).toString()),
            //             ),
            //           ]),
            //           SizedBox(height: 6),
            //           SizedBox(width: MediaQuery.sizeOf(context).width, child: CustomPaint(painter: DashedLinePainter(dashWidth: 7, thickness: 0.7))),
            //           SizedBox(height: 6),
            //           //
            //           // SingleColumnRow(
            //           //   txtString: "${Statics.getLabel('presentTotalMaleFemale')} ",
            //           //   value: data.ekumalenfemale.toString(),
            //           // ),
            //           //
            //           Row(children: [
            //             Expanded(child: Text(Statics.getLabel('presentGanveshatTotal'))),
            //             Container(
            //               margin: EdgeInsets.only(left: 8),
            //               child: Text((data.ekunganvash ?? 0).toString()),
            //             ),
            //           ]),
            //           SizedBox(height: 8),
            //           // SingleColumnRow(
            //           //   txtString: "${Statics.getLabel('presentGanveshatTotal')} ",
            //           //   value: data.ekunganvash.toString(),
            //           // ),
            //           //
            //           Row(children: [
            //             Expanded(child: Text(Statics.getLabel('otherSwayamsewakPresentCount'))),
            //             Container(
            //               margin: EdgeInsets.only(left: 8),
            //               child: Text((data.ekunanya ?? 0).toString()),
            //             ),
            //           ]),
            //           SizedBox(height: 8),
            //           // SingleColumnRow(
            //           //   txtString: "${Statics.getLabel('otherSwayamsewakPresentCount')} ",
            //           //   value: data.ekunanya.toString(),
            //           // ),
            //           //
            //           // SingleColumnRow(
            //           //   txtString: "${Statics.getLabel('presentSamajik')} ",
            //           //   value: "${totalShakhaCount + totalMilanCount + totalSanghaMandaliCount}",
            //           // ),
            //           // ✅ Total
            //           SingleColumnRow(
            //             rowColor: Colors.grey.shade300,
            //             txtString: "${Statics.getLabel('presentAllTotal')} ",
            //             value: data.ekunupastitisummary.toString(),
            //           ),
            //           // const SizedBox(height: 10),
            //           // Text(
            //           //   "${Statics.getLabel('Total')} : $total",
            //           //   style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            //           // ),
            //         ],
            //       ),
            //     ),
            //     tileColor: Colors.purple.shade50,),
          ],
        ),
        Card(
          clipBehavior: Clip.antiAlias,
          margin: EdgeInsets.only(top: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
          surfaceTintColor: Colors.transparent,
          child: ExpansionTile(
              tilePadding: EdgeInsets.only(right: 16, left: 16),
              childrenPadding: EdgeInsets.zero,
              collapsedBackgroundColor: Colors.yellow.shade100,
              backgroundColor: Colors.yellow.shade100,
              initiallyExpanded: true,
              shape: RoundedRectangleBorder(side: BorderSide.none),
              title: Text(
                Statics.getLabel("anyaUpstithSummary"),
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
                    decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade800)),
                    padding: EdgeInsets.all(12),
                    child: Column(
                      children: [
                        Row(children: [
                          Expanded(child: Text(Statics.getLabel('Male'))),
                          Container(
                            margin: EdgeInsets.only(left: 8),
                            child: Text((data.ekunmale ?? 0).toString()),
                          ),
                        ]),
                        SizedBox(height: 8),
                        Row(children: [
                          Expanded(child: Text(Statics.getLabel('Female'))),
                          Container(
                            margin: EdgeInsets.only(left: 8),
                            child: Text((data.ekunfemale ?? 0).toString()),
                          ),
                        ]),
                        SizedBox(height: 6),
                        SizedBox(width: MediaQuery.sizeOf(context).width, child: CustomPaint(painter: DashedLinePainter(dashWidth: 7, thickness: 0.7))),
                        SizedBox(height: 6),
                        Row(children: [
                          Expanded(child: Text(Statics.getLabel('presentTotalMaleFemale2'))),
                          Container(
                            margin: EdgeInsets.only(left: 8),
                            child: Text((data.ekumalenfemale ?? 0).toString()),
                          ),
                        ]),
                        SizedBox(height: 6),
                        SizedBox(width: MediaQuery.sizeOf(context).width, child: CustomPaint(painter: DashedLinePainter(dashWidth: 7, thickness: 0.7))),
                        SizedBox(height: 6),
                        //
                        // SingleColumnRow(
                        //   txtString: "${Statics.getLabel('presentTotalMaleFemale')} ",
                        //   value: data.ekumalenfemale.toString(),
                        // ),
                        //
                        // Row(children: [
                        //   Expanded(child: Text(Statics.getLabel('presentGanveshatTotal'))),
                        //   Container(
                        //     margin: EdgeInsets.only(left: 8),
                        //     child: Text((data.ekunganvash ?? 0).toString()),
                        //   ),
                        // ]),
                        // SizedBox(height: 8),
                        // SingleColumnRow(
                        //   txtString: "${Statics.getLabel('presentGanveshatTotal')} ",
                        //   value: data.ekunganvash.toString(),
                        // ),
                        //
                        Row(children: [
                          Expanded(child: Text(Statics.getLabel('otherSwayamsewakPresentCount'))),
                          Container(
                            margin: EdgeInsets.only(left: 8),
                            child: Text((data.ekunanya ?? 0).toString()),
                          ),
                        ]),
                        SizedBox(height: 8),
                        // SingleColumnRow(
                        //   txtString: "${Statics.getLabel('otherSwayamsewakPresentCount')} ",
                        //   value: data.ekunanya.toString(),
                        // ),
                        //
                        // SingleColumnRow(
                        //   txtString: "${Statics.getLabel('presentSamajik')} ",
                        //   value: "${totalShakhaCount + totalMilanCount + totalSanghaMandaliCount}",
                        // ),
                        // ✅ Total
                        SingleColumnRow(
                          padding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                          rowColor: Colors.purple.shade50,
                          txtString: "${Statics.getLabel('presentAllTotal')} ",
                          value: data.ekunupastitisummary.toString(),
                          fontWeight: FontWeight.bold,
                        ),
                        // const SizedBox(height: 10),
                        // Text(
                        //   "${Statics.getLabel('Total')} : $total",
                        //   style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        // ),
                      ],
                    ),
                  ),
                ),
              ]),
        )
      ],
    );
  }

  ExpansionPanel _buildPanel(String title, int index, Widget child, {Color? tileColor, Color? backgroundColor}) {
    return ExpansionPanel(
      backgroundColor: backgroundColor,
      isExpanded: _expanded[index],
      headerBuilder: (context, isExpanded) {
        return ListTile(
          tileColor: tileColor,
          title: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.purpleAccent,
            ),
          ),
        );
      },
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: child,
      ),
    );
  }

  Widget buildMarathiDataTable(List<Vijayadashaminagarlist> data) {
    final List<String> headers = [
      // 'कार्यक्रम स्तर',
      Statics.getLabel('sanmelanReportTable1'),
      Statics.getLabel('sanmelanReportTable2'),
      Statics.getLabel('sanmelanReportTable3'),
      Statics.getLabel('sanmelanReportTable4'),
      Statics.getLabel('sanmelanReportTable5'),
      Statics.getLabel('sanmelanReportTable6'),
    ];

    return Row(
      children: [
        DataTable(
          headingRowColor: MaterialStateColor.resolveWith((_) => Colors.purple.shade100),
          columnSpacing: 0,
          horizontalMargin: 16,
          border: TableBorder.all(color: Colors.black26),
          columns: [
            DataColumn(
              label: Container(
                constraints: BoxConstraints(minWidth: 40, maxWidth: 70),
                child: Text(
                  Statics.getLabel("sanmelanReportTable0"),
                  softWrap: true,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
          rows: data.where((e) => [Statics.getLabel("Vasti"), Statics.getLabel("Mandal")].contains(e.levelname)).map((level) {
                return DataRow(cells: [
                  DataCell(Text(level.levelname.toString())),
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
                            constraints: BoxConstraints(minWidth: 40, maxWidth: 150),
                            // constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width * 0.2),
                            child: Text(header, softWrap: true, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ))
                    .toList(),
                rows: data.where((e) => [Statics.getLabel("Vasti"), Statics.getLabel("Mandal")].contains(e.levelname)).map((level) {
                      return DataRow(cells: [
                        DataCell(Center(
                            child: Row(
                          mainAxisAlignment: (level.karyakramnirdharitvedhvarcount != 0) ? MainAxisAlignment.spaceBetween : MainAxisAlignment.center,
                          children: [
                            if (level.karyakramnirdharitvedhvarcount != 0) SizedBox(width: 1),
                            Container(margin: EdgeInsets.only(right: level.karyakramnirdharitvedhvarcount != 0 ? 0 : 10), child: Text(level.karyakramnirdharitvedhvarcount.toString())),
                            if (level.karyakramnirdharitvedhvarcount != 0)
                              InkWell(
                                borderRadius: BorderRadius.circular(50),
                                onTap: () {
                                  showInfoDialogBox(names: level.karyakramnirdharitvedhvarcountNames ?? "", title: Statics.getLabel("vijayadashmiReportTable3"));
                                },
                                child: Icon(Icons.info_rounded, color: CupertinoColors.activeBlue, size: 16),
                              ),
                          ],
                        ))),
                        DataCell(Center(
                            child: Row(
                          mainAxisAlignment: (level.vyaktigeetkhantastakcount != 0) ? MainAxisAlignment.spaceBetween : MainAxisAlignment.center,
                          children: [
                            if (level.vyaktigeetkhantastakcount != 0) SizedBox(width: 1),
                            Container(margin: EdgeInsets.only(right: level.vyaktigeetkhantastakcount != 0 ? 0 : 10), child: Text(level.vyaktigeetkhantastakcount.toString())),
                            if (level.vyaktigeetkhantastakcount != 0)
                              InkWell(
                                borderRadius: BorderRadius.circular(50),
                                onTap: () {
                                  showInfoDialogBox(names: level.vyaktigeetkhantastakcountNames ?? "", title: Statics.getLabel("vijayadashmiReportTable4"));
                                },
                                child: Icon(Icons.info_rounded, color: CupertinoColors.activeBlue, size: 16),
                              ),
                          ],
                        ))),
                        DataCell(Center(
                            child: Row(
                          mainAxisAlignment: (level.skaraykramhisob24tasapurnacount != 0) ? MainAxisAlignment.spaceBetween : MainAxisAlignment.center,
                          children: [
                            if (level.skaraykramhisob24tasapurnacount != 0) SizedBox(width: 1),
                            Container(margin: EdgeInsets.only(right: level.skaraykramhisob24tasapurnacount != 0 ? 0 : 10), child: Text(level.skaraykramhisob24tasapurnacount.toString())),
                            if (level.skaraykramhisob24tasapurnacount != 0)
                              InkWell(
                                borderRadius: BorderRadius.circular(50),
                                onTap: () {
                                  showInfoDialogBox(names: level.skaraykramhisob24tasapurnacountNames ?? "", title: Statics.getLabel("vijayadashmiReportTable6"));
                                },
                                child: Icon(Icons.info_rounded, color: CupertinoColors.activeBlue, size: 16),
                              ),
                          ],
                        ))),

                        //sanchalan
                        DataCell(Center(
                            child: Row(
                          mainAxisAlignment: (level.shanchalancount != 0) ? MainAxisAlignment.spaceBetween : MainAxisAlignment.center,
                          children: [
                            if (level.shanchalancount != 0) SizedBox(width: 1),
                            Container(margin: EdgeInsets.only(right: level.shanchalancount != 0 ? 0 : 10), child: Text(level.shanchalancount.toString())),
                            if (level.shanchalancount != 0)
                              InkWell(
                                borderRadius: BorderRadius.circular(50),
                                onTap: () {
                                  showInfoDialogBox(names: level.shanchalancountNames ?? "", title: Statics.getLabel("vijayadashmiReportTable2"));
                                },
                                child: Icon(Icons.info_rounded, color: CupertinoColors.activeBlue, size: 16),
                              ),
                          ],
                        ))),
                        DataCell(Center(
                            child: Row(
                          mainAxisAlignment: (level.shanchalanghosvandancount != 0) ? MainAxisAlignment.spaceBetween : MainAxisAlignment.center,
                          children: [
                            if (level.shanchalanghosvandancount != 0) SizedBox(width: 1),
                            Container(margin: EdgeInsets.only(right: level.shanchalanghosvandancount != 0 ? 0 : 10), child: Text(level.shanchalanghosvandancount.toString())),
                            if (level.shanchalanghosvandancount != 0)
                              InkWell(
                                borderRadius: BorderRadius.circular(50),
                                onTap: () {
                                  showInfoDialogBox(names: level.shanchalanghosvandancountNames ?? "", title: Statics.getLabel("vijayadashmiReportTable5"));
                                },
                                child: Icon(Icons.info_rounded, color: CupertinoColors.activeBlue, size: 16),
                              ),
                          ],
                        ))),
                        DataCell(Center(
                            child: Row(
                          mainAxisAlignment: (level.shanchalansadandacount != 0) ? MainAxisAlignment.spaceBetween : MainAxisAlignment.center,
                          children: [
                            if (level.shanchalansadandacount != 0) SizedBox(width: 1),
                            Container(margin: EdgeInsets.only(right: level.shanchalansadandacount != 0 ? 0 : 10), child: Text(level.shanchalansadandacount.toString())),
                            if (level.shanchalansadandacount != 0)
                              InkWell(
                                borderRadius: BorderRadius.circular(50),
                                onTap: () {
                                  showInfoDialogBox(names: level.shanchalansadandacountNames ?? "", title: Statics.getLabel("vijayadashmiReportTable7"));
                                },
                                child: Icon(Icons.info_rounded, color: CupertinoColors.activeBlue, size: 16),
                              ),
                          ],
                        ))),
                      ]);
                    }).toList() +
                    [
                      DataRow(color: MaterialStatePropertyAll(Colors.yellow.shade100), cells: [
                        DataCell(Center(
                            child: Text(
                          data.fold(0, (sum, item) => sum + (item.karyakramnirdharitvedhvarcount ?? 0)).toString(),
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ))),
                        DataCell(Center(
                            child: Text(
                          data.fold(0, (sum, item) => sum + (item.vyaktigeetkhantastakcount ?? 0)).toString(),
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ))),
                        DataCell(Center(
                            child: Text(
                          data.fold(0, (sum, item) => sum + (item.skaraykramhisob24tasapurnacount ?? 0)).toString(),
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ))),

                        //sanchalan
                        DataCell(Center(
                            child: Text(
                          data.fold(0, (sum, item) => sum + (item.shanchalancount ?? 0)).toString(),
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ))),
                        DataCell(Center(
                            child: Text(
                          data.fold(0, (sum, item) => sum + (item.shanchalanghosvandancount ?? 0)).toString(),
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ))),
                        DataCell(Center(
                            child: Text(
                          data.fold(0, (sum, item) => sum + (item.shanchalansadandacount ?? 0)).toString(),
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ))),
                      ])
                    ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  showInfoDialogBox({required String names, required String title}) {
    final ScrollController _scrollController = ScrollController();
    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, set) {
            return AlertDialog(
              insetPadding: EdgeInsets.symmetric(horizontal: 24),
              // contentPadding: EdgeInsets.zero,
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.white,
              title: Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.purple.shade400)),
              content: SingleChildScrollView(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
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
                        border: TableBorder.symmetric(inside: BorderSide(width: 0.4, color: Colors.grey.shade400)),
                        showCheckboxColumn: false,
                        headingRowColor: MaterialStatePropertyAll(Colors.purple.shade50),
                        headingTextStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
                        columns: [
                          DataColumn(
                              label: Container(
                            constraints: BoxConstraints(maxWidth: 40),
                            child: Text(" "),
                          )),
                          DataColumn(
                              label: Container(
                            constraints: BoxConstraints(minWidth: MediaQuery.sizeOf(context).width * 0.5),
                            child: Text(
                              "${Statics.getLabel('Name')}",
                            ),
                          )),
                        ],
                        rows: names.split(",").toList().asMap().entries.map((entry) {
                          int index = entry.key;
                          var data = entry.value;
                          return DataRow(cells: [
                            DataCell(Container(constraints: BoxConstraints(maxWidth: 40), child: Text((index + 1).toString()))),
                            DataCell(Text(data, maxLines: 2, overflow: TextOverflow.ellipsis, softWrap: true)),
                          ]);
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ),
              actions: [
                ElevatedButton(
                  child: Text(Statics.getLabel("Submit")),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildExpansionPanel() {
    return Container(
      // width: MediaQuery.of(context).size.width * 0.9,
      // margin: EdgeInsets.symmetric(horizontal: 20),
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
                          _selectedGeoUnitId = value;
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
                          _selectedGeoUnitId = value;
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
                          _selectedGeoUnitId = value;
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
                          _selectedGeoUnitId = value;
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
                          _selectedGeoUnitId = value;
                          _selctedLevel = 'Nagar';
                          _selctedLevelName = selectedItem.name ?? "";
                          _linkednagarName = selectedItem.name ?? "";
                          populatelinkedMandalDropdown(value);
                          populatelinkedVastiDropdown(value);
                        });
                      },
                      isDisabled: false,
                    ),
                  // if (_linkedmandal != null && _linkedmandal!.isNotEmpty)
                  //   _buildDropdownField(
                  //     label: Statics.getLabel('Mandal'),
                  //     value: _linkedmandalValue,
                  //     items: _linkedmandal!
                  //         .map((bg) => DropdownMenuItem(
                  //       value: bg.geoUnitID.toString(),
                  //       child: Text(bg.name!),
                  //     ))
                  //         .toList(),
                  //     onChanged: (value) {
                  //       final selectedItem = _linkedmandal!.firstWhere((bg) => bg.geoUnitID.toString() == value);
                  //       setState(() {
                  //         _linkedmandalValue = value;
                  //         _selectedGeoUnitId = value.toString();
                  //         _selctedLevel = 'Mandal';
                  //         _selctedLevelName = selectedItem.name ?? "";
                  //         _linkedmandalName = selectedItem.name ?? "";
                  //         populatelinkedGraamDropdown(value);
                  //       });
                  //     },
                  //     isDisabled: false,
                  //   ),
                  // if (_linkedgraam != null && _linkedgraam!.isNotEmpty)
                  //   _buildDropdownField(
                  //     label: Statics.getLabel('Graam'),
                  //     value: _linkedgraamValue,
                  //     items: _linkedgraam!
                  //         .map((bg) => DropdownMenuItem(
                  //               value: bg.geoUnitID.toString(),
                  //               child: Text(bg.name!),
                  //             ))
                  //         .toList(),
                  //     onChanged: (value) {
                  //       final selectedItem = _linkedgraam!.firstWhere((bg) => bg.geoUnitID.toString() == value);
                  //       setState(() {
                  //         _linkedgraamValue = value;
                  //         _selectedGeoUnitId = value.toString();
                  //         _selctedLevel = 'Graam';
                  //         _selctedLevelName = selectedItem.name ?? "";
                  //         _linkedgraamName = selectedItem.name ?? "";
                  //       });
                  //     },
                  //     isDisabled: false,
                  //   ),
                  // if (_linkedvasti != null && _linkedvasti!.isNotEmpty)
                  //   _buildDropdownField(
                  //     label: Statics.getLabel('Vasti'),
                  //     value: _linkedvastiValue,
                  //     items: _linkedvasti!
                  //         .map((bg) => DropdownMenuItem(
                  //               value: bg.geoUnitID.toString(),
                  //               child: Text(bg.name!),
                  //             ))
                  //         .toList(),
                  //     onChanged: (value) {
                  //       final selectedItem = _linkedvasti!.firstWhere((bg) => bg.geoUnitID.toString() == value);
                  //       setState(() {
                  //         _linkedvastiValue = value;
                  //         _selectedGeoUnitId = value.toString();
                  //         _selctedLevel = 'Vasti';
                  //         _selctedLevelName = selectedItem.name ?? "";
                  //         _linkedvastiName = selectedItem.name ?? "";
                  //       });
                  //     },
                  //     isDisabled: false,
                  //   ),
                  SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // if ((_linkedgraamValue != "" && _linkedgraamValue != null) || (_linkedvastiValue != "" && _linkedvastiValue != null))
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

                          await getReportDataFun();

                          setState(() {
                            _selctedLevelNames = _selctedLevelNameList
                                .where((e) => e != null && e.isNotEmpty) // remove null or empty strings
                                .cast<String>() // convert from String? to String
                                .join(' -> ');
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
                              _selectedGeoUnitId = null;
                              _linkedMahaanagarValue = _linkedbhaagValue = _linkedshaharValue = _linkednagarValue = _linkedmandalValue = _linkedvastiValue = _linkedgraamValue = null;
                              _linkedVibhaagValue = _linkedbhaag = _linkedshahar = _linkedgraam = _linkedmandal = _linkedvasti = _linkednagar = null;
                              // type = "praant";
                            });
                            // await populateDropdown(isClear: true);
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
