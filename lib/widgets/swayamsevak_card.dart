import 'dart:convert';

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
import '../screens/edit_swayamsevak_basic_info.dart';
import '../screens/edit_swayamsevak_daayitva.dart';
import '../screens/edit_swayamsevak_other_info.dart';
import '../screens/edit_swayamsevak_screen.dart';
import '../screens/edit_swayamsevak_transfer.dart';

class SwayamsevakCard extends StatefulWidget {
  final swItem;
  var onCheckCard;
  var onUnCheckCard;
  bool? _isChecked;
  var onSaveDetails;

  SwayamsevakCard(this.swItem, this.onCheckCard, this.onUnCheckCard, this._isChecked, this.onSaveDetails);

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
              value: widget._isChecked,
              onChanged: (value) {
                setState(() {
                  widget._isChecked = value!;
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
  AbhiyanSwayamsevakList swItem;
  var onCheckCard;
  var onUnCheckCard;
  bool _isChecked;
  Function getAbhiyaanSwayamsevakListData;

  SwayamsevakHomeAbhiyanCard(this.swItem, this.onCheckCard, this.onUnCheckCard, this._isChecked, this.getAbhiyaanSwayamsevakListData);

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
  final swItem;
  var onSaveDetails;

  AbhiyanSwayamsevakCard(this.swItem, this.onSaveDetails);

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
}
