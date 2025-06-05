import 'dart:convert';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import '../helpers/static_data.dart' as Statics;
import '../models/response_model/nirikshan_baithak_vrutta.dart';
import '../providers/bals.dart';

class NirikshanAnnualBaithakVrutta extends StatefulWidget {
  static const routeName = '/search-nirikshan-annual-baithak-vrutta';

  @override
  _NirikshanAnnualBaithakVruttaState createState() => _NirikshanAnnualBaithakVruttaState();
}

class _NirikshanAnnualBaithakVruttaState extends State<NirikshanAnnualBaithakVrutta> {

  bool _isLoading = false;
  bool _isSearching = false;
  bool _isExpanded = false;
  List<GeoUnitMasterBAL>? _linkedMahaanagar;
  List<GeoUnitMasterBAL>? _linkedVibhaag;
  List<GeoUnitMasterBAL>? _linkedBhaag;
  List<GeoUnitMasterBAL>? _linkedShahar;
  List<GeoUnitMasterBAL>? _linkedNagar;
  List<StaticMasterBAL>? _baithakTypes;

  String? _linkedMahaanagarValue = '';
  String? _linkedVibhaagValue = '';
  String? _linkedBhaagValue = '';
  String? _linkedShaharValue = '';
  String? _linkedNagarValue = '';
  String? _baithakTypeValue = '';
  int? _baithakType;
  String? mahanagarId = '';
  String? vibhagId = '';
  String _selectedNagarAndBaithak = '';

  List<String> geoUnitNamesList = [];
  List<String> exportList = [];
  List<List<String>> donloadexportList = [];

  int? selectedViewOnly = 1;

