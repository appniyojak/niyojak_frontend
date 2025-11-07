// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:intl/intl.dart';
//
// import '../helpers/static_data.dart' as Statics;
// import '../widgets/app_drawer.dart';
//
// import '../widgets/swayamsevak_transfer_card.dart';
// import '../providers/bals.dart';
//
// class SearchSwayamsevakTransfer extends StatefulWidget {
//   static const routeName = '/search-swayamsevak-transfer';
//
//   @override
//   _SearchSwayamsevakTransferState createState() => _SearchSwayamsevakTransferState();
// }
//
// class _SearchSwayamsevakTransferState extends State<SearchSwayamsevakTransfer> {
//   final _nameController = TextEditingController();
//   bool _isSearching = false;
//
//   DateTime? _fromDate;
//   var _fromDateCntrl = TextEditingController();
//
//   DateTime? _toDate;
//   var _toDateCntrl = TextEditingController();
//
//   List<GeoUnitMasterBAL?> _linkedSourceBhaagList = [];
//   List<GeoUnitMasterBAL?> _linkedDestinationBhaagList = [];
//
//   String? _linkedSourceBhaagValue = "";
//   String? _linkedDestinationBhaagValue = "";
//   List<String> strEmail = [];
//   List<String> strMobile = [];
//   bool _isSelectAll = false;
//
//   bool _isExpanded = false;
//
//   Future<List<dynamic>>? _swayamsevakTransferList;
//
//   _pickFromDate() async {
//     DateTime? date = await showDatePicker(
//         context: context,
//         initialDate: _fromDate == null ? DateTime.now() : _fromDate!,
//         firstDate: DateTime((_fromDate == null ? DateTime.now().year : _fromDate!.year) - 80),
//         lastDate: DateTime((_fromDate == null ? DateTime.now().year : _fromDate!.year) + 80));
//
//     if (date != null) {
//       if (_toDate != null) {
//         if (_toDate!.year < date.year || _toDate!.month < date.month || _toDate!.day < date.day) {
//           Statics.showToast("From date should be less than To Date");
//           return;
//         }
//       }
//       setState(() {
//         _fromDate = date;
//         _fromDateCntrl.text = DateFormat('dd-MMM-yyyy').format(date);
//       });
//     }
//   }
//
//   _pickToDate() async {
//     DateTime? date = await showDatePicker(
//         context: context,
//         initialDate: _toDate == null ? DateTime.now() : _toDate!,
//         firstDate: DateTime((_toDate == null ? DateTime.now().year : _toDate!.year) - 80),
//         lastDate: DateTime((_toDate == null ? DateTime.now().year : _toDate!.year) + 80));
//
//     if (date != null) {
//       if (_fromDate != null) {
//         if (date.year < _fromDate!.year || date.month < _fromDate!.month || date.day < _fromDate!.day) {
//           Statics.showToast("From date should be less than To Date");
//           return;
//         }
//       }
//       setState(() {
//         _toDate = date;
//         _toDateCntrl.text = DateFormat('dd-MMM-yyyy').format(date);
//       });
//     }
//   }
//
//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//
//     _swayamsevakTransferList = _getSwayamsevakTransferList(null, null, "", null, null);
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//     _nameController.dispose();
//     _fromDateCntrl.dispose();
//     _toDateCntrl.dispose();
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     populateLinkedBhaagDropdown();
//   }
//
//   void onCheckCard(var emailID, var mobileNum) {
//     if (!strEmail.contains(emailID)) {
//       strEmail.add(emailID);
//     }
//     if (!strMobile.contains(mobileNum)) {
//       strMobile.add(mobileNum);
//     }
//   }
//
//   void onUnCheckCard(var emailID, var mobileNum) {
//     if (strEmail.contains(emailID)) {
//       strEmail.remove(emailID);
//     }
//     if (strMobile.contains(mobileNum)) {
//       strMobile.remove(mobileNum);
//     }
//   }
//
//   void onSelectAll(value) {
//     _swayamsevakTransferList!.then((dataList) {
//       for (var data in dataList) {
//         if (value == true)
//           onCheckCard(data["Email"], data["MobileNumber"]);
//         else
//           onUnCheckCard(data["Email"], data["MobileNumber"]);
//       }
//     });
//     setState(() {
//       _isSelectAll = value;
//     });
//   }
//
//   void populateLinkedBhaagDropdown() async {
//     List<GeoUnitMasterBAL?> data = await Statics.getGeoUnitMasterForApp('', '1', '', Statics.levels['BhaagLevelID']!, '', '', '', '', '', '', '', '');
//     // var data = await Statics.getGeoUnitsByLevelAndParent(
//     //     Statics.levels['BhaagLevelID'].toString(), "", "", "");
//     setState(() {
//       _linkedSourceBhaagList = data;
//       _linkedDestinationBhaagList = data;
//     });
//   }
//
//   Future<void> _search() async {
//     setState(() {
//       _isSearching = true;
//     });
//
//     var searchString = _nameController.text;
//     var frmDate = _fromDate == null ? null : DateFormat('dd-MM-yyyy').format(_fromDate!);
//     var toDate = _toDate == null ? null : DateFormat('dd-MM-yyyy').format(_toDate!);
//
//     int sourceBhaagVal = _linkedSourceBhaagValue == "" ||  _linkedSourceBhaagValue == null ? 0 : int.parse(_linkedSourceBhaagValue.toString());
//     int destinationBhaagVal = _linkedDestinationBhaagValue == "" ||  _linkedDestinationBhaagValue == null ? 0 : int.parse(_linkedDestinationBhaagValue.toString());
//
//     setState(() {
//       _swayamsevakTransferList = _getSwayamsevakTransferList(sourceBhaagVal, destinationBhaagVal, searchString, frmDate, toDate);
//       _isSearching = false;
//       _isExpanded = false;
//     });
//   }
//
//   Future<List<dynamic>> _getSwayamsevakTransferList(
//       int? sourceBhaagID, int? destinationBhaagID, String? searchString, String? fromDateStr, String? toDateStr) async {
//     bool isConnected = await Statics.isInternetConnected();
//     if (isConnected == false) {
//       Statics.showMessageDialog(context, Statics.getLabel('internetNotConnected'));
//       return [];
//     }
//     String strInput = json.encode({
//       "AppUserID": Statics.userDetails['userID'],
//       "SourceBhaagID": sourceBhaagID,
//       "DestinationBhaagID": destinationBhaagID,
//       "SearchString": searchString,
//       "FromDateStr": fromDateStr,
//       "ToDateStr": toDateStr
//     });
//     print(strInput);
//     return Statics.getSwayamsevakTransferList(strInput);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: Text(
//             Statics.getLabel('searchSwayamsevakTransferLabel'),
//             style: TextStyle(fontSize: 24),
//           ),
//         ),
//         drawer: AppDrawer(),
//         body: SingleChildScrollView(
//           child: Column(
//             children: <Widget>[
//               Text(
//                 Statics.getLabel('searchSwayamsevakTransferBanner'),
//                 style: TextStyle(fontSize: 20),
//               ),
//               SizedBox(height: 10),
//               ExpansionPanelList(
//                 expansionCallback: (int index, bool isExpanded) {
//                   setState(() {
//                     _isExpanded = isExpanded;
//                   });
//                 },
//                 children: [
//                   ExpansionPanel(
//                     headerBuilder: (BuildContext context, bool isExpanded) {
//                       return ListTile(
//                         title: Text(Statics.getLabel('Filters')),
//                       );
//                     },
//                     body: Container(
//                       margin: EdgeInsets.all(5),
//                       child: Column(
//                         children: [
//                           TextFormField(
//                             controller: _nameController,
//                             textInputAction: TextInputAction.done,
//                             keyboardType: TextInputType.text,
//                             decoration: InputDecoration(labelText: Statics.getLabel('Name') + "/" + Statics.getLabel('mobileNumberLabel')),
//                           ),
//                           SizedBox(
//                             height: 10,
//                           ),
//                           DropdownButtonFormField(
//                             decoration: InputDecoration(labelText: Statics.getLabel('sourceBhaagLabel')),
//                             isExpanded: true,
//                             value: _linkedSourceBhaagValue == "" ? null : _linkedSourceBhaagValue,
//                             items:
//                                 _linkedSourceBhaagList.map((bg) => DropdownMenuItem(value: bg!.geoUnitID.toString(), child: Text(bg.name!))).toList(),
//                             onChanged: (value) {
//                               setState(() {
//                                 _linkedSourceBhaagValue = value!;
//                               });
//                             },
//                           ),
//                           SizedBox(
//                             height: 10,
//                           ),
//                           DropdownButtonFormField(
//                             decoration: InputDecoration(labelText: Statics.getLabel('destinationBhaagLabel')),
//                             isExpanded: true,
//                             value: _linkedDestinationBhaagValue == "" ? null : _linkedDestinationBhaagValue,
//                             items: _linkedDestinationBhaagList!
//                                 .map((bg) => DropdownMenuItem(value: bg!.geoUnitID.toString(), child: Text(bg.name!)))
//                                 .toList(),
//                             onChanged: (value) {
//                               setState(() {
//                                 _linkedDestinationBhaagValue = value!;
//                               });
//                             },
//                           ),
//                           SizedBox(
//                             height: 10,
//                           ),
//                           Row(
//                             children: [
//                               SizedBox(
//                                 width: Statics.getDeviceSize(context).width * 0.7,
//                                 child: TextField(
//                                   enabled: false,
//                                   controller: _fromDateCntrl,
//                                   decoration: InputDecoration(labelText: Statics.getLabel('FromDate')),
//                                   textInputAction: TextInputAction.done,
//                                 ),
//                               ),
//                               IconButton(
//                                 color: Colors.purple,
//                                 icon: FaIcon(FontAwesomeIcons.solidCalendarAlt),
//                                 onPressed: _pickFromDate,
//                               ),
//                             ],
//                           ),
//                           SizedBox(
//                             height: 10,
//                           ),
//                           Row(
//                             children: [
//                               SizedBox(
//                                 width: Statics.getDeviceSize(context).width * 0.7,
//                                 child: TextField(
//                                   enabled: false,
//                                   controller: _toDateCntrl,
//                                   decoration: InputDecoration(labelText: Statics.getLabel('ToDate')),
//                                   textInputAction: TextInputAction.done,
//                                 ),
//                               ),
//                               IconButton(
//                                 color: Colors.purple,
//                                 icon: FaIcon(FontAwesomeIcons.solidCalendarAlt),
//                                 onPressed: _pickToDate,
//                               ),
//                             ],
//                           ),
//                           SizedBox(
//                             height: 10,
//                           ),
//                         ],
//                       ),
//                     ),
//                     isExpanded: _isExpanded,
//                   ),
//                 ],
//               ),
//               Container(
//                 margin: EdgeInsets.all(20),
//                 child: Column(
//                   children: [
//                     if (_isSearching)
//                       CircularProgressIndicator()
//                     else
//                       Wrap(
//                         children: [
//                           MaterialButton(
//                             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
//                             padding: EdgeInsets.symmetric(
//                               horizontal: 15,
//                               vertical: 8,
//                             ),
//                             color: Theme.of(context).primaryColor,
//                             textColor: Theme.of(context).primaryTextTheme.labelMedium?.color,
//                             onPressed: () {
//                               _search();
//                             },
//                             child: Text(
//                               Statics.getLabel('Search'),
//                               style: TextStyle(fontSize: 25),
//                             ),
//                           ),
//                           SizedBox(
//                             width: 10,
//                           ),
//                           MaterialButton(
//                               onPressed: () {
//                                 setState(() {
//                                   _linkedSourceBhaagValue = _linkedDestinationBhaagValue = null;
//                                   //_linkedSourceBhaagList = _linkedDestinationBhaagList = null;
//                                   _nameController.clear();
//                                   _fromDateCntrl.clear();
//                                   _toDateCntrl.clear();
//                                   _fromDate = _toDate = null;
//                                 });
//                                 populateLinkedBhaagDropdown();
//                               },
//                               child: Text(Statics.getLabel('clear'))),
//                         ],
//                       ),
//                   ],
//                 ),
//               ),
//               FutureBuilder<List<dynamic>>(
//                 future: _swayamsevakTransferList,
//                 builder: (ctx, dataSnapshot) {
//                   //print(dataSnapshot.connectionState.toString());
//                   //print(dataSnapshot.hasData.toString());
//                   //print(_isSearching.toString());
//                   if (dataSnapshot.connectionState != ConnectionState.done) {
//                     return Center(child: CircularProgressIndicator());
//                   }
//                   if (dataSnapshot.hasError) {
//                     return Center(
//                         child: Text(
//                       'Server Error, Please Try Again Later',
//                       style: TextStyle(color: Colors.red),
//                     ));
//                   }
//                   return dataSnapshot.hasData && dataSnapshot.data!.length > 0
//                       ? Column(
//                           children: dataSnapshot.data!
//                               .map((swTransferItem) => SwayamsevakTransferCard(swTransferItem, onCheckCard, onUnCheckCard, _isSelectAll, _search))
//                               .toList(),
//                         )
//                       : Center(child: Text(Statics.getLabel('noDataFoundTryAnotherSearch')));
//                 },
//               ),
//             ],
//           ),
//         ));
//   }
// }

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import '../helpers/static_data.dart' as Statics;
import '../providers/bals.dart';
import '../widgets/app_drawer.dart';
import '../widgets/swayamsevak_transfer_card.dart';

class SearchSwayamsevakTransfer extends StatefulWidget {
  static const routeName = '/search-swayamsevak-transfer';

  @override
  _SearchSwayamsevakTransferState createState() => _SearchSwayamsevakTransferState();
}

class _SearchSwayamsevakTransferState extends State<SearchSwayamsevakTransfer> {
  final _nameController = TextEditingController();
  bool _isSearching = false;

  DateTime? _fromDate;
  var _fromDateCntrl = TextEditingController();

  DateTime? _toDate;
  var _toDateCntrl = TextEditingController();

  List<GeoUnitMasterBAL?> _linkedSourceBhaagList = [];
  List<GeoUnitMasterBAL?> _linkedDestinationBhaagList = [];

  String? _linkedSourceBhaagValue = "";
  String? _linkedDestinationBhaagValue = "";
  List<String> strEmail = [];
  List<String> strMobile = [];
  bool _isSelectAll = false;

  bool _isExpanded = false;

  Future<List<dynamic>>? _swayamsevakTransferList;

  _pickFromDate() async {
    DateTime? date = await showDatePicker(
        context: context,
        initialDate: _fromDate == null ? DateTime.now() : _fromDate!,
        firstDate: DateTime((_fromDate == null ? DateTime.now().year : _fromDate!.year) - 80),
        lastDate: DateTime((_fromDate == null ? DateTime.now().year : _fromDate!.year) + 80));

    if (date != null) {
      if (_toDate != null) {
        if (_toDate!.year < date.year || _toDate!.month < date.month || _toDate!.day < date.day) {
          Statics.showToast("From date should be less than To Date");
          return;
        }
      }
      setState(() {
        _fromDate = date;
        _fromDateCntrl.text = DateFormat('dd-MMM-yyyy').format(date);
      });
    }
  }

  _pickToDate() async {
    DateTime? date = await showDatePicker(
        context: context,
        initialDate: _toDate == null ? DateTime.now() : _toDate!,
        firstDate: DateTime((_toDate == null ? DateTime.now().year : _toDate!.year) - 80),
        lastDate: DateTime((_toDate == null ? DateTime.now().year : _toDate!.year) + 80));

    if (date != null) {
      if (_fromDate != null) {
        if (date.year < _fromDate!.year || date.month < _fromDate!.month || date.day < _fromDate!.day) {
          Statics.showToast("From date should be less than To Date");
          return;
        }
      }
      setState(() {
        _toDate = date;
        _toDateCntrl.text = DateFormat('dd-MMM-yyyy').format(date);
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _swayamsevakTransferList = _getSwayamsevakTransferList(null, null, "", null, null);
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _fromDateCntrl.dispose();
    _toDateCntrl.dispose();
  }

  @override
  void initState() {
    super.initState();
    populateLinkedBhaagDropdown();
    _search();
    _swayamsevakTransferList;
  }

  void onCheckCard(var emailID, var mobileNum) {
    if (!strEmail.contains(emailID)) {
      strEmail.add(emailID);
    }
    if (!strMobile.contains(mobileNum)) {
      strMobile.add(mobileNum);
    }
  }

  void onUnCheckCard(var emailID, var mobileNum) {
    if (strEmail.contains(emailID)) {
      strEmail.remove(emailID);
    }
    if (strMobile.contains(mobileNum)) {
      strMobile.remove(mobileNum);
    }
  }

  void onSelectAll(value) {
    _swayamsevakTransferList!.then((dataList) {
      for (var data in dataList) {
        if (value == true)
          onCheckCard(data["Email"], data["MobileNumber"]);
        else
          onUnCheckCard(data["Email"], data["MobileNumber"]);
      }
    });
    setState(() {
      _isSelectAll = value;
    });
  }

  void populateLinkedBhaagDropdown() async {
    List<GeoUnitMasterBAL?> data = await Statics.getGeoUnitMasterForApp('', '1', '', Statics.levels['BhaagLevelID']!, '', '', '', '', '', '', '', '');
    // var data = await Statics.getGeoUnitsByLevelAndParent(
    //     Statics.levels['BhaagLevelID'].toString(), "", "", "");
    setState(() {
      _linkedSourceBhaagList = data;
      _linkedDestinationBhaagList = data;
    });
  }

  Future<void> _search() async {
    setState(() {
      _isSearching = true;
    });

    var searchString = _nameController.text;
    var frmDate = _fromDate == null ? null : DateFormat('dd-MM-yyyy').format(_fromDate!);
    var toDate = _toDate == null ? null : DateFormat('dd-MM-yyyy').format(_toDate!);

    int sourceBhaagVal = _linkedSourceBhaagValue == "" || _linkedSourceBhaagValue == null ? 0 : int.parse(_linkedSourceBhaagValue.toString());
    int destinationBhaagVal = _linkedDestinationBhaagValue == "" || _linkedDestinationBhaagValue == null ? 0 : int.parse(_linkedDestinationBhaagValue.toString());

    setState(() {
      _swayamsevakTransferList = _getSwayamsevakTransferList(sourceBhaagVal, destinationBhaagVal, searchString, frmDate, toDate);
      _isSearching = false;
      _isExpanded = false;
    });
  }

  Future<List<dynamic>> _getSwayamsevakTransferList(int? sourceBhaagID, int? destinationBhaagID, String? searchString, String? fromDateStr, String? toDateStr) async {
    bool isConnected = await Statics.isInternetConnected();
    if (isConnected == false) {
      Statics.showMessageDialog(context, Statics.getLabel('internetNotConnected'));
      return [];
    }
    String strInput = json.encode({
      "AppUserID": Statics.userDetails['userID'],
      "SourceBhaagID": sourceBhaagID,
      "DestinationBhaagID": destinationBhaagID,
      "SearchString": searchString,
      "FromDateStr": fromDateStr,
      "ToDateStr": toDateStr
    });
    print(strInput);
    return Statics.getSwayamsevakTransferList(strInput);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            Statics.getLabel('searchSwayamsevakTransferLabel'),
            style: TextStyle(fontSize: 24),
          ),
        ),
        drawer: AppDrawer(),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Text(
                Statics.getLabel('searchSwayamsevakTransferBanner'),
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
                      margin: EdgeInsets.all(5),
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _nameController,
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(labelText: Statics.getLabel('Name') + "/" + Statics.getLabel('mobileNumberLabel')),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          DropdownButtonFormField(
                            decoration: InputDecoration(labelText: Statics.getLabel('sourceBhaagLabel')),
                            isExpanded: true,
                            value: _linkedSourceBhaagValue == "" ? null : _linkedSourceBhaagValue,
                            items: _linkedSourceBhaagList.map((bg) => DropdownMenuItem(value: bg!.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                            onChanged: (value) {
                              setState(() {
                                _linkedSourceBhaagValue = value!;
                              });
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          DropdownButtonFormField(
                            decoration: InputDecoration(labelText: Statics.getLabel('destinationBhaagLabel')),
                            isExpanded: true,
                            value: _linkedDestinationBhaagValue == "" ? null : _linkedDestinationBhaagValue,
                            items: _linkedDestinationBhaagList.map((bg) => DropdownMenuItem(value: bg!.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                            onChanged: (value) {
                              setState(() {
                                _linkedDestinationBhaagValue = value!;
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
                            height: 10,
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
                            height: 10,
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
                              _search();
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
                                  _linkedSourceBhaagValue = _linkedDestinationBhaagValue = null;
                                  //_linkedSourceBhaagList = _linkedDestinationBhaagList = null;
                                  _nameController.clear();
                                  _fromDateCntrl.clear();
                                  _toDateCntrl.clear();
                                  _fromDate = _toDate = null;
                                });
                                populateLinkedBhaagDropdown();
                              },
                              child: Text(Statics.getLabel('clear'))),
                        ],
                      ),
                  ],
                ),
              ),
              FutureBuilder<List<dynamic>>(
                future: _swayamsevakTransferList,
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
                  return dataSnapshot.hasData && dataSnapshot.data!.length > 0
                      ? Column(
                          children: dataSnapshot.data!.map((swTransferItem) => SwayamsevakTransferCard(swTransferItem, onCheckCard, onUnCheckCard, _isSelectAll, _search)).toList(),
                        )
                      : Center(child: Text(Statics.getLabel('noDataFoundTryAnotherSearch')));
                },
              ),
            ],
          ),
        ));
  }
}
