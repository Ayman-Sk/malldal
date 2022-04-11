import 'package:dal/screens/post_images_screen.dart';
import 'package:flutter/material.dart';

class PostImagesWidget extends StatefulWidget {
  @override
  _PostImagesWidgetState createState() => _PostImagesWidgetState();
}

class _PostImagesWidgetState extends State<PostImagesWidget> {
  List<String> adds = [
    'img/test.jpg',
    'img/test.jpg',
    'img/test.jpg',
  ];
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => PostImagesScreen(imgs: adds),
          ),
        );
      },
      child: Container(
        color: Colors.grey.withOpacity(0.1),
        child: adds.length > 1
            ? Column(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: Image.asset(
                        'img/test.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Stack(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          child: Image.asset(
                            'img/test.jpg',
                            fit: BoxFit.cover,
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          color: Colors.black54,
                          child: Center(
                            child: Text(
                              'x${adds.length - 1}',
                              style: TextStyle(
                                // color: Colors.white,
                                fontSize: 35,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            : Container(
                width: MediaQuery.of(context).size.width,
                child: Image.asset(
                  'img/test.jpg',
                  fit: BoxFit.cover,
                ),
              ),
      ),
    );
  }
}
