/*import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/painting/basic_types.dart' as flutter_axis;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:niyojak_prod/models/response_model/AbhiyaanSwayamsevakListResponse.dart';
import 'package:niyojak_prod/screens/AbhiyanEditSwayamsevak.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

import '../helpers/static_data.dart' as Statics;
import '../providers/swayamsevak_provider.dart';
import '../screens/AbhiyanViewSwayamsevak.dart';
import '../screens/swayamsevak_module/edit_module/edit_swayamsevak_basic_info.dart';
import '../screens/swayamsevak_module/edit_module/edit_swayamsevak_daayitva.dart';
import '../screens/swayamsevak_module/edit_module/edit_swayamsevak_other_info.dart';
import '../screens/swayamsevak_module/edit_module/edit_swayamsevak_screen.dart';
import '../screens/swayamsevak_module/edit_module/edit_swayamsevak_transfer.dart';

class SwayamsevakCard extends StatefulWidget {
  final swItem;
  var onCheckCard;
  var onUnCheckCard;
  bool? isChecked;
  var onSaveDetails;

  SwayamsevakCard({this.swItem, this.onCheckCard, this.onUnCheckCard, this.isChecked, this.onSaveDetails});

  @override
  _SwayamsevakCardState createState() => _SwayamsevakCardState();
}

class _SwayamsevakCardState extends State<SwayamsevakCard> {
  void _deleteSwayamSevak(var context, var swayamSevakID) async {
    try {
      bool isConnected = await Statics.isInternetConnected();
      if (!isConnected) {
        Statics.showMessageDialog(context, Statics.getLabel('internetNotConnected'));
      } else {
        var inputData = json.encode({"SwayamsevakID": swayamSevakID});
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text(Statics.getLabel('AskConfirmation')),
            content: Text(Statics.getLabel('AreyouSureYouWantToDeleteSwayamsevak')),
            actions: <Widget>[
              MaterialButton(
                child: Text(Statics.getLabel('ConfirmationYes')),
                onPressed: () async {
                  var data = await Statics.deleteSwayamsevakDataForApp(inputData);
                  if (data.contains("Deleted Successfully")) {
                    Statics.showToast(Statics.getLabel('SwayamsevakDeletedSuccessfully'));
                    widget.onSaveDetails("Search");
                  } else
                    Statics.showToast(Statics.getLabel('CouldnotDeleteSwayamsevak'));
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

  int? canEditStatus;

  @override
  Widget build(BuildContext context) {
    var showTransferMenu = false;
    var showEditMenu = true;
    var showResetPasswordMenu = false;
    var showDeleteMenu = false;
    if (((Statics.userDetails['LevelName'] == 'Praant' ||
            Statics.userDetails['LevelName'] == 'प्रांत' ||
            Statics.userDetails['LevelName'] == 'Mahaanagar' ||
            Statics.userDetails['LevelName'] == 'महानगर' ||
            Statics.userDetails['LevelName'] == 'Bhaag' ||
            Statics.userDetails['LevelName'] == 'भाग/जिल्हा' ||
            Statics.userDetails['LevelName'] == 'भाग/जिला' ||
            Statics.userDetails['LevelName'] == 'Vibhaag' ||
            Statics.userDetails['LevelName'] == 'विभाग' ||
            Statics.userDetails['LevelName'] == 'Nagar' ||
            Statics.userDetails['LevelName'] == 'Nagar/Taalukaa' ||
            Statics.userDetails['LevelName'] == 'नगर/तालुका')
        // &&
        //     (Statics.userDetails["DaayitvaName"] == "Join RSS Sanyojak" ||
        //         Statics.userDetails["DaayitvaName"] == "जॉयन आर.एस.एस. संयोजक" ||
        //         Statics.userDetails["DaayitvaName"] == "Join RSS Pramukh" ||
        //         Statics.userDetails["DaayitvaName"] == "जॉयन आर.एस.एस. प्रमुख" ||
        //         Statics.userDetails['DaayitvaName'] == 'Kaaryavaah' ||
        //         Statics.userDetails['DaayitvaName'] == 'कार्यवाह' ||
        //         Statics.userDetails["DaayitvaName"] == "karyalay sachiv" ||
        //         Statics.userDetails["DaayitvaName"] == "कार्यालय सचिव" ||
        //         Statics.userDetails['DaayitvaName'] == 'Saha-Kaaryavaah' ||
        //         Statics.userDetails['DaayitvaName'] == 'सह कार्यवाह' ||
        //         Statics.userDetails['DaayitvaName'] == 'Baal Vidyaarthi Pramukh' ||
        //         Statics.userDetails['DaayitvaName'] == 'बाल विद्यार्थी प्रमुख' ||
        //         Statics.userDetails['DaayitvaName'] == 'बाल विद्यार्थी प्रमुख' ||
        //         Statics.userDetails['DaayitvaName'] == 'Mahaavidyaalayeen Vidyaarthi Pramukh' ||
        //         Statics.userDetails['DaayitvaName'] == 'महाविद्यालयीन प्रमुख' ||
        //         Statics.userDetails['DaayitvaName'] == 'महाविद्यालयीन प्रमुख' ||
        //         Statics.userDetails['DaayitvaName'] == 'Vyavasaayee Pramukh' ||
        //         Statics.userDetails['DaayitvaName'] == 'व्यवसायी प्रमुख' ||
        //         Statics.userDetails['DaayitvaName'] == 'व्यवसायी प्रमुख' ||
        //         Statics.userDetails['DaayitvaName'] == 'Vyavasaayee Saha-Pramukh' ||
        //         Statics.userDetails['DaayitvaName'] == 'व्यवसायी सह प्रमुख' ||
        //         Statics.userDetails['DaayitvaName'] == 'व्यवसायी सह प्रमुख' ||
        //         Statics.userDetails['DaayitvaName'] == 'Tarun Vyavsayee Pramukh' ||
        //         Statics.userDetails['DaayitvaName'] == 'तरुण व्यवसायी प्रमुख' ||
        //         Statics.userDetails['DaayitvaName'] == 'तरुण व्यवसायी प्रमुख' ||
        //         Statics.userDetails['DaayitvaName'] == 'Praudh Vyavsayee Pramukh' ||
        //         Statics.userDetails['DaayitvaName'] == 'प्रौढ व्यवसायी प्रमुख' ||
        //         Statics.userDetails['DaayitvaName'] == 'प्रौढ व्यवसायी प्रमुख' ||
        //         Statics.userDetails['DaayitvaName'] == 'Tarun Vyavsayee Sah Pramukh' ||
        //         Statics.userDetails['DaayitvaName'] == 'तरुण व्यवसायी सह प्रमुख' ||
        //         Statics.userDetails['DaayitvaName'] == 'तरुण व्यवसायी सह प्रमुख' ||
        //         Statics.userDetails['DaayitvaName'] == 'Praudh Vyavsayee Sah Pramukh' ||
        //         Statics.userDetails['DaayitvaName'] == 'प्रौढ व्यवसायी सह प्रमुख' ||
        //         Statics.userDetails['DaayitvaName'] == 'प्रौढ व्यवसायी सह प्रमुख' ||
        //         Statics.userDetails['DaayitvaName'] == 'Bal Vidyarthi Sah Pramukh' ||
        //         Statics.userDetails['DaayitvaName'] == 'बाल विद्यार्थी सह प्रमुख' ||
        //         Statics.userDetails['DaayitvaName'] == 'बाल विद्यार्थी सह प्रमुख' ||
        //         Statics.userDetails['DaayitvaName'] == 'Mahavidyaleen Vidyarthi Sah Pramukh' ||
        //         Statics.userDetails['DaayitvaName'] == 'महाविद्यालयीन विद्यार्थी सह प्रमुख' ||
        //         Statics.userDetails['DaayitvaName'] == 'महाविद्यालयीन विद्यार्थी सह प्रमुख' ||
        //         Statics.userDetails['DaayitvaName'] == 'App Sanyojak' ||
        //         Statics.userDetails['DaayitvaName'] == 'एप संयोजक' ||
        //         Statics.userDetails['DaayitvaName'] == 'Kaaryaalay Pramukh' ||
        //         Statics.userDetails['DaayitvaName'] == 'कार्यालय प्रमुख')
        ) ||
        (Statics.userDetails['LevelName'] == 'Shaakhaa' ||
            Statics.userDetails['LevelName'] == 'शाखा' &&
                (Statics.userDetails['DaayitvaName'] == 'Mukhya Shikshak' ||
                    Statics.userDetails['DaayitvaName'] == 'मुख्य शिक्षक' ||
                    Statics.userDetails['DaayitvaName'] == 'Kaaryavaah' ||
                    Statics.userDetails['DaayitvaName'] == 'कार्यवाह')) ||
        ( //Statics.userDetails['LevelName'] == 'Praant' || Statics.userDetails['LevelName'] == 'प्रांत' && https://trello.com/c/lMAE64Rh 9223534792 p/w efgh प्रांत सेवा सह प्रमुख
            Statics.userDetails["DaayitvaName"] == "Join RSS Sanyojak" ||
                Statics.userDetails["DaayitvaName"] == "जॉयन आर.एस.एस. संयोजक" ||
                Statics.userDetails["DaayitvaName"] == "Join RSS Pramukh" ||
                Statics.userDetails["DaayitvaName"] == "जॉयन आर.एस.एस. प्रमुख" ||
                Statics.userDetails['DaayitvaName'] == 'Baal Vidyaarthi Pramukh' ||
                Statics.userDetails['DaayitvaName'] == 'बाल विद्यार्थी प्रमुख' ||
                Statics.userDetails['DaayitvaName'] == 'बाल विद्यार्थी प्रमुख' ||
                Statics.userDetails['DaayitvaName'] == 'Mahaavidyaalayeen Vidyaarthi Pramukh' ||
                Statics.userDetails['DaayitvaName'] == 'महाविद्यालयीन प्रमुख' ||
                Statics.userDetails['DaayitvaName'] == 'महाविद्यालयीन प्रमुख' ||
                Statics.userDetails['DaayitvaName'] == 'Vyavasaayee Pramukh' ||
                Statics.userDetails['DaayitvaName'] == 'व्यवसायी प्रमुख' ||
                Statics.userDetails['DaayitvaName'] == 'व्यवसायी प्रमुख' ||
                Statics.userDetails['DaayitvaName'] == 'Vyavasaayee Saha-Pramukh' ||
                Statics.userDetails['DaayitvaName'] == 'व्यवसायी सह प्रमुख' ||
                Statics.userDetails['DaayitvaName'] == 'व्यवसायी सह प्रमुख' ||
                Statics.userDetails['DaayitvaName'] == 'Tarun Vyavsayee Pramukh' ||
                Statics.userDetails['DaayitvaName'] == 'तरुण व्यवसायी प्रमुख' ||
                Statics.userDetails['DaayitvaName'] == 'तरुण व्यवसायी प्रमुख' ||
                Statics.userDetails['DaayitvaName'] == 'Praudh Vyavsayee Pramukh' ||
                Statics.userDetails['DaayitvaName'] == 'प्रौढ व्यवसायी प्रमुख' ||
                Statics.userDetails['DaayitvaName'] == 'प्रौढ व्यवसायी प्रमुख' ||
                Statics.userDetails['DaayitvaName'] == 'Tarun Vyavsayee Sah Pramukh' ||
                Statics.userDetails['DaayitvaName'] == 'तरुण व्यवसायी सह प्रमुख' ||
                Statics.userDetails['DaayitvaName'] == 'तरुण व्यवसायी सह प्रमुख' ||
                Statics.userDetails['DaayitvaName'] == 'Praudh Vyavsayee Sah Pramukh' ||
                Statics.userDetails['DaayitvaName'] == 'प्रौढ व्यवसायी सह प्रमुख' ||
                Statics.userDetails['DaayitvaName'] == 'प्रौढ व्यवसायी सह प्रमुख' ||
                Statics.userDetails['DaayitvaName'] == 'Bal Vidyarthi Sah Pramukh' ||
                Statics.userDetails['DaayitvaName'] == 'बाल विद्यार्थी सह प्रमुख' ||
                Statics.userDetails['DaayitvaName'] == 'बाल विद्यार्थी सह प्रमुख' ||
                Statics.userDetails['DaayitvaName'] == 'Mahavidyaleen Vidyarthi Sah Pramukh' ||
                Statics.userDetails['DaayitvaName'] == 'महाविद्यालयीन विद्यार्थी सह प्रमुख' ||
                Statics.userDetails['DaayitvaName'] == 'महाविद्यालयीन विद्यार्थी सह प्रमुख' ||
                Statics.userDetails['DaayitvaName'] == 'Mandal Samiti Sadasya' ||
                Statics.userDetails['DaayitvaName'] == 'मंडल समिती सदस्य' ||
                Statics.userDetails['DaayitvaName'] == 'App Sanyojak' ||
                Statics.userDetails['DaayitvaName'] == 'एप संयोजक') ||
        (Statics.userDetails['DaayitvaName'] == 'Prachaarak' ||
            Statics.userDetails['DaayitvaName'] == 'प्रचारक' ||
            Statics.userDetails['DaayitvaName'] == 'Saha-Prachaarak' ||
            Statics.userDetails['DaayitvaName'] == 'सह प्रचारक')) showTransferMenu = true;
//
//
//
//     if (((Statics.userDetails['LevelName'] == 'Praant' ||  Statics.userDetails['LevelName'] == 'प्रांत' ||
//         Statics.userDetails['LevelName'] == 'Mahaanagar' ||   Statics.userDetails['LevelName'] == 'महानगर' ||
//         Statics.userDetails['LevelName'] == 'Bhaag' ||  Statics.userDetails['LevelName'] == 'भाग/जिल्हा' || Statics.userDetails['LevelName'] == 'भाग/जिला' ||
//         Statics.userDetails['LevelName'] == 'Vibhaag' || Statics.userDetails['LevelName'] == 'विभाग'||
//         Statics.userDetails['LevelName'] == 'Nagar' || Statics.userDetails['LevelName'] == 'Nagar/Taalukaa' || Statics.userDetails['LevelName'] == 'नगर/तालुका') &&
//             (Statics.userDetails["DaayitvaName"] == "Join RSS Sanyojak" || Statics.userDetails["DaayitvaName"] == "जॉयन आर.एस.एस. संयोजक" ||
//                 Statics.userDetails["DaayitvaName"] == "Join RSS Pramukh" || Statics.userDetails["DaayitvaName"] == "जॉयन आर.एस.एस. प्रमुख" ||
//                 Statics.userDetails['DaayitvaName'] == 'Kaaryavaah' || Statics.userDetails['DaayitvaName'] == 'कार्यवाह' ||
//                 Statics.userDetails["DaayitvaName"] == "karyalay sachiv" ||Statics.userDetails["DaayitvaName"] == "कार्यालय सचिव" ||
//                 Statics.userDetails['DaayitvaName'] == 'Saha-Kaaryavaah' || Statics.userDetails['DaayitvaName'] == 'सह कार्यवाह' ||
//                 Statics.userDetails['DaayitvaName'] == 'Baal Vidyaarthi Pramukh'|| Statics.userDetails['DaayitvaName'] == 'बाल विद्यार्थी प्रमुख'   || Statics.userDetails['DaayitvaName'] == 'बाल विद्यार्थी प्रमुख'  ||
//                 Statics.userDetails['DaayitvaName'] == 'Mahaavidyaalayeen Vidyaarthi Pramukh'   || Statics.userDetails['DaayitvaName'] == 'महाविद्यालयीन प्रमुख'|| Statics.userDetails['DaayitvaName'] == 'महाविद्यालयीन प्रमुख'  ||
//                 Statics.userDetails['DaayitvaName'] == 'Vyavasaayee Pramukh'   || Statics.userDetails['DaayitvaName'] == 'व्यवसायी प्रमुख'||  Statics.userDetails['DaayitvaName'] == 'व्यवसायी प्रमुख'  ||
//                 Statics.userDetails['DaayitvaName'] == 'Vyavasaayee Saha-Pramukh'|| Statics.userDetails['DaayitvaName'] == 'व्यवसायी सह प्रमुख'   || Statics.userDetails['DaayitvaName'] == 'व्यवसायी सह प्रमुख'  ||
//                 Statics.userDetails['DaayitvaName'] == 'Tarun Vyavsayee Pramukh' || Statics.userDetails['DaayitvaName'] == 'तरुण व्यवसायी प्रमुख' || Statics.userDetails['DaayitvaName'] == 'तरुण व्यवसायी प्रमुख' ||
// Statics.userDetails['DaayitvaName'] == 'Praudh Vyavsayee Pramukh' || Statics.userDetails['DaayitvaName'] == 'प्रौढ व्यवसायी प्रमुख' || Statics.userDetails['DaayitvaName'] == 'प्रौढ व्यवसायी प्रमुख' ||
// Statics.userDetails['DaayitvaName'] == 'Tarun Vyavsayee Sah Pramukh' || Statics.userDetails['DaayitvaName'] == 'तरुण व्यवसायी सह प्रमुख' || Statics.userDetails['DaayitvaName'] == 'तरुण व्यवसायी सह प्रमुख' ||
// Statics.userDetails['DaayitvaName'] == 'Praudh Vyavsayee Sah Pramukh' || Statics.userDetails['DaayitvaName'] == 'प्रौढ व्यवसायी सह प्रमुख' || Statics.userDetails['DaayitvaName'] == 'प्रौढ व्यवसायी सह प्रमुख' ||
// Statics.userDetails['DaayitvaName'] == 'Bal Vidyarthi Sah Pramukh' || Statics.userDetails['DaayitvaName'] == 'बाल विद्यार्थी सह प्रमुख' || Statics.userDetails['DaayitvaName'] == 'बाल विद्यार्थी सह प्रमुख' ||
// Statics.userDetails['DaayitvaName'] == 'Mahavidyaleen Vidyarthi Sah Pramukh' || Statics.userDetails['DaayitvaName'] == 'महाविद्यालयीन विद्यार्थी सह प्रमुख' || Statics.userDetails['DaayitvaName'] == 'महाविद्यालयीन विद्यार्थी सह प्रमुख' ||
// Statics.userDetails['DaayitvaName'] == 'App Sanyojak'  || Statics.userDetails['DaayitvaName'] == 'एप संयोजक' ||
//                 Statics.userDetails['DaayitvaName'] == 'Vasti Pramukh' || Statics.userDetails['DaayitvaName'] == 'वस्ती प्रमुख' ||
//                 Statics.userDetails['DaayitvaName'] == 'Kaaryaalay Pramukh' || Statics.userDetails['DaayitvaName'] == 'कार्यालय प्रमुख')) ||
//         (Statics.userDetails['LevelName'] == 'Shaakhaa' || Statics.userDetails['LevelName'] == 'शाखा' &&
//             (Statics.userDetails['DaayitvaName'] == 'Mukhya Shikshak' || Statics.userDetails['DaayitvaName'] == 'मुख्य शिक्षक' || Statics.userDetails['DaayitvaName'] == 'Kaaryavaah' || Statics.userDetails['DaayitvaName'] == 'कार्यवाह')) ||
//         (//Statics.userDetails['LevelName'] == 'Praant' || Statics.userDetails['LevelName'] == 'प्रांत' &&  // 9223534792 p/w efgh प्रांत सेवा सह प्रमुख https://trello.com/c/lMAE64Rh
//             Statics.userDetails["DaayitvaName"] == "Join RSS Sanyojak" || Statics.userDetails["DaayitvaName"] == "जॉयन आर.एस.एस. संयोजक" ||
//             Statics.userDetails["DaayitvaName"] == "Join RSS Pramukh" || Statics.userDetails["DaayitvaName"] == "जॉयन आर.एस.एस. प्रमुख" ||
//             Statics.userDetails['DaayitvaName'] == 'Baal Vidyaarthi Pramukh'   ||
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
//         (Statics.userDetails['DaayitvaName'] == 'Prachaarak' || Statics.userDetails['DaayitvaName'] == 'प्रचारक' ||
//             Statics.userDetails['DaayitvaName'] == 'Saha-Prachaarak' || Statics.userDetails['DaayitvaName'] == 'सह प्रचारक')
//     ) showEditMenu = true;
//
    if (int.parse(Statics.userDetails['LevelID']) >= 4 &&
        // (Statics.userDetails["DaayitvaName"] == "Join RSS Sanyojak" ||
        //     Statics.userDetails["DaayitvaName"] == "जॉयन आर.एस.एस. संयोजक" ||
        //     Statics.userDetails["DaayitvaName"] == "Join RSS Pramukh" ||
        //     Statics.userDetails["DaayitvaName"] == "जॉयन आर.एस.एस. प्रमुख" ||
        //     Statics.userDetails['DaayitvaName'] == 'Kaaryavaah' ||
        //     Statics.userDetails['DaayitvaName'] == 'कार्यवाह' ||
        //     Statics.userDetails["DaayitvaName"] == "karyalay sachiv" ||
        //     Statics.userDetails["DaayitvaName"] == "कार्यालय सचिव" ||
        //     Statics.userDetails['DaayitvaName'] == 'Saha-Kaaryavaah' ||
        //     Statics.userDetails['DaayitvaName'] == 'सह कार्यवाह' ||
        //     Statics.userDetails['DaayitvaName'] == 'Prachaarak' ||
        //     Statics.userDetails['DaayitvaName'] == 'प्रचारक' ||
        //     Statics.userDetails['DaayitvaName'] == 'Saha-Prachaarak' ||
        //     Statics.userDetails['DaayitvaName'] == 'सह प्रचारक' ||
        //     Statics.userDetails['DaayitvaName'] == 'Baal Vidyaarthi Pramukh' ||
        //     Statics.userDetails['DaayitvaName'] == 'बाल विद्यार्थी प्रमुख' ||
        //     Statics.userDetails['DaayitvaName'] == 'Mahaavidyaalayeen Vidyaarthi Pramukh' ||
        //     Statics.userDetails['DaayitvaName'] == 'महाविद्यालयीन प्रमुख' ||
        //     Statics.userDetails['DaayitvaName'] == 'Vyavasaayee Pramukh' ||
        //     Statics.userDetails['DaayitvaName'] == 'व्यवसायी प्रमुख' ||
        //     Statics.userDetails['DaayitvaName'] == 'Vyavasaayee Saha-Pramukh' ||
        //     Statics.userDetails['DaayitvaName'] == 'व्यवसायी सह प्रमुख' ||
        //     Statics.userDetails['DaayitvaName'] == 'Tarun Vyavsayee Pramukh' ||
        //     Statics.userDetails['DaayitvaName'] == 'तरुण व्यवसायी प्रमुख' ||
        //     Statics.userDetails['DaayitvaName'] == 'तरुण व्यवसायी प्रमुख' ||
        //     Statics.userDetails['DaayitvaName'] == 'Praudh Vyavsayee Pramukh' ||
        //     Statics.userDetails['DaayitvaName'] == 'प्रौढ व्यवसायी प्रमुख' ||
        //     Statics.userDetails['DaayitvaName'] == 'प्रौढ व्यवसायी प्रमुख' ||
        //     Statics.userDetails['DaayitvaName'] == 'Tarun Vyavsayee Sah Pramukh' ||
        //     Statics.userDetails['DaayitvaName'] == 'तरुण व्यवसायी सह प्रमुख' ||
        //     Statics.userDetails['DaayitvaName'] == 'तरुण व्यवसायी सह प्रमुख' ||
        //     Statics.userDetails['DaayitvaName'] == 'Praudh Vyavsayee Sah Pramukh' ||
        //     Statics.userDetails['DaayitvaName'] == 'प्रौढ व्यवसायी सह प्रमुख' ||
        //     Statics.userDetails['DaayitvaName'] == 'प्रौढ व्यवसायी सह प्रमुख' ||
        //     Statics.userDetails['DaayitvaName'] == 'Bal Vidyarthi Sah Pramukh' ||
        //     Statics.userDetails['DaayitvaName'] == 'बाल विद्यार्थी सह प्रमुख' ||
        //     Statics.userDetails['DaayitvaName'] == 'बाल विद्यार्थी सह प्रमुख' ||
        //     Statics.userDetails['DaayitvaName'] == 'Mahavidyaleen Vidyarthi Sah Pramukh' ||
        //     Statics.userDetails['DaayitvaName'] == 'महाविद्यालयीन विद्यार्थी सह प्रमुख' ||
        //     Statics.userDetails['DaayitvaName'] == 'महाविद्यालयीन विद्यार्थी सह प्रमुख' ||
        //     Statics.userDetails['DaayitvaName'] == 'App Sanyojak' ||
        //     Statics.userDetails['DaayitvaName'] == 'एप संयोजक' ||
        //     Statics.userDetails['DaayitvaName'] == 'Prachaarak' ||
        //     Statics.userDetails['DaayitvaName'] == 'प्रचारक' ||
        //     Statics.userDetails['DaayitvaName'] == 'Kaaryaalay Pramukh' ||
        //     Statics.userDetails['DaayitvaName'] == 'कार्यालय प्रमुख') &&
        widget.swItem["CanUseApp"] == true) showResetPasswordMenu = true;
//
    if (((Statics.userDetails['LevelName'] == 'Praant' ||
            Statics.userDetails['LevelName'] == 'प्रांत' ||
            Statics.userDetails['LevelName'] == 'Mahaanagar' ||
            Statics.userDetails['LevelName'] == 'महानगर' ||
            Statics.userDetails['LevelName'] == 'Bhaag' ||
            Statics.userDetails['LevelName'] == 'भाग/जिल्हा' ||
            Statics.userDetails['LevelName'] == 'भाग/जिला' ||
            Statics.userDetails['LevelName'] == 'Vibhaag' ||
            Statics.userDetails['LevelName'] == 'विभाग' ||
            Statics.userDetails['LevelName'] == 'Nagar' ||
            Statics.userDetails['LevelName'] == 'Nagar/Taalukaa' ||
            Statics.userDetails['LevelName'] == 'नगर/तालुका')
        // &&
        //     (Statics.userDetails["DaayitvaName"] == "Join RSS Sanyojak" ||
        //         Statics.userDetails["DaayitvaName"] == "जॉयन आर.एस.एस. संयोजक" ||
        //         Statics.userDetails["DaayitvaName"] == "Join RSS Pramukh" ||
        //         Statics.userDetails["DaayitvaName"] == "जॉयन आर.एस.एस. प्रमुख" ||
        //         Statics.userDetails['DaayitvaName'] == 'Kaaryavaah' ||
        //         Statics.userDetails['DaayitvaName'] == 'कार्यवाह' ||
        //         Statics.userDetails["DaayitvaName"] == "karyalay sachiv" ||
        //         Statics.userDetails["DaayitvaName"] == "कार्यालय सचिव" ||
        //         Statics.userDetails['DaayitvaName'] == 'Saha-Kaaryavaah' ||
        //         Statics.userDetails['DaayitvaName'] == 'सह कार्यवाह' ||
        //         Statics.userDetails['DaayitvaName'] == 'Baal Vidyaarthi Pramukh' ||
        //         Statics.userDetails['DaayitvaName'] == 'बाल विद्यार्थी प्रमुख' ||
        //         Statics.userDetails['DaayitvaName'] == 'बाल विद्यार्थी प्रमुख' ||
        //         Statics.userDetails['DaayitvaName'] == 'Mahaavidyaalayeen Vidyaarthi Pramukh' ||
        //         Statics.userDetails['DaayitvaName'] == 'महाविद्यालयीन प्रमुख' ||
        //         Statics.userDetails['DaayitvaName'] == 'महाविद्यालयीन प्रमुख' ||
        //         Statics.userDetails['DaayitvaName'] == 'Vyavasaayee Pramukh' ||
        //         Statics.userDetails['DaayitvaName'] == 'व्यवसायी प्रमुख' ||
        //         Statics.userDetails['DaayitvaName'] == 'व्यवसायी प्रमुख' ||
        //         Statics.userDetails['DaayitvaName'] == 'Vyavasaayee Saha-Pramukh' ||
        //         Statics.userDetails['DaayitvaName'] == 'व्यवसायी सह प्रमुख' ||
        //         Statics.userDetails['DaayitvaName'] == 'व्यवसायी सह प्रमुख' ||
        //         Statics.userDetails['DaayitvaName'] == 'Tarun Vyavsayee Pramukh' ||
        //         Statics.userDetails['DaayitvaName'] == 'तरुण व्यवसायी प्रमुख' ||
        //         Statics.userDetails['DaayitvaName'] == 'तरुण व्यवसायी प्रमुख' ||
        //         Statics.userDetails['DaayitvaName'] == 'Praudh Vyavsayee Pramukh' ||
        //         Statics.userDetails['DaayitvaName'] == 'प्रौढ व्यवसायी प्रमुख' ||
        //         Statics.userDetails['DaayitvaName'] == 'प्रौढ व्यवसायी प्रमुख' ||
        //         Statics.userDetails['DaayitvaName'] == 'Tarun Vyavsayee Sah Pramukh' ||
        //         Statics.userDetails['DaayitvaName'] == 'तरुण व्यवसायी सह प्रमुख' ||
        //         Statics.userDetails['DaayitvaName'] == 'तरुण व्यवसायी सह प्रमुख' ||
        //         Statics.userDetails['DaayitvaName'] == 'Praudh Vyavsayee Sah Pramukh' ||
        //         Statics.userDetails['DaayitvaName'] == 'प्रौढ व्यवसायी सह प्रमुख' ||
        //         Statics.userDetails['DaayitvaName'] == 'प्रौढ व्यवसायी सह प्रमुख' ||
        //         Statics.userDetails['DaayitvaName'] == 'Bal Vidyarthi Sah Pramukh' ||
        //         Statics.userDetails['DaayitvaName'] == 'बाल विद्यार्थी सह प्रमुख' ||
        //         Statics.userDetails['DaayitvaName'] == 'बाल विद्यार्थी सह प्रमुख' ||
        //         Statics.userDetails['DaayitvaName'] == 'Mahavidyaleen Vidyarthi Sah Pramukh' ||
        //         Statics.userDetails['DaayitvaName'] == 'महाविद्यालयीन विद्यार्थी सह प्रमुख' ||
        //         Statics.userDetails['DaayitvaName'] == 'महाविद्यालयीन विद्यार्थी सह प्रमुख' ||
        //         Statics.userDetails['DaayitvaName'] == 'App Sanyojak' ||
        //         Statics.userDetails['DaayitvaName'] == 'एप संयोजक' ||
        //         Statics.userDetails['DaayitvaName'] == 'Kaaryaalay Pramukh' ||
        //         Statics.userDetails['DaayitvaName'] == 'कार्यालय प्रमुख')
        ) ||
        (Statics.userDetails['LevelName'] == 'Shaakhaa' ||
            Statics.userDetails['LevelName'] == 'शाखा' &&
                (Statics.userDetails['DaayitvaName'] == 'Mukhya Shikshak' ||
                    Statics.userDetails['DaayitvaName'] == 'मुख्य शिक्षक' ||
                    Statics.userDetails['DaayitvaName'] == 'Kaaryavaah' ||
                    Statics.userDetails['DaayitvaName'] == 'कार्यवाह')) ||
        ( // Statics.userDetails['LevelName'] == 'Praant' || Statics.userDetails['LevelName'] == 'प्रांत' || // 9223534792 p/w efgh प्रांत सेवा सह प्रमुख https://trello.com/c/lMAE64Rh
            // Statics.userDetails['LevelName'] == 'Mahaanagar' ||   Statics.userDetails['LevelName'] == 'महानगर' || //9930945083 p/w efgh महानगर सेवा प्रमुख sathi comment kel https://trello.com/c/p7IbNEGM
            // Statics.userDetails['LevelName'] == 'Bhaag' ||  Statics.userDetails['LevelName'] == 'भाग/जिल्हा' || //  sewa pramukha bhag/jilha sathi hide kel
            Statics.userDetails['LevelName'] == 'Vibhaag' || Statics.userDetails['LevelName'] == 'विभाग'
        //     && Statics.userDetails["DaayitvaName"] == "Join RSS Sanyojak" ||
        // Statics.userDetails["DaayitvaName"] == "जॉयन आर.एस.एस. संयोजक" ||
        // Statics.userDetails["DaayitvaName"] == "Join RSS Pramukh" ||
        // Statics.userDetails["DaayitvaName"] == "जॉयन आर.एस.एस. प्रमुख" ||
        // Statics.userDetails['DaayitvaName'] == 'Baal Vidyaarthi Pramukh' ||
        // Statics.userDetails['DaayitvaName'] == 'बाल विद्यार्थी प्रमुख' ||
        // Statics.userDetails['DaayitvaName'] == 'बाल विद्यार्थी प्रमुख' ||
        // Statics.userDetails['DaayitvaName'] == 'Mahaavidyaalayeen Vidyaarthi Pramukh' ||
        // Statics.userDetails['DaayitvaName'] == 'महाविद्यालयीन प्रमुख' ||
        // Statics.userDetails['DaayitvaName'] == 'महाविद्यालयीन प्रमुख' ||
        // Statics.userDetails['DaayitvaName'] == 'Vyavasaayee Pramukh' ||
        // Statics.userDetails['DaayitvaName'] == 'व्यवसायी प्रमुख' ||
        // Statics.userDetails['DaayitvaName'] == 'व्यवसायी प्रमुख' ||
        // Statics.userDetails['DaayitvaName'] == 'Vyavasaayee Saha-Pramukh' ||
        // Statics.userDetails['DaayitvaName'] == 'व्यवसायी सह प्रमुख' ||
        // Statics.userDetails['DaayitvaName'] == 'व्यवसायी सह प्रमुख' ||
        // // Statics.userDetails["DaayitvaName"] == "Sewa Pramukh" ||Statics.userDetails["DaayitvaName"] == "सेवा प्रमुख" ||
        // Statics.userDetails['DaayitvaName'] == 'Tarun Vyavsayee Pramukh' ||
        // Statics.userDetails['DaayitvaName'] == 'तरुण व्यवसायी प्रमुख' ||
        // Statics.userDetails['DaayitvaName'] == 'तरुण व्यवसायी प्रमुख' ||
        // Statics.userDetails['DaayitvaName'] == 'Praudh Vyavsayee Pramukh' ||
        // Statics.userDetails['DaayitvaName'] == 'प्रौढ व्यवसायी प्रमुख' ||
        // Statics.userDetails['DaayitvaName'] == 'प्रौढ व्यवसायी प्रमुख' ||
        // Statics.userDetails['DaayitvaName'] == 'Tarun Vyavsayee Sah Pramukh' ||
        // Statics.userDetails['DaayitvaName'] == 'तरुण व्यवसायी सह प्रमुख' ||
        // Statics.userDetails['DaayitvaName'] == 'तरुण व्यवसायी सह प्रमुख' ||
        // Statics.userDetails['DaayitvaName'] == 'Praudh Vyavsayee Sah Pramukh' ||
        // Statics.userDetails['DaayitvaName'] == 'प्रौढ व्यवसायी सह प्रमुख' ||
        // Statics.userDetails['DaayitvaName'] == 'प्रौढ व्यवसायी सह प्रमुख' ||
        // Statics.userDetails['DaayitvaName'] == 'Bal Vidyarthi Sah Pramukh' ||
        // Statics.userDetails['DaayitvaName'] == 'बाल विद्यार्थी सह प्रमुख' ||
        // Statics.userDetails['DaayitvaName'] == 'बाल विद्यार्थी सह प्रमुख' ||
        // Statics.userDetails['DaayitvaName'] == 'Mahavidyaleen Vidyarthi Sah Pramukh' ||
        // Statics.userDetails['DaayitvaName'] == 'महाविद्यालयीन विद्यार्थी सह प्रमुख' ||
        // Statics.userDetails['DaayitvaName'] == 'महाविद्यालयीन विद्यार्थी सह प्रमुख' ||
        // Statics.userDetails['DaayitvaName'] == 'App Sanyojak' ||
        // Statics.userDetails['DaayitvaName'] == 'एप संयोजक' ||
        // Statics.userDetails['DaayitvaName'] == 'एप संयोजक'
        ) ||
        (Statics.userDetails['DaayitvaName'] == 'Prachaarak' ||
            Statics.userDetails['DaayitvaName'] == 'प्रचारक' ||
            Statics.userDetails['DaayitvaName'] == 'प्रचारक' ||
            Statics.userDetails['DaayitvaName'] == 'Saha-Prachaarak' ||
            Statics.userDetails['DaayitvaName'] == 'सह प्रचारक' ||
            Statics.userDetails['DaayitvaName'] == 'सह प्रचारक')) showDeleteMenu = true;

    return Card(
      margin: EdgeInsets.all(5),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            // Leading Checkbox
            Checkbox(
              checkColor: Colors.white,
              activeColor: Colors.purple,
              value: widget.isChecked,
              onChanged: (value) {
                setState(() {
                  widget.isChecked = value!;
                  if (value == true)
                    widget.onCheckCard(widget.swItem["Email"], widget.swItem["MobileNumber"], widget.swItem["SwayamsevakID"].toString());
                  else
                    widget.onUnCheckCard(widget.swItem["Email"], widget.swItem["MobileNumber"], widget.swItem["SwayamsevakID"].toString());
                });
              },
            ),

            // Title and Subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    widget.swItem["FullName"],
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 5),
                  // Subtitle
                  if (widget.swItem["DaayitvaGeoUnitName"].toString().isNotEmpty)
                    Wrap(
                      spacing: 1,
                      children: [
                        Text(
                          widget.swItem["DaayitvaGeoUnitName"],
                          style: TextStyle(fontSize: 14, color: Colors.black54),
                        ),
                        Text(
                          widget.swItem["LevelName"],
                          style: TextStyle(fontSize: 14, color: Colors.black54),
                        ),
                        Text(
                          widget.swItem["DaayitvaName"],
                          style: TextStyle(fontSize: 14, color: Colors.black54),
                        ),
                      ],
                    ),
                  SizedBox(height: 5),
                  Wrap(
                    spacing: 2,
                    children: [
                      RichText(
                        text: TextSpan(
                          text: 'M: ${widget.swItem["MobileNumber"].toString()}${widget.swItem["Email"].toString().isNotEmpty ? ',' : ''}',
                          style: TextStyle(color: Colors.blue),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              UrlLauncher.launch("tel://" + widget.swItem["MobileNumber"].toString());
                            },
                        ),
                      ),
                      if (widget.swItem['Email'].toString().isNotEmpty)
                        RichText(
                          text: TextSpan(
                            text: 'E: ${widget.swItem["Email"].toString()}',
                            style: TextStyle(color: Colors.blue),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                UrlLauncher.launch("mailto:" + widget.swItem["Email"].toString());
                              },
                          ),
                        )
                    ],
                  )
                ],
              ),
            ),

            // Trailing Buttons
            SizedBox(
              width: 108,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Text(
                        "Edit Info",
                        style: TextStyle(fontSize: 10),
                      ),
                      Transform.scale(
                        scale: 0.6,
                        child: Switch(
                          value: widget.swItem["can_edit"] == true,
                          onChanged: (bool newValue) async {
                            setState(() {
                              widget.swItem["can_edit"] = newValue;
                            });
                            await changeEditStatus(newValue);
                          },
                          activeColor: Colors.green,
                          inactiveThumbColor: Colors.grey,
                          inactiveTrackColor: Colors.grey.withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        "Menu",
                        style: TextStyle(fontSize: 10),
                      ),
                      PopupMenuButton(
                        onSelected: (value) {
                          if (value == "ResetPassword") {
                            Statics.showConfirmationBox(context, Statics.getLabel('ConfirmResetpassword'), "ResetPassword", widget.swItem["SwayamsevakID"].toString());
                          } else if (value == "Delete") {
                            _deleteSwayamSevak(context, widget.swItem["SwayamsevakID"].toString());
                          } else if (value == "Transfer") {
                            setState(() {
                              Navigator.of(context)
                                  .pushNamed(EditSwayamsevakTransferScreen.routeName, arguments: Statics.ScreenArgumentsSwayamsevakTransfer('0', widget.swItem["SwayamsevakID"].toString(), value));
                            });
                          } else if (value == "EditMenuNew") {
                            Navigator.of(context).pushNamed(EditSwayamsevakBasicInfo.routeName, arguments: Statics.ScreenArgumentsNew(widget.swItem["SwayamsevakID"], value));
                          } else if (value == "DaayitvaMenu") {
                            Navigator.of(context).pushNamed(EditSwayamsevakDaayitva.routeName, arguments: Statics.ScreenArguments(widget.swItem["SwayamsevakID"], value));
                          } else if (value == "OtherInfoMenu") {
                            Navigator.of(context).pushNamed(EditSwayamsevakOtherInfo.routeName, arguments: Statics.ScreenArguments(widget.swItem["SwayamsevakID"], value));
                          }
                          // else if (value == "AddinSoochi") {
                          //   print("${widget.swItem["SwayamsevakID"]}");
                          //   Navigator.of(context).pushNamed(EditSwayamsevakSoochiInfo.routeName,
                          //     arguments: Statics.ScreenArguments(widget.swItem["SwayamsevakID"], value),
                          //   );
                          //
                          // }
                          else {
                            Navigator.of(context).pushNamed(EditSwayamsevakScreen.routeName, arguments: Statics.ScreenArgumentsNew(widget.swItem["SwayamsevakID"], value));
                          }
                        },
                        icon: Icon(
                          FontAwesomeIcons.ellipsisV,
                          color: Colors.grey,
                        ),
                        itemBuilder: (BuildContext context) {
                          return [
                            // Statics.MenuItem(Statics.getLabel('addinSoochi'), Icons.list, 'AddinSoochi'),
                            if (showEditMenu == true) Statics.MenuItem(Statics.getLabel('EditMenu'), FontAwesomeIcons.edit, 'EditMenu'),
                            if (showEditMenu == true && Statics.userDetails['MobileNumber'] == '9322406725-1234')
                              Statics.MenuItem(Statics.getLabel('EditMenu') + '-New', FontAwesomeIcons.edit, 'EditMenuNew'),
                            if (showEditMenu == true && Statics.userDetails['MobileNumber'] == '9322406725-1234')
                              Statics.MenuItem(Statics.getLabel('Daayitva') + '-New', FontAwesomeIcons.edit, 'DaayitvaMenu'),
                            if (showEditMenu == true && Statics.userDetails['MobileNumber'] == '9322406725-1234')
                              Statics.MenuItem(Statics.getLabel('OtherInfo') + '-New', FontAwesomeIcons.edit, 'OtherInfoMenu'),
                            if (showEditMenu == true && Statics.userDetails['MobileNumber'] == '9322406725-1234')
                              Statics.MenuItem(Statics.getLabel('SanghaShikshanShaaririk') + '-New', FontAwesomeIcons.edit, 'SanghaShikshanShaaririkMenu'),
                            if (showEditMenu == true && Statics.userDetails['MobileNumber'] == '9322406725-1234')
                              Statics.MenuItem(Statics.getLabel('GhoshVishay') + '-New', FontAwesomeIcons.edit, 'GhoshVishayMenu'),
                            if (showEditMenu == true && Statics.userDetails['MobileNumber'] == '9322406725-1234')
                              Statics.MenuItem(Statics.getLabel('Occupation') + '-New', FontAwesomeIcons.edit, 'OccupationMenu'),
                            Statics.MenuItem(Statics.getLabel('ViewMenu'), FontAwesomeIcons.eye, 'ViewMenu'),
                            if (showResetPasswordMenu == true) Statics.MenuItem(Statics.getLabel('ResetPassword'), Icons.settings_backup_restore, 'ResetPassword'),
                            if (showDeleteMenu == true) Statics.MenuItem(Statics.getLabel('Delete'), Icons.delete, 'Delete'),
                            if (showTransferMenu == true) Statics.MenuItem(Statics.getLabel('CardMenuSwayamsevakTransfer'), Icons.transfer_within_a_station, 'Transfer'),
                          ].map((Statics.MenuItem menuItem) {
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> changeEditStatus(bool newValue) async {
    String userId = widget.swItem["SwayamsevakID"].toString();
    // print(userId);
    int editStatus = newValue ? 1 : 0;
    var inputData = '{"userid":"$userId","can_edit":$editStatus}';
    await SwayamsevakProvider().changeSwayamsewakCanEditStatus(inputData);
  }
}

class SwayamsevakHomeAbhiyanCard extends StatefulWidget {
  final AbhiyanSwayamsevakList swItem;
  final dynamic onCheckCard;
  final dynamic onUnCheckCard;
  final bool isChecked;
  final Function getAbhiyaanSwayamsevakListData;

  SwayamsevakHomeAbhiyanCard({required this.swItem, this.onCheckCard, this.onUnCheckCard, required this.isChecked, required this.getAbhiyaanSwayamsevakListData});

  @override
  _SwayamsevakHomeAbhiyanCardState createState() => _SwayamsevakHomeAbhiyanCardState();
}

// void deleteSahbhagiKaryakarta(var context, var sahabhagikaryakartaId) async {
//   try {
//     bool isConnected = await Statics.isInternetConnected();
//     if (!isConnected) {
//       Statics.showMessageDialog(context, Statics.getLabel('internetNotConnected'));
//     } else {
//       showDialog(
//         context: context,
//         builder: (ctx) => AlertDialog(
//           title: Text(Statics.getLabel('AskConfirmation')),
//           content: Text(Statics.getLabel('AreyouSureYouWantToDeleteSahbhagiKaryakarta')),
//           actions: <Widget>[
//             MaterialButton(
//               child: Text(Statics.getLabel('ConfirmationYes')),
//               onPressed: () async {
//                 var data = await Statics.deleteSahbhagiKaryakarta(json.encode({"AbhiyanSwayamsevakID": sahabhagikaryakartaId}));
//                 if (data.contains("Deleted Successfully")) {
//                     Statics.showToast(Statics.getLabel('SahbhagiKaryakartaDeletedSuccessfully'));
//                 } else
//                   Statics.showToast(Statics.getLabel('SahbhagiKaryakartaDeletedSuccessfully'));
//                 Navigator.of(ctx).pop();
//               },
//             ),
//             MaterialButton(
//               child: Text(Statics.getLabel('ConfirmationNo')),
//               onPressed: () {
//                 Navigator.of(ctx).pop();
//               },
//             )
//           ],
//         ),
//       );
//     }
//   } on Exception catch (error) {
//     Statics.showErrorDialog(context, Statics.getLabel('unableToCompleteProcess'));
//   } catch (error) {
//     Statics.showErrorDialog(context, Statics.getLabel('unableToCompleteProcess'));
//   }
// }
void deleteSahbhagiKaryakarta(var context, var sahabhagikaryakartaId, Function onDelete) async {
  try {
    bool isConnected = await Statics.isInternetConnected();
    if (!isConnected) {
      Statics.showMessageDialog(context, Statics.getLabel('internetNotConnected'));
    } else {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(Statics.getLabel('AskConfirmation')),
          content: Text(Statics.getLabel('AreyouSureYouWantToDeleteSahbhagiKaryakarta')),
          actions: <Widget>[
            MaterialButton(
              child: Text(Statics.getLabel('ConfirmationYes')),
              onPressed: () async {
                var data = await Statics.deleteSahbhagiKaryakarta(json.encode({"AbhiyanSwayamsevakID": sahabhagikaryakartaId}));
                if (data.contains("Deleted Successfully")) {
                  Statics.showToast(Statics.getLabel('SahbhagiKaryakartaDeletedSuccessfully'));
                  onDelete();
                } else {
                  Statics.showToast(Statics.getLabel('Unable to delete Sahbhagi Karyakarta'));
                }
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

// class _SwayamsevakHomeAbhiyanCardState extends State<SwayamsevakHomeAbhiyanCard> {
//   @override
//   Widget build(BuildContext context) {
//
//     return Card(
//       margin: EdgeInsets.all(5),
//       elevation: 5,
//       child: ListTile(
//         contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
//         title: Text(widget.swItem.participantName!),
//
//         trailing: Container(
//           height: 50,
//           width: 0.1 * Statics.getDeviceSize(context).width,
//           child: Stack(
//             children: [
//               Positioned(
//                 right: 0.0,
//                 top: 0.0,
//                 child: PopupMenuButton(
//                   padding: EdgeInsets.all(5),
//                   onSelected: (value) {
//                     if (value == "सुधार") {
//                       Navigator.of(context)
//                           .pushNamed(AbhiyanEditSwayamsevakScreen.routeName, arguments: widget.swItem)
//                           .then((value) => widget.getAbhiyaanSwayamsevakListData.call());
//                     } else if (value == "माहिती पहा") {
//                       Navigator.of(context)
//                           .pushNamed(AbhiyanViewSwayamsevakScreen.routeName, arguments: widget.swItem)
//                           .then((value) => widget.getAbhiyaanSwayamsevakListData.call());
//                     } else if (value == "हटवा") {
//                       setState(() {
//                         Statics.showToast(Statics.getLabel('VisheshVyaktiDeletedSuccessfully'));
//                         deleteSahbhagiKaryakarta(context,widget.swItem.abhiyanSwayamsevakID);
//                       });
//                     print("widget.swItem.abhiyanSwayamsevakID ${widget.swItem.abhiyanSwayamsevakID}");
//                     }
//                   },
//                   child: Icon(
//                     FontAwesomeIcons.ellipsisV,
//                     color: Colors.grey,
//                   ),
//                   itemBuilder: (BuildContext context) {
//                     return [
//                       'सुधार',
//                       'माहिती पहा',
//                       'हटवा',
//                     ].map((String value) {
//                       IconData icon;
//                       switch (value) {
//                         case 'सुधार':
//                           icon = Icons.edit;
//                           break;
//                         case 'माहिती पहा':
//                           icon = Icons.visibility;
//                           break;
//                         case 'हटवा':
//                           icon = Icons.delete;
//                           break;
//                         default:
//                           icon = Icons.help;
//                       }
//                       return PopupMenuItem(
//                         value: value,
//                         child: ListTile(
//                           dense: true,
//                           contentPadding: EdgeInsets.zero,
//                           visualDensity: VisualDensity.compact,
//                           leading: Icon(
//                             icon,
//                             color: Colors.purple,
//                           ),
//                           title: Text(value),
//                         ),
//                       );
//                     }).toList();
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//         subtitle: Container(
//             child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             SizedBox(
//               height: 5,
//             ),
//             Text(widget.swItem.daayityaName!),
//             SizedBox(
//               height: 5,
//             ),
//             Wrap(direction: flutter_axis.Axis.vertical, spacing: 5, children: [
//               RichText(
//                 text: TextSpan(
//                 text: 'M: ${widget.swItem.participantNumber.toString()}${widget.swItem.email.toString().isNotEmpty ? ',' : ''}',
//                 style: TextStyle(color: Colors.blue),
//                 recognizer: TapGestureRecognizer()
//                   ..onTap = () {
//                     UrlLauncher.launch("tel://" + widget.swItem.participantNumber.toString());
//                   },
//               )),
//               if (widget.swItem.email != null && widget.swItem.email!.isNotEmpty)
//                 RichText(
//                   text: TextSpan(
//                       text: 'E: ${widget.swItem.email.toString()}',
//                       style: TextStyle(color: Colors.blue),
//                       recognizer: TapGestureRecognizer()
//                         ..onTap = () {
//                           UrlLauncher.launch("mailto:" + widget.swItem.email.toString());
//                         }),
//                 )
//             ])
//           ],
//         )),
//       ),
//     );
//   }
//
// }
class _SwayamsevakHomeAbhiyanCardState extends State<SwayamsevakHomeAbhiyanCard> {
  bool _isVisible = true;

  @override
  Widget build(BuildContext context) {
    if (!_isVisible) {
      return SizedBox.shrink();
    }

    return Card(
      margin: EdgeInsets.all(5),
      elevation: 5,
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        title: Text(widget.swItem.participantName!),
        trailing: Container(
          height: 50,
          width: 0.1 * Statics.getDeviceSize(context).width,
          child: Stack(
            children: [
              Positioned(
                right: 0.0,
                top: 0.0,
                child: PopupMenuButton(
                  padding: EdgeInsets.all(5),
                  onSelected: (value) {
                    if (value == "सुधार") {
                      Navigator.of(context).pushNamed(AbhiyanEditSwayamsevakScreen.routeName, arguments: widget.swItem).then((value) => widget.getAbhiyaanSwayamsevakListData.call());
                    } else if (value == "माहिती पहा") {
                      Navigator.of(context).pushNamed(AbhiyanViewSwayamsevakScreen.routeName, arguments: widget.swItem).then((value) => widget.getAbhiyaanSwayamsevakListData.call());
                    } else if (value == "हटवा") {
                      setState(() {
                        deleteSahbhagiKaryakarta(context, widget.swItem.abhiyanSwayamsevakID, () {
                          setState(() {
                            _isVisible = false;
                          });
                          widget.getAbhiyaanSwayamsevakListData.call();
                        });
                      });
                    }
                  },
                  child: Icon(
                    FontAwesomeIcons.ellipsisV,
                    color: Colors.grey,
                  ),
                  itemBuilder: (BuildContext context) {
                    return [
                      'सुधार',
                      'माहिती पहा',
                      'हटवा',
                    ].map((String value) {
                      IconData icon;
                      switch (value) {
                        case 'सुधार':
                          icon = Icons.edit;
                          break;
                        case 'माहिती पहा':
                          icon = Icons.visibility;
                          break;
                        case 'हटवा':
                          icon = Icons.delete;
                          break;
                        default:
                          icon = Icons.help;
                      }
                      return PopupMenuItem(
                        value: value,
                        child: ListTile(
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                          visualDensity: VisualDensity.compact,
                          leading: Icon(
                            icon,
                            color: Colors.purple,
                          ),
                          title: Text(value),
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
              Text(widget.swItem.daayityaName!),
              SizedBox(
                height: 5,
              ),
              Wrap(direction: flutter_axis.Axis.vertical, spacing: 5, children: [
                RichText(
                  text: TextSpan(
                    text: 'M: ${widget.swItem.participantNumber.toString()}${widget.swItem.email.toString().isNotEmpty ? ',' : ''}',
                    style: TextStyle(color: Colors.blue),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        UrlLauncher.launch("tel://" + widget.swItem.participantNumber.toString());
                      },
                  ),
                ),
                if (widget.swItem.email != null && widget.swItem.email!.isNotEmpty)
                  RichText(
                    text: TextSpan(
                      text: 'E: ${widget.swItem.email.toString()}',
                      style: TextStyle(color: Colors.blue),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          UrlLauncher.launch("mailto:" + widget.swItem.email.toString());
                        },
                    ),
                  ),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}

class AbhiyanSwayamsevakCard extends StatefulWidget {
  final dynamic swItem;
  final dynamic onSaveDetails;

  AbhiyanSwayamsevakCard({this.swItem, this.onSaveDetails});

  @override
  _AbhiyanSwayamsevakCardState createState() => _AbhiyanSwayamsevakCardState();
}

class _AbhiyanSwayamsevakCardState extends State<AbhiyanSwayamsevakCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(5),
      elevation: 5,
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
        title: Text(widget.swItem["FullName"]),
        subtitle: Container(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 5,
            ),
            if (widget.swItem["DaayitvaGeoUnitName"].toString().isNotEmpty)
              Wrap(
                spacing: 1,
                children: [
                  Text(widget.swItem["DaayitvaGeoUnitName"]),
                  Text(widget.swItem["LevelName"]),
                  Text(widget.swItem["DaayitvaName"]),
                ],
              ),
            SizedBox(
              height: 5,
            ),
            Wrap(spacing: 2, children: [
              RichText(
                  text: TextSpan(
                text: 'M: ${widget.swItem["MobileNumber"].toString()}${widget.swItem["Email"].toString().isNotEmpty ? ',' : ''}',
                style: TextStyle(color: Colors.blue),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    UrlLauncher.launch("tel://" + widget.swItem["MobileNumber"].toString());
                  },
              )),
              if (widget.swItem['Email'].toString().isNotEmpty)
                RichText(
                  text: TextSpan(
                      text: 'E: ${widget.swItem["Email"].toString()}',
                      style: TextStyle(color: Colors.blue),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          UrlLauncher.launch("mailto:" + widget.swItem["Email"].toString());
                        }),
                )
            ])
          ],
        )),
      ),
    );
  }
}*/

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

