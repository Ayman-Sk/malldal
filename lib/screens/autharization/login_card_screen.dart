// enum AuthMode { Signup, Login }

import 'package:dal/data_layer/models/facebook_user.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:intl/intl.dart';

import '../../business_logic_layer/user_provider.dart';
import '../../theme/app_colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../utils/utils.dart';
import '../homescreen_with_tabbar_view_controller.dart';
import 'customer_signup_screen.dart';

class LoginCardScreen extends StatefulWidget {
  static const routeName = 'LoginCardScreen';
  const LoginCardScreen({Key key}) : super(key: key);

  @override
  _LoginCardScreenState createState() => _LoginCardScreenState();
}

class _LoginCardScreenState extends State<LoginCardScreen>
    with SingleTickerProviderStateMixin {
  final String svgPath = "assets/svgs/ill1.svg";
  final GlobalKey<FormState> _formkey = GlobalKey();
  bool loading = false;
  final _phonecontroller = TextEditingController();

  FacebookUser facebookUser = FacebookUser();

  bool _isLoading = false;

  bool _isLoggedIn = false;
  Map _usrObj = {
    // 'Pictures': {
    //   'data': {'url': 'sssss'}
    // },
    // 'name': 'Ayman',
    // 'email': 'ayman.sk.290@gmail.com',
  };
  // Image.network(_usrObj['Pictures']
  //                                                 ['data']['url']),
  //                                             Text(_usrObj['name']),
  //                                             Text(_usrObj['email']),
  Future<bool> _submit(String number) async {
    setState(() {
      loading = true;
    });
    if (!_formkey.currentState.validate()) {
      setState(() {
        loading = false;
      });
      return Future.value(false);
    }
    _formkey.currentState.save();
    return await Provider.of<UserProvider>(context, listen: false)
        .login(number);
  }

  // Future<bool> _facebookSubmit(
  //   String facebookId,
  //   String name,
  //   String email,
  //   String profileImage,
  //   String customerSessionExpirationDate,
  // ) async {
  //   setState(() {
  //     loading = true;
  //   });
  //   // if (!_formkey.currentState.validate()) {
  //   //   setState(() {
  //   //     loading = false;
  //   //   });
  //   //   return Future.value(false);
  //   // }
  //   // data['facebook_id'] = facebookId;
  //   // data['name'] = name;
  //   // data['email'] = email;
  //   // data['profile_image'] = profileImage;
  //   // data['customer_session_expiration_date'] =
  //   //     this.customerSessionExpirationDate;
  //   Map<String, String> facebookData = {
  //     'facebook_id': facebookId,
  //     'name': name,
  //     'email': email,
  //     'profile_image': profileImage,
  //     'customer_session_expiration_date': customerSessionExpirationDate
  //   };
  //   // _formkey.currentState.save();
  //   return await Provider.of<UserProvider>(context, listen: false)
  //       .facebookLogin(facebookData);
  // }

  @override
  Widget build(BuildContext context) {
    // final devicesize = MediaQuery.of(context).size;
    // DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
    //     dateFormat = DateFormat("yyyy-MM-dd");
    // AccessToken accessToken;

    final phoneTextFielde = TextFormField(
      controller: _phonecontroller,
      keyboardType: TextInputType.number, cursorColor: AppColors.background,
      decoration: InputDecoration(
        labelText: AppLocalizations.of(context).personlNumber,
        labelStyle: TextStyle(
          color: AppColors.background,
        ),
        fillColor: Colors.white,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: AppColors.background,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: AppColors.background,
            width: 2.0,
          ),
        ),
      ),
      validator: (value) {
        if (value == null ||
            value.isEmpty ||
            value.length > 10 ||
            value.length < 10) {
          // return 'أدخل رقم صالح';
          return AppLocalizations.of(context).validNumber;
        }
        return null;
      },
      // onSaved: (value) {
      //   addMalkanprovider.area = int.tryParse(_areacontroller.text);
      // },
    );
    return SafeArea(
      child: Scaffold(
        // backgroundColor: Colors.white,
        body: _isLoggedIn
            ? SingleChildScrollView(
                child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Text(
                  _usrObj.toString(),
                ),
              ))
            : Center(
                child: Container(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 100,
                        ),
                        Image.asset(
                          'img/logo.png',
                          fit: BoxFit.cover,
                          height: 200,
                        ),
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            AppLocalizations.of(context).dalPhrase,
                            // 'أدخل رقمك الشخصي',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Divider(
                          color: AppColors.primary,
                          indent: 25,
                          endIndent: 25,
                        ),
                        Container(
                          padding: const EdgeInsets.only(
                              left: 8.0, right: 8.0, top: 16.0),
                          child: Text(
                            AppLocalizations.of(context).enterNumber,
                            // 'أدخل رقمك الشخصي',
                            style: TextStyle(
                              // color: AppColors.primary,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                bottom: 16.0, left: 16.0, right: 16.0),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              elevation: 9.0,
                              child: Form(
                                key: _formkey,
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: <Widget>[
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 4,
                                          horizontal: 8,
                                        ),
                                        child: phoneTextFielde,
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      _isLoading
                                          ? CircularProgressIndicator(
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                AppColors.accent,
                                              ),
                                            )
                                          : Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 30.0,
                                                  vertical: 8.0),
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  primary: AppColors.primary,
                                                ),
                                                child: Text(
                                                  AppLocalizations.of(context)
                                                      .logIn,
                                                  style: TextStyle(
                                                      // color: AppColors.background,
                                                      ),
                                                ),
                                                onPressed: () async {
                                                  setState(() {
                                                    loading = false;
                                                  });
                                                  bool res;
                                                  res = await _submit(
                                                      _phonecontroller.text);
                                                  if (res) {
                                                    Utils.showToast(
                                                      message:
                                                          AppLocalizations.of(
                                                                  context)
                                                              .logedin,
                                                      // 'أنت الان مسجل في التطبيق',
                                                      backgroundColor:
                                                          AppColors.primary,
                                                      textColor:
                                                          Theme.of(context)
                                                              .textTheme
                                                              .bodyText1
                                                              .color,
                                                    );
                                                    // var myUser = Provider.of<CustomerProvider>(context,listen: false).user;
                                                    //   CachHelper.saveData(
                                                    //         key: 'user', value: myUser,);

                                                    Navigator.of(context)
                                                        .pushReplacementNamed(
                                                      // OtpScreen.routeName
                                                      MainTabBarViewController
                                                          .routeName,
                                                    );

                                                    // if (_authMode == AuthMode.Login) {

                                                    //   Navigator.of(context)
                                                    //       .pushReplacementNamed(
                                                    //           HomePageScreen.routeName);
                                                    // }

                                                  } else {
                                                    Utils.showToast(
                                                      message:
                                                          AppLocalizations.of(
                                                                  context)
                                                              .loginRefused,
                                                      // 'تعذرت عملية التسجيل',
                                                      backgroundColor:
                                                          AppColors.primary,
                                                      textColor:
                                                          Theme.of(context)
                                                              .textTheme
                                                              .bodyText1
                                                              .color,
                                                    );
                                                    setState(() {
                                                      loading = false;
                                                    });
                                                  }
                                                },
                                              ),
                                            ),
                                      // SingleChildScrollView(
                                      //   child: Container(
                                      //     child: ElevatedButton(
                                      //       style: ElevatedButton.styleFrom(
                                      //         primary: AppColors.primary,
                                      //       ),
                                      //       onPressed: () async {
                                      //         FacebookAuth.instance.login(
                                      //             permissions: [
                                      //               'email',
                                      //               'public_profile',
                                      //               // "user_birthday",
                                      //               // "user_gender",
                                      //               // "user_link",
                                      //               // "user_photos",
                                      //               // 'pages_user_gender'
                                      //             ],
                                      //             loginBehavior: LoginBehavior
                                      //                 .dialogOnly).then(
                                      //             (value) async {
                                      //           // LoginResult()

                                      //           print('facebook result');
                                      //           print(value.message);
                                      //           print(value.runtimeType);

                                      //           if (value.status ==
                                      //               LoginStatus.success) {
                                      //             // you are logged

                                      //             accessToken =
                                      //                 value.accessToken;

                                      //             print(dateFormat.format(
                                      //                 accessToken.expires));
                                      //             facebookUser
                                      //                 .setCustomerSessionExpirationDate(
                                      //                     dateFormat.format(
                                      //                         accessToken
                                      //                             .expires));

                                      //             // Name email id , image ,yyyy-MM-dd ,
                                      //             print('access Token ');
                                      //             print(accessToken.token);
                                      //             print('expires');
                                      //             print(accessToken.expires);
                                      //             print(dateFormat.format(
                                      //                 accessToken
                                      //                     .expires)); //Converting DateTime object to String

                                      //             print(
                                      //                 accessToken.runtimeType);
                                      //           } else {
                                      //             print(value);
                                      //             print(value.status);
                                      //             print(value.message);
                                      //           }
                                      //           FacebookAuth.instance
                                      //               .getUserData()
                                      //               .then(
                                      //             (userData) {
                                      //               setState(
                                      //                 () {
                                      //                   // _isLoggedIn =
                                      //                   //     true;
                                      //                   _usrObj = userData;
                                      //                   facebookUser
                                      //                       .setFacebookId(
                                      //                           userData['id']);
                                      //                   facebookUser.setName(
                                      //                       userData['name']);
                                      //                   facebookUser.setEamil(
                                      //                       userData['email']);
                                      //                   facebookUser
                                      //                       .setProfileImage(
                                      //                           userData['picture']
                                      //                                   ['data']
                                      //                               ['url']);

                                      //                   // facebookUser = FacebookUser(
                                      //                   //     facebookId:
                                      //                   //         userData[
                                      //                   //             'id'],
                                      //                   //     name: userData[
                                      //                   //         'name'],
                                      //                   //     email: userData[
                                      //                   //         'email'],
                                      //                   //     profileImage:
                                      //                   //         userData['picture']['data']
                                      //                   //             [
                                      //                   //             'url']);

                                      //                   print(
                                      //                       'facebook usr data');
                                      //                   print(userData);
                                      //                   FacebookAuth.instance
                                      //                       .getUserData(
                                      //                           fields:
                                      //                               'gender')
                                      //                       .then(
                                      //                     (value) async {
                                      //                       print('ge');
                                      //                       print(value
                                      //                           .toString());
                                      //                       print('sss');
                                      //                       print(value
                                      //                           .runtimeType);
                                      //                       print('gender');

                                      //                       print(facebookUser
                                      //                           .toJson()
                                      //                           .runtimeType);

                                      //                       var res =
                                      //                           await _facebookSubmit(
                                      //                         userData['id'],
                                      //                         userData['name'],
                                      //                         userData['email'],
                                      //                         userData['picture']
                                      //                                 ['data']
                                      //                             ['url'],
                                      //                         dateFormat.format(
                                      //                             accessToken
                                      //                                 .expires),
                                      //                       );
                                      //                       if (res) {
                                      //                         Utils.showToast(
                                      //                           message: AppLocalizations.of(
                                      //                                   context)
                                      //                               .logedin,
                                      //                           // 'أنت الان مسجل في التطبيق',
                                      //                           backgroundColor:
                                      //                               AppColors
                                      //                                   .primary,
                                      //                           textColor: Theme.of(
                                      //                                   context)
                                      //                               .textTheme
                                      //                               .bodyText1
                                      //                               .color,
                                      //                         );
                                      //                         // var myUser = Provider.of<CustomerProvider>(context,listen: false).user;
                                      //                         //   CachHelper.saveData(
                                      //                         //         key: 'user', value: myUser,);

                                      //                         Navigator.of(
                                      //                                 context)
                                      //                             .pushReplacementNamed(
                                      //                           // OtpScreen.routeName
                                      //                           MainTabBarViewController
                                      //                               .routeName,
                                      //                         );

                                      //                         // if (_authMode == AuthMode.Login) {

                                      //                         //   Navigator.of(context)
                                      //                         //       .pushReplacementNamed(
                                      //                         //           HomePageScreen.routeName);
                                      //                         // }

                                      //                       } else {
                                      //                         Utils.showToast(
                                      //                           message: AppLocalizations.of(
                                      //                                   context)
                                      //                               .loginRefused,
                                      //                           // 'تعذرت عملية التسجيل',
                                      //                           backgroundColor:
                                      //                               AppColors
                                      //                                   .primary,
                                      //                           textColor: Theme.of(
                                      //                                   context)
                                      //                               .textTheme
                                      //                               .bodyText1
                                      //                               .color,
                                      //                         );
                                      //                         setState(() {
                                      //                           loading = false;
                                      //                         });
                                      //                       }
                                      //                     },
                                      //                   );
                                      //                 },
                                      //               );
                                      //             },
                                      //           );
                                      //         });
                                      //       },
                                      //       child: Text(
                                      //           AppLocalizations.of(context)
                                      //               .loginWithFacebook),
                                      //     ),
                                      //   ),
                                      // ),
                                      // Padding(
                                      //   padding: const EdgeInsets.only(
                                      //       top: 0, bottom: 8),
                                      //   child: GestureDetector(
                                      //     onTap: () {
                                      //       Navigator.of(context).pushNamed(
                                      //         CustomerSignupScreens.routeName,
                                      //       );
                                      //     },
                                      //     child: Text(
                                      //       AppLocalizations.of(context).signup,
                                      //       style: TextStyle(
                                      //           color: AppColors.primary),
                                      //     ),
                                      //   ),
                                      // ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 4, bottom: 16),
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.of(context)
                                                .pushReplacementNamed(
                                              MainTabBarViewController
                                                  .routeName,
                                            );
                                          },
                                          child: Text(
                                            AppLocalizations.of(context).guest,
                                            style: TextStyle(
                                                color: AppColors.primary),
                                          ),
                                        ),
                                      ),
                                      if (loading)
                                        Center(
                                          child: CircularProgressIndicator(
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                              AppColors.primary,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
