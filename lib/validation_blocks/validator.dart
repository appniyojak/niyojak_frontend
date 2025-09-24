import 'dart:async';

import 'package:url_launcher/url_launcher.dart';

Future<bool> isValidUrl(String text) async {
  if (text.isEmpty) return false;

  final Uri uri = Uri.tryParse(text) ?? Uri();

  // Make sure scheme is included
  if (!uri.hasScheme) {
    return false;
  }

  return await canLaunchUrl(uri);
}

mixin SankalpValidator {
  final validateSankalpYear = StreamTransformer<String, String>.fromHandlers(handleData: (sankalpYear, sink) {
    if (sankalpYear.isEmpty) {
      sink.addError("Enter Sankalp Year");
    } else {
      sink.add(sankalpYear);
    }
  });
  final validateTaalukaa = StreamTransformer<String, String>.fromHandlers(handleData: (taalukaa, sink) {
    if (taalukaa.isNotEmpty) {
      sink.add(taalukaa);
    }
  });

  final validateBhaagName = StreamTransformer<String, String>.fromHandlers(handleData: (bhaagName, sink) {
    if (bhaagName.isEmpty) {
      sink.addError("Enter Bhaag Name");
    } else {
      sink.add(bhaagName);
    }
  });
}
