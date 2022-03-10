import 'dart:io';
import 'package:dal/business_logic_layer/user_provider.dart';
import 'package:dal/network/local_host.dart';
import 'package:dal/screens/edit_seller_profile.dart';
import 'package:dal/screens/seller_posts_screen.dart';
import 'package:dal/theme/app_colors.dart';
import 'package:dal/widgets/myDrawer.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'add_post_screen.dart';

class SellerProfileScreenV2 extends StatefulWidget {
  static const routeName = 'SellerProfileScreenV2';

  @override
  _SellerProfileScreenV2State createState() => _SellerProfileScreenV2State();
}

class _SellerProfileScreenV2State extends State<SellerProfileScreenV2> {
  File file;
  Future selectFile(BuildContext context) async {
    var sellerProvider = Provider.of<UserProvider>(context, listen: false);
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);
    if (result == null) return;
    final path = result.files.single.path;
    setState(() {
      file = File(path);
      // upLoadedImage = true;
    });
    sellerProvider.setProfileImage(path);
  }

  @override
  Widget build(BuildContext context) {
    var sellerProvider = Provider.of<UserProvider>(context);
    // final ownerUser = ModalRoute.of(context).settings.arguments as Seller;
    // sellerProvider.getUserToApp();
    // final fileName = file != null ? basename(file.path) : 'لم تختر صورة بعد';
    // bool upLoadedImage = sellerProvider.profileImage == null ? false : true;

    final user = sellerProvider;

    String userMode = sellerProvider.userMode;
    print('UUUUUUUUUUUUUUUUUUUU');
    print("USERMODEEE:" + userMode);
    double coverHeight = MediaQuery.of(context).size.height / 4;
    double imageHeight = MediaQuery.of(context).size.height / 8;
    return SafeArea(
      child: Scaffold(
        drawer: MyDrawer(),
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          elevation: 0.0,
        ),
        body: Stack(
          children: [
            Positioned(
              top: MediaQuery.of(context).size.height / 8,
              right: 0,
              child: Container(
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
            Center(
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
                          accountInfoCard(
                              icon: Icons.phone,
                              title: AppLocalizations.of(context)
                                  .phoneNumber, //"الرقم",
                              subTitle: sellerProvider.user.phoneNumber),
                          accountInfoCard(
                              icon: Icons.location_on,
                              title: AppLocalizations.of(context)
                                  .city, // 'المدينة',
                              subTitle: sellerProvider.cityName),
                          accountInfoCard(
                            icon: sellerProvider.gender == 'male'
                                ? Icons.male
                                : Icons.female,
                            title:
                                AppLocalizations.of(context).gender, // "الجنس",
                            subTitle: sellerProvider.gender == 'male'
                                ? AppLocalizations.of(context).male //'ذكر'
                                : AppLocalizations.of(context).female, //'أنثى',
                          ),
                          accountInfoCard(
                            icon: userMode == 'customer'
                                ? Icons.attach_money
                                : Icons.sell_outlined,
                            title: AppLocalizations.of(context)
                                .accountType, // 'نوع الحساب',
                            subTitle: sellerProvider.userMode == 'customer'
                                ? AppLocalizations.of(context)
                                    .customer //'مشتري'
                                : AppLocalizations.of(context).seller, //'بائع',
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
                sellerProvider.user.name,
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
                        child: Image.network('http://malldal.com/dal/' +
                            sellerProvider
                                .profileImage), //Image.asset('img/user.jpg'),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: MediaQuery.of(context).size.height / 1.44,
              left: MediaQuery.of(context).size.width / 2.3,
              child: Row(
                children: [
                  Card(
                    color: AppColors.primary,
                    elevation: 10,
                    shadowColor: Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: IconButton(
                      onPressed: () => Navigator.of(context).pushNamed(
                          SellerPostScreen.routeName,
                          arguments: false),
                      icon: Icon(Icons.view_array, color: Colors.white),
                    ),
                  ),
                  Card(
                    color: AppColors.primary,
                    elevation: 10,
                    shadowColor: Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: IconButton(
                      onPressed: () => Navigator.of(context).pushNamed(
                          SellerPostScreen.routeName,
                          arguments: true),
                      icon: Icon(Icons.push_pin_sharp, color: Colors.white),
                    ),
                  ),
                  Card(
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
                          .pushNamed(AddPostScreen.routeName),
                      icon: Icon(Icons.shopping_bag, color: Colors.white),
                    ),
                  ),
                  // Card(
                  //   color: AppColors.primary,
                  //   elevation: 10,
                  //   shadowColor: Colors.grey,
                  //   // maxRadius: 20,
                  //   // backgroundColor: AppColors.primary,
                  //   shape: RoundedRectangleBorder(
                  //     borderRadius: BorderRadius.circular(50),
                  //   ),
                  //   child: IconButton(
                  //     onPressed: () => Navigator.of(context)
                  //         .pushNamed(EditSellerProfileScreen.routeName),
                  //     icon: Icon(Icons.people, color: Colors.white),
                  //   ),
                  // ),
                ],
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
                      .pushNamed(EditSellerProfileScreen.routeName),
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
