import 'dart:async';
import 'package:dal/business_logic_layer/user_provider.dart';
import 'package:dal/screens/autharization/customer_signup_screen.dart';
import 'package:dal/screens/homescreen_with_tabbar_view_controller.dart';
import 'package:dal/theme/app_colors.dart';
import 'package:dal/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// enum AuthMode { Signup, Login }

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

  bool _isLoading = false;

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

  @override
  Widget build(BuildContext context) {
    // final devicesize = MediaQuery.of(context).size;

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
        body: Center(
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
                    padding:
                        const EdgeInsets.only(left: 8.0, right: 8.0, top: 16.0),
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
                                            horizontal: 30.0, vertical: 8.0),
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            primary: AppColors.primary,
                                          ),
                                          child: Text(
                                            AppLocalizations.of(context).logIn,
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
                                                    AppLocalizations.of(context)
                                                        .logedin,
                                                // 'أنت الان مسجل في التطبيق',
                                                backgroundColor:
                                                    AppColors.primary,
                                                textColor: Theme.of(context)
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
                                                    AppLocalizations.of(context)
                                                        .loginRefused,
                                                // 'تعذرت عملية التسجيل',
                                                backgroundColor:
                                                    AppColors.primary,
                                                textColor: Theme.of(context)
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
                                //
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 0, bottom: 8),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).pushNamed(
                                        CustomerSignupScreens.routeName,
                                      );
                                    },
                                    child: Text(
                                      AppLocalizations.of(context).signup,
                                      style:
                                          TextStyle(color: AppColors.primary),
                                    ),
                                  ),
                                ),
                                // Padding(
                                //   padding:
                                //       const EdgeInsets.only(top: 0, bottom: 8),
                                //   child: ElevatedButton(
                                //     style: ElevatedButton.styleFrom(
                                //       primary: AppColors.primary,
                                //     ),
                                //     onPressed: () {
                                //       Navigator.of(context).pushNamed(
                                //         CustomerSignupScreens.routeName,
                                //       );
                                //     },
                                //     child: Directionality(
                                //       textDirection: TextDirection.rtl,
                                //       child: Text(
                                //         AppLocalizations.of(context).signup,
                                //         style: TextStyle(
                                //             color: AppColors.background),
                                //       ),
                                //     ),
                                //   ),
                                // ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 4, bottom: 16),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.of(context)
                                          .pushReplacementNamed(
                                        MainTabBarViewController.routeName,
                                      );
                                    },
                                    child: Text(
                                      AppLocalizations.of(context).guest,
                                      style:
                                          TextStyle(color: AppColors.primary),
                                    ),
                                  ),
                                ),
                                if (loading)
                                  Center(
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
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