import '../helpers/static_data.dart' as Statics;
import '../providers/swayamsevak_provider.dart';
import '../screens/AbhiyanEditSwayamsevak.dart';
import '../screens/AbhiyanViewSwayamsevak.dart';
import '../screens/swayamsevak_module/edit_module/edit_swayamsevak_basic_info.dart';
import '../screens/swayamsevak_module/edit_module/edit_swayamsevak_daayitva.dart';
import '../screens/swayamsevak_module/edit_module/edit_swayamsevak_other_info.dart';
import '../screens/swayamsevak_module/edit_module/edit_swayamsevak_screen.dart';
import '../screens/swayamsevak_module/edit_module/edit_swayamsevak_transfer.dart';

// ============================================================================
// MODERNIZED SWAYAMSEVAK CARD
// ============================================================================

class PendingModule {
  final String name;
  final List<String> keys;

  const PendingModule({
    required this.name,
    required this.keys,
  });

  factory PendingModule.fromJson(Map<String, dynamic> json) {
    return PendingModule(
      name: json['module']?.toString() ?? '',
      keys: json['pkeys'] != null ? List<String>.from(json['pkeys'].map((e) => e.toString())) : [],
    );
  }
}

// ============================================================================
// MODERNIZED SWAYAMSEVAK CARD
// ============================================================================

