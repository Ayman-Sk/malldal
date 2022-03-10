import 'dart:convert';

import 'package:dal/data_layer/models/user_model.dart';
import 'package:dal/network/local_host.dart';
import 'package:dal/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Utils {
  static void showToast({
    String message,
    Color backgroundColor,
    Color textColor,
  }) =>
      Fluttertoast.showToast(
          msg: message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.SNACKBAR,
          timeInSecForIosWeb: 1,
          backgroundColor: backgroundColor,
          textColor: textColor,
          fontSize: 16.0);

  static void showSimpleDialog(String message, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(
            color: AppColors.primary,
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  void printUserInfo() {
    dynamic jsonUser = CachHelper.getData(key: 'user');
    MyUser cus = MyUser.fromJson(json.decode(jsonUser));
    print('-->id OfCustomer : ${cus.id}\n');
    print('-->name OfCustomer : ${cus.name}\n');
    print('-->gender OfCustomer : ${cus.gender}\n');
    print('-->cityId OfCustomer : ${cus.cityId}\n');
    print('-->profileImage OfCustomer : ${cus.profileImage}\n');
    print('-->Number OfCustomer : ${cus.phoneNumber}\n');
  }
}
