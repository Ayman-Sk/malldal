import 'package:dal/business_logic_layer/all_posts_with_categories.dart';
import 'package:dal/business_logic_layer/user_provider.dart';
import 'package:dal/data_layer/repositories/categories_repository.dart';
import 'package:dal/screens/category_posts_screen.dart';
import 'package:dal/theme/app_colors.dart';
import 'package:dal/utils/utils.dart';
import 'package:dal/widgets/center_title_widget.dart';
import 'package:dal/widgets/myDrawer.dart';
import 'package:flutter/cupertino.dart';
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

  List<String> categoriesList = [];
  List<String> citiesList = [];

  var items = [];
  CategoriesRepositoryImp _catRepo = CategoriesRepositoryImp();
  bool isLoading = true;
  int pageNumber = 1;
  int pageSize = 8;
  int allPage = 0;
  @override
  void initState() {
    Provider.of<UserProvider>(context, listen: false)
        .getFollowedCategoriesByCustomerID()
        .then((value) {
      // allPage = value['data']['last_page'];
      print(value);
      // value['data'].froEach((element) {
      //   print(element['categories']);
      // });
      _catRepo
          .getAllCategories(
        refreshed: true,
        pageNumber: pageNumber,
        pageSize: pageSize,
      )
          .then((value) {
        setState(() {
          allPage = value.data.lastPage;
        });
        value.data.categories.forEach((element) {
          categoriesList.add(element.title);
        });
        setState(() {
          pageNumber++;
          isLoading = false;
        });
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String filterType = ModalRoute.of(context).settings.arguments;
    var provider = Provider.of<AllPostsWithCategories>(context);
    final userPrvider = Provider.of<UserProvider>(context);

    RefreshController _refreshController =
        RefreshController(initialRefresh: false);

    return Scaffold(
      // backgroundColor: AppColors.background,
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
              // footer: CustomFooter(
              //   builder: (BuildContext context, LoadStatus mode) {
              //     Widget body;
              //     if (mode == LoadStatus.idle) {
              //       body = CupertinoActivityIndicator(); //Text("pull up load");
              //     } else if (mode == LoadStatus.loading) {
              //       body = CupertinoActivityIndicator();
              //     } else if (mode == LoadStatus.failed) {
              //       body = Text("Load Failed!Click retry!");
              //     } else if (mode == LoadStatus.canLoading) {
              //       body = Text("release to load more");
              //     } else {
              //       body = Text("No more Data");
              //     }
              //     return Container(
              //       height: 55.0,
              //       child: Center(child: body),
              //     );
              //   },
              // ),
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
                  categoriesList = [];
                  value.data.categories.forEach((element) {
                    categoriesList.add(element.title);
                  });
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
                      value.data.categories.forEach((element) {
                        categoriesList.add(element.title);
                      });
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
              child: GridView.builder(
                shrinkWrap: true,
                itemCount: filterType == 'City'
                    ? citiesList.length
                    : categoriesList.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: 3 / 3,
                    crossAxisCount: 2,
                    crossAxisSpacing: 3.0,
                    mainAxisSpacing: 5.0),
                itemBuilder: (context, index) {
                  bool isFavorite = userPrvider
                      .isFavoriteCategoryContain((index + 1).toString());
                  bool checked = chekedIndexes.contains(index);
                  Color itemColor = AppColors.primary;

                  if (provider.getCategoryFilter
                      .contains((index + 1).toString())) {
                    itemColor = AppColors.primary;
                    checked = true;
                  }

                  return Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                                context, CategoryPostsScreen.routeName,
                                arguments: {'id': index + 1});
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            color: itemColor,
                            elevation: 20,
                            child: Center(
                              child: Text(
                                categoriesList[index],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: MediaQuery.of(context).size.width / 5.1,
                        child: IconButton(
                          onPressed: () {
                            setState(
                              () {
                                print(isFavorite);
                                if (userPrvider.isFavoriteCategoryContain(
                                    (index + 1).toString())) {
                                  if (userPrvider
                                          .removeCateogryFromCustomerFavorite(
                                              (index + 1)) !=
                                      null) {
                                    Utils.showToast(
                                      message: 'تم  إزالة الفئة من المحفوظات',
                                      backgroundColor: Colors.white,
                                      textColor: Colors.black,
                                    );
                                    userPrvider.removeCategoryFromFavorite(
                                        (index + 1).toString());
                                  }
                                } else {
                                  if (userPrvider.addCateogryToCustomerFavorite(
                                          {'category_id': (index + 1)}) !=
                                      null) {
                                    Utils.showToast(
                                      message: 'تم حفظ  الفئة',
                                      backgroundColor: Colors.white,
                                      textColor: Colors.black,
                                    );
                                    userPrvider.addCategoryToFavorite(
                                        (index + 1).toString());
                                  }
                                }
                              },
                            );
                          },
                          icon: Icon(
                            isFavorite ? Icons.star : Icons.star_border,
                            color: Colors.amber,
                            size: MediaQuery.of(context).size.width / 12,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
    );
  }
}
