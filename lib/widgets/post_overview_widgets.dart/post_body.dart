import 'package:card_swiper/card_swiper.dart';
import 'package:dal/network/local_host.dart';
import 'package:dal/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PostBodyWidget extends StatefulWidget {
  final String title;
  final String body;
  final String bio;
  final String phoneNumber;
  final List<String> postImagePaths;
  PostBodyWidget({
    @required this.title,
    @required this.body,
    @required this.postImagePaths,
    this.phoneNumber,
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
                      onPressed: () {
                        _buildUseriformationDialog();
                      },
                      icon: Icon(
                        Icons.info_outline,
                        color: AppColors.primary,
                      ),
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
        padding: const EdgeInsets.symmetric(vertical: 240, horizontal: 32),
        child: Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(10),
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: <Widget>[
              Container(
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
                          AppLocalizations.of(context).contactNumber,
                          style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(widget.phoneNumber),
                      ),
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
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      // ),
    );
  }
}
