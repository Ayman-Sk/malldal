import 'package:card_swiper/card_swiper.dart';
import 'package:dal/network/end_points.dart';
import 'package:dal/network/local_host.dart';
import 'package:dal/theme/app_colors.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../data_layer/models/account_type.dart';

class PostBodyWidget extends StatefulWidget {
  final String title;
  final String body;
  final String bio;
  final String phoneNumber;
  final List<String> postImagePaths;
  final String ownerId;
  PostBodyWidget({
    @required this.title,
    @required this.body,
    @required this.postImagePaths,
    this.ownerId,
    this.phoneNumber,
    this.bio,
  });

  @override
  _PostBodyWidgetState createState() => _PostBodyWidgetState();
}

class _PostBodyWidgetState extends State<PostBodyWidget> {
  Dio _dio = Dio();
  List<Widget> displayedAccounts = [];

  Map<int, Icon> types = {
    1: Icon(FontAwesomeIcons.phone, color: AppColors.primary),
    2: Icon(FontAwesomeIcons.whatsapp, color: Color(0xFF25D366)),
    3: Icon(FontAwesomeIcons.telegram, color: Color(0xFF229ED9)),
    4: Icon(FontAwesomeIcons.facebook, color: Color(0xFF4267B2)),
    5: Icon(FontAwesomeIcons.instagram, color: Color(0xFFE1306C))
  };
  AccountType accountType;
  @override
  void initState() {
    super.initState();
    _dio.post(EndPoints.getSellerContactInfo(widget.ownerId)).then((value) {
      accountType = AccountType.fromJson(value.data);
      setState(() {
        accountType.accounts.forEach(
          (element) =>
              displayedAccounts.add(_buildSellerAccountWidget(element)),
        );
      });
      print(accountType);
    });
  }

  @override
  Widget build(BuildContext context) {
    // List<String> images = ['img/1.jpg', 'img/2.jpg', 'img/3.jpg'];
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
      ),
      // color: Theme.of(context).cardColor,
      // margin: EdgeInsets.only(left: 10, right: 10),
      child: Stack(
        children: [
          CachHelper.getData(key: 'userId') == null
              ? Container()
              : Padding(
                  padding:
                      const EdgeInsets.only(bottom: 8.0, left: 8.0, right: 8.0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      icon: Icon(
                        Icons.info_outline,
                        color: AppColors.primary,
                      ),
                      onPressed: () {
                        Dio dio = Dio();
                        dio
                            .post(EndPoints.visitContactInfo(widget.ownerId))
                            .then((value) => print(value));
                        _buildUseriformationDialog();
                      },
                    ),
                  ),
                ),
          Column(
            children: [
              Expanded(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.only(
                      bottom: 1, left: 16, right: 16, top: 0),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
                        // title Of Post

                        Expanded(
                          flex: 1,
                          child: Align(
                            alignment: Alignment.topRight,
                            child: FittedBox(
                              child: Text(
                                widget.title,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
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
        ],
      ),
    );
  }

  Future _buildUseriformationDialog() {
    return showDialog(
      context: context,
      builder: (_) => Padding(
        padding: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height / 5,
            horizontal: MediaQuery.of(context).size.width / 10),
        child: Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(10),
          child: Container(
            height: MediaQuery.of(context).size.height / 2,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Theme.of(context).cardColor),
            padding: const EdgeInsets.all(4),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      AppLocalizations.of(context).additionalInformation,
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(widget.bio),
                  ),
                  Column(
                    children: displayedAccounts,
                  ),
                  // ListView.separated(
                  //   shrinkWrap: true,
                  //   itemCount: accountType.accounts.length,
                  //   itemBuilder: (context, index) =>
                  //       _buildSellerAccountWidget(accountType.accounts[index]),
                  //   separatorBuilder: (context, _) => Divider(),
                  // ),
                ],
              ),
            ),

            // SingleChildScrollView(

            // child: Column(
            //   children: [
            //     accountType.accounts.
            //     // Padding(
            //     //   padding: const EdgeInsets.only(top: 8.0),
            //     //   child: Text(
            //     //     AppLocalizations.of(context).contactNumber,
            //     //     style: TextStyle(
            //     //         color: AppColors.primary,
            //     //         fontWeight: FontWeight.bold),
            //     //   ),
            //     // ),
            //     // Padding(
            //     //   padding: const EdgeInsets.only(top: 8.0),
            //     //   child: Text(widget.phoneNumber),
            //     // ),
            //     // Padding(
            //     //   padding: const EdgeInsets.only(top: 8.0),
            //     //   child: Text(
            //     //     AppLocalizations.of(context).additionalInformation,
            //     //     style: TextStyle(
            //     //       color: AppColors.primary,
            //     //       fontWeight: FontWeight.bold,
            //     //     ),
            //     //   ),
            //     // ),
            //     // Padding(
            //     //   padding: const EdgeInsets.only(top: 8.0),
            //     //   child: Text(widget.bio),
            //     // )
            //   ],
            // ),
            // ),
          ),
        ),
      ),
      // ),
    );
  }

  Widget _buildSellerAccountWidget(Account account) {
    return ListTile(
      leading: types[int.parse(account.contactInfoTypeId)],
      title: Text(account.info),
    );
  }
}
