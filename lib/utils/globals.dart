import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:niyojak_prod/models/response_model/dropdown_level_responsemodel.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../helpers/database_helper.dart';

//----------------From db----------------//
DropDownModel? ddm;
int? userLevelId;
int? userGeoUnitId;
int? userparentMahanagar;
int? userparentVibhag;
int? userparentBhaag;
int? userparentNagarid;
int? userparentUpanagarid;
int? userparentMandalid;
int? userParentGramid;
int? userParentVastiid;

class MyAppGlobals {
  static String checkTextNullEmpty(String? txt) {
    if (txt == null || txt.isEmpty) return "N/A";
    return txt;
  }

  static String beautifyHeader(String key) {
    // Optional: turn ekunPat → "Ekun Pat", etc.
    final regex = RegExp(r'(?<=[a-z])(?=[A-Z])');
    return key.split(regex).map((w) => w[0].toUpperCase() + w.substring(1)).join(' ');
  }

  static Future<void> downloadFile(String url, String fileName) async {
    try {
      // LoadingDialog.show(Get.context!);
      final status = await Permission.storage.request();
      if (!status.isGranted) {
        print('Permission denied');
        return;
      }

      Directory? downloadsDir;
      if (Platform.isAndroid) {
        downloadsDir = Directory('/storage/emulated/0/Download');

        if (!await downloadsDir.exists()) {
          downloadsDir = await getExternalStorageDirectory();
        }
      } else {
        downloadsDir = await getApplicationDocumentsDirectory();
      }

      String filePath = '${downloadsDir!.path}/$fileName';

      if (await File(filePath).exists()) {
        // LoadingDialog.dismiss(Get.context!);
        await OpenFilex.open(filePath);
        return;
        // return showWarning("Alert!", "Receipt is already downloaded at $filePath");
      }
      Dio dio = Dio();
      await dio.download(url, filePath);
      // LoadingDialog.dismiss(Get.context!);
      print('Downloaded to: $filePath');
      // showSuccess("Success!", "Receipt downloaded to $filePath");
      await OpenFilex.open(filePath);
    } catch (e) {
      // LoadingDialog.dismiss(Get.context!);
      print('Download failed: $e');
      // showError("Error!", "Failed to downloaded Receipt");
    }
  }

  static bool hasValueBetweenDollar(String input) {
    final regExp = RegExp(r'\$(.*?)\$');
    final match = regExp.firstMatch(input);

    return match != null && match.group(1)!.isNotEmpty;
  }

  static Future<DropDownModel> getLevelLDB() async {
    var result = await DatabaseHelper.getData("Select * from DaayitwaLevelMaster;");
    var ddmodel = DropDownModel.fromJson(result.first);
    //List<DropDownModel> dropdownlist = result.map((e) => DropDownModel.fromJson(e)).toList();
    return ddmodel;
  }

  static Map<String, int> levelOrder = {'Mahaanagar': 9, 'Vibhaag': 8, 'Bhaag': 7, 'Nagar': 6, 'upnagarUpkhanda': 5, 'Mandal': 4, 'Graam': 3, 'Vasti': 2};

  static bool isDropdownDisabled(String levelName) {
    int dropdownLevel = levelOrder[levelName] ?? 0;
    if (levelName == 'upnagarUpkhanda') {
      var usLevelid = 5;
      return dropdownLevel >= usLevelid;
    }

    return dropdownLevel >= userLevelId!;
  }
}

Widget buildDropdownField({
  required String label,
  required String? value,
  required List<DropdownMenuItem<String>> items,
  required ValueChanged<String?>? onChanged,
  required bool isDisabled,
}) {
  return IgnorePointer(
    ignoring: isDisabled,
    child: DropdownButtonFormField<String>(
      decoration: InputDecoration(labelText: label),
      isExpanded: true,
      value: (value == null || value.isEmpty) ? null : value,
      items: items,
      onChanged: onChanged,
    ),
  );
}
