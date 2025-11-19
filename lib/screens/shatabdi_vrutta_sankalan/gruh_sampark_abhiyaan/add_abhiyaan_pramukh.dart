import 'dart:convert';
import 'dart:developer';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

import '../../../helpers/static_data.dart' as Statics;
import '../../../models/response_model/AbhiyaanSwayamsevakListResponse.dart';
import '../../edit_swayamsevak_screen.dart';

class AddAbhiyaanPramukhScreen extends StatefulWidget {
  static const String routeName = '/add-abhiyaan-pramukh-screen';
  const AddAbhiyaanPramukhScreen({super.key});

  @override
  State<AddAbhiyaanPramukhScreen> createState() => _AddAbhiyaanPramukhScreenState();
}

class _AddAbhiyaanPramukhScreenState extends State<AddAbhiyaanPramukhScreen> {
  String? _selectedGeoUnitId;
  bool _isSearching = false;

  AbhiyanSwayamsevakList? _selectedPramukh;

  TextEditingController _searchController = TextEditingController();

  List<AbhiyanSwayamsevakList>? abhiyaanPramukhSwayamsevak;

  Future<void> _search(String strType) async {
    setState(() {
      _isSearching = true;
    });
    await _getSwList(strType);
    setState(() {
      _selectedPramukh = null;
      _isSearching = false;
    });
  }

