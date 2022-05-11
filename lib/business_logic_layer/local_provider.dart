import "package:flutter/material.dart";

class LocaleProvider extends ChangeNotifier {
  Locale _locale = Locale('ar');

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

  Locale get locale => _locale;
}
