import 'package:flutter/material.dart';
import '../helpers/static_data.dart' as Statics;

class LoaderUtils {
  static bool _isLoaderVisible = false;
  static BuildContext? _context;

  // Function to toggle the loader visibility
  static void toggleLoader(BuildContext context, bool show) {
    if (show) {
      if (!_isLoaderVisible) {
        _isLoaderVisible = true;
        _context = context;
        // Show dialog when loader starts
        showDialog(
          context: context,
          barrierDismissible: false, // Prevent dismissing dialog by tapping outside
          builder: (context) => Stack(
            children: [
              GestureDetector(
                onTap: () {}, // Prevent touch events while loader is visible
                child: Container(
                  color: Colors.black.withOpacity(0.5), // Dim the background
                ),
              ),
              Center(
                child: AlertDialog(
                  content: Row(
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(width: 20),
                      Text(Statics.getLabel('pleaseWait')),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }
    } else {
      if (_isLoaderVisible) {
        _isLoaderVisible = false;
        Navigator.of(context, rootNavigator: true).pop(); // Close dialog
      }
    }
  }

  // Function to handle back button press behavior when loader is visible
  static Future<bool> onWillPop(BuildContext context) async {
    if (_isLoaderVisible) {
      return false; // Prevent back button when loader is visible
    }
    return true; // Allow back button when loader is hidden
  }
}
