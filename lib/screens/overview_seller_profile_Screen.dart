import 'dart:io';

import 'package:dal/business_logic_layer/user_provider.dart';
import 'package:dal/data_layer/data_providers/customer_apis.dart';
import 'package:dal/data_layer/models/post_with_sellers_model.dart';
import 'package:dal/network/local_host.dart';
import 'package:dal/theme/app_colors.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OverviewSellerProfileScreen extends StatefulWidget {
  static const routeName = 'OverviewSellerProfileScreen';

  @override
  _OverviewSellerProfileScreenState createState() =>
      _OverviewSellerProfileScreenState();
}

class _OverviewSellerProfileScreenState
    extends State<OverviewSellerProfileScreen> {
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

  bool isFollowed = false;

  @override
  Widget build(BuildContext context) {
    var sellerProvider = Provider.of<UserProvider>(context);
    final ownerUser = ModalRoute.of(context).settings.arguments as Seller;
    // sellerProvider.getUserToApp();
    // final fileName = file != null ? basename(file.path) : 'لم تختر صورة بعد';
    // bool upLoadedImage = sellerProvider.profileImage == null ? false : true;
    setState(() {
      if (CachHelper.getData(key: 'userId') != null &&
          sellerProvider.user.userMode == 'customer')
        isFollowed = sellerProvider.user.followSellers.contains(ownerUser.id);
      else
        isFollowed = false;
      print('isssssssssssssssssssFolloweeed');
      print(isFollowed);
      print(Provider.of<UserProvider>(context).user.followSellers);
    });
    final user = ownerUser;

    // String userMode = sellerProvider.userMode;
    // print('UUUUUUUUUUUUUUUUUUUU');
    // print("USERMODEEE:" + userMode);
    double coverHeight = MediaQuery.of(context).size.height / 4;
    // double coverWidth = MediaQuery.of(context).size.width;
    double imageHeight = MediaQuery.of(context).size.height / 8;

    return SafeArea(
      child: Scaffold(
        // endDrawer: MyDrawer(),
        drawerScrimColor: AppColors.primary.withOpacity(0.7),
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          elevation: 0.0,
        ),
        // backgroundColor: Colors.white,
        body: ListView(
          children: [
            // buildTop(
            //     coverHeight,
            //     imageHeight,
            //     coverWidth,
            //     sellerProvider.userId,
            //     ownerUser.userId,
            //     sellerProvider.userMode == 'seller'),

            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: coverHeight / 2),
                  child: buildCoverImage(coverHeight),
                ),
                Positioned(
                  child: buildProfileImage(imageHeight, ownerUser.profileImage),
                  top: coverHeight - imageHeight / 2,
                  // left: MediaQuery.of(context).size.width / 2.5,
                ),
                CachHelper.getData(key: 'userId') != null &&
                        sellerProvider.userMode != 'seller'
                    ? Positioned(
                        // child: buildFollowButton(
                        //     sellerProvider.userId, ownerUser.userId),
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            CustomerApis apis = CustomerApis();
                            if (!isFollowed) {
                              bool res =
                                  await apis.addSellerTofollowedUserOfCustomer(
                                      customerId: sellerProvider.userId,
                                      sellerId: ownerUser.userId,
                                      token: CachHelper.getData(key: 'token'));
                              print(res);
                              if (res == true) {
                                setState(() {
                                  isFollowed = true;
                                });
                                sellerProvider.user.followSellers
                                    .add(ownerUser.id);
                              }
                              return res;
                            } else {
                              bool res = await apis
                                  .removeSellerTofollowedUserOfCustomer(
                                      customerId: sellerProvider.userId,
                                      sellerId: ownerUser.userId,
                                      token: CachHelper.getData(key: 'token'));
                              print(res);
                              if (res == true) {
                                setState(() {
                                  isFollowed = false;
                                });
                                sellerProvider.user.followSellers
                                    .remove(ownerUser.id);
                              }
                              return res;
                            }
                          },
                          icon: isFollowed
                              ? Icon(Icons.person_add_disabled)
                              : Icon(Icons.person_add_alt),
                          label: isFollowed
                              ? Text(
                                  AppLocalizations.of(context).unfollow,
                                  // 'إلغاء المتابعة',
                                )
                              : Text(
                                  AppLocalizations.of(context).follow,
                                  // 'متابعة',
                                ),
                          style: ElevatedButton.styleFrom(
                            primary: AppColors.primary,
                            shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(30.0),
                            ),
                          ),
                        ),
                        top: coverHeight / 1.1,
                        right: 10,
                      )
                    : Container(),
              ],
            ),

            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      AppLocalizations.of(context).accountInfo,
                      // 'معلومات الحساب',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 30,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                accountInfoCard(
                    icon: Icons.person,
                    title: AppLocalizations.of(context).name, //"الاسم",
                    subTitle: user.user.name),
                ////////////////////////////////////////////////////////////

                ///able To Change
                // accountInfoCard(
                //     icon: Icons.phone,
                //     title: AppLocalizations.of(context).phoneNumber, //"الرقم",
                //     subTitle: user.user.phone),
                // CachHelper.getData(key: 'userId') != null
                //     ? accountInfoCard(
                //         icon: Icons.info,
                //         title: AppLocalizations.of(context)
                //             .contactInfo, //'معلومات التواصل',
                //         subTitle: user.bio)
                //     : Container(),

                // ////////////////////////////////////////////////////////
                // accountInfoCard(
                //     icon: Icons.phone_in_talk,
                //     title: 'أرقام أخرى',
                //     subTitle: sellerProvider.getNumbersOfSeller),
                // accountInfoCard(
                //     icon: Icons.contact_page,
                //     title: 'السيرة الشخصية',
                //     subTitle: sellerProvider.contactInfo),
                // accountInfoCard(
                //     icon: Icons.location_on,
                //     title: 'المدينة',
                //     subTitle: user.),
                accountInfoCard(
                  icon: user.user.gender == 'male' ? Icons.male : Icons.female,
                  title: AppLocalizations.of(context).gender, //"الجنس",
                  subTitle: user.user.gender == 'male'
                      ? AppLocalizations.of(context).male
                      : //'ذكر' :
                      AppLocalizations.of(context).female, //'أنثى'
                ),
                accountInfoCard(
                  icon: Icons.sell_outlined,
                  title:
                      AppLocalizations.of(context).accountType, //'نوع الحساب',
                  subTitle: AppLocalizations.of(context).seller,
                  // 'بائع',
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget buildTop(double coverHeight, imageHeight, coverwidth, String userId,
      String ownerId, bool isSeller, String profielImagePath) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Container(
            margin: EdgeInsets.only(bottom: coverHeight / 2),
            child: buildCoverImage(coverHeight)),
        Positioned(
          child: buildProfileImage(imageHeight, profielImagePath),
          top: coverHeight - imageHeight / 2,
          // left: MediaQuery.of(context).size.width / 2.5,
        ),
        CachHelper.getData(key: 'userId') != null && !isSeller
            ? Positioned(
                child: buildFollowButton(userId, ownerId),
                top: coverHeight / 1.1,
                right: 10,
              )
            : Container(),
      ],
    );
  }

  Widget buildFollowButton(String userId, String ownerId) =>
      ElevatedButton.icon(
        onPressed: () async {
          CustomerApis apis = CustomerApis();
          if (!isFollowed) {
            bool res = await apis.addSellerTofollowedUserOfCustomer(
                customerId: userId,
                sellerId: ownerId,
                token: CachHelper.getData(key: 'token'));
            print(res);
            if (res == true) {
              setState(() {
                isFollowed = true;
              });
              // userProvider.user.followSellers.add(widget.ownerUser.id);
            }
            return res;
          } else {
            bool res = await apis.removeSellerTofollowedUserOfCustomer(
                customerId: userId,
                sellerId: ownerId,
                token: CachHelper.getData(key: 'token'));
            print(res);
            if (res == true) {
              setState(() {
                isFollowed = false;
              });
              // userProvider.user.followSellers.remove(widget.ownerUser.id);
            }
            return res;
          }
        },
        icon: isFollowed
            ? Icon(Icons.person_add_disabled)
            : Icon(Icons.person_add_alt),
        label: isFollowed
            ? Text(AppLocalizations.of(context).unfollow)
            : //'إلغاء المتابعة') :
            Text(AppLocalizations.of(context).follow), //'متابعة'),
        style: ElevatedButton.styleFrom(
          primary: AppColors.primary,
          shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(30.0),
          ),
        ),
      );
  Widget buildCoverImage(double coverHeight) => Container(
      // color: Colors.white,
      child: Image.asset(
        'img/logo.png',
        width: double.infinity,
        height: coverHeight,
        fit: BoxFit.contain,
      ),
      decoration:
          BoxDecoration(border: Border.all(width: 1, color: Colors.grey)));
  Widget buildProfileImage(double imageHeight, String profileImagePath) =>
      CircleAvatar(
        radius: imageHeight / 2,
        backgroundColor: Theme.of(context).colorScheme.background,
        backgroundImage: NetworkImage(
          'http://malldal.com/dal/' + profileImagePath,
        ),
      );
  Widget accountInfoCard({IconData icon, String title, String subTitle}) {
    return Card(
      elevation: 10,
      child: ListTile(
        leading: Icon(
          icon,
          size: 40,
        ),
        title: Text(
          title,
          textAlign: TextAlign.left,
          style: TextStyle(
              fontSize: 25,
              color: AppColors.primary,
              fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          subTitle,
          textAlign: TextAlign.left,
          style: TextStyle(
              fontSize: 15, color: Colors.grey, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

// Widget accountInfoCard({IconData icon, String title, String subTitle}) {
//   return ListTile(
//     leading: Icon(
//       icon,
//       size: 40,
//     ),
//     title: Text(
//       title,
//       textAlign: TextAlign.left,
//       style: TextStyle(
//           fontSize: 25, color: AppColors.primary, fontWeight: FontWeight.w600),
//     ),
//     subtitle: Text(
//       subTitle,
//       textAlign: TextAlign.left,
//       style: TextStyle(
//           fontSize: 15, color: Colors.grey, fontWeight: FontWeight.w600),
//     ),
//   );
// }

class MyCustumClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.moveTo(0, 100);
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 100);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}

class MyCustumClipper2 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.moveTo(0, 50);
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 100);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}

class MyCustumClipper3 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.moveTo(0, 0);
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 100);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}

class MyCustumClipper4 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.moveTo(0, 100);
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}

class MyCustumClipper5 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.moveTo(0, 100);
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 50);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
