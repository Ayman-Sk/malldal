import 'dart:io';
import 'package:path/path.dart' as pathLib;
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

import 'package:dal/business_logic_layer/user_provider.dart';
import 'package:dal/network/local_host.dart';
import 'package:dal/screens/edit_seller_profile.dart';
import 'package:dal/theme/app_colors.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SellerProfileScreen extends StatefulWidget {
  static const routeName = 'SellerProfileScreen';

  @override
  _SellerProfileScreenState createState() => _SellerProfileScreenState();
}

class _SellerProfileScreenState extends State<SellerProfileScreen> {
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

    // final user = sellerProvider;

    String userMode = sellerProvider.userMode;
    print('UUUUUUUUUUUUUUUUUUUU');
    print("USERMODEEE:" + userMode);
    print('object' + sellerProvider.profileImage);
    double coverHeight = MediaQuery.of(context).size.height / 4;
    double imageHeight = MediaQuery.of(context).size.height / 8;
    return SafeArea(
      child: Scaffold(
        // drawer: MyDrawer(),
        // drawerScrimColor: AppColors.primary.withOpacity(0.7),
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          elevation: 0.0,
        ),
        // backgroundColor: Colors.white,
        body: ListView(
          children: [
            buildTop(
                coverHeight, imageHeight, sellerProvider.profileImage, context),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () async {
                        String path = 'http://malldal.com/dal/' +
                            sellerProvider.profileImage;
                        path = await editAllNetworkImagePaths(path);
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                EditSellerProfileScreen(path: path)));

                        // Navigator.of(context)
                        //     .pushNamed(EditSellerProfileScreen.routeName);
                      },
                      icon: Icon(Icons.edit),
                      label: Text(
                        AppLocalizations.of(context).edit,
                        // 'تعديل',
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: AppColors.primary,
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0),
                        ),
                      ),
                    ),
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
                    icon: FontAwesomeIcons.person,
                    title: AppLocalizations.of(context).name, //"الاسم",
                    subTitle: sellerProvider.userName),
                accountInfoCard(
                    icon: FontAwesomeIcons.phone,
                    title: AppLocalizations.of(context).phoneNumber, //"الرقم",
                    subTitle: sellerProvider.phoneNumber),
                CachHelper.getData(key: 'userId') != null
                    ? accountInfoCard(
                        icon: Icons.info,
                        title: AppLocalizations.of(context)
                            .contactInfo, //'معلومات التواصل',
                        subTitle: sellerProvider.biography)
                    : Container(),
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
                //     title: AppLocalizations.of(context).city, //'المدينة',
                //     subTitle: sellerProvider.cityName),
                accountInfoCard(
                  icon: sellerProvider.gender == 'male'
                      ? Icons.male
                      : Icons.female,
                  title: AppLocalizations.of(context).gender, //"الجنس",
                  subTitle: sellerProvider.gender == 'male'
                      ? AppLocalizations.of(context).male
                      : //'ذكر' :
                      AppLocalizations.of(context).female,
                  // 'أنثى',
                ),
                accountInfoCard(
                  icon: userMode == 'customer'
                      ? Icons.attach_money
                      : Icons.sell_outlined,
                  title:
                      AppLocalizations.of(context).accountType, //'نوع الحساب',
                  subTitle: userMode == 'customer'
                      ?
                      // 'مشتري' :
                      AppLocalizations.of(context).customer
                      :
                      //  'بائع',
                      AppLocalizations.of(context).seller,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

Future<String> editAllNetworkImagePaths(String path) async {
  String truePaths = await getTruePaths(path);
  print(path);
  print('all');
  print(truePaths);
  return truePaths;
}

Future<String> getTruePaths(String path) async {
  print('sub');
  print(path);
  // print(widget.imagesPaths);
  print(path.substring(0, 4));
  if (path.substring(0, 4) == 'http') {
    String fileName = path.split('/').last;
    var s = await http.get(Uri.parse(path));
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    File file = new File(pathLib.join(documentDirectory.path, fileName));
    file.writeAsBytes(s.bodyBytes);
    print('true');
    print(path);
    print(fileName);
    print(documentDirectory.path + fileName);
    return documentDirectory.path + '/' + fileName;
  }
  return path;
}

Widget buildTop(double coverHeight, imageHeight, String profileImagePath,
    BuildContext context) {
  return Stack(clipBehavior: Clip.none, alignment: Alignment.center, children: [
    Container(
        margin: EdgeInsets.only(bottom: coverHeight / 2),
        child: buildCoverImage(coverHeight)),
    Positioned(
      child: buildProfileImage(imageHeight, profileImagePath, context),
      top: coverHeight - imageHeight / 2,
      // left: MediaQuery.of(context).size.width / 2.5,
    )
  ]);
}

Widget buildCoverImage(double coverHeight) => Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey),
        ),
      ),
      // color: Colors.white,
      child: Image.asset(
        'img/logo.png',
        width: double.infinity,
        height: coverHeight,
        fit: BoxFit.contain,
      ),
    );

Widget buildProfileImage(
        double imageHeight, String profileImagePath, BuildContext context) =>
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
        size: 30,
      ),
      title: Text(
        title,
        style: TextStyle(
            fontSize: 20,
            color: AppColors.primary,
            fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        subTitle,
        style: TextStyle(
            fontSize: 15, color: Colors.grey, fontWeight: FontWeight.w600),
      ),
    ),
  );
}
