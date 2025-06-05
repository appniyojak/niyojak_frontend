// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:niyojak_prod/screens/soochi_members.dart';
// import 'package:niyojak_prod/screens/soochi_sharing.dart';
// import '../screens/edit_soochi.dart';
// import '../widgets/sooochi_card.dart';
//
// import '../helpers/static_data.dart' as Statics;
// import '../widgets/app_drawer.dart';
//
// class SearchSwayamsewakSoochiScreen extends StatefulWidget {
//   static const routeName = '/search-swayamsewak-soochi-screen';
//
//
//   @override
//   _SearchSwayamsewakSoochiScreenState createState() => _SearchSwayamsewakSoochiScreenState();
// }
//
// class _SearchSwayamsewakSoochiScreenState extends State<SearchSwayamsewakSoochiScreen> {
//   Statics.ScreenArguments? args;
//   var swID;
//   var viewType;
//   final _searchController = TextEditingController();
//   bool _isSearching = false;
//   bool _isExpanded = false;
//   bool _includeOwnedSoochi = true;
//   bool _includeSharedSoochi = true;
//   bool isSoochiAvailable = false;
//
//   Future<List<dynamic>>? _soochiList;
//
//   Future<List<dynamic>> _getSoochiList(String searchString, bool includeOwnedSoochi, bool includeSharedSoochi) async {
//     bool isConnected = await Statics.isInternetConnected();
//     if (isConnected) {
//       return Statics.getSoochiList(searchString, includeOwnedSoochi, includeSharedSoochi);
//     } else {
//       Statics.showMessageDialog(context, Statics.getLabel('internetNotConnected'));
//       return [];
//     }
//   }
//  @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     _soochiList = _getSoochiList("Get Nothing", _includeOwnedSoochi, _includeSharedSoochi);
//     // checkIfSoochiExits(theId);
//  }
//
//
//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     _soochiList = _getSoochiList(" ", _includeOwnedSoochi, _includeSharedSoochi);
//     swID = args?.itemID;
//     viewType = args?.viewType;
//     print("$swID == $viewType");
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//     _searchController.dispose();
//   }
//
//   void onSaveDetails(outputID) {
//     setState(() {
//       swID = outputID;
//     });
//     print(swID);
//   }
//
//   void checkIfSoochiExits(swId) async {
//     var membersData = await Statics.getSwayamSevakMembersInSoochi(swId.toString());
//
//     var data = membersData == null ? null : membersData["TaggedSoochi"];
//     var data1 = membersData == null ? null : membersData["SharedSoochi"];
//     if ((data != null && data.length > 0) || (data1 != null && data1.length > 0)) {
//       if (!mounted) return;
//       setState(() {
//         isSoochiAvailable = true;
//       });
//     } else {
//       if (!mounted) return;
//       setState(() {
//         isSoochiAvailable = false;
//       });
//     }
//   }
//   Future<void> _search() async {
//     setState(() {
//       _isSearching = true;
//     });
//
//     var searchString = _searchController.text;
//
//     setState(() {
//       _soochiList = _getSoochiList(searchString, _includeOwnedSoochi, _includeSharedSoochi);
//       _isSearching = false;
//       _isExpanded = false;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: Text(
//             Statics.getLabel('addinSoochi'),
//             style: TextStyle(fontSize: 24),
//           ),
//           // actions: <Widget>[
//           //   IconButton(
//           //     padding: EdgeInsets.all(8),
//           //     icon: const Icon(Icons.add),
//           //     onPressed: () {
//           //       Navigator.of(context).pushNamed(EditSoochiScreen.routeName, arguments: Statics.ScreenArguments(0, Statics.getLabel('EditMenu')));
//           //     },
//           //   ),
//           // ],
//         ),
//         // drawer: AppDrawer(),
//         body: SingleChildScrollView(
//           child: Container(
//             padding: EdgeInsets.all(10),
//             child: Column(
//               children: <Widget>[
//                 // Text(
//                 //   Statics.getLabel('searchSoochiScreenBanner'),
//                 //   style: TextStyle(fontSize: 20),
//                 // ),
//                 // SizedBox(height: 10),
//                 // ExpansionPanelList(
//                 //   expansionCallback: (int index, bool isExpanded) {
//                 //     setState(() {
//                 //       _isExpanded = isExpanded;
//                 //     });
//                 //   },
//                 //   children: [
//                 //     ExpansionPanel(
//                 //       headerBuilder: (BuildContext context, bool isExpanded) {
//                 //         return ListTile(
//                 //           title: Text(Statics.getLabel('Filters')),
//                 //         );
//                 //       },
//                 //       body: Container(
//                 //         margin: EdgeInsets.all(20),
//                 //         child: Column(
//                 //           children: [
//                 //             Container(
//                 //               margin: EdgeInsets.only(
//                 //                 left: 10,
//                 //               ),
//                 //               width: Statics.getDeviceSize(context).width * 0.85, //300,
//                 //               child: TextFormField(
//                 //                 controller: _searchController,
//                 //                 textInputAction: TextInputAction.done,
//                 //                 keyboardType: TextInputType.text,
//                 //                 decoration: InputDecoration(labelText: Statics.getLabel('SoochiName') + '/' + Statics.getLabel('MemberName')),
//                 //               ),
//                 //             ),
//                 //             SizedBox(
//                 //               height: 10,
//                 //             ),
//                 //             CheckboxListTile(
//                 //               contentPadding: EdgeInsets.symmetric(horizontal: 0),
//                 //               controlAffinity: ListTileControlAffinity.leading,
//                 //               title: Text(Statics.getLabel('IncludeOwnedSoochi'), style: TextStyle(fontSize: 15)),
//                 //               checkColor: Colors.white,
//                 //               activeColor: Colors.purple,
//                 //               value: _includeOwnedSoochi == null ? false : _includeOwnedSoochi,
//                 //               onChanged: (value) {
//                 //                 setState(() {
//                 //                   _includeOwnedSoochi = value!;
//                 //                 });
//                 //               },
//                 //             ),
//                 //             SizedBox(
//                 //               height: 10,
//                 //             ),
//                 //             CheckboxListTile(
//                 //               contentPadding: EdgeInsets.symmetric(horizontal: 0),
//                 //               controlAffinity: ListTileControlAffinity.leading,
//                 //               title: Text(Statics.getLabel('IncludeSharedSoochi'), style: TextStyle(fontSize: 15)),
//                 //               checkColor: Colors.white,
//                 //               activeColor: Colors.purple,
//                 //               value: _includeSharedSoochi == null ? false : _includeSharedSoochi,
//                 //               onChanged: (value) {
//                 //                 setState(() {
//                 //                   _includeSharedSoochi = value!;
//                 //                 });
//                 //               },
//                 //             ),
//                 //           ],
//                 //         ),
//                 //       ),
//                 //       isExpanded: _isExpanded,
//                 //     ),
//                 //   ],
//                 // ),
//                 // Container(
//                 //   margin: EdgeInsets.all(20),
//                 //   child: Column(
//                 //     children: [
//                 //       if (_isSearching)
//                 //         CircularProgressIndicator()
//                 //       else
//                 //         Wrap(
//                 //           children: [
//                 //             MaterialButton(
//                 //               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
//                 //               padding: EdgeInsets.symmetric(
//                 //                 horizontal: 15,
//                 //                 vertical: 8,
//                 //               ),
//                 //               color: Theme.of(context).primaryColor,
//                 //               textColor: Theme.of(context).primaryTextTheme.button!.color,
//                 //               onPressed: _search,
//                 //               child: Text(
//                 //                 Statics.getLabel('Search'),
//                 //                 style: TextStyle(fontSize: 25),
//                 //               ),
//                 //             ),
//                 //             SizedBox(
//                 //               width: 10,
//                 //             ),
//                 //             MaterialButton(
//                 //                 onPressed: () {
//                 //                   setState(() {
//                 //                     _searchController.text = "";
//                 //                   });
//                 //                 },
//                 //                 child: Text(Statics.getLabel('clear'))),
//                 //           ],
//                 //         ),
//                 //     ],
//                 //   ),
//                 // ),
//                 FutureBuilder<List<dynamic>>(
//                   future: _soochiList,
//                   builder: (ctx, dataSnapshot) {
//                     //print(dataSnapshot.connectionState.toString());
//                     //print(dataSnapshot.hasData.toString());
//                     //print(_isSearching.toString());
//                     if (dataSnapshot.connectionState != ConnectionState.done) {
//                       return Center(child: CircularProgressIndicator());
//                     }
//                     if (dataSnapshot.hasError) {
//                       return Center(
//                           child: Text(
//                             'Server Error, Please Try Again Later',
//                             style: TextStyle(color: Theme.of(context).errorColor),
//                           ));
//                     }
//                     return dataSnapshot.hasData && dataSnapshot.data!.length > 0
//                         ? Column(
//                       children: dataSnapshot.data!.map((soochi) => SwayamsewakSocchiCard(soochi, _search)).toList(),
//                     )
//                         : Center(child: Text(Statics.getLabel('noDataFoundTryAnotherSearch')));
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ));
//   }
// }
//
// class SwayamsewakSocchiCard extends StatelessWidget {
//   final soochiItem;
//   final serahcDetails;
//
//   SwayamsewakSocchiCard(this.soochiItem, this.serahcDetails);
//
//   void _deleteSoochi(var context, var soochiID) async {
//     try {
//       bool isConnected = await Statics.isInternetConnected();
//       if (!isConnected) {
//         Statics.showMessageDialog(context, Statics.getLabel('internetNotConnected'));
//       } else {
//         var inputData = json.encode({"SoochiID": soochiID, "ModifiedBy": Statics.userDetails["userID"]});
//         showDialog(
//           context: context,
//           builder: (ctx) => AlertDialog(
//             title: Text(Statics.getLabel('AskConfirmation')),
//             content: Text(Statics.getLabel('AreyouSureYouWantToDeleteSoochi')),
//             actions: <Widget>[
//               MaterialButton(
//                 child: Text(Statics.getLabel('ConfirmationYes')),
//                 onPressed: () async {
//                   var data = await Statics.deleteSoochiForApp(inputData);
//                   if (data == "Soochi Deleted Successfully ") {
//                     Statics.showToast(Statics.getLabel('SoochiDeletedSuccessfully'));
//                     serahcDetails();
//                   } else
//                     Statics.showToast(Statics.getLabel('CouldnotDeleteSoochi'));
//
//                   Navigator.of(ctx).pop();
//                 },
//               ),
//               MaterialButton(
//                 child: Text(Statics.getLabel('ConfirmationNo')),
//                 onPressed: () {
//                   Navigator.of(ctx).pop();
//                 },
//               )
//             ],
//           ),
//         );
//       }
//     } on Exception catch (error) {
//       Statics.showErrorDialog(context, Statics.getLabel('unableToCompleteProcess'));
//     } catch (error) {
//       Statics.showErrorDialog(context, Statics.getLabel('unableToCompleteProcess'));
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: EdgeInsets.all(5),
//       elevation: 5,
//       child: ListTile(
//         onTap: (){
//           // print(object)
//         },
//         title: Text(
//             soochiItem["SoochiName"] + (soochiItem["SoochiMemberCount"] == null ? '' : (' (' + soochiItem["SoochiMemberCount"].toString() + ')'))),
//         // trailing: Container(
//         //   height: 50,
//         //   width: 0.1 * Statics.getDeviceSize(context).width,
//         //   child: Stack(
//         //     children: [
//         //       Positioned(
//         //         right: 0.0,
//         //         top: 0.0,
//         //         child: PopupMenuButton(
//         //           onSelected: (value) {
//         //             if (value == "AddMembers" || value == "ViewMembers") {
//         //               Navigator.of(context)
//         //                   .pushNamed(SoochiMembers.routeName, arguments: Statics.ScreenArguments(soochiItem["SoochiID"], value));
//         //             } else if (value == "AddSharing" || value == "ViewSharing") {
//         //               Navigator.of(context)
//         //                   .pushNamed(SoochiSharing.routeName, arguments: Statics.ScreenArguments(soochiItem["SoochiID"], value));
//         //             } else if (value == "Delete") {
//         //               _deleteSoochi(context, soochiItem["SoochiID"].toString());
//         //             } else
//         //               Navigator.of(context)
//         //                   .pushNamed(EditSoochiScreen.routeName, arguments: Statics.ScreenArguments(soochiItem["SoochiID"], value));
//         //           },
//         //           icon: Icon(
//         //             FontAwesomeIcons.ellipsisV,
//         //             color: Colors.grey,
//         //           ),
//         //           itemBuilder: (BuildContext context) {
//         //             return [
//         //               if (soochiItem["AppUserCanEdit"] == true) Statics.MenuItem(Statics.getLabel('EditMenu'), FontAwesomeIcons.edit, 'EditMenu'),
//         //               Statics.MenuItem(Statics.getLabel('ViewMenu'), FontAwesomeIcons.eye, 'ViewMenu'),
//         //               if (soochiItem["AppUserCanEdit"] == true) Statics.MenuItem(Statics.getLabel('AddMembers'), Icons.people, 'AddMembers'),
//         //               if (soochiItem["AppUserIsOwner"] == true) Statics.MenuItem(Statics.getLabel('AddSharing'), Icons.share, 'AddSharing'),
//         //               if (soochiItem["AppUserCanEdit"] == true) Statics.MenuItem(Statics.getLabel('ViewMembers'), Icons.people, 'ViewMembers'),
//         //               if (soochiItem["AppUserCanEdit"] == false) Statics.MenuItem(Statics.getLabel('ViewSharing'), Icons.share, 'ViewSharing'),
//         //               if (soochiItem["AppUserIsOwner"] == true) Statics.MenuItem(Statics.getLabel('Delete'), Icons.delete, 'Delete'),
//         //             ].map((Statics.MenuItem menuItem) {
//         //               return PopupMenuItem(
//         //                 //value: menuItem.menuVal,
//         //                 value: menuItem.menuKey,
//         //                 child: ListTile(
//         //                   leading: Icon(
//         //                     menuItem.iconVal,
//         //                     color: Colors.purple,
//         //                   ),
//         //                   title: Text(menuItem.menuVal),
//         //                 ),
//         //               );
//         //             }).toList();
//         //           },
//         //         ),
//         //       ),
//         //     ],
//         //   ),
//         // ),
//         subtitle: Container(
//             width: double.infinity,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 SizedBox(
//                   height: 5,
//                 ),
//                 Text(soochiItem["OwnerSwayamsevakFullName"]),
//                 SizedBox(
//                   height: 5,
//                 ),
//                 Text(soochiItem["Remark"]),
//               ],
//             )),
//       ),
//     );
//   }
// }

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:niyojak_prod/screens/soochi_members.dart';
import 'package:niyojak_prod/screens/soochi_sharing.dart';
import '../screens/edit_soochi.dart';
import '../widgets/sooochi_card.dart';

