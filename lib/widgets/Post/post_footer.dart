import 'package:dal/widgets/Post/review_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../business_logic_layer/user_provider.dart';
import '../../data_layer/repositories/posts_repositories.dart';
import '../../network/local_host.dart';
import '../../theme/app_colors.dart';
import '../../utils/utils.dart';

// ignore: must_be_immutable
class PostFooter extends StatefulWidget {
  bool isSave;
  final String postId;

  PostFooter({Key key, this.isSave, this.postId}) : super(key: key);

  @override
  State<PostFooter> createState() => _PostFooterState();
}

class _PostFooterState extends State<PostFooter> {
  // final _postsApi = PostsApi();
  PostsRepositoryImp postsRepositoryImp = PostsRepositoryImp();

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    // final postsProvider = Provider.of<AllPostsWithCategories>(context);

    return Column(
      children: [
        Expanded(
          flex: 2,
          child: Row(
            children: userProvider.userMode == 'seller'
                ? [
                    ReviewDialog(postId: widget.postId),
                  ]
                : [
                    ReviewDialog(postId: widget.postId),
                    buildSaveButton(userProvider)
                  ],
          ),
        ),
      ],
    );
  }

  // Widget buildchipBottun() {
  //   return Expanded(
  //     flex: 1,
  //     child: GestureDetector(
  //       onTap: () {
  //         _buildReviewPopupDialog();
  //       },
  //       child: Chip(
  //         label: Padding(
  //           padding: const EdgeInsets.all(8.0),
  //           child: Text(
  //             AppLocalizations.of(context)!.rate,
  //             style: const TextStyle(
  //               fontSize: 10,
  //             ),
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget buildSaveButton(UserProvider userProvider) {
    return Expanded(
      flex: 1,
      child: Center(
        child: IconButton(
          icon: Icon(
            widget.isSave ? Icons.favorite : Icons.favorite_border,
            color: AppColors.focus,
            size: 20,
          ),
          onPressed: () async {
            if (widget.isSave) {
              removePostFromFavorite(widget.postId);
              userProvider.savedPosts.remove(widget.postId);
            } else {
              addPostToFavorite(widget.postId);
              userProvider.savedPosts.add(widget.postId);
            }
          },
        ),
      ),
    );
  }

  Future<void> removePostFromFavorite(String postId) async {
    bool res;
    res = await postsRepositoryImp.removePostFromFollowedPostsOfCustomer(
      cutomerId: CachHelper.getData(
        key: 'userId',
      ),
      postId: widget.postId,
      token: CachHelper.getData(key: 'token'),
    );
    if (res) {
      setState(() {
        widget.isSave = false;
      });
      Utils.showToast(
        message: AppLocalizations.of(context).removePost,
        backgroundColor: AppColors.primary,
        textColor: Theme.of(context).textTheme.bodyText1.color,
      );
    } else {
      Utils.showToast(
        message: AppLocalizations.of(context).favoriteRefused,
        backgroundColor: AppColors.primary,
        textColor: Theme.of(context).textTheme.bodyText1.color,
      );
    }
  }

  Future<void> addPostToFavorite(String postId) async {
    bool res;
    res = await postsRepositoryImp.addPostTofollowedPostsOfCustomer(
      cutomerId: CachHelper.getData(
        key: 'userId',
      ),
      postId: widget.postId,
      token: CachHelper.getData(key: 'token'),
    );
    if (res) {
      setState(() {
        widget.isSave = true;
      });

      Utils.showToast(
        message: AppLocalizations.of(context).postFavorite,
        backgroundColor: AppColors.primary,
        textColor: Theme.of(context).textTheme.bodyText1.color,
      );
    } else {
      Utils.showToast(
        message: AppLocalizations.of(context).favoriteRefused,
        backgroundColor: AppColors.primary,
        textColor: Theme.of(context).textTheme.bodyText1.color,
      );
    }
  }
}
