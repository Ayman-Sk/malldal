// import 'dart:convert';

// class PostModel {
//   PostModel({
//     this.id,
//     this.title,
//     this.deletedAt,
//     this.body,
//     this.priceDetails,
//     this.avgRate,
//     this.sellerId,
//     this.postRequestId,
//     this.createdAt,
//     this.updatedAt,
//     this.postImages,
//     this.seller,
//   });

//   int id;
//   String title;
//   dynamic deletedAt;
//   String body;
//   String priceDetails;
//   int avgRate;
//   int sellerId;
//   int postRequestId;
//   DateTime createdAt;
//   DateTime updatedAt;
//   List<String> postImages;
//   Seller seller;

//   factory PostModel.fromJson(Map<String, dynamic> json) => PostModel(
//         id: json["id"],
//         title: json["title"],
//         deletedAt: json["deleted_at"],
//         body: json["body"],
//         priceDetails: json["priceDetails"],
//         avgRate: json["avgRate"],
//         sellerId: json["seller_id"],
//         postRequestId: json["post_request_id"],
//         createdAt: DateTime.parse(json["created_at"]),
//         updatedAt: DateTime.parse(json["updated_at"]),
//         postImages: List<dynamic>.from(json["post_images"].map((x) => x)),
//         seller: Seller.fromJson(json["seller"]),
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "title": title,
//         "deleted_at": deletedAt,
//         "body": body,
//         "priceDetails": priceDetails,
//         "avgRate": avgRate,
//         "seller_id": sellerId,
//         "post_request_id": postRequestId,
//         "created_at": createdAt.toIso8601String(),
//         "updated_at": updatedAt.toIso8601String(),
//         "post_images": List<dynamic>.from(postImages.map((x) => x)),
//         "seller": seller.toJson(),
//       };
// }

// class Seller {
//   Seller({
//     this.id,
//     this.profileImage,
//     this.bio,
//     this.deletedAt,
//     this.userId,
//     this.createdAt,
//     this.updatedAt,
//     this.user,
//   });

//   int id;
//   ProfileImage profileImage;
//   String bio;
//   dynamic deletedAt;
//   int userId;
//   DateTime createdAt;
//   DateTime updatedAt;
//   User user;

//   factory Seller.fromJson(Map<String, dynamic> json) => Seller(
//         id: json["id"],
//         profileImage: profileImageValues.map[json["profile_image"]],
//         bio: json["bio"],
//         deletedAt: json["deleted_at"],
//         userId: json["user_id"],
//         createdAt: DateTime.parse(json["created_at"]),
//         updatedAt: DateTime.parse(json["updated_at"]),
//         user: User.fromJson(json["user"]),
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "profile_image": profileImageValues.reverse[profileImage],
//         "bio": bio,
//         "deleted_at": deletedAt,
//         "user_id": userId,
//         "created_at": createdAt.toIso8601String(),
//         "updated_at": updatedAt.toIso8601String(),
//         "user": user.toJson(),
//       };
// }

// enum ProfileImage { NULL }

// final profileImageValues = EnumValues({"null": ProfileImage.NULL});

// class User {
//   User({
//     this.name,
//     this.gender,
//     this.phone,
//   });

//   Name name;
//   Gender gender;
//   String phone;

//   factory User.fromJson(Map<String, dynamic> json) => User(
//         name: nameValues.map[json["name"]],
//         gender: genderValues.map[json["gender"]],
//         phone: json["phone"],
//       );

//   Map<String, dynamic> toJson() => {
//         "name": nameValues.reverse[name],
//         "gender": genderValues.reverse[gender],
//         "phone": phone,
//       };
// }

// enum Gender { MALE }

// final genderValues = EnumValues({"male": Gender.MALE});

// enum Name { IMMANUEL_SWANIAWSKI }

// final nameValues =
//     EnumValues({"Immanuel Swaniawski": Name.IMMANUEL_SWANIAWSKI});

// class Link {
//   Link({
//     this.url,
//     this.label,
//     this.active,
//   });

//   String url;
//   String label;
//   bool active;

//   factory Link.fromJson(Map<String, dynamic> json) => Link(
//         url: json["url"] == null ? null : json["url"],
//         label: json["label"],
//         active: json["active"],
//       );

//   Map<String, dynamic> toJson() => {
//         "url": url == null ? null : url,
//         "label": label,
//         "active": active,
//       };
// }

// class EnumValues<T> {
//   Map<String, T> map;
//   Map<T, String> reverseMap;

//   EnumValues(this.map);

//   Map<T, String> get reverse {
//     if (reverseMap == null) {
//       reverseMap = map.map((k, v) => new MapEntry(v, k));
//     }
//     return reverseMap;
//   }
// }