import '../helpers/static_data.dart' as Statics;
import '../widgets/app_drawer.dart';

class SearchSwayamsewakSoochiScreen extends StatefulWidget {
  static const routeName = '/search-swayamsewak-soochi-screen';

  final String swId;
  final Function onSaveSwDetails;
  final String viewType;

  SearchSwayamsewakSoochiScreen({
    required this.swId,
    required this.onSaveSwDetails,
    required this.viewType,
  });

  @override
  _SearchSwayamsewakSoochiScreenState createState() => _SearchSwayamsewakSoochiScreenState();
}

class _SearchSwayamsewakSoochiScreenState extends State<SearchSwayamsewakSoochiScreen> {
  Statics.ScreenArguments? args;
  var swID;
  var viewType;
  final _searchController = TextEditingController();
  bool _isSearching = false;
  bool _isExpanded = false;
  bool _includeOwnedSoochi = true;
  bool _includeSharedSoochi = true;
  bool isSoochiAvailable = false;

  Future<List<dynamic>>? _soochiList;

  Future<List<dynamic>> _getSoochiList(String searchString, bool includeOwnedSoochi, bool includeSharedSoochi) async {
    bool isConnected = await Statics.isInternetConnected();
    if (isConnected) {
      return Statics.getSoochiList(searchString, includeOwnedSoochi, includeSharedSoochi);
    } else {
      Statics.showMessageDialog(context, Statics.getLabel('internetNotConnected'));
      return [];
    }
  }

