import 'package:dal/screens/category_posts_screen.dart';
import 'package:dal/screens/customer_profile_screen_v2.dart';
import 'package:dal/screens/otp_screen.dart';
import 'package:dal/screens/seller_profile_screen_v2.dart';
import 'package:dal/screens/tester.dart';
import 'package:flutter/material.dart';
import 'package:dal/business_logic_layer/local_provider.dart';
import 'package:dal/screens/add_post_screen.dart';
import 'package:dal/screens/customer_profile_screen.dart';
import 'package:dal/screens/edit_customer_profile.dart';
import 'package:dal/screens/edit_seller_profile.dart';
import 'package:dal/screens/filter_screen.dart';
// import 'package:dal/screens/customer_profile_screen.dart';
import 'package:dal/screens/homescreen_with_tabbar_view_controller.dart';
import 'package:dal/screens/introduction_screen.dart';
import 'package:dal/screens/autharization/login_card_screen.dart';
import 'package:dal/screens/autharization/customer_signup_screen.dart';
// import 'package:dal/screens/registration_for_seller/seller_signup_steps/seller_signup_screens.dart';
import 'package:dal/screens/seller_account_screen.dart';
import 'package:dal/screens/seller_posts_screen.dart';
import 'package:dal/screens/seller_profile_screen.dart';
import 'package:dal/screens/settings_screen.dart';
import 'package:provider/provider.dart';

import 'L10N/l10n.dart';
import 'screens/overview_seller_profile_Screen.dart';
// import 'package:localization/src/localization_extension.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import './theme/my_theme_provider.dart';

class MainContoller extends StatefulWidget {
  const MainContoller({Key key, this.token}) : super(key: key);
  final String token;
  // MainContoller(this.token);

  @override
  State<MainContoller> createState() => _MainContollerState();
}

class _MainContollerState extends State<MainContoller>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached) return;
    final isBackground = state == AppLifecycleState.paused;
    if (isBackground) {
      print('fsjkfsdgirhgre');
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      themeMode: themeProvider.themeMode,
      theme: MyThemes.lightTheme, //ThemeData(fontFamily: 'QTNOWTitle'),
      darkTheme: MyThemes.darkTheme,
      locale: Provider.of<LocaleProvider>(context).locale,
      supportedLocales: L10n.all,
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      debugShowCheckedModeBanner: true,
      title: 'dal',

      // home: CustomerProfileScreen(),
      home:
          // tester(),
          widget.token == null
              ? IntroductionScreen()
              : MainTabBarViewController(),
      //  SplashScreen(),
      //     AnimatedSplashScreen(
      //   duration: 10000,

      //   splash: SplashScreen(), //Image.asset('img/logo.jpg'),
      //   nextScreen: widget.token == null
      //       ? IntroductionScreen()
      //       : MainTabBarViewController(),
      // ),

      // home:IntroductionScreen(),
      routes: {
        'MainTabBarViewController': (context) => MainTabBarViewController(),
        'IntroductionScreen': (context) => IntroductionScreen(),
        'SellerProfileScreen': (context) => SellerProfileScreen(),
        'CustomerSignupScreens': (context) => CustomerSignupScreens(),
        'CustomerProfileScreen': (context) => CustomerProfileScreen(),
        'SellerPostScreen': (context) => SellerPostScreen(),
        'CustomerLoginScreen': (context) => LoginCardScreen(),
        'LoginCardScreen': (context) => LoginCardScreen(),
        'EditCustomerProfileScreen': (context) => EditCustomerProfileScreen(),
        'EditSellerProfileScreen': (context) => EditSellerProfileScreen(),
        'SettingsScreen': (context) => SettingsScreen(),
        'AddPostScreen': (context) => AddPostScreen(),
        'SellerAccountScreen': (context) => SellerAccountScreen(),
        'OverviewSellerProfileScreen': (context) =>
            OverviewSellerProfileScreen(),
        'FilterScreen': (context) => FilterScreen(),
        'OtpScreen': (context) => OtpScreen(),
        'CustomerProfileScreenV2': (context) => CustomerProfileScreenV2(),
        'SellerProfileScreenV2': (context) => SellerProfileScreenV2(),
        'CategoryPostsScreen': (context) => CategoryPostsScreen()
      },
    );
  }
}
