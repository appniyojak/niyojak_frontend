import 'dart:async';

Future<bool> isValidUrl(String text) async {
  if (text.isEmpty) return false;

  final Uri? uri = Uri.tryParse(text);

  // A valid URI must be non-null and have a host
  if (uri == null || uri.host.isEmpty) {
    return false;
  }

  // You can add more checks here, e.g., for schemes
  return uri.isAbsolute;
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
