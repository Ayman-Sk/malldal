import 'package:dal/network/local_host.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:dal/business_logic_layer/adds_provider.dart';
import 'package:dal/business_logic_layer/all_posts_with_categories.dart';
import 'package:dal/business_logic_layer/user_provider.dart';
import 'package:dal/data_layer/models/followed_posts_by_customer_model.dart';
import 'package:dal/data_layer/models/post_with_sellers_model.dart';
import 'package:dal/data_layer/repositories/posts_repositories.dart';

import '../../network/dio_helper.dart';
import '../../network/end_points.dart';
import '../../network/local_host.dart';

import '../repositories/categories_repository.dart';

class GetData {
  BuildContext context;
  int postPageSize;
  int categoriesPageSize;

  GetData({this.context, this.postPageSize, this.categoriesPageSize});

  int userId = CachHelper.getData(key: 'userId') == null
      ? -1
      : CachHelper.getData(key: 'userId');

  Future<bool> getCategoriesData() async {
    CategoriesRepositoryImp _catRepo = CategoriesRepositoryImp();
    final postsProvider =
        Provider.of<AllPostsWithCategories>(context, listen: false);
    final categories = await _catRepo.getAllCategories(
        refreshed: true, pageNumber: 1, pageSize: categoriesPageSize);
    print('alallllllll categoriessss');
    print(categories.data.categories);
    if (categories != null) {
      List<String> categoriesList = [];
      categories.data.categories.forEach((element) {
        categoriesList.add(element.title);
      });
      postsProvider.addCategories(categoriesList);
      return true;
    }

    // getFollowedCategoriesByCustomerID().then((value) {
    //   print(value);
    //   _catRepo.getAllCategories(refreshed: true, pageNumber: 1, pageSize: categoriesPageSize).then((value) {
    //     if (value != null) {
    //       value.data.categories.forEach((element) {
    //         postsProvider.addCategories(element.title);
    //       });
    //       return true;
    //     }
    //   });
    // });
    return false;
  }

  Future<Map<String, dynamic>> getFollowedCategoriesByCustomerID() async {
    try {
      final userProvider = Provider.of<UserProvider>(context);
      dynamic response = await DioHelper.getFollowedCategories(
        url: EndPoints.getFollowedCategoriesByCustomerByID(userId),
      );
      print('\nget Followed Categories Response : ${response.data}\n');
      if (response.data['data'] != null) {
        int postId = response.data['data'][0]['id'];
        print('\nuser Id : $postId\n');
        response.data['data'][0]['categories'].forEach((element) {
          userProvider.addCategoryToFavorite(element['id'].toString());
        });

        // CachHelper.saveData(key: 'userId', value: userId);
        return response.data;
      } else {
        print('***\nError In get customer Sellers\n***');
        return null;
      }
    } catch (e) {
      print('get Categories Is error is $e');
      return Future.value();
    }
  }

  Future<bool> getPostData() async {
    Map<String, dynamic> sellerFollower = {};
    PostsRepositoryImp postsRepositoryImp = PostsRepositoryImp();
    PostsWithSellerModel allPostsData = PostsWithSellerModel();
    FollowedPostsByCustomerModel followedRes = FollowedPostsByCustomerModel();

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final postsProvider =
        Provider.of<AllPostsWithCategories>(context, listen: false);
    userProvider.getUserToApp();

    bool isSeller = CachHelper.getData(key: 'userMode') == 'seller';
    bool isAnonymous = userId == -1;
    print(isSeller);
    print(isAnonymous);
    var addsData =
        await Provider.of<AddsProvider>(context, listen: false).getAdds(2, 1);

    print('asdafasfdgkfdvkfdnviuabfvuadvf');
    print('getttDataa');
//    print(searchTerm);
    print('paaaggggeee');
    allPostsData = await postsRepositoryImp.getAllPostsIncludeCategories(
        1, postPageSize, '');

    print('adddds');
    print(addsData['data']['data']);
    addsData['data']['data'].forEach((element) {
      userProvider.addAdds(element['url']);
    });

    if (!isAnonymous && !isSeller) {
      print('weeee areeee innnnnnn');
      followedRes = await postsRepositoryImp
          .getFollowedPostsOfCustomerByCustomerID(id: userId);
      sellerFollower =
          await userProvider.getFollowedSellersByCustomerID(userId);
      var followedPosts = followedRes.data[0].posts;
      List<int> ids = [];
      print('ffollowww');
      print(followedPosts);
      followedPosts.forEach((element) {
        ids.add(element['id']);
      });
      userProvider.setSavedPosts(ids);
      ids = [];
      sellerFollower['data'][0]['sellers'].forEach((element) {
        ids.add(element['id']);
      });
      userProvider.setFollowers(ids);
    }
    if (allPostsData == null) {
      return false;
    } else {
      postsProvider.setAllPost(allPostsData);
      return true;
    }
  }

  Future<Map<String, dynamic>> getFollowedSellersByCustomerID(
      int userId) async {
    try {
      dynamic response = await DioHelper.getFollowedSeller(
        url: EndPoints.getFollowedSellersByCustomerByID(userId),
      );
      print('\nget Followed Response : ${response.data}\n');
      if (response.data['data'] != null) {
        int postId = response.data['data'][0]['id'];
        print('\nuser Id : $postId\n');
        // CachHelper.saveData(key: 'userId', value: userId);
        return response.data;
      } else {
        print('***\nError In get customer Sellers\n***');
        return null;
      }
    } catch (e) {
      print('get Seller Is error is $e');
      return Future.value();
    }
  }
}
