import 'package:flutter/widgets.dart';

class Language with ChangeNotifier {
  static bool isEnglish = false;

  void toggleSwitch(bool value) {
    if (isEnglish == false) {
      isEnglish = true;
      //CachHelper.saveData(key: 'isEnglish', value: true);
      // notifyListeners();
    } else {
      isEnglish = false;
      //achHelper.saveData(key: 'isEnglish', value: false);
      //notifyListeners();
    }
  }

  void setArabic(bool val) {
    isEnglish = val;
    // CachHelper.saveData(key: 'isEnglish', value: val);
    // notifyListeners();
  }
             
   void setEnglish(bool val) {
    isEnglish = val;
    // CachHelper.saveData(key: 'isEnglish', value: val);
    // notifyListeners();
  }

}
