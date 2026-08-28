import 'dart:io';

import 'package:path_provider/path_provider.dart';

class AudioFileHelper {
  AudioFileHelper._();

  static String fileNameFromUrl(String remoteUrl) {
    final uri = Uri.parse(remoteUrl);
    final last = uri.pathSegments.isNotEmpty ? uri.pathSegments.last : null;
    return (last != null && last.isNotEmpty) ? last : '${remoteUrl.hashCode}.mp4';
  }

  static Future<String> getLocalFilePath(String remoteUrl) async {
    final dir = await getApplicationDocumentsDirectory();
    final downloadsDir = Directory('${dir.path}/shakha_pustika_downloads');
    if (!await downloadsDir.exists()) {
      await downloadsDir.create(recursive: true);
    }
    return '${downloadsDir.path}/${fileNameFromUrl(remoteUrl)}';
  }

  /// Returns true only if [remoteUrl] is non-empty AND a local copy
  /// already exists on disk.
  static Future<bool> isDownloaded(String remoteUrl) async {
    if (remoteUrl.isEmpty) return false;
    final path = await getLocalFilePath(remoteUrl);
    return File(path).exists();
  }
}
