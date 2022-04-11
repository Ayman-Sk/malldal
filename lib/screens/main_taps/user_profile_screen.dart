import 'package:dal/business_logic_layer/user_provider.dart';
import 'package:dal/screens/customer_account_screen.dart';
import 'package:dal/screens/customer_profile_screen.dart';
import 'package:dal/screens/seller_account_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../seller_profile_screen.dart';

class UserProfileScreen extends StatelessWidget {
  static const routeName = 'UserProfileScreenRoute';

  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context);
    userProvider.printUser();
    print(userProvider.userMode);
    return userProvider.userMode == 'seller'
        ? SellerProfileScreen()
        : CustomerProfileScreen();
  }
}
