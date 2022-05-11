import 'package:dal/business_logic_layer/user_provider.dart';
import 'package:dal/data_layer/models/followed_posts_by_customer_model.dart';
import 'package:dal/data_layer/models/post_with_sellers_model.dart';
import 'package:dal/data_layer/repositories/posts_repositories.dart';
import 'package:dal/network/local_host.dart';
import 'package:dal/theme/app_colors.dart';
import 'package:dal/widgets/center_title_widget.dart';
import 'package:dal/widgets/myDrawer.dart';
import 'package:dal/widgets/Post/post_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FollowedPostsTap extends StatefulWidget {
  @override
  State<FollowedPostsTap> createState() => _FollowedPostsTapState();
}

class _FollowedPostsTapState extends State<FollowedPostsTap> {
  PostsRepositoryImp postsRepositoryImp = PostsRepositoryImp();

  final token = CachHelper.getData(key: 'token');

  final customerId = CachHelper.getData(key: 'userId');
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    print(customerId);
    userProvider.index = -1;
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
      body: FutureBuilder(
        future: postsRepositoryImp.getFollowedPostsOfCustomerByCustomerID(
            id: customerId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            print('\n\n%%%%waiting%%%%%\n\n');
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            );
          } else if (snapshot.hasData) {
            print('\n\n%%%%hasData%%%%%\n\n');
            FollowedPostsByCustomerModel res = snapshot.data;

            var posts = res.data[0].posts;
            print(posts);
            if (posts.isEmpty) {
              print('\n\n%%%%posts.isEmpty%%%%%\n\n');
              return CenterTitleWidget(
                title: AppLocalizations.of(context)
                    .emptySavedPosts, //'لا يوجد منتجات مفضلة بعد',
                iconData: Icons.emoji_flags_outlined,
              );
            } else {
              print('\n\n%%%%posts is%%%%%\n\n');
              List<String> adds = userProvider.getAdds();
              return Container(
                padding: EdgeInsets.only(
                  top: 0,
                ),
                child: ListView.separated(
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
                    print(item);
                    List<String> imagePaths = [];
                    item['post_images'].forEach((element) {
                      imagePaths
                          .add('http://malldal.com/dal/' + element['url']);
                    });
                    return Padding(
                      padding:
                          const EdgeInsets.only(top: 3, left: 10, right: 10),
                      child: PostItem(
                        // postId: item.,
                        postId: item["id"],
                        // nameOfSeller: item["seller"]["user"]["name"],
                        createdAt: item["created_at"],
                        title: item["title"],
                        body: item["body"],
                        priceDetails: item["priceDetails"],
                        averageRate: item["avgRate"].toString(),
                        // isInteract: true,
                        owner: Seller.fromJson(item['seller']),

                        paths: imagePaths,
                        isEditable: false,
                      ),
                    );
                  },
                ),
              );
            }
          } else if (snapshot.hasError) {
            return CenterTitleWidget(
              title: AppLocalizations.of(context).error, //'حصل خطأ في التحميل',
              iconData: Icons.error,
            );
          }
          return Center(
            child: Text('ssssss'),
          );
        },
      ),
    );
  }
}
