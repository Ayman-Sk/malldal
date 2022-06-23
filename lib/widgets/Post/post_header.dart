import 'package:dal/screens/edit_post_screen.dart';
import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

class PostHeader extends StatefulWidget {
  final String sellerName;
  final String createdAt;
  final String postTitle;
  final String postBody;
  final String price;
  final String sellerProfileImage;
  final bool isEditable;

  const PostHeader({
    Key key,
    this.sellerName,
    this.createdAt,
    this.postTitle,
    this.postBody,
    this.price,
    this.sellerProfileImage,
    this.isEditable,
  }) : super(key: key);
  @override
  State<PostHeader> createState() => _PostHeaderState();
}

class _PostHeaderState extends State<PostHeader> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              radius: 31,
              backgroundColor: Theme.of(context).colorScheme.background,
              backgroundImage: NetworkImage(
                'http://malldal.com/dal/' + widget.sellerProfileImage,
              ),
            ),
            title: Text(
              widget.sellerName,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              widget.createdAt.toString().substring(0, 10),
            ),
            trailing: widget.isEditable
                ? Container(
                    width: MediaQuery.of(context).size.width / 3,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.price,
                          style: const TextStyle(
                            color: AppColors.focus,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => EditPostScreen(
                                  productName: widget.postTitle,
                                  productDetails: widget.postBody,
                                  productPrice: widget.price,
                                ),
                              ),
                            );
                          },
                          icon: Icon(
                            Icons.edit,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  )
                : Text(
                    widget.price,
                    style: const TextStyle(
                      color: AppColors.focus,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
          Center(
            child: Text(
              widget.postTitle,
              style: const TextStyle(
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
                  widget.postBody,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
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
