import 'dart:io';
import 'package:path/path.dart' as pathLib;
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

import 'package:dal/screens/edit_post_screen.dart';
import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

class PostHeader extends StatefulWidget {
  final String postId;
  final String sellerName;
  final String createdAt;
  final String postTitle;
  final String postBody;
  final String price;
  final String sellerProfileImage;
  final bool isEditable;
  final List<String> images;

  const PostHeader({
    Key key,
    this.postId,
    this.sellerName,
    this.createdAt,
    this.postTitle,
    this.postBody,
    this.price,
    this.sellerProfileImage,
    this.isEditable,
    this.images,
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
                    child: Directionality(
                      textDirection: TextDirection.ltr,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            child: FittedBox(
                              child: Text(
                                widget.price,
                                style: const TextStyle(
                                  color: AppColors.focus,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () async {
                              List<String> paths =
                                  await editAllNetworkImagePaths(widget.images);
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => EditPostScreen(
                                    productName: widget.postTitle,
                                    productDetails: widget.postBody,
                                    productPrice: widget.price,
                                    imagesPaths: paths,
                                    postId: widget.postId,
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

  Future<List<String>> editAllNetworkImagePaths(List<String> paths) async {
    List<String> truePaths = [];
    for (int i = 0; i < paths.length; i++) {
      var element = paths[i];
      var path = await getTruePaths(element);
      truePaths.add(path);
      print(element);
    }
    print('all');
    print(paths.length);
    print(truePaths);
    return truePaths;
  }

  Future<String> getTruePaths(String path) async {
    print('sub');
    print(path);
    // print(widget.imagesPaths);
    print(path.substring(0, 4));
    if (path.substring(0, 4) == 'http') {
      String fileName = path.split('/').last;
      var s = await http.get(Uri.parse(path));
      Directory documentDirectory = await getApplicationDocumentsDirectory();
      File file = new File(pathLib.join(documentDirectory.path, fileName));
      file.writeAsBytes(s.bodyBytes);
      print('true');
      print(path);
      print(fileName);
      print(documentDirectory.path + fileName);
      return documentDirectory.path + '/' + fileName;
    }
    return path;
  }
}
