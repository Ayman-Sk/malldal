import 'package:dal/business_logic_layer/user_provider.dart';
import 'package:dal/screens/autharization/login_card_screen.dart';
import 'package:dal/screens/homescreen_with_tabbar_view_controller.dart';
import 'package:dal/screens/autharization/customer_signup_screen.dart';
import 'package:dal/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

class IntroductionScreen extends StatefulWidget {
  static const routeName = 'IntroductionScreen';
  @override
  _IntroductionScreenState createState() => _IntroductionScreenState();
}

class _IntroductionScreenState extends State<IntroductionScreen> {
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
    var userProvider = Provider.of<UserProvider>(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.primary,
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 1,
                child: Center(
                  child: Text(
                    AppLocalizations.of(context).letStart,
                    // "هيا بنا نبدأ",
                    style: TextStyle(
                        fontSize: 30,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Center(
                  child: Container(
                    width: 300,
                    height: 300,
                    child: Image.asset("img/gs-01.png"),
                  ),
                ),
              ),
              /////
              Expanded(
                flex: 4,
                child: Column(
                  children: [
                    Text(
                      AppLocalizations.of(context).introTitle,
                      // "خطوات بسيطة تفصلك عن رؤية اخر المنتجات المنزلية الصنع او عرض منتجاتك الشخصية كل ذلك عبر تطبيق دال .",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        // fontWeight: FontWeight.w200,
                        height: 2,
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                flex: 2,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20.0),
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).pushReplacementNamed(
                                  CustomerSignupScreens.routeName);
                            },
                            child: Container(
                              alignment: Alignment.center,
                              width: 130,
                              height: 50,
                              color: Colors.white,
                              child: Text(
                                AppLocalizations.of(context).signup,
                                // "إنشاء حساب عميل",
                                style: TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15),
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Padding(
                      //   padding: EdgeInsets.all(8.0),
                      //   child: ClipRRect(
                      //     borderRadius: BorderRadius.circular(20.0),
                      //     child: InkWell(
                      //       onTap: () {
                      //         Navigator.of(context).pushReplacementNamed(
                      //             SellerSignupScreens.routeName);
                      //       },
                      //       child: Container(
                      //         alignment: Alignment.center,
                      //         width: 130,
                      //         height: 50,
                      //         color: Colors.white,
                      //         child: Directionality(
                      //           textDirection: TextDirection.rtl,
                      //           child: Text(
                      //             "إنشاء حساب بائع",
                      //             style: TextStyle(
                      //                 color: AppColors.primary,
                      //                 fontWeight: FontWeight.bold,
                      //                 fontSize: 15),
                      //           ),
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      ////
                      Padding(
                        padding: EdgeInsets.only(top: 16),
                        child: GestureDetector(
                          onTap: () {
                            // Provider.of<UserProvider>(context, listen: false)
                            //     .setRegisteredFalse();
                            Navigator.of(context).pushNamed(
                              MainTabBarViewController.routeName,
                            );
                          },
                          child: Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Center(
                                  child: GestureDetector(
                                    onTap: () {
                                      userProvider.setUserMode('');
                                      Navigator.of(context).pushNamed(
                                        MainTabBarViewController.routeName,
                                      );
                                    },
                                    child: Text(
                                      AppLocalizations.of(context).guest,
                                      // "تصفح بدون حساب",
                                      style: TextStyle(
                                        // color: AppColors.background,
                                        // fontWeight: FontWeight.w200,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              ////
                              Expanded(
                                flex: 1,
                                child: Center(
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.of(context)
                                          .pushReplacementNamed(
                                        LoginCardScreen.routeName,
                                      );
                                    },
                                    child: Text(
                                      AppLocalizations.of(context).logIn,
                                      // 'لدي حساب',
                                      style: TextStyle(
                                        // color: AppColors.background,
                                        // fontWeight: FontWeight.w200,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
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
        ),
      ),
    );
  }
}
