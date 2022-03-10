import 'package:dal/data_layer/data_providers/posts_apis.dart';
import 'package:dal/data_layer/models/followed_posts_bycustomer_model.dart';
import 'package:dal/data_layer/models/post_with_sellers_model.dart';
import 'package:flutter/cupertino.dart';

abstract class PostsRepository {
  Future<PostsWithSellerModel> getAllPosts();
  Future<PostsWithSellerModel> getSinglePostById({@required int id});
  Future<PostsWithSellerModel> getPostsByTitle();
  Future<FollowedPostsByCustomerModel> getFollowedPostsOfCustomerByCustomerID({
    @required int id,
  });
  Future<bool> addPostTofollowedPostsOfCustomer({
    @required int cutomerId,
    @required int postId,
  });
}

class PostsRepositoryImp extends PostsRepository {
  // بما اني موجود ب ريبو البوستات ف بحط هون انستنس من البوست رو
  final PostsAPIs postAPI = PostsAPIs();
  //Done
  @override
  Future<PostsWithSellerModel> getAllPosts() async {
    PostsWithSellerModel allposts = PostsWithSellerModel();
    final rowPosts = await postAPI.getRowPostsWithSellers();
    var _allposts = PostsWithSellerModel.fromJson(rowPosts, false);
    allposts = _allposts;
    return allposts;
  }

  Future<PostsWithSellerModel> getAllPostsIncludeCategories(
      int pageNumber, int pageSize, String search) async {
    PostsWithSellerModel allposts = PostsWithSellerModel();
    final rowPosts = await postAPI.getRowPostsIncludeCategories(
        pageNumber, pageSize, search);
    var _allposts = PostsWithSellerModel.fromJson(rowPosts, false);
    print('allposts with cate :');
    _allposts.data.data.forEach((element) {
      print(element.categories);
    });

    allposts = _allposts;
    return allposts;
  }

  Future<dynamic> getAllPostsByCategoryId(
      int id, int pageNumber, int pageSize) async {
    PostsWithSellerModel allposts = PostsWithSellerModel();
    final rowPosts =
        await postAPI.getRowPostsByCategoryId(id, pageNumber, pageSize);
    // var _allposts = PostsWithSellerModel.fromJson(rowPosts, true);
    // allposts = _allposts;
    return rowPosts;
  }

  @override
  Future<PostsWithSellerModel> getSinglePostById({@required int id}) async {
    PostsWithSellerModel singlePost = PostsWithSellerModel();
    final rowSinglePost = await postAPI.getSingleRowPostByID(postId: id);
    var _rowSinglePost = PostsWithSellerModel.fromJson(rowSinglePost, false);
    singlePost = _rowSinglePost;
    return singlePost;
  }

  //Done
  @override
  Future<PostsWithSellerModel> getPostsByTitle({@required String name}) async {
    PostsWithSellerModel posts = PostsWithSellerModel();
    final rowPosts = await postAPI.getRowPostByTitle(name: name);
    var _posts = PostsWithSellerModel.fromJson(rowPosts, false);
    posts = _posts;
    return posts;
  }

  @override
  Future<FollowedPostsByCustomerModel> getFollowedPostsOfCustomerByCustomerID(
      {@required int id}) async {
    FollowedPostsByCustomerModel followedPosts = FollowedPostsByCustomerModel();
    final rowFollowedPosts =
        await postAPI.getRowFollowedPostsOfCustomerByCustomerID(id: id);
    var _followedPosts =
        FollowedPostsByCustomerModel.fromJson(rowFollowedPosts);
    followedPosts = _followedPosts;
    return followedPosts;
  }

  //addPostTofollowedPostsOfCustomer
  @override
  Future<bool> addPostTofollowedPostsOfCustomer({
    @required int cutomerId,
    @required int postId,
    @required String token,
  }) async {
    print('addddddddddddd');
    bool res = await postAPI.addPostTofollowedPostsOfCustomer(
      cutomerId: cutomerId,
      postId: postId,
      token: token,
    );
    if (res) {
      print('\n%%%%%%%%\nPOST ADDED\n%%%%%%%%%%\n');
      return true;
    } else {
      print('\n%%%%%%%%\nWRONG\n%%%%%%%%%%\n');
      return false;
    }
  }

  Future<bool> removePostFromFollowedPostsOfCustomer({
    @required int cutomerId,
    @required int postId,
    @required String token,
  }) async {
    bool res = await postAPI.removePostFromfollowedPostsOfCustomer(
      cutomerId: cutomerId,
      postId: postId,
      token: token,
    );
    if (res) {
      print('\n%%%%%%%%\nPOST REMOVES\n%%%%%%%%%%\n');
      return true;
    } else {
      print('\n%%%%%%%%\nWRONG\n%%%%%%%%%%\n');
      return false;
    }
  }
}

//  allposts = List<PostsWithSellerModel>.from(
//   response.data.map(
//     (x) => PostsWithSellerModel.fromJson(x),
//   ),
// );
