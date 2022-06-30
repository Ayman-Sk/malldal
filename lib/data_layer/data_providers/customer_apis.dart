import 'package:dal/network/end_points.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

import '../../network/local_host.dart';

class CustomerApis {
  Dio _dio = Dio();

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

  Future<bool> addSellerTofollowedUserOfCustomer({
    @required String customerId,
    @required String sellerId,
    @required String token,
  }) async {
    final response = await _dio.post(
      EndPoints.addSellerToCustomerFavList(customerId),
      options: Options(
        headers: {
          'Authorization': 'Bearer' + token,
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
      data: {"seller_id": sellerId},
    );
    if (response.statusCode == 200) {
      // if (response.data['code'] == "401") {
      //   // await refreshToken();
      //   await addSellerTofollowedUserOfCustomer(
      //       customerId: customerId, sellerId: sellerId, token: token);
      //   return true;
      // }
      print('\n1-${response.data}');
      return true;
    } else if (response.data['code'] == '401') {
      await refreshToken();
      await addSellerTofollowedUserOfCustomer(
          customerId: customerId, sellerId: sellerId, token: token);
    } else {
      print('\n -Error IN addPostTofollowedPostsOfCustomer \n${response.data}');
      throw Exception('Can not Load getRowFollowedPostsOfCustomerByCustomerID');
    }
  }

  Future<bool> removeSellerTofollowedUserOfCustomer({
    @required String customerId,
    @required String sellerId,
    @required String token,
  }) async {
    final response = await _dio.delete(
      EndPoints.removeSellerFromCustomerFavList(
          customerId: customerId, sellerId: sellerId),
      options: Options(
        headers: {
          'Authorization': 'Bearer' + token,
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
      // data: {"seller_id": sellerId},
    );
    if (response.statusCode == 200) {
      print('\n1-${response.data}');
      return true;
    } else if (response.data['code'] == '401') {
      await refreshToken();
      await removeSellerTofollowedUserOfCustomer(
          customerId: customerId, sellerId: sellerId, token: token);
    } else {
      print('\n -Error IN addPostTofollowedPostsOfCustomer \n${response.data}');
      throw Exception('Can not Load getRowFollowedPostsOfCustomerByCustomerID');
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
