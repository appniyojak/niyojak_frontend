import 'package:flutter/material.dart';
import 'package:niyojak_prod/widgets/single_column_row.dart';

import '../../../helpers/static_data.dart' as Statics;
import '../../../providers/bals.dart';

class VijayadashamiFormReport extends StatefulWidget {
  static const String routeName = '/vijayadashami-form-report';
  const VijayadashamiFormReport({super.key});

  @override
  State<VijayadashamiFormReport> createState() =>
      _VijayadashamiFormReportState();
}

class _VijayadashamiFormReportState extends State<VijayadashamiFormReport> {
  final List<bool> _expanded = List.generate(6, (_) => false);

  bool _isSearching = false;
  bool _isExpanded = false;
  bool isVastiSearch = false;

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
    var data = await Statics.getStaticLDB('AnnualBaithakType');
    populatelinkedMahaanagarDropdown();
    populatelinkedVibhaagDropdown('');
    if (!mounted) return;
    _baithakTypes = data;
    _baithakTypes = _baithakTypes!
        .where((element) => element.showAnnualBaithakkey!.contains('1'))
        .toList();
    print("_baithakTypes :-- ${_baithakTypes}");
    setState(() {});
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedMahaanagarDropdown() async {
    var data = await Statics.getGeoUnitsByLevelAndParent(
        Statics.levels['MahaanagarLevelID'].toString(), '', '', '');
    setState(() {
      _linkedMahaanagar = data;
    });
    return data;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedBhaagDropdown(
      String vibhaagIDStr) async {
    _linkedShaharValue = _linkedNagarValue = null;
    var data = await Statics.getGeoUnitsByLevelAndParent(
        Statics.levels['BhaagLevelID'].toString(), vibhaagIDStr, 'Vibhaag', '');
    setState(() {
      _linkedBhaag = data;
    });
    return data;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedVibhaagDropdown(
      String mahaanagarIDStr) async {
    _linkedBhaagValue = null;
    var data = await Statics.getGeoUnitsByLevelAndParent(
        Statics.levels['VibhaagLevelID'].toString(),
        mahaanagarIDStr,
        (mahaanagarIDStr.isEmpty ? '' : 'Mahaanagar'),
        '');
    setState(() {
      _linkedVibhaag = data;
    });
    return data;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedShaharDropdown(
      String bhaagIDStr) async {
    _linkedShaharValue = _linkedShahar = null;
    var shDD = await Statics.getGeoUnitsByLevelAndParent(
        Statics.levels['ShaharLevelID'].toString(), bhaagIDStr, 'Bhaag', '');
    setState(() {
      _linkedShahar = (shDD.length > 0 ? shDD : null);
    });
    return shDD;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedNagarDropdown(
      String? bhaagIDStr, String? shaharIDStr) async {
    _linkedNagarValue = null;
    _linkedNagar = null;
    if (shaharIDStr != null) {
      var ngDD = await Statics.getGeoUnitsByLevelAndParent(
          Statics.levels['NagarLevelID'].toString(), shaharIDStr, 'Shahar', '');
      setState(() {
        _linkedNagar = (ngDD.length > 0 ? ngDD : null);
      });
      return ngDD;
    } else {
      var ngDD = await Statics.getGeoUnitsByLevelAndParent(
          Statics.levels['NagarLevelID'].toString(), bhaagIDStr!, 'Bhaag', '');
      setState(() {
        _linkedNagar = (ngDD.length > 0 ? ngDD : null);
      });
      return ngDD;
    }
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedMandalDropdown(
      String nagarIDStr) async {
    _linkedgraamValue = null;
    _linkedmandal = _linkedgraam = null;
    var mnDD = await Statics.getGeoUnitsByLevelAndParent(
        Statics.levels['MandalLevelID'].toString(), nagarIDStr, 'Nagar', '');
    setState(() {
      _linkedmandal = (mnDD.length > 0 ? mnDD : null);
    });
    return mnDD;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedGraamDropdown(
      String mandalIDStr) async {
    _linkedgraamValue = null;
    var gmDD = await Statics.getGeoUnitsByLevelAndParent(
        Statics.levels['GraamLevelID'].toString(), mandalIDStr, 'Mandal', '');
    setState(() {
      _linkedgraam = (gmDD.length > 0 ? gmDD : null);
    });
    return gmDD;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedVastiDropdown(
      String nagarIDStr) async {
    _linkedvastiValue = null;
    var vsDD = await Statics.getGeoUnitsByLevelAndParent(
        Statics.levels['VastiLevelID'].toString(), nagarIDStr, 'Nagar', '');
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
                    headerBuilder: (BuildContext context, bool isExpanded) {
                      return ListTile(
                        title: Text(
                          Statics.getLabel('selectStar'),
                          style: TextStyle(
                              color: Colors.purpleAccent,
                              fontWeight: FontWeight.bold),
                        ),
                      );
                    },
                    body: Container(
                      margin: EdgeInsets.all(20),
                      child: Column(
                        children: [
                          if (_linkedMahaanagar != null)
                            DropdownButtonFormField(
                              decoration: InputDecoration(
                                  labelText: Statics.getLabel('Mahaanagar')),
                              isExpanded: true,
                              value: _linkedMahaanagarValue == ""
                                  ? null
                                  : _linkedMahaanagarValue,
                              items: _linkedMahaanagar!
                                  .map((bg) => DropdownMenuItem(
                                      value: bg.geoUnitID.toString(),
                                      child: Text(bg.name!)))
                                  .toList(),
                              onChanged: (value) {
                                final selectedItem = _linkedMahaanagar!
                                    .firstWhere((bg) =>
                                        bg.geoUnitID.toString() == value);
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
                              decoration: InputDecoration(
                                  labelText: Statics.getLabel('Vibhaag')),
                              isExpanded: true,
                              value: _linkedVibhaagValue == ""
                                  ? null
                                  : _linkedVibhaagValue,
                              items: _linkedVibhaag!
                                  .map((bg) => DropdownMenuItem(
                                      value: bg.geoUnitID.toString(),
                                      child: Text(bg.name!)))
                                  .toList(),
                              onChanged: (value) {
                                final selectedItem = _linkedVibhaag!.firstWhere(
                                    (bg) => bg.geoUnitID.toString() == value);
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
                              decoration: InputDecoration(
                                  labelText: Statics.getLabel('Bhaag')),
                              isExpanded: true,
                              value: _linkedBhaagValue == ""
                                  ? null
                                  : _linkedBhaagValue,
                              items: _linkedBhaag!
                                  .map((bg) => DropdownMenuItem(
                                      value: bg.geoUnitID.toString(),
                                      child: Text(bg.name!)))
                                  .toList(),
                              onChanged: (value) {
                                final selectedItem = _linkedBhaag!.firstWhere(
                                    (bg) => bg.geoUnitID.toString() == value);
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
                              decoration: InputDecoration(
                                  labelText: Statics.getLabel('Nagar')),
                              isExpanded: true,
                              value: _linkedNagarValue == ""
                                  ? null
                                  : _linkedNagarValue,
                              items: _linkedNagar!
                                  .map((bg) => DropdownMenuItem(
                                      value: bg.geoUnitID.toString(),
                                      child: Text(bg.name!)))
                                  .toList(),
                              onChanged: (value) {
                                final selectedItem = _linkedNagar!.firstWhere(
                                    (bg) => bg.geoUnitID.toString() == value);
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
                          if (_linkedmandal != null &&
                              _linkedmandal!.length > 0)
                            DropdownButtonFormField(
                              decoration: InputDecoration(
                                  labelText: Statics.getLabel('Mandal')),
                              isExpanded: true,
                              value: _linkedmandalValue == ""
                                  ? null
                                  : _linkedmandalValue,
                              items: _linkedmandal!
                                  .map((bg) => DropdownMenuItem(
                                      value: bg.geoUnitID.toString(),
                                      child: Text(bg.name!)))
                                  .toList(),
                              onChanged: (value) {
                                final selectedItem = _linkedmandal!.firstWhere(
                                    (bg) => bg.geoUnitID.toString() == value);
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
                          Align(
                            alignment: Alignment.center,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor: MaterialStatePropertyAll(
                                      Colors.purpleAccent)),
                              onPressed: () {
                                setState(() {
                                  _isExpanded = false;
                                  isVastiSearch = true;
                                });
                              },
                              child: Text("${Statics.getLabel('Filters')}",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                            ),
                          )
                        ],
                      ),
                    ),
                    isExpanded: _isExpanded,
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              if (selctedLevel != "" &&
                  selctedLevelName != "" &&
                  isVastiSearch == true)
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
                          "${selctedLevel}  ->  ",
                          style: TextStyle(
                              color: Colors.purpleAccent,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                        Text(
                          " $selctedLevelName",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 17),
                        ),
                      ],
                    )),
              SizedBox(
                height: 10,
              ),
              Divider(
                color: Colors.black,
              ),
              SizedBox(
                height: 10,
              ),
              SingleChildScrollView(
                child: ExpansionPanelList(
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
                            txtString: "एकूण पट",
                            value: "1254",
                          ),
                          SingleColumnRow(
                            txtString: "गणवेशात उपस्थित",
                            value: "832",
                          ),
                          SingleColumnRow(
                              txtString: "संचलनात उपस्थित", value: "582"),
                          SingleColumnRow(
                              txtString: "अन्य उपस्थित", value: "210"),
                          SingleColumnRow(
                              txtString: "वर्तमान शाखा प्रतिनिधित्व",
                              value: "25"),
                          SingleColumnRow(
                              txtString: "वर्तमान साप्ताहिक मिलन प्रतिनिधित्व",
                              value: "18"),
                          SingleColumnRow(
                              txtString: "वर्तमान मासिक मिलन प्रतिनिधित्व",
                              value: "10"),
                          SingleColumnRow(
                              txtString: "वर्तमान संघ मंडली प्रतिनिधित्व",
                              value: "4"),
                          SingleColumnRow(
                              txtString: "नवीन संकल्पित शाखा प्रतिनिधित्व",
                              value: "5"),
                          SingleColumnRow(
                              txtString:
                                  "नवीन संकल्पित साप्ताहिक मिलन प्रतिनिधित्व",
                              value: "3"),
                          SingleColumnRow(
                              txtString: "नवीन संकल्पित संघ मंडली प्रतिनिधित्व",
                              value: "2"),
                          SingleColumnRow(
                              txtString: "वस्ती प्रतिनिधित्व", value: "24"),
                          SingleColumnRow(
                              txtString: "ग्राम प्रतिनिधित्व", value: "15"),
                          SingleColumnRow(
                              txtString: "मंडल प्रतिनिधित्व", value: "8"),
                        ],
                      ),
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

  final ScrollController _scrollController = ScrollController();
  ExpansionPanel _buildPanel(String title, int index, Widget child) {
    return ExpansionPanel(
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
      body: Container(
        height: 300,
        child: Scrollbar(
          thumbVisibility: true,
          controller: _scrollController,
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: child,
            ),
          ),
        ),
      ),
      isExpanded: _expanded[index],
      canTapOnHeader: true,
    );
  }
}
