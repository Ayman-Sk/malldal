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
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

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
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: AppColors.primary,
      systemNavigationBarDividerColor: Colors.white));
  String token = CachHelper.getData(key: 'token');

  runApp(MyApp(token));
}

class MyApp extends StatelessWidget {
  final String token;
  MyApp(this.token);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserProvider>(create: (_) => UserProvider()),
        ChangeNotifierProvider<SellerProvider>(create: (_) => SellerProvider()),
        ChangeNotifierProvider<LocaleProvider>(create: (_) => LocaleProvider()),
        ChangeNotifierProvider<ThemeProvider>(create: (_) => ThemeProvider()),
        ChangeNotifierProvider<PostRequestProvider>(
            create: (_) => PostRequestProvider()),
        ChangeNotifierProvider<AddsProvider>(create: (_) => AddsProvider()),
        ChangeNotifierProvider<AllPostsWithCategories>(
            create: (_) => AllPostsWithCategories()),
      ],
      child: MainContoller(token: token),
    );
  }
}
