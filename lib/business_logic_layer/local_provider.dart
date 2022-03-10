import "package:flutter/material.dart";

class LocaleProvider extends ChangeNotifier {
  Locale _locale;

  Map<String, String> _langCode = {"en": "English", "ar": "العربية"};

  void setLocale(Locale locale) {
    _locale = locale;
    notifyListeners();
  }

  void clearLocal() {
    _locale = null;
    notifyListeners();
  }

  String getLanguage(String code) {
    return _langCode[code];
  }

  // Map<String, String> get getLanguage => _langCode;
  Locale get locale => _locale;
}
