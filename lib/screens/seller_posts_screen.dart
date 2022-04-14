import 'package:dal/business_logic_layer/user_provider.dart';
import 'package:dal/theme/app_colors.dart';
import 'package:dal/widgets/center_title_widget.dart';
import 'package:dal/widgets/myDrawer.dart';
import 'package:dal/widgets/Post/post_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../data_layer/models/post_with_sellers_model.dart';
import '../network/dio_helper.dart';
import '../network/end_points.dart';

class SellerPostScreen extends StatefulWidget {
  static const routeName = 'SellerPostScreen';

  @override
  State<SellerPostScreen> createState() => _SellerPostScreenState();
}

class _SellerPostScreenState extends State<SellerPostScreen> {
  // bool isRequest = false;
  int currentPageNumber = 1;
  int totalPageNumber = 2;
  int pageSize = 1;
  List<PostModel> posts = [];
  // bool isLoading = true;
  RefreshController _refreshController =
      RefreshController(initialRefresh: true);

  Future<bool> getSellerPosts(bool isRefresh, bool isRequest, int id,
      int pageNumber, int pageSize) async {
    // try {
    dynamic response = isRequest
        ? await DioHelper.sellerPosts(
            url: EndPoints.getPostRequestBySellerID(id, pageNumber, pageSize),
            lang: 'en',
            isRequset: isRequest)
        : await DioHelper.sellerPosts(
            url: EndPoints.getPostsBySellerID(id, pageNumber, pageSize),
            lang: 'en',
            isRequset: isRequest);

    if (response.data['status'] == 'true') {
      print('\npppossstsssResponse : ${response.data}');
      totalPageNumber = response.data['data']['last_page'];
      if (isRefresh) {
        posts = [];
      }

      List allPosts = response.data['data']['data'];

      allPosts.forEach(
        (element) {
          PostModel model = PostModel.fromJson(element);
          posts.add(model);
          // print(_myUser.posts);
          // isRequest ? _myUser.postRequest.add(model) : _myUser.posts.add(model);
          // print(_myUser.posts.length);
        },
      );
      // posts.add(value)
      setState(() {
        // isLoading =false;
        currentPageNumber++;
      });
      return true;
    } else {
      print('Error in get Postsss');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    // var sellerProvider = Provider.of<UserProvider>(context, listen: false);
    final arguments = ModalRoute.of(context).settings.arguments as Map;

    // Future<bool> _myData;
    print('idddddddddddddddddddddddddddd');
    print(arguments['userId']);
    // if (arguments != null) {
    //   sellerProvider.getSellerPosts(arguments['isRequest'], arguments['userId'], currentPageNumber, pageSize);
    //   _myData = sellerProvider.getSellerPosts(arguments['isRequest'], arguments['userId'], currentPageNumber, pageSize);
    // }

    return Scaffold(
      // backgroundColor: AppColors.background,
      drawer: MyDrawer(),
      appBar: AppBar(
          centerTitle: true,
          title: Text(arguments['isRequest']
              ? AppLocalizations.of(context).posts
              : AppLocalizations.of(context).pendingPosts),
          // title: arguments['isRequest']?Text(AppLocalizations.of(context).posts):Text(AppLoca),
          backgroundColor: AppColors.primary,
          leading: IconButton(
              onPressed: Navigator.of(context).pop,
              icon: Icon(Icons.arrow_back_sharp))),
      body: SmartRefresher(
          controller: _refreshController,
          enablePullDown: true,
          enablePullUp: true,
          header: WaterDropMaterialHeader(backgroundColor: AppColors.primary),
          footer: const ClassicFooter(loadStyle: LoadStyle.ShowWhenLoading),
          onRefresh: () async {
            setState(() {
              currentPageNumber = 1;
            });
            // sellerProvider.getSellerPosts(arguments['isRequest'], arguments['userId'],currentPageNumber,pageSize);
            bool getPosts = await getSellerPosts(true, arguments['isRequest'],
                arguments['userId'], currentPageNumber, pageSize);

            if (getPosts) {
              setState(() {
                _refreshController.refreshCompleted();
              });
            } else {
              _refreshController.refreshFailed();
            }
          },
          onLoading: () async {
            print('asdasdas');
            print(totalPageNumber);
            print(currentPageNumber);
            if (totalPageNumber < currentPageNumber) {
              print('sss');
              print(totalPageNumber);
              print(currentPageNumber);
              setState(() {
                _refreshController.loadComplete();
                _refreshController.loadNoData();
              });
              // _refreshController.loadNoData();
            } else {
              bool getPosts = await getSellerPosts(
                  false,
                  arguments['isRequest'],
                  arguments['userId'],
                  currentPageNumber,
                  pageSize);
              if (getPosts) {
                _refreshController.loadComplete();
              } else {
                _refreshController.loadFailed();
              }
            }
          },
          child: posts.isEmpty
              ? CenterTitleWidget(
                  title: AppLocalizations.of(context).empty,
                  iconData: Icons.flag)
              // isLoading
              //     ? Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary)))
              //     :
              : ListView.builder(
                  itemCount: posts
                      .length, //arguments['isRequest'] ? sellerProvider.postRequest.length : sellerProvider.posts.length,
                  itemBuilder: (context, index) {
                    var item = posts[
                        index]; //arguments['isRequest'] ? sellerProvider.postRequest[index] : sellerProvider.posts[index];

                    List<String> paths = [];
                    item.postImages.forEach((element) {
                      paths.add('http://malldal.com/dal/' + element['url']);
                    });
                    return PostItem(
                      postId: item.id,
                      createdAt: item.createdAt,
                      title: item.title,
                      body: item.body,
                      priceDetails: item.priceDetails,
                      averageRate: item.avgRate,
                      owner: item.seller,
                      paths: paths,
                    );
                  },
                )
          // FutureBuilder(
          //   future: sellerProvider.getSellerPosts(arguments['isRequest'], arguments['userId']),
          //   builder: (context, snapshot) {
          //     if (snapshot.connectionState == ConnectionState.waiting)
          //       return Center(
          //         child: CircularProgressIndicator(
          //           valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
          //         ),
          //       );
          //     else if (snapshot.hasData) {
          //       // print('000000000000000000000');
          //       // print(sellerProvider.posts[0]);
          //       print(snapshot.data);
          //       if (snapshot.data == false) {
          //         return Center(
          //           child: IconButton(
          //             icon: Icon(
          //               Icons.restart_alt_outlined,
          //               size: MediaQuery.of(context).size.width / 10,
          //               color: AppColors.primary,
          //             ),
          //             onPressed: () {
          //               setState(() {
          //                 _myData = sellerProvider.getSellerPosts(arguments['isRequest'], arguments['userId']);
          //               });
          //             },
          //           ),
          //         );
          //       }
          //       return ListView.builder(
          //         itemCount: arguments['isRequest'] ? sellerProvider.postRequest.length : sellerProvider.posts.length,
          //         itemBuilder: (context, index) {
          //           var item = arguments['isRequest'] ? sellerProvider.postRequest[index] : sellerProvider.posts[index];
          //
          //           List<String> paths = [];
          //           item.postImages.forEach((element) {
          //             paths.add('http://malldal.com/dal/' + element['url']);
          //           });
          //           return PostItem(
          //             postId: item.id,
          //             createdAt: item.createdAt,
          //             title: item.title,
          //             body: item.body,
          //             priceDetails: item.priceDetails,
          //             averageRate: item.avgRate,
          //             owner: item.seller,
          //             paths: paths,
          //           );
          //         },
          //       );
          //     } else if (snapshot.hasError) {
          //       return CenterTitleWidget(
          //         title: AppLocalizations.of(context).error, //'حصل خطأ في التحميل',
          //         iconData: Icons.error,
          //       );
          //     }
          //     return Container();
          //   },
          // ),
          ),

      // ListView.builder(
      //   itemCount:
      //       sellerProvider.posts == null ? 0 : sellerProvider.posts.length,
      //   itemBuilder: (context, index) {
      //     var item = sellerProvider.posts[index];
      //     return PostItem(
      //       postId: item.id,
      //       nameOfSeller: item.seller.user.name,
      //       createdAt: item.seller.createdAt,
      //       title: item.title,
      //       body: item.body,
      //       priceDetails: item.priceDetails,
      //       avgRate: item.avgRate,
      //     );
      //   },
      // ),
    );
  }
}
