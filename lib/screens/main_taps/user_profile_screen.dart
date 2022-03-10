import 'package:dal/business_logic_layer/user_provider.dart';
import 'package:dal/screens/customer_profile_screen_v2.dart';
import 'package:dal/screens/seller_account_screen.dart';
import 'package:dal/screens/seller_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../customer_profile_screen.dart';
import '../seller_profile_screen_v2.dart';

class UserProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //  var customerProvider = Provider.of<CustomerProvider>(context);
    // customerProvider.getUserToApp();
    //   String userMode = customerProvider.modeOfUser;
    // return CustomerProfileScreen();
    // var user = CachHelper.getData(key: 'user');

    // return user['userMode'] == 'Customer'
    //     ? CustomerProfileScreen()
    //     :
    var userProvider = Provider.of<UserProvider>(context);
    // userProvider.getUserToApp();
    userProvider.printUser();
    print(userProvider.userMode);
    return userProvider.userMode == 'seller'
        ? SellerAccountScreen()
        : CustomerProfileScreen();
  }
}
