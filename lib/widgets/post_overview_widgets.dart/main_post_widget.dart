import 'package:dal/data_layer/models/post_with_sellers_model.dart';
import 'package:dal/network/local_host.dart';
import 'package:dal/theme/app_colors.dart';

import 'package:dal/widgets/post_overview_widgets.dart/post_body.dart';
import 'package:dal/widgets/post_overview_widgets.dart/post_footer.dart';
import 'package:dal/widgets/post_overview_widgets.dart/post_header.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../business_logic_layer/user_provider.dart';

// ignore: must_be_immutable
class PostOverViewWidget extends StatefulWidget {
  final String postId;
  final String title;
  final String nameOfSeller;
  final String body;
  final String priceDetails;
  // final int avgRate;
  // int sellerId;
  final String createdAt;
  final Seller ownerUser;
  final bool isInteract;
  List<String> postImages;
  final bool isRequest;
  // SellerModel seller;
  final Function toggleInteract;
  PostOverViewWidget({
    this.postId,
    this.title,
    this.nameOfSeller,
    this.body,
    this.priceDetails,
    this.createdAt,
    // this.avgRate,
    this.ownerUser,
    this.isInteract,
    this.toggleInteract,
    this.postImages,
    this.isRequest,
  });

  @override
  _PostOverViewWidgetState createState() => _PostOverViewWidgetState();
}

class _PostOverViewWidgetState extends State<PostOverViewWidget> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Column(
        children: [
          PostHeaderWidget(
            sellerName: widget.nameOfSeller,
            createdAt: widget.createdAt,
            ownerUser: widget.ownerUser,
          ),
          Divider(
            color: AppColors.background,
            thickness: 1.0,
          ),
          Expanded(
            child: PostBodyWidget(
              title: widget.title,
              body: widget.body,
              bio: widget.ownerUser.bio,
              ownerId: widget.ownerUser.id,
              postImagePaths: widget.postImages,
              phoneNumber: widget.ownerUser.user.phone,
            ),
          ),
          CachHelper.getData(key: 'userId') == null ||
                  widget.isRequest ||
                  Provider.of<UserProvider>(context).userMode == 'seller'
              ? Container()
              : Column(
                  children: [
                    Divider(
                      color: AppColors.background,
                      thickness: 1.0,
                    ),
                    PostFooterWidget(
                        // avgRate: widget.avgRate,

                        sellerId: widget.ownerUser.id,
                        postId: widget.postId,
                        isInteract: Provider.of<UserProvider>(context)
                            .savedPosts
                            .contains(widget.postId),
                        toggleInteract: () => widget.toggleInteract),
                  ],
                ),
        ],
      ),
    );
  }
}
