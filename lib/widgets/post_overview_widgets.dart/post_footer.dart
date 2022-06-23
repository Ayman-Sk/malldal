import 'package:dal/business_logic_layer/user_provider.dart';
import 'package:dal/data_layer/repositories/posts_repositories.dart';
import 'package:dal/data_layer/repositories/reviews_repository.dart';
import 'package:dal/network/end_points.dart';
import 'package:dal/network/local_host.dart';
import 'package:dal/theme/app_colors.dart';
import 'package:dal/utils/utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../Post/review_dialog.dart';

// ignore: must_be_immutable
class PostFooterWidget extends StatefulWidget {
  // final int avgRate;
  final int postId;
  bool isInteract;
  final Function toggleInteract;
  final int sellerId;
  PostFooterWidget({
    // @required this.avgRate,
    @required this.sellerId,
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
  String token = CachHelper.getData(key: 'token');
  PostsRepositoryImp postsRepositoryImp = PostsRepositoryImp();
  Dio _dio = Dio();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    print('isInteract');
    print(widget.isInteract);

    return Container(
      padding: EdgeInsets.only(bottom: 10),
      child: Container(
        padding: EdgeInsets.all(10),
        child: Row(
          children: [
            CachHelper.getData(key: 'userId') != null
                ? Expanded(flex: 1, child: ReviewDialog(postId: widget.postId))
                : Container(),
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
                                              textColor: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1
                                                  .color,
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
                                              textColor: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1
                                                  .color,
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
                                              textColor: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1
                                                  .color,
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
                                          textColor: Theme.of(context)
                                              .textTheme
                                              .bodyText1
                                              .color,
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

  Future<void> getSellerContactInfo() async {
    final res =
        await _dio.post(EndPoints.getSellerContactInfo(widget.sellerId));
    if (res != null) {}
  }

  TextFormField _buildRatingTextFormField(
      TextEditingController ratingController) {
    return TextFormField(
      controller: ratingController,
      keyboardType: TextInputType.name,
      decoration: InputDecoration(
        labelStyle: const TextStyle(
          color: AppColors.background,
        ),
        fillColor: Colors.white,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(
            color: AppColors.background,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(
            color: AppColors.background,
            width: 2.0,
          ),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return AppLocalizations.of(context).importantItem;
        }
        return null;
      },
    );
  }

  Widget _buildSvgPicture({
    double width,
    double height,
    double top = 0,
    double left = 0,
    double right = 0,
  }) {
    return Positioned(
      top: top,
      right: right,
      left: left,
      child: SvgPicture.asset(
        'img/hp_gold_star.svg',
        width: width,
        height: height,
      ),
    );
  }

  Widget _buildDialogButton({
    String buttonLabel,
    bool isSendButton,
    int rating = 0,
    String notes = '',
  }) {
    return ElevatedButton(
      child: Text(buttonLabel,
          style: TextStyle(
              fontSize: 15,
              color: Theme.of(context).textTheme.bodyLarge.color)),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.grey[350]),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          ),
        ),
      ),
      onPressed: () async {
        if (!isSendButton) {
          Navigator.of(context).pop();
        } else {
          ReviewRepositoryImp reviewRepositoryImp = ReviewRepositoryImp();
          bool res;
          res = await reviewRepositoryImp.addReviewToSinglePost(
            rate: rating.toInt(),
            notes: 'asdsd', //notes,
            postId: widget.postId,
            customerId: CachHelper.getData(key: 'userId'),
          );
          if (res) {
            Utils.showToast(
              message: AppLocalizations.of(context).reviewAdded,
              //  'تم إضافة تقييم جديد',
              backgroundColor: AppColors.primary,
              textColor: Theme.of(context).textTheme.bodyText1.color,
            );
            Navigator.of(context).pop();
          } else {
            Utils.showToast(
              message: AppLocalizations.of(context).reviewRefused,
              // 'تعذر إضافة التقييم',
              backgroundColor: AppColors.primary,
              textColor: Theme.of(context).textTheme.bodyText1.color,
            );
          }
        }
      },
    );
  }

  void _buildReviewPopupDialog() async {
    TextEditingController ratingController = TextEditingController();
    double rating = 0;

    final ratingTextFielde = _buildRatingTextFormField(ratingController);

    return showDialog(
      context: context,
      builder: (_) => SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 240, horizontal: 32),
          child: Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: const EdgeInsets.all(10),
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: <Widget>[
                _buildSvgPicture(width: 50, height: 50, top: -60),
                _buildSvgPicture(width: 30, height: 30, top: -35, left: 100),
                _buildSvgPicture(width: 30, height: 30, top: -35, right: 100),
                Container(
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
                            AppLocalizations.of(context).rateReview,
                            style: const TextStyle(fontSize: 15),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: SizedBox(
                            height: 30,
                            width: 200,
                            child: ratingTextFielde,
                          ),
                        ),
                        RatingBar.builder(
                          initialRating: rating,
                          minRating: 0,
                          itemSize: 25,
                          allowHalfRating: true,
                          itemPadding:
                              const EdgeInsets.symmetric(horizontal: 5),
                          itemBuilder: (context, _) => const Icon(
                            Icons.star,
                            color: AppColors.focus,
                          ),
                          updateOnDrag: true,
                          onRatingUpdate: (rat) {
                            setState(() {
                              rating = rat;
                            });
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildDialogButton(
                              buttonLabel: AppLocalizations.of(context).cancel,
                              isSendButton: false,
                            ),
                            _buildDialogButton(
                              buttonLabel: AppLocalizations.of(context).send,
                              isSendButton: true,
                              rating: rating.toInt(),
                              notes: ratingController.text,
                            )
                          ],
                        ),
                      ],
                    ),
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
