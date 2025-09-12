import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:niyojak_prod/widgets/single_column_row.dart';

import '../../../helpers/static_data.dart' as Statics;
import '../../../models/response_model/get_vijayadashmi_report_resp_model.dart';
import '../../../providers/bals.dart';
import '../../../utils/cust_painters.dart';

class VijayadashamiFormReport extends StatefulWidget {
  static const String routeName = '/vijayadashami-form-report';

  const VijayadashamiFormReport({super.key});

  @override
  State<VijayadashamiFormReport> createState() => _VijayadashamiFormReportState();
}

class _VijayadashamiFormReportState extends State<VijayadashamiFormReport> {
  late ScrollController _scrollController;

  GetVijayadashamiReportModel? vijayadashamiReport;

  final List<bool> _expanded = List.generate(2, (_) => true);

  bool _isLoading = false;
  bool _isSearching = false;
  bool _isExpanded = true;

  // bool isVastiSearch = false;

  List<GeoUnitMasterBAL>? _linkedMahaanagar;
  List<GeoUnitMasterBAL>? _linkedVibhaag;
  List<GeoUnitMasterBAL>? _linkedBhaag;
  List<GeoUnitMasterBAL>? _linkedShahar;
  List<GeoUnitMasterBAL>? _linkedNagar;
  List<GeoUnitMasterBAL>? _linkedmandal;
  List<GeoUnitMasterBAL>? _linkedgraam;
  List<GeoUnitMasterBAL>? _linkedvasti;
  List<StaticMasterBAL>? _baithakTypes;
  String? _linkedMahaanagarValue = '';
  String? _linkedVibhaagValue = '';
  String? _linkedBhaagValue = '';
  String? _linkedShaharValue = '';
  String? _linkedNagarValue = '';
  String? _linkedgraamValue = "";
  String? _linkedmandalValue = "";
  String? _linkedvastiValue = "";
  String? _baithakTypeValue = '';
  String? _baithakTypeYear = '';
  int? _baithakType;
  String _selectedNagarAndBaithak = '';
  String? mahanagarId = '';
  String? vibhagId = '';

  @override
  void initState() {
    super.initState();
    populateDropdown();
  }

  void populateDropdown() async {
    _scrollController = ScrollController();
    var data = await Statics.getStaticLDB('AnnualBaithakType');
    populatelinkedMahaanagarDropdown();
    populatelinkedVibhaagDropdown('');
    if (!mounted) return;
    _baithakTypes = data;
    _baithakTypes = _baithakTypes!.where((element) => element.showAnnualBaithakkey!.contains('1')).toList();
    print("_baithakTypes :-- $_baithakTypes");
    setState(() {});
  }

