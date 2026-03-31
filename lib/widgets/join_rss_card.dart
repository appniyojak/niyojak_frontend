import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../screens/edit_join_rss.dart';

import 'package:url_launcher/url_launcher.dart' as UrlLauncher;
import '../helpers/static_data.dart' as Statics;
import '../screens/edit_shaakhaa.dart';
import '../screens/edit_swayamsevak_basic_info.dart';
import '../screens/edit_swayamsevak_screen.dart';

class JoinRSSCard extends StatelessWidget {
  final joinRSSItem;
  Future<void> Function(dynamic outputType) searchNew;

  JoinRSSCard(this.joinRSSItem, this.searchNew);

  final List<Statics.MenuItem> menuItem = [
    if (
        // (Statics.userDetails["LevelName"] == "Praant" ||
        //         Statics.userDetails["LevelName"] == "Mahaanagar" ||
        //         Statics.userDetails["LevelName"] == "Vibhaag" ||
        //         Statics.userDetails["LevelName"] == "Bhaag" ||
        //         Statics.userDetails["LevelName"] == "Shahar" ||
        //         Statics.userDetails["LevelName"] == "Nagar")
        (Statics.userDetails["LevelName"] == "Praant" ||
            Statics.userDetails["LevelName"] == "प्रांत" ||
            Statics.userDetails["LevelName"] == "Mahaanagar" ||
            Statics.userDetails["LevelName"] == "महानगर" ||
            Statics.userDetails["LevelName"] == "Vibhaag" ||
            Statics.userDetails["LevelName"] == "विभाग" ||
            Statics.userDetails["LevelName"] == "Bhaag" ||
            Statics.userDetails["LevelName"] == "भाग/जिला" ||
            Statics.userDetails["LevelName"] == "भाग/जिल्हा" ||
            Statics.userDetails["LevelName"] == "Shahar" ||
            Statics.userDetails["LevelName"] == "शहर" ||
            Statics.userDetails["LevelName"] == "Nagar" ||
            Statics.userDetails["LevelName"] == "नगर/तालुका")
//         &&
//         // (Statics.userDetails["DaayitvaName"] == "Join RSS Sanyojak" ||
//         //     Statics.userDetails["DaayitvaName"] == "Baal Vidyaarthi Pramukh"   || Statics.userDetails["DaayitvaName"] == "बाल विद्यार्थी प्रमुख"   || Statics.userDetails["DaayitvaName"] == "बाल विद्यार्थी प्रमुख"  ||Statics.userDetails["DaayitvaName"] == "Mahaavidyaalayeen Vidyaarthi Pramukh"   || Statics.userDetails["DaayitvaName"] == "महाविद्यालयीन प्रमुख"   || Statics.userDetails["DaayitvaName"] == "महाविद्यालयीन प्रमुख"  ||Statics.userDetails["DaayitvaName"] == "Vyavasaayee Pramukh"   || Statics.userDetails["DaayitvaName"] == "व्यवसायी प्रमुख"   || Statics.userDetails["DaayitvaName"] == "व्यवसायी प्रमुख"  ||Statics.userDetails["DaayitvaName"] == "Vyavasaayee Saha-Pramukh"   || Statics.userDetails["DaayitvaName"] == "व्यवसायी सह प्रमुख"   || Statics.userDetails["DaayitvaName"] == "व्यवसायी सह प्रमुख"  || Statics.userDetails["DaayitvaName"] == "Tarun Vyavsayee Pramukh" || Statics.userDetails["DaayitvaName"] == "तरुण व्यवसायी प्रमुख" || Statics.userDetails["DaayitvaName"] == "तरुण व्यवसायी प्रमुख" ||
// Statics.userDetails["DaayitvaName"] == "Praudh Vyavsayee Pramukh" || Statics.userDetails["DaayitvaName"] == "प्रौढ व्यवसायी प्रमुख" || Statics.userDetails["DaayitvaName"] == "प्रौढ व्यवसायी प्रमुख" ||
// Statics.userDetails["DaayitvaName"] == "Tarun Vyavsayee Sah Pramukh" || Statics.userDetails["DaayitvaName"] == "तरुण व्यवसायी सह प्रमुख" || Statics.userDetails["DaayitvaName"] == "तरुण व्यवसायी सह प्रमुख" ||
// Statics.userDetails["DaayitvaName"] == "Praudh Vyavsayee Sah Pramukh" || Statics.userDetails["DaayitvaName"] == "प्रौढ व्यवसायी सह प्रमुख" || Statics.userDetails["DaayitvaName"] == "प्रौढ व्यवसायी सह प्रमुख" ||
// Statics.userDetails["DaayitvaName"] == "Bal Vidyarthi Sah Pramukh" || Statics.userDetails["DaayitvaName"] == "बाल विद्यार्थी सह प्रमुख" || Statics.userDetails["DaayitvaName"] == "बाल विद्यार्थी सह प्रमुख" ||
// Statics.userDetails["DaayitvaName"] == "Mahavidyaleen Vidyarthi Sah Pramukh" || Statics.userDetails["DaayitvaName"] == "महाविद्यालयीन विद्यार्थी सह प्रमुख" || Statics.userDetails["DaayitvaName"] == "महाविद्यालयीन विद्यार्थी सह प्रमुख" ||
// Statics.userDetails["DaayitvaName"] == "App Sanyojak"  ||
//         //     Statics.userDetails["DaayitvaName"] == "Prachaarak" ||
//         //     Statics.userDetails["DaayitvaName"] == "Saha-Prachaarak" ||
//         //     Statics.userDetails["DaayitvaName"] == "Kaaryaalay Pramukh" ||
//         //     Statics.userDetails["DaayitvaName"] == "Kaaryavaah" ||
//         //     Statics.userDetails["DaayitvaName"] == "Saha-Kaaryavaah")
//         (Statics.userDetails["DaayitvaName"] == "Join RSS Sanyojak" || Statics.userDetails["DaayitvaName"] == "जॉयन आर.एस.एस. संयोजक" ||
//             Statics.userDetails["DaayitvaName"] == "Join RSS Pramukh" || Statics.userDetails["DaayitvaName"] == "जॉयन आर.एस.एस. प्रमुख" ||
//             Statics.userDetails["DaayitvaName"] == "Baal Vidyaarthi Pramukh"   || Statics.userDetails["DaayitvaName"] == "बाल विद्यार्थी प्रमुख"   || Statics.userDetails["DaayitvaName"] == "बाल विद्यार्थी प्रमुख"  ||Statics.userDetails["DaayitvaName"] == "Mahaavidyaalayeen Vidyaarthi Pramukh"   || Statics.userDetails["DaayitvaName"] == "महाविद्यालयीन प्रमुख"   || Statics.userDetails["DaayitvaName"] == "महाविद्यालयीन प्रमुख"  ||Statics.userDetails["DaayitvaName"] == "Vyavasaayee Pramukh"   || Statics.userDetails["DaayitvaName"] == "व्यवसायी प्रमुख"   || Statics.userDetails["DaayitvaName"] == "व्यवसायी प्रमुख"  ||Statics.userDetails["DaayitvaName"] == "Vyavasaayee Saha-Pramukh"   || Statics.userDetails["DaayitvaName"] == "व्यवसायी सह प्रमुख"   || Statics.userDetails["DaayitvaName"] == "व्यवसायी सह प्रमुख"  || Statics.userDetails["DaayitvaName"] == "Tarun Vyavsayee Pramukh" || Statics.userDetails["DaayitvaName"] == "तरुण व्यवसायी प्रमुख" || Statics.userDetails["DaayitvaName"] == "तरुण व्यवसायी प्रमुख" ||
// Statics.userDetails["DaayitvaName"] == "Praudh Vyavsayee Pramukh" || Statics.userDetails["DaayitvaName"] == "प्रौढ व्यवसायी प्रमुख" || Statics.userDetails["DaayitvaName"] == "प्रौढ व्यवसायी प्रमुख" ||
// Statics.userDetails["DaayitvaName"] == "Tarun Vyavsayee Sah Pramukh" || Statics.userDetails["DaayitvaName"] == "तरुण व्यवसायी सह प्रमुख" || Statics.userDetails["DaayitvaName"] == "तरुण व्यवसायी सह प्रमुख" ||
// Statics.userDetails["DaayitvaName"] == "Praudh Vyavsayee Sah Pramukh" || Statics.userDetails["DaayitvaName"] == "प्रौढ व्यवसायी सह प्रमुख" || Statics.userDetails["DaayitvaName"] == "प्रौढ व्यवसायी सह प्रमुख" ||
// Statics.userDetails["DaayitvaName"] == "Bal Vidyarthi Sah Pramukh" || Statics.userDetails["DaayitvaName"] == "बाल विद्यार्थी सह प्रमुख" || Statics.userDetails["DaayitvaName"] == "बाल विद्यार्थी सह प्रमुख" ||
// Statics.userDetails["DaayitvaName"] == "Mahavidyaleen Vidyarthi Sah Pramukh" || Statics.userDetails["DaayitvaName"] == "महाविद्यालयीन विद्यार्थी सह प्रमुख" || Statics.userDetails["DaayitvaName"] == "महाविद्यालयीन विद्यार्थी सह प्रमुख" ||
// Statics.userDetails["DaayitvaName"] == "App Sanyojak"  ||Statics.userDetails["DaayitvaName"] == "एप संयोजक" ||
//             Statics.userDetails["DaayitvaName"] == "Prachaarak" ||Statics.userDetails["DaayitvaName"] == "प्रचारक" ||
//             Statics.userDetails["DaayitvaName"] == "Saha-Prachaarak" ||Statics.userDetails["DaayitvaName"] == "सह प्रचारक" ||
//             Statics.userDetails["DaayitvaName"] == "Kaaryaalay Pramukh" ||Statics.userDetails["DaayitvaName"] == "कार्यालय प्रमुख" ||
//             Statics.userDetails["DaayitvaName"] == "Kaaryavaah" ||Statics.userDetails["DaayitvaName"] == "कार्यवाह" ||
//             Statics.userDetails["DaayitvaName"] == "karyalay sachiv" ||Statics.userDetails["DaayitvaName"] == "कार्यालय सचिव" ||
//             Statics.userDetails["DaayitvaName"] == "Saha-Kaaryavaah" || Statics.userDetails["DaayitvaName"] == "सह कार्यवाह")
        )
      Statics.MenuItem(Statics.getLabel('EditMenu'), FontAwesomeIcons.edit, 'EditMenu'),
    Statics.MenuItem(Statics.getLabel('ViewMenu'), FontAwesomeIcons.eye, 'ViewMenu'),
    if (
        // (Statics.userDetails["LevelName"] == "Praant" ||
        //         Statics.userDetails["LevelName"] == "Mahaanagar" ||
        //         Statics.userDetails["LevelName"] == "Vibhaag" ||
        //         Statics.userDetails["LevelName"] == "Bhaag" ||
        //         Statics.userDetails["LevelName"] == "Shahar" ||
        //         Statics.userDetails["LevelName"] == "Nagar")
        (Statics.userDetails["LevelName"] == "Praant" ||
            Statics.userDetails["LevelName"] == "प्रांत" ||
            Statics.userDetails["LevelName"] == "Mahaanagar" ||
            Statics.userDetails["LevelName"] == "महानगर" ||
            Statics.userDetails["LevelName"] == "Vibhaag" ||
            Statics.userDetails["LevelName"] == "विभाग" ||
            Statics.userDetails["LevelName"] == "Bhaag" ||
            Statics.userDetails["LevelName"] == "भाग/जिला" ||
            Statics.userDetails["LevelName"] == "भाग/जिल्हा" ||
            Statics.userDetails["LevelName"] == "Shahar" ||
            Statics.userDetails["LevelName"] == "शहर" ||
            Statics.userDetails["LevelName"] == "Nagar" ||
            Statics.userDetails["LevelName"] == "नगर/तालुका")
//         &&
//         // (Statics.userDetails["DaayitvaName"] == "Join RSS Sanyojak" ||
//         //     Statics.userDetails["DaayitvaName"] == "Baal Vidyaarthi Pramukh"   || Statics.userDetails["DaayitvaName"] == "बाल विद्यार्थी प्रमुख"   || Statics.userDetails["DaayitvaName"] == "बाल विद्यार्थी प्रमुख"  ||Statics.userDetails["DaayitvaName"] == "Mahaavidyaalayeen Vidyaarthi Pramukh"   || Statics.userDetails["DaayitvaName"] == "महाविद्यालयीन प्रमुख"   || Statics.userDetails["DaayitvaName"] == "महाविद्यालयीन प्रमुख"  ||Statics.userDetails["DaayitvaName"] == "Vyavasaayee Pramukh"   || Statics.userDetails["DaayitvaName"] == "व्यवसायी प्रमुख"   || Statics.userDetails["DaayitvaName"] == "व्यवसायी प्रमुख"  ||Statics.userDetails["DaayitvaName"] == "Vyavasaayee Saha-Pramukh"   || Statics.userDetails["DaayitvaName"] == "व्यवसायी सह प्रमुख"   || Statics.userDetails["DaayitvaName"] == "व्यवसायी सह प्रमुख"  || Statics.userDetails["DaayitvaName"] == "Tarun Vyavsayee Pramukh" || Statics.userDetails["DaayitvaName"] == "तरुण व्यवसायी प्रमुख" || Statics.userDetails["DaayitvaName"] == "तरुण व्यवसायी प्रमुख" ||
// Statics.userDetails["DaayitvaName"] == "Praudh Vyavsayee Pramukh" || Statics.userDetails["DaayitvaName"] == "प्रौढ व्यवसायी प्रमुख" || Statics.userDetails["DaayitvaName"] == "प्रौढ व्यवसायी प्रमुख" ||
// Statics.userDetails["DaayitvaName"] == "Tarun Vyavsayee Sah Pramukh" || Statics.userDetails["DaayitvaName"] == "तरुण व्यवसायी सह प्रमुख" || Statics.userDetails["DaayitvaName"] == "तरुण व्यवसायी सह प्रमुख" ||
// Statics.userDetails["DaayitvaName"] == "Praudh Vyavsayee Sah Pramukh" || Statics.userDetails["DaayitvaName"] == "प्रौढ व्यवसायी सह प्रमुख" || Statics.userDetails["DaayitvaName"] == "प्रौढ व्यवसायी सह प्रमुख" ||
// Statics.userDetails["DaayitvaName"] == "Bal Vidyarthi Sah Pramukh" || Statics.userDetails["DaayitvaName"] == "बाल विद्यार्थी सह प्रमुख" || Statics.userDetails["DaayitvaName"] == "बाल विद्यार्थी सह प्रमुख" ||
// Statics.userDetails["DaayitvaName"] == "Mahavidyaleen Vidyarthi Sah Pramukh" || Statics.userDetails["DaayitvaName"] == "महाविद्यालयीन विद्यार्थी सह प्रमुख" || Statics.userDetails["DaayitvaName"] == "महाविद्यालयीन विद्यार्थी सह प्रमुख" ||
// Statics.userDetails["DaayitvaName"] == "App Sanyojak"  ||
//         //     Statics.userDetails["DaayitvaName"] == "Prachaarak" ||
//         //     Statics.userDetails["DaayitvaName"] == "Saha-Prachaarak" ||
//         //     Statics.userDetails["DaayitvaName"] == "Kaaryaalay Pramukh" ||
//         //     Statics.userDetails["DaayitvaName"] == "Kaaryavaah" ||
//         //     Statics.userDetails["DaayitvaName"] == "Saha-Kaaryavaah")
//         (Statics.userDetails["DaayitvaName"] == "Join RSS Sanyojak" || Statics.userDetails["DaayitvaName"] == "जॉयन आर.एस.एस. संयोजक" ||
//             Statics.userDetails["DaayitvaName"] == "Join RSS Pramukh" || Statics.userDetails["DaayitvaName"] == "जॉयन आर.एस.एस. प्रमुख" ||
//             Statics.userDetails["DaayitvaName"] == "Baal Vidyaarthi Pramukh"   || Statics.userDetails["DaayitvaName"] == "बाल विद्यार्थी प्रमुख"   || Statics.userDetails["DaayitvaName"] == "बाल विद्यार्थी प्रमुख"  ||Statics.userDetails["DaayitvaName"] == "Mahaavidyaalayeen Vidyaarthi Pramukh"   || Statics.userDetails["DaayitvaName"] == "महाविद्यालयीन प्रमुख"   || Statics.userDetails["DaayitvaName"] == "महाविद्यालयीन प्रमुख"  ||Statics.userDetails["DaayitvaName"] == "Vyavasaayee Pramukh"   || Statics.userDetails["DaayitvaName"] == "व्यवसायी प्रमुख"   || Statics.userDetails["DaayitvaName"] == "व्यवसायी प्रमुख"  ||Statics.userDetails["DaayitvaName"] == "Vyavasaayee Saha-Pramukh"   || Statics.userDetails["DaayitvaName"] == "व्यवसायी सह प्रमुख"   || Statics.userDetails["DaayitvaName"] == "व्यवसायी सह प्रमुख"  || Statics.userDetails["DaayitvaName"] == "Tarun Vyavsayee Pramukh" || Statics.userDetails["DaayitvaName"] == "तरुण व्यवसायी प्रमुख" || Statics.userDetails["DaayitvaName"] == "तरुण व्यवसायी प्रमुख" ||
// Statics.userDetails["DaayitvaName"] == "Praudh Vyavsayee Pramukh" || Statics.userDetails["DaayitvaName"] == "प्रौढ व्यवसायी प्रमुख" || Statics.userDetails["DaayitvaName"] == "प्रौढ व्यवसायी प्रमुख" ||
// Statics.userDetails["DaayitvaName"] == "Tarun Vyavsayee Sah Pramukh" || Statics.userDetails["DaayitvaName"] == "तरुण व्यवसायी सह प्रमुख" || Statics.userDetails["DaayitvaName"] == "तरुण व्यवसायी सह प्रमुख" ||
// Statics.userDetails["DaayitvaName"] == "Praudh Vyavsayee Sah Pramukh" || Statics.userDetails["DaayitvaName"] == "प्रौढ व्यवसायी सह प्रमुख" || Statics.userDetails["DaayitvaName"] == "प्रौढ व्यवसायी सह प्रमुख" ||
// Statics.userDetails["DaayitvaName"] == "Bal Vidyarthi Sah Pramukh" || Statics.userDetails["DaayitvaName"] == "बाल विद्यार्थी सह प्रमुख" || Statics.userDetails["DaayitvaName"] == "बाल विद्यार्थी सह प्रमुख" ||
// Statics.userDetails["DaayitvaName"] == "Mahavidyaleen Vidyarthi Sah Pramukh" || Statics.userDetails["DaayitvaName"] == "महाविद्यालयीन विद्यार्थी सह प्रमुख" || Statics.userDetails["DaayitvaName"] == "महाविद्यालयीन विद्यार्थी सह प्रमुख" ||
// Statics.userDetails["DaayitvaName"] == "App Sanyojak"  ||Statics.userDetails["DaayitvaName"] == "एप संयोजक" ||
//             Statics.userDetails["DaayitvaName"] == "Prachaarak" ||Statics.userDetails["DaayitvaName"] == "प्रचारक" ||
//             Statics.userDetails["DaayitvaName"] == "Saha-Prachaarak" ||Statics.userDetails["DaayitvaName"] == "सह प्रचारक" ||
//             Statics.userDetails["DaayitvaName"] == "Kaaryaalay Pramukh" ||Statics.userDetails["DaayitvaName"] == "कार्यालय प्रमुख" ||
//             Statics.userDetails["DaayitvaName"] == "Kaaryavaah" ||Statics.userDetails["DaayitvaName"] == "कार्यवाह" ||
//             Statics.userDetails["DaayitvaName"] == "karyalay sachiv" ||Statics.userDetails["DaayitvaName"] == "कार्यालय सचिव" ||
//             Statics.userDetails["DaayitvaName"] == "Saha-Kaaryavaah" || Statics.userDetails["DaayitvaName"] == "सह कार्यवाह")
        )
      Statics.MenuItem(Statics.getLabel('DeleteMenu'), FontAwesomeIcons.remove, 'DeleteMenu'),
    Statics.MenuItem(Statics.getLabel('AddSwayamsevak'), FontAwesomeIcons.add, 'AddSwayamsevak'),
  ];

