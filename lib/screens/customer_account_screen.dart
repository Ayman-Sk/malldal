import 'dart:io';
import 'package:dal/business_logic_layer/user_provider.dart';
import 'package:dal/theme/app_colors.dart';
import 'package:dal/widgets/myDrawer.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CustomerAccountScreen extends StatefulWidget {
  static const routeName = 'CustomerAccountScreen';
  @override
  _CustomerAccountScreenState createState() => _CustomerAccountScreenState();
}

class _CustomerAccountScreenState extends State<CustomerAccountScreen> {
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

    List<Map<String, dynamic>> choose = [
      {
        'Icon': Icons.verified_user,
        'Title': AppLocalizations.of(context).followed, //'البائعون المتابعون',
        'Route': 'CustomerSellerFollower',
        'Argument': false,
      },
      {
        'Icon': Icons.person,
        'Title': AppLocalizations.of(context).profilePage, //'الملف الشخصي',
        'Route': 'SellerProfileScreen'
      },
    ];
    String userMode = sellerProvider.userMode;
    print('UUUUUUUUUUUUUUUUUUUU');
    print("USERMODEEE:" + userMode);
    double coverHeight = MediaQuery.of(context).size.height / 4;
    double imageHeight = MediaQuery.of(context).size.height / 8;
    return SafeArea(
      child: Scaffold(
        drawer: MyDrawer(),
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            AppLocalizations.of(context).title,
            // 'إنشاء حساب جديد',
          ),
          backgroundColor: AppColors.primary,
        ),
        drawerScrimColor: AppColors.primary.withOpacity(0.7),
        body: ListView(
          children: [
            buildTop(coverHeight, imageHeight, sellerProvider.profileImage),
            GridView.count(
              crossAxisCount: 3,
              physics:
                  NeverScrollableScrollPhysics(), // to disable GridView's scrolling
              shrinkWrap: true,

              children: List.generate(
                choose.length,
                (index) {
                  return gridViewItem(choose[index], context);
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

Widget gridViewItem(Map<String, dynamic> item, BuildContext context) {
  return GestureDetector(
    onTap: () {
      if (item.keys.contains('Argument')) {
        Navigator.pushNamed(context, item['Route'],
            arguments: item['Argument']);
      } else
        Navigator.pushNamed(context, item['Route']);
    },
    child: Container(
      height: 130,
      width: 120,
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        color: AppColors.background,
        elevation: 2,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Center(
              child: Icon(
                item['Icon'],
                color: AppColors.accent,
                size: 70,
              ),
            ),
            Center(
              child: Text(
                item['Title'],
                style: TextStyle(
                  color: AppColors.accent,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget buildTop(double coverHeight, imageHeight, String profileImagePath) {
  return Stack(clipBehavior: Clip.none, alignment: Alignment.center, children: [
    Container(
        margin: EdgeInsets.only(bottom: coverHeight / 2),
        child: buildCoverImage(coverHeight)),
    Positioned(
      child: buildProfileImage(imageHeight, profileImagePath),
      top: coverHeight - imageHeight / 2,
      // left: MediaQuery.of(context).size.width / 2.5,
    )
  ]);
}

Widget buildCoverImage(double coverHeight) => Container(
      decoration:
          BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey))),
      // color: Colors.white,
      child: Image.asset(
        'img/logo.png',
        width: double.infinity,
        height: coverHeight,
        fit: BoxFit.contain,
      ),
    );

Widget buildProfileImage(double imageHeight, String ProfileImagePath) =>
    CircleAvatar(
      radius: imageHeight / 2,
      backgroundImage: NetworkImage(
        'http://malldal.com/dal/' + ProfileImagePath,
      ),
    );

Widget accountInfoCard({IconData icon, String title, String subTitle}) {
  return ListTile(
    leading: Icon(
      icon,
      size: 40,
    ),
    title: Text(
      title,
      textAlign: TextAlign.left,
      style: TextStyle(
          fontSize: 25, color: AppColors.primary, fontWeight: FontWeight.w600),
    ),
    subtitle: Text(
      subTitle,
      textAlign: TextAlign.left,
      style: TextStyle(
          fontSize: 15, color: Colors.grey, fontWeight: FontWeight.w600),
    ),
  );
}
