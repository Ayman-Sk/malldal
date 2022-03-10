import 'package:dal/L10N/l10n.dart';
import 'package:dal/business_logic_layer/local_provider.dart';
import 'package:dal/business_logic_layer/user_provider.dart';
import 'package:dal/screens/introduction_screen.dart';
import 'package:dal/theme/app_colors.dart';
import 'package:dal/theme/my_theme_provider.dart';
import 'package:dal/widgets/dropdown_model.dart';
import 'package:dal/widgets/multi_selected_drop_down.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

              // buildSettingCard(
              //   Icon(Icons.language),
              //   textValue,
              //   Switch(
              //     onChanged: toggleSwitch,
              //     value: isSwitched,
              //     activeColor: Colors.blue,
              //     activeTrackColor: Colors.blue[200],
              //     inactiveThumbColor: Colors.blue,
              //     inactiveTrackColor: Colors.blue[200],
              //   ),
              // )
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

  Widget buildSettingCard(Icon icon, String title, Widget trail) {
    return GestureDetector(
      onTap: () async {
        bool response = await Provider.of<UserProvider>(context, listen: false)
            .deleteUser();
        if (response == true) {
          Navigator.of(context).pushNamed(IntroductionScreen.routeName);
        }
      },
      child: ListTile(
        leading: icon,
        title: Text(title),
        trailing: trail,
      ),
    );
  }
}
