import 'package:dal/business_logic_layer/user_provider.dart';
import 'package:dal/screens/autharization/login_card_screen.dart';
import 'package:dal/screens/homescreen_with_tabbar_view_controller.dart';
import 'package:dal/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:intl/intl.dart' as intl;
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data_layer/models/facebook_user.dart';
import '../utils/utils.dart';

class IntroductionScreen extends StatefulWidget {
  static const routeName = 'IntroductionScreen';
  @override
  _IntroductionScreenState createState() => _IntroductionScreenState();
}

class _IntroductionScreenState extends State<IntroductionScreen> {
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.primary,
        body: Container(
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
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
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height / 6),

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
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width / 40,
                      ),
                      child: Text(
                        AppLocalizations.of(context).introTitle,
                        // "خطوات بسيطة تفصلك عن رؤية اخر المنتجات المنزلية الصنع او عرض منتجاتك الشخصية كل ذلك عبر تطبيق دال .",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          // fontWeight: FontWeight.w200,
                          height: 2,
                        ),
                      ),
                    ),
                  ),

                  Expanded(
                    flex: 3,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height / 28,
                            child: loading
                                ? CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  )
                                : SizedBox(),
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20.0),
                                    child: _buildLoginButton(
                                      AppLocalizations.of(context)
                                          .loginAsSeller,
                                      LoginCardScreen.routeName,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20.0),
                                    child: _buildFacebookLoginButton(
                                      AppLocalizations.of(context)
                                          .loginAsCustomer,
                                    ),
                                  ),
                                ),
                              ]),
                          SizedBox(
                              height: MediaQuery.of(context).size.height / 50),
                          Center(
                            child: GestureDetector(
                              onTap: () {
                                userProvider.setUserMode('');
                                Navigator.of(context).pushReplacementNamed(
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
                        ],
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Center(
                        child: TextButton(
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Directionality(
                              textDirection: TextDirection.ltr,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text('Powerd by ',
                                      style: TextStyle(color: Colors.black)),
                                  Text("CHI",
                                      style:
                                          TextStyle(color: Color(0XFFF05F23)))
                                ],
                              ),
                            ),
                          ),
                          onPressed: () => _launchURL(),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFacebookLoginButton(String label) {
    FacebookUser facebookUser = FacebookUser();

    intl.DateFormat
        // dateFormat =
        // DateFormat(
        //     "yyyy-MM-dd HH:mm:ss");
        dateFormat = intl.DateFormat("yyyy-MM-dd");
    AccessToken accessToken;
    return InkWell(
      onTap: () {
        FacebookAuth.instance.login(permissions: [
          'email',
          'public_profile',
          // "user_birthday",
          // "user_gender",
          // "user_link",
          // "user_photos",
          // 'pages_user_gender'
        ], loginBehavior: LoginBehavior.webOnly).then((value) async {
          // LoginResult()

          print('facebook result');
          print(value.message);
          print(value.runtimeType);

          if (value.status == LoginStatus.success) {
            // you are logged

            accessToken = value.accessToken;

            print(dateFormat.format(accessToken.expires));
            facebookUser.setCustomerSessionExpirationDate(
                dateFormat.format(accessToken.expires));

            // Name email id , image ,yyyy-MM-dd ,
            print('access Token ${accessToken.token}');
            print(accessToken.token);
            print('expires');
            print(accessToken.expires);
            print(dateFormat.format(
                accessToken.expires)); //Converting DateTime object to String

            print(accessToken.runtimeType);
          } else {
            print(value);
            print(value.status);
            print(value.message);
          }
          FacebookAuth.instance.getUserData().then(
            (userData) {
              setState(
                () {
                  // _isLoggedIn =
                  //     true;
                  // _usrObj = userData;
                  facebookUser.setFacebookId(userData['id']);
                  facebookUser.setName(userData['name']);
                  facebookUser.setEamil(userData['email']);
                  facebookUser
                      .setProfileImage(userData['picture']['data']['url']);

                  // facebookUser = FacebookUser(
                  //     facebookId:
                  //         userData[
                  //             'id'],
                  //     name: userData[
                  //         'name'],
                  //     email: userData[
                  //         'email'],
                  //     profileImage:
                  //         userData['picture']['data']
                  //             [
                  //             'url']);

                  print('facebook usr data');
                  print(userData);
                  FacebookAuth.instance.getUserData(fields: 'gender').then(
                    (value) async {
                      print('ge');
                      print(value.toString());
                      print('sss');
                      print(value.runtimeType);
                      print('gender');

                      print(facebookUser.toJson().runtimeType);

                      var res = await _facebookSubmit(
                        userData['id'],
                        userData['name'],
                        userData['email'],
                        userData['picture']['data']['url'],
                        dateFormat.format(accessToken.expires),
                      );
                      if (res) {
                        Utils.showToast(
                          message: AppLocalizations.of(context).logedin,
                          // 'أنت الان مسجل في التطبيق',
                          backgroundColor: AppColors.primary,
                          textColor:
                              Theme.of(context).textTheme.bodyText1.color,
                        );
                        // var myUser = Provider.of<CustomerProvider>(context,listen: false).user;
                        //   CachHelper.saveData(
                        //         key: 'user', value: myUser,);

                        Navigator.of(context).pushReplacementNamed(
                          // OtpScreen.routeName
                          MainTabBarViewController.routeName,
                        );

                        // if (_authMode == AuthMode.Login) {

                        //   Navigator.of(context)
                        //       .pushReplacementNamed(
                        //           HomePageScreen.routeName);
                        // }

                      } else {
                        Utils.showToast(
                          message: AppLocalizations.of(context).loginRefused,
                          // 'تعذرت عملية التسجيل',
                          backgroundColor: AppColors.primary,
                          textColor:
                              Theme.of(context).textTheme.bodyText1.color,
                        );
                        setState(() {
                          loading = false;
                        });
                      }
                    },
                  );
                },
              );
            },
          );
        });
      },
      child: Container(
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width / 2.5,
        height: 50,
        color: Colors.white,
        child: FittedBox(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              label,
              style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 15),
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _facebookSubmit(
    String facebookId,
    String name,
    String email,
    String profileImage,
    String customerSessionExpirationDate,
  ) async {
    setState(() {
      loading = true;
    });
    Map<String, String> facebookData = {
      'facebook_id': facebookId,
      'name': name,
      'email': email,
      'profile_image': profileImage,
      'customer_session_expiration_date': customerSessionExpirationDate
    };
    // _formkey.currentState.save();
    return await Provider.of<UserProvider>(context, listen: false)
        .facebookLogin(facebookData);
  }

  Widget _buildLoginButton(String label, String route) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(route);
      },
      child: Container(
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width / 2.5,
        height: 50,
        color: Colors.white,
        child: FittedBox(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              label,
              style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 15),
            ),
          ),
        ),
      ),
    );
  }

  _launchURL() async {
    const url = 'https://chi-team.com/';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
