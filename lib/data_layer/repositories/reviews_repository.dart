import 'package:dal/data_layer/data_providers/reviews-apis.dart';
import 'package:dal/network/local_host.dart';
import 'package:flutter/cupertino.dart';

abstract class ReviewRepository {
  Future<bool> addReviewToSinglePost({
    @required int rate,
    @required String notes,
    @required int postId,
    @required int customerId,
  });
}

class ReviewRepositoryImp extends ReviewRepository {
  ReviewsAPIs revAPI = ReviewsAPIs();

  @override
  Future<bool> addReviewToSinglePost({
    @required int rate,
    @required String notes,
    @required int postId,
    @required int customerId,
  }) async {
    bool res = await revAPI.addReviewToPost(
      rate: rate,
      notes: notes,
      postId: postId,
      customerId: customerId,
      token: CachHelper.getData(key: 'token'),
    );
    if (res) {
      print('\n%%%%%%%%\nReview ADDED\n%%%%%%%%%%\n');
      return true;
    } else {
      print('\n%%%%%%%%\nWRONG\n%%%%%%%%%%\n');
      return false;
    }
  }
}
