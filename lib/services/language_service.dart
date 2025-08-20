import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageService extends ChangeNotifier {
  static const String _appLanguageKey = 'app_language';
  static const String _pdfLanguageKey = 'pdf_language';
  
  Locale _appLocale = const Locale('en');
  Locale _pdfLocale = const Locale('en');
  
  Locale get appLocale => _appLocale;
  Locale get pdfLocale => _pdfLocale;
  
  // Supported locales
  static const List<Locale> supportedLocales = [
    Locale('en'), // English
    Locale('es'), // Spanish
    Locale('tr'), // Turkish
  ];
  
  // Language names for UI
  static const Map<String, String> languageNames = {
    'en': 'English',
    'es': 'Español',
    'tr': 'Türkçe',
  };
  
  LanguageService() {
    _loadSettings();
  }
  
  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    
    final appLanguage = prefs.getString(_appLanguageKey) ?? 'en';
    final pdfLanguage = prefs.getString(_pdfLanguageKey) ?? 'en';
    
    _appLocale = Locale(appLanguage);
    _pdfLocale = Locale(pdfLanguage);
    
    notifyListeners();
  }
  
  Future<void> setAppLanguage(String languageCode) async {
    if (!supportedLocales.any((locale) => locale.languageCode == languageCode)) {
      return;
    }
    
    _appLocale = Locale(languageCode);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_appLanguageKey, languageCode);
    
    notifyListeners();
  }
  
  Future<void> setPdfLanguage(String languageCode) async {
    if (!supportedLocales.any((locale) => locale.languageCode == languageCode)) {
      return;
    }
    
    _pdfLocale = Locale(languageCode);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_pdfLanguageKey, languageCode);
    
    notifyListeners();
  }
  
  String getLanguageName(String languageCode) {
    return languageNames[languageCode] ?? languageCode;
  }
  
  List<MapEntry<String, String>> getLanguageOptions() {
    return languageNames.entries.toList();
  }
}
