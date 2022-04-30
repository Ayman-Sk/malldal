import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../data_layer/repositories/reviews_repository.dart';
import '../../network/local_host.dart';
import '../../theme/app_colors.dart';
import '../../utils/utils.dart';

class ReviewDialog extends StatefulWidget {
  final int postId;
  const ReviewDialog({Key key, this.postId}) : super(key: key);

  @override
  State<ReviewDialog> createState() => _ReviewDialogState();
}

class _ReviewDialogState extends State<ReviewDialog> {
  @override
  Widget build(BuildContext context) {
    double rating = 0;
    TextEditingController ratingController = TextEditingController();
    ReviewRepositoryImp reviewRepositoryImp = ReviewRepositoryImp();
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
    return Expanded(
      flex: 1,
      child: GestureDetector(
        onTap: () {
          showDialog(
            context: context,
            builder: (_) => SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 240, horizontal: 32),
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
                                      // Utils.showToast(
                                      //   message: AppLocalizations.of(context)
                                      //           .newRate +
                                      //       (rating.toInt()).toString(),
                                      //   backgroundColor: AppColors.primary,
                                      //   textColor: Theme.of(context)
                                      //       .textTheme
                                      //       .bodyText1
                                      //       .color,
                                      // );
                                    });
                                  },
                                ),
                              ),
                              ///////
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
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
                                        customerId:
                                            CachHelper.getData(key: 'userId'),
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
        },
        child: Chip(
          label: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              AppLocalizations.of(context).rate,
              style: const TextStyle(fontSize: 10),
            ),
          ),
        ),
      ),
    );
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
    int rating,
    String notes,
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
          print('!!!!!!!!!!!!');
          print(rating);
          print(notes);
          // ratingController.clear();
          Navigator.of(context).pop();
        } else {
          print('rrrrr');
          print(rating);
          print(notes);
          ReviewRepositoryImp reviewRepositoryImp = ReviewRepositoryImp();
          bool res;
          res = await reviewRepositoryImp.addReviewToSinglePost(
            rate: rating.toInt(),
            notes: notes,
            postId: widget.postId,
            customerId: CachHelper.getData(key: 'userId'),
          );
          print('print res');
          print(res);
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

  // void _buildReviewPopupDialog() async {
  //   double rating = 0;

  //   // final ratingTextFielde = _buildRatingTextFormField(ratingController);
  //   ratingController.text = '';
  //   return showDialog(
  //     context: context,
  //     builder: (_) => SingleChildScrollView(
  //       child: Padding(
  //         padding: const EdgeInsets.symmetric(vertical: 240, horizontal: 32),
  //         child: Dialog(
  //           backgroundColor: Colors.transparent,
  //           insetPadding: const EdgeInsets.all(10),
  //           child: Stack(
  //             clipBehavior: Clip.none,
  //             alignment: Alignment.center,
  //             children: <Widget>[
  //               _buildSvgPicture(width: 50, height: 50, top: -60),
  //               _buildSvgPicture(width: 30, height: 30, top: -35, left: 100),
  //               _buildSvgPicture(width: 30, height: 30, top: -35, right: 100),
  //               Container(
  //                 decoration: BoxDecoration(
  //                     borderRadius: BorderRadius.circular(15),
  //                     color: Theme.of(context).cardColor),
  //                 padding: const EdgeInsets.all(4),
  //                 child: SingleChildScrollView(
  //                   child: Column(
  //                     children: [
  //                       Padding(
  //                         padding: const EdgeInsets.only(top: 8.0),
  //                         child: Text(
  //                           AppLocalizations.of(context).rateReview,
  //                           style: const TextStyle(fontSize: 15),
  //                           textAlign: TextAlign.center,
  //                         ),
  //                       ),
  //                       Padding(
  //                         padding: const EdgeInsets.all(20.0),
  //                         child: SizedBox(
  //                           height: 30,
  //                           width: 200,
  //                           child: TextFormField(
  //                             controller: ratingController,
  //                             keyboardType: TextInputType.name,
  //                             decoration: InputDecoration(
  //                               labelStyle: const TextStyle(
  //                                 color: AppColors.background,
  //                               ),
  //                               fillColor: Colors.white,
  //                               focusedBorder: OutlineInputBorder(
  //                                 borderRadius: BorderRadius.circular(10.0),
  //                                 borderSide: const BorderSide(
  //                                   color: AppColors.background,
  //                                 ),
  //                               ),
  //                               enabledBorder: OutlineInputBorder(
  //                                 borderRadius: BorderRadius.circular(10.0),
  //                                 borderSide: const BorderSide(
  //                                   color: AppColors.background,
  //                                   width: 2.0,
  //                                 ),
  //                               ),
  //                             ),
  //                             validator: (value) {
  //                               if (value == null || value.isEmpty) {
  //                                 return AppLocalizations.of(context)
  //                                     .importantItem;
  //                               }
  //                               return null;
  //                             },
  //                           ),
  //                         ),
  //                       ),
  //                       RatingBar.builder(
  //                         initialRating: rating,
  //                         minRating: 0,
  //                         itemSize: 25,
  //                         allowHalfRating: true,
  //                         itemPadding:
  //                             const EdgeInsets.symmetric(horizontal: 5),
  //                         itemBuilder: (context, _) => const Icon(
  //                           Icons.star,
  //                           color: AppColors.focus,
  //                         ),
  //                         updateOnDrag: true,
  //                         onRatingUpdate: (rat) {
  //                           setState(() {
  //                             rating = rat;
  //                             print(rating);
  //                             print(ratingController.text);
  //                           });
  //                         },
  //                       ),
  //                       Row(
  //                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                         children: [
  //                           _buildDialogButton(
  //                             buttonLabel: AppLocalizations.of(context).cancel,
  //                             isSendButton: false,
  //                             rating: rating.toInt(),
  //                             notes: ratingController.text,
  //                           ),
  //                           _buildDialogButton(
  //                             buttonLabel: AppLocalizations.of(context).send,
  //                             isSendButton: true,
  //                             rating: rating.toInt(),
  //                             notes: ratingController.text,
  //                           )
  //                         ],
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
