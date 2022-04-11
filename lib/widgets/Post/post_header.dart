import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

class PostHeader extends StatefulWidget {
  final String sellerName;
  final String createdAt;
  final String postTitle;
  final String postBody;
  final String price;
  final String sellerProfileImage;

  const PostHeader({
    Key key,
    this.sellerName,
    this.createdAt,
    this.postTitle,
    this.postBody,
    this.price,
    this.sellerProfileImage,
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
            trailing: Text(
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
