import 'package:flutter/material.dart';

import '../models/response_model/sadbhav_center_list_resp_model.dart';

class SadbhavProvider extends ChangeNotifier {
  ///Setters
  bool _isLoading = false;

  SadbhavCenter? _selectedSadbhav = SadbhavCenter();

  ///Getters
  bool get isLoading => _isLoading;

  SadbhavCenter? get selectedSadbhav => _selectedSadbhav;

  clearData() {
    _selectedSadbhav = null;
    notifyListeners();
  }

  ///
  updateSadbhavVal(SadbhavCenter? data) {
    _selectedSadbhav = data;
    notifyListeners();
  }

  set setSadbhav(SadbhavCenter? value) {
    _selectedSadbhav = value;
    notifyListeners();
  }
}
