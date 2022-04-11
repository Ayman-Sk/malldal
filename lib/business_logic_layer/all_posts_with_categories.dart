import 'dart:convert';

import 'package:dal/data_layer/models/post_with_sellers_model.dart';
import 'package:dal/network/local_host.dart';
import 'package:flutter/cupertino.dart';

class AllPostsWithCategories with ChangeNotifier {
  PostsWithSellerModel _allPosts = PostsWithSellerModel();
  List<PostModel> _displayedPosts = [];
  List<String> _categoriesList = [];
  int _displayPostsIndex = -1;

  // List<String> _categoryFilter = [];
  // List<String> _cityFilter = [];
  String _categoryFilter = "";
  String _cityFilter = "";

  void setAllPost(PostsWithSellerModel posts) {
    this._allPosts = posts;
    notifyListeners();
  }

  void addNewPosts(List<PostModel> newPostsData) {
    this._allPosts.data.data.addAll(newPostsData);
    notifyListeners();
  }



  void addCategories(List<String> categories) {
    this._categoriesList.addAll(categories);
    notifyListeners();
  }

  void setCategoriesListEmpty() {
    this._categoriesList = [];
    notifyListeners();
  }

  PostsWithSellerModel getAllPost() {
    return _allPosts;
  }

  void setIndexOfCategory(int index) {
    this._displayPostsIndex = index;
    notifyListeners();
  }

  void setCategoryFilter(String index) {
    this._categoryFilter = index;
    notifyListeners();
  }

  void removeCategoryFilter() {
    this._categoryFilter = "";
    notifyListeners();
  }

  void setCityFilter(String index) {
    this._cityFilter = index;
    notifyListeners();
  }

  void remveCityFilter() {
    this._cityFilter = "";
    notifyListeners();
  }

  void savePostsData() {
    // Gson gson = new Gson();
    // String json = gson.encode(this._allPosts);
    var map = this._allPosts.toJson();
    var x = jsonEncode(this._allPosts);
    print('jjjjjjjjjjjjjjjjjjjjj');
    print(map.runtimeType);
    CachHelper.saveData(key: 'posts', value: x);
    // print(this._allPosts);
    // var jsonPostsData = jsonEncode(this._allPosts.data.data);
    // print(jsonPostsData);
    // CachHelper.saveData(key: 'posts', value: jsonPostsData);
    // print(x);
    // this._allPosts.data.data.map((e) => null)
    // this._allPosts.data.data.forEach((element) {

    //   print(element);
    // });
  }

  void getPostsData() {
    // Gson gson = new Gson();
    var json = CachHelper.getData(key: "posts");

    if (json != null) {
      var j = jsonDecode(json);
      print(j.runtimeType);
      this._allPosts = PostsWithSellerModel.fromJson(j, true);
      // var hashedUser = gson.decode(json);
      print(json);
      // if (js != null && json.isNotEmpty) {
      //   print('pppppppppppppppppppppppppppp');
      //   print(json);
      //   this._allPosts = PostsWithSellerModel(
      //       code: int.parse(json[0]['code']),
      //       data: json['data'],
      //       message: json['message'],
      //       messageAr: json['messageAr'],
      //       status: json['status']);

      //   // id: int.parse(hashedUser['id'].toString()),
      //   // name: hashedUser['name'],
      //   // gender: hashedUser['gender'],
      //   // cityId: int.parse(hashedUser['city_id'].toString()),
      //   // biography: hashedUser['biography'],
      //   // profileImage: hashedUser['profile_image'],
      //   // phoneNumber: hashedUser['phone'],
      //   // userMode: hashedUser['mode'],
      //   // followSellers: hashedUser['follow_sellers']);
      //   var jsonData = CachHelper.getData(key: 'posts');
      //   if (jsonData != null) {
      //     this._allPosts = PostsWithSellerModel();
      //     this._allPosts.data = Data();
      //     this._allPosts.data.data = [];

      //     print(jsonData);
      //     this._allPosts.data.data = List<PostModel>.from(
      //         jsonData["data"].map((x) => PostModel.fromJson(x)));
      //     // jsonData.forEach((element){
      //     //   this._allPosts.data.data.add(,);
      //     // })
      //     this._allPosts.data.data = jsonDecode(jsonData);
      //   }
      // }
    }
  }

  // void addCategoryFilter(String index) {
  //   this._categoryFilter.add(index);
  //   print(this._categoryFilter);
  //   notifyListeners();
  // }

  // void removeCategoryFilter(String index) {
  //   this._categoryFilter.remove(index);
  //   notifyListeners();
  // }

  // void addCityFilter(String index) {
  //   this._cityFilter.add(index);
  //   notifyListeners();
  // }

  // void removeCityFilter(String index) {
  //   this._cityFilter.remove(index);
  //   notifyListeners();
  // }

  void removeFirst() {
    _allPosts.data.data.removeAt(0);
    notifyListeners();
  }

  int get getDiplayedPostsIndex => this._displayPostsIndex;

  String get getCategoryFilter => this._categoryFilter;

  String get getCityFilter => this._cityFilter;

  List<String> get getCategories => this._categoriesList;


  // List<String> get getCategoryFilter => this._categoryFilter;
  // List<String> get getCityFilter => this._cityFilter;

  List<PostModel> getDisplayedPosts() {
    if (_allPosts.data != null) {
      if (_categoryFilter.isEmpty && _cityFilter.isEmpty) this._displayPostsIndex = -1;
      if (this._displayPostsIndex == -1) return _allPosts.data.data;
      _displayedPosts = [];
      _allPosts.data.data.forEach((element) {
        print(_displayPostsIndex.toString());
        if (element.categories.any((value) => this._categoryFilter == value)) {
          _displayedPosts.add(element);
        }
        // if (element.cities.any((value) => this._cityFilter.contains(value))) {
        //   _displayedPosts.add(element);
        // }
        // if (element.categories.contains(_displayPostsIndex.toString())) {
        //   print('Mmmmmmathced Elementttttttttttttttttttttttttt');
        //   print(element);
        //   _displayedPosts.add(element);
        // }
      });
      print('ddddddddddddddddddddddddissssplyed');
      print(_displayedPosts);
      // notifyListeners();
      return _displayedPosts;
    } else {
      return [];
    }
  }
}
