import 'package:dal/network/end_points.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class ReviewsAPIs {
  Dio _dio = Dio();

  Future<bool> addReviewToPost({
    @required int rate,
    @required String notes,
    @required int postId,
    @required int customerId,
    @required String token,
  }) async {
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
    } else {
      print('\n -Error IN addReviewToPost \n${response.data}');
      throw Exception('Can not addReviewToPost');
    }
  }
}
