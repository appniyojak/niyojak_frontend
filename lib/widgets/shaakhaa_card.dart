import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

import '../helpers/static_data.dart' as Statics;
import '../screens/maps_display.dart';
import '../screens/shaakhaa_milan_module/edit_shaakhaa.dart';
import '../screens/shaakhaa_milan_module/edit_shaakhaa_vrutta.dart';
import '../screens/shaakhaa_milan_module/shaakhaa_pat.dart';
import '../screens/shaakhaa_milan_module/shaakhaa_sewa_vasti_link.dart';
import '../screens/shaakhaa_milan_module/shaakhaa_toli.dart';

class ShaakhaaCard extends StatelessWidget {
  final shaakhaaItem;
  final IsSankalpit;
  final IsNew;
  var onSaveDetails;
  final Widget? traillingIcon;
  final bool showOther;

  List<Statics.MenuItem>? menuItem;

  ShaakhaaCard(this.shaakhaaItem, this.IsSankalpit, this.onSaveDetails, {this.IsNew, this.traillingIcon, this.showOther = true}) {
    menuItem = [
      if ((int.tryParse(Statics.userDetails['LevelID'] ?? "0") ?? 0) >= 6 && (int.tryParse(Statics.userDetails['LevelID'] ?? "0") ?? 0) < 13)
        Statics.MenuItem(Statics.getLabel('EditMenu'), FontAwesomeIcons.edit, 'EditMenu'),
      Statics.MenuItem(Statics.getLabel('ViewMenu'), FontAwesomeIcons.eye, 'ViewMenu'),
      if (IsSankalpit == false) Statics.MenuItem(Statics.getLabel('ShaakhaaPat'), FontAwesomeIcons.building, 'ShaakhaaPat'),
      if (IsSankalpit == false) Statics.MenuItem(Statics.getLabel('Vrutta'), FontAwesomeIcons.database, 'Vrutta'),
      if (IsSankalpit == false) Statics.MenuItem(Statics.getLabel('ViewLocation'), Icons.location_pin, 'ViewLocation'),
      if (IsSankalpit == false) Statics.MenuItem(Statics.getLabel('RecordLocation'), Icons.location_searching, 'RecordLocation'),
      // if (((Statics.userDetails['LevelName'] == 'Bhaag' ||
      //             Statics.userDetails['LevelName'] == 'Nagar') &&
      //         (Statics.userDetails['DaayitvaName'] == 'Baal Vidyaarthi Pramukh'   ||
//  Statics.userDetails['DaayitvaName'] == 'बाल विद्यार्थी प्रमुख'   ||
//  Statics.userDetails['DaayitvaName'] == 'बाल विद्यार्थी प्रमुख'  ||
// Statics.userDetails['DaayitvaName'] == 'Mahaavidyaalayeen Vidyaarthi Pramukh'   ||
//  Statics.userDetails['DaayitvaName'] == 'महाविद्यालयीन प्रमुख'   ||
//  Statics.userDetails['DaayitvaName'] == 'महाविद्यालयीन प्रमुख'  ||
// Statics.userDetails['DaayitvaName'] == 'Vyavasaayee Pramukh'   ||
//  Statics.userDetails['DaayitvaName'] == 'व्यवसायी प्रमुख'   ||
//  Statics.userDetails['DaayitvaName'] == 'व्यवसायी प्रमुख'  ||
// Statics.userDetails['DaayitvaName'] == 'Vyavasaayee Saha-Pramukh'   ||
//  Statics.userDetails['DaayitvaName'] == 'व्यवसायी सह प्रमुख'   ||
//  Statics.userDetails['DaayitvaName'] == 'व्यवसायी सह प्रमुख'  ||
//  Statics.userDetails['DaayitvaName'] == 'Tarun Vyavsayee Pramukh' || Statics.userDetails['DaayitvaName'] == 'तरुण व्यवसायी प्रमुख' || Statics.userDetails['DaayitvaName'] == 'तरुण व्यवसायी प्रमुख' ||
// Statics.userDetails['DaayitvaName'] == 'Praudh Vyavsayee Pramukh' || Statics.userDetails['DaayitvaName'] == 'प्रौढ व्यवसायी प्रमुख' || Statics.userDetails['DaayitvaName'] == 'प्रौढ व्यवसायी प्रमुख' ||
// Statics.userDetails['DaayitvaName'] == 'Tarun Vyavsayee Sah Pramukh' || Statics.userDetails['DaayitvaName'] == 'तरुण व्यवसायी सह प्रमुख' || Statics.userDetails['DaayitvaName'] == 'तरुण व्यवसायी सह प्रमुख' ||
// Statics.userDetails['DaayitvaName'] == 'Praudh Vyavsayee Sah Pramukh' || Statics.userDetails['DaayitvaName'] == 'प्रौढ व्यवसायी सह प्रमुख' || Statics.userDetails['DaayitvaName'] == 'प्रौढ व्यवसायी सह प्रमुख' ||
// Statics.userDetails['DaayitvaName'] == 'Bal Vidyarthi Sah Pramukh' || Statics.userDetails['DaayitvaName'] == 'बाल विद्यार्थी सह प्रमुख' || Statics.userDetails['DaayitvaName'] == 'बाल विद्यार्थी सह प्रमुख' ||
// Statics.userDetails['DaayitvaName'] == 'Mahavidyaleen Vidyarthi Sah Pramukh' || Statics.userDetails['DaayitvaName'] == 'महाविद्यालयीन विद्यार्थी सह प्रमुख' || Statics.userDetails['DaayitvaName'] == 'महाविद्यालयीन विद्यार्थी सह प्रमुख' ||
// Statics.userDetails['DaayitvaName'] == 'App Sanyojak'  || Statics.userDetails['DaayitvaName'] == 'एप संयोजक' ||
      //             Statics.userDetails['DaayitvaName'] == 'Kaaryavaah' || Statics.userDetails['DaayitvaName'] == 'कार्यवाह' ||
      //             Statics.userDetails['DaayitvaName'] == 'Saha-Kaaryavaah' || Statics.userDetails['DaayitvaName'] == 'सह कार्यवाह' ||
      //             Statics.userDetails['DaayitvaName'] == 'Kaaryaalay Pramukh' || Statics.userDetails['DaayitvaName'] == 'कार्यालय प्रमुख')) ||
      //     (Statics.userDetails['LevelName'] == 'Praant' &&
      //         Statics.userDetails['DaayitvaName'] == 'Baal Vidyaarthi Pramukh'   ||
//  Statics.userDetails['DaayitvaName'] == 'बाल विद्यार्थी प्रमुख'   ||
//  Statics.userDetails['DaayitvaName'] == 'बाल विद्यार्थी प्रमुख'  ||
// Statics.userDetails['DaayitvaName'] == 'Mahaavidyaalayeen Vidyaarthi Pramukh'   ||
//  Statics.userDetails['DaayitvaName'] == 'महाविद्यालयीन प्रमुख'   ||
//  Statics.userDetails['DaayitvaName'] == 'महाविद्यालयीन प्रमुख'  ||
// Statics.userDetails['DaayitvaName'] == 'Vyavasaayee Pramukh'   ||
//  Statics.userDetails['DaayitvaName'] == 'व्यवसायी प्रमुख'   ||
//  Statics.userDetails['DaayitvaName'] == 'व्यवसायी प्रमुख'  ||
// Statics.userDetails['DaayitvaName'] == 'Vyavasaayee Saha-Pramukh'   ||
//  Statics.userDetails['DaayitvaName'] == 'व्यवसायी सह प्रमुख'   ||
//  Statics.userDetails['DaayitvaName'] == 'व्यवसायी सह प्रमुख'  ||
//  Statics.userDetails['DaayitvaName'] == 'Tarun Vyavsayee Pramukh' || Statics.userDetails['DaayitvaName'] == 'तरुण व्यवसायी प्रमुख' || Statics.userDetails['DaayitvaName'] == 'तरुण व्यवसायी प्रमुख' ||
// Statics.userDetails['DaayitvaName'] == 'Praudh Vyavsayee Pramukh' || Statics.userDetails['DaayitvaName'] == 'प्रौढ व्यवसायी प्रमुख' || Statics.userDetails['DaayitvaName'] == 'प्रौढ व्यवसायी प्रमुख' ||
// Statics.userDetails['DaayitvaName'] == 'Tarun Vyavsayee Sah Pramukh' || Statics.userDetails['DaayitvaName'] == 'तरुण व्यवसायी सह प्रमुख' || Statics.userDetails['DaayitvaName'] == 'तरुण व्यवसायी सह प्रमुख' ||
// Statics.userDetails['DaayitvaName'] == 'Praudh Vyavsayee Sah Pramukh' || Statics.userDetails['DaayitvaName'] == 'प्रौढ व्यवसायी सह प्रमुख' || Statics.userDetails['DaayitvaName'] == 'प्रौढ व्यवसायी सह प्रमुख' ||
// Statics.userDetails['DaayitvaName'] == 'Bal Vidyarthi Sah Pramukh' || Statics.userDetails['DaayitvaName'] == 'बाल विद्यार्थी सह प्रमुख' || Statics.userDetails['DaayitvaName'] == 'बाल विद्यार्थी सह प्रमुख' ||
// Statics.userDetails['DaayitvaName'] == 'Mahavidyaleen Vidyarthi Sah Pramukh' || Statics.userDetails['DaayitvaName'] == 'महाविद्यालयीन विद्यार्थी सह प्रमुख' || Statics.userDetails['DaayitvaName'] == 'महाविद्यालयीन विद्यार्थी सह प्रमुख' ||
// Statics.userDetails['DaayitvaName'] == 'App Sanyojak'  || Statics.userDetails['DaayitvaName'] == 'एप संयोजक') ||
      //     (Statics.userDetails['DaayitvaName'] == 'Prachaarak' || Statics.userDetails['DaayitvaName'] == 'प्रचारक' ||
      //         Statics.userDetails['DaayitvaName'] == 'Saha-Prachaarak' || Statics.userDetails['DaayitvaName'] == 'सह प्रचारक'))
      //   Statics.MenuItem(Statics.getLabel('Delete'), Icons.delete, 'Delete'),
      if (IsSankalpit == false) Statics.MenuItem(Statics.getLabel('SewaVasti'), Icons.house, 'SewaVasti'),
      if (IsSankalpit == false) Statics.MenuItem(Statics.getLabel('shaakhaaToli'), Icons.people, 'ShaakhaaToli'),
    ];
  }

