import 'dart:convert';

import 'package:dal/data_layer/models/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CachHelper {
  static SharedPreferences _pref;
  static init() async {
    _pref = await SharedPreferences.getInstance();
  }

  static Future<bool> saveData({
    @required String key,
    @required dynamic value,
  }) async {
    if (value is String) return await _pref.setString(key, value);
    if (value is int) return await _pref.setInt(key, value);
    if (value is bool) return await _pref.setBool(key, value);
    // if(value is Map<String,dynamic>) return await _pref.setString('user', jsonEncode(value));
    if (value is MyUser)
      return await _pref.setString(key, json.encode(value.toJson()));
    // if (value is CitiesImp ||
    //     value is CategoriesImp ||
    //     value is MalkansImp ||
    //     value is AllCarsImp ||
    //     value is AllPropertiesImp)
    //   return await _pref.setString(key, json.encode(value));
    return await _pref.setDouble(key, value);
  }

  static dynamic getData({@required String key}) {
    return _pref.get(key);
  }

  static getObjectFromCash(String key) async {
    return json.decode(_pref.getString(key));
  }

  static Future<bool> removeData({@required String key}) async {
    return await _pref.remove(key);
  }
}
