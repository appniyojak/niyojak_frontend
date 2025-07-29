import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:niyojak_prod/widgets/app_drawer.dart';

import '../../../helpers/static_data.dart' as Statics;
import '../../../providers/bals.dart';

class GruhSamparkAbhiyanView extends StatefulWidget {
  static const String routeName = '/gruh-sampark-abhiyan-form-view';

  const GruhSamparkAbhiyanView({super.key});

  @override
  State<GruhSamparkAbhiyanView> createState() => _GruhSamparkAbhiyanViewState();
}

class _GruhSamparkAbhiyanViewState extends State<GruhSamparkAbhiyanView> {
  final _formKey = GlobalKey<FormState>();

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
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${Statics.getLabel('vijayaDashamiUtsav')}",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      drawer: AppDrawer(),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
//=======================================   SEARCH FILTERS ==========================================================================================
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
                                  .firstWhere(
                                      (bg) => bg.geoUnitID.toString() == value);
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
                        if (_linkedmandal != null && _linkedmandal!.length > 0)
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
                        if (_linkedmandal != null && _linkedmandal!.length > 0)
                          SizedBox(
                            height: 10,
                          ),
                        if (_linkedgraam != null && _linkedgraam!.length > 0)
                          DropdownButtonFormField(
                            decoration: InputDecoration(
                                labelText: Statics.getLabel('Graam')),
                            isExpanded: true,
                            value: _linkedgraamValue == ""
                                ? null
                                : _linkedgraamValue,
                            items: _linkedgraam!
                                .map((bg) => DropdownMenuItem(
                                    value: bg.geoUnitID.toString(),
                                    child: Text(bg.name!)))
                                .toList(),
                            onChanged: (value) {
                              final selectedItem = _linkedgraam!.firstWhere(
                                  (bg) => bg.geoUnitID.toString() == value);
                              setState(() {
                                _linkedgraamValue = value;
                                selctedLevelName = selectedItem.name ?? "";
                                selctedLevel = 'Graam';
                                selctedLevelId = value;
                              });
                            },
                          ),
                        if (_linkedvasti != null && _linkedvasti!.length > 0)
                          DropdownButtonFormField(
                            decoration: InputDecoration(
                                labelText: Statics.getLabel('Vasti')),
                            isExpanded: true,
                            value: _linkedvastiValue == ""
                                ? null
                                : _linkedvastiValue,
                            items: _linkedvasti!
                                .map((bg) => DropdownMenuItem(
                                    value: bg.geoUnitID.toString(),
                                    child: Text(bg.name!)))
                                .toList(),
                            onChanged: (value) {
                              final selectedItem = _linkedvasti!.firstWhere(
                                  (bg) => bg.geoUnitID.toString() == value);
                              setState(() {
                                _linkedvastiValue = value;
                                selctedLevelName = selectedItem.name ?? "";
                                selctedLevel = 'Vasti';
                                selctedLevelId = value;
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

// ================================== 1 QUESTIONS Box ==================================================================================================================================================================================================================================================================================================================================================
            mainContainer(
              "${Statics.getLabel('mukhyaAtithi')}",
              Column(
                children: [],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget textControllerField2(
      {required String name,
      required TextEditingController controller,
      double height = 50.0,
      TextInputType keyboardType = TextInputType.text,
      bool isEdit = false,
      String? hintTextString,
      String? imp,
      int? maxInput}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: name,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              TextSpan(
                text: imp,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 5),
        Container(
          height: height,
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            inputFormatters: keyboardType == TextInputType.number
                ? [FilteringTextInputFormatter.allow(RegExp(r'^[0-9]*$'))]
                : [],
            decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              filled: true,
              fillColor: Colors.white,
              hintText: hintTextString,
            ),
            // readOnly: isVastiSearch == false ? true : isEdit,
            onTap: () {
              // if (isVastiSearch) {
              // print("Nothing");
              // } else {
              //   showPopupForVastiValidation(context);
              // }
            },
            maxLength: maxInput,
            buildCounter: (context,
                    {int? currentLength, int? maxLength, bool? isFocused}) =>
                null,
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }

  Widget mainContainer(String header, Widget child) {
    Size size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.symmetric(vertical: size.height * 0.01),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
          child,
        ],
      ),
    );
  }

  Widget yesNoRadioButton({
    required String question,
    required Function(int) onChanged,
    required int selectedOption,
    int? questionNumber,
    String? imp,
    bool isDisable = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text:
                    "${questionNumber != null ? "$questionNumber. " : ""}$question",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              TextSpan(
                text: imp,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
        Row(
          children: [
            Radio<int>(
              value: 1,
              groupValue: selectedOption,
              onChanged: isDisable
                  ? null
                  : (value) {
                      if (value != null) onChanged(value);
                    },
              activeColor: Colors.purpleAccent,
            ),
            Text(
              "${Statics.getLabel('ConfirmationYes')}",
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(width: 20),
            Radio<int>(
              value: 0,
              groupValue: selectedOption,
              onChanged: isDisable
                  ? null
                  : (value) {
                      if (value != null) onChanged(value);
                    },
              activeColor: Colors.purpleAccent,
            ),
            Text(
              "${Statics.getLabel('ConfirmationNo')}",
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoRow(String title, String? value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          "$title : ",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: Colors.purpleAccent,
          ),
        ),
        Expanded(
          child: Text(
            value ?? "—",
            style: TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }
}
