import 'package:dal/data_layer/models/post_with_sellers_model.dart';
import 'package:dal/theme/app_colors.dart';
import 'package:dal/widgets/post_overview_widgets.dart/main_post_widget.dart';
import 'package:flutter/material.dart';

class OverviewSinglePostScreen extends StatefulWidget {
  final int postId;
  final String postTitle;
  final String postbody;
  final String priceDetails;
  final String createdAt;
  final Seller ownerUser;
  final List<String> postImagePaths;
  final bool isRequest;
  // final bool isInteract;
  // Function toggleInteract;
  OverviewSinglePostScreen({
    @required this.postId,
    @required this.postTitle,
    @required this.postbody,
    @required this.priceDetails,
    @required this.createdAt,
    @required this.ownerUser,
    @required this.postImagePaths,
    @required this.isRequest,
    // @required this.isInteract,
    // @required this.toggleInteract,
  });

  @override
  _OverviewSinglePostScreenState createState() =>
      _OverviewSinglePostScreenState();
}

class _OverviewSinglePostScreenState extends State<OverviewSinglePostScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.postTitle,
          style: TextStyle(
            fontSize: 20,
          ),
        ),
        backgroundColor: AppColors.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          shape: new RoundedRectangleBorder(
              side: new BorderSide(color: AppColors.background, width: 2.0),
              borderRadius: BorderRadius.circular(20.0)),
          elevation: 20,
          child: Center(
            child: PostOverViewWidget(
              postId: widget.postId,
              nameOfSeller: widget.ownerUser.user.name,
              createdAt: widget.createdAt,
              title: widget.postTitle,
              body: widget.postbody,
              priceDetails: widget.priceDetails,
              // avgRate: widget.avgRate,
              ownerUser: widget.ownerUser,
              postImages: widget.postImagePaths,
              isRequest: widget.isRequest,
              // isInteract: widget.isInteract,
              // toggleInteract: () => widget.toggleInteract,
            ),
          ),
        ),
      ),
    );
  }
}
