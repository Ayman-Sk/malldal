import 'package:dal/network/end_points.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

import '../../network/local_host.dart';

class PostsAPIs {
  Dio _dio = Dio();

  Future<dynamic> getRowPostsWithSellers() async {
    final response = await _dio.get(EndPoints.getAllPostsWithSeller);
    print('resss :$response');
    if (response.statusCode == 200) {
      print('\nPostData${response.data}');
      return response.data;
    } else {
      print('EEEEERRROR :${response.statusCode}');
      throw Exception('Can not Load Raw PostsWithSellers');
    }
  }

  Future<dynamic> getRowPostsIncludeCategories(
      int pageNumber, int pageSize, String search) async {
    final response = await _dio.get(
        EndPoints.getAllPostsIncudeCategories(pageNumber, pageSize, search));
    print('resss :$response');
    // print(List<String>.from(response.data['data']['data'][0]['categories']
    //     .map((element) => element['id'].toString())));
    if (response.statusCode == 200) {
      print('\nPostData${response.data}');
      return response.data;
    } else {
      print('EEEEERRROR :${response.statusCode}');
      throw Exception('Can not Load Raw PostsWithSellers');
    }
  }

  Future<dynamic> getRowPostsByCategoryId(
      String id, int pageNumber, int pageSize) async {
    final response = await _dio
        .get(EndPoints.getPostsByCategoryId(id, pageNumber, pageSize));
    print('resss :$response');
    if (response.statusCode == 200) {
      print('\nPostData${response.data}');
      return response.data;
    } else {
      print('EEEEERRROR :${response.statusCode}');
      throw Exception('Can not Load Raw PostsWithSellers');
    }
  }

  Future<dynamic> getRowPostsByCategoryIdAndCityId(
      String categoryId, String cityId, int pageNumber, int pageSize) async {
    final response = await _dio.get(EndPoints.getPostsByCategoryIdAndCityID(
        categoryId, cityId, pageNumber, pageSize));
    print('resss :$response');
    if (response.statusCode == 200) {
      print('\nPostData${response.data}');
      return response.data;
    } else {
      print('EEEEERRROR :${response.statusCode}');
      throw Exception('Can not Load Raw PostsWithSellers');
    }
  }

  Future<dynamic> getSingleRowPostByID({@required String postId}) async {
    final response = await _dio.get(EndPoints.getSinglePostById(postId));
    if (response.statusCode == 200) {
      print('\n1-${response.data}');
      return response.data;
    } else {
      // print('EEEEERRROR :${response.statusCode}');
      throw Exception('Can not Load Raw PostsWithSellers');
    }
  }

  Future<dynamic> getRowPostByTitle({@required String name}) async {
    final response = await _dio.get(EndPoints.getPostsByTitle(name));
    if (response.statusCode == 200) {
      print('\n1-${response.data}');
      return response.data;
    } else {
      throw Exception('Can not Load Raw PostsWithSellers');
    }
  }

  Future<dynamic> getRowFollowedPostsOfCustomerByCustomerID(
      {@required String id}) async {
    final response =
        await _dio.get(EndPoints.getFollowedPostsOfCustomerByCustomerID(id));
    if (response.statusCode == 200) {
      print('\nFollowedPostsOfCustomerByCustomerID${response.data}');
      return response.data;
    } else {
      throw Exception('Can not Load getRowFollowedPostsOfCustomerByCustomerID');
    }
  }

  // Future<void> refreshToken() async {
  //   final response = await _dio.post(
  //     EndPoints.refreshToken,
  //     options: Options(
  //       headers: {
  //         'Authorization': 'Bearer' + CachHelper.getData(key: 'token'),
  //         'Content-Type': 'application/json',
  //         'Accept': 'application/json',
  //       },
  //     ),
  //   );
  //   CachHelper.saveData(key: 'token', value: response.data['token']);
  // }

  Future<bool> addPostTofollowedPostsOfCustomer({
    @required String cutomerId,
    @required String postId,
    @required String token,
  }) async {
    final response = await _dio.post(
      EndPoints.addPostToCustomerFavList(customerId: cutomerId),
      options: Options(
        headers: {
          'Authorization': 'Bearer' + token,
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
      data: {"post_id": postId},
    );
    if (response.statusCode == 200) {
      // if (response.data['code'] == "401") {
      //   await refreshToken();
      //   addPostTofollowedPostsOfCustomer(
      //       cutomerId: cutomerId, postId: postId, token: token);
      //   return true;
      // }
      print('\n1-${response.data}');
      return true;
    } else if (response.data['code'] == '401') {
      await refreshToken();
      await addPostTofollowedPostsOfCustomer(
          cutomerId: cutomerId, postId: postId, token: token);
    } else {
      print('\n -Error IN addPostTofollowedPostsOfCustomer \n${response.data}');
      throw Exception('Can not Load getRowFollowedPostsOfCustomerByCustomerID');
    }
  }

  Future<bool> removePostFromfollowedPostsOfCustomer({
    @required String cutomerId,
    @required String postId,
    @required String token,
  }) async {
    print(cutomerId);
    print(postId);
    print(token);
    final response = await _dio.delete(
        EndPoints.removePostFromCustomerFavList(
            customerId: cutomerId, postId: postId),
        options: Options(
          headers: {
            'Authorization': 'Bearer' + token,
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
        data: {} //{"post_id": postId},
        );
    if (response.statusCode == 200) {
      print('\n1-${response.data}');
      return true;
    } else if (response.data['code'] == '401') {
      await refreshToken();
      await removePostFromfollowedPostsOfCustomer(
          cutomerId: cutomerId, postId: postId, token: token);
    } else {
      print(
          '\n -Error IN removePostTofollowedPostsOfCustomer \n${response.data}');
      throw Exception('Can not Load removeFollowedPostsOfCustomerByCustomerID');
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
}
