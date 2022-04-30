import 'package:dal/data_layer/models/post_with_sellers_model.dart';
import 'package:dal/data_layer/models/user_model.dart';
import 'package:dal/network/dio_helper.dart';
import 'package:dal/network/end_points.dart';
import 'package:dal/network/local_host.dart';
import 'package:flutter/cupertino.dart';
import 'package:gson/gson.dart';

class UserProvider with ChangeNotifier {
  int statusCode;
  String message;

  int index = -1;

  // String name;
  // String number;
  // String gender = 'male' ;
  // int city = 0;
  // String imagePath;
  MyUser _myUser = MyUser(
      gender: 'male', cityId: 0, userMode: 'customer', followSellers: []);
  Locale local;

  void setID(int userid) {
    _myUser.id = userid;
    notifyListeners();
  }

  void setName(String name) {
    _myUser.name = name;
    notifyListeners();
  }

  void setProfileImage(String profileImage) {
    _myUser.profileImage = profileImage;
    notifyListeners();
  }

  void setCityId(int cityId) {
    _myUser.cityId = cityId;
    notifyListeners();
  }

  void setPhoneNumber(String number) {
    _myUser.phoneNumber = number;
    notifyListeners();
  }

  void setGender(String gender) {
    _myUser.gender = gender;
    notifyListeners();
  }

  void setUserMode(String mode) {
    _myUser.userMode = mode;
    notifyListeners();
  }

  void setUser(MyUser user) {
    _myUser = user;
    notifyListeners();
  }

  void setBiography(String bio) {
    _myUser.biography = bio;
    notifyListeners();
  }

  void setFollowers(List<int> followers) {
    _myUser.followSellers = followers;
    notifyListeners();
  }

  void addFolower(int id) {
    _myUser.followSellers.add(id);
    notifyListeners();
  }

  void removeFollower(int id) {
    _myUser.followSellers.remove(id);
    notifyListeners();
  }

  void setSavedPosts(List<int> savedPosts) {
    _myUser.savedPosts = [];
    _myUser.savedPosts.addAll(savedPosts);
    notifyListeners();
  }

  void addPostToSavedPost(int id) {
    _myUser.savedSellers.add(id);
    notifyListeners();
  }

  void removePostFromSavedPost(int id) {
    _myUser.savedPosts.remove(id);
    notifyListeners();
  }

  void addCategoryToFavorite(String name) {
    _myUser.favoriteCategory.add(name);
    notifyListeners();
  }

  void removeCategoryFromFavorite(String name) {
    _myUser.favoriteCategory.remove(name);
    notifyListeners();
  }

  void addAdds(String data) {
    if (!_myUser.adds.contains(data)) _myUser.adds.add(data);
  }

  bool isFavoriteCategoryContain(String index) {
    return _myUser.favoriteCategory.contains(index);
  }

  List<String> getAdds() => _myUser.adds;

  MyUser get user => _myUser;

  // get
  int get userId => _myUser.id;

  String get userName => _myUser.name;

  String get phoneNumber => _myUser.phoneNumber;

  String get gender => _myUser.gender;

  int get cityId => _myUser.cityId;

  String get cityName => _myUser.cityName;

  String get profileImage => _myUser.profileImage;

  String get userMode => _myUser.userMode;

  String get biography => _myUser.biography;

  List<PostModel> get posts => _myUser.posts;

  List<PostModel> get postRequest => _myUser.postRequest;

  List<int> get followers => _myUser.followSellers;

  List<int> get savedPosts => _myUser.savedPosts;

  List<String> get favoriteCategories => _myUser.favoriteCategory;

  Locale get appLocal => local;

  // List<String> get getAdds => _myUser.adds;
  String getNextAdds() {
    if (index < _myUser.adds.length && _myUser.adds.isNotEmpty) {
      index++;
      return _myUser.adds[index];
    } else {
      return '';
    }
  }

  // List<int>
  // UserMode get modeOfUserAsString =>
  // int get userIdOfCustomer => _myUser.userId;

  void printUser() {
    print(
      'User {Name : ${user.name}\nPhoneNumber : ${user.phoneNumber}\nGender : ${user.gender}\nid : ${user.id}\nuserId : ${user.userId}\ncityID : ${user.cityId}\nImage : ${user.profileImage}}}',
    );
  }