  void _deleteEntry(var context, var joinRssID) async {
    try {
      bool isConnected = await Statics.isInternetConnected();
      if (!isConnected) {
        Statics.showMessageDialog(context, Statics.getLabel('internetNotConnected'));
      } else {
        var inputData = json.encode({
          "JoinRSSID": joinRssID,
        });
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text(Statics.getLabel('AskConfirmation')),
            content: Text(Statics.getLabel('AreyouSureYouWantToDeleteJoinRSS')),
            actions: <Widget>[
              MaterialButton(
                child: Text(Statics.getLabel('ConfirmationYes')),
                onPressed: () async {
                  print("inputDataaaaa :----- $inputData");

                  var data = await Statics.deleteJoinRSS(inputData);
                  print("Dataaa :----- $data");
                  if (data.contains("Deleted Successfully")) {
                    searchNew('search');
                    Statics.showToast(Statics.getLabel('JoinRSSDeletedSuccessfully'));
                  } else
                    Statics.showToast(Statics.getLabel('CouldNotDeleteJoinRSS'));

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
      margin: EdgeInsets.all(5),
      elevation: 5,
      child: ListTile(
        title: Text(joinRSSItem["Name"]),
        trailing: Container(
          height: 50,
          width: 0.1 * Statics.getDeviceSize(context).width,
          child: Stack(
            children: [
              Positioned(
                right: 0.0,
                top: 0.0,
                child: PopupMenuButton(
                  onSelected: (value) {
                    if (value == 'DeleteMenu') {
                      _deleteEntry(context, joinRSSItem["JoinRSSID"]);
                    } else if (value == 'AddSwayamsevak') {
                      Navigator.of(context).pushNamed(
                        EditSwayamsevakScreen.routeName,
                        arguments: Statics.ScreenArgumentsNew(
                          joinRSSItem["JoinRSSID"],
                          "JoinRss",
                          name: joinRSSItem["Name"],
                          email: joinRSSItem['Email'],
                          mobile: joinRSSItem["MobileNumber"],
                        ),
                      );
                      print("viewType  JoinRss -- name ${joinRSSItem["Name"]} -- email ${joinRSSItem['Email']} -- mobile ${joinRSSItem["MobileNumber"]}");
                    } else {
                      Navigator.of(context).pushNamed(EditJoinRss.routeName, arguments: Statics.ScreenArguments(joinRSSItem["JoinRSSID"], value));
                    }
                  },
                  icon: Icon(
                    FontAwesomeIcons.ellipsisV,
                    color: Colors.grey,
                  ),
                  itemBuilder: (BuildContext context) {
                    return menuItem.map((Statics.MenuItem menuItem) {
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
              ),
            ],
          ),
        ),
        subtitle: Container(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 5,
            ),
            Wrap(
              spacing: 1,
              children: [
                Text('${Statics.getLabel("JoiningDate")}: '),
                Text('${joinRSSItem["JoiningDateStr"].toString()}, '),
                Text('${Statics.getLabel("Age")}: '),
                Text('${joinRSSItem["Age"]}, '),
                Text('${Statics.getLabel("Status")}: '),
                Text('${joinRSSItem["StatusCode"].toString()}, '),
                Text('${Statics.getLabel("StatusDate")}: '),
                Text('${joinRSSItem["StatusDateStr"]}, '),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Wrap(spacing: 2, children: [
              RichText(
                  text: TextSpan(
                text: 'M: ${joinRSSItem["MobileNumber"].toString()}',
                style: TextStyle(color: Colors.blue),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    UrlLauncher.launch("tel://" + joinRSSItem["MobileNumber"].toString());
                  },
              )),
              if (joinRSSItem['Email'].toString().isNotEmpty)
                RichText(
                  text: TextSpan(
                      text: 'E: ${joinRSSItem["Email"].toString()}',
                      style: TextStyle(color: Colors.blue),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          UrlLauncher.launch("mailto:" + joinRSSItem["Email"].toString());
                        }),
                )
            ]),
          ],
        )),
      ),
    );
  }
}
