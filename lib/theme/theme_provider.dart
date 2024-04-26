import 'package:flutter/material.dart';
import 'package:habittracker/theme/dark_mode.dart';
import 'package:habittracker/theme/light_mode.dart';

class ThemeProvider extends ChangeNotifier{
  ThemeData _themeData = lightMode;
  ThemeData get themeData => _themeData;

  bool get isDarkMode => _themeData == darkMode;

  set themeData(ThemeData themeData){
    _themeData = themeData;
    notifyListeners();
  }

  void toggleTheme(){
    if(_themeData == lightMode){
      _themeData = darkMode;
    }else{
      _themeData = lightMode;
    }
    notifyListeners();
  }
}