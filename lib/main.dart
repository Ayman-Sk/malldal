import 'package:dal/business_logic_layer/adds_provider.dart';
import 'package:dal/business_logic_layer/all_posts_with_categories.dart';
import 'package:dal/business_logic_layer/local_provider.dart';
import 'package:dal/business_logic_layer/post_request_provider.dart';
import 'package:dal/business_logic_layer/seller_provider.dart';
import 'package:dal/main_controll.dart';
import 'package:dal/network/dio_helper.dart';
import 'package:dal/business_logic_layer/user_provider.dart';
import 'package:dal/network/local_host.dart';
import 'package:dal/theme/app_colors.dart';
import 'package:dal/theme/my_theme_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel',
  'High Importance Notifications',
  description: 'This Channel is used for important notification',
  importance: Importance.high,
  playSound: true,
);
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> backgroundHandler(RemoteMessage message) async {
  print(message.data.toString());
  print(message.notification.title);
}

Future<void> main() async {
  Provider.debugCheckInvalidValueType = null;
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);

  await CachHelper.init();
  DioHelper.init();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: AppColors.primary, systemNavigationBarDividerColor: Colors.white));

  // var tokenn =
  //     'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOlwvXC9kYWwuY2hpLXRlYW0uY29tXC9hcGlcL2F1dGgiLCJpYXQiOjE2NDQwMTk5ODAsImV4cCI6MTY0NDAyMzU4MCwibmJmIjoxNjQ0MDE5OTgwLCJqdGkiOiJxR0dxRzRWT2F3bXZEMU1EIiwic3ViIjozOCwicHJ2IjoiMjNiZDVjODk0OWY2MDBhZGIzOWU3MDFjNDAwODcyZGI3YTU5NzZmNyJ9.81DvxyWwFkvkdwTeADOUbiLpIhdEV1ueKLUXp51eqLE';
  // CachHelper.removeData(key: 'user');
  // CachHelper.removeData(key: 'token');
  String token = CachHelper.getData(key: 'token');

  runApp(MyApp(token));
}

// List<String> im = [
//   'img/test.jpg',
//   'img/test.jpg',
//   'img/test.jpg',
//   'img/test.jpg',
// ];

class MyApp extends StatelessWidget {
  final String token;
  MyApp(this.token);

  @override
  Widget build(BuildContext context) {
    // final provider = Provider.of<LocaleProvider>(context);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserProvider>(create: (_) => UserProvider()),
        ChangeNotifierProvider<SellerProvider>(create: (_) => SellerProvider()),
        ChangeNotifierProvider<LocaleProvider>(create: (_) => LocaleProvider()),
        ChangeNotifierProvider<ThemeProvider>(create: (_) => ThemeProvider()),
        // ChangeNotifierProvider<UserProvider>(create: (_) => UserProvider()),
        // ChangeNotifierProvider<PostsProvider>(create: (_) => PostsProvider()),
        ChangeNotifierProvider<PostRequestProvider>(create: (_) => PostRequestProvider()),
        ChangeNotifierProvider<AddsProvider>(create: (_) => AddsProvider()),
        ChangeNotifierProvider<AllPostsWithCategories>(create: (_) => AllPostsWithCategories()),
      ],
      child: MainContoller(token: token),
      // child: MaterialApp(
      //   // locale: Provider.of<LocaleProvider>(context, listen: false).locale,
      //   supportedLocales: L10n.all,
      //   localizationsDelegates: [
      //     AppLocalizations.delegate,
      //     GlobalMaterialLocalizations.delegate,
      //     GlobalWidgetsLocalizations.delegate,
      //   ],
      //   debugShowCheckedModeBanner: true,
      //   title: 'dal',
      //   theme: ThemeData(
      //     fontFamily: 'QTNOWTitle',
      //   ),
      //   // home: CustomerProfileScreen(),
      //   home: token == null ? IntroductionScreen() : MainTabBarViewController(),
      //   // home:IntroductionScreen(),
      //   routes: {
      //     'MainTabBarViewController': (context) => MainTabBarViewController(),
      //     'IntroductionScreen': (context) => IntroductionScreen(),
      //     'SellerSignupScreens': (context) => SellerSignupScreens(),
      //     'SellerProfileScreen': (context) => SellerProfileScreen(),
      //     'CustomerSignupScreens': (context) => CustomerSignupScreens(),
      //     'CustomerProfileScreen': (context) => CustomerProfileScreen(),
      //     'SellerPostScreen': (context) => SellerPostScreen(),
      //     'CustomerLoginScreen': (context) => LoginCardScreen(),
      //     'LoginCardScreen': (context) => LoginCardScreen(),
      //     'EditCustomerProfileScreen': (context) => EditCustomerProfileScreen(),
      //     'EditSellerProfileScreen': (context) => EditSellerProfileScreen(),
      //     'SettingsScreen': (context) => SettingsScreen(),
      //     'AddPostScreen': (context) => AddPostScreen(),
      //     'SellerAccountScreen': (context) => SellerAccountScreen(),
      //     'OverviewSellerProfileScreen': (context) =>
      //         OverviewSellerProfileScreen(),
      //     'FilterScreen': (context) => FilterScreen(),
      //   },
      // ),
    );
  }
}
