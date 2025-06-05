import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../screens/edit_sewa_vasti.dart';

import '../helpers/static_data.dart' as Statics;

class SewaVastiCard extends StatelessWidget {
  final sewaVastiItem;
  var onSaveDetails;
  SewaVastiCard(this.sewaVastiItem, this.onSaveDetails);

  final List<Statics.MenuItem> menuItem = [
    if (
    // Statics.userDetails["LevelName"] == "Bhaag"
    (Statics.userDetails["LevelName"] == "Bhaag" ||Statics.userDetails["LevelName"] == "भाग/जिला"||Statics.userDetails["LevelName"] == "भाग/जिल्हा" ||
        Statics.userDetails["LevelName"] == "Nagar" ||Statics.userDetails["LevelName"] == "Nagar\/Taalukaa" || Statics.userDetails["LevelName"] == "नगर/तालुका"||int.parse(Statics.userDetails["LevelID"]) >= 6 )
        &&
        // (Statics.userDetails["DaayitvaName"] == "Baal Vidyaarthi Pramukh"   || Statics.userDetails["DaayitvaName"] == "बाल विद्यार्थी प्रमुख"   || Statics.userDetails["DaayitvaName"] == "बाल विद्यार्थी प्रमुख"  ||Statics.userDetails["DaayitvaName"] == "Mahaavidyaalayeen Vidyaarthi Pramukh"   || Statics.userDetails["DaayitvaName"] == "महाविद्यालयीन प्रमुख"   || Statics.userDetails["DaayitvaName"] == "महाविद्यालयीन प्रमुख"  ||Statics.userDetails["DaayitvaName"] == "Vyavasaayee Pramukh"   || Statics.userDetails["DaayitvaName"] == "व्यवसायी प्रमुख"   || Statics.userDetails["DaayitvaName"] == "व्यवसायी प्रमुख"  ||Statics.userDetails["DaayitvaName"] == "Vyavasaayee Saha-Pramukh"   || Statics.userDetails["DaayitvaName"] == "व्यवसायी सह प्रमुख"   || Statics.userDetails["DaayitvaName"] == "व्यवसायी सह प्रमुख"  || Statics.userDetails["DaayitvaName"] == "Tarun Vyavsayee Pramukh" || Statics.userDetails["DaayitvaName"] == "तरुण व्यवसायी प्रमुख" || Statics.userDetails["DaayitvaName"] == "तरुण व्यवसायी प्रमुख" ||
Statics.userDetails["DaayitvaName"] == "Praudh Vyavsayee Pramukh" || Statics.userDetails["DaayitvaName"] == "प्रौढ व्यवसायी प्रमुख" || Statics.userDetails["DaayitvaName"] == "प्रौढ व्यवसायी प्रमुख" ||
Statics.userDetails["DaayitvaName"] == "Tarun Vyavsayee Sah Pramukh" || Statics.userDetails["DaayitvaName"] == "तरुण व्यवसायी सह प्रमुख" || Statics.userDetails["DaayitvaName"] == "तरुण व्यवसायी सह प्रमुख" ||
Statics.userDetails["DaayitvaName"] == "Praudh Vyavsayee Sah Pramukh" || Statics.userDetails["DaayitvaName"] == "प्रौढ व्यवसायी सह प्रमुख" || Statics.userDetails["DaayitvaName"] == "प्रौढ व्यवसायी सह प्रमुख" ||
Statics.userDetails["DaayitvaName"] == "Bal Vidyarthi Sah Pramukh" || Statics.userDetails["DaayitvaName"] == "बाल विद्यार्थी सह प्रमुख" || Statics.userDetails["DaayitvaName"] == "बाल विद्यार्थी सह प्रमुख" ||
Statics.userDetails["DaayitvaName"] == "Mahavidyaleen Vidyarthi Sah Pramukh" || Statics.userDetails["DaayitvaName"] == "महाविद्यालयीन विद्यार्थी सह प्रमुख" || Statics.userDetails["DaayitvaName"] == "महाविद्यालयीन विद्यार्थी सह प्रमुख" ||
Statics.userDetails["DaayitvaName"] == "App Sanyojak"  ||
        //     Statics.userDetails["DaayitvaName"] == "Kaaryavaah" ||
        //     Statics.userDetails["DaayitvaName"] == "Saha-Kaaryavaah" ||
        //     Statics.userDetails["DaayitvaName"] == "Sewa Pramukh" ||
        //     Statics.userDetails["DaayitvaName"] == "Saha-SewaPramukh" ||
        //     Statics.userDetails['DaayitvaName'] == 'Kaaryaalay Pramukh' ||
        //     Statics.userDetails['DaayitvaName'] == 'Prachaarak' ||
        //     Statics.userDetails['DaayitvaName'] == 'Saha-Prachaarak')
        (Statics.userDetails["DaayitvaName"] == "Join RSS Sanyojak" || Statics.userDetails["DaayitvaName"] == "जॉयन आर.एस.एस. संयोजक" ||
            Statics.userDetails["DaayitvaName"] == "Join RSS Pramukh" || Statics.userDetails["DaayitvaName"] == "जॉयन आर.एस.एस. प्रमुख" ||
            Statics.userDetails["DaayitvaName"] == "Baal Vidyaarthi Pramukh"   || Statics.userDetails["DaayitvaName"] == "बाल विद्यार्थी प्रमुख"   || Statics.userDetails["DaayitvaName"] == "बाल विद्यार्थी प्रमुख"  ||Statics.userDetails["DaayitvaName"] == "Mahaavidyaalayeen Vidyaarthi Pramukh"   || Statics.userDetails["DaayitvaName"] == "महाविद्यालयीन प्रमुख"   || Statics.userDetails["DaayitvaName"] == "महाविद्यालयीन प्रमुख"  ||Statics.userDetails["DaayitvaName"] == "Vyavasaayee Pramukh"   || Statics.userDetails["DaayitvaName"] == "व्यवसायी प्रमुख"   || Statics.userDetails["DaayitvaName"] == "व्यवसायी प्रमुख"  ||Statics.userDetails["DaayitvaName"] == "Vyavasaayee Saha-Pramukh"   || Statics.userDetails["DaayitvaName"] == "व्यवसायी सह प्रमुख"   || Statics.userDetails["DaayitvaName"] == "व्यवसायी सह प्रमुख"  || Statics.userDetails["DaayitvaName"] == "Tarun Vyavsayee Pramukh" || Statics.userDetails["DaayitvaName"] == "तरुण व्यवसायी प्रमुख" || Statics.userDetails["DaayitvaName"] == "तरुण व्यवसायी प्रमुख" ||
Statics.userDetails["DaayitvaName"] == "Praudh Vyavsayee Pramukh" || Statics.userDetails["DaayitvaName"] == "प्रौढ व्यवसायी प्रमुख" || Statics.userDetails["DaayitvaName"] == "प्रौढ व्यवसायी प्रमुख" ||
Statics.userDetails["DaayitvaName"] == "Tarun Vyavsayee Sah Pramukh" || Statics.userDetails["DaayitvaName"] == "तरुण व्यवसायी सह प्रमुख" || Statics.userDetails["DaayitvaName"] == "तरुण व्यवसायी सह प्रमुख" ||
Statics.userDetails["DaayitvaName"] == "Praudh Vyavsayee Sah Pramukh" || Statics.userDetails["DaayitvaName"] == "प्रौढ व्यवसायी सह प्रमुख" || Statics.userDetails["DaayitvaName"] == "प्रौढ व्यवसायी सह प्रमुख" ||
Statics.userDetails["DaayitvaName"] == "Bal Vidyarthi Sah Pramukh" || Statics.userDetails["DaayitvaName"] == "बाल विद्यार्थी सह प्रमुख" || Statics.userDetails["DaayitvaName"] == "बाल विद्यार्थी सह प्रमुख" ||
Statics.userDetails["DaayitvaName"] == "Mahavidyaleen Vidyarthi Sah Pramukh" || Statics.userDetails["DaayitvaName"] == "महाविद्यालयीन विद्यार्थी सह प्रमुख" || Statics.userDetails["DaayitvaName"] == "महाविद्यालयीन विद्यार्थी सह प्रमुख" ||
Statics.userDetails["DaayitvaName"] == "App Sanyojak"  ||Statics.userDetails["DaayitvaName"] == "एप संयोजक" ||
            Statics.userDetails["DaayitvaName"] == "Kaaryavaah" ||Statics.userDetails["DaayitvaName"] == "कार्यवाह" ||
            Statics.userDetails["DaayitvaName"] == "karyalay sachiv" ||Statics.userDetails["DaayitvaName"] == "कार्यालय सचिव" ||
            Statics.userDetails["DaayitvaName"] == "Saha-Kaaryavaah" ||Statics.userDetails["DaayitvaName"] == "सह कार्यवाह" ||
            Statics.userDetails["DaayitvaName"] == "Sewa Pramukh" ||Statics.userDetails["DaayitvaName"] == "सेवा प्रमुख" ||
            Statics.userDetails["DaayitvaName"] == "Sewa Vibhaag - Toli Sadasya" ||Statics.userDetails["DaayitvaName"] == "सेवा विभाग टोली सदस्य" ||
            Statics.userDetails["DaayitvaName"] == "Saha-SewaPramukh" ||
            Statics.userDetails['DaayitvaName'] == 'Kaaryaalay Pramukh' ||Statics.userDetails['DaayitvaName'] == 'कार्यालय प्रमुख' ||
            Statics.userDetails['DaayitvaName'] == 'Prachaarak' ||Statics.userDetails['DaayitvaName'] == 'प्रचारक' ||
            Statics.userDetails["DaayitvaName"] == "Sewa Vibhaag - Toli Sadasya" ||Statics.userDetails["DaayitvaName"] == "सेवा विभाग टोली सदस्य" ||
            Statics.userDetails["DaayitvaName"] == "Sewa Saha-Pramukh" ||Statics.userDetails["DaayitvaName"] == "सेवा सह प्रमुख" ||Statics.userDetails["DaayitvaName"] == "सेवा सह प्रमुख" ||
            Statics.userDetails['DaayitvaName'] == 'Saha-Prachaarak' ||Statics.userDetails['DaayitvaName'] == 'सह प्रचारक' )
    )
      Statics.MenuItem(Statics.getLabel('EditMenu'), FontAwesomeIcons.edit, 'EditMenu'),
    Statics.MenuItem(Statics.getLabel('ViewMenu'), FontAwesomeIcons.eye, 'ViewMenu'),
    if (
    // Statics.userDetails["LevelName"] == "Bhaag"
    (Statics.userDetails["LevelName"] == "Bhaag" ||Statics.userDetails["LevelName"] == "भाग/जिला" ||Statics.userDetails["LevelName"] == "भाग/जिल्हा"||
        Statics.userDetails["LevelName"] == "Nagar" ||Statics.userDetails["LevelName"] == "Nagar\/Taalukaa" || Statics.userDetails["LevelName"] == "नगर/तालुका"||int.parse(Statics.userDetails["LevelID"]) >= 6 )
        &&
/*        (Statics.userDetails["DaayitvaName"] == "Baal Vidyaarthi Pramukh"   || Statics.userDetails["DaayitvaName"] == "बाल विद्यार्थी प्रमुख"   || Statics.userDetails["DaayitvaName"] == "बाल विद्यार्थी प्रमुख"  ||Statics.userDetails["DaayitvaName"] == "Mahaavidyaalayeen Vidyaarthi Pramukh"   || Statics.userDetails["DaayitvaName"] == "महाविद्यालयीन प्रमुख"   || Statics.userDetails["DaayitvaName"] == "महाविद्यालयीन प्रमुख"  ||Statics.userDetails["DaayitvaName"] == "Vyavasaayee Pramukh"   || Statics.userDetails["DaayitvaName"] == "व्यवसायी प्रमुख"   || Statics.userDetails["DaayitvaName"] == "व्यवसायी प्रमुख"  ||Statics.userDetails["DaayitvaName"] == "Vyavasaayee Saha-Pramukh"   || Statics.userDetails["DaayitvaName"] == "व्यवसायी सह प्रमुख"   || Statics.userDetails["DaayitvaName"] == "व्यवसायी सह प्रमुख"  || Statics.userDetails["DaayitvaName"] == "Tarun Vyavsayee Pramukh" || Statics.userDetails["DaayitvaName"] == "तरुण व्यवसायी प्रमुख" || Statics.userDetails["DaayitvaName"] == "तरुण व्यवसायी प्रमुख" ||
Statics.userDetails["DaayitvaName"] == "Praudh Vyavsayee Pramukh" || Statics.userDetails["DaayitvaName"] == "प्रौढ व्यवसायी प्रमुख" || Statics.userDetails["DaayitvaName"] == "प्रौढ व्यवसायी प्रमुख" ||
Statics.userDetails["DaayitvaName"] == "Tarun Vyavsayee Sah Pramukh" || Statics.userDetails["DaayitvaName"] == "तरुण व्यवसायी सह प्रमुख" || Statics.userDetails["DaayitvaName"] == "तरुण व्यवसायी सह प्रमुख" ||
Statics.userDetails["DaayitvaName"] == "Praudh Vyavsayee Sah Pramukh" || Statics.userDetails["DaayitvaName"] == "प्रौढ व्यवसायी सह प्रमुख" || Statics.userDetails["DaayitvaName"] == "प्रौढ व्यवसायी सह प्रमुख" ||
Statics.userDetails["DaayitvaName"] == "Bal Vidyarthi Sah Pramukh" || Statics.userDetails["DaayitvaName"] == "बाल विद्यार्थी सह प्रमुख" || Statics.userDetails["DaayitvaName"] == "बाल विद्यार्थी सह प्रमुख" ||
Statics.userDetails["DaayitvaName"] == "Mahavidyaleen Vidyarthi Sah Pramukh" || Statics.userDetails["DaayitvaName"] == "महाविद्यालयीन विद्यार्थी सह प्रमुख" || Statics.userDetails["DaayitvaName"] == "महाविद्यालयीन विद्यार्थी सह प्रमुख" ||
Statics.userDetails["DaayitvaName"] == "App Sanyojak"  ||
            Statics.userDetails["DaayitvaName"] == "Kaaryavaah" ||
            Statics.userDetails["DaayitvaName"] == "Saha-Kaaryavaah" ||
            Statics.userDetails["DaayitvaName"] == "Sewa Pramukh" ||
            Statics.userDetails["DaayitvaName"] == "Saha-SewaPramukh" ||
            Statics.userDetails['DaayitvaName'] == 'Kaaryaalay Pramukh' ||
            Statics.userDetails['DaayitvaName'] == 'Prachaarak' ||
            Statics.userDetails['DaayitvaName'] == 'Saha-Prachaarak')*/
        (Statics.userDetails["DaayitvaName"] == "Join RSS Sanyojak" || Statics.userDetails["DaayitvaName"] == "जॉयन आर.एस.एस. संयोजक" ||
            Statics.userDetails["DaayitvaName"] == "Join RSS Pramukh" || Statics.userDetails["DaayitvaName"] == "जॉयन आर.एस.एस. प्रमुख" ||
            Statics.userDetails["DaayitvaName"] == "Baal Vidyaarthi Pramukh"   || Statics.userDetails["DaayitvaName"] == "बाल विद्यार्थी प्रमुख"   || Statics.userDetails["DaayitvaName"] == "बाल विद्यार्थी प्रमुख"  ||Statics.userDetails["DaayitvaName"] == "Mahaavidyaalayeen Vidyaarthi Pramukh"   || Statics.userDetails["DaayitvaName"] == "महाविद्यालयीन प्रमुख"   || Statics.userDetails["DaayitvaName"] == "महाविद्यालयीन प्रमुख"  ||Statics.userDetails["DaayitvaName"] == "Vyavasaayee Pramukh"   || Statics.userDetails["DaayitvaName"] == "व्यवसायी प्रमुख"   || Statics.userDetails["DaayitvaName"] == "व्यवसायी प्रमुख"  ||Statics.userDetails["DaayitvaName"] == "Vyavasaayee Saha-Pramukh"   || Statics.userDetails["DaayitvaName"] == "व्यवसायी सह प्रमुख"   || Statics.userDetails["DaayitvaName"] == "व्यवसायी सह प्रमुख"  || Statics.userDetails["DaayitvaName"] == "Tarun Vyavsayee Pramukh" || Statics.userDetails["DaayitvaName"] == "तरुण व्यवसायी प्रमुख" || Statics.userDetails["DaayitvaName"] == "तरुण व्यवसायी प्रमुख" ||
Statics.userDetails["DaayitvaName"] == "Praudh Vyavsayee Pramukh" || Statics.userDetails["DaayitvaName"] == "प्रौढ व्यवसायी प्रमुख" || Statics.userDetails["DaayitvaName"] == "प्रौढ व्यवसायी प्रमुख" ||
Statics.userDetails["DaayitvaName"] == "Tarun Vyavsayee Sah Pramukh" || Statics.userDetails["DaayitvaName"] == "तरुण व्यवसायी सह प्रमुख" || Statics.userDetails["DaayitvaName"] == "तरुण व्यवसायी सह प्रमुख" ||
Statics.userDetails["DaayitvaName"] == "Praudh Vyavsayee Sah Pramukh" || Statics.userDetails["DaayitvaName"] == "प्रौढ व्यवसायी सह प्रमुख" || Statics.userDetails["DaayitvaName"] == "प्रौढ व्यवसायी सह प्रमुख" ||
Statics.userDetails["DaayitvaName"] == "Bal Vidyarthi Sah Pramukh" || Statics.userDetails["DaayitvaName"] == "बाल विद्यार्थी सह प्रमुख" || Statics.userDetails["DaayitvaName"] == "बाल विद्यार्थी सह प्रमुख" ||
Statics.userDetails["DaayitvaName"] == "Mahavidyaleen Vidyarthi Sah Pramukh" || Statics.userDetails["DaayitvaName"] == "महाविद्यालयीन विद्यार्थी सह प्रमुख" || Statics.userDetails["DaayitvaName"] == "महाविद्यालयीन विद्यार्थी सह प्रमुख" ||
Statics.userDetails["DaayitvaName"] == "App Sanyojak"  ||Statics.userDetails["DaayitvaName"] == "एप संयोजक" ||
            Statics.userDetails["DaayitvaName"] == "Kaaryavaah" ||Statics.userDetails["DaayitvaName"] == "कार्यवाह" ||
            Statics.userDetails["DaayitvaName"] == "karyalay sachiv" ||Statics.userDetails["DaayitvaName"] == "कार्यालय सचिव" ||
            Statics.userDetails["DaayitvaName"] == "Saha-Kaaryavaah" ||Statics.userDetails["DaayitvaName"] == "सह कार्यवाह" ||
            Statics.userDetails["DaayitvaName"] == "Sewa Pramukh" ||Statics.userDetails["DaayitvaName"] == "सेवा प्रमुख" ||
            Statics.userDetails["DaayitvaName"] == "Sewa Vibhaag - Toli Sadasya" ||Statics.userDetails["DaayitvaName"] == "सेवा विभाग टोली सदस्य" ||
            Statics.userDetails["DaayitvaName"] == "Saha-SewaPramukh" ||
            Statics.userDetails['DaayitvaName'] == 'Kaaryaalay Pramukh' ||Statics.userDetails['DaayitvaName'] == 'कार्यालय प्रमुख' ||
            Statics.userDetails['DaayitvaName'] == 'Prachaarak' ||Statics.userDetails['DaayitvaName'] == 'प्रचारक' ||
            Statics.userDetails["DaayitvaName"] == "Sewa Vibhaag - Toli Sadasya" ||Statics.userDetails["DaayitvaName"] == "सेवा विभाग टोली सदस्य" ||
            Statics.userDetails["DaayitvaName"] == "Sewa Saha-Pramukh" ||Statics.userDetails["DaayitvaName"] == "सेवा सह प्रमुख" ||Statics.userDetails["DaayitvaName"] == "सेवा सह प्रमुख" ||
            Statics.userDetails['DaayitvaName'] == 'Saha-Prachaarak' ||Statics.userDetails['DaayitvaName'] == 'सह प्रचारक' )
    )
      Statics.MenuItem(Statics.getLabel('Delete'), Icons.delete, 'Delete'),
  ];

