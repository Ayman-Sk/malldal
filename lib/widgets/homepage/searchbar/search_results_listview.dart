import 'package:dal/business_logic_layer/all_posts_with_categories.dart';
import 'package:dal/business_logic_layer/user_provider.dart';
import 'package:dal/data_layer/models/followed_posts_by_customer_model.dart';
import 'package:dal/data_layer/models/post_with_sellers_model.dart';
import 'package:dal/data_layer/repositories/posts_repositories.dart';
import 'package:dal/network/local_host.dart';
import 'package:dal/widgets/center_title_widget.dart';
import 'package:dal/theme/app_colors.dart';
// import 'package:dal/widgets/post_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../Post/post_item.dart';

class SearchResultsListView extends StatefulWidget {
  final String searchTerm;
  SearchResultsListView({this.searchTerm});

  @override
  _SearchResultsListViewState createState() => _SearchResultsListViewState();
}

class _SearchResultsListViewState extends State<SearchResultsListView> {
  PostsRepositoryImp postsRepositoryImp = PostsRepositoryImp();

  List<Object> postsAndAddsList = [];

  bool isAnonymous = CachHelper.getData(key: 'userId') == null;

  RefreshController _refreshController = RefreshController(initialRefresh: false);

  bool isRefreshed = true;
  int currentPage = 1;
  List<dynamic> gatAllMatchedProducts(String searchTerm, List<PostModel> posts) {
    List<PostModel> matchedProducts = [];
    for (var item in posts) {
      // var index = posts.indexOf(item);
      if (item.title == searchTerm) {
        print("\n%%%%%%%%%%%%%%%%%%\n" + item.title + '\n%%%%%%%%%%%%%%%%%%\n');
        matchedProducts.add(item);
      }
    }
    return matchedProducts;
  }

  @override
  Widget build(BuildContext context) {
    final postsProvider = Provider.of<AllPostsWithCategories>(context);
    // final addsProvider = Provider.of<AddsProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context);
    final customerId = CachHelper.getData(key: 'userId');
    // final userMode = CachHelper.getData(key: 'userMode');
    bool isSeller = userProvider.userMode == 'seller';
    PostsWithSellerModel allPostsData = PostsWithSellerModel();
    FollowedPostsByCustomerModel followedRes = FollowedPostsByCustomerModel();
    Map<String, dynamic> sellerFollower = {};
    List<String> adds = userProvider.getAdds();

    Future<Widget> getPostData({bool refreshed = false}) async {
      if (refreshed) {
        currentPage = 1;
      }
      allPostsData = await postsRepositoryImp.getAllPostsIncludeCategories(
        currentPage,
        3,
        '',
      );
      if (!isAnonymous && !isSeller) {
        followedRes = await postsRepositoryImp.getFollowedPostsOfCustomerByCustomerID(id: customerId);
        sellerFollower = await userProvider.getFollowedSellersByCustomerID(userProvider.userId);
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
      currentPage++;
      List<PostModel> posts = postsProvider.getDisplayedPosts();
      if (posts.isEmpty) {
        CenterTitleWidget(
          title: AppLocalizations.of(context).empty,
          iconData: Icons.emoji_flags_outlined,
        );
      } else {
        if (widget.searchTerm == null) {
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
                    );
                  },
                );
              },
            ),
          );
        } else if (gatAllMatchedProducts(widget.searchTerm, posts).isEmpty) {
          return CenterTitleWidget(
            title: AppLocalizations.of(context).emptyPostsSearch,
            iconData: Icons.emoji_flags_outlined,
          );
        } else {
          return Container(
            padding: EdgeInsets.only(top: 50, bottom: 80),
            child: ListView(
              children: gatAllMatchedProducts(widget.searchTerm, posts).map((e) {
                // var index = gatAllMatchedProducts(widget.searchTerm, posts)
                //     .indexOf(e);
                return PostItem(
                  postId: e.id,
                  createdAt: e.createdAt,
                  title: e.title,
                  body: e.body,
                  priceDetails: e.priceDetails,
                  averageRate: e.avgRate,
                  owner: e.seller,
                );
              }).toList(),
            ),
          );
        }
      }
      return CenterTitleWidget(
        title: AppLocalizations.of(context).empty,
        iconData: Icons.emoji_flags_outlined,
      );
    }

    return SmartRefresher(
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
        var widget = await getPostData(refreshed: true);
        if (widget != null) {
          _refreshController.refreshCompleted();
        } else {
          _refreshController.refreshFailed();
        }
      },
      onLoading: () {
        var widget = getPostData();
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
      child: postsProvider.getAllPost().data != null
          ? postsProvider.getDisplayedPosts().isEmpty
              ? CenterTitleWidget(
                  title: AppLocalizations.of(context).empty,
                  iconData: Icons.error,
                )
              : ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(),
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
                    var item = postsProvider.getDisplayedPosts()[index];
                    // followedPosts.any((element) => element['id']==item.id);
                    return Consumer<UserProvider>(
                      builder: (context, user, _) {
                        return Padding(
                          padding: EdgeInsets.only(top: 3, left: 10, right: 10),
                          child: PostItem(
                            postId: item.id,
                            createdAt: item.createdAt,
                            title: item.title,
                            body: item.body,
                            priceDetails: item.priceDetails,
                            averageRate: item.avgRate,
                            owner: item.seller,
                          ),
                        );
                      },
                    );
                  },
                )

          ///////////////////
          : FutureBuilder(
              future: getPostData(refreshed: true),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
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
            ),
    );
  }
}
