import 'package:dal/business_logic_layer/adds_provider.dart';
import 'package:dal/business_logic_layer/all_posts_with_categories.dart';
import 'package:dal/business_logic_layer/user_provider.dart';
import 'package:dal/data_layer/models/followed_posts_by_customer_model.dart';
import 'package:dal/data_layer/models/post_with_sellers_model.dart';
import 'package:dal/data_layer/repositories/posts_repositories.dart';
import 'package:dal/network/local_host.dart';
import 'package:dal/theme/app_colors.dart';
import 'package:dal/widgets/center_title_widget.dart';
import 'package:dal/widgets/myDrawer.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../data_layer/models/notification.dart';
import '../../network/end_points.dart';
import '../../widgets/Post/post_item.dart';
import '../../widgets/dropdown_model.dart';
import '../../widgets/multi_selected_drop_down.dart';

class HomePageTap extends StatefulWidget {
  @override
  _HomePageTapState createState() => _HomePageTapState();
}

class _HomePageTapState extends State<HomePageTap> {
  SearchBar searchBar;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  int currentPage = 2;
  int pageSize = 2;
  int totalPageNumber = 3;

  PostsWithSellerModel allPostsData = PostsWithSellerModel();
  FollowedPostsByCustomerModel followedRes = FollowedPostsByCustomerModel();
  Map<String, dynamic> sellerFollower = {};
  PostsRepositoryImp postsRepositoryImp = PostsRepositoryImp();
  List<int> listOfCities = [];
  List<int> listOfCategories = [];
  int categoryFilter = -1;
  int cityFilter = -1;
  List<String> categoryList = [];
  List<String> citiesList = [];
  NotificationData notificationData = NotificationData();
  Dio _dio = Dio();
  List<DropdownMenuItem<DropDownListModel>> _citiesdropDownMenueItems;

  List<DropdownMenuItem<DropDownListModel>> _categorydropDownMenueItems;

  @override
  void initState() {
    getCategories();
    getCities();
    getAllNotification();
    super.initState();
  }

  Widget buildFilterPopupMenuButtom() {
    return IconButton(
      onPressed: () {
        // getCategories().then(
        //     (value) => getCities().then((value) => _buildReviewPopupDialog()));
        _buildReviewPopupDialog();
      },
      icon: Icon(Icons.filter_alt),
    );
  }

  Widget buildNotificationPopupMenuItem() {
    return IconButton(
      icon: Icon(Icons.notifications),
      onPressed: () {
        _buildNotificationPopupDialog();
      },
    );
  }

  Future<void> getCategories(//{String name, String email} في حال بدي
      ) async {
    _dio = Dio();
    final response = await _dio.get(EndPoints.getAllCategories(1, 30));
    // if (response == null) {
    //   setState(() {
    //     loading = true;
    //   });
    // }
    if (response.statusCode == 200) {
      setState(() {
        List categories = response.data['data']['data'];
        categories.forEach((element) {
          categoryList.add(element['title']);
        });
        print(response.data);
        _categorydropDownMenueItems =
            DropDownListModel.buildDropDownMenuItemFromData(
                response.data, false);
        // _selectedcategory = _categorydropDownMenueItems[0].value;
      });
    } else {
      setState(() {
        _categorydropDownMenueItems = null;
      });
    }
  }

  Future<void> getCities(//{String name, String email} في حال بدي
      ) async {
    _dio = Dio();

    final response = await _dio.get(EndPoints.getAllCities);

    // if (response == null) {
    //   setState(() {
    //     loading = true;
    //   });
    // }
    if (response.statusCode == 200) {
      setState(() {
        List cities = response.data['data']['data'];
        cities.forEach((element) {
          citiesList.add(element['cityName']);
        });
        _citiesdropDownMenueItems =
            DropDownListModel.buildDropDownMenuItemFromData(
                response.data, true);
        // _selectedcity = _citiesdropDownMenueItems[0].value;
      });
    } else {
      setState(() {
        _citiesdropDownMenueItems = null;
        print(_citiesdropDownMenueItems);
      });
    }
  }

  Future<void> getAllNotification() async {
    _dio = Dio();

    final token = CachHelper.getData(key: 'token');
    _dio.options.headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer' + token,
    };
    final response = await _dio
        .get(EndPoints.getNotification(CachHelper.getData(key: 'userId')));
    if (response.data['code'] == 200) {
      print('coooode');
      print(response.data['code']);
      setState(() {
        notificationData = NotificationData.fromJson(response.data);
      });
      return response.data;
      // setState(() {

      // });

    } else if (response.data['code'] == '401') {
      print('coooode');
      print(response.data['code'].runtimeType);
      await refreshToken();
      await getAllNotification();
    } else {
      print('coooode uuut o');
      print(response.data['code'].runtimeType);
    }
  }

  Future<void> refreshToken() async {
    _dio = Dio();
    final token = CachHelper.getData(key: 'token');
    _dio.options.headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer' + token,
    };
    final response = await _dio.post(EndPoints.refreshToken);
    if (response.data['code'] == 200) {
      final token = response.data['data']['token'];
      print(token);
      CachHelper.saveData(key: 'token', value: token);
    }
  }

  void _buildNotificationPopupDialog() async {
    return showDialog(
        context: context,
        builder: (_) => StatefulBuilder(builder: (context, _setState) {
              return AlertDialog(
                backgroundColor: Colors.transparent,
                insetPadding: EdgeInsets.zero,
                contentPadding: EdgeInsets.zero,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                content: StatefulBuilder(
                    builder: ((BuildContext context, StateSetter setter) {
                  _setState = setter;
                  var height = MediaQuery.of(context).size.height;
                  var width = MediaQuery.of(context).size.width;
                  return Container(
                      height: height / 2,
                      width: width - 100,
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Theme.of(context).cardColor,
                      ),
                      child:
                          //  FutureBuilder(
                          //     future: getAllNotification(),
                          //     builder: (context, snapshot) {
                          //       if (!snapshot.hasData) {
                          //         Center(
                          //           child: CircularProgressIndicator(
                          //               color: AppColors.primary),
                          //         );
                          //       } else if (snapshot.hasError) {
                          //         print('ThisData From SSSSSSSSS');
                          //         print(snapshot.data);
                          //         return CenterTitleWidget(
                          //           title: AppLocalizations.of(context).error,
                          //           iconData: Icons.error,
                          //         );
                          // }
                          // else {
                          // NotificationData allNotifications =
                          //     NotificationData.fromJson(snapshot.data);
                          // print(allNotifications.pageData);
                          // return
                          notificationData.pageData.data.isEmpty
                              ? Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.emoji_flags_outlined),
                                      Text(AppLocalizations.of(context)
                                          .emptyNotification)
                                    ],
                                  ),
                                )
                              : ListView.separated(
                                  shrinkWrap: true,
                                  itemCount:
                                      notificationData.pageData.data.length,
                                  separatorBuilder: (context, _) => Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 25.0),
                                    child: Divider(thickness: 1),
                                  ),
                                  itemBuilder: (context, index) {
                                    var item =
                                        notificationData.pageData.data[index];
                                    return ListTile(
                                      leading: CircleAvatar(
                                        backgroundColor: Theme.of(context)
                                            .colorScheme
                                            .background,
                                        child: Image.asset('img/logo.png',
                                            fit: BoxFit.fill),
                                      ),
                                      title: Text(item.title),
                                      subtitle: Text(item.body),
                                      trailing:
                                          Text(item.createdAt.substring(0, 10)),
                                    );
                                  },
                                )
                      //   }
                      //   return Container();
                      // }),

                      );
                })),
              );
            }));
  }

  void _buildReviewPopupDialog() async {
    // StateSetter _setState;
    categoryFilter = 0;
    cityFilter = 0;
    String categoryTitle = categoryList[0];
    String cityTitle = citiesList[0];
    return showDialog(
        context: context,
        builder: (_) => StatefulBuilder(builder: (context, _setState) {
              return AlertDialog(
                backgroundColor: Colors.transparent,
                insetPadding: EdgeInsets.zero,
                contentPadding: EdgeInsets.zero,
                clipBehavior: Clip.antiAliasWithSaveLayer,

                // insetPadding: const EdgeInsets.all(10),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),

                content: StatefulBuilder(
                  builder: (BuildContext context, StateSetter setter) {
                    _setState = setter;
                    // Get available height and width of the build area of this widget. Make a choice depending on the size.
                    var height = MediaQuery.of(context).size.height;
                    var width = MediaQuery.of(context).size.width;

                    return Container(
                      height: height / 2,
                      width: width - 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Theme.of(context).cardColor,
                      ),
                      padding: const EdgeInsets.all(4),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 5,
                            child: ListView(
                              shrinkWrap: true,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 8.0, bottom: 20.0),
                                  child: Text(
                                    AppLocalizations.of(context).filterText,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(
                                      AppLocalizations.of(context).category,
                                      style: TextStyle(
                                        // color: AppColors.primary,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: DropdownButton(
                                      isExpanded: true,
                                      menuMaxHeight:
                                          MediaQuery.of(context).size.height /
                                              3,
                                      value: categoryTitle,
                                      items: categoryList
                                          .map(buildMenuItem)
                                          .toList(),
                                      onChanged: (value) {
                                        print(categoryTitle);
                                        _setState(() {
                                          categoryFilter =
                                              categoryList.indexOf(value);
                                          categoryTitle = value;
                                        });
                                      }),
                                ),
                                // buildDropDownList(
                                //     // buildSingleItemSelectDropDownList(
                                //     title: AppLocalizations.of(context)
                                //         .category, //'فئة المنتج',
                                //     listOfItems: categoryList,
                                //     func: getCategories,
                                //     items: _categorydropDownMenueItems,
                                //     isCities: false),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 16.0, bottom: 8.0),
                                  child: Center(
                                    child: Text(
                                      AppLocalizations.of(context).city,
                                      style: TextStyle(
                                        // color: AppColors.primary,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ),

                                Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: DropdownButton(
                                      isExpanded: true,
                                      menuMaxHeight:
                                          MediaQuery.of(context).size.height /
                                              3,
                                      value: cityTitle,
                                      items: citiesList
                                          .map(buildMenuItem)
                                          .toList(),
                                      onChanged: (value) {
                                        print(cityTitle);
                                        _setState(() {
                                          cityFilter =
                                              citiesList.indexOf(value);
                                          cityTitle = value;
                                        });
                                      }),
                                ),
                                // buildDropDownList(
                                //     title: AppLocalizations.of(context)
                                //         .city, //'المدينة:',
                                //     listOfItems: citiesList,
                                //     func: getCities,
                                //     items: _citiesdropDownMenueItems,
                                //     isCities: true),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: MaterialButton(
                                color: AppColors.primary,
                                child: Text(AppLocalizations.of(context).ok),
                                onPressed: () {
                                  setState(() {
                                    isChange = true;
                                    categoryFilter = categoryFilter + 1;
                                    cityFilter = cityFilter + 1;
                                    currentPage = 1;
                                  });
                                  getPostData(
                                    searchTerm: search,
                                    refreshed: true,
                                    categoryFilter: categoryFilter,
                                    cityFilter: cityFilter,
                                  );
                                  Navigator.of(context).pop();
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
              );
            }));
  }

  // Widget buildSingleItemSelectDropDownList(
  //     {String title,
  //     List<String> listOfItems,
  //     Function() func,
  //     List<DropdownMenuItem<DropDownListModel>> items,
  //     bool isCities}) {
  //   return DropdownButton(
  //       menuMaxHeight: MediaQuery.of(context).size.height / 3,
  //       value: isCities ? cityTitle : categoryTitle,
  //       items: listOfItems.map(buildMenuItem).toList(),
  //       onChanged: (value) {
  //         setState(() {
  //           if (isCities) {
  //             listOfCities[0] = citiesList.indexOf(value);
  //             cityTitle = value;
  //           } else {
  //             listOfCategories[0] = categoryList.indexOf(value);
  //             categoryTitle = value;
  //           }
  //         });
  //       });
  // }

  DropdownMenuItem<String> buildMenuItem(String item) =>
      DropdownMenuItem(value: item, child: Text(item));

  Widget buildDropDownList(
      {String title,
      List<String> listOfItems,
      Function() func,
      List<DropdownMenuItem<DropDownListModel>> items,
      bool isCities}) {
    print('aaaaaaaaaaaaassssssddddddd');
    print(isCities);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title,
            style: TextStyle(
              // color: AppColors.primary,
              fontSize: 20,
            ),
          ),
        ),
        items == null
            ? TextButton(
                onPressed: () => func(), //func()????
                child: Icon(Icons.refresh),
              )
            : CustomMultiselectDropDown(
                listOFStrings: listOfItems,
                selectedList: isCities ? addCityFunction : addCategoryFunction,
              ),
      ],
    );
  }

  void addCityFunction(List<int> listOfItems) {
    listOfCities = listOfItems;
    print('Cities' + listOfCities.toString());
  }

  void addCategoryFunction(List<int> listOfItems) {
    listOfCategories = listOfItems;
    print('Categories' + listOfCategories.toString());
  }

  AppBar buildAppBar(BuildContext context) {
    return new AppBar(
      title: Text(AppLocalizations.of(context).title),
      centerTitle: true,
      backgroundColor: AppColors.primary,
      elevation: 10,
      actions: [
        searchBar.getSearchAction(context),
        buildFilterPopupMenuButtom(),
        CachHelper.getData(key: 'userId') != null
            ? buildNotificationPopupMenuItem()
            : Container()
      ],
    );
  }

  String search = '';
  bool isChange = false;

  void onSubmitted(String value) {
    setState(() async {
      search = value;
      setState(() {
        isChange = true;
      });
      print(isChange);
      await getPostData(
          refreshed: true, searchTerm: search, categoryFilter: -1);
      print('ayman Skhni');
      currentPage++;
      print(currentPage);
    });
  }

  _HomePageTapState() {
    searchBar = new SearchBar(
        inBar: false,
        buildDefaultAppBar: buildAppBar,
        showClearButton: true,
        clearOnSubmit: false,
        closeOnSubmit: false,
        setState: setState,
        onSubmitted: onSubmitted,
        onCleared: () {
          print(search);
          setState(() {
            search = '';
          });
          print("cleared");
        },
        onClosed: () {
          setState(() {
            setState(() {
              search = '';
              isChange = true;
            });
          });
          print("closed");
        });
  }

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  Future<Widget> getPostData(
      {bool refreshed = false,
      String searchTerm,
      int cityFilter,
      // int currentPage,
      int categoryFilter}) async {
    var addsData = await Provider.of<AddsProvider>(context, listen: false)
        .getAdds(2, currentPage);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    bool isSeller = userProvider.userMode == 'seller';
    bool isAnonymous = CachHelper.getData(key: 'userId') == null;
    final customerId = CachHelper.getData(key: 'userId');
    final postsProvider =
        Provider.of<AllPostsWithCategories>(context, listen: false);

    print('getttDataa');
    print(searchTerm);
    print('paaaggggeee');
    print(currentPage);
    print(totalPageNumber);
    print(categoryFilter);
    print(cityFilter);
    if (refreshed) {
      currentPage = 1;
      print(currentPage);
      print(totalPageNumber);
    } else if (currentPage > totalPageNumber) {
      print(currentPage);
      print(totalPageNumber);
      print('No dataaaa');
      _refreshController.loadNoData();
      // return null;
    }
    if (categoryFilter != -1 && cityFilter != -1) {
      var data = await postsRepositoryImp.getAllpostsByCategoryIdAndCityId(
          categoryFilter, cityFilter, currentPage, pageSize);
      print(data);
      allPostsData = PostsWithSellerModel.fromJson(data, false);
    } else if (categoryFilter != -1) {
      var data = await postsRepositoryImp.getAllPostsByCategoryId(
          categoryFilter, currentPage, pageSize);
      print('fffffffffffffffffffffffffffff dataaaaaa');
      print(data);
      allPostsData = PostsWithSellerModel.fromJson(data, false);
      // if (allPostsData.data.data.isEmpty) {
      //   postsProvider.setAllPost(allPostsData);
      //   print('emptyyyyyyyyyyyyyyyyyyyy');
      //   setState(() {
      //     isChange = false;
      //   });
      //   return null;
      //   // return CenterTitleWidget(
      //   //   title: AppLocalizations.of(context).empty,
      //   //   iconData: Icons.hourglass_empty,
      //   // );
      // }
    } else {
      allPostsData = await postsRepositoryImp.getAllPostsIncludeCategories(
        currentPage,
        pageSize,
        searchTerm,
      );
    }

    setState(() {
      totalPageNumber = allPostsData.data.lastPage;
    });

    print('adddds');
    print(addsData['data']['data']);
    addsData['data']['data'].forEach((element) {
      userProvider.addAdds(element['url']);
    });
    // print(userProvider.get)

    if (!isAnonymous && !isSeller) {
      followedRes = await postsRepositoryImp
          .getFollowedPostsOfCustomerByCustomerID(id: customerId);
      sellerFollower = await userProvider
          .getFollowedSellersByCustomerID(userProvider.userId);
      var followedPosts = followedRes.data[0].posts;
      List<int> ids = [];
      followedPosts.forEach((element) {
        ids.add(element['id']);
      });
      userProvider.setSavedPosts(ids);
      ids = [];
      sellerFollower['data'][0]['sellers'].forEach((element) {
        // response.entries
        ids.add(element['id']);
      });
      print('bbbbbbbbbbbbbbbbbbbbbbbb');
      userProvider.setFollowers(ids);
    }
    if (allPostsData == null) {
      return CenterTitleWidget(
        title: AppLocalizations.of(context).error,
        iconData: Icons.error,
      );
    }
    // setState(() {
    //   currentPage++;
    // });
    if (!refreshed) {
      postsProvider.addNewPosts(allPostsData.data.data);
    } else {
      postsProvider.setAllPost(allPostsData);
    }

    List<PostModel> posts = postsProvider.getDisplayedPosts();
    List<String> adds = userProvider.getAdds();
    setState(() {
      isChange = false;
    });
    if (posts.isEmpty) {
      return CenterTitleWidget(
        title: AppLocalizations.of(context).empty,
        iconData: Icons.emoji_flags_outlined,
      );
    } else {
      // if (widget.searchTerm == null) {
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
            print(item.postImages);
            // followedPosts.any((element) => element['id']==item.id);
            return Consumer<UserProvider>(
              builder: (context, user, _) {
                List<String> imagePaths = [];
                item.postImages.forEach((element) {
                  imagePaths.add('http://malldal.com/dal/' + element['url']);
                });
                return PostItem(
                  postId: item.id,
                  createdAt: item.createdAt,
                  title: item.title,
                  body: item.body,
                  priceDetails: item.priceDetails,
                  owner: item.seller,
                  paths: imagePaths,
                  isEditable: false,
                );
              },
            );
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // List<String> filterItems = [
    //   AppLocalizations.of(context).city,
    //   AppLocalizations.of(context).category,
    // ];

    final userProvider = Provider.of<UserProvider>(context);
    final postsProvider = Provider.of<AllPostsWithCategories>(context);
    List<String> adds = userProvider.getAdds();

    if (isChange) {
      getPostData(
              refreshed: true,
              categoryFilter: categoryFilter,
              cityFilter: cityFilter,
              searchTerm: search)
          .then((_) {
        setState(() {
          currentPage++;
          isChange = false;
        });
      });
    }

    // final addsProvider = Provider.of<AddsProvider>(context, listen: false);
    // // final userProvider = Provider.of<UserProvider>(context, listen: false);
    // bool isSeller = userProvider.userMode == 'seller';
    // bool isAnonymous = CachHelper.getData(key: 'userId') == null;
    // final customerId = CachHelper.getData(key: 'userId');
    // // final postsProvider =
    // //     Provider.of<AllPostsWithCategories>(context, listen: false);
    // int currentPage = 1;
    // int totalPage = 2;

    // var prevPage = 0.0;
    // if (postsProvider.getAllPost().data != null) {
    //   currentPage = prevPage.round();
    //   if (prevPage > prevPage.round()) {
    //     currentPage++;
    //   }
    //   prevPage = postsProvider.getDisplayedPosts().length / pageSize;
    // }

    setState(() {
      print('inside');
      print(search);
    });

    // userProvider.index = -1;
    // int totalPageNumber = 2;

    return Scaffold(
      // backgroundColor: AppColors.background,
      drawer: MyDrawer(),
      drawerScrimColor: AppColors.primary.withOpacity(0.7),
      // appBar: searchBar.build(context),
      key: _scaffoldKey,
      // body: new Center(1648486844
      //     child: new Text("Don't look at me! Press the search button!")),
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).title),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        elevation: 10,
        // leading: //buildFilterPopupMenuButtom(),
        actions: [
          // searchBar.getSearchAction(context),
          Expanded(child: searchBar.build(context)),
          // buildFilterPopupMenuButtom(),
        ],

        // actions: [searchBar.build(context), buildFilterPopupMenuButtom()],
      ),

      body: SmartRefresher(
        footer: const ClassicFooter(loadStyle: LoadStyle.ShowWhenLoading),
        controller: _refreshController,
        enablePullDown: true,
        enablePullUp: true,
        header: WaterDropMaterialHeader(
          backgroundColor: AppColors.primary,
        ),

        onRefresh: () async {
          setState(() {
            currentPage = 1;
            categoryFilter = -1;
            cityFilter = -1;
          });
          // search = '';
          var widget = await getPostData(
              refreshed: true,
              searchTerm: search,
              categoryFilter: categoryFilter,
              cityFilter: cityFilter);
          if (widget != null) {
            userProvider.index = -1;
            setState(() {
              currentPage++;
            });
            _refreshController.refreshCompleted();
          } else {
            _refreshController.refreshFailed();
          }
        },
        onLoading: () async {
          var widget = await getPostData(
              searchTerm: search,
              categoryFilter: categoryFilter,
              cityFilter: cityFilter);
          print(widget.toString());
          if (widget == null) {
            print('no data under');
            _refreshController.loadNoData();
          }
          if (widget != null) {
            setState(() {
              currentPage++;
            });
            _refreshController.loadComplete();
          }

          // postsProvider.removeFirst();

          // postsProvider.getAllPost();
          // return getPostData();
        },
        // color: AppColors.primary,
        // displacement: MediaQuery.of(context).size.height / 10,
        child: isChange
            ? Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
              )
            :
            // postsProvider.getAllPost().data == null || isChange
            //     ? FutureBuilder(
            //         future: getPostData(refreshed: true, searchTerm: search),
            //         builder: (context, snapshot) {
            //           if (snapshot.connectionState == ConnectionState.waiting) {
            //             return Center(
            //               child: CircularProgressIndicator(
            //                 valueColor:
            //                     AlwaysStoppedAnimation<Color>(AppColors.primary),
            //               ),
            //             );
            //           } else if (snapshot.hasError) {
            //             print('ThisData From SSSSSSSSS');
            //             print(snapshot.data);
            //             return CenterTitleWidget(
            //               title: AppLocalizations.of(context).error,
            //               iconData: Icons.error,
            //             );
            //           } else {
            //             return snapshot.data;
            //           }
            //         },
            //       )
            //     :
            postsProvider.getDisplayedPosts().isEmpty
                ? CenterTitleWidget(
                    title: AppLocalizations.of(context).empty,
                    iconData: Icons.error,
                  )
                : ListView.separated(
                    physics: AlwaysScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemCount: postsProvider.getDisplayedPosts().length,
                    separatorBuilder: (context, index) {
                      if (index % 4 == 0) {
                        // String path = userProvider.getNextAdds();
                        String path = '';
                        if (index ~/ 4 < adds.length) {
                          path = adds[index ~/ 4];
                        }
                        if (path.isNotEmpty) {
                          print("adddssssss Pathhhhhhh");
                          print(path);
                          print(userProvider.getAdds);
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
                      // return AddImageItem(userProvider.getAdds[index]);
                      return Container();
                    },
                    itemBuilder: (context, index) {
                      var item = postsProvider.getDisplayedPosts()[index];
                      // followedPosts.any((element) => element['id']==item.id);
                      return Consumer<UserProvider>(
                        builder: (context, user, _) {
                          List<String> imagePaths = [];
                          item.postImages.forEach((element) {
                            imagePaths.add(
                                'http://malldal.com/dal/' + element['url']);
                          });
                          return Padding(
                            padding:
                                EdgeInsets.only(top: 3, left: 10, right: 10),
                            child: PostItem(
                              postId: item.id,
                              createdAt: item.createdAt,
                              title: item.title,
                              body: item.body,
                              priceDetails: item.priceDetails,
                              owner: item.seller,
                              paths: imagePaths,
                              isEditable: false,
                            ),
                          );
                        },
                      );
                    },
                  ),
      ),
    );
  }
}
