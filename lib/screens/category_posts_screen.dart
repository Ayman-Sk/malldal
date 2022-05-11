import 'package:dal/business_logic_layer/user_provider.dart';
import 'package:dal/data_layer/models/followed_posts_by_customer_model.dart';
import 'package:dal/data_layer/repositories/posts_repositories.dart';
import 'package:dal/theme/app_colors.dart';
import 'package:dal/widgets/Post/post_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../data_layer/models/post_with_sellers_model.dart';

class CategoryPostsScreen extends StatefulWidget {
  static const routeName = 'CategoryPostsScreen';
  @override
  _CategoryPostsScreenState createState() => _CategoryPostsScreenState();
}

class _CategoryPostsScreenState extends State<CategoryPostsScreen> {
  SearchBar searchBar;

  // PostsWithSellerModel allPostsData = PostsWithSellerModel();
  FollowedPostsByCustomerModel followedRes = FollowedPostsByCustomerModel();
  Map<String, dynamic> sellerFollower = {};
  PostsRepositoryImp postsRepositoryImp = PostsRepositoryImp();
  final _refreshController = RefreshController(initialRefresh: true);
  int totalPages = 2;
  int pageSize = 5;
  int currentPage = 1;
  List<dynamic> posts = [];

  int catId;

  int whatIsCategoryId() {
    if (catId != null) {
      return catId;
    }
    Map<String, int> arguments = ModalRoute.of(context).settings.arguments;
    return arguments['id'];
  }

  Future<dynamic> getPostData({bool refreshed = false}) async {
    int id = whatIsCategoryId();
    print(id.runtimeType);
    print(id);
    if (refreshed == true) {
      currentPage = 1;
    }
    if (currentPage > totalPages) {
      _refreshController.loadNoData();
      return false;
    }
    print('willll get');
    var data = await postsRepositoryImp.getAllPostsByCategoryId(
        id, currentPage, pageSize);
    print('gettted');
    if (data['code'] == 200) {
      if (refreshed) {
        posts = data['data']['data'];
      } else {
        posts.addAll(data['data']['data']);
      }
      print('llllllasttt paggge');

      totalPages = data['data']['last_page'];
      print(totalPages);
      currentPage += 1;
      print('current pagggge number');
      print(currentPage);

      setState(() {});
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    List<String> adds = userProvider.getAdds();
    return Scaffold(
      drawerScrimColor: AppColors.primary.withOpacity(0.7),
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).title),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        elevation: 10,
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
          final result = await getPostData(refreshed: true);
          if (result) {
            _refreshController.refreshCompleted();
          } else {
            _refreshController.refreshFailed();
          }
        },
        onLoading: () async {
          final result = await getPostData(refreshed: false);
          if (result) {
            _refreshController.loadComplete();
          } else {
            _refreshController.loadFailed();
          }
        },
        child: ListView.separated(
          physics: AlwaysScrollableScrollPhysics(),
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
            print('this is posstssss');
            print(posts);
            print('lllllength');
            print(posts.length);
            // followedPosts.any((element) => element['id']==item.id);
            List<String> imagePaths = [];

            item['post_images'].forEach((element) {
              imagePaths.add('http://malldal.com/dal/' + element['url']);
            });

            return Padding(
              padding: EdgeInsets.only(top: 3, left: 10, right: 10),
              child: PostItem(
                postId: item['id'],
                createdAt: item['created_at'],
                title: item['title'],
                body: item['body'],
                priceDetails: item['priceDetails'],
                averageRate: item['avgRate'].toString(),
                owner: Seller.fromJson(item['seller']),
                paths: imagePaths,
                isEditable: false,
              ),
            );
          },
        ),
      ),
    );
  }
}
