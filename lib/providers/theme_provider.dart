import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode; 

  void cambioDeTema() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

}