import 'package:dal/network/end_points.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

import '../../network/local_host.dart';

class ReviewsAPIs {
  Dio _dio = Dio();

  Future<bool> addReviewToPost({
    @required String rate,
    @required String notes,
    @required String postId,
    @required String customerId,
    @required String token,
  }) async {
    print('rate');
    print(rate);
    print('notes');
    print(notes);
    print('post');
    print(postId);
    print('cus');
    print(customerId);
    print(token);
    final response = await _dio.post(
      EndPoints.reviews,
      options: Options(
        headers: {
          'Authorization': 'Bearer' + token,
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
      data: {
        "rate": rate,
        "notes": notes,
        "post_id": postId,
        "customer_id": customerId,
      },
    );
    if (response.statusCode == 200) {
      print('\n1-${response.data}');
      return true;
    } else if (response.data['code'] == '401') {
      await refreshToken();
      await addReviewToPost(
          rate: rate,
          notes: notes,
          postId: postId,
          customerId: customerId,
          token: token);
    } else {
      print('\n -Error IN addReviewToPost \n${response.data}');
      throw Exception('Can not addReviewToPost');
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
