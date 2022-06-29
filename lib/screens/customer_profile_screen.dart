import 'dart:io';
import 'package:dal/business_logic_layer/user_provider.dart';
import 'package:dal/network/local_host.dart';
import 'package:dal/screens/autharization/customer_signup_screen.dart';
import 'package:dal/screens/autharization/login_card_screen.dart';
import 'package:dal/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'edit_customer_profile.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CustomerProfileScreen extends StatefulWidget {
  static const routeName = 'CustomerProfileScreen';
  @override
  _CustomerProfileScreenState createState() => _CustomerProfileScreenState();
}

class _CustomerProfileScreenState extends State<CustomerProfileScreen> {
  File file;

  @override
  Widget build(BuildContext context) {
    var customerProvider = Provider.of<UserProvider>(context);
    customerProvider.getUserToApp();

    int id = CachHelper.getData(key: 'userId');
    String userMode = customerProvider.userMode;

    double coverHeight = MediaQuery.of(context).size.height / 4;
    double imageHeight = MediaQuery.of(context).size.height / 8;
    return SafeArea(
      child: Scaffold(
        // drawer: MyDrawer(),
        // drawerScrimColor: AppColors.primary.withOpacity(0.7),
        appBar: AppBar(
          title: Text(
            AppLocalizations.of(context).title,
          ),
          centerTitle: true,
          backgroundColor: AppColors.primary,
          elevation: 10,
        ),
        body: id == null
            ? buildUnregisteredProfile(context)
            : buildRegisteredProfile(
                coverHeight,
                imageHeight,
                customerProvider,
                context,
                userMode,
              ),
      ),
    );
  }

  ListView buildRegisteredProfile(double coverHeight, double imageHeight,
      UserProvider customerProvider, BuildContext context, String userMode) {
    return ListView(
      children: [
        buildTop(
            coverHeight, imageHeight, customerProvider.profileImage, context),
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // ElevatedButton.icon(
                //   onPressed: () => Navigator.of(context)
                //       .pushNamed(EditCustomerProfileScreen.routeName),
                //   icon: Icon(Icons.edit),
                //   label: Text(
                //     AppLocalizations.of(context).edit,
                //     // 'تعديل'
                //   ),
                //   style: ElevatedButton.styleFrom(
                //     primary: AppColors.primary,
                //     shape: new RoundedRectangleBorder(
                //       borderRadius: new BorderRadius.circular(30.0),
                //     ),
                //   ),
                // ),
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
                title: AppLocalizations.of(context).name, // "الاسم",
                subTitle: customerProvider.user.name),
            accountInfoCard(
              icon: Icons.email,
              title: AppLocalizations.of(context).email,
              subTitle: customerProvider.user.phoneNumber,
            ),
            // accountInfoCard(
            //     icon: Icons.phone,
            //     title: AppLocalizations.of(context).phoneNumber, //"الرقم",
            //     subTitle: customerProvider.user.phoneNumber),
            // accountInfoCard(
            //     icon: Icons.location_on,
            //     title: AppLocalizations.of(context).city, // 'المدينة',
            //     subTitle: customerProvider.cityName),
            // accountInfoCard(
            //   icon:
            //       customerProvider.gender == 'male' ? Icons.male : Icons.female,
            //   title: AppLocalizations.of(context).gender, // "الجنس",
            //   subTitle: customerProvider.gender == 'male'
            //       ? AppLocalizations.of(context).male //'ذكر'
            //       : AppLocalizations.of(context).female, //'أنثى',
            // ),
            accountInfoCard(
              icon: userMode == 'customer'
                  ? Icons.attach_money
                  : Icons.sell_outlined,
              title: AppLocalizations.of(context).accountType, // 'نوع الحساب',
              subTitle: customerProvider.userMode == 'customer'
                  ? AppLocalizations.of(context).customer //'مشتري'
                  : AppLocalizations.of(context).seller, //'بائع',
            )
          ],
        )
      ],
    );
  }
}

Widget buildUnregisteredProfile(BuildContext context) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          AppLocalizations.of(context).unregistered,
          // 'يجب أن تكون مسجلا'
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(primary: AppColors.accent),
          onPressed: () =>
              Navigator.of(context).pushNamed(LoginCardScreen.routeName),
          child: Text(
            AppLocalizations.of(context).logIn,
            // 'تسجيل الدخول'
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(primary: AppColors.accent),
          onPressed: () =>
              Navigator.of(context).pushNamed(CustomerSignupScreens.routeName),
          child: Text(
            AppLocalizations.of(context).signup,
            // 'إنشاء حساب'
          ),
        )
      ],
    ),
  );
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
      // color: Colors.white,
      child: Image.asset(
        // Provider.of<UserProvider>(context, listen: false).profileImage,
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
      // backgroundColor: Colors.white,
      // foregroundColor: Colors.amber,
      // child: Container(
      //   color: Colors.brown,
      // ),
      // child: CachedNetworkImage(
      //   imageUrl: 'http://malldal.com/dal/' + profileImagePath,
      //   placeholder: (context, url) =>
      //       new CircularProgressIndicator(color: AppColors.primary),
      //   errorWidget: (context, url, error) =>
      //       new Icon(Icons.error, color: AppColors.primary),
      //       fadeOutDuration: const Duration(seconds: 1),
      //           fadeInDuration: const Duration(seconds: 3),
      // ),
      backgroundColor: Theme.of(context).colorScheme.background,

      backgroundImage: NetworkImage(
        'http://malldal.com/dal/' + profileImagePath,
      ),
      onBackgroundImageError: (object, stackTrace) {
        Icon(Icons.error);
      },
    );

Widget accountInfoCard({IconData icon, String title, String subTitle}) {
  return Card(
    elevation: 10,
    // color: Colors.white70,
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