  getReportDataFun() async {
    setState(() {
      vijayadashamiReport = null;
      _isLoading = true;
    });
    Map<String, dynamic> formData = {
      "GeoUnitID": int.tryParse(selctedLevelId.toString()) ?? null,
      "AppUserID": int.tryParse(Statics.userDetails['userID']) ?? null,
    };

    String formattedJson = const JsonEncoder.withIndent('  ').convert(formData);
    log("Form Data (JSON):\n$formattedJson");
    vijayadashamiReport = await Statics.getVijayaDashamiUtsavReportData(context, formData);
    log("vijayadashamiReport >>>>>>>>>>>>>>>>> ${jsonDecode(jsonEncode(vijayadashamiReport))}");
    setState(() {
      _isLoading = false;
      vijayadashamiReport;
    });
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedMahaanagarDropdown() async {
    var data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['MahaanagarLevelID'].toString(), '', '', '');
    setState(() {
      _linkedMahaanagar = data;
    });
    return data;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedBhaagDropdown(String vibhaagIDStr) async {
    _linkedShaharValue = _linkedNagarValue = null;
    var data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['BhaagLevelID'].toString(), vibhaagIDStr, 'Vibhaag', '');
    setState(() {
      _linkedBhaag = data;
    });
    return data;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedVibhaagDropdown(String mahaanagarIDStr) async {
    _linkedBhaagValue = null;
    var data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['VibhaagLevelID'].toString(), mahaanagarIDStr, (mahaanagarIDStr.isEmpty ? '' : 'Mahaanagar'), '');
    setState(() {
      _linkedVibhaag = data;
    });
    return data;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedShaharDropdown(String bhaagIDStr) async {
    _linkedShaharValue = _linkedShahar = null;
    var shDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['ShaharLevelID'].toString(), bhaagIDStr, 'Bhaag', '');
    setState(() {
      _linkedShahar = (shDD.length > 0 ? shDD : null);
    });
    return shDD;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedNagarDropdown(String? bhaagIDStr, String? shaharIDStr) async {
    _linkedNagarValue = null;
    _linkedNagar = null;
    if (shaharIDStr != null) {
      var ngDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['NagarLevelID'].toString(), shaharIDStr, 'Shahar', '');
      setState(() {
        _linkedNagar = (ngDD.length > 0 ? ngDD : null);
      });
      return ngDD;
    } else {
      var ngDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['NagarLevelID'].toString(), bhaagIDStr!, 'Bhaag', '');
      setState(() {
        _linkedNagar = (ngDD.length > 0 ? ngDD : null);
      });
      return ngDD;
    }
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedMandalDropdown(String nagarIDStr) async {
    _linkedgraamValue = null;
    _linkedmandal = _linkedgraam = null;
    var mnDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['MandalLevelID'].toString(), nagarIDStr, 'Nagar', '');
    setState(() {
      _linkedmandal = (mnDD.length > 0 ? mnDD : null);
    });
    return mnDD;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedGraamDropdown(String mandalIDStr) async {
    _linkedgraamValue = null;
    var gmDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['GraamLevelID'].toString(), mandalIDStr, 'Mandal', '');
    setState(() {
      _linkedgraam = (gmDD.length > 0 ? gmDD : null);
    });
    return gmDD;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedVastiDropdown(String nagarIDStr) async {
    _linkedvastiValue = null;
    var vsDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['VastiLevelID'].toString(), nagarIDStr, 'Nagar', '');
    setState(() {
      _linkedvasti = (vsDD.length > 0 ? vsDD : null);
    });
    return vsDD;
  }

  String? selctedLevel = 'praant';
  String? selctedLevelName = '';
  String? selctedLevelId = '';
  String? selctedSanchalanLevelId = '';
  String? selctedSanchalanLevelName = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "विजयादशमी कार्यक्रम रिपोर्ट",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              ExpansionPanelList(
                expansionCallback: (int index, bool isExpanded) {
                  setState(() {
                    _isExpanded = isExpanded;
                  });
                },
                children: [
                  ExpansionPanel(
                    isExpanded: _isExpanded,
                    headerBuilder: (BuildContext context, bool isExpanded) {
                      return ListTile(
                        title: Text(
                          Statics.getLabel('selectStar'),
                          style: TextStyle(color: Colors.purpleAccent, fontWeight: FontWeight.bold),
                        ),
                      );
                    },
                    body: Container(
                      margin: EdgeInsets.all(20),
                      child: Column(
                        children: [
                          if (_linkedMahaanagar != null)
                            DropdownButtonFormField(
                              decoration: InputDecoration(labelText: Statics.getLabel('Mahaanagar')),
                              isExpanded: true,
                              value: _linkedMahaanagarValue == "" ? null : _linkedMahaanagarValue,
                              items: _linkedMahaanagar!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                              onChanged: (value) {
                                final selectedItem = _linkedMahaanagar!.firstWhere((bg) => bg.geoUnitID.toString() == value);
                                print(value);
                                setState(() {
                                  _linkedMahaanagarValue = value;
                                  _linkedVibhaagValue = null;
                                  _linkedBhaagValue = null;
                                  _linkedShaharValue = null;
                                  _linkedNagarValue = null;
                                  populatelinkedVibhaagDropdown(value!);
                                  mahanagarId = value;
                                  selctedLevelName = selectedItem.name ?? "";
                                  selctedLevel = 'Mahanagar';
                                  selctedLevelId = value;
                                });
                              },
                            ),
                          SizedBox(
                            height: 10,
                          ),
                          if (_linkedVibhaag != null)
                            DropdownButtonFormField(
                              decoration: InputDecoration(labelText: Statics.getLabel('Vibhaag')),
                              isExpanded: true,
                              value: _linkedVibhaagValue == "" ? null : _linkedVibhaagValue,
                              items: _linkedVibhaag!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                              onChanged: (value) {
                                final selectedItem = _linkedVibhaag!.firstWhere((bg) => bg.geoUnitID.toString() == value);
                                print(value);
                                setState(() {
                                  _linkedVibhaagValue = value;
                                  populatelinkedBhaagDropdown(value!);
                                  vibhagId = value;
                                  _linkedBhaagValue = _linkedNagarValue = null;
                                  _linkedBhaag = _linkedNagar = null;
                                  selctedLevelName = selectedItem.name ?? "";
                                  selctedLevel = 'Vibhaag';
                                  selctedLevelId = value;
                                });
                              },
                            ),
                          SizedBox(
                            height: 10,
                          ),
                          if (_linkedBhaag != null)
                            DropdownButtonFormField(
                              decoration: InputDecoration(labelText: Statics.getLabel('Bhaag')),
                              isExpanded: true,
                              value: _linkedBhaagValue == "" ? null : _linkedBhaagValue,
                              items: _linkedBhaag!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                              onChanged: (value) {
                                final selectedItem = _linkedBhaag!.firstWhere((bg) => bg.geoUnitID.toString() == value);
                                setState(() {
                                  _linkedBhaagValue = value;
                                  // populatelinkedShaharDropdown(value!);
                                  populatelinkedNagarDropdown(value, null);
                                  selctedLevelName = selectedItem.name ?? "";
                                  selctedLevel = 'Bhaag';
                                  selctedLevelId = value;
                                });
                              },
                            ),
                          if (_linkedNagar != null && _linkedNagar!.length > 0)
                            DropdownButtonFormField(
                              decoration: InputDecoration(labelText: Statics.getLabel('Nagar')),
                              isExpanded: true,
                              value: _linkedNagarValue == "" ? null : _linkedNagarValue,
                              items: _linkedNagar!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                              onChanged: (value) {
                                final selectedItem = _linkedNagar!.firstWhere((bg) => bg.geoUnitID.toString() == value);
                                populatelinkedMandalDropdown(value!);
                                populatelinkedVastiDropdown(value);
                                setState(() {
                                  selctedLevelName = selectedItem.name ?? "";
                                  selctedLevel = 'Nagar';
                                  selctedLevelId = value;

                                  _linkedNagarValue = value;
                                });
                              },
                            ),
                          if (_linkedNagar != null && _linkedNagar!.length > 0)
                            SizedBox(
                              height: 10,
                            ),
                          if (_linkedmandal != null && _linkedmandal!.length > 0)
                            DropdownButtonFormField(
                              decoration: InputDecoration(labelText: Statics.getLabel('Mandal')),
                              isExpanded: true,
                              value: _linkedmandalValue == "" ? null : _linkedmandalValue,
                              items: _linkedmandal!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                              onChanged: (value) {
                                final selectedItem = _linkedmandal!.firstWhere((bg) => bg.geoUnitID.toString() == value);
                                setState(() {
                                  selctedLevelName = selectedItem.name ?? "";
                                  selctedLevel = 'Mandal';
                                  selctedLevelId = value;

                                  _linkedmandalValue = value;
                                  populatelinkedGraamDropdown(value!);
                                });
                              },
                            ),
                          SizedBox(
                            height: 15,
                          ),
                          // if (selctedLevelId != '')
                          Align(
                            alignment: Alignment.center,
                            child: ElevatedButton(
                              style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.purpleAccent)),
                              onPressed: () async {
                                await getReportDataFun();
                                setState(() {
                                  _isExpanded = false;
                                  // isVastiSearch = true;
                                });
                              },
                              child: Text("${Statics.getLabel('Filters')}", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              if (selctedLevel != "" && selctedLevelName != "")
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
                          "${Statics.getLabel(selctedLevel ?? "Mahaanagar")}  ->  ",
                          style: TextStyle(color: Colors.purpleAccent, fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        Text(
                          " $selctedLevelName",
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

    return ExpansionPanelList(
      expansionCallback: (index, isExpanded) {
        setState(() {
          _expanded[index] = !_expanded[index];
        });
      },
      children: [
        _buildPanel(
          "स्वयंसेवक",
          0,
          Column(
            children: [
              SingleColumnRow(
                txtString: Statics.getLabel('present'),
                value: "",
                fontsize: 16,
                subChild: Column(
                  children: [
                    Row(children: [
                      Expanded(child: Text(Statics.getLabel('totalPat'))),
                      Container(
                        margin: EdgeInsets.only(left: 8),
                        child: Text((data.ekunpat ?? 0).toString()),
                      ),
                    ]),
                    SizedBox(height: 8),
                    Row(children: [
                      Expanded(child: Text(Statics.getLabel('presentGanveshatTotal'))),
                      Container(
                        margin: EdgeInsets.only(left: 8),
                        child: Text((data.ekungan ?? 0).toString()),
                      ),
                    ]),
                    SizedBox(height: 8),
                    Row(children: [
                      Expanded(child: Text(Statics.getLabel('presentSanchalanatTotal'))),
                      Container(
                        margin: EdgeInsets.only(left: 8),
                        child: Text((data.ekunsanchalan ?? 0).toString()),
                      ),
                    ]),
                    SizedBox(height: 8),
                    Row(children: [
                      Expanded(child: Text(Statics.getLabel('anyaUpasthit'))),
                      Container(
                        margin: EdgeInsets.only(left: 8),
                        child: Text((data.ekunupastiti ?? 0).toString()),
                      ),
                    ]),
                  ],
                ),
              ),
              SingleColumnRow(
                txtString: Statics.getLabel('shakhaMilanPratinidhitwaReport'),
                value: "",
                fontsize: 16,
                subChild: Column(
                  children: [
                    Row(children: [
                      Expanded(child: Text(Statics.getLabel('vartamaan') + " " + Statics.getLabel('shakhaMilanPratinidhitwa'))),
                      Container(
                        margin: EdgeInsets.only(left: 8),
                        child: Text((data.vartamansaakhapratinidhatva ?? 0).toString()),
                      ),
                    ]),
                    SizedBox(height: 8),
                    Row(children: [
                      Expanded(child: Text(Statics.getLabel('vartamaan') + " " + Statics.getLabel('MilanPratinidhitwa'))),
                      Container(
                        margin: EdgeInsets.only(left: 8),
                        child: Text((data.vartamansapthahikpratinidhatva ?? 0).toString()),
                      ),
                    ]),
                    SizedBox(height: 8),
                    Row(children: [
                      Expanded(child: Text(Statics.getLabel('vartamaan') + " " + Statics.getLabel('MaasikMilanPratinidhitwa'))),
                      Container(
                        margin: EdgeInsets.only(left: 8),
                        child: Text((data.vartamansanghmandalipratinidhatva ?? 0).toString()),
                      ),
                    ]),
                  ],
                ),
              ),
              SingleColumnRow(
                txtString: Statics.getLabel('bhougolikPratinidhitwa'),
                value: "",
                fontsize: 16,
                subChild: Column(
                  children: [
                    Row(children: [
                      Expanded(child: Text(Statics.getLabel('vastiPratinidhitwa'))),
                      Container(
                        margin: EdgeInsets.only(left: 8),
                        child: Text((data.vasticountpratinidhatva ?? 0).toString()),
                      ),
                    ]),
                    SizedBox(height: 8),
                    Row(children: [
                      Expanded(child: Text(Statics.getLabel('mandalPratinidhitwa'))),
                      Container(
                        margin: EdgeInsets.only(left: 8),
                        child: Text((data.mandalcountpratinidhatva ?? 0).toString()),
                      ),
                    ]),
                    SizedBox(height: 8),
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
          "समाज",
          1,
          Column(
            children: [
              SingleColumnRow(
                txtString: Statics.getLabel('mukhyaAtithi'),
                value: "",
                fontsize: 16,
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
                txtString: "अन्य उपस्थित",
                value: "",
                fontsize: 16,
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
                txtString: Statics.getLabel("Total"),
                value: "",
                fontsize: 16,
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
      ],
    );
  }

  ExpansionPanel _buildPanel(String title, int index, Widget child) {
    return ExpansionPanel(
      isExpanded: _expanded[index],
      headerBuilder: (context, isExpanded) {
        return ListTile(
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
      'किती कार्यक्रम झाले',
      'किती संचालन झाले ?',
      'किती कार्यक्रम ठरलेल्या\n बैठक सुरु झाले ?',
      'किती कार्यक्रमात वैदिक\n गीत पाठ स्तुती गेले ?',
      'किती कार्यक्रमात घोष\n वादन झाले ?',
      'किती कार्यक्रमांचे हिसाब\n २४ तासात पूर्ण झाले ?',
    ];

    // return Column(
    //   children: [
    //     Scrollbar(
    //       controller: _scrollController,
    //       thumbVisibility: true,
    //       interactive: true,
    //       thickness: 5,
    //       radius: Radius.circular(10),
    //       child: SingleChildScrollView(
    //         controller: _scrollController,
    //         scrollDirection: Axis.horizontal,
    //         child: DataTable(
    //           columnSpacing: 18,
    //           headingRowColor: MaterialStateColor.resolveWith((_) => Colors.purple.shade100),
    //           border: TableBorder(verticalInside: BorderSide(width: 0.7, color: Colors.grey.shade200)),
    //           columns: headers
    //               .map((header) => DataColumn(
    //                     label: Container(
    //                       // constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width * 0.2),
    //                       child: Text(header, softWrap: true, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontWeight: FontWeight.bold)),
    //                     ),
    //                   ))
    //               .toList(),
    //           rows: data.map((level) {
    //             return DataRow(cells: [
    //               DataCell(Text(level.levelname.toString())),
    //               DataCell(Center(child: Text(level.karykakramcount.toString()))),
    //               DataCell(Center(child: Text(level.shanchalancount.toString()))),
    //               DataCell(Center(child: Text(level.karyakramnirdharitvedhvarcount.toString()))),
    //               DataCell(Center(child: Text(level.vyaktigeetkhantastakcount.toString()))),
    //               DataCell(Center(child: Text(level.shanchalanghosvandancount.toString()))),
    //               DataCell(Center(child: Text(level.skaraykramhisob24tasapurnacount.toString()))),
    //             ]);
    //           }).toList(),
    //         ),
    //       ),
    //     ),
    //     SizedBox(height: 12),
    //     Divider(color: Colors.black),
    //     SizedBox(height: 12),
    //   ],
    // );
    return Row(
      children: [
        DataTable(
          headingRowColor: MaterialStateColor.resolveWith((_) => Colors.purple.shade100),
          columnSpacing: 0,
          border: TableBorder.all(color: Colors.black26),
          columns: [
            DataColumn(
              label: Center(
                child: SizedBox(
                  width: 50,
                  child: Text(
                    "कार्यक्रम स्तर",
                    softWrap: true,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
          rows: data.map((level) {
            return DataRow(cells: [
              DataCell(Text(level.levelname.toString())),
            ]);
          }).toList(),
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
                headingRowColor: MaterialStateColor.resolveWith((_) => Colors.purple.shade100),
                border: TableBorder(verticalInside: BorderSide(width: 0.7, color: Colors.grey.shade200)),
                columns: headers
                    .map((header) => DataColumn(
                          label: Container(
                            constraints: BoxConstraints(minWidth: 40, maxWidth: [headers[0], headers[1]].contains(header) ? 80 : 150),
                            // constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width * 0.2),
                            child: Text(header, softWrap: true, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ))
                    .toList(),
                rows: data.map((level) {
                  return DataRow(cells: [
                    DataCell(Center(child: Text(level.karykakramcount.toString()))),
                    DataCell(Center(child: Text(level.shanchalancount.toString()))),
                    DataCell(Center(child: Text(level.karyakramnirdharitvedhvarcount.toString()))),
                    DataCell(Center(child: Text(level.vyaktigeetkhantastakcount.toString()))),
                    DataCell(Center(child: Text(level.shanchalanghosvandancount.toString()))),
                    DataCell(Center(child: Text(level.skaraykramhisob24tasapurnacount.toString()))),
                  ]);
                }).toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
