import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'local_host.dart';

class DioHelper {
  static Dio dio;

  static init() {
    dio = Dio(
      BaseOptions(
        baseUrl: 'http://malldal.com/dal/api',
        receiveDataWhenStatusError: true,
      ),
    );
  }

  static Future<dynamic> getAdds({
    @required String url,
  }) async {
    Response response = await dio.get(url);
    if (response.statusCode != 200) {
      print('RES:$response');
      print('status code is ${response.statusCode}');
      return false;
    } else {
      print('RES:$response');
      print('status code is ${response.statusCode}');
      return response;
    }
  }

  static Future<dynamic> addCategoryAsFavorite(
      {@required String url, @required Map<String, dynamic> data}) async {
    String accessToken = CachHelper.getData(key: 'token').toString();
    dio.options.headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': "Bearer " + accessToken
    };
    Response response = await dio.post(url, data: data);
    if (response.statusCode == 200) {
      print('RES:$response');
      print('status code is ${response.statusCode}');
      return response;
    } else {
      print('RES:$response');
      print('status code is ${response.statusCode}');
      return false;
    }
  }

  static Future<dynamic> deleteCategoryFromFavorite(
      {@required String url}) async {
    String accessToken = CachHelper.getData(key: 'token').toString();
    dio.options.headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': "Bearer " + accessToken
    };
    Response response = await dio.delete(url);
    if (response.statusCode == 200) {
      print('RES:$response');
      print('status code is ${response.statusCode}');
      return response;
    } else {
      print('RES:$response');
      print('status code is ${response.statusCode}');
      return false;
    }
  }

  static Future<dynamic> getFollowedSeller({
    @required String url,
  }) async {
    Response response = await dio.get(url);
    if (response.statusCode != 200) {
      print('RES:$response');
      print('status code is ${response.statusCode}');
      return false;
    } else {
      print('RES:$response');
      print('status code is ${response.statusCode}');
      return response;
    }
  }

  static Future<dynamic> getFollowedCategories({@required String url}) async {
    Response response = await dio.get(url);
    if (response.statusCode != 200) {
      print('RES:$response');
      print('status code is ${response.statusCode}');
      return false;
    } else {
      print('RES:$response');
      print('status code is ${response.statusCode}');
      return response;
    }
  }

  static Future<dynamic> addPostRequest({
    @required String url,
    // Map<String, dynamic> query,
    // queryParameters: query,
    @required Map<String, dynamic> data,
    bool isFormData = true,
    String lang = 'ar',
  }) async {
    String accessToken = CachHelper.getData(key: 'token').toString();
    dio.options.headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': "Bearer " + accessToken,
    };
    // String accessToken = CachHelper.getData(key: 'token');
    // dio.options.headers["Authorization"] = "Bearer " + accessToken;
    // FormData formData = FormData.fromMap(data);
    print('ppppppppppppppppppppppppppps');
    print(data['images']);
    FormData bodyFormData = FormData.fromMap(data);
    if (data['images'] != null) {
      // List<dynamic> imagePaths = [];
      for (int i = 0; i < data['images'].length; i++) {
        bodyFormData.files.addAll([
          MapEntry(
            "images[$i]",
            await MultipartFile.fromFile(data['images'][i]),
          ),
          // MapEntry(
          //   "images[$i]",
          //   await MultipartFile.fromFile(data['images'][1]),
          // ),
          // MapEntry(
          //     "images+[$i]", await MultipartFile.fromFile(data['images'][i])),
        ]);
      }
      // String fileName = data['profile_image'].split('/').last;
      // data['images'] = await MultipartFile.fromFile(
      //   data['images'],
      //   filename: fileName,
      // );
      print(data['images']);
    }

    // FormData bodyFormData = FormData.fromMap(data);
    Response response = isFormData
        ? await dio.post(url, data: bodyFormData)
        : await dio.post(url, data: data);

    if (response.data['data'] == null) {
      print('RES:$response');
      print('status code is ${response.statusCode}');
      return false;
    } else {
      print('RES:$response');
      print('status code is ${response.statusCode}');
      return response;
    }
  }

  static Future<dynamic> sellerPosts({
    @required String url,
    // Map<String, dynamic> query,
    // queryParameters: query,
    // @required Map<String, dynamic> data,
    String lang = 'ar',
    bool isRequset,
  }) async {
    // dio.options.headers = {
    //   'Accept': 'application/json',
    //   'Content-Type': 'application/json',
    // };
    if (isRequset) {
      final token = CachHelper.getData(key: 'token');
      dio.options.headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer' + token,
      };
    }
    Response response = await dio.get(url);
    if (response.statusCode != 200) {
      print('RES:$response');
      print('status code is ${response.statusCode}');
      return false;
    } else {
      print('RES:$response');
      print('status code is ${response.statusCode}');
      return response;
    }
  }

  static Future<dynamic> loginOfCustomer({
    @required String url,
    // Map<String, dynamic> query,
    // queryParameters: query,
    @required Map<String, dynamic> data,
    String lang = 'ar',
  }) async {
    dio.options.headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
    Response response = await dio.post(url, data: data);
    if (response.statusCode != 200) {
      print('RES:$response');
      print('status code is ${response.statusCode}');
      return false;
    } else {
      print('RES:$response');
      print('status code is ${response.statusCode}');
      return response;
    }
  }

  static Future<dynamic> deleteUserAccount({
    @required String url,
    // Map<String, dynamic> query,
    // queryParameters: query,
    String lang = 'ar',
  }) async {
   
    String accessToken = CachHelper.getData(key: 'token');
     print(url);
    dio.options.headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': "Bearer " + accessToken,
    };
    Response response = await dio.delete(url);
    if (response.statusCode != 200) {
      print('RES:$response');
      print('status code is ${response.statusCode}');
      return false;
    } else {
      print('RES:$response');
      print('status code is ${response.statusCode}');
      return response;
    }
  }

  static Future<dynamic> registeraitionOfCustomer({
    @required String url,
    // Map<String, dynamic> query,
    // queryParameters: query,
    @required Map<String, dynamic> data,
    bool isFormData = false,
    String lang = 'ar',
  }) async {
    // String accessToken = CachHelper.getData(key: 'token');
    dio.options.headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
    print('ppppppppppppppppppppppppppps');
    print(data['profile_image']);
    if (data['profile_image'] != null) {
      String fileName = data['profile_image'].split('/').last;
      data['profile_image'] = await MultipartFile.fromFile(
        data['profile_image'],
        filename: fileName,
      );
      print(data['profile_image']);
    }
// Storage/images/customers/33/profile-1643471461id33.IMG_20220128_161545.jpg
// Storage/images/customers/32/profile-1643424200id32.IMG_20220128_161545.jpg
    // FormData formData = FormData.fromMap(
    //   {
    //     'name': data['name'],
    //     'gender': data['gender'],
    //     'city_id': data['city_id'],
    //     'phone': data['phone'],
    //   },
    // );
    FormData bodyFormData = FormData.fromMap(data);
    Response response = isFormData
        ? await dio.post(url, data: bodyFormData)
        : await dio.post(url, data: data);

    if (response.data['data'] == null) {
      print('RES:$response');
      print('status code is ${response.statusCode}');
      return false;
    } else {
      print('RES:$response');
      print('status code is ${response.statusCode}');
      return response;
    }
  }

  static Future<dynamic> updateUserData({
    @required String url,
    // Map<String, dynamic> query,
    // queryParameters: query,
    @required Map<String, dynamic> data,
    bool isFormData = false,
    String lang = 'ar',
  }) async {
    String accessToken = CachHelper.getData(key: 'token');
    print('Access Token');
    print(accessToken);
    dio.options.headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      // 'Authorization': "Bearer " + accessToken.toString(),
    };
    dio.options.headers["Authorization"] = "Bearer " + accessToken.toString();
    print('EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE');

    //eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOlwvXC9kYWwuY2hpLXRlYW
    //0uY29tXC9hcGlcL2F1dGgiLCJpYXQiOjE2NDQ0OTc1MjIsImV4cCI6MTY0NDUwMTEyMiwibmJm
    //IjoxNjQ0NDk3NTIyLCJqdGkiOiJtSVJ5MDd1ek1MdDdtWmlPIiwic3ViIjoxLCJwcnYiOiIyM2
    //JkNWM4OTQ5ZjYwMGFkYjM5ZTcwMWM0MDA4NzJkYjdhNTk3NmY3In0.5E8GFwGNW3-KewPwT6Nn
    //GFWwX5fcu4jqpPdxBK11L8s
    print(data['profile_image']);
    print('\\\\\\\\\\\\\\\\\\\\\data:');
    print(data);
    if (data['profile_image'] != null) {
      String fileName = data['profile_image'].split('/').last;
      data['profile_image'] = await MultipartFile.fromFile(
        data['profile_image'],
        filename: fileName,
      );
      print(data['profile_image']);
    }

    FormData bodyFormData = FormData.fromMap(data);
    Response response = isFormData
        ? await dio.post(url, data: bodyFormData)
        : await dio.post(url, data: data);

    if (response.data['data'] == null) {
      print('RES:$response');
      print('status code is ${response.statusCode}');
      return false;
    } else {
      print('RES:$response');
      print('status code is ${response.statusCode}');
      return response;
    }
  }

  // if (token != null) {
  //     header['Authorization'] = 'Bearer ' + token;
  //   }
  // static Future<bool> addToSavedPost(
  //     {int postId, int cusId, String token}) async {
  //   dio.options.headers = {
  //     'Authorization': 'Bearer ' + token,
  //     'Content-Type': 'application/json',
  //     'Accept': 'application/json',
  //   };
  //   try {
  //     Response response = await dio.post(
  //         EndPoints.addPostToCustomerFavList(customerId: ),
  //         data: {'post_id': postId});
  //     if (response.statusCode == 200) {
  //       return Future.value(true);
  //     } else {
  //       return Future.value(false);
  //     }
  //     // var _favoritesCar = PostModel.fromJson(response.data);
  //     // favoritesCar = _favoritesCar;
  //   } on DioError catch (e) {
  //     print('\n************\n');
  //     print(e.error);
  //     print('\n************\n');
  //   }
  // }

}
