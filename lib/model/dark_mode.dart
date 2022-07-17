import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  primaryColor: Color(0xFF64B5F6),
  primaryColorLight: Color(0xFF64B5F6),
  primaryColorDark: Color(0xFF106A8D),
  scaffoldBackgroundColor: Color(0xfff7f7f7),
  backgroundColor: Color(0xfff7f7f7),
  appBarTheme: AppBarTheme(
    color: Color(0xfff7f7f7),
    iconTheme: IconThemeData(color: Color(0xff0d1117)),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Color(0xfff7f7f7),
    selectedItemColor: Colors.black,
    selectedLabelStyle: TextStyle(color: Colors.black)
  ),
  fontFamily: "Poppins",
  cardColor: Colors.white
);

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Color(0xFF106A8D),
  primaryColorLight: Color(0xFF106A8D),
  primaryColorDark: Color(0xFF64B5F6),
  scaffoldBackgroundColor: Color(0xFF0F181B),
  cardColor: Color(0xFF106A8D),
  backgroundColor: Color(0xFF0F181B),
  appBarTheme: AppBarTheme(
    color: Color(0xFF0F181B),
    iconTheme: IconThemeData(color: Colors.white),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Color(0xFF0F181B),
    selectedItemColor: Colors.white,
    selectedIconTheme: IconThemeData(color: Colors.white),
    unselectedIconTheme: IconThemeData(color: Colors.white),
    selectedLabelStyle: TextStyle(color: Colors.white)
  ),
  fontFamily: "Poppins",
);

class ThemeNotifier extends ChangeNotifier {
  final String key = "theme";
  SharedPreferences _preferences;
  bool _darkMode;

  bool get darkMode => _darkMode;
  
  ThemeNotifier() {
    _darkMode = false;
    _loadFromPreferences();
  }

  _initialPreferences() async {
    if(_preferences == null)
      _preferences = await SharedPreferences.getInstance();
  }

  _savePreferences()async {
    await _initialPreferences();
    _preferences.setBool(key, _darkMode);
  }

  _loadFromPreferences() async {
    await _initialPreferences();
    _darkMode = _preferences.getBool(key) ?? false;
    notifyListeners();
  }

  toggleChangeTheme() {
    _darkMode = !_darkMode;
    _savePreferences();
    notifyListeners();
  }
}