import 'package:dal/business_logic_layer/all_posts_with_categories.dart';
import 'package:dal/business_logic_layer/user_provider.dart';
import 'package:dal/data_layer/models/post_with_sellers_model.dart';
import 'package:dal/data_layer/repositories/categories_repository.dart';
import 'package:dal/data_layer/repositories/posts_repositories.dart';
import 'package:dal/network/local_host.dart';
import 'package:dal/theme/app_colors.dart';
import 'package:dal/utils/utils.dart';
import 'package:dal/widgets/center_title_widget.dart';
import 'package:dal/widgets/Post/post_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class FilterScreen extends StatefulWidget {
  static const routeName = 'FilterScreen';

  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  // List<int> chekedIndexes = [];
  int cheak = -1;
  // List<String> test = [
  //   'Ayman',
  //   'bla',
  //   'bla',
  //   'bla',
  //   'Ayman',
  //   'bla',
  //   'bla',
  //   'bla',
  //   'Ayman',
  //   'bla',
  //   'bla',
  //   'bla'
  // ];

  List<String> categoriesList = [];
  List<String> citiesList = [];

  var items = [];
  CategoriesRepositoryImp _catRepo = CategoriesRepositoryImp();
  bool isLoading = true;

  PostsWithSellerModel allPostsData = PostsWithSellerModel();
  PostsRepositoryImp postsRepositoryImp = PostsRepositoryImp();

  int pageNumber = 1;
  int pageSize = 7;
  @override
  void initState() {
    _catRepo
        .getAllCategories(
            refreshed: true, pageNumber: pageNumber, pageSize: pageSize)
        .then((value) {
      value.data.categories.forEach((element) {
        categoriesList.add(element.title);
      });
      _catRepo.getAllCities().then((value) {
        value.forEach((element) {
          // print(element);
          citiesList.add(element.cityName);
        });
        setState(() {
          isLoading = false;
        });
      });
    });
    // loadCategory().then((value) => print(value[0]));
    // _future.then((value) => print(value));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String filterType = ModalRoute.of(context).settings.arguments;
    var provider = Provider.of<AllPostsWithCategories>(context);
    // final addsProvider = Provider.of<AddsProvider>(context, listen: false);
    List<String> adds = Provider.of<UserProvider>(context).getAdds();

    final userPrvider = Provider.of<UserProvider>(context);
    RefreshController _refreshController =
        RefreshController(initialRefresh: false);
    int pageNumebr = 1;
    int pageSize = 7;
    Future<Widget> getPostData(String id) async {
      allPostsData = await postsRepositoryImp.getAllPostsByCategoryId(
          id, pageNumebr, pageSize);

      if (allPostsData == null) {
        return CenterTitleWidget(
          title: AppLocalizations.of(context).error,
          iconData: Icons.error,
        );
      }
      provider.addNewPosts(allPostsData.data.data);

      List<PostModel> posts = provider.getDisplayedPosts();
      if (posts.isEmpty) {
        CenterTitleWidget(
          title: AppLocalizations.of(context).empty,
          iconData: Icons.emoji_flags_outlined,
        );
      } else {
        return Container(
          padding: EdgeInsets.only(
            top: 50,
          ),
          child: ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemCount: posts.length,
            separatorBuilder: (context, index) {
              if (index % 4 == 0) {
                // String path = userProvider.getNextAdds();
                String path = '';
                if (index ~/ 4 < adds.length) {
                  path = adds[index ~/ 4];
                }
                if (path.isNotEmpty) {
                  return Container(
                    padding: const EdgeInsets.all(8),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 3,
                    color: Theme.of(context).colorScheme.background,
                    child: Image.network(
                      'http://malldal.com/dal/' + path,
                      fit: BoxFit.fill,
                    ),
                  );
                }
              }
              return Container();
            },
            itemBuilder: (context, index) {
              var item = posts[index];
              // followedPosts.any((element) => element['id']==item.id);
              return Consumer<UserProvider>(
                builder: (context, user, _) {
                  return PostItem(
                    postId: item.id,
                    createdAt: item.createdAt,
                    title: item.title,
                    body: item.body,
                    priceDetails: item.priceDetails,
                    averageRate: item.avgRate,
                    owner: item.seller,
                    isEditable: false,
                    isRequest: false,
                  );
                },
              );
            },
          ),
        );
      }
      return CenterTitleWidget(
        title: AppLocalizations.of(context).empty,
        iconData: Icons.emoji_flags_outlined,
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).cardColor,
        // elevation: 0,
        leading: IconButton(
          onPressed: () {
            provider.removeCategoryFilter();
            provider.remveCityFilter();
            Navigator.pop(context);
          },
          icon: Icon(Icons.close, color: AppColors.primary, size: 30),
        ),
        centerTitle: true,
        title: Text(
          filterType,
          style: TextStyle(color: AppColors.primary),
        ),
        actions: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.check, color: AppColors.primary, size: 30),
          ),
        ],
      ),
      // backgroundColor: AppColors.primary,
      body: SmartRefresher(
        footer: const ClassicFooter(loadStyle: LoadStyle.ShowWhenLoading),
        controller: _refreshController,
        enablePullDown: true,
        enablePullUp: true,
        header: WaterDropMaterialHeader(
          backgroundColor: AppColors.primary,
        ),
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
          var categories = _catRepo
              .getAllCategories(
            pageNumber: pageNumber,
            pageSize: pageSize,
          )
              .then((value) {
            setState(() {
              value.data.categories.forEach((element) {
                categoriesList.add(element.title);
              });
            });
          });
          if (categories != null) {
            setState(() {
              _refreshController.loadComplete();
            });
          } else {
            _refreshController.loadFailed();
          }
        },
        child: GridView.builder(
          shrinkWrap: true,
          itemCount:
              filterType == 'City' ? citiesList.length : categoriesList.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 3 / 3,
            crossAxisCount: 2,
            crossAxisSpacing: 3.0,
            mainAxisSpacing: 5.0,
          ),
          itemBuilder: (context, index) {
            bool isFavorite =
                userPrvider.isFavoriteCategoryContain((index + 1).toString());
            bool checked = index == cheak; //chekedIndexes.contains(index);
            Color itemColor = Theme.of(context).cardColor;
            if (filterType == 'City') {
              if (provider.getCityFilter.contains((index + 1).toString())) {
                itemColor = AppColors.primary;
                checked = true;
              }
            } else {
              if (provider.getCategoryFilter.contains((index + 1).toString())) {
                itemColor = AppColors.primary;
                checked = true;
              }
            }

            return Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(50),
                      bottomRight: Radius.circular(50),
                    ),
                    // color: Colors.white,
                  ),
                  padding: EdgeInsets.all(20),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        print(provider.getCategoryFilter);
                        if (checked) {
                          // chekedIndexes.remove(index);
                          filterType == 'City'
                              ? provider.remveCityFilter()
                              : provider.removeCategoryFilter();
                          checked = false;
                        } else {
                          getPostData(index.toString());
                          // chekedIndexes.add(index);
                          filterType == 'City'
                              ? provider.setCityFilter((index + 1).toString())
                              : provider
                                  .setCategoryFilter((index + 1).toString());

                          provider.setIndexOfCategory((index + 1).toString());
                        }
                      });
                    },
                    child: Card(
                      // decoration: BoxDecoration(
                      //     color: color,
                      // borderRadius: BorderRadius.circular(15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      color: itemColor,
                      elevation: 20,
                      child: Center(
                        child: Text(
                          filterType == 'City'
                              ? citiesList[index]
                              : categoriesList[index],
                        ),
                      ),
                    ),
                  ),
                ),
                filterType == 'City' ||
                        CachHelper.getData(key: 'userId') == null
                    ? Container()
                    : Positioned(
                        bottom: 0,
                        left: MediaQuery.of(context).size.width / 5.1,
                        child: IconButton(
                          onPressed: () {
                            // print(isFavorite);
                            setState(
                              () {
                                isFavorite = true;
                                print(isFavorite);
                                if (userPrvider.isFavoriteCategoryContain(
                                    (index + 1).toString())) {
                                  if (userPrvider
                                          .removeCateogryFromCustomerFavorite(
                                              (index + 1).toString()) !=
                                      null) {
                                    Utils.showToast(
                                      message: AppLocalizations.of(context)
                                          .removeCategory,
                                      // 'تم  إزالة الفئة من المحفوظات',
                                      backgroundColor: AppColors.primary,
                                      textColor: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .color,
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
                                          .saveCategory,
                                      // 'تم حفظ  الفئة',
                                      backgroundColor: AppColors.primary,
                                      textColor: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .color,
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
      // isLoading
      //     ? Center(
      //         child: CircularProgressIndicator(
      //           valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
      //         ),
      //       )
      //     : Column(
      //         children: [
      //           Container(
      //             // padding: EdgeInsets.only(top: 20),
      //             decoration: BoxDecoration(
      //               borderRadius: BorderRadius.only(
      //                 bottomLeft: Radius.circular(50),
      //                 bottomRight: Radius.circular(50),
      //               ),
      //             ),
      //             height: MediaQuery.of(context).size.height -
      //                 MediaQuery.of(context).size.height / 5,
      //             child: ClipRRect(
      //               borderRadius: BorderRadius.only(
      //                 bottomLeft: Radius.circular(50),
      //                 bottomRight: Radius.circular(50),
      //               ),
      //               child: Column(
      //                 children: [
      //                   Expanded(
      //                     // flex: 10,
      //                     child: Container(
      //                       color: Colors.white10,
      //                       child: GridView.builder(
      //                         shrinkWrap: true,
      //                         itemCount: filterType == 'City'
      //                             ? citiesList.length
      //                             : categoriesList.length,
      //                         gridDelegate:
      //                             SliverGridDelegateWithFixedCrossAxisCount(
      //                           childAspectRatio: 3 / 3,
      //                           crossAxisCount: 2,
      //                           crossAxisSpacing: 3.0,
      //                           mainAxisSpacing: 5.0,
      //                         ),
      //                         itemBuilder: (context, index) {
      //                           bool isFavorite =
      //                               userPrvider.isFavoriteCategoryContain(
      //                                   (index + 1).toString());
      //                           bool checked = index ==
      //                               cheak; //chekedIndexes.contains(index);
      //                           Color itemColor = Theme.of(context).cardColor;
      //                           if (filterType == 'City') {
      //                             if (provider.getCityFilter
      //                                 .contains((index + 1).toString())) {
      //                               itemColor = AppColors.primary;
      //                               checked = true;
      //                             }
      //                           } else {
      //                             if (provider.getCategoryFilter
      //                                 .contains((index + 1).toString())) {
      //                               itemColor = AppColors.primary;
      //                               checked = true;
      //                             }
      //                           }

      //                           return Stack(
      //                             children: [
      //                               Container(
      //                                 decoration: BoxDecoration(
      //                                   borderRadius: BorderRadius.only(
      //                                     bottomLeft: Radius.circular(50),
      //                                     bottomRight: Radius.circular(50),
      //                                   ),
      //                                   // color: Colors.white,
      //                                 ),
      //                                 padding: EdgeInsets.all(20),
      //                                 child: GestureDetector(
      //                                   onTap: () {
      //                                     setState(() {
      //                                       print(provider.getCategoryFilter);
      //                                       if (checked) {
      //                                         // chekedIndexes.remove(index);
      //                                         filterType == 'City'
      //                                             ? provider.remveCityFilter()
      //                                             : provider
      //                                                 .removeCategoryFilter();
      //                                         checked = false;
      //                                       } else {
      //                                         getPostData(index);
      //                                         // chekedIndexes.add(index);
      //                                         filterType == 'City'
      //                                             ? provider.setCityFilter(
      //                                                 (index + 1).toString())
      //                                             : provider.setCategoryFilter(
      //                                                 (index + 1).toString());

      //                                         provider.setIndexOfCategory(
      //                                             index + 1);
      //                                       }
      //                                     });
      //                                   },
      //                                   child: Card(
      //                                     // decoration: BoxDecoration(
      //                                     //     color: color,
      //                                     // borderRadius: BorderRadius.circular(15),
      //                                     shape: RoundedRectangleBorder(
      //                                       borderRadius:
      //                                           BorderRadius.circular(12),
      //                                     ),
      //                                     color: itemColor,
      //                                     elevation: 20,
      //                                     child: Center(
      //                                       child: Text(
      //                                         filterType == 'City'
      //                                             ? citiesList[index]
      //                                             : categoriesList[index],
      //                                       ),
      //                                     ),
      //                                   ),
      //                                 ),
      //                               ),
      //                               filterType == 'City' ||
      //                                       CachHelper.getData(key: 'userId') ==
      //                                           null
      //                                   ? Container()
      //                                   : Positioned(
      //                                       bottom: 0,
      //                                       left: MediaQuery.of(context)
      //                                               .size
      //                                               .width /
      //                                           5.1,
      //                                       child: IconButton(
      //                                         onPressed: () {
      //                                           // print(isFavorite);
      //                                           setState(
      //                                             () {
      //                                               isFavorite = true;
      //                                               print(isFavorite);
      //                                               if (userPrvider
      //                                                   .isFavoriteCategoryContain(
      //                                                       (index + 1)
      //                                                           .toString())) {
      //                                                 if (userPrvider
      //                                                         .removeCateogryFromCustomerFavorite(
      //                                                             (index +
      //                                                                 1)) !=
      //                                                     null) {
      //                                                   Utils.showToast(
      //                                                     message: AppLocalizations
      //                                                             .of(context)
      //                                                         .removeCategory,
      //                                                     // 'تم  إزالة الفئة من المحفوظات',
      //                                                     backgroundColor:
      //                                                         Colors.white,
      //                                                     textColor:
      //                                                         Colors.black,
      //                                                   );
      //                                                   userPrvider
      //                                                       .removeCategoryFromFavorite(
      //                                                           (index + 1)
      //                                                               .toString());
      //                                                 }
      //                                               } else {
      //                                                 if (userPrvider
      //                                                         .addCateogryToCustomerFavorite({
      //                                                       'category_id':
      //                                                           (index + 1)
      //                                                     }) !=
      //                                                     null) {
      //                                                   Utils.showToast(
      //                                                     message:
      //                                                         AppLocalizations.of(
      //                                                                 context)
      //                                                             .saveCategory,
      //                                                     // 'تم حفظ  الفئة',
      //                                                     backgroundColor:
      //                                                         Colors.white,
      //                                                     textColor:
      //                                                         Colors.black,
      //                                                   );
      //                                                   userPrvider
      //                                                       .addCategoryToFavorite(
      //                                                           (index + 1)
      //                                                               .toString());
      //                                                 }
      //                                               }
      //                                             },
      //                                           );
      //                                         },
      //                                         icon: Icon(
      //                                           isFavorite
      //                                               ? Icons.star
      //                                               : Icons.star_border,
      //                                           color: Colors.amber,
      //                                           size: MediaQuery.of(context)
      //                                                   .size
      //                                                   .width /
      //                                               12,
      //                                         ),
      //                                       ),
      //                                     ),
      //                             ],
      //                           );
      //                         },
      //                       ),
      //                     ),
      //                   ),
      //                 ],
      //               ),
      //             ),
      //           ),
      //         ],
      //       ),
    );
  }
}