  @override
  void initState() {
    super.initState();
    swID = widget.swId;
    viewType = widget.viewType;
    // _soochiList = _getSoochiList("Get Nothing", _includeOwnedSoochi, _includeSharedSoochi);
    // checkIfSoochiExits(theId);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _soochiList = _getSoochiList(" ", _includeOwnedSoochi, _includeSharedSoochi);
    swID = widget.swId;
    viewType = widget.viewType;
    print("$swID == $viewType");
  }

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  void onSaveDetails(outputID) {
    setState(() {
      swID = outputID;
    });
    print(swID);
    widget.onSaveSwDetails(outputID);
  }

  void checkIfSoochiExits(swId) async {
    var membersData = await Statics.getSwayamSevakMembersInSoochi(swId.toString());

    var data = membersData == null ? null : membersData["TaggedSoochi"];
    var data1 = membersData == null ? null : membersData["SharedSoochi"];
    if ((data != null && data.length > 0) || (data1 != null && data1.length > 0)) {
      if (!mounted) return;
      setState(() {
        isSoochiAvailable = true;
      });
    } else {
      if (!mounted) return;
      setState(() {
        isSoochiAvailable = false;
      });
    }
  }

  Future<void> _search() async {
    setState(() {
      _isSearching = true;
    });

    var searchString = _searchController.text;

    setState(() {
      _soochiList = _getSoochiList(searchString, _includeOwnedSoochi, _includeSharedSoochi);
      _isSearching = false;
      _isExpanded = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            Statics.getLabel('addinSoochi'),
            style: TextStyle(fontSize: 24),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(10),
            child: Column(
              children: <Widget>[
                FutureBuilder<List<dynamic>>(
                  future: _soochiList,
                  builder: (ctx, dataSnapshot) {
                    if (dataSnapshot.connectionState != ConnectionState.done) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (dataSnapshot.hasError) {
                      return Center(
                          child: Text(
                            'Server Error, Please Try Again Later',
                            style: TextStyle(color: Theme.of(context).errorColor),
                          ));
                    }
                    return dataSnapshot.hasData && dataSnapshot.data!.length > 0
                        ? Column(
                      children: dataSnapshot.data!.map((soochi) => SwayamsewakSocchiCard(soochi, _search,swID,)).toList(),
                    )
                        : Center(child: Text(Statics.getLabel('noDataFoundTryAnotherSearch')));
                  },
                ),
              ],
            ),
          ),
        ));
  }
}