  void _deleteSewaVasti(var context, var sewaVastiID) async {
    try {
      bool isConnected = await Statics.isInternetConnected();
      if (!isConnected) {
        Statics.showMessageDialog(context, Statics.getLabel('internetNotConnected'));
      } else {
        var inputData = json.encode({"SewaVastiID": sewaVastiID});
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text(Statics.getLabel('AskConfirmation')),
            content: Text(Statics.getLabel('AreyouSureYouWantToDeleteSewaVasti')),
            actions: <Widget>[
              MaterialButton(
                child: Text(Statics.getLabel('ConfirmationYes')),
                onPressed: () async {
                  var data = await Statics.deleteSewaVastiForApp(inputData);
                  if (data.contains("Deleted Successfully")) {
                    Statics.showToast(Statics.getLabel('SewaVastiDeletedSuccessfully'));
                    onSaveDetails();
                  } else
                    Statics.showToast(Statics.getLabel('CouldnotDeleteSewaVasti'));

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
        title: Text(sewaVastiItem["SewaVastiName"]),
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
                    if (value == 'Delete') {
                      _deleteSewaVasti(context, sewaVastiItem["SewaVastiID"].toString());
                    } else {
                      Navigator.of(context)
                          .pushNamed(EditSewaVasti.routeName, arguments: Statics.ScreenArguments(sewaVastiItem["SewaVastiID"], value));
                    }
                  },
                  icon: Icon(
                    FontAwesomeIcons.ellipsisV,
                    color: Colors.grey,
                  ),
                  itemBuilder: (BuildContext context) {
                    return menuItem.map((Statics.MenuItem menuItem) {
                      return PopupMenuItem(
                        //value: menuItem.menuVal,
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
                Text('${sewaVastiItem["BhaagName"].toString()}, '),
                Text('${sewaVastiItem["ShaharName"]}, '),
                Text('${sewaVastiItem["NagarName"].toString()}, '),
              ],
            ),
            SizedBox(
              height: 5,
            ),
          ],
        )),
      ),
    );
  }
}
