// import 'dart:html';
import 'package:dal/screens/category_posts_screen.dart';
import 'package:dal/screens/customer_seller_follower.dart';
import 'package:dal/screens/edit_post_screen.dart';
import 'package:dal/screens/main_taps/user_profile_screen.dart';
import 'package:dal/screens/otp_screen.dart';
import 'package:dal/screens/splash_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:dal/business_logic_layer/local_provider.dart';
import 'package:dal/screens/add_post_screen.dart';
import 'package:dal/screens/customer_profile_screen.dart';
import 'package:dal/screens/edit_customer_profile.dart';
import 'package:dal/screens/edit_seller_profile.dart';
import 'package:dal/screens/filter_screen.dart';
import 'package:dal/screens/homescreen_with_tabbar_view_controller.dart';
import 'package:dal/screens/introduction_screen.dart';
import 'package:dal/screens/autharization/login_card_screen.dart';
import 'package:dal/screens/autharization/customer_signup_screen.dart';
import 'package:dal/screens/seller_account_screen.dart';
import 'package:dal/screens/seller_posts_screen.dart';
import 'package:dal/screens/seller_profile_screen.dart';
import 'package:dal/screens/settings_screen.dart';
import 'package:provider/provider.dart';
import 'L10N/l10n.dart';
import 'Services/loacl_notification_service.dart';
import 'screens/overview_seller_profile_Screen.dart';
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
    LocalNotificationService.initialize(context);

    //gives you the message on which user taps and it opend the app from terminated state
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        final routeFromMessage = message.data['route'];
        print(routeFromMessage);
      }
    });

    //When App is in forground
    FirebaseMessaging.onMessage.listen((message) {
      if (message.notification != null) {
        print(message.notification.body);
        print(message.notification.title);
        LocalNotificationService.display(message);
      }
    });
    //When App is in Background but running
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      final routeFromMessage = message.data['route'];
      print(routeFromMessage);
    });
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
      home: Scaffold(
        body: SplashScreen(),
      ),

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
        'CategoryPostsScreen': (context) => CategoryPostsScreen(),
        'CustomerSellerFollower': (context) => CustomerSellerFollower(),
        'UserProfileScreenRoute': (context) => UserProfileScreen(),
        'EditPostScreen': (context) => EditPostScreen(),
      },
    );
  }
}