class SwayamsewakSocchiCard extends StatefulWidget {
  final soochiItem;
  final serahcDetails;
  final swId;

  SwayamsewakSocchiCard(this.soochiItem, this.serahcDetails, this.swId);

  @override
  _SwayamsewakSocchiCardState createState() => _SwayamsewakSocchiCardState();
}

class _SwayamsewakSocchiCardState extends State<SwayamsewakSocchiCard> {
  bool _isLoading = false;
  var _memberList;
  var _swController = TextEditingController();
  var _soochiController = TextEditingController();
  var _swValue;
  var _soochiValue;
  // int? _selectedRadio;
  Future<void> addtoSoochi() async {
    setState(() {
      _isLoading = true;
    });
    // try {
      bool isConnected = await Statics.isInternetConnected();
      if (!isConnected) {
        Statics.showMessageDialog(context, Statics.getLabel('internetNotConnected'));
      } else {
        await saveSoochiMembers();
      }
    // } on Exception catch (error) {
    //   Statics.showErrorDialog(context, Statics.getLabel('unableToCompleteProcess'));
    //   print("errorerror :--- $error");
    // } catch (error) {
    //   Statics.showErrorDialog(context, Statics.getLabel('unableToCompleteProcess'));
    //   print("errorerror 1 :--- $error");
    //
    // }

    setState(() {
      _isLoading = false;
    });
  }