final regExp = RegExp(r'\$(\d+)\$');

class SwayamsevakCard extends StatefulWidget {
  final dynamic swItem;
  final Function(String, String, String) onCheckCard;
  final Function(String, String, String) onUnCheckCard;
  final bool isChecked;
  final Function(String) onSaveDetails;

  // NEW: Completion fields
  final double percentage;
  final List<PendingModule> pendingModules;

  const SwayamsevakCard({
    Key? key,
    required this.swItem,
    required this.onCheckCard,
    required this.onUnCheckCard,
    required this.isChecked,
    required this.onSaveDetails,
    this.percentage = 0.0,
    this.pendingModules = const [],
  }) : super(key: key);

  @override
  State<SwayamsevakCard> createState() => _SwayamsevakCardState();
}

class _SwayamsevakCardState extends State<SwayamsevakCard> {
  late bool _isChecked;

  @override
  void initState() {
    super.initState();
    _isChecked = widget.isChecked;
  }

  @override
  void didUpdateWidget(SwayamsevakCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isChecked != widget.isChecked) {
      setState(() {
        _isChecked = widget.isChecked;
      });
    }
  }

  // ============================================================================
  // PERMISSION CHECKS
  // ============================================================================

  PermissionSet _getPermissions() {
    final levelName = Statics.userDetails['LevelName'];
    final daayitvaName = Statics.userDetails['DaayitvaName'];
    final levelID = int.tryParse(Statics.userDetails['LevelID'] ?? '0') ?? 0;
    final mobileNumber = Statics.userDetails['MobileNumber'];

    return PermissionSet(
      canTransfer: _checkTransferPermission(levelName, daayitvaName),
      canEdit: true,
      canResetPassword: levelID >= 4 && widget.swItem["CanUseApp"] == true,
      canDelete: _checkDeletePermission(levelName, daayitvaName),
      isDevUser: mobileNumber == '9322406725-1234',
    );
  }

  bool _checkTransferPermission(String? levelName, String? daayitvaName) {
    final highLevels = ['Praant', 'प्रांत', 'Mahaanagar', 'महानगर', 'Bhaag', 'भाग/जिल्हा', 'भाग/जिला', 'Vibhaag', 'विभाग', 'Nagar', 'Nagar/Taalukaa', 'नगर/तालुका'];
    final shaakhaRoles = ['Mukhya Shikshak', 'मुख्य शिक्षक', 'Kaaryavaah', 'कार्यवाह'];
    final specialRoles = [
      'Join RSS Sanyojak',
      'जॉयन आर.एस.एस. संयोजक',
      'Join RSS Pramukh',
      'जॉयन आर.एस.एस. प्रमुख',
      'Baal Vidyaarthi Pramukh',
      'बाल विद्यार्थी प्रमुख',
      'Mahaavidyaalayeen Vidyaarthi Pramukh',
      'महाविद्यालयीन प्रमुख',
      'Vyavasaayee Pramukh',
      'व्यवसायी प्रमुख',
      'Vyavasaayee Saha-Pramukh',
      'व्यवसायी सह प्रमुख',
      'App Sanyojak',
      'एप संयोजक',
      'Mandal Samiti Sadasya',
      'मंडल समिती सदस्य',
      'Prachaarak',
      'प्रचारक',
      'Saha-Prachaarak',
      'सह प्रचारक'
    ];

    if (highLevels.contains(levelName)) return true;
    if (levelName == 'Shaakhaa' || levelName == 'शाखा') {
      return shaakhaRoles.contains(daayitvaName);
    }
    return specialRoles.contains(daayitvaName);
  }

  bool _checkDeletePermission(String? levelName, String? daayitvaName) {
    final allowedLevels = ['Praant', 'प्रांत', 'Mahaanagar', 'महानगर', 'Bhaag', 'भाग/जिल्हा', 'भाग/जिला', 'Vibhaag', 'विभाग', 'Nagar', 'Nagar/Taalukaa', 'नगर/तालुका'];
    final shaakhaRoles = ['Mukhya Shikshak', 'मुख्य शिक्षक', 'Kaaryavaah', 'कार्यवाह'];
    final prachaarakRoles = ['Prachaarak', 'प्रचारक', 'Saha-Prachaarak', 'सह प्रचारक'];

    if (allowedLevels.contains(levelName)) return true;
    if (levelName == 'Shaakhaa' || levelName == 'शाखा') {
      return shaakhaRoles.contains(daayitvaName);
    }
    if (levelName == 'Vibhaag' || levelName == 'विभाग') return true;
    return prachaarakRoles.contains(daayitvaName);
  }

  // ============================================================================
  // DELETE HANDLER
  // ============================================================================

  Future<void> _deleteSwayamSevak() async {
    try {
      bool isConnected = await Statics.isInternetConnected();
      if (!isConnected) {
        Statics.showMessageDialog(context, Statics.getLabel('internetNotConnected'));
        return;
      }

      final confirmed = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(Statics.getLabel('AskConfirmation')),
          content: Text(Statics.getLabel('AreyouSureYouWantToDeleteSwayamsevak')),
          actions: [
            TextButton(
              child: Text(Statics.getLabel('ConfirmationNo'), style: TextStyle(color: Colors.grey[700], fontSize: 16)),
              onPressed: () => Navigator.of(ctx).pop(false),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Text(Statics.getLabel('ConfirmationYes'), style: TextStyle(fontSize: 16)),
              onPressed: () => Navigator.of(ctx).pop(true),
            ),
          ],
        ),
      );

      if (confirmed == true) {
        final inputData = json.encode({"SwayamsevakID": widget.swItem["SwayamsevakID"]});
        final data = await Statics.deleteSwayamsevakDataForApp(inputData);
        if (data.contains("Deleted Successfully")) {
          Statics.showToast(Statics.getLabel('SwayamsevakDeletedSuccessfully'));
          widget.onSaveDetails("Search");
        } else {
          Statics.showToast(Statics.getLabel('CouldnotDeleteSwayamsevak'));
        }
      }
    } catch (error) {
      Statics.showErrorDialog(context, Statics.getLabel('unableToCompleteProcess'));
    }
  }

  // ============================================================================
  // EDIT STATUS HANDLER
  // ============================================================================

  Future<void> _changeEditStatus(bool newValue) async {
    final userId = widget.swItem["SwayamsevakID"].toString();
    final editStatus = newValue ? 1 : 0;
    final inputData = '{"userid":"$userId","can_edit":$editStatus}';
    await SwayamsevakProvider().changeSwayamsewakCanEditStatus(inputData);
  }

  // ============================================================================
  // MENU HANDLERS
  // ============================================================================

  void _handleMenuSelection(String value, PermissionSet permissions) {
    final swayamsevakID = widget.swItem["SwayamsevakID"];
    switch (value) {
      case "ResetPassword":
        Statics.showConfirmationBox(context, Statics.getLabel('ConfirmResetpassword'), "ResetPassword", swayamsevakID.toString());
        break;
      case "Delete":
        _deleteSwayamSevak();
        break;
      case "Transfer":
        Navigator.of(context).pushNamed(
          EditSwayamsevakTransferScreen.routeName,
          arguments: Statics.ScreenArgumentsSwayamsevakTransfer('0', swayamsevakID.toString(), value),
        );
        break;
      case "EditMenuNew":
        Navigator.of(context).pushNamed(EditSwayamsevakBasicInfo.routeName, arguments: Statics.ScreenArgumentsNew(swayamsevakID, value));
        break;
      case "DaayitvaMenu":
        Navigator.of(context).pushNamed(EditSwayamsevakDaayitva.routeName, arguments: Statics.ScreenArguments(swayamsevakID, value));
        break;
      case "OtherInfoMenu":
        Navigator.of(context).pushNamed(EditSwayamsevakOtherInfo.routeName, arguments: Statics.ScreenArguments(swayamsevakID, value));
        break;
      default:
        Navigator.of(context).pushNamed(EditSwayamsevakScreen.routeName, arguments: Statics.ScreenArgumentsNew(swayamsevakID, value));
    }
  }

  /// Navigate directly to the screen for a pending module key.
  /// Add/extend cases here as your route map grows.
  void _handlePendingModuleTap(PendingModule module) {
    Navigator.of(context).pop(); // close the bottom sheet first
    final swayamsevakID = widget.swItem["SwayamsevakID"];
    String? tabNo;
    final match = regExp.firstMatch(module.name);
    if (match != null) {
      tabNo = match.group(1); // "15602"
    }
    Navigator.of(context).pushNamed(
      EditSwayamsevakScreen.routeName,
      arguments: Statics.ScreenArgumentsNew(swayamsevakID, Statics.getLabel('EditMenu'), tabNo: int.tryParse(tabNo ?? "0") ?? 0),
    );
  }

  List<PopupMenuEntry<String>> _buildMenuItems(PermissionSet permissions) {
    final items = <PopupMenuEntry<String>>[];

    if (permissions.canEdit) {
      items.add(_buildMenuItem('EditMenu', Icons.edit, Statics.getLabel('EditMenu')));
      if (permissions.isDevUser) {
        items.add(_buildMenuItem('EditMenuNew', Icons.edit_note, '${Statics.getLabel('EditMenu')}-New'));
        items.add(_buildMenuItem('DaayitvaMenu', Icons.work, '${Statics.getLabel('Daayitva')}-New'));
        items.add(_buildMenuItem('OtherInfoMenu', Icons.info, '${Statics.getLabel('OtherInfo')}-New'));
      }
    }

    items.add(_buildMenuItem('ViewMenu', Icons.visibility, Statics.getLabel('ViewMenu')));

    if (permissions.canResetPassword) {
      items.add(_buildMenuItem('ResetPassword', Icons.lock_reset, Statics.getLabel('ResetPassword')));
    }
    if (permissions.canDelete) {
      items.add(_buildMenuItem('Delete', Icons.delete, Statics.getLabel('Delete')));
    }
    if (permissions.canTransfer) {
      items.add(_buildMenuItem('Transfer', Icons.swap_horiz, Statics.getLabel('CardMenuSwayamsevakTransfer')));
    }

    return items;
  }

  PopupMenuItem<String> _buildMenuItem(String key, IconData icon, String label) {
    return PopupMenuItem(
      value: key,
      child: Row(
        children: [
          Icon(icon, color: Colors.deepPurple, size: 20),
          SizedBox(width: 12),
          Expanded(child: Text(label, style: TextStyle(fontSize: 15))),
        ],
      ),
    );
  }

  // ============================================================================
  // BUILD METHOD
  // ============================================================================

  @override
  Widget build(BuildContext context) {
    final permissions = _getPermissions();
    final canEdit = widget.swItem["can_edit"] == true;
    final bool isComplete = widget.percentage >= 100.0;

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 2,
      surfaceTintColor: Colors.transparent,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: _isChecked ? Colors.deepPurple.withOpacity(0.3) : Colors.transparent,
          width: 2,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: _isChecked
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.deepPurple.withOpacity(0.05), Colors.purple.withOpacity(0.02)],
                )
              : null,
        ),
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ==============================================================
              // HEADER ROW — Checkbox + Name + Actions
              // ==============================================================
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Checkbox
                  Transform.scale(
                    scale: 1.125,
                    child: Checkbox(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                      checkColor: Colors.white,
                      activeColor: Colors.deepPurple,
                      value: _isChecked,
                      onChanged: (value) {
                        setState(() {
                          _isChecked = value!;
                          if (value) {
                            widget.onCheckCard(widget.swItem["Email"], widget.swItem["MobileNumber"], widget.swItem["SwayamsevakID"].toString());
                          } else {
                            widget.onUnCheckCard(widget.swItem["Email"], widget.swItem["MobileNumber"], widget.swItem["SwayamsevakID"].toString());
                          }
                        });
                      },
                    ),
                  ),

                  SizedBox(width: 8),

                  // Name and Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.swItem["FullName"] ?? "",
                          style: TextStyle(fontSize: 15.5, fontWeight: FontWeight.w600, color: Colors.black87, height: 1.3),
                        ),
                        SizedBox(height: 8),
                        if (widget.swItem["DaayitvaGeoUnitName"].toString().isNotEmpty) ...[
                          _buildInfoChips(),
                          SizedBox(height: 8),
                        ],
                        _buildContactInfo(),
                      ],
                    ),
                  ),

                  SizedBox(width: 8),

                  // Actions Column
                  Column(
                    children: [
                      _buildEditToggle(canEdit),
                      SizedBox(height: 8),
                      _buildMenuButton(permissions),
                    ],
                  ),
                ],
              ),

              // ==============================================================
              // COMPLETION INDICATOR BAR
              // ==============================================================
              SizedBox(height: 10),
              _buildCompletionIndicator(isComplete),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================================
  // COMPLETION INDICATOR
  // ============================================================================

  Widget _buildCompletionIndicator(bool isComplete) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: isComplete ? Colors.green.withOpacity(0.07) : Colors.orange.withOpacity(0.07),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isComplete ? Colors.green.withOpacity(0.25) : Colors.orange.withOpacity(0.25),
        ),
      ),
      child: isComplete ? _buildCompleteState() : _buildIncompleteState(),
    );
  }

  /// 100% — simple green tick + label
  Widget _buildCompleteState() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Row: label + percentage + info button
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.check, color: Colors.white, size: 13),
            ),
            SizedBox(width: 6),
            Text(
              Statics.getLabel('ProfileComplete'),
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: _percentageColor(100)),
            ),
            Spacer(),
            // Percentage badge
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: _percentageColor(100).withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: _percentageColor(100).withOpacity(0.4)),
              ),
              child: Text(
                '100%',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: _percentageColor(100),
                ),
              ),
            ),
            SizedBox(width: 6),
          ],
        ),

        SizedBox(height: 8),

        // Progress bar
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: widget.percentage.clamp(0.0, 100.0) / 100.0,
            minHeight: 6,
            backgroundColor: Colors.grey.withOpacity(0.2),
            valueColor: AlwaysStoppedAnimation<Color>(_percentageColor(100)),
          ),
        ),
      ],
    );
  }

  /// < 100% — progress bar + percentage + info button
  Widget _buildIncompleteState() {
    final int pct = widget.percentage.clamp(0.0, 100.0).toInt();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Row: label + percentage + info button
        Row(
          children: [
            Icon(Icons.pending_actions_outlined, size: 14, color: Colors.orange[700]),
            SizedBox(width: 6),
            Text(
              Statics.getLabel('ProfileIncomplete'), // e.g. "Profile Incomplete"
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.orange[800]),
            ),
            Spacer(),
            // Percentage badge
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: _percentageColor(pct).withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: _percentageColor(pct).withOpacity(0.4)),
              ),
              child: Text(
                '$pct%',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: _percentageColor(pct),
                ),
              ),
            ),
            SizedBox(width: 6),
            // Info button — only when there are pending modules to show
            if (widget.pendingModules.isNotEmpty)
              GestureDetector(
                onTap: _showPendingModulesSheet,
                child: Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple.withOpacity(0.1),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.deepPurple.withOpacity(0.3)),
                  ),
                  child: Icon(Icons.info_outline, size: 15, color: Colors.deepPurple),
                ),
              ),
          ],
        ),

        SizedBox(height: 8),

        // Progress bar
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: widget.percentage.clamp(0.0, 100.0) / 100.0,
            minHeight: 6,
            backgroundColor: Colors.grey.withOpacity(0.2),
            valueColor: AlwaysStoppedAnimation<Color>(_percentageColor(pct)),
          ),
        ),
      ],
    );
  }

  /// Color transitions: red → orange → green as pct climbs
  Color _percentageColor(int pct) {
    if (pct < 40) return Colors.red[600]!;
    if (pct < 75) return Colors.orange[700]!;
    return Colors.teal[600]!;
  }

  // ============================================================================
  // PENDING MODULES BOTTOM SHEET
  // ============================================================================

  void _showPendingModulesSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _PendingModulesSheet(
        pendingModules: widget.pendingModules,
        percentage: widget.percentage,
        onModuleTap: _handlePendingModuleTap,
      ),
    );
  }

  // ============================================================================
  // UI COMPONENTS (unchanged)
  // ============================================================================

  Widget _buildInfoChips() {
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: [
        _buildChip(widget.swItem["DaayitvaGeoUnitName"], Icons.location_on),
        _buildChip(widget.swItem["LevelName"], Icons.layers),
        _buildChip(widget.swItem["DaayitvaName"], Icons.work),
      ],
    );
  }

  Widget _buildChip(String text, IconData icon) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.deepPurple.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.deepPurple.withOpacity(0.2), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.deepPurple),
          SizedBox(width: 4),
          Text(text, style: TextStyle(fontSize: 11.5, color: Colors.deepPurple[700], fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildContactInfo() {
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: [
        _buildContactButton(
          icon: Icons.phone,
          label: widget.swItem["MobileNumber"].toString(),
          onTap: () => UrlLauncher.launch("tel://${widget.swItem["MobileNumber"]}"),
        ),
        if (widget.swItem['Email'].toString().isNotEmpty)
          _buildContactButton(
            icon: Icons.email,
            label: widget.swItem["Email"].toString(),
            onTap: () => UrlLauncher.launch("mailto:${widget.swItem["Email"]}"),
          ),
      ],
    );
  }

  Widget _buildContactButton({required IconData icon, required String label, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.08),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.blue.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: Colors.blue[700]),
            SizedBox(width: 6),
            Flexible(
              child: Text(
                label,
                style: TextStyle(fontSize: 13, color: Colors.blue[700], fontWeight: FontWeight.w500),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditToggle(bool canEdit) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: canEdit ? Colors.green.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: canEdit ? Colors.green.withOpacity(0.3) : Colors.grey.withOpacity(0.3)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(Icons.edit, size: 16, color: canEdit ? Colors.green[700] : Colors.grey[600]),
              SizedBox(width: 2),
              Text("Edit", style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: canEdit ? Colors.green[700] : Colors.grey[600])),
            ],
          ),
          Transform.scale(
            scale: 0.7,
            child: Switch(
              value: canEdit,
              onChanged: (bool newValue) async {
                setState(() => widget.swItem["can_edit"] = newValue);
                await _changeEditStatus(newValue);
              },
              activeColor: Colors.green,
              inactiveThumbColor: Colors.grey,
              inactiveTrackColor: Colors.grey.withOpacity(0.3),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuButton(PermissionSet permissions) {
    return PopupMenuButton<String>(
      padding: EdgeInsets.zero,
      color: Colors.purple.shade50,
      position: PopupMenuPosition.under,
      borderRadius: BorderRadius.circular(16),
      onSelected: (value) => _handleMenuSelection(value, permissions),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      itemBuilder: (context) => _buildMenuItems(permissions),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.deepPurple.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.deepPurple.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.more_vert, size: 16, color: Colors.deepPurple),
            SizedBox(width: 2),
            Text("Menu", style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Colors.deepPurple)),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// PENDING MODULES BOTTOM SHEET  (separate widget for cleanliness)
// ============================================================================

class _PendingModulesSheet extends StatelessWidget {
  final List<PendingModule> pendingModules;
  final double percentage;
  final void Function(PendingModule) onModuleTap;

  _PendingModulesSheet({
    required this.pendingModules,
    required this.percentage,
    required this.onModuleTap,
  });

  @override
  Widget build(BuildContext context) {
    final int pct = percentage.clamp(0.0, 100.0).toInt();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 20, offset: Offset(0, -4))],
      ),
      padding: EdgeInsets.fromLTRB(20, 12, 20, 24 + MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)),
            ),
          ),
          SizedBox(height: 16),

          // Title row
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.pending_actions, color: Colors.orange[700], size: 20),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Statics.getLabel('PendingFields'), // e.g. "Pending Fields"
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.black87),
                    ),
                    Text(
                      '${pendingModules.length} ${Statics.getLabel('FieldsRemaining')}', // e.g. "fields remaining"
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              // Circular progress indicator
              SizedBox(
                width: 48,
                height: 48,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircularProgressIndicator(
                      value: percentage.clamp(0.0, 100.0) / 100.0,
                      strokeWidth: 4,
                      backgroundColor: Colors.grey.withOpacity(0.2),
                      valueColor: AlwaysStoppedAnimation<Color>(_percentageColor(pct)),
                    ),
                    Text(
                      '$pct%',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: _percentageColor(pct)),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 16),
          Divider(height: 1, color: Colors.grey[200]),
          SizedBox(height: 8),

          // Module list
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.45,
            ),
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: pendingModules.length,
              separatorBuilder: (_, __) => SizedBox(height: 6),
              itemBuilder: (ctx, index) {
                final module = (pendingModules[index]);
                return _buildModuleTile(module, index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModuleTile(PendingModule module, int index) {
    String cleanedText = module.name.replaceAll(regExp, '').trim();
    return InkWell(
      onTap: () => onModuleTap(module),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.deepPurple.withOpacity(0.04),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.deepPurple.withOpacity(0.12)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Index bubble
            Container(
              width: 26,
              height: 26,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.15),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.orange.withOpacity(0.4)),
              ),
              child: Text(
                '${index + 1}',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.orange[800]),
              ),
            ),
            SizedBox(width: 12),
            // Module name
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 4,
                children: [
                  Text(
                    cleanedText,
                    style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600, color: Colors.black),
                  ),
                  Text(
                    module.keys.asMap().entries.map((entry) => '${String.fromCharCode(97 + entry.key)}. ${entry.value}').join('\n'),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            // Tap cue
            Icon(Icons.arrow_forward_ios_rounded, size: 13, color: Colors.deepPurple.withOpacity(0.5)),
          ],
        ),
      ),
    );
  }

  Color _percentageColor(int pct) {
    if (pct < 40) return Colors.red[600]!;
    if (pct < 75) return Colors.orange[700]!;
    return Colors.teal[600]!;
  }
}

