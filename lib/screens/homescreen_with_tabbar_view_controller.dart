import 'package:dal/business_logic_layer/all_posts_with_categories.dart';
import 'package:dal/business_logic_layer/user_provider.dart';
import 'package:dal/network/local_host.dart';
import 'package:dal/screens/main_taps/home_page_tap.dart';
import 'package:dal/screens/main_taps/customer_categories_Tab.dart';
import 'package:dal/screens/main_taps/followedposts_tap.dart';
import 'package:dal/screens/main_taps/user_profile_screen.dart';
import 'package:dal/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MainTabBarViewController extends StatefulWidget {
  static const routeName = 'MainTabBarViewController';
  @override
  _MainTabBarViewControllerState createState() =>
      _MainTabBarViewControllerState();
}

class _MainTabBarViewControllerState extends State<MainTabBarViewController>
    with WidgetsBindingObserver {
  // List<Widget> listScreens;
  int tabIndex = 0;
  // int userId = CachHelper.getData(key: 'userId');
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    Provider.of<AllPostsWithCategories>(context, listen: false).getPostsData();
    // Provider.of<UserProvider>(context, listen: false).getUserToApp();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached) return;
    final isBackground = state == AppLifecycleState.paused;
    if (isBackground) {
      print('we will save data');
      Provider.of<AllPostsWithCategories>(context, listen: false)
          .savePostsData();
      print('ayman');
      print('alaa');
    }
  }

  List<Widget> listScreens = [
    HomePageTap(),
    FollowedPostsTap(),
    CustomerCategoriesTap(),
    // UserProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    bool isMinimum = CachHelper.getData(key: 'userId') == null ||
        Provider.of<UserProvider>(context).userMode == 'seller';
    if (isMinimum) {
      listScreens = [
        HomePageTap(),
        // UserProfileScreen(),
      ];
    }
    if (isMinimum) {
      return Scaffold(
        body: listScreens[tabIndex],
      );
    } else {
      return Scaffold(
        body: listScreens[tabIndex],
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.primary.withOpacity(0.5),
          // backgroundColor: Colors.white,
          currentIndex: tabIndex,
          onTap: (int index) {
            setState(() {
              tabIndex = index;
              print(index);
            });
          },
          items: getItems(isMinimum),
        ),
      );
    }
  }

  List<BottomNavigationBarItem> getItems(bool minimum) {
    if (minimum) {
      return [
        BottomNavigationBarItem(
          icon: Icon(
            Icons.home_rounded,
          ),
          label: AppLocalizations.of(context).homePage,
        ),
        // BottomNavigationBarItem(
        //   icon: Icon(
        //     Icons.account_circle_rounded,
        //   ),
        //   label: AppLocalizations.of(context).profilePage,
        // )
      ];
    } else {
      return [
        BottomNavigationBarItem(
          icon: Icon(
            Icons.home_rounded,
          ),
          label: AppLocalizations.of(context).homePage,
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.favorite_border_rounded,
          ),
          activeIcon: Icon(Icons.favorite),
          label: AppLocalizations.of(context).favoritePage,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.system_security_update),
          label: AppLocalizations.of(context).categoryPage,
        ),
        // BottomNavigationBarItem(
        //   icon: Icon(
        //     Icons.account_circle_rounded,
        //   ),
        //   label: AppLocalizations.of(context).profilePage,
        // )
      ];
    }
  }
}