  List<Statics.cLatLong> _latLng = [];

  void _recordLocation(var context) async {
    try {
      bool isConnected = await Statics.isInternetConnected();
      if (!isConnected) {
        Statics.showMessageDialog(context, Statics.getLabel('internetNotConnected'));
      } else {
        if (shaakhaaItem["ShaakhaaLatitude"] != null && shaakhaaItem["ShaakhaaLatitude"].toString() != "") {
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text(Statics.getLabel('AskConfirmation')),
              content: Text(Statics.getLabel('LocationAlreadyExists')),
              actions: <Widget>[
                MaterialButton(
                  child: Text(Statics.getLabel('ConfirmationYes')),
                  onPressed: () async {
                    saveLocation(ctx, true);
                  },
                ),
                MaterialButton(
                  child: Text(Statics.getLabel('ConfirmationNo')),
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                )
              ],
            ),
          );
        } else {
          saveLocation(context, false);
        }
      }
    } on Exception catch (error) {
      Statics.showErrorDialog(context, Statics.getLabel('unableToCompleteProcess'));
    } catch (error) {
      Statics.showErrorDialog(context, Statics.getLabel('unableToCompleteProcess'));
    }
  }

  Future<void> checkLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        print("Location permission permanently denied.");
        return;
      }
    }

    if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      print("Current Location: ${position.latitude}, ${position.longitude}");
    }
  }

  void saveLocation(var ctx, bool pop) async {
    await checkLocationPermission();
    Permission.location.request();
    // if (await Permission.location.request().isGranted) {
    var position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    var inputData = json
        .encode({"PraantID": 1, "ShaakhaaID": shaakhaaItem["ShaakhaaID"], "ShaakhaaLatitude": position.latitude, "ShaakhaaLongitude": position.longitude, "ModifiedBy": Statics.userDetails["userID"]});
    var data = await Statics.saveShaakhaaCoordinatesForApp(inputData);
    if (data == "Shaakhaa Coordinates Saved Successfully ") {
      Statics.showToast(Statics.getLabel('dataSavedSuccessfully'));
      onSaveDetails("Search", ctx);
    } else {
      print("e 1111");
      Statics.showToast(Statics.getLabel('CannotUpdateLocation'));
    }
    // } else {
    //   print("e 2222");
    //
    //   Statics.showErrorDialog(ctx, Statics.getLabel("CannotUpdateLocation"));
    // }
    if (pop) Navigator.of(ctx).pop();
  }

  void _deleteShaakhaa(var context, var shaakhaaID) async {
    try {
      bool isConnected = await Statics.isInternetConnected();
      if (!isConnected) {
        Statics.showMessageDialog(context, Statics.getLabel('internetNotConnected'));
      } else {
        var inputData = json.encode({"ShaakhaaID": shaakhaaID, "ModifiedBy": Statics.userDetails["userID"]});
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text(Statics.getLabel('AskConfirmation')),
            content: Text(Statics.getLabel('AreyouSureYouWantToDeleteShaakhaa')),
            actions: <Widget>[
              MaterialButton(
                child: Text(Statics.getLabel('ConfirmationYes')),
                onPressed: () async {
                  var data = await Statics.deleteShaakhaaForApp(inputData);
                  if (data == "Shaakhaa Deleted Successfully ") {
                    Statics.showToast(Statics.getLabel('ShaakhaaDeletedSuccessfully'));
                    onSaveDetails("Search", ctx);
                  } else
                    Statics.showToast(Statics.getLabel('CouldnotDeleteShaakhaa'));

                  Navigator.of(ctx).pop();
                },
              ),
              MaterialButton(
                child: Text(Statics.getLabel('ConfirmationNo')),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              )
            ],
          ),
        );
      }
    } on Exception catch (error) {
      Statics.showErrorDialog(context, Statics.getLabel('unableToCompleteProcess'));
    } catch (error) {
      Statics.showErrorDialog(context, Statics.getLabel('unableToCompleteProcess'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: IsNew == true ? Colors.lightBlue.shade100 : (IsSankalpit == true ? Colors.amber : null),
      margin: EdgeInsets.all(5),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start, // Aligns items to the top
          children: [
            // 1. The Title and Subtitle section wrapped in Expanded.
            // This tells Flutter: "Take up ALL remaining space dynamically, but do NOT exceed the screen."
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    shaakhaaItem["GeoUnitName"],
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 5),

                  // Subtitle (Your Wrap widget)
                  Wrap(
                    spacing: 10, // Replaces your hardcoded SizedBoxes! Much cleaner.
                    runSpacing: 4, // Space between lines if it drops to a new line
                    children: [
                      Text(shaakhaaItem["VayogatCode"].toString(), style: ListTileThemeData().subtitleTextStyle),
                      if (showOther) ...[
                        Text(shaakhaaItem["FrequencyCode"].toString(), style: ListTileThemeData().subtitleTextStyle),
                        if (shaakhaaItem["FrequencyID"].toString() == Statics.shaakhaaFrequencyWeekly.toString())
                          Text(shaakhaaItem["DayNamesOfWeek"].toString(), style: ListTileThemeData().subtitleTextStyle)
                        else if (shaakhaaItem["FrequencyCode"].toString() == "Monthly")
                          Text(shaakhaaItem["DayOfMonth"].toString(), style: ListTileThemeData().subtitleTextStyle),
                        Text("${shaakhaaItem["StartTimeStr"]}${shaakhaaItem["StartTimeStr"].toString().isEmpty ? "" : "-"}${shaakhaaItem["EndTimeStr"]}", style: ListTileThemeData().subtitleTextStyle),
                      ]
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: 12), // Dynamic buffer between text and trailing icon

            // 2. The Trailing Section
            // Because the text above is wrapped in Expanded, this will take
            // exactly the minimum space it needs at the very edge of the screen.
            traillingIcon ??
                PopupMenuButton(
                  onSelected: (value) {
                    if (value == 'ShaakhaaPat')
                      Navigator.of(context).pushNamed(ShaakhaaPat.routeName, arguments: Statics.ScreenArguments(shaakhaaItem["ShaakhaaID"], value));
                    else if (value == 'Vrutta')
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditShaakhaaVrutta(
                                    shaakhaaID: shaakhaaItem["ShaakhaaID"].toString(),
                                    vruttaID: "0",
                                    onSaveDetails: null,
                                    viewType: "EditVrutta",
                                  )));
                    // Navigator.of(context).pushNamed(ShaakhaaVrutta.routeName, arguments: Statics.ScreenArguments(shaakhaaItem["ShaakhaaID"], value));
                    else if (value == 'ViewLocation') {
                      if (shaakhaaItem["ShaakhaaLatitude"] != null && shaakhaaItem["ShaakhaaLatitude"].toString() != "") {
                        _latLng.add(Statics.cLatLong(shaakhaaItem["ShaakhaaID"], shaakhaaItem["GeoUnitName"].toString(), shaakhaaItem["FrequencyCode"].toString(),
                            LatLng(shaakhaaItem["ShaakhaaLatitude"], shaakhaaItem["ShaakhaaLongitude"])));
                        Navigator.of(context).pushNamed(MapDisplay.routeName, arguments: _latLng);
                      } else {
                        Statics.showMessageDialog(context, "Co-Ordinates Not present");
                      }
                    } else if (value == 'SewaVasti') {
                      Navigator.of(context).pushNamed(ShaakhaaSevaVastiLink.routeName, arguments: Statics.ScreenArguments(shaakhaaItem["ShaakhaaID"], shaakhaaItem["GeoUnitName"].toString()));
                    } else if (value == 'Delete') {
                      _deleteShaakhaa(context, shaakhaaItem["ShaakhaaID"].toString());
                    } else if (value == 'RecordLocation') {
                      _recordLocation(context);
                    } else if (value == 'ShaakhaaToli') {
                      Navigator.of(context).pushNamed(ShaakhaaToli.routeName, arguments: Statics.ScreenArguments(shaakhaaItem["ShaakhaaID"], shaakhaaItem["GeoUnitName"].toString()));
                    } else
                      Navigator.of(context).pushNamed(EditShaakhaaScreen.routeName, arguments: Statics.ScreenArguments(shaakhaaItem["ShaakhaaID"], value));
                  },
                  icon: const Icon(
                    FontAwesomeIcons.ellipsisV,
                    color: Colors.grey,
                  ),
                  itemBuilder: (BuildContext context) {
                    return menuItem!.map((Statics.MenuItem menuItem) {
                      return PopupMenuItem(
                        value: menuItem.menuKey,
                        child: ListTile(
                          leading: Icon(
                            menuItem.iconVal,
                            color: Colors.purple,
                          ),
                          title: Text(menuItem.menuVal),
                        ),
                      );
                    }).toList();
                  },
                ),
          ],
        ),
      ),
    );
  }
}
