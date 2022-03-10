import 'package:dal/business_logic_layer/adds_provider.dart';
import 'package:dal/business_logic_layer/all_posts_with_categories.dart';
import 'package:dal/business_logic_layer/user_provider.dart';
import 'package:dal/data_layer/models/followed_posts_bycustomer_model.dart';
import 'package:dal/data_layer/models/post_with_sellers_model.dart';
import 'package:dal/data_layer/repositories/posts_repositories.dart';
import 'package:dal/network/local_host.dart';
import 'package:dal/screens/filter_screen.dart';
import 'package:dal/theme/app_colors.dart';
import 'package:dal/widgets/center_title_widget.dart';
import 'package:dal/widgets/homepage/add_image_item.dart';
import 'package:dal/widgets/myDrawer.dart';
import 'package:dal/widgets/post_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomePageTap extends StatefulWidget {
  @override
  _HomePageTapState createState() => _HomePageTapState();
}

class _HomePageTapState extends State<HomePageTap> {
  SearchBar searchBar;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  int currentPage = 1;
  PostsWithSellerModel allPostsData = PostsWithSellerModel();
  FollowedPostsByCustomerModel followedRes = FollowedPostsByCustomerModel();
  Map<String, dynamic> sellerFollower = {};
  PostsRepositoryImp postsRepositoryImp = PostsRepositoryImp();

  Widget buildFilterPopupMenuButtom(BuildContext context) {
    List<String> filterItems = [
      AppLocalizations.of(context).city,
      AppLocalizations.of(context).category,
    ];
    return PopupMenuButton<String>(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20))),
      icon: Icon(Icons.filter_alt),
      // onSelected: choiceAction,
      itemBuilder: (BuildContext context) {
        return filterItems.map((String choice) {
          return PopupMenuItem<String>(
            value: choice,
            child: GestureDetector(
              child: Text(choice),
              onTap: () {
                print(choice);
                Navigator.of(context)
                    .pushNamed(FilterScreen.routeName, arguments: choice)
                    .then(
                  (ele) {
                    setState(
                      () {
                        Provider.of<AllPostsWithCategories>(context,
                                listen: false)
                            .getDisplayedPosts();
                      },
                    );
                    Navigator.pop(context);
                  },
                );
              },
            ),
          );
        }).toList();
      },
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return new AppBar(
      title: Text(AppLocalizations.of(context).title),
      centerTitle: true,
      backgroundColor: AppColors.primary,
      elevation: 10,

      // leading: buildFilterPopupMenuButtom(),
      actions: [
        searchBar.getSearchAction(context),
        buildFilterPopupMenuButtom(context),
      ],
    );
  }

  String search = '';
  bool isChange = false;

  void onSubmitted(String value) {
    // getPostData(search: value, refreshed: false, context: context);
    setState(() {
      search = value;
      isChange = true;
      print(isChange);
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
            search = '';
            isChange = true;
          });
          print("closed");
        });
  }

  @override
  Widget build(BuildContext context) {
    // List<String> filterItems = [
    //   AppLocalizations.of(context).city,
    //   AppLocalizations.of(context).category,
    // ];

    setState(() {
      print('inside');
      print(search);
    });
    final userProvider = Provider.of<UserProvider>(context);
    final postsProvider = Provider.of<AllPostsWithCategories>(context);
    final addsProvider = Provider.of<AddsProvider>(context, listen: false);
    final customerId = CachHelper.getData(key: 'userId');
    bool isSeller = userProvider.userMode == 'seller';
    bool isAnonymous = CachHelper.getData(key: 'userId') == null;
    RefreshController _refreshController =
        RefreshController(initialRefresh: false);

    userProvider.index = -1;
    int pageNumber = 2;

    Future<Widget> getPostData(
        {bool refreshed = false, String searchTerm}) async {
      print('getttDataa');
      print(searchTerm);
      if (refreshed) {
        currentPage = 1;
      } else if (currentPage > pageNumber) {
        print(currentPage);
        print(pageNumber);
        print('No dataaaa');
        // _refreshController.loadNoData();
        return null;
      }
      allPostsData = await postsRepositoryImp.getAllPostsIncludeCategories(
        currentPage,
        3,
        searchTerm,
      );

      pageNumber = allPostsData.data.lastPage;

      var addsData = await addsProvider.getAdds();
      print('adddds');
      print(addsData['data']['data']);
      addsData['data']['data'].forEach((element) {
        userProvider.addAdds(element['url']);
      });

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
      if (!refreshed) {
        postsProvider.addNewPosts(allPostsData.data.data);
      } else {
        postsProvider.setAllPost(allPostsData);
      }

      List<PostModel> posts = postsProvider.getDisplayedPosts();
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
              // print(userProvider.getAdds[index]);
              if (index % 4 == 0) {
                String path = userProvider.getNextAdds;
                if (path.isNotEmpty) {
                  return Image.network('http://malldal.com/dal/' + path);
                }
              }
              // return AddImageItem(userProvider.getAdds[index]);
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
                    nameOfSeller: item.seller.user.name,
                    createdAt: item.seller.createdAt,
                    title: item.title,
                    body: item.body,
                    priceDetails: item.priceDetails,
                    avgRate: item.avgRate,
                    ownerUser: item.seller,
                    price: item.priceDetails,
                    paths: imagePaths,
                  );
                },
              );
            },
          ),
        );
      }
    }

    return Scaffold(
      // backgroundColor: AppColors.background,
      drawer: MyDrawer(),
      drawerScrimColor: AppColors.primary.withOpacity(0.7),
      // appBar: searchBar.build(context),
      key: _scaffoldKey,
      // body: new Center(
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
      body:
          //  SearchResultsListView()
          SmartRefresher(
        footer: const ClassicFooter(loadStyle: LoadStyle.ShowWhenLoading),
        controller: _refreshController,
        enablePullDown: true,
        enablePullUp: true,
        header: WaterDropMaterialHeader(
          backgroundColor: AppColors.primary,
        ),
        // footer:
        // CustomFooter(
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
          search = '';
          var widget = await getPostData(refreshed: true, searchTerm: search);
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
        onLoading: () {
          var widget = getPostData(searchTerm: search);
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
        child: postsProvider.getAllPost().data == null || isChange
            ? FutureBuilder(
                future: getPostData(refreshed: true, searchTerm: search),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(AppColors.primary),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    print('ThisData From SSSSSSSSS');
                    print(snapshot.data);
                    return CenterTitleWidget(
                      title: AppLocalizations.of(context).error,
                      iconData: Icons.error,
                    );
                  } else {
                    return snapshot.data;
                  }
                },
              )
            : postsProvider.getDisplayedPosts().isEmpty
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
                        String path = userProvider.getNextAdds;
                        if (path.isNotEmpty) {
                          return Container(
                            padding: const EdgeInsets.all(8),
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height / 3,
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
                              nameOfSeller: item.seller.user.name,
                              createdAt: item.seller.createdAt,
                              title: item.title,
                              body: item.body,
                              priceDetails: item.priceDetails,
                              avgRate: item.avgRate,
                              ownerUser: item.seller,
                              price: item.priceDetails,
                              paths: imagePaths,
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
