import 'dart:io';

import 'package:dio/dio.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class MyAppGlobals {
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
}
