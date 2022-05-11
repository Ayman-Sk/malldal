import 'package:dal/L10N/l10n.dart';
import 'package:dal/business_logic_layer/local_provider.dart';
import 'package:dal/business_logic_layer/user_provider.dart';
import 'package:dal/screens/introduction_screen.dart';
import 'package:dal/theme/app_colors.dart';
import 'package:dal/theme/my_theme_provider.dart';
import 'package:dal/widgets/dropdown_model.dart';
import 'package:dal/widgets/multi_selected_drop_down.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../network/local_host.dart';

class SettingsScreen extends StatefulWidget {
  static const routeName = 'SettingsScreen';
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    String language = AppLocalizations.of(context).language;
    final localeProvider = Provider.of<LocaleProvider>(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            AppLocalizations.of(context).setting,
            // 'أعدادات التطبيق',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          backgroundColor: AppColors.primary,
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              buildSettingCard(
                Icon(Icons.delete_forever),
                AppLocalizations.of(context).deleteAccount,
                // 'حذف حسابي'
                SizedBox.shrink(),
              ),
              Divider(
                thickness: 1,
              ),
              Padding(
                padding: EdgeInsets.all(12.0),
                // width: MediaQuery.of(context).size.width,
                child: DropdownButton(
                  elevation: 10,
                  hint: Row(
                    children: [
                      Icon(Icons.language),
                      SizedBox(
                        width: 10,
                      ),
                      Text(language),
                    ],
                  ),
                  isExpanded: true,
                  items: L10n.all.map((locale) {
                    return DropdownMenuItem(
                      value: locale,
                      child:
                          Text(localeProvider.getLanguage(locale.languageCode)),
                      onTap: () {
                        localeProvider.setLocale(locale);
                        setState(() {
                          language +=
                              localeProvider.getLanguage(locale.languageCode);
                        });
                        // Navigator.of(context).pushNamedAndRemoveUntil(
                        //     MainTabBarViewController.routeName,
                        //     (route) => false);
                      },
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      // print(value);
                      // language = value;
                    });
                  },
                ),
              ),
              ListTile(
                leading: Icon(themeProvider.isDarkMode
                    ? Icons.brightness_2
                    : Icons.wb_sunny),
                title: Text(AppLocalizations.of(context).theme),
                trailing: Switch.adaptive(
                  value: themeProvider.isDarkMode,
                  onChanged: (value) {
                    themeProvider.toggleTheme(value);
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDropDownList(
      {String title,
      List<String> listOfItems,
      Function() func,
      List<DropdownMenuItem<DropDownListModel>> items,
      bool isCities}) {
    print('aaaaaaaaaaaaassssssddddddd');
    print(isCities);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title,
            style: TextStyle(
              color: AppColors.primary,
              fontSize: 20,
            ),
          ),
        ),
        CustomMultiselectDropDown(
          listOFStrings: listOfItems,
          selectedList: addCityFunction,
        ),
      ],
    );
  }

  void addCityFunction(List<int> listOfItems) {
    listOfItems = listOfItems;
    print('Cities');
  }

  void _buildYesNoDialog(BuildContext ctx) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Text(AppLocalizations.of(context).delete),
            content: Text(AppLocalizations.of(context).areYouSureDelete),
            actions: <Widget>[
              TextButton(
                onPressed: () async {
                  // CachHelper.removeData(key: 'token');
                  // CachHelper.removeData(key: 'user');
                  // CachHelper.removeData(key: 'userId');
                  // CachHelper.removeData(key: 'posts');
                  // await _deleteCacheDir();

                  // Navigator.of(context).pop();
                  bool response =
                      await Provider.of<UserProvider>(context, listen: false)
                          .deleteUser();
                  if (response == true) {
                    CachHelper.removeData(key: 'token');
                    CachHelper.removeData(key: 'user');
                    CachHelper.removeData(key: 'userId');
                    CachHelper.removeData(key: 'posts');
                    await _deleteCacheDir();
                    Navigator.of(context).pop();
                    Navigator.of(context)
                        .pushReplacementNamed(IntroductionScreen.routeName);
                  }
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

  Future<void> _deleteCacheDir() async {
    final cacheDir = await getTemporaryDirectory();

    if (cacheDir.existsSync()) {
      cacheDir.deleteSync(recursive: true);
      print('delete cach memory done');
    }
  }

  // Future<void> _deleteAppDir() async {
  //   final appDir = await getApplicationSupportDirectory();

  //   if (appDir.existsSync()) {
  //     appDir.deleteSync(recursive: true);
  //     print('delete app memory done');
  //   }
  // }

  Widget buildSettingCard(Icon icon, String title, Widget trail) {
    return GestureDetector(
      onTap: () async {
        _buildYesNoDialog(context);
      },
      child: ListTile(
        leading: icon,
        title: Text(title),
        trailing: trail,
      ),
    );
  }
}
