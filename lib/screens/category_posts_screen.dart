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

class CategoryPostsScreen extends StatefulWidget {
  static const routeName = 'CategoryPostsScreen';
  @override
  _CategoryPostsScreenState createState() => _CategoryPostsScreenState();
}

class _CategoryPostsScreenState extends State<CategoryPostsScreen> {
  SearchBar searchBar;

  int currentPage = 1;
  // PostsWithSellerModel allPostsData = PostsWithSellerModel();
  FollowedPostsByCustomerModel followedRes = FollowedPostsByCustomerModel();
  Map<String, dynamic> sellerFollower = {};
  PostsRepositoryImp postsRepositoryImp = PostsRepositoryImp();

  bool hasData = false;

  @override
  Widget build(BuildContext context) {
    Map<String, int> arguments = ModalRoute.of(context).settings.arguments;
    print(arguments['id']);
    // int i = arguments['id'];

    final userProvider = Provider.of<UserProvider>(context, listen: false);

    RefreshController _refreshController =
        RefreshController(initialRefresh: false);
    // AllPostsWithCategories allPostsWithCategories = AllPostsWithCategories();
    int pageNumber = 1;
    int pageSize = 50;
    List<dynamic> posts;
    Future<Object> getPostData(int id) async {
      print('willll get');
      var data = await postsRepositoryImp.getAllPostsByCategoryId(
          id, pageNumber, pageSize);
      print('gettted');

      if (data == null) {
        return CenterTitleWidget(
          title: AppLocalizations.of(context).error,
          iconData: Icons.error,
        );
      }
      print(data);
      // allPostsWithCategories.setAllPost(data);
      // allPostsWithCategories.addNewPosts(allPostsData.data.data);

      // List<PostModel> posts = allPostsWithCategories.getDisplayedPosts();

      if (data['data']['data'].isEmpty) {
        return CenterTitleWidget(
          title: AppLocalizations.of(context).empty,
          iconData: Icons.emoji_flags_outlined,
        );
      } else {
        posts = data['data']['data'];

        return Container(
          // padding: EdgeInsets.only(top: 50),
          child: ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemCount: posts.length,
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
              var item = posts[index]; //posts[index];
              print('itttemmmms');
              print(item);
              List<String> imagePaths = [];
              item['post_images'].forEach((element) {
                imagePaths.add('http://malldal.com/dal/' + element['url']);
              });
              // followedPosts.any((element) => element['id']==item.id);
              return Consumer<UserProvider>(
                builder: (context, user, _) {
                  return PostItem(
                    postId: item['id'],
                    nameOfSeller: item['seller']['user']['name'],
                    createdAt: item['seller']['created_at'],
                    title: item['title'],
                    body: item['body'],
                    priceDetails: item['priceDetails'],
                    avgRate: item['avgRate'],
                    ownerUser: Seller.fromJson(item['seller']),
                    price: item['priceDetails'],
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
      // drawer: MyDrawer(),
      drawerScrimColor: AppColors.primary.withOpacity(0.7),
      // appBar: searchBar.build(context),
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
          // Expanded(child: searchBar.build(context)),
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
              //  CustomFooter(
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
                var widget = await getPostData(arguments['id']);
                if (widget != null) {
                  _refreshController.refreshCompleted();
                } else {
                  _refreshController.refreshFailed();
                }
              },
              onLoading: () {
                var widget = getPostData(arguments['id']);
                if (widget != null) {
                  _refreshController.loadComplete();
                } else {
                  _refreshController.loadFailed();
                }

                // postsProvider.removeFirst();

                // postsProvider.getAllPost();
                // return getPostData();
              },
              // color: AppColors.primary,
              // displacement: MediaQuery.of(context).size.height / 10,
              child:
                  // hasData == false
                  //     ?
                  // postsProvider.getAllPost().data == null || isChange
                  //     ?
                  FutureBuilder(
                future: getPostData(arguments['id']),
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
                    print(
                        'pstssssDataaapstssssDataaapstssssDataaapstssssDataaapstssssDataaapstssssDataaapstssssDataaapstssssDataaapstssssDataaapstssssDataaapstssssDataaa');
                    // print(posts);
                    // print(snapshot.data);
                    // posts = snapshot.data;
                    return snapshot.data;
                    hasData = true;
                    // // setState(() {
                    // //   hasData = true;
                    // // });
                    // return Container();
                    //snapshot.data;
                  }
                },
              )
              // : ListView.separated(
              //     physics: AlwaysScrollableScrollPhysics(),
              //     scrollDirection: Axis.vertical,
              //     itemCount: posts.length,
              //     separatorBuilder: (context, index) {
              //       if (index % 4 == 0) {
              //         String path = userProvider.getNextAdds;
              //         if (path.isNotEmpty) {
              //           return Container(
              //             padding: const EdgeInsets.all(8),
              //             width: MediaQuery.of(context).size.width,
              //             height: MediaQuery.of(context).size.height / 3,
              //             child: Image.network(
              //               'http://malldal.com/dal/' + path,
              //               fit: BoxFit.fill,
              //             ),
              //           );
              //         }
              //       }
              //       // return AddImageItem(userProvider.getAdds[index]);
              //       return Container();
              //     },
              //     itemBuilder: (context, index) {
              //       var item = posts[index]; //posts[index];
              //       print('itttemmmms');
              //       print(item);
              //       List<String> imagePaths = [];
              //       item['post_images'].forEach((element) {
              //         imagePaths.add('http://malldal.com/dal/' + element['url']);
              //       });
              //       // followedPosts.any((element) => element['id']==item.id);
              //       return Consumer<UserProvider>(
              //         builder: (context, user, _) {
              //           return PostItem(
              //             postId: item['id'],
              //             nameOfSeller: item['seller']['user']['name'],
              //             createdAt: item['seller']['created_at'],
              //             title: item['title'],
              //             body: item['body'],
              //             priceDetails: item['priceDetails'],
              //             avgRate: item['avgRate'],
              //             ownerUser: Seller.fromJson(item['seller']),
              //             price: item['priceDetails'],
              //             paths: imagePaths,
              //           );
              //         },
              //       );
              //     },
              //   ),
              ),
    );
  }
}
