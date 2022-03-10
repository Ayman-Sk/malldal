import 'package:dal/business_logic_layer/user_provider.dart';
import 'package:dal/data_layer/repositories/posts_repositories.dart';
import 'package:dal/data_layer/repositories/reviews_repository.dart';
import 'package:dal/network/local_host.dart';
import 'package:dal/theme/app_colors.dart';
import 'package:dal/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// ignore: must_be_immutable
class PostFooterWidget extends StatefulWidget {
  final int avgRate;
  final int postId;
  bool isInteract;
  final Function toggleInteract;
  PostFooterWidget({
    @required this.avgRate,
    @required this.postId,
    @required this.isInteract,
    @required this.toggleInteract,
  });
  @override
  _PostFooterWidgetState createState() => _PostFooterWidgetState();
}

class _PostFooterWidgetState extends State<PostFooterWidget> {
  double rating = 0;
  bool isFav = false;
  // bool isInteract = false;
  String token = CachHelper.getData(key: 'token');
  PostsRepositoryImp postsRepositoryImp = PostsRepositoryImp();

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    if (userProvider.savedPosts != null) {
      widget.isInteract = userProvider.savedPosts.contains(widget.postId);
    }

    return Container(
      padding: EdgeInsets.only(bottom: 10),
      // margin: EdgeInsets.only(right: 10, left: 10),
      child: Container(
        padding: EdgeInsets.all(10),
        // decoration: BoxDecoration(
        //   color: Theme.of(context).cardColor,
        //   // color: Colors.white,
        //   borderRadius: BorderRadius.only(
        //     bottomLeft: Radius.circular(20),
        //     bottomRight: Radius.circular(20),
        //   ),
        //   border:
        //       Border.all(color: AppColors.primary.withOpacity(0.1), width: 1),
        // ),
        child: Row(
          children: [
            // CachHelper.getData(key: 'userId') != null &&
            //         Provider.of<UserProvider>(context).userMode != 'seller'
            //     ? Expanded(
            //         flex: 1,
            //         child: Container(
            //           child: Center(
            //               child: IconButton(
            //             icon: Icon(
            //               isFav ? Icons.star : Icons.star_border,
            //               color: AppColors.focus,
            //               size: 20,
            //             ),
            //             onPressed: () {
            //               setState(
            //                 () {
            //                   if (isFav) {
            //                     isFav = false;
            //                     Utils.showToast(
            //                       message: 'أزيل من المفضلة',
            //                       backgroundColor: AppColors.primary,
            //                       textColor: AppColors.background,
            //                     );
            //                   } else {
            //                     isFav = true;
            //                     Utils.showToast(
            //                       message: 'تمت الإضافة الى المفضلة',
            //                       backgroundColor: AppColors.primary,
            //                       textColor: AppColors.background,
            //                     );
            //                   }
            //                 },
            //               );
            //             },
            //           )),
            //         ),
            //       )
            //     : Container(),
            Expanded(
              flex: CachHelper.getData(key: 'userId') != null &&
                      Provider.of<UserProvider>(context).userMode != 'seller'
                  ? 1
                  : 100,
              child: GestureDetector(
                onTap: () {
                  _buildReviewPopupDialog();
                  // print(
                  //   '%%%%\n${CachHelper.getData(key: 'userId')}\n%%%%',
                  // );
                },
                child: Chip(
                  label: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      AppLocalizations.of(context).rate,
                      // 'تقييم المنشور',
                      style: TextStyle(
                        // color: AppColors.primary,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Expanded(
            //   flex: 1,
            //   child: Container(
            //     child: Center(
            //       child: RatingBar.builder(
            //         initialRating: double.tryParse(widget.avgRate.toString()),
            //         minRating: 0,
            //         itemSize: 20,
            //         itemBuilder: (context, _) => Icon(
            //           Icons.star,
            //           color: AppColors.focus,
            //         ),
            //         updateOnDrag: true,
            //         onRatingUpdate: (rating) {
            //           setState(() {
            //             this.rating = rating;
            //             Utils.showToast(
            //               message: 'تقييم جديد: ${rating.round()}',
            //               backgroundColor: AppColors.primary,
            //               textColor: AppColors.background,
            //             );
            //           });
            //         },
            //       ),
            //     ),
            //   ),
            // ),
            CachHelper.getData(key: 'userId') != null &&
                    Provider.of<UserProvider>(context).userMode != 'seller'
                ? Expanded(
                    flex: 1,
                    child: Provider.of<UserProvider>(context).userId != null &&
                            Provider.of<UserProvider>(context).userMode !=
                                'seller'
                        ? Container(
                            child: Center(
                              child: IconButton(
                                icon: Icon(
                                  widget.isInteract
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: AppColors.focus,
                                  size: 20,
                                ),
                                onPressed: token != null
                                    ? () async {
                                        if (userProvider.savedPosts
                                            .contains(widget.postId)) {
                                          bool res;
                                          res = await postsRepositoryImp
                                              .removePostFromFollowedPostsOfCustomer(
                                                  cutomerId: CachHelper.getData(
                                                    key: 'userId',
                                                  ),
                                                  postId: widget.postId,
                                                  token: token);
                                          if (res) {
                                            setState(() {
                                              widget.isInteract = false;
                                              widget.toggleInteract();
                                            });
                                            userProvider.savedPosts
                                                .remove(widget.postId);
                                            Utils.showToast(
                                              message:
                                                  AppLocalizations.of(context)
                                                      .removePost,
                                              // 'تم إلغاء التفاعل',
                                              backgroundColor:
                                                  AppColors.primary,
                                              textColor: AppColors.background,
                                            );
                                          }
                                        } else {
                                          print('bbbefffore');
                                          bool res;
                                          res = await postsRepositoryImp
                                              .addPostTofollowedPostsOfCustomer(
                                                  cutomerId: CachHelper.getData(
                                                    key: 'userId',
                                                  ),
                                                  postId: widget.postId,
                                                  token: token);
                                          if (res) {
                                            setState(() {
                                              widget.isInteract = true;
                                              widget.toggleInteract();
                                            });
                                            userProvider.savedPosts
                                                .add(widget.postId);

                                            Utils.showToast(
                                              message:
                                                  AppLocalizations.of(context)
                                                      .postFavorite,
                                              //  'تفاعلت مع هذا المنشور',
                                              backgroundColor:
                                                  AppColors.primary,
                                              textColor: AppColors.background,
                                            );
                                            // Navigator.of(context)
                                            //     .pushReplacementNamed(
                                            //   MainTabBarViewController
                                            //       .routeName,
                                            // );
                                          } else {
                                            Utils.showToast(
                                              message:
                                                  AppLocalizations.of(context)
                                                      .favoriteRefused,
                                              // 'حصل خطأ ما أثناء حفظ المنشور',
                                              backgroundColor:
                                                  AppColors.primary,
                                              textColor: AppColors.background,
                                            );
                                          }
                                        }
                                      }
                                    : () {
                                        Utils.showToast(
                                          message: AppLocalizations.of(context)
                                              .unregistered,
                                          // 'يجب أن تكون مسجل في التطبيق',
                                          backgroundColor: AppColors.primary,
                                          textColor: AppColors.background,
                                        );
                                      },
                              ),
                            ),
                          )
                        : Container())
                : Container()
          ],
        ),
      ),
    );
  }

  void _buildReviewPopupDialog() async {
    ReviewRepositoryImp reviewRepositoryImp = ReviewRepositoryImp();
    TextEditingController ratingController = TextEditingController();
    double rating = 0;

    final ratingTextFielde = TextFormField(
      controller: ratingController,
      keyboardType: TextInputType.name,
      decoration: InputDecoration(
        labelStyle: TextStyle(
            // color: AppColors.background,
            ),
        // fillColor: Colors.white,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: AppColors.background,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: AppColors.background,
            width: 2.0,
          ),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'هذا البند مهم';
        }
        return null;
      },
      // onSaved: (value) {
      //   addMalkanprovider.area = int.tryParse(_areacontroller.text);
      // },
    );

    return showDialog(
      context: context,
      builder: (_) => SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 240, horizontal: 32),
          child: Dialog(
            // backgroundColor: Colors.transparent,
            insetPadding: EdgeInsets.all(10),
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: <Widget>[
                Container(
                  // width: double.infinity,
                  // height:700,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    // color: Colors.white,
                  ),
                  padding: EdgeInsets.all(4),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            AppLocalizations.of(context).rateReview,
                            // "تقييمك وملاحظاتك",
                            style: TextStyle(fontSize: 15),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        // Text Field
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Container(
                            height: 30,
                            width: 200,
                            child: ratingTextFielde,
                          ),
                        ),
                        ///////
                        Container(
                          child: RatingBar.builder(
                            initialRating: rating,
                            // initialRating:
                            // double.tryParse(widget.avgRate.toString()),
                            minRating: 0,
                            itemSize: 10,
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: AppColors.focus,
                            ),
                            updateOnDrag: true,
                            onRatingUpdate: (rat) {
                              setState(() {
                                rating = rat;
                                Utils.showToast(
                                  message:
                                      AppLocalizations.of(context).newRate +
                                          (rating.toInt()).toString(),
                                  // 'تقييم جديد: ${rating.toInt()}',
                                  backgroundColor: AppColors.primary,
                                  textColor: AppColors.background,
                                );
                              });
                            },
                          ),
                        ),
                        ///////
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: Chip(
                                label: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    AppLocalizations.of(context).cancel,
                                    // 'إلغاء',
                                    style: TextStyle(
                                      // color: AppColors.primary,
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            //
                            GestureDetector(
                              onTap: () async {
                                bool res;
                                res = await reviewRepositoryImp
                                    .addReviewToSinglePost(
                                  rate: rating.toInt(),
                                  notes: ratingController.text,
                                  postId: widget.postId,
                                  customerId: CachHelper.getData(key: 'userId'),
                                );
                                if (res) {
                                  Utils.showToast(
                                    message: AppLocalizations.of(context)
                                        .reviewAdded,
                                    // 'تم إضافة تقييم جديد',
                                    backgroundColor: AppColors.primary,
                                    textColor: AppColors.background,
                                  );
                                  Navigator.of(context).pop();
                                } else {
                                  Utils.showToast(
                                    message: AppLocalizations.of(context)
                                        .reviewRefused,
                                    // 'تعذر إضافة التقييم',
                                    backgroundColor: AppColors.primary,
                                    textColor: AppColors.background,
                                  );
                                }
                              },
                              child: Chip(
                                label: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    AppLocalizations.of(context).send,
                                    // 'إرسال',
                                    style: TextStyle(
                                      // color: AppColors.primary,
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: -60,
                  child: SvgPicture.asset(
                    'img/hp_gold_star.svg',
                    width: 50,
                    height: 50,
                  ),
                ),
                Positioned(
                  top: -35,
                  left: 70,
                  child: SvgPicture.asset(
                    'img/hp_gold_star.svg',
                    width: 30,
                    height: 30,
                  ),
                ),
                Positioned(
                  top: -35,
                  right: 70,
                  child: SvgPicture.asset(
                    'img/hp_gold_star.svg',
                    width: 30,
                    height: 30,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
