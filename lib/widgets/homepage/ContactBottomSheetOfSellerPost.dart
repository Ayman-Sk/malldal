import 'package:dal/screens/seller_posts_screen.dart';
import 'package:dal/theme/app_colors.dart';
import 'package:flutter/material.dart';

class ContactBottomSheetOfSellerPost extends StatelessWidget {
  const ContactBottomSheetOfSellerPost({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          //image
          Row(
            children: [
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    child: Center(
                      child: Container(
                        width: 70,
                        height: 70,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(300),
                          child: Image(
                            image: AssetImage('img/test.jpg'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              ////
              Expanded(
                flex: 7,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'اسم البائع',
                    style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          //posts
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: InkWell(
                onTap: () {
                  Navigator.of(context).pushNamed(SellerPostScreen.routeName);
                },
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(8),
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  color: AppColors.accent,
                  child: Text(
                    'المنشورات الخاصة بالبائع',
                    style: TextStyle(
                      color: AppColors.background,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          //contact
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: InkWell(
                onTap: () {},
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(8),
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  color: AppColors.accent,
                  child: Text(
                    'تواصل مع البائع',
                    style: TextStyle(
                      color: AppColors.background,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
