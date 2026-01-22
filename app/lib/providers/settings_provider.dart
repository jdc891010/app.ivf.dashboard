import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider with ChangeNotifier {
  bool _enableNotifications = true;
  bool _enableEmailAlerts = true;
  bool _isDarkMode = false;
  String _selectedLanguage = 'English';
  
  // Profile Info
  String _userName = 'Admin User';
  String _userEmail = 'admin@ivfclinic.com';
  String _userPhone = '+1 (555) 000-0000';
  String _userRole = 'Clinic Administrator';

  bool get enableNotifications => _enableNotifications;
  bool get enableEmailAlerts => _enableEmailAlerts;
  bool get isDarkMode => _isDarkMode;
  String get selectedLanguage => _selectedLanguage;
  
  String get userName => _userName;
  String get userEmail => _userEmail;
  String get userPhone => _userPhone;
  String get userRole => _userRole;

  SettingsProvider() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _enableNotifications = prefs.getBool('enableNotifications') ?? true;
    _enableEmailAlerts = prefs.getBool('enableEmailAlerts') ?? true;
    _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    _selectedLanguage = prefs.getString('selectedLanguage') ?? 'English';
    
    _userName = prefs.getString('userName') ?? 'Admin User';
    _userEmail = prefs.getString('userEmail') ?? 'admin@ivfclinic.com';
    _userPhone = prefs.getString('userPhone') ?? '+1 (555) 000-0000';
    _userRole = prefs.getString('userRole') ?? 'Clinic Administrator';
    
    notifyListeners();
  }

  Future<void> setNotifications(bool value) async {
    _enableNotifications = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('enableNotifications', value);
    notifyListeners();
  }

  Future<void> setEmailAlerts(bool value) async {
    _enableEmailAlerts = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('enableEmailAlerts', value);
    notifyListeners();
  }

  Future<void> setDarkMode(bool value) async {
    _isDarkMode = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', value);
    notifyListeners();
  }

  Future<void> setLanguage(String value) async {
    _selectedLanguage = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedLanguage', value);
    notifyListeners();
  }
  
  Future<void> updateProfile({
    required String name,
    required String email,
    required String phone,
    required String role,
  }) async {
    _userName = name;
    _userEmail = email;
    _userPhone = phone;
    _userRole = role;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userName', name);
    await prefs.setString('userEmail', email);
    await prefs.setString('userPhone', phone);
    await prefs.setString('userRole', role);
    
    notifyListeners();
  }
}