  saveSoochiMembers() async {
    var inputData = json.encode({
      "SoochiMemberID": 0,
      "PraantID": 1,
      "SoochiID": widget.soochiItem["SoochiID"],
      "SwayamsevakID": (widget.swId == "" || widget.swId == null) ? null : widget.swId,
      // "SourceSoochiID":  widget.soochiItem["SoochiID"],
      "SourceSoochiID":  (_soochiValue == "" || _soochiValue == null) ? null : _soochiValue,
      "ModifiedBy": Statics.userDetails["userID"]
    });
  print("inputDatainputDatainputData :-- $inputData");
    var data = await Statics.saveSoochiMembers(inputData);
    print("datadatadata :-- $data");
    if (data == "-1") {
      Statics.showToast(Statics.getLabel('MemberExits'));
    }
    setState(() {
      Statics.showToast(Statics.getLabel('dataSavedSuccessfully'));
    });
    _swController.text = "";
    _soochiController.text = "";
    _swValue = null;
    _soochiValue = null;
  }



  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(5),
      elevation: 5,
      child: ListTile(
        onTap: () {
          print("DJKGHBJKDGH${widget.swId}");
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(Statics.getLabel('AskConfirmation')),
                content: Text(Statics.getLabel('AreyouSureYouWantToAddSoochi')),
                actions: [
                  TextButton(
                    child: Text(Statics.getLabel('ConfirmationNo')),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: Text(Statics.getLabel('ConfirmationYes')),
                    onPressed: () {
                      Navigator.of(context).pop();
                      addtoSoochi();
                    },
                  ),
                ],
              );
            },
          );
          // addtoSoochi();

        },
        // leading: Radio<int>(
        //   value: widget.soochiItem["SoochiID"],
        //   groupValue: _selectedRadio,
        //   onChanged: (int? value) {
        //     setState(() {
        //       _selectedRadio = value;
        //     });
        //   },
        // ),
        trailing:   IconButton(onPressed: (){
          Navigator.of(context)
              .pushNamed(SoochiMembers.routeName, arguments: Statics.ScreenArguments(widget.soochiItem["SoochiID"], "ViewMembers"));
        }, icon: Icon(Icons.remove_red_eye)),
        title: Text(widget.soochiItem["SoochiName"] +
            (widget.soochiItem["SoochiMemberCount"] == null
                ? ''
                : (' (' + widget.soochiItem["SoochiMemberCount"].toString() + ')'))),
        subtitle: Container(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 5,
              ),
              Text(widget.soochiItem["OwnerSwayamsevakFullName"]),
              SizedBox(
                height: 5,
              ),
              Text(widget.soochiItem["Remark"]),
            ],
          ),
        ),
      ),
    );
  }
}

