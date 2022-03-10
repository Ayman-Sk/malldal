import 'package:dal/network/local_host.dart';
import 'package:dal/screens/autharization/login_card_screen.dart';
// import 'package:dal/screens/customer_profile_screen.dart';
import 'package:dal/screens/homescreen_with_tabbar_view_controller.dart';
import 'package:dal/screens/settings_screen.dart';
import 'package:dal/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:url_launcher/url_launcher.dart';

class MyDrawer extends StatefulWidget {
  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  _launchURL() async {
    const url = 'https://www.facebook.com/chi.team.dev';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            // decoration: BoxDecoration(
            //   borderRadius: BorderRadius.circular(30),
            //   color: Color(0xffc59e51),
            // ),
            child: Center(
              child: Column(
                children: [
                  Expanded(
                    flex: 2,
                    child: Image.asset(
                      'img/logo.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Center(
                      child: Text(
                        AppLocalizations.of(context).dalPhrase,
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          SizedBox(height: 30),
          GestureDetector(
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(MainTabBarViewController.routeName);
            },
            child: Center(
              child: Container(
                child: Text(
                  AppLocalizations.of(context).homePageScreen,
                  // 'الصفحة الرئيسية',
                  style: TextStyle(
                    // color: AppColors.primary,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 15),
          Divider(
            color: Colors.grey,
            height: 0.2,
          ),
          SizedBox(height: 15),
          // GestureDetector(
          //   onTap: () {
          //     Navigator.of(context)
          //         .pushReplacementNamed(CustomerProfileScreen.routeName);
          //   },
          //   child: Center(
          //     child: Container(
          //       child: Text(
          //         'الملف الشخصي',
          //         style: TextStyle(color: AppColors.primary, fontSize: 20),
          //       ),
          //     ),
          //   ),
          // ),
          // SizedBox(height: 30),
          CachHelper.getData(key: 'userId') != null
              ? Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context)
                            .pushReplacementNamed(LoginCardScreen.routeName);
                      },
                      child: GestureDetector(
                        onTap: () async {
                          CachHelper.removeData(key: 'token');
                          CachHelper.removeData(key: 'user');
                          CachHelper.removeData(key: 'userId');
                          CachHelper.removeData(key: 'posts');

                          await _deleteCacheDir();
                          await _deleteAppDir();
                          Navigator.of(context)
                              .pushReplacementNamed(LoginCardScreen.routeName);
                        },
                        child: Center(
                          child: Container(
                            child: Text(
                              AppLocalizations.of(context).logout,
                              // 'تسجيل الخروج',
                              style: TextStyle(
                                // color: AppColors.primary,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    Divider(color: Colors.grey, height: 0.8),
                    SizedBox(height: 15),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context)
                            .pushNamed(SettingsScreen.routeName);
                      },
                      child: Center(
                        child: Container(
                          child: Text(
                            AppLocalizations.of(context).setting,
                            // 'إعدادات التطبيق',
                            style: TextStyle(
                              // color: AppColors.primary,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    Divider(
                      color: Colors.grey,
                      height: 1.4,
                    ),
                    SizedBox(height: 15),
                  ],
                )
              : GestureDetector(
                  onTap: () {
                    Navigator.of(context)
                        .pushReplacementNamed(LoginCardScreen.routeName);
                  },
                  child: Center(
                    child: Container(
                      child: Text(
                        AppLocalizations.of(context).logIn,
                        // 'تسجيل الدخول',
                        style:
                            TextStyle(color: AppColors.primary, fontSize: 20),
                      ),
                    ),
                  ),
                ),
          // Divider(
          //   height: 30,
          //   color: AppColors.primary,
          //   endIndent: 30,
          //   indent: 30,
          // ),
          // GestureDetector(
          //   onTap: () {
          //     Navigator.of(context)
          //         .pushReplacementNamed(IntroductionScreen.routeName);
          //   },
          //   child: Center(
          //     child: Container(
          //       child: Text(
          //         'الانترو',
          //         style: TextStyle(color: AppColors.primary, fontSize: 20),
          //       ),
          //     ),
          //   ),
          // ),
          // Divider(
          //   height: 30,
          //   color: AppColors.primary,
          //   endIndent: 30,
          //   indent: 30,
          // ),
          // GestureDetector(
          //   onTap: () {
          //     Navigator.of(context)
          //         .pushReplacementNamed(SellerSignupScreens.routeName);
          //   },
          //   child: Center(
          //     child: Container(
          //       child: Text(
          //         'صفحة تسجيل البائع',
          //         style: TextStyle(color: AppColors.primary, fontSize: 20),
          //       ),
          //     ),
          //   ),
          // ),
          // Divider(
          //   height: 30,
          //   color: AppColors.primary,
          //   endIndent: 30,
          //   indent: 30,
          // ),
          // GestureDetector(
          //   onTap: () {
          //     Navigator.of(context)
          //         .pushReplacementNamed(CustomerSignupScreens.routeName);
          //   },
          //   child: Center(
          //     child: Container(
          //       child: Text(
          //         'صفحة تسجيل الزبون',
          //         style: TextStyle(color: AppColors.primary, fontSize: 20),
          //       ),
          //     ),
          //   ),
          // ),
          // Divider(
          //   height: 30,
          //   color: AppColors.primary,
          //   endIndent: 30,
          //   indent: 30,
          // ),
          // GestureDetector(
          //   onTap: () {
          //     Navigator.of(context)
          //         .pushReplacementNamed(SellerProfileScreen.routeName);
          //   },
          //   child: Center(
          //     child: Container(
          //       child: Text(
          //         'صفحة بروفايل البائع',
          //         style: TextStyle(color: AppColors.primary, fontSize: 20),
          //       ),
          //     ),
          //   ),
          // ),
          // Divider(
          //   height: 30,
          //   color: AppColors.primary,
          //   endIndent: 30,
          //   indent: 30,
          // ),
          // GestureDetector(
          //   onTap: () {
          //     Navigator.of(context)
          //         .pushReplacementNamed(CustomerProfileScreen.routeName);
          //   },
          //   child: Center(
          //     child: Container(
          //       child: Text(
          //         'صفحة بروفايل الزبون',
          //         style: TextStyle(color: AppColors.primary, fontSize: 20),
          //       ),
          //     ),
          //   ),
          // )
          Center(
            child: TextButton(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Powerd by ', style: TextStyle(color: Colors.black)),
                  Text(
                    "CHI",
                    style: TextStyle(color: Color(0XFFF05F23)),
                  )
                ],
              ),
              onPressed: _launchURL,
            ),
          )
        ],
      ),
    );
  }

  // _launchURL() async {
  //   const url = 'https://www.facebook.com/chi.team.dev';
  //   if (await canLaunch(url)) {
  //     await launch(url);
  //   } else {
  //     throw 'Could not launch $url';
  //   }
  // }

  Future<void> _deleteCacheDir() async {
    final cacheDir = await getTemporaryDirectory();

    if (cacheDir.existsSync()) {
      cacheDir.deleteSync(recursive: true);
      print('delete cach memory done');
    }
  }

  Future<void> _deleteAppDir() async {
    final appDir = await getApplicationSupportDirectory();

    if (appDir.existsSync()) {
      appDir.deleteSync(recursive: true);
      print('delete app memory done');
    }
  }
}
