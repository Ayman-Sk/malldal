import 'package:card_swiper/card_swiper.dart';
import 'package:dal/network/local_host.dart';
import 'package:dal/screens/autharization/customer_signup_screen.dart';
import 'package:dal/screens/autharization/login_card_screen.dart';
import 'package:dal/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PostBodyWidget extends StatefulWidget {
  final String title;
  final String body;
  final String bio;
  final List<String> postImagePaths;
  PostBodyWidget({
    @required this.title,
    @required this.body,
    @required this.postImagePaths,
    this.bio,
  });

  @override
  _PostBodyWidgetState createState() => _PostBodyWidgetState();
}

class _PostBodyWidgetState extends State<PostBodyWidget> {
  @override
  Widget build(BuildContext context) {
    // List<String> images = ['img/1.jpg', 'img/2.jpg', 'img/3.jpg'];
    return Container(
      decoration: BoxDecoration(
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.grey,
        //     // offset: Offset(0.0, 0.0), //(x,y)
        //     blurRadius: 5.0,
        //   ),
        // ],
        color: Theme.of(context).cardColor,
      ),
      // color: Theme.of(context).cardColor,
      // margin: EdgeInsets.only(left: 10, right: 10),
      child: Column(
        children: [
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.only(
                  bottom: 1, left: 16, right: 16, top: 16),
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    // title Of Post
                    Expanded(
                      flex: 1,
                      child: Align(
                        alignment: Alignment.center,
                        child: FittedBox(
                          child: Container(
                            child: Text(
                              widget.title,
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 6,
                      child: Container(
                        padding: EdgeInsets.only(bottom: 8),
                        child: ListView(
                          children: [
                            Align(
                              alignment: Alignment.topRight,
                              child: Text(
                                widget.body,
                                style: TextStyle(
                                    // color: AppColors.primary,
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal,
                                    wordSpacing: 3,
                                    height: 1.3),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            CachHelper.getData(key: 'userId') != null
                                ? ExpansionTile(
                                    title: Text(
                                      AppLocalizations.of(context)
                                          .sellerContactInfo,
                                      style: TextStyle(
                                        color: AppColors.primary,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    onExpansionChanged: (value) {
                                      print(value);
                                    },
                                    children: <Widget>[
                                      ListTile(
                                        title: Text(
                                          widget.bio,
                                          style: TextStyle(
                                            // color: AppColors.primary,
                                            fontSize: 15,
                                            fontWeight: FontWeight.normal,
                                            wordSpacing: 3,
                                            height: 1.3,
                                          ),
                                        ),
                                      )
                                    ],
                                  )
                                // Column(
                                //     children: [
                                //       Container(
                                //         padding: EdgeInsets.only(bottom: 10),
                                //         child: Text(
                                //           AppLocalizations.of(context)
                                //               .sellerContactInfo,
                                //           // "معلومات التواصل مع البائع :",
                                //           style: TextStyle(
                                //             color: AppColors.primary,
                                //             fontSize: 20,
                                //             fontWeight: FontWeight.bold,
                                //           ),
                                //         ),
                                //       ),
                                //       Align(
                                //         // alignment: Alignment.topRight,
                                //         child: Text(
                                //           widget.bio,
                                //           style: TextStyle(
                                //             color: AppColors.primary,
                                //             fontSize: 15,
                                //             fontWeight: FontWeight.normal,
                                //             wordSpacing: 3,
                                //             height: 1.3,
                                //           ),
                                //         ),
                                //       ),
                                //     ],
                                //   )
                                : Column(
                                    children: [
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Align(
                                        alignment: Alignment.topRight,
                                        child: Text(
                                          AppLocalizations.of(context)
                                              .notAllowedSeeSellerInfo,
                                          // 'يجب أن تكون مسجلا لرؤية معلومات التواصل مع البائع',
                                          style: TextStyle(
                                            color: Colors.red,
                                            fontSize: 15,
                                            fontWeight: FontWeight.normal,
                                            wordSpacing: 3,
                                            height: 1.3,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            primary: AppColors.accent),
                                        onPressed: () => Navigator.of(context)
                                            .pushNamed(
                                                LoginCardScreen.routeName),
                                        child: Text(
                                          AppLocalizations.of(context).logIn,
                                          // 'تسجيل الدخول',
                                        ),
                                      ),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            primary: AppColors.accent),
                                        onPressed: () => Navigator.of(context)
                                            .pushNamed(CustomerSignupScreens
                                                .routeName),
                                        child: Text(
                                          AppLocalizations.of(context).signup,
                                          // 'إنشاء حساب',
                                        ),
                                      )
                                    ],
                                  ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Swiper(
              loop: false,
              itemCount: widget.postImagePaths.length, // images.length,
              pagination: const SwiperPagination(),
              control: const SwiperControl(),
              // indicatorLayout: PageIndicatorLayout.COLOR,

              autoplay: false,
              itemBuilder: (context, index) {
                final path = widget.postImagePaths[index]; //images[index];
                return Container(
                    height: MediaQuery.of(context).size.height / 2,
                    child: Image.network(
                      path,
                      fit: BoxFit.fill,
                    ));
              },
            ),
            // PostImagesWidget(),
          ),
        ],
      ),
    );
  }
}