  NIrikshanBiathakVruttaModel? nirikshanBaithakVrutta;
  List fullDataSubmit = [];
  List  halfDataSubmit = [];
  List  noDataSubmit = [];
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

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
    _baithakTypes = _baithakTypes!.where((element) => element.showAnnualBaithakkey!.contains('1')).toList();
    // _baithakTypes = _baithakTypes!.where((element) => element.code!.contains(DateTime.now().year.toString())).toList();
    setState(() {});
  }
  void populatelinkedMahaanagarDropdown() async {
    var data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['MahaanagarLevelID'].toString(), '', '', '');
    setState(() {
      _linkedMahaanagar = data;
    });
  }
  void populatelinkedBhaagDropdown(String vibhaagIDStr) async {
    _linkedShaharValue = _linkedNagarValue = null;
    var data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['BhaagLevelID'].toString(), vibhaagIDStr, 'Vibhaag', '');
    setState(() {
      _linkedBhaag = data;
    });
  }
  void populatelinkedVibhaagDropdown(String mahaanagarIDStr) async {
    _linkedBhaagValue = null;
    var data = await Statics.getGeoUnitsByLevelAndParent(
        Statics.levels['VibhaagLevelID'].toString(), mahaanagarIDStr, (mahaanagarIDStr.isEmpty ? '' : 'Mahaanagar'), '');
    setState(() {
      _linkedVibhaag = data;
    });
  }
  void populatelinkedShaharDropdown(String bhaagIDStr) async {
    _linkedShaharValue = _linkedShahar = null;
    var shDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['ShaharLevelID'].toString(), bhaagIDStr, 'Bhaag', '');
    setState(() {
      _linkedShahar = (shDD.length > 0 ? shDD : null);
    });
  }

  void populatelinkedNagarDropdown(String? bhaagIDStr, String? shaharIDStr) async {
    _linkedNagarValue = null;
    _linkedNagar = null;
    if (shaharIDStr != null) {
      var ngDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['NagarLevelID'].toString(), shaharIDStr, 'Shahar', '');
      setState(() {
        _linkedNagar = (ngDD.length > 0 ? ngDD : null);
      });
    } else {
      var ngDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['NagarLevelID'].toString(), bhaagIDStr!, 'Bhaag', '');
      setState(() {
        _linkedNagar = (ngDD.length > 0 ? ngDD : null);
      });
    }
  }


  Future<dynamic> _getNirikshanVrutta(BuildContext context, String? type, int? baithakTypeID,int? locid) async {
    bool isConnected = await Statics.isInternetConnected();
    if (isConnected) {
      String strInput = json.encode({
        "type": type,
        "AnnualBaithakTypeID": baithakTypeID,
        "locid": locid,
        "AppUserID": Statics.userDetails["userID"],
      });
      nirikshanBaithakVrutta = await Statics.getNirikshanAnnualBaithakNagarVruttaForApp(strInput);
      setState(() {
        fullDataSubmit = nirikshanBaithakVrutta!.getbaithakvarshiklist!.where((e) => e.full == 1).toList();
        halfDataSubmit = nirikshanBaithakVrutta!.getbaithakvarshiklist!.where((e) => e.half == 1).toList();
        noDataSubmit = nirikshanBaithakVrutta!.getbaithakvarshiklist!.where((e) => e.notstarted == 1).toList();
      });

      print("fullDataSubmit ==> ${fullDataSubmit.length}");
      print("halfDataSubmit ==> ${halfDataSubmit.length}");
      print("noDataSubmit ==> ${noDataSubmit.length}");
      print("Complete data  ==> ${nirikshanBaithakVrutta!.getbaithakvarshiklist!.length}");

    } else {
      Statics.showMessageDialog(context, Statics.getLabel('internetNotConnected'));
      return null;
    }
    setState(() {
      _isSearching = false;
      _isLoading = false;
      _isExpanded = false;
    });
  }

  Future<void> _search(BuildContext) async {
    print("searching");
    setState(() {
      _isSearching = true;
      _isLoading = true;
      fullDataSubmit = [];
      halfDataSubmit = [];
      noDataSubmit = [];
    });
    int? mahaanagarVal = _linkedMahaanagarValue == null || _linkedMahaanagarValue == "" ? null : int.parse(_linkedMahaanagarValue!);
    int? vibhaagVal = _linkedVibhaagValue == null || _linkedVibhaagValue == "" ? null : int.parse(_linkedVibhaagValue!);
    int? bhaagVal = _linkedBhaagValue == null || _linkedBhaagValue == "" ? null : int.parse(_linkedBhaagValue!);
    int? shaharVal = _linkedShaharValue == null || _linkedShaharValue == "" ? null : int.parse(_linkedShaharValue!);
    int? nagarVal = _linkedNagarValue == null || _linkedNagarValue == "" ? null : int.parse(_linkedNagarValue!);
    _baithakType = _baithakTypeValue == null || _baithakTypeValue == "" ? null : int.parse(_baithakTypeValue!);
    int? geoID = (nagarVal != null ? nagarVal : (bhaagVal != null ? bhaagVal : (vibhaagVal != null ? vibhaagVal : (mahaanagarVal != null ? mahaanagarVal : null))));
    String type = "";
    if(_linkedMahaanagarValue != null &&_linkedVibhaagValue == null &&_linkedBhaagValue == null && _linkedNagarValue == null){
      type = "Mahaanagar";
    }else if(_linkedVibhaagValue != null &&_linkedBhaagValue == null && _linkedNagarValue == null){
      type = "Vibhaag";
    }else if(_linkedBhaagValue != null && _linkedNagarValue == null){
      type = "Bhaag";
    }else if(_linkedBhaagValue != null && _linkedNagarValue != null){
      type = "Nagar";
    }
    int locId = 0;
    if(_linkedMahaanagarValue != null &&_linkedVibhaagValue == null &&_linkedBhaagValue == null && _linkedNagarValue == null){
      locId = mahaanagarVal!;
    }else if(_linkedVibhaagValue != null &&_linkedBhaagValue == null && _linkedNagarValue == null){
      locId = vibhaagVal!;
    }else if(_linkedBhaagValue != null && _linkedNagarValue == null){
      locId = bhaagVal!;
    }else if(_linkedBhaagValue != null && _linkedNagarValue != null){
      locId = nagarVal!;
    }
    _selectedNagarAndBaithak = _baithakTypes!.firstWhere((element) => element.staticID == _baithakType).codeForDisplay! +
        ' | ' +
        (bhaagVal == null ? ' - ' : _linkedBhaag!.firstWhere((element) => element.geoUnitID == bhaagVal).name!) +
        ' | ' +
        (nagarVal  == null ? ' - ' :_linkedNagar!.firstWhere((element) => element.geoUnitID == nagarVal).name!) +
        ' | ' +
        (vibhaagVal == null ? ' - ' : _linkedVibhaag!.firstWhere((element) => element.geoUnitID == vibhaagVal).name!) +
        ' | ' +
        (mahaanagarVal == null ? ' - ' : _linkedMahaanagar!.firstWhere((element) => element.geoUnitID == mahaanagarVal).name!) +
        ' | ' ;
    _getNirikshanVrutta(context,type,_baithakType!,locId);
  }


  @override
  Widget build(BuildContext context) {
   var fulllength = nirikshanBaithakVrutta?.getbaithakvarshiklist!.where((e) => e.full == 1).toList();
   var halflength = nirikshanBaithakVrutta?.getbaithakvarshiklist!.where((e) => e.half == 1).toList();
   var notstartlength = nirikshanBaithakVrutta?.getbaithakvarshiklist!.where((e) => e.notstarted == 1).toList();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          Statics.getLabel('nirikshanAnnualBaithakVruttaTitle'),
          style: TextStyle(fontSize: 20),
        ),

      ),
      // drawer: AppDrawer(),
      body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20),
            width: Statics.getDeviceSize(context).width,
            child: Column(
              children: <Widget>[
                Text(
                  Statics.getLabel('nirikshanAnnualBaithakVruttaTitle'),
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 10),
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
                          title: Text(Statics.getLabel('Filters')),
                        );
                      },
                      body: Container(
                        margin: EdgeInsets.all(20),
                        child: Column(
                          children: [
                            if(_linkedMahaanagar != null)
                              DropdownButtonFormField(
                                decoration: InputDecoration(labelText: Statics.getLabel('Mahaanagar')),
                                isExpanded: true,
                                value: _linkedMahaanagarValue == "" ? null : _linkedMahaanagarValue,
                                items: _linkedMahaanagar!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                                onChanged: (value) {
                                  print(value);
                                  setState(() {
                                    _linkedMahaanagarValue = value;
                                    _linkedVibhaagValue =  _linkedBhaagValue  = _linkedNagarValue  = null;
                                    _linkedVibhaag = _linkedBhaag  = _linkedNagar = null;
                                    populatelinkedVibhaagDropdown(value!);
                                    mahanagarId = value;
                                  });
                                },
                              ),
                            SizedBox(
                              height: 10,
                            ),
                            if(_linkedVibhaag != null)
                              DropdownButtonFormField(
                                decoration: InputDecoration(labelText: Statics.getLabel('Vibhaag')),
                                isExpanded: true,
                                value: _linkedVibhaagValue == "" ? null : _linkedVibhaagValue,
                                items: _linkedVibhaag!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                                onChanged: (value) {
                                  print(value);
                                  setState(() {
                                    _linkedVibhaagValue = value;
                                    populatelinkedBhaagDropdown(value!);
                                    vibhagId = value;
                                    _linkedBhaagValue  = _linkedNagarValue  = null;
                                    _linkedBhaag  = _linkedNagar = null;
                                  });
                                },
                              ),
                            SizedBox(
                              height: 10,
                            ),
                            if(_linkedBhaag != null)
                              DropdownButtonFormField(
                                decoration: InputDecoration(labelText: Statics.getLabel('Bhaag')),
                                isExpanded: true,
                                value: _linkedBhaagValue == "" ? null : _linkedBhaagValue,
                                items: _linkedBhaag!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _linkedBhaagValue = value;
                                    populatelinkedShaharDropdown(value!);
                                    populatelinkedNagarDropdown(value, null);
                                  });
                                },
                              ),
                            SizedBox(
                              height: 10,
                            ),
                            if (_linkedShahar != null && _linkedShahar!.length > 0)
                              DropdownButtonFormField(
                                decoration: InputDecoration(labelText: Statics.getLabel('Shahar')),
                                isExpanded: true,
                                value: _linkedShaharValue == "" ? null : _linkedShaharValue,
                                items: _linkedShahar!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _linkedShaharValue = value;
                                    populatelinkedNagarDropdown(null, value);
                                  });
                                },
                              ),
                            if (_linkedShahar != null && _linkedShahar!.length > 0)
                              SizedBox(
                                height: 10,
                              ),
                            if (_linkedNagar != null && _linkedNagar!.length > 0)
                              DropdownButtonFormField(
                                decoration: InputDecoration(labelText: Statics.getLabel('Nagar')),
                                isExpanded: true,
                                value: _linkedNagarValue == "" ? null : _linkedNagarValue,
                                items: _linkedNagar!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _linkedNagarValue = value;
                                  });
                                },
                              ),
                            if (_linkedNagar != null && _linkedNagar!.length > 0)
                              SizedBox(
                                height: 10,
                              ),
                            if(_baithakTypes != null)
                              DropdownSearch<String>(
                                popupProps: PopupProps.bottomSheet(
                                  showSearchBox: true,
                                  fit: FlexFit.tight, // Ensures the popup width matches the dropdown width
                                  itemBuilder: (context, item, isSelected) {
                                    return Container(
                                      margin: EdgeInsets.symmetric(horizontal: 8),
                                      decoration: !isSelected
                                          ? null
                                          : BoxDecoration(
                                        border: Border.all(color: Theme.of(context).primaryColor),
                                        borderRadius: BorderRadius.circular(5),
                                        color: Colors.grey[300],
                                      ),
                                      child: ListTile(
                                        title: Text(
                                          item,
                                          style: TextStyle(fontSize: 14), // Adjust the font size here
                                        ),
                                        contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 8), // Adjust padding here
                                        visualDensity: VisualDensity(vertical: -4), // Adjust density here
                                      ),
                                    );
                                  },
                                  searchFieldProps: TextFieldProps(
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                                    ),
                                  ),
                                  constraints: BoxConstraints.tightFor(
                                    width: double.infinity, // Ensures the popup width matches the dropdown width
                                  ),
                                  containerBuilder: (context, popupWidget) {
                                    return Stack(
                                      children: [
                                        popupWidget,
                                        Positioned(
                                          right: 10,
                                          top: 10,
                                          child: IconButton(
                                            icon: Icon(Icons.close),
                                            onPressed: () {
                                              Navigator.of(context).pop(); // Close the dropdown
                                            },
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                                items: _baithakTypes!.map((bg) => bg.codeForDisplay!).toList(),
                                dropdownDecoratorProps: DropDownDecoratorProps(
                                  dropdownSearchDecoration: InputDecoration(
                                    labelText: Statics.getLabel('baithakType'),
                                  ),
                                ),
                                selectedItem: _baithakTypeValue == "" ? null : _baithakTypes?.firstWhere((element) => element.staticID.toString() == _baithakTypeValue).codeForDisplay,
                                onChanged: (value) {
                                  print(value);
                                  setState(() {
                                    selectedViewOnly = _baithakTypes?.firstWhere((element) => element.codeForDisplay == value).ViewOnly;
                                    _baithakTypeValue = _baithakTypes?.firstWhere((element) => element.codeForDisplay == value).staticID.toString();
                                  });
                                  print(selectedViewOnly);
                                },
                              ),

                            SizedBox(  height: 10,
                            ),
                          ],
                        ),
                      ),
                      isExpanded: _isExpanded,
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Wrap(
                        children: [
                          MaterialButton(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                            padding: EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 8,
                            ),
                            color: Theme.of(context).primaryColor,
                            textColor: Theme.of(context).primaryTextTheme.button!.color,
                            onPressed: () async {
                              if (_baithakTypeValue != '') {
                                await _search(context);
                              } else {
                                Statics.showMessageDialog(context, Statics.getLabel('baithakTypeNotSelected'));
                              }


                            },

                            child: Text(
                              Statics.getLabel('Search'),
                              style: TextStyle(fontSize: 25),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          MaterialButton(
                              onPressed: () {
                                setState(() {
                                  _linkedMahaanagarValue = _linkedVibhaagValue =  _linkedBhaagValue  = _linkedNagarValue  = null;
                                  _linkedMahaanagar =  _linkedVibhaag = _linkedBhaag  = _linkedNagar = null;
                                  _baithakType = null;
                                  _baithakTypeValue =  _selectedNagarAndBaithak = '';
                                  _isSearching = false;
                                  exportList.clear();
                                  donloadexportList.clear();
                                  fullDataSubmit = [];
                                  halfDataSubmit = [];
                                  noDataSubmit = [];
                                });
                                populatelinkedMahaanagarDropdown();
                                populatelinkedVibhaagDropdown('');
                              },
                              child: Text(Statics.getLabel('clear'))),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Text(_selectedNagarAndBaithak!, style: TextStyle(fontSize: 18)),
          Divider(color: Colors.grey,),
          _isLoading == true ?
                CircularProgressIndicator():
          nirikshanBaithakVrutta?.getbaithakvarshiklist == null ?
          Container():
                Column(
                  children: [
                    Card(
                            child: Container(
                              padding: EdgeInsets.all(10),
                              height:  fullDataSubmit.length > 20 ? 500:250,
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("${Statics.getLabel('completeVrutta')}  :-  ", style: TextStyle(fontWeight: FontWeight.bold)),
                                      Text("${fullDataSubmit.length}"),
                                    ],
                                  ),
                                  Divider(color: Colors.grey),
                                  fullDataSubmit.length > 0 ?
                                  Expanded(
                                    child: ListView.builder(
                                      itemCount: fulllength?.length ?? 0,
                                      itemBuilder: (context, index) {
                                        var data = fulllength![index];
                                        return ListTile(
                                          title: Wrap(
                                            children: [
                                              Text("${index + 1})"),
                                              Text("${data.naav}"),
                                              if (data.prakar != "") Text("/${data.prakar}"),
                                              if (data.vayogat != "") Text("/${data.vayogat}"),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ):Container(
                                    child:  Text("${Statics.getLabel('NoDataFound')}"),
                                  ),
                                ],
                              ),
                            ),
                          ),
                    Card(
                            child: Container(
                              padding: EdgeInsets.all(10),
                              height:  halfDataSubmit.length > 20 ? 500:250,
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("${Statics.getLabel('incompleteVrutta')}  :-  ", style: TextStyle(fontWeight: FontWeight.bold)),
                                      Text("${halfDataSubmit.length}"),
                                    ],
                                  ),
                                  Divider(color: Colors.grey),
                                  halfDataSubmit.length > 0 ?
                                  Expanded(
                                    child: ListView.builder(
                                      itemCount: halflength?.length ?? 0,
                                      itemBuilder: (context, index) {
                                        var data = halflength![index];
                                        return ListTile(
                                          title: Wrap(
                                            children: [
                                              Text("${index + 1})"),
                                              Text("${data.naav}"),
                                              if (data.prakar != "") Text("/${data.prakar}"),
                                              if (data.vayogat != "") Text("/${data.vayogat}"),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  )
                                      :Container(
                                    child:  Text("${Statics.getLabel('NoDataFound')}"),
                                  ),
                                ],
                              ),
                            ),
                          ),
                    Card(
                            child: Container(
                              padding: EdgeInsets.all(10),
                              height:  noDataSubmit.length > 20 ? 500:250,
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("${Statics.getLabel('notStartVrutta')}  :-  ", style: TextStyle(fontWeight: FontWeight.bold)),
                                      Text("${noDataSubmit.length}"),
                                    ],
                                  ),
                                  Divider(color: Colors.grey),
                                  noDataSubmit.length > 0 ?
                                  Expanded(
                                    child: ListView.builder(
                                      itemCount: notstartlength?.length ?? 0,
                                      itemBuilder: (context, index) {
                                        var data = notstartlength![index];
                                        return ListTile(
                                          title: Wrap(
                                            children: [
                                              Text("${index + 1})"),
                                              Text("${data.naav}"),
                                              if (data.prakar != "") Text("/${data.prakar}"),
                                              if (data.vayogat != "") Text("/${data.vayogat}"),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ):Container(
                                    child:  Text("${Statics.getLabel('NoDataFound')}"),
                                  ),
                                ],
                              ),
                            ),
                          ),
                  ],
                ),
              ],
            ),
          )),
    );
  }
}