  Future<void> _getSwList(String strType) async {
    log("calling");
    bool isConnected = await Statics.isInternetConnected();
    if (isConnected) {
      var inputData = {
        "AppUserID": Statics.userDetails["userID"],
        // "AppUserID": "5693",
        "SearchCriteria": _searchController.text.trim(),
      };
      log(jsonEncode(inputData));
      abhiyaanPramukhSwayamsevak = await Statics.searchPramukhGruhAbhiyaan(inputData);
      setState(() {});
      if (abhiyaanPramukhSwayamsevak != null) {
        if (abhiyaanPramukhSwayamsevak!.isEmpty) {
          await showDialog(
            barrierDismissible: false,
            context: context,
            builder: (ctnx) => AlertDialog(
              title: Text(Statics.getLabel('AskConfirmation')),
              content: Text("स्वयंसेवक उपस्थित नाहीत, या अभियानासाठी नवीन अभियान स्वयंसेवक जोडायचा आहे का ?"),
              actions: <Widget>[
                TextButton(
                  child: Text(Statics.getLabel('ConfirmationNo')),
                  onPressed: () {
                    Navigator.of(ctnx).pop();
                    Navigator.of(context).pop();
                  },
                ),
                MaterialButton(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  padding: EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 8,
                  ),
                  color: Theme.of(context).primaryColor,
                  textColor: Theme.of(context).primaryTextTheme.labelMedium?.color,
                  child: Text(Statics.getLabel('ConfirmationYes')),
                  onPressed: () {
                    Navigator.of(ctnx).pop();
                    Navigator.of(context).pushReplacementNamed(EditSwayamsevakScreen.routeName, arguments: Statics.ScreenArgumentsNew(0, Statics.getLabel('EditMenu')));
                    // Navigator.pushReplacementNamed(context, AbhiyanAddSwayamsevakScreen.routeName);
                  },
                ),
              ],
            ),
          );
          return;
        }

        // setState(() {
        //   _fullNameCntrl.text = abhiyaanSwayamsevak?.swayamsevak?.participantName ?? "";
        //   _emailCntrl.text = abhiyaanSwayamsevak?.swayamsevak?.email ?? "";
        //   _mobileCntrl.text = abhiyaanSwayamsevak?.swayamsevak?.participantNumber ?? "";
        //   _sansthaNameCntrl.text = abhiyaanSwayamsevak?.swayamsevak?.sansthaName ?? "";
        //   _sansthaPadhCntrl.text = abhiyaanSwayamsevak?.swayamsevak?.sansthaPadh ?? "";
        //   selectedSansthaValue = abhiyaanSwayamsevak?.swayamsevak?.sansthaType ?? "";
        //   // _anyaSansthaCntrl.text = "";
        //
        //   // selectedGramVastiList = abhiyaanSwayamsevak?.swayamsevak?.mappingforGruhs ?? [];
        // });
        //
        // _levelValue = abhiyaanSwayamsevak?.swayamsevak?.levelID.toString() ?? "";
        // if (_levelValue.isNotEmpty && _levelValue != "null") {
        //   await populateGeoUnits(_levelValue);
        // }
        // _geoUnitsValue = abhiyaanSwayamsevak?.swayamsevak?.geoUnitID.toString() ?? "";
        // selectedDayitvValue = abhiyaanSwayamsevak?.swayamsevak?.daayityaName ?? "";
        setState(() {});
      }
    }
  }

  saveAbhiyaanSwayamsevakCall() async {
    try {
      bool isConnected = await Statics.isInternetConnected();
      if (isConnected) {
        var data = {
          "AppUserID": Statics.userDetails["userID"],
          "Geounitid": _selectedGeoUnitId,
          "SwayamsevakID": _selectedPramukh?.swayamsevakID,
        };

        log(jsonEncode(data));

        var result = await Statics.saveAsPramukhForGruhAbhiyaan(data, context: context);
        if (result) {
          print("succeed");
          // showDialog(
          //   barrierDismissible: false,
          //   context: context,
          //   builder: (ctnx) => AlertDialog(
          //     title: Text(Statics.getLabel('AskConfirmation')),
          //     content: Text("तुम्हाला आणखी एक स्वयंसेवक जोडायचा आहे का?"),
          //     actions: <Widget>[
          //       TextButton(
          //         child: Text(Statics.getLabel('ConfirmationNo')),
          //         onPressed: () {
          //           Navigator.of(ctnx).pop();
          Navigator.of(context).pop();
          //           // Navigator.of(ctx).pop();
          //         },
          //       ),
          //       MaterialButton(
          //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          //         padding: EdgeInsets.symmetric(
          //           horizontal: 15,
          //           vertical: 8,
          //         ),
          //         color: Theme.of(context).primaryColor,
          //         textColor: Theme.of(context).primaryTextTheme.labelMedium?.color,
          //         child: Text(Statics.getLabel('ConfirmationYes')),
          //         onPressed: () {
          //           Navigator.of(ctnx).pop();
          //           setState(() {
          //             _searchController.clear();
          //             _selectedPramukh = null;
          //           });
          //           // Navigator.pushReplacementNamed(context, AbhiyanAddSwayamsevakScreen.routeName);
          //         },
          //       ),
          //     ],
          //   ),
          // );
        } else {
          Statics.showToast(Statics.getLabel('unableToSaveData'));
        }
      }
    } catch (e) {
      Statics.showToast(Statics.getLabel('unableToSaveData'));
      log(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _selectedGeoUnitId = ModalRoute.of(context)?.settings.arguments as String?;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("अभियान कार्यकर्ता जोडा"),
      ),
      body: ModalProgressHUD(
        inAsyncCall: _isSearching,
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                SizedBox(height: 15),
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text(
                        "${Statics.getLabel('Search')} ",
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        ":",
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: TextField(
                        controller: _searchController,
                        style: TextStyle(fontSize: 16),
                        autofocus: false,
                        onChanged: (v) {
                          if (v.isEmpty) {
                            _selectedPramukh = null;
                          }
                          setState(() {});
                        },
                        inputFormatters: [LengthLimitingTextInputFormatter(10), FilteringTextInputFormatter.digitsOnly],
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          isDense: true,
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
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                if ((abhiyaanPramukhSwayamsevak != null && abhiyaanPramukhSwayamsevak!.isNotEmpty) && _searchController.text.isNotEmpty)
                  Container(
                    constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * 0.5),
                    child: ListView.separated(
                      shrinkWrap: true,
                      separatorBuilder: (context, index) => SizedBox(height: 12),
                      itemCount: abhiyaanPramukhSwayamsevak?.length ?? 0,
                      itemBuilder: (context, index) {
                        final _data = abhiyaanPramukhSwayamsevak![index];
                        return InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () => setState(() {
                            _selectedPramukh = _data;
                          }),
                          child: Card(
                            clipBehavior: Clip.antiAlias,
                            margin: EdgeInsets.all(5),
                            surfaceTintColor: Colors.transparent,
                            elevation: 5,
                            child: Container(
                                decoration: BoxDecoration(color: _selectedPramukh == _data ? Colors.purple.shade50 : Colors.white),
                                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            _data.participantName ?? "",
                                            style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                        if (_selectedPramukh == _data)
                                          Icon(
                                            Icons.check_box_rounded,
                                            color: Colors.purple,
                                          )
                                      ],
                                    ),
                                    SizedBox(height: 12),
                                    RichText(
                                        text: TextSpan(
                                      text: 'M: ${_data.participantNumber}',
                                      style: TextStyle(color: Colors.blue),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          UrlLauncher.launch("tel://" + (_data.participantNumber ?? ''));
                                        },
                                    ))
                                  ],
                                )),
                          ),
                        );
                      },
                    ),
                  ),
                // if (_isSearching)
                // Container(
                //     height: MediaQuery.of(context).size.height * 0.2,
                //     width: MediaQuery.of(context).size.width,
                //     padding: const EdgeInsets.all(5.0),
                //     child: Center(
                //       child: CircularProgressIndicator(),
                //     )),
                SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                // if (selectedDayitvValue.isNotEmpty)
                _selectedPramukh != null
                    ? MaterialButton(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        padding: EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 8,
                        ),
                        color: Theme.of(context).primaryColor,
                        textColor: Theme.of(context).primaryTextTheme.labelMedium?.color,
                        onPressed: () async {
                          FocusManager.instance.primaryFocus?.unfocus();
                          showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (ctnx) => AlertDialog(
                              title: Text(Statics.getLabel('AskConfirmation')),
                              content: Text("निवडलेले स्वयंसेवक प्रमुख म्हणून जोडायचे आहे का?"),
                              actions: <Widget>[
                                TextButton(
                                  child: Text(Statics.getLabel('ConfirmationNo')),
                                  onPressed: () {
                                    Navigator.of(ctnx).pop();
                                    // Navigator.of(context).pop();
                                    // Navigator.of(ctx).pop();
                                  },
                                ),
                                MaterialButton(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 15,
                                    vertical: 8,
                                  ),
                                  color: Theme.of(context).primaryColor,
                                  textColor: Theme.of(context).primaryTextTheme.labelMedium?.color,
                                  child: Text(Statics.getLabel('ConfirmationYes')),
                                  onPressed: () async {
                                    Navigator.of(ctnx).pop();
                                    await saveAbhiyaanSwayamsevakCall();
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                        child: Text(
                          Statics.getLabel('Submit'),
                          style: TextStyle(fontSize: 16),
                        ),
                      )
                    : ElevatedButton(
                        onPressed: () async {
                          FocusScope.of(context).unfocus();

                          // if (from == "swayamsevak") {
                          //   Fluttertoast.showToast(
                          //     msg: Statics.getLabel("workInProgress"),
                          //     toastLength: Toast.LENGTH_SHORT,
                          //     gravity: ToastGravity.BOTTOM,
                          //   );
                          //   return;
                          // }
                          if (_searchController.text.length < 10) {
                            Statics.showToast(Statics.getLabel('MobileValidationMessage'));
                            return null;
                          }
                          await _search("Search");
                          setState(() {});
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [Icon(Icons.search), SizedBox(width: 6), Text(Statics.getLabel("search"))],
                        ),
                      ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.015),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