  Future<bool> addCateogryToCustomerFavorite(Map<String, dynamic> data) async {
    // try {
    dynamic response = await DioHelper.addCategoryAsFavorite(
        url: EndPoints.addCategoryToCustomerFavList(userId), data: data);
    print('\nResponse : ${response.data}\n');
    if (response.data['data'] != null) {
      return true;
    } else {
      print('***\nError In Add Request\n***');
      return false;
    }
    // } catch (e) {
    //   print('register error is $e');
    //   return Future.value(false);
    // }
  }

  Future<bool> removeCateogryFromCustomerFavorite(int categoryId) async {
    // try {
    dynamic response = await DioHelper.deleteCategoryFromFavorite(
      url: EndPoints.removeCategoryFromCustomerFavList(
          customerId: userId, categoryId: categoryId),
    );
    print('\nResponse : ${response.data}\n');
    if (response.data['code'] != null) {
      return true;
    } else {
      print('***\nError In Add Request\n***');
      return false;
    }
    // } catch (e) {
    //   print('register error is $e');
    //   return Future.value(false);
    // }
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

  Future<Map<String, dynamic>> getFollowedCategoriesByCustomerID() async {
    try {
      dynamic response = await DioHelper.getFollowedCategories(
        url: EndPoints.getFollowedCategoriesByCustomerByID(userId),
      );
      print('\nget Followed Categories Response : ${response.data}\n');
      if (response.data['data'] != null) {
        int postId = response.data['data'][0]['id'];
        print('\nuser Id : $postId\n');
        response.data['data'][0]['categories'].forEach((element) {
          addCategoryToFavorite(element['id'].toString());
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

  Future<bool> createPostRequest(Map<String, dynamic> data) async {
    // try {
    dynamic response = await DioHelper.addPostRequest(
        url: EndPoints.addPostRequest(userId),
        isFormData: true,
        lang: 'en',
        data: data);
    print('\nResponse : ${response.data}\n');
    if (response.data['data'] != null) {
      int postId = response.data['data'][0]['id'];
      print('\nuser Id : $postId\n');
      // CachHelper.saveData(key: 'userId', value: userId);
      return true;
    } else {
      print('***\nError In Add Request\n***');
      return false;
    }
    // } catch (e) {
    //   print('add error is $e');
    //   return Future.value(false);
    // }
  }

  Future<bool> getSellerPosts(
      bool isRequest, int id, int pageNumber, int pageSize) async {
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
      _myUser.posts = [];
      List allPosts = response.data['data']['data'];
      _myUser.postRequest = [];
      allPosts.forEach(
        (element) {
          PostModel model = PostModel.fromJson(element);
          print(_myUser.posts);
          isRequest ? _myUser.postRequest.add(model) : _myUser.posts.add(model);
          print(_myUser.posts.length);
        },
      );
      // posts.add(value)

      return true;
    } else {
      print('Error in get Postsss');
      return false;
    }
    // } catch (e) {
    // print('Login error is $e');
    // return Future.value(false);
    // }
  }

  Future<bool> updateSellerInfo(String name, String gender, String bio,
      String imagePath, String phoneNumber) async {
    print('seeeeend iddddd');
    print(userId);
    dynamic response = await DioHelper.updateUserData(
      url: EndPoints.updateSellerByID(userId),
      isFormData: true,
      lang: 'en',
      data: {
        'name': name,
        'gender': gender,
        'bio': bio,
        'profile_image': imagePath,
        'phone': phoneNumber,
      },
    );
    print(userId);
    print('\nResponse : ${response.data}\n');
    if (response.data['data'] != null) {
      _myUser.name = name;
      _myUser.gender = gender;
      _myUser.biography = bio;
      _myUser.profileImage = imagePath;
      _myUser.phoneNumber = phoneNumber;
      int userId = response.data['data']['id'];
      print('\nuser Id : $userId\n');
      CachHelper.saveData(key: 'userId', value: userId);
      CachHelper.removeData(key: 'user');
      saveUserinApp(
        idOfUser: userId,
        userName: userName,
        gender: gender,
        modeOfuser: _myUser.userMode,
        phoneNumber: phoneNumber,
        profileImage: imagePath,
        biography: bio,
        followers: _myUser.followSellers,
      );
      return true;
    } else {
      print('***\nError In Update\n***');
      return false;
    }

    //   print('register error is $e');
    //   return Future.value(false);
    // }
  }

  Future<bool> updateCustomerInfo(
    String name,
    String gender,
    int cityId,
    String imagePath,
    String phoneNumber,
  ) async {
    // try {
    print('seeeeend iddddd');
    print(userId);
    dynamic response = imagePath.isEmpty
        ? await DioHelper.updateUserData(
            url: EndPoints.updateCustomer(userId),
            isFormData: true,
            lang: 'en',
            data: {
              'name': name,
              'gender': gender,
              'city_id': cityId,
              'phone': phoneNumber,
            },
          )
        : await DioHelper.updateUserData(
            url: EndPoints.updateCustomer(userId),
            isFormData: true,
            lang: 'en',
            data: {
              'name': name,
              'gender': gender,
              'city_id': cityId,
              'profile_image': imagePath,
              'phone': phoneNumber,
            },
          );
    print(userId);
    print('\nResponse : ${response.data}\n');
    if (response.data['data'] != null) {
      print(
          'ppppppppppppppppppppppppppppppppppppppppppppppprrrrrrrrrrrrroooooooooffffffffile');
      print(response.data['data']['profile_image']);
      _myUser.name = name;
      _myUser.gender = gender;
      _myUser.cityId = cityId;
      _myUser.profileImage = response.data['data']['profile_image'];
      _myUser.phoneNumber = phoneNumber;
      int userId = response.data['data']['id'];
      print('\nuser Id : $userId\n');
      CachHelper.saveData(key: 'userId', value: userId);
      CachHelper.removeData(key: 'user');
      saveUserinApp(
          idOfUser: userId,
          userName: userName,
          gender: gender,
          modeOfuser: _myUser.userMode,
          phoneNumber: phoneNumber,
          profileImage: _myUser.profileImage,
          cityId: cityId,
          followers: _myUser.followSellers);
      return true;
    } else {
      print('***\nError In Update\n***');
      return false;
    }
    // } catch (e) {
    //   print('register error is $e');
    //   return Future.value(false);
    // }
  }

  Future<bool> deleteUser() async {
    // try {
    dynamic response = await DioHelper.deleteUserAccount(
      url: userMode == 'customer'
          ? EndPoints.deleteCustomer(userId)
          : EndPoints.deleteSellerByID(userId),
      lang: 'en',
    );
    print('Deeeeelllllllllllllleeeeeeeettttttttteeeeeeeeee');
    print(userId);
    print(userMode);
    print(response.data);
    // if (response.data['token'] != null) {
    //   print('\nResponse : ${response.data}');
    //   String token = response.data['token'];
    //   CachHelper.saveData(key: 'token', value: token);
    //   String userMode = response.data['user'][0].keys.elementAt(3);

    //   print('mooooooooooooooooode');
    //   print(userMode);
    //   print(response.data['user'][0][userMode]['city_id']);
    //   print('iddddddddddddddddddddddddddd');
    //   print(response.data['user'][0][userMode]['bio']);
    //   saveUserinApp(
    //     idOfUser: response.data['user'][0]['id'],
    //     userName: response.data['user'][0]['name'],
    //     gender: response.data['user'][0]['gender'],
    //     cityId: response.data['user'][0][userMode]['city_id'],
    //     biography: response.data['user'][0][userMode]['bio'],
    //     profileImage: response.data['user'][0][userMode]['profile_image'],
    //     phoneNumber: response.data['user'][0]['phone'],
    //     modeOfuser: userMode,
    //   );

    return true;
    // } else {
    // print('Error in Login');
    // return false;
    // }
    // } catch (e) {
    // print('Login error is $e');
    // return Future.value(false);
    // }
  }

  Future<bool> register(
    String name,
    String gender,
    int cityId,
    String imagePath,
    String phoneNumber,
  ) async {
    // try{
    dynamic response = await DioHelper.registeraitionOfCustomer(
      url: EndPoints.customerSignUp,
      isFormData: true,
      lang: 'en',
      data: {
        'name': name,
        'gender': gender,
        'city_id': cityId,
        'profile_image': imagePath,
        'phone': phoneNumber,
      },
    );
    print('\nResponse : ${response.data}\n');
    if (response.data['data'] != null) {
      int userId = response.data['data'][0]['id'];
      print('\nuser Id : $userId\n');
      CachHelper.saveData(key: 'userId', value: userId);
      return true;
    } else {
      print('***\nError In Sign Up\n***');
      return false;
    }
    // } catch (e) {
    //   print('register error is $e');
    //   return Future.value(false);
    // }
  }

  Future<bool> login(
    String phoneNumber,
  ) async {
    try {
      dynamic response = await DioHelper.loginOfCustomer(
        url: EndPoints.userLogin,
        lang: 'en',
        data: {
          'phoneNumber': phoneNumber,
        },
      );
      print(response);
      if (response.data['token'] != null) {
        print('\nResponse : ${response.data}');
        String token = response.data['token'];
        CachHelper.saveData(key: 'token', value: token);
        String userMode = response.data['user'][0].keys.elementAt(3);

        CachHelper.saveData(
            key: 'userId', value: response.data['user'][0][userMode]['id']);
        CachHelper.saveData(key: 'userMode', value: userMode);
        print(userMode);

        print('mooooooooooooooooode');
        print(userMode);
        print(response.data['user'][0][userMode]['city_id']);
        print('iddddddddddddddddddddddddddd');
        print(response.data['user'][0][userMode]['bio']);
        print(response.data['user'][0][userMode]['id']);
        saveUserinApp(
          idOfUser: response.data['user'][0][userMode]['id'],
          userName: response.data['user'][0]['name'],
          gender: response.data['user'][0]['gender'],
          cityId: response.data['user'][0][userMode]['city_id'],
          cityName: userMode == 'customer'
              ? response.data['user'][0][userMode]['city']['cityName']
              : '',
          biography: response.data['user'][0][userMode]['bio'],
          profileImage: response.data['user'][0][userMode]['profile_image'],
          phoneNumber: response.data['user'][0]['phone'],
          modeOfuser: userMode,
          followers: _myUser.followSellers == null ? [] : _myUser.followSellers,
        );

        return true;
      } else {
        print('Error in Login');
        return false;
      }
    } catch (e) {
      print('Login error is $e');
      return Future.value(false);
    }
  }

  void getUserToApp() {
    if (CachHelper.getData(key: 'token') != null) {
      Gson gson = new Gson();
      String json = CachHelper.getData(key: "user");
      var hashedUser = gson.decode(json);
      print('pppppppppppppppppppppppppppp');
      print(hashedUser);
      _myUser = MyUser(
          id: int.parse(hashedUser['id'].toString()),
          name: hashedUser['name'],
          gender: hashedUser['gender'],
          cityId: int.parse(hashedUser['city_id'].toString()),
          cityName: hashedUser['city_name'],
          biography: hashedUser['biography'],
          profileImage: hashedUser['profile_image'],
          phoneNumber: hashedUser['phone'],
          userMode: hashedUser['mode'],
          followSellers: hashedUser['follow_sellers']);
    }
  }

  void saveUserinApp(
      {@required int idOfUser,
      @required String userName,
      @required String gender,
      @required String profileImage,
      @required String phoneNumber,
      @required String modeOfuser,
      @required List<int> followers,
      int cityId = 0,
      String cityName = '',
      String biography = ''}) {
    // print('-->name OfCustomer : $nameOfCustomer\n');
    // print('-->gender OfCustomer : $genderOfCustomer\n');
    print('-->cityId OfCustomer : $cityId\n');
    print('-->bio OfCustomer : $biography\n');
    // print('-->profileImage OfCustomer : $profileImageOfCustomer\n');
    // print('-->Number OfCustomer : $phoneNumberOfCustomer\n');
    // print('-->UserMode OfCustomer : $modeOfuser\n');
    MyUser user = MyUser(
        id: idOfUser,
        name: userName,
        gender: gender,
        cityId: cityId == null ? 0 : cityId,
        cityName: cityName == null ? '' : cityName,
        biography: biography == null ? ' ' : biography,
        profileImage: profileImage,
        phoneNumber: phoneNumber,
        userMode: modeOfuser,
        followSellers: followers);
    _myUser = user;
    print(_myUser.name);
    print('nnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnn');
    Gson gson = new Gson();
    String json = gson.encode(user);
    print('jjjjjjjjjjjjjjjjjjjjj');
    print(json);
    CachHelper.saveData(key: 'user', value: json);

    print('\User ' +
        modeOfuser +
        ' Saving in App in customer_provider.dart file\n');
  }
}
