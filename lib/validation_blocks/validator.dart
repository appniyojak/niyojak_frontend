import 'dart:async';

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
