import 'dart:convert';

import 'package:dal/data_layer/models/post_with_sellers_model.dart';

enum UserMode { seller, customer }

User userFromJson(String str) => User.fromJson(json.decode(str));
// String userToJson(User data) => json.encode(data.toJson());

class UserModel {
  UserModel({
    this.user,
    this.token,
  });
  User user;
  String token;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        user: User.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        // "user": user.toJson(),
        "token": token,
      };
}

class MyUser {
  //in both
  int id;
  String profileImage;
  String cityId = '0';
  int userId;
  String name;
  String phoneNumber;
  String gender;
  int verification;
  String createdAt;
  String updatedAt;
  String deletedAt;
  String userMode;
  //in customer
  // int city = 0;
  //in seller
  String biography = ' ';
  String numbers = ' ';
  String contactInfo = ' ';
  List<PostModel> posts = [];
  List<PostModel> postRequest = [];
  List<int> followSellers = [];
  List<int> savedSellers = [];
  List<int> savedPosts = [];
  List<String> favoriteCategory = [];
  List<String> adds = [];
  // List<PostsWithSellerModel>
  List<String> cities = [];
  String cityName = '';

  MyUser({
    this.id,
    this.name,
    this.profileImage,
    this.phoneNumber,
    this.gender,
    this.cityId,
    this.userId,
    this.verification,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.userMode,
    //in customer
    // this.city,
    //in seller
    this.biography,
    this.numbers,
    this.contactInfo,
    this.followSellers,
    this.savedPosts,
    this.cityName,
    // this.posts,
  });

  factory MyUser.fromJson(Map<String, dynamic> json) => MyUser(
        id: json["id"],
        name: json["name"],
        gender: json["gender"],
        phoneNumber: json["phone"],
        profileImage: json["profile_image"],
        biography: json['biography'],
        cityId: json["city_id"],
        cityName: json["city_name"],
        userId: json["user_id"],
        userMode: json['mode'],
        verification: json["verification"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        deletedAt: json["deleted_at"],
      );
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'gender': gender,
      'city_id': cityId,
      'city_name': cityName,
      'profile_image': profileImage,
      'phone': phoneNumber,
      'mode': userMode,
      'biography': biography,
    };
  }
}
