import 'package:dal/business_logic_layer/all_posts_with_categories.dart';
import 'package:dal/data_layer/models/category_model.dart';
import 'package:dal/data_layer/repositories/categories_repository.dart';
import 'package:dal/theme/app_colors.dart';
import 'package:dal/widgets/center_title_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoriesTapsWidget extends StatelessWidget {
  final CategoriesRepositoryImp _catRepo = CategoriesRepositoryImp();

  @override
  Widget build(BuildContext context) {
    final postsProvider = Provider.of<AllPostsWithCategories>(context);
    return FutureBuilder(
      future: _catRepo.getAllCategories(),
      builder: (context, snapShot) {
        if (snapShot.connectionState == ConnectionState.waiting)
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          );
        else if (snapShot.hasData) {
          return ListView.separated(
            itemCount: snapShot.data.length + 1,
            separatorBuilder: (context, index) {
              return SizedBox(
                width: 1,
              );
            },
            itemBuilder: (context, index) {
              // print('allCategories');
              // print(snapShot.data.length);

              print(index);
              if (index == 0) {
                CategoryModel item = snapShot.data[index];
                return Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: GestureDetector(
                    child: Chip(
                      backgroundColor: AppColors.accent,
                      padding:
                          EdgeInsets.symmetric(vertical: 2.5, horizontal: 2.5),
                      label: Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          'All',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            // color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    onTap: () {
                      print(item.id);
                      postsProvider.setIndexOfCategory(-1);
                    },
                  ),
                );
              } else {
                CategoryModel item = snapShot.data[index - 1];
                return Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: GestureDetector(
                    child: Chip(
                      backgroundColor: AppColors.accent,
                      padding:
                          EdgeInsets.symmetric(vertical: 2.5, horizontal: 2.5),
                      label: Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          item.title,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            // color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    onTap: () {
                      print(item.id);
                      postsProvider.setIndexOfCategory(item.id);
                    },
                  ),
                );
              }
            },
            scrollDirection: Axis.horizontal,
          );
        } else if (snapShot.hasError) {
          return CenterTitleWidget(
            title: 'حصل خطأ في التحميل',
            iconData: Icons.error,
          );
        }
        return Container();
      },
    );
  }
}
