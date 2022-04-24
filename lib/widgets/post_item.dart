import 'package:card_swiper/card_swiper.dart';
import 'package:dal/data_layer/models/post_with_sellers_model.dart';
import 'package:dal/business_logic_layer/user_provider.dart';
import 'package:dal/data_layer/repositories/posts_repositories.dart';
import 'package:dal/data_layer/repositories/reviews_repository.dart';
import 'package:dal/network/local_host.dart';
import 'package:dal/screens/overview_single_post_screen.dart';
import 'package:dal/theme/app_colors.dart';
import 'package:dal/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PostItem extends StatefulWidget {
  final int postId;
  final String title;
  final String nameOfSeller;
  final String body;
  final String priceDetails;
  final int avgRate;
  // final  int sellerId;
  final String createdAt;
  final List<String> paths;
  // final  List<String> postImages;
  // final SellerModel seller;
  // final  bool isInteract;
  // final  String ownerBio;
  final Seller ownerUser;
  final String price;

  PostItem({
    @required this.postId,
    this.title,
    this.nameOfSeller,
    this.body,
    this.priceDetails,
    this.createdAt,
    this.avgRate,
    // this.isInteract = false,
    this.ownerUser,
    this.price,
    this.paths,
  });

  @override
  _PostItemState createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {
  PostsRepositoryImp postsRepositoryImp = PostsRepositoryImp();
  // double rating = 0;
  bool isFav = false;

  bool isExpanded = false;
  final token = CachHelper.getData(key: 'token');
  bool isInteract = false;

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    if (userProvider.savedPosts != null) {
      isInteract = userProvider.savedPosts.contains(widget.postId);
    }
    // List<String> images = ['img/test.jpg', 'img/test.jpg', 'img/test.jpg'];
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .push(
          MaterialPageRoute(
            builder: (_) => OverviewSinglePostScreen(
              postId: widget.postId,
              postTitle: widget.title,
              postbody: widget.body,
              priceDetails: widget.priceDetails,
              createdAt: widget.createdAt,

              ownerUser: widget.ownerUser,
              postImagePaths: widget.paths,
              // isInteract: widget.isInteract,
              // toggleInteract: () => toggleInteract,
            ),
          ),
        )
            .then((value) {
          setState(() {
            if (userProvider.savedPosts != null)
              isInteract = userProvider.savedPosts.contains(widget.postId);
          });
        });
      },
      child: Container(
        child: Padding(
          padding: const EdgeInsets.only(top: 10, left: 5, right: 5),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor, //Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                  color: AppColors.primary.withOpacity(0.1), width: 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.black87,
                  offset: Offset(0.0, 1.0), //(x,y)
                  blurRadius: 10,
                ),
              ],
            ),
            height: 400,
            child: Column(
              children: [
                Expanded(
                  flex: 3,
                  child: ItemHeader(
                    nameOfSeller: widget.nameOfSeller,
                    createdAt: widget.createdAt,
                    titleOfPost: widget.title,
                    bodyOfPost: widget.body,
                    price: widget.price,
                    sellerProfileImage: widget.ownerUser.profileImage,
                  ),
                ),

                // images
                Expanded(
                  flex: 4,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 2,
                    child: Swiper(
                      loop: false,
                      itemCount: widget.paths.length,
                      pagination: const SwiperPagination(),
                      control: const SwiperControl(),
                      indicatorLayout: PageIndicatorLayout.COLOR,
                      autoplay: false,
                      itemBuilder: (context, index) {
                        final path = widget.paths[index];
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height / 2,
                          child: Image.network(
                            path,
                            fit: BoxFit.fill,
                          ),
                        );
                      },
                    ),
                  ),
                  //  GestureDetector(
                  //   onTap: () {
                  //     List<String> i = [
                  //       'img/test.jpg',
                  //       'img/test.jpg',
                  //       'img/test.jpg'
                  //     ];
                  //     Navigator.of(context).push(
                  //       MaterialPageRoute(
                  //         builder: (_) => PostImagesScreen(imgs: i),
                  //       ),
                  //     );
                  //   },
                  //   child: Container(
                  //     color: Colors.grey.withOpacity(0.1),
                  //     child: PostImagesWidget(),
                  //   ),
                  // ),
                ),

                // footer
                Expanded(
                  flex: 1,
                  child: Container(
                    child: Column(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Row(
                            children: [
                              //                 Expanded(
                              //                   flex: 1,
                              //                   child: Container(
                              //                     child: Center(
                              //                         child: IconButton(
                              //                       icon: Icon(
                              //                           // Icons.system_security_update_good
                              // // Icons.system_security_update
                              //                         isFav ? Icons.star : Icons.star_border,
                              //                         color: AppColors.focus,
                              //                         size: 20,
                              //                       ),
                              //                       onPressed: () {
                              //                         setState(
                              //                           () {
                              //                             if (isFav) {
                              //                               isFav = false;
                              //                               Utils.showToast(
                              //                                 message: 'أزيل من المفضلة',
                              //                                 backgroundColor:
                              //                                     AppColors.primary,
                              //                                 textColor: AppColors.background,
                              //                               );
                              //                             } else {
                              //                               isFav = true;
                              //                               Utils.showToast(
                              //                                 message:
                              //                                     'تمت الإضافة الى المفضلة',
                              //                                 backgroundColor:
                              //                                     AppColors.primary,
                              //                                 textColor: AppColors.background,
                              //                               );
                              //                             }
                              //                           },
                              //                         );
                              //                       },
                              //                     )),
                              //                   ),
                              //                 ),
                              // تقييم جديد
                              Expanded(
                                flex:
                                    CachHelper.getData(key: 'userId') != null &&
                                            Provider.of<UserProvider>(context)
                                                    .userMode !=
                                                'seller'
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
                                        style: TextStyle(
                                          // color: AppColors.primary,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Consumer<UserProvider>(
                                builder: (context, user, _) {
                                  return Expanded(
                                      flex: 1,
                                      child: userProvider.userId != null &&
                                              userProvider.userMode != 'seller'
                                          ? Container(
                                              child: Center(
                                                child: IconButton(
                                                  icon: Icon(
                                                    isInteract
                                                        ? Icons.favorite
                                                        : Icons.favorite_border,
                                                    color: AppColors.focus,
                                                    size: 20,
                                                  ),
                                                  onPressed: token != null
                                                      ? () async {
                                                          if (user.savedPosts
                                                              .contains(widget
                                                                  .postId)) {
                                                            bool res;
                                                            res = await postsRepositoryImp
                                                                .removePostFromFollowedPostsOfCustomer(
                                                              cutomerId:
                                                                  CachHelper
                                                                      .getData(
                                                                key: 'userId',
                                                              ),
                                                              postId:
                                                                  widget.postId,
                                                              token: token,
                                                            );
                                                            if (res) {
                                                              setState(() {
                                                                isInteract =
                                                                    false;
                                                              });
                                                              user.savedPosts
                                                                  .remove(widget
                                                                      .postId);
                                                              Utils.showToast(
                                                                message: AppLocalizations.of(
                                                                        context)
                                                                    .removePost,
                                                                // 'تم إلغاء التفاعل',
                                                                backgroundColor:
                                                                    AppColors
                                                                        .primary,
                                                                textColor: Theme.of(
                                                                        context)
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
                                                                    cutomerId:
                                                                        CachHelper
                                                                            .getData(
                                                                      key:
                                                                          'userId',
                                                                    ),
                                                                    postId: widget
                                                                        .postId,
                                                                    token:
                                                                        token);
                                                            if (res) {
                                                              setState(() {
                                                                isInteract =
                                                                    true;
                                                              });
                                                              user.savedPosts
                                                                  .add(widget
                                                                      .postId);

                                                              Utils.showToast(
                                                                message: AppLocalizations.of(
                                                                        context)
                                                                    .postFavorite,
                                                                // 'تفاعلت مع هذا المنشور',
                                                                backgroundColor:
                                                                    AppColors
                                                                        .primary,
                                                                textColor: Theme.of(
                                                                        context)
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
                                                                message: AppLocalizations.of(
                                                                        context)
                                                                    .favoriteRefused,
                                                                // 'حصل خطأ ما أثناء حفظ المنشور',
                                                                backgroundColor:
                                                                    AppColors
                                                                        .primary,
                                                                textColor: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .bodyText1
                                                                    .color,
                                                              );
                                                            }
                                                          }
                                                        }
                                                      : () {
                                                          Utils.showToast(
                                                            message: AppLocalizations
                                                                    .of(context)
                                                                .unregistered,
                                                            // 'يجب أن تكون مسجل في التطبيق',
                                                            backgroundColor:
                                                                AppColors
                                                                    .primary,
                                                            textColor: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .bodyText1
                                                                .color,
                                                          );
                                                        },
                                                ),
                                              ),
                                            )
                                          : Container());
                                },
                                // child: Expanded(
                                //     flex: 1,
                                //     child: Provider.of<UserProvider>(context)
                                //                     .userId !=
                                //                 null &&
                                //             Provider.of<UserProvider>(context)
                                //                     .userMode !=
                                //                 'seller'
                                //         ? Container(
                                //             child: Center(
                                //               child: IconButton(
                                //                 icon: Icon(
                                //                   widget.isInteract
                                //                       ? Icons.favorite
                                //                       : Icons.favorite_border,
                                //                   color: AppColors.focus,
                                //                   size: 20,
                                //                 ),
                                //                 onPressed: token != null
                                //                     ? () async {
                                //                         if (widget.isInteract) {
                                //                           bool res;
                                //                           res = await postsRepositoryImp
                                //                               .removePostFromFollowedPostsOfCustomer(
                                //                             cutomerId: CachHelper
                                //                                 .getData(
                                //                               key: 'userId',
                                //                             ),
                                //                             postId: widget.postId,
                                //                             token: token,
                                //                           );
                                //                           if (res) {
                                //                             setState(() {
                                //                               widget.isInteract =
                                //                                   false;
                                //                             });
                                //                             userProvider
                                //                                 .savedPosts
                                //                                 .remove(widget
                                //                                     .postId);
                                //                             // userProvider.user
                                //                             //     .followSellers
                                //                             //     .remove(widget
                                //                             //         .ownerUser
                                //                             //         .id);

                                //                             Utils.showToast(
                                //                               message:
                                //                                   'تم إلغاء التفاعل',
                                //                               backgroundColor:
                                //                                   AppColors
                                //                                       .primary,
                                //                               textColor: AppColors
                                //                                   .background,
                                //                             );
                                //                           }
                                //                         } else {
                                //                           print('bbbefffore');
                                //                           bool res;
                                //                           res = await postsRepositoryImp
                                //                               .addPostTofollowedPostsOfCustomer(
                                //                                   cutomerId:
                                //                                       CachHelper
                                //                                           .getData(
                                //                                     key: 'userId',
                                //                                   ),
                                //                                   postId: widget
                                //                                       .postId,
                                //                                   token: token);
                                //                           if (res) {
                                //                             setState(() {
                                //                               widget.isInteract =
                                //                                   true;
                                //                             });
                                //                             userProvider
                                //                                 .savedPosts
                                //                                 .add(widget
                                //                                     .postId);
                                //                             // userProvider.user
                                //                             //     .followSellers
                                //                             //     .add(widget
                                //                             //         .ownerUser
                                //                             //         .id);

                                //                             Utils.showToast(
                                //                               message:
                                //                                   'تفاعلت مع هذا المنشور',
                                //                               backgroundColor:
                                //                                   AppColors
                                //                                       .primary,
                                //                               textColor: AppColors
                                //                                   .background,
                                //                             );
                                //                             // Navigator.of(context)
                                //                             //     .pushReplacementNamed(
                                //                             //   MainTabBarViewController
                                //                             //       .routeName,
                                //                             // );
                                //                           } else {
                                //                             Utils.showToast(
                                //                               message:
                                //                                   'حصل خطأ ما أثناء حفظ المنشور',
                                //                               backgroundColor:
                                //                                   AppColors
                                //                                       .primary,
                                //                               textColor: AppColors
                                //                                   .background,
                                //                             );
                                //                           }
                                //                         }
                                //                       }
                                //                     : () {
                                //                         Utils.showToast(
                                //                           message:
                                //                               'يجب أن تكون مسجل في التطبيق',
                                //                           backgroundColor:
                                //                               AppColors.primary,
                                //                           textColor: AppColors
                                //                               .background,
                                //                         );
                                //                       },
                                //               ),
                                //             ),
                                //           )
                                //         : Container()),
                              ),
                            ],
                          ),
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

  void _buildReviewPopupDialog() async {
    ReviewRepositoryImp reviewRepositoryImp = ReviewRepositoryImp();
    TextEditingController ratingController = TextEditingController();
    double rating = 0;

    final ratingTextFielde = TextFormField(
      controller: ratingController,
      keyboardType: TextInputType.name,
      decoration: InputDecoration(
        labelStyle: TextStyle(
          color: AppColors.background,
        ),
        fillColor: Colors.white,
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
          return AppLocalizations.of(context).importantItem; //'هذا البند مهم';
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
            backgroundColor: Colors.transparent,
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
                      color: Theme.of(context).cardColor
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
                                  backgroundColor: AppColors.primary,
                                  textColor: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      .color,
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
                                print('text');
                                print(ratingController.text);
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
                                    //  'تم إضافة تقييم جديد',
                                    backgroundColor: AppColors.primary,
                                    textColor: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .color,
                                  );
                                  Navigator.of(context).pop();
                                } else {
                                  Utils.showToast(
                                    message: AppLocalizations.of(context)
                                        .reviewRefused,
                                    // 'تعذر إضافة التقييم',
                                    backgroundColor: AppColors.primary,
                                    textColor: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .color,
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

class ItemHeader extends StatelessWidget {
  final String nameOfSeller;
  final String createdAt;
  final String titleOfPost;
  final String bodyOfPost;
  final String price;
  final String sellerProfileImage;
  ItemHeader({
    @required this.nameOfSeller,
    @required this.createdAt,
    @required this.titleOfPost,
    @required this.bodyOfPost,
    @required this.price,
    @required this.sellerProfileImage,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 8),
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              radius: 30,
              backgroundColor: AppColors.accent,
              child: CircleAvatar(
                radius: 31,
                backgroundColor: Theme.of(context).colorScheme.background,
                backgroundImage: NetworkImage(
                  'http://malldal.com/dal/' + sellerProfileImage,
                ),
                // AssetImage(
                //   'img/test.jpg',
                // ),
              ),
            ),
            title: Text(
              nameOfSeller,
              style: TextStyle(
                // color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              createdAt.toString().substring(0, 10),
              style: TextStyle(
                  // color: AppColors.primary,
                  ),
            ),
            trailing: Text(
              price,
              style: TextStyle(
                color: Colors.yellowAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Center(
            child: Text(
              titleOfPost,
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  bodyOfPost,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                    wordSpacing: 3,
                    height: 1.3,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
