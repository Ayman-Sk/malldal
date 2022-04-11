import 'package:dal/business_logic_layer/user_provider.dart';
import 'package:dal/data_layer/data_providers/customer_apis.dart';
import 'package:dal/data_layer/models/post_with_sellers_model.dart';
import 'package:dal/network/local_host.dart';
import 'package:dal/screens/autharization/customer_signup_screen.dart';
import 'package:dal/screens/overview_seller_profile_Screen.dart';
import 'package:dal/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PostHeaderWidget extends StatefulWidget {
  // final String imgUrl;
  final String sellerName;
  final String createdAt;
  final Seller ownerUser;
  PostHeaderWidget({
    // @required this.imgUrl,
    @required this.sellerName,
    @required this.createdAt,
    @required this.ownerUser,
  });

  @override
  State<PostHeaderWidget> createState() => _PostHeaderWidgetState();
}

class _PostHeaderWidgetState extends State<PostHeaderWidget> {
  bool isFollowed;
  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context);

    setState(() {
      if (CachHelper.getData(key: 'userId') != null &&
          userProvider.user.followSellers != null)
        isFollowed =
            userProvider.user.followSellers.contains(widget.ownerUser.id);
      else
        isFollowed = false;
      print('isssssssssssssssssssFolloweeed');
      print(isFollowed);
      print(Provider.of<UserProvider>(context).user.followSellers);
    });
    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Container(
          padding: const EdgeInsets.only(
            top: 8,
            bottom: 8,
          ),
          // decoration: BoxDecoration(
          //   // color: Colors.white,

          //   color: Theme.of(context).cardColor,
          //   borderRadius: BorderRadius.only(
          //     topLeft: Radius.circular(20),
          //     topRight: Radius.circular(20),
          //   ),
          //   border: Border.all(
          //     color: AppColors.primary.withOpacity(0.1),
          //     width: 1,
          //   ),
          // ),
          child: ListTile(
            leading: Container(
              child: CircleAvatar(
                radius: 31,
                backgroundColor: AppColors.accent,
                child: CircleAvatar(
                  radius: 30,
                  backgroundColor: Theme.of(context).colorScheme.background,
                  backgroundImage: NetworkImage(
                    'http://malldal.com/dal/' + widget.ownerUser.profileImage,
                  ),
                  // AssetImage(
                  //   'img/test.jpg',
                  // ),
                ),
              ),
            ),
            title: Text(
              widget.sellerName,
              style: TextStyle(
                // color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              widget.createdAt.toString().substring(0, 9),
              style: TextStyle(
                  // color: AppColors.primary,
                  ),
            ),
            trailing: userProvider.userMode != 'seller' &&
                    CachHelper.getData(key: 'userId') != null
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        CustomerApis apis = CustomerApis();
                        if (!isFollowed) {
                          bool res =
                              await apis.addSellerTofollowedUserOfCustomer(
                                  customerId: userProvider.userId,
                                  sellerId: widget.ownerUser.id,
                                  token: CachHelper.getData(key: 'token'));
                          print(res);
                          if (res == true) {
                            setState(() {
                              isFollowed = true;
                            });
                            userProvider.user.followSellers
                                .add(widget.ownerUser.id);
                          }
                          return res;
                        } else {
                          bool res =
                              await apis.removeSellerTofollowedUserOfCustomer(
                                  customerId: userProvider.userId,
                                  sellerId: widget.ownerUser.id,
                                  token: CachHelper.getData(key: 'token'));
                          print(res);
                          if (res == true) {
                            setState(() {
                              isFollowed = false;
                            });
                            userProvider.user.followSellers
                                .remove(widget.ownerUser.id);
                          }
                          return res;
                        }
                      },
                      icon: userProvider.user.followSellers
                              .contains(widget.ownerUser.id)
                          ? Icon(Icons.person_add_disabled)
                          : Icon(Icons.person_add_alt),
                      label: userProvider.user.followSellers
                              .contains(widget.ownerUser.id)
                          ? Text(AppLocalizations.of(context)
                              .unfollow) //إلغاء المتابعة
                          : Text(AppLocalizations.of(context).follow), //متابعة
                      style: ElevatedButton.styleFrom(
                        primary: AppColors.primary,
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0),
                        ),
                      ),
                    ),
                  )
                : Container(
                    width: 0.01,
                  ),
          ),
        ),
      ),
      onTap: () {
        Navigator.of(context)
            .pushNamed(OverviewSellerProfileScreen.routeName,
                arguments: widget.ownerUser)
            .then((_) {
          setState(() {
            userProvider.user.followSellers.contains(widget.ownerUser.id);
          });
        });
      },
    );
  }

  Future<void> openDiaog() async {
    switch (await showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return SimpleDialog(
          backgroundColor: Colors.white,
          title: Center(
              child: Text(
            AppLocalizations.of(context).unregistered,
            // '.يجب أن تكون مسجلا" في التطبيق',
            style: TextStyle(
              // color: AppColors.primary,
              height: 1.2,
            ),
          )),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(CustomerSignupScreens.routeName);
              },
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).pushReplacementNamed(
                          CustomerSignupScreens.routeName);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: 130,
                      height: 50,
                      color: AppColors.primary,
                      child: Text(
                        AppLocalizations.of(context).logIn,
                        // "تسجيل",
                        style: TextStyle(
                          // color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Center(
                child: Text(
                  AppLocalizations.of(context).back,
                  // "رجوع",
                  style: TextStyle(
                    // color: AppColors.primary,
                    fontWeight: FontWeight.w200,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    )) {
      case CustomerSignupScreens.routeName:
        print('CustomerSignupScreens');
        break;
    }
  }
}
