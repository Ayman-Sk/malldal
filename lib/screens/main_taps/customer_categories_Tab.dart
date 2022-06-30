import 'package:dal/business_logic_layer/all_posts_with_categories.dart';
import 'package:dal/business_logic_layer/user_provider.dart';
import 'package:dal/data_layer/repositories/categories_repository.dart';
import 'package:dal/screens/category_posts_screen.dart';
import 'package:dal/theme/app_colors.dart';
import 'package:dal/utils/utils.dart';
import 'package:dal/widgets/myDrawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class CustomerCategoriesTap extends StatefulWidget {
  @override
  _CustomerCategoriesTapState createState() => _CustomerCategoriesTapState();
}

class _CustomerCategoriesTapState extends State<CustomerCategoriesTap> {
  List<int> chekedIndexes = [];

  // List<String> categoriesList = [];
  List<String> citiesList = [];

  var items = [];
  CategoriesRepositoryImp _catRepo = CategoriesRepositoryImp();
  bool isLoading = false;
  int pageNumber = 2;
  int pageSize = 8;
  int allPage = 3;

  @override
  void initState() {
    // Provider.of<UserProvider>(context, listen: false)
    //     .getFollowedCategoriesByCustomerID()
    //     .then((value) {
    //   print(value);
    //   _catRepo
    //       .getAllCategories(
    //     refreshed: true,
    //     pageNumber: pageNumber,
    //     pageSize: pageSize,
    //   )
    //       .then((value) {
    //     setState(() {
    //       allPage = value.data.lastPage;
    //     });
    //     value.data.categories.forEach((element) {
    //       categoriesList.add(element.title);
    //     });
    //     setState(() {
    //       pageNumber++;
    //       isLoading = false;
    //     });
    //   });
    // });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String filterType = ModalRoute.of(context).settings.arguments;
    final postProvider = Provider.of<AllPostsWithCategories>(context);
    final userProvider = Provider.of<UserProvider>(context);

    RefreshController _refreshController =
        RefreshController(initialRefresh: false);

    return Scaffold(
      drawer: MyDrawer(),
      drawerScrimColor: AppColors.primary.withOpacity(0.7),
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context).title,
        ),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        elevation: 10,
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            )
          : SmartRefresher(
              // semanticChildCount: 2,
              controller: _refreshController,
              enablePullDown: true,
              enablePullUp: true,
              header: WaterDropMaterialHeader(
                backgroundColor: AppColors.primary,
              ),
              footer: const ClassicFooter(loadStyle: LoadStyle.ShowWhenLoading),

              onRefresh: () async {
                setState(() {
                  pageNumber = 1;
                });
                var categories = _catRepo
                    .getAllCategories(
                  refreshed: true,
                  pageNumber: pageNumber,
                  pageSize: pageSize,
                )
                    .then((value) {
                  postProvider.setCategoriesListEmpty();
                  List<String> categoriesList = [];
                  value.data.categories.forEach((element) {
                    categoriesList.add(element.title);
                  });
                  postProvider.addCategories(categoriesList);
                });
                if (categories != null) {
                  _refreshController.refreshCompleted();
                } else {
                  _refreshController.refreshFailed();
                }
              },
              onLoading: () {
                print('asdasdas');
                print(allPage);
                print(pageNumber);
                if (allPage < pageNumber) {
                  print('sss');
                  print(allPage);
                  print(pageNumber);
                  setState(() {
                    _refreshController.loadComplete();
                    _refreshController.loadNoData();
                  });
                  // _refreshController.loadNoData();
                } else {
                  var categories = _catRepo
                      .getAllCategories(
                    pageNumber: pageNumber,
                    pageSize: pageSize,
                  )
                      .then((value) {
                    setState(() {
                      // allPage =
                      List<String> categoriesList = [];
                      value.data.categories.forEach((element) {
                        categoriesList.add(element.title);
                      });
                      postProvider.addCategories(categoriesList);
                    });
                  });
                  if (categories != null) {
                    setState(() {
                      pageNumber = 5;
                      allPage = 0;

                      _refreshController.loadComplete();
                    });
                  } else {
                    _refreshController.loadFailed();
                  }
                }
              },
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: filterType == 'City'
                    ? citiesList.length
                    : postProvider.getCategories.length,
                // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                //     childAspectRatio: 3 / 3,
                //     crossAxisCount: 2,
                //     crossAxisSpacing: 3.0,
                //     mainAxisSpacing: 5.0),
                itemBuilder: (context, index) {
                  bool isFavorite = userProvider
                      .isFavoriteCategoryContain((index + 1).toString());
                  // bool checked = chekedIndexes.contains(index);
                  // Color itemColor = AppColors.primary;

                  if (postProvider.getCategoryFilter
                      .contains((index + 1).toString())) {
                    // itemColor = AppColors.primary;
                    // checked = true;
                  }

                  return buildListViewItem(
                      context,
                      postProvider.getCategories[index],
                      index,
                      isFavorite,
                      userProvider);
                },
              ),
            ),
    );
  }

  Stack buildListViewItem(BuildContext context, String title, int index,
      bool isFavorite, UserProvider userPrvider) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, CategoryPostsScreen.routeName,
                  arguments: {'id': index + 1});
            },
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 20,
              child: ListTile(
                title: Text(title),
                trailing: GestureDetector(
                  child: Icon(
                    isFavorite ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: MediaQuery.of(context).size.width / 12,
                  ),
                  onTap: () {
                    setState(
                      () {
                        print(isFavorite);
                        if (userPrvider.isFavoriteCategoryContain(
                            (index + 1).toString())) {
                          if (userPrvider.removeCateogryFromCustomerFavorite(
                                  (index + 1).toString()) !=
                              null) {
                            Utils.showToast(
                              message: AppLocalizations.of(context)
                                  .removeCategory, //'تم  إزالة الفئة من المحفوظات',
                              backgroundColor: AppColors.primary,
                              textColor:
                                  Theme.of(context).textTheme.bodyText1.color,
                            );
                            userPrvider.removeCategoryFromFavorite(
                                (index + 1).toString());
                          }
                        } else {
                          if (userPrvider.addCateogryToCustomerFavorite(
                                  {'category_id': (index + 1)}) !=
                              null) {
                            Utils.showToast(
                              message: AppLocalizations.of(context)
                                  .saveCategory, //'تم حفظ  الفئة',
                              backgroundColor: AppColors.primary,
                              textColor:
                                  Theme.of(context).textTheme.bodyText1.color,
                            );
                            userPrvider
                                .addCategoryToFavorite((index + 1).toString());
                          }
                        }
                      },
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
