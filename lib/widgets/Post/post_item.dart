import 'package:dal/widgets/Post/post_body.dart';
import 'package:dal/widgets/Post/post_footer.dart';
import 'package:dal/widgets/Post/post_header.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../business_logic_layer/user_provider.dart';
import '../../data_layer/models/post_with_sellers_model.dart';
import '../../network/local_host.dart';
import '../../screens/overview_single_post_screen.dart';
import '../../theme/app_colors.dart';

class PostItem extends StatefulWidget {
  final String postId;
  final String title;
  final String body;
  final String priceDetails;
  final String averageRate;
  final String createdAt;
  final List<String> paths;
  final Seller owner;
  final bool isEditable;
  final bool isRequest;
  const PostItem({
    Key key,
    this.postId,
    this.title,
    this.body,
    this.priceDetails,
    this.averageRate,
    this.createdAt,
    this.paths,
    this.owner,
    this.isEditable,
    this.isRequest,
  }) : super(key: key);

  @override
  State<PostItem> createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {
  final token = CachHelper.getData(key: 'token');
  bool isSaved = false;
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    if (userProvider.savedPosts != null) {
      isSaved = userProvider.savedPosts.contains(widget.postId);
    }
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

              ownerUser: widget.owner,
              postImagePaths: widget.paths,
              isRequest: widget.isRequest,
              // isInteract: widget.isInteract,
              // toggleInteract: () => toggleInteract,
            ),
          ),
        )
            .then((value) {
          setState(() {
            if (userProvider.savedPosts != null)
              isSaved = userProvider.savedPosts.contains(widget.postId);
          });
        });
      },
      child: Container(
        padding: const EdgeInsets.only(top: 10, left: 5, right: 5),
        height: MediaQuery.of(context).size.height / 1.7,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.0),
          // color: Colors.grey,
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              offset: Offset(0.0, 1.0), //(x,y)
              blurRadius: 6.0,
            ),
          ],
        ),
        child: ClipRRect(
          child: Card(
            // elevation: 10,
            shape: RoundedRectangleBorder(
                side: BorderSide(
                    color: AppColors.primary.withOpacity(0.5), width: 1),
                borderRadius: BorderRadius.circular(20)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Column(
                children: [
                  Expanded(
                    flex: 3,
                    child: PostHeader(
                      sellerName: widget.owner.user.name,
                      createdAt: widget.createdAt,
                      postTitle: widget.title,
                      postBody: widget.body,
                      price: widget.priceDetails,
                      sellerProfileImage: widget.owner.profileImage,
                      isEditable: widget.isEditable,
                      images: widget.paths,
                      postId: widget.postId,
                    ),
                  ),
                  Expanded(flex: 4, child: PostBody(imagesPath: widget.paths)),
                  CachHelper.getData(key: 'userId') == null || widget.isRequest
                      // ||
                      // userProvider.userMode == 'seller'
                      ? Container()
                      : Expanded(
                          flex: 1,
                          child: PostFooter(
                              isSave: isSaved, postId: widget.postId)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
