import 'package:flutter/material.dart';

class CircularProgressDialog {
  static bool _dialogIsOpen = false;

  static void showProgressDialog(BuildContext context, {bool barrierDismissible = false}) {
    if (_dialogIsOpen) return;
    _dialogIsOpen = true;

    showDialog(
      barrierDismissible: barrierDismissible,
      context: context, // Use passed context
      builder: (context) {
        return ProgressDialogWidget();
      },
    );
  }

  static void close(BuildContext context) {
    if (_dialogIsOpen) {
      Navigator.of(context).pop();
      _dialogIsOpen = false;
    }
  }
}

class ProgressDialogWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: CircularProgressIndicator(
            strokeWidth: 5.0,
            color: Colors.teal,
          ),
        ),
      ),
    );
  }
}
