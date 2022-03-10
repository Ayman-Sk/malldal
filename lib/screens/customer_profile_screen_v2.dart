import 'dart:io';
import 'package:dal/business_logic_layer/user_provider.dart';
import 'package:dal/network/local_host.dart';
import 'package:dal/screens/autharization/customer_signup_screen.dart';
import 'package:dal/screens/autharization/login_card_screen.dart';
import 'package:dal/theme/app_colors.dart';
import 'package:dal/widgets/myDrawer.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'edit_customer_profile.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CustomerProfileScreenV2 extends StatefulWidget {
  static const routeName = 'CustomerProfileScreenV2';
  @override
  _CustomerProfileScreenV2State createState() =>
      _CustomerProfileScreenV2State();
}

class _CustomerProfileScreenV2State extends State<CustomerProfileScreenV2> {
  File file;
  Future selectFile(BuildContext context) async {
    var userProvider = Provider.of<UserProvider>(context, listen: false);
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);
    if (result == null) return;
    final path = result.files.single.path;
    setState(() {
      file = File(path);
      file = File(userProvider.profileImage);
      // upLoadedImage = true;
    });
    userProvider.setProfileImage(path);
  }

  @override
  Widget build(BuildContext context) {
    var customerProvider = Provider.of<UserProvider>(context);
    customerProvider.getUserToApp();
    var userProvider = Provider.of<UserProvider>(context);
    int id = CachHelper.getData(key: 'userId');
    String userMode = customerProvider.userMode;

    return Scaffold(
      drawer: MyDrawer(),
      drawerScrimColor: AppColors.primary.withOpacity(0.7),
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context).title,
        ),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        elevation: 10,
      ),
      body: id == null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppLocalizations.of(context).unregistered,
                    // 'يجب أن تكون مسجلا'
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: AppColors.accent),
                    onPressed: () => Navigator.of(context)
                        .pushNamed(LoginCardScreen.routeName),
                    child: Text(
                      AppLocalizations.of(context).logIn,
                      // 'تسجيل الدخول'
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: AppColors.accent),
                    onPressed: () => Navigator.of(context)
                        .pushNamed(CustomerSignupScreens.routeName),
                    child: Text(
                      AppLocalizations.of(context).signup,
                      // 'إنشاء حساب'
                    ),
                  )
                ],
              ),
            )
          : Stack(
              children: [
                Positioned(
                  top: MediaQuery.of(context).size.height / 8,
                  right: 0,
                  child: Container(
                    // color: Colors.amberAccent,
                    width: MediaQuery.of(context).size.width / 2,
                    height: MediaQuery.of(context).size.height / 1.5,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).iconTheme.color,
                          // offset: Offset(0.0, 0.0), //(x,y)
                          blurRadius: 10.0,
                        ),
                      ],
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(1000),
                        bottomLeft: Radius.circular(1000),
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [
                          AppColors.primary,
                          Colors.green,
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  child: Container(
                    // color: Colors.amberAccent,
                    width: MediaQuery.of(context).size.width / 2,
                    height: MediaQuery.of(context).size.height / 2,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).iconTheme.color,
                          // offset: Offset(0.0, 0.0), //(x,y)
                          blurRadius: 10.0,
                        ),
                      ],
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(1000),
                        bottomRight: Radius.circular(1000),
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [
                          AppColors.primary,
                          Colors.greenAccent,
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  child: Container(
                    // color: Colors.amberAccent,
                    width: MediaQuery.of(context).size.width / 2,
                    height: MediaQuery.of(context).size.height / 4,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).iconTheme.color,
                          // offset: Offset(0.0, 0.0), //(x,y)
                          blurRadius: 10.0,
                        ),
                      ],
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(1000),
                          bottomRight: Radius.circular(30)),
                      gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [
                          Colors.lightGreen,
                          AppColors.primary,
                        ],
                      ),
                    ),
                  ),
                ),

                // Positioned(
                //   left: MediaQuery.of(context).size.width / 10,
                //   top: MediaQuery.of(context).size.height / 18,
                //   child: Container(
                //     child: Text(
                //       'Profile',
                //       style: TextStyle(color: AppColors.primary, fontSize: 20),
                //     ),
                //   ),
                // ),
                Center(
                  // left: MediaQuery.of(context).size.width / 5,
                  // top: MediaQuery.of(context).size.height / 5,
                  // height: MediaQuery.of(context).size.height / 2,
                  // width: MediaQuery.of(context).size.width,
                  child: Container(
                    padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width / 11,
                      right: MediaQuery.of(context).size.width / 11,
                      top: MediaQuery.of(context).size.height / 12,
                      bottom: MediaQuery.of(context).size.height / 14,
                    ),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Card(
                      elevation: 20,
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height / 8),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              // accountInfoCard(
                              //   icon: Icons.person,
                              //   title: AppLocalizations.of(context)
                              //       .name, // "الاسم",
                              //   subTitle: customerProvider.user.name,
                              // ),
                              accountInfoCard(
                                  icon: Icons.phone,
                                  title: AppLocalizations.of(context)
                                      .phoneNumber, //"الرقم",
                                  subTitle: customerProvider.user.phoneNumber),
                              accountInfoCard(
                                  icon: Icons.location_on,
                                  title: AppLocalizations.of(context)
                                      .city, // 'المدينة',
                                  subTitle: customerProvider.cityName),
                              accountInfoCard(
                                icon: customerProvider.gender == 'male'
                                    ? Icons.male
                                    : Icons.female,
                                title: AppLocalizations.of(context)
                                    .gender, // "الجنس",
                                subTitle: customerProvider.gender == 'male'
                                    ? AppLocalizations.of(context).male //'ذكر'
                                    : AppLocalizations.of(context)
                                        .female, //'أنثى',
                              ),
                              accountInfoCard(
                                icon: userMode == 'customer'
                                    ? Icons.attach_money
                                    : Icons.sell_outlined,
                                title: AppLocalizations.of(context)
                                    .accountType, // 'نوع الحساب',
                                subTitle:
                                    customerProvider.userMode == 'customer'
                                        ? AppLocalizations.of(context)
                                            .customer //'مشتري'
                                        : AppLocalizations.of(context)
                                            .seller, //'بائع',
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: MediaQuery.of(context).size.height / 6.5,
                  right: MediaQuery.of(context).size.width / 4,
                  child: Text(
                    customerProvider.user.name,
                    style: TextStyle(
                      fontSize: 25,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                      shadows: <Shadow>[
                        Shadow(
                          offset: Offset(1, 2),
                          blurRadius: 4,
                          color: Colors.grey,
                        ),
                        Shadow(
                          // offset: Offset(10.0, 10.0),
                          blurRadius: 0,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: MediaQuery.of(context).size.height / 1.55,
                  right: MediaQuery.of(context).size.width / 1.6,
                  child: CircleAvatar(
                    backgroundColor: AppColors.primary,
                    maxRadius: MediaQuery.of(context).size.width / 6,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [
                            Colors.greenAccent,
                            AppColors.primary,
                          ],
                        ),
                      ),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: CircleAvatar(
                          // backgroundColor: Colors.black,
                          maxRadius: MediaQuery.of(context).size.width / 7,
                          // backgroundImage: Image.asset('img/test.jpg'),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: Image.network(
                                userProvider.profileImage,
                              ) //Image.asset('img/user.jpg'),
                              ),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: MediaQuery.of(context).size.height / 1.44,
                  right: MediaQuery.of(context).size.width / 2.1,
                  child: Card(
                    color: AppColors.primary,
                    elevation: 10,
                    shadowColor: Colors.grey,
                    // maxRadius: 20,
                    // backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: IconButton(
                      onPressed: () => Navigator.of(context)
                          .pushNamed(EditCustomerProfileScreen.routeName),
                      icon: Icon(Icons.people, color: Colors.white),
                    ),
                  ),
                ),
                Positioned(
                  right: MediaQuery.of(context).size.width / 3.1,
                  top: MediaQuery.of(context).size.height / 1.4,
                  child: Container(
                    height: MediaQuery.of(context).size.height / 18,
                    width: MediaQuery.of(context).size.width / 3,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          // offset: Offset(0.0, 0.0),
                          blurRadius: 20.0,
                        ),
                      ],
                    ),
                    child: ElevatedButton.icon(
                      onPressed: () => Navigator.of(context)
                          .pushNamed(EditCustomerProfileScreen.routeName),
                      icon: Icon(Icons.edit),
                      label: Text(
                        AppLocalizations.of(context).edit,
                        // 'تعديل'
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: AppColors.primary,
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

Widget accountInfoCard({IconData icon, String title, String subTitle}) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
    child: Card(
      elevation: 10,
      // color: Colors.white70,
      child: ListTile(
        leading: Icon(
          icon,
          size: 30,
        ),
        title: Text(
          title,
          // textAlign: TextAlign.left,
          style: TextStyle(
              fontSize: 18,
              color: AppColors.primary,
              fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          subTitle,
          // textAlign: TextAlign.left,
          style: TextStyle(
              fontSize: 15, color: Colors.grey, fontWeight: FontWeight.w600),
        ),
      ),
    ),
  );
}
