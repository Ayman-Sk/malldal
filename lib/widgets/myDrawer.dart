import 'package:dal/network/local_host.dart';
import 'package:dal/screens/add_post_screen.dart';
import 'package:dal/screens/autharization/login_card_screen.dart';
import 'package:dal/screens/customer_seller_follower.dart';
import 'package:dal/screens/main_taps/user_profile_screen.dart';
import 'package:dal/screens/seller_posts_screen.dart';
import 'package:dal/screens/settings_screen.dart';
import 'package:dal/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../business_logic_layer/user_provider.dart';
// import 'package:url_launcher/url_launcher.dart';

class MyDrawer extends StatefulWidget {
  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  bool logout = false;
  List<Map<String, dynamic>> items = [];
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    if (userProvider.userMode == 'seller') {
      items = [
        {
          'Icon': Icons.view_array,
          'Title': AppLocalizations.of(context).posts, //'المنشورات',
          'Route': SellerPostScreen.routeName,
          'Replace': false,
          'Argument': false,
        },
        {
          'Icon': Icons.push_pin_sharp,
          'Title': AppLocalizations.of(context).pendingPosts,
          'Route': SellerPostScreen.routeName,
          'Replace': false,
          'Argument': true,
        },
        {
          'Icon': Icons.shopping_bag,
          'Title': AppLocalizations.of(context).addProduct,
          'Route': AddPostScreen.routeName,
          'Replace': false,
        },
        {
          'Icon': Icons.settings,
          'Title': AppLocalizations.of(context).setting, //'إضافة منتج',
          'Route': SettingsScreen.routeName,
          'Replace': false,
        },
        {
          'Icon': Icons.logout,
          'Title': AppLocalizations.of(context).logout, //'إضافة منتج',
          'Route': LoginCardScreen.routeName,
          'Replace': true,
        },
      ];
    } else if (userProvider.userMode == 'customer') {
      items = [
        {
          'Icon': Icons.verified_user,
          'Title':
              AppLocalizations.of(context).followed, //'البائعون المتابعون',
          'Route': CustomerSellerFollower.routeName,
          'Replace': false,
          'Argument': false,
        },
        {
          'Icon': Icons.settings,
          'Title': AppLocalizations.of(context).setting, //'إضافة منتج',
          'Route': SettingsScreen.routeName,
          'Replace': false,
        },
        {
          'Icon': Icons.logout,
          'Title': AppLocalizations.of(context).logout, //'إضافة منتج',
          'Route': LoginCardScreen.routeName,
          'Replace': true,
        }
      ];
    }

    return Drawer(
      child: CachHelper.getData(key: 'userId') == null
          ? Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(children: [
                  buildDrawerHeader(),
                  buildDrawerItem(AppLocalizations.of(context).logIn,
                      Icons.login, LoginCardScreen.routeName, true, 1),
                ]),
                powerdByCHI(),

                // Expanded(child: powerdByCHI()),
                // powerdByCHI(),
              ],
            )
          : Column(
              children: [
                buildDrawerHeader(),
                buildUserProfileItem(
                    userProvider.profileImage, userProvider.userName),
                Expanded(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      var item = items[index];
                      return buildDrawerItem(item['Title'], item['Icon'],
                          item['Route'], item['Replace'], index);
                    },
                    separatorBuilder: (BuildContext context, _) =>
                        Divider(thickness: 0.3),
                  ),
                ),
                powerdByCHI()
              ],
            ),
    );
  }

  _launchURL() async {
    const url = 'https://www.facebook.com/chi.team.dev';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _buildYesNoDialog(String route) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Text(AppLocalizations.of(context).logout),
            content: Text(AppLocalizations.of(context).areYouSure),
            actions: <Widget>[
              TextButton(
                onPressed: () async {
                  CachHelper.removeData(key: 'token');
                  CachHelper.removeData(key: 'user');
                  CachHelper.removeData(key: 'userId');
                  CachHelper.removeData(key: 'posts');
                  await _deleteCacheDir();
                  Navigator.of(context).pop();
                  Navigator.of(context).pushReplacementNamed(route);
                  // Navigator.of(context).pop();
                },
                child: Text(
                  AppLocalizations.of(context).yes,
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  AppLocalizations.of(context).no,
                  style: TextStyle(color: AppColors.primary),
                ),
              ),
            ],
          );
        });
  }

  Widget buildDrawerItem(
      String title, IconData icon, String route, bool replace, int index) {
    return GestureDetector(
      onTap: () async {
        if (replace) {
          _buildYesNoDialog(route);
        } else {
          // Navigator.of(context).pushNamed(route);
          if (items[index].keys.contains('Argument')) {
            Navigator.pushNamed(context, items[index]['Route'], arguments: {
              'isRequest': items[index]['Argument'],
              'userId': Provider.of<UserProvider>(context, listen: false).userId
            });
          } else
            Navigator.pushNamed(context, items[index]['Route']);
        }
      },
      child: ListTile(leading: Icon(icon), title: Text(title)),
    );
  }

  Widget buildDrawerHeader() {
    return DrawerHeader(
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
    );
  }

  Widget buildUserProfileItem(String profileImage, String userName) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamed(UserProfileScreen.routeName),
      //  {
      //   UserProfileScreen();
      // },
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.background,
          backgroundImage:
              NetworkImage('http://malldal.com/dal/' + profileImage),
        ),
        title: Text(userName),
      ),
    );
  }

  Widget powerdByCHI() {
    return Center(
      child: TextButton(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Powerd by ', style: TextStyle(color: Colors.black)),
                Text("CHI", style: TextStyle(color: Color(0XFFF05F23)))
              ],
            ),
          ),
        ),
        onPressed: _launchURL,
      ),
    );
  }

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
