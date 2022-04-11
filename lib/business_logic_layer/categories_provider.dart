import 'dart:convert';

FollowedPostsByCustomerModel followedPostsByCustomerModelFromJson(String str) =>
    FollowedPostsByCustomerModel.fromJson(json.decode(str));

String followedPostsByCustomerModelToJson(FollowedPostsByCustomerModel data) =>
    json.encode(data.toJson());

/*
{status: true, code: 200, message: succesfully, messageAr: تم , 
data: [{id: 28, profile_image:na.png,city_id: 9, user_id: 49, verification: 0,
deleted_at: null, created_at: 2021-12-21T17:41:40.000000Z,
updated_at: 2021-12-21T17:41:40.000000Z, user_count: 1, 
user: {name: غفغغغغغغغغغغغ, gender: male, phone: 1472583690}, posts: []}]}
*/
class FollowedPostsByCustomerModel {
  FollowedPostsByCustomerModel({
    this.status,
    this.code,
    this.message,
    this.messageAr,
    this.data,
  });

  String status;
  int code;
  String message;
  String messageAr;
  List<Datum> data; // [0]

  factory FollowedPostsByCustomerModel.fromJson(Map<String, dynamic> json) {
    var temp = FollowedPostsByCustomerModel(
      status: json["status"],
      code: json["code"],
      message: json["message"],
      messageAr: json["messageAr"],
      data:
          List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))).toList(),
    );
    print(temp.data);
    return temp;
  }

  Map<String, dynamic> toJson() => {
        "status": status,
        "code": code,
        "message": message,
        "messageAr": messageAr,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  Datum({
    this.id,
    this.profileImage,
    this.cityId,
    this.userId,
    this.verification,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
    this.userCount,
    this.user,
    this.posts,
  });

  int id;
  String profileImage;
  int cityId;
  int userId;
  int verification;
  dynamic deletedAt;
  DateTime createdAt;
  DateTime updatedAt;
  int userCount;
  User user;
  List<dynamic> posts;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        profileImage: json["profile_image"],
        cityId: json["city_id"],
        userId: json["user_id"],
        verification: json["verification"],
        deletedAt: json["deleted_at"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        userCount: json["user_count"],
        user: User.fromJson(json["user"]),
        posts: List<dynamic>.from(json["posts"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "profile_image": profileImage,
        "city_id": cityId,
        "user_id": userId,
        "verification": verification,
        "deleted_at": deletedAt,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "user_count": userCount,
        "user": user.toJson(),
        "posts": List<dynamic>.from(posts.map((x) => x)),
      };
}

class User {
  User({
    this.name,
    this.gender,
    this.phone,
  });

  String name;
  String gender;
  String phone;

  factory User.fromJson(Map<String, dynamic> json) => User(
        name: json["name"],
        gender: json["gender"],
        phone: json["phone"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "gender": gender,
        "phone": phone,
      };
}