// ============================================================================
// PERMISSION SET CLASS
// ============================================================================

class PermissionSet {
  final bool canTransfer;
  final bool canEdit;
  final bool canResetPassword;
  final bool canDelete;
  final bool isDevUser;

  PermissionSet({
    required this.canTransfer,
    required this.canEdit,
    required this.canResetPassword,
    required this.canDelete,
    required this.isDevUser,
  });
}

// ============================================================================
// LIST CONTAINER - MODERNIZED
// ============================================================================

class SwayamsevakListContainer extends StatelessWidget {
  final bool isSelectAll;
  final Function(bool) onSelectAll;
  final Future<List<dynamic>>? swList;
  final Function(String, String, String) onCheckCard;
  final Function(String, String, String) onUnCheckCard;
  final Function(String) search;

  const SwayamsevakListContainer({
    Key? key,
    required this.isSelectAll,
    required this.onSelectAll,
    required this.swList,
    required this.onCheckCard,
    required this.onUnCheckCard,
    required this.search,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(12, 16, 12, 12),
      child: Column(
        children: [
          // // Header
          // Container(
          //   padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          //   decoration: BoxDecoration(
          //     gradient: LinearGradient(
          //       colors: [Colors.deepPurple, Colors.purple],
          //     ),
          //     borderRadius: BorderRadius.circular(12),
          //     boxShadow: [
          //       BoxShadow(
          //         color: Colors.deepPurple.withOpacity(0.3),
          //         blurRadius: 8,
          //         offset: Offset(0, 4),
          //       ),
          //     ],
          //   ),
          //   child: Row(
          //     children: [
          //       Icon(Icons.people, color: Colors.white, size: 28),
          //       SizedBox(width: 12),
          //       Text(
          //         Statics.getLabel('SwayamsevaksList'),
          //         style: TextStyle(
          //           fontSize: 22,
          //           fontWeight: FontWeight.bold,
          //           color: Colors.white,
          //         ),
          //       ),
          //     ],
          //   ),
          // ),

          SizedBox(height: 16),

          // Select All
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              title: Row(
                children: [
                  // Icon(Icons.check_circle_outline, color: Colors.deepPurple, size: 20),
                  // SizedBox(width: 8),
                  Text(
                    Statics.getLabel('SelectAll'),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              checkColor: Colors.white,
              activeColor: Colors.deepPurple,
              value: isSelectAll,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
              controlAffinity: ListTileControlAffinity.leading,
              onChanged: (value) => onSelectAll(value ?? false),
            ),
          ),

          SizedBox(height: 12),

          // List
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: swList,
              builder: (ctx, dataSnapshot) {
                if (dataSnapshot.connectionState != ConnectionState.done) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Loading...',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                if (dataSnapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline, size: 64, color: Colors.red),
                        SizedBox(height: 16),
                        Text(
                          'Server Error',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Please Try Again Later',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                if (!dataSnapshot.hasData || dataSnapshot.data!.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        SizedBox(height: 16),
                        Text(
                          Statics.getLabel('noDataFoundTryAnotherSearch'),
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: dataSnapshot.data!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return SwayamsevakCard(
                      swItem: dataSnapshot.data![index],
                      onCheckCard: onCheckCard,
                      onUnCheckCard: onUnCheckCard,
                      isChecked: isSelectAll,
                      onSaveDetails: search,
                      percentage: (dataSnapshot.data![index]["percentage"] ?? 0).toDouble(),
                      pendingModules: ((dataSnapshot.data![index]['pendindpoints'] as List?) ?? []).map((e) => PendingModule.fromJson(e as Map<String, dynamic>)).toList(),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// ABHIYAN SWAYAMSEVAK CARD - MODERNIZED
// ============================================================================

class SwayamsevakHomeAbhiyanCard extends StatefulWidget {
  final dynamic swItem;
  final Function(String, String, String) onCheckCard;
  final Function(String, String, String) onUnCheckCard;
  final bool isChecked;
  final VoidCallback getAbhiyaanSwayamsevakListData;

  const SwayamsevakHomeAbhiyanCard({
    Key? key,
    required this.swItem,
    required this.onCheckCard,
    required this.onUnCheckCard,
    required this.isChecked,
    required this.getAbhiyaanSwayamsevakListData,
  }) : super(key: key);

  @override
  State<SwayamsevakHomeAbhiyanCard> createState() => _SwayamsevakHomeAbhiyanCardState();
}

class _SwayamsevakHomeAbhiyanCardState extends State<SwayamsevakHomeAbhiyanCard> {
  bool _isVisible = true;

  Future<void> _deleteSahbhagiKaryakarta() async {
    try {
      bool isConnected = await Statics.isInternetConnected();
      if (!isConnected) {
        Statics.showMessageDialog(
          context,
          Statics.getLabel('internetNotConnected'),
        );
        return;
      }

      final confirmed = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(Statics.getLabel('AskConfirmation')),
          content: Text(
            Statics.getLabel('AreyouSureYouWantToDeleteSahbhagiKaryakarta'),
          ),
          actions: [
            TextButton(
              child: Text(
                Statics.getLabel('ConfirmationNo'),
                style: TextStyle(color: Colors.grey[700], fontSize: 16),
              ),
              onPressed: () => Navigator.of(ctx).pop(false),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                Statics.getLabel('ConfirmationYes'),
                style: TextStyle(fontSize: 16),
              ),
              onPressed: () => Navigator.of(ctx).pop(true),
            ),
          ],
        ),
      );

      if (confirmed == true) {
        final data = await Statics.deleteSahbhagiKaryakarta(
          json.encode({"AbhiyanSwayamsevakID": widget.swItem.abhiyanSwayamsevakID}),
        );

        if (data.contains("Deleted Successfully")) {
          Statics.showToast(
            Statics.getLabel('SahbhagiKaryakartaDeletedSuccessfully'),
          );
          setState(() {
            _isVisible = false;
          });
          widget.getAbhiyaanSwayamsevakListData();
        } else {
          Statics.showToast('Unable to delete Sahbhagi Karyakarta');
        }
      }
    } catch (error) {
      Statics.showErrorDialog(
        context,
        Statics.getLabel('unableToCompleteProcess'),
      );
    }
  }

  void _handleMenuSelection(String value) {
    switch (value) {
      case 'सुधार':
        Navigator.of(context)
            .pushNamed(
              AbhiyanEditSwayamsevakScreen.routeName,
              arguments: widget.swItem,
            )
            .then((_) => widget.getAbhiyaanSwayamsevakListData());
        break;

      case 'माहिती पहा':
        Navigator.of(context)
            .pushNamed(
              AbhiyanViewSwayamsevakScreen.routeName,
              arguments: widget.swItem,
            )
            .then((_) => widget.getAbhiyaanSwayamsevakListData());
        break;

      case 'हटवा':
        _deleteSahbhagiKaryakarta();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isVisible) {
      return SizedBox.shrink();
    }

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(14),
        child: Row(
          children: [
            // Main Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name
                  Text(
                    widget.swItem.participantName ?? '',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),

                  SizedBox(height: 8),

                  // Daayitva
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.deepPurple.withOpacity(0.2),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.work,
                          size: 14,
                          color: Colors.deepPurple,
                        ),
                        SizedBox(width: 6),
                        Text(
                          widget.swItem.daayityaName ?? '',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.deepPurple[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 10),

                  // Contact Info
                  Wrap(
                    spacing: 12,
                    runSpacing: 8,
                    children: [
                      // Phone
                      _buildContactButton(
                        icon: Icons.phone,
                        label: widget.swItem.participantNumber?.toString() ?? '',
                        onTap: () => UrlLauncher.launch(
                          "tel://${widget.swItem.participantNumber}",
                        ),
                      ),

                      // Email
                      if (widget.swItem.email != null && widget.swItem.email!.isNotEmpty)
                        _buildContactButton(
                          icon: Icons.email,
                          label: widget.swItem.email!,
                          onTap: () => UrlLauncher.launch(
                            "mailto:${widget.swItem.email}",
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(width: 12),

            // Action Menu
            _buildActionMenu(),
          ],
        ),
      ),
    );
  }

  Widget _buildContactButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.08),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.blue.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: Colors.blue[700]),
            SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.blue[700],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionMenu() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.deepPurple.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.deepPurple.withOpacity(0.3)),
      ),
      child: PopupMenuButton<String>(
        padding: EdgeInsets.all(8),
        onSelected: _handleMenuSelection,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        icon: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.more_vert, color: Colors.deepPurple, size: 20),
            SizedBox(height: 2),
            Text(
              'Actions',
              style: TextStyle(
                fontSize: 10,
                color: Colors.deepPurple,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        itemBuilder: (BuildContext context) {
          return [
            _buildMenuItem('सुधार', Icons.edit),
            _buildMenuItem('माहिती पहा', Icons.visibility),
            _buildMenuItem('हटवा', Icons.delete),
          ];
        },
      ),
    );
  }

  PopupMenuItem<String> _buildMenuItem(String label, IconData icon) {
    return PopupMenuItem(
      value: label,
      child: Row(
        children: [
          Icon(icon, color: Colors.deepPurple, size: 20),
          SizedBox(width: 12),
          Text(
            label,
            style: TextStyle(fontSize: 15),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// SIMPLE ABHIYAN CARD - MODERNIZED
// ============================================================================

class AbhiyanSwayamsevakCard extends StatelessWidget {
  final dynamic swItem;
  final Function(String) onSaveDetails;

  const AbhiyanSwayamsevakCard({
    Key? key,
    required this.swItem,
    required this.onSaveDetails,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Name
            Text(
              swItem["FullName"] ?? '',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),

            SizedBox(height: 10),

            // Position Details
            if (swItem["DaayitvaGeoUnitName"].toString().isNotEmpty)
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  _buildInfoChip(swItem["DaayitvaGeoUnitName"], Icons.location_on),
                  _buildInfoChip(swItem["LevelName"], Icons.layers),
                  _buildInfoChip(swItem["DaayitvaName"], Icons.work),
                ],
              ),

            SizedBox(height: 10),

            // Contact Info
            Wrap(
              spacing: 12,
              runSpacing: 8,
              children: [
                // Phone
                _buildContactButton(
                  icon: Icons.phone,
                  label: swItem["MobileNumber"]?.toString() ?? '',
                  onTap: () => UrlLauncher.launch(
                    "tel://${swItem["MobileNumber"]}",
                  ),
                ),

                // Email
                if (swItem['Email'].toString().isNotEmpty)
                  _buildContactButton(
                    icon: Icons.email,
                    label: swItem["Email"].toString(),
                    onTap: () => UrlLauncher.launch(
                      "mailto:${swItem["Email"]}",
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(String text, IconData icon) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.deepPurple.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.deepPurple.withOpacity(0.2),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.deepPurple),
          SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 13,
              color: Colors.deepPurple[700],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.08),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.blue.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: Colors.blue[700]),
            SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.blue[700],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
