import 'dart:convert';

PostsWithSellerModel postsWithSellerFromJson(String str) =>
    PostsWithSellerModel.fromJson(json.decode(str), false);

String postsWithSellerToJson(PostsWithSellerModel data) =>
    json.encode(data.toJson());

class PostsWithSellerModel {
  PostsWithSellerModel({
    this.status,
    this.code,
    this.message,
    this.messageAr,
    this.data,
  });

  String status;
  int code;
  dynamic message;
  dynamic messageAr;
  Data data = Data();

  factory PostsWithSellerModel.fromJson(
          Map<String, dynamic> json, bool isFromCategory) =>
      PostsWithSellerModel(
        status: json["status"],
        code: json["code"],
        message: json["message"],
        messageAr: json["messageAr"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "code": code,
        "message": message,
        "messageAr": messageAr,
        "data": data.toJson(),
      };
}

class Data {
  Data({
    this.currentPage,
    this.data,
    this.firstPageUrl,
    this.from,
    this.lastPage,
    this.lastPageUrl,
    this.links,
    this.nextPageUrl,
    this.path,
    this.perPage,
    this.prevPageUrl,
    this.to,
    this.total,
  });

  int currentPage;
  List<PostModel> data = [];
  String firstPageUrl;
  int from;
  int lastPage;
  String lastPageUrl;
  List<Link> links;
  dynamic nextPageUrl;
  String path;
  int perPage;
  dynamic prevPageUrl;
  int to;
  int total;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        currentPage: json["current_page"],
        data: List<PostModel>.from(
            json["data"].map((x) => PostModel.fromJson(x))),
        firstPageUrl: json["first_page_url"],
        from: json["from"],
        lastPage: json["last_page"],
        lastPageUrl: json["last_page_url"],
        links: List<Link>.from(json["links"].map((x) => Link.fromJson(x))),
        nextPageUrl: json["next_page_url"],
        path: json["path"],
        perPage: json["per_page"],
        prevPageUrl: json["prev_page_url"],
        to: json["to"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "first_page_url": firstPageUrl,
        "from": from,
        "last_page": lastPage,
        "last_page_url": lastPageUrl,
        "links": List<dynamic>.from(links.map((x) => x.toJson())),
        "next_page_url": nextPageUrl,
        "path": path,
        "per_page": perPage,
        "prev_page_url": prevPageUrl,
        "to": to,
        "total": total,
      };
}

class PostModel {
  PostModel({
    this.id,
    this.title,
    this.deletedAt,
    this.body,
    this.priceDetails,
    this.avgRate,
    this.sellerId,
    // this.postRequestId,
    this.createdAt,
    this.updatedAt,
    this.categories,
    this.cities,
    this.postImages,
    this.seller,
    this.isSaved,
  });

  String id;
  String title;
  dynamic deletedAt;
  String body;
  String priceDetails;
  String avgRate;
  String sellerId;
  // String postRequestId;
  String createdAt;
  String updatedAt;
  bool isSaved;
  List<String> cities;
  List<String> categories;
  List<dynamic> postImages;
  Seller seller;

  factory PostModel.fromJson(Map<String, dynamic> json) => PostModel(
        id: json["id"],
        title: json["title"],
        deletedAt: json["deleted_at"],
        body: json["body"],
        priceDetails: json["priceDetails"],
        avgRate: json["avgRate"].toString(),
        sellerId: json["seller_id"],
        // postRequestId: int.parse(json["post_request_id"]),
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        postImages: List<dynamic>.from(json["post_images"].map((x) => x)),
        categories: json["categories"] == null
            ? []
            : List<String>.from(
                json["categories"].map((element) => element['id'].toString())),
        seller: Seller.fromJson(json["seller"]),
        isSaved: json['is_saved'],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "deleted_at": deletedAt,
        "body": body,
        "priceDetails": priceDetails,
        "avgRate": avgRate,
        "seller_id": sellerId,
        // "post_request_id": postRequestId,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "post_images": List<dynamic>.from(postImages.map((x) => x)),
        "seller": seller.toJson(),
        'is_saved': isSaved,
      };
}

class Seller {
  Seller({
    this.id,
    this.profileImage,
    this.bio,
    this.deletedAt,
    this.userId,
    this.createdAt,
    this.updatedAt,
    this.user,
  });

  String id;
  String profileImage;
  String bio;
  dynamic deletedAt;
  String userId;
  String createdAt;
  String updatedAt;
  User user;

  factory Seller.fromJson(Map<String, dynamic> json) => Seller(
        id: json["id"],
        profileImage: json[
            'profile_image'], //profileImageValues.map[json["profile_image"]],
        bio: json["bio"],
        deletedAt: json["deleted_at"],
        userId: json["user_id"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        user: User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "profile_image":
            profileImage, //profileImageValues.reverse[profileImage],
        "bio": bio,
        "deleted_at": deletedAt,
        "user_id": userId,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "user": user.toJson(),
      };
}

enum ProfileImage { NULL }

final profileImageValues = EnumValues({"null": ProfileImage.NULL});

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

enum Gender { MALE }

final genderValues = EnumValues({"male": Gender.MALE});

enum Name { IMMANUEL_SWANIAWSKI }

final nameValues =
    EnumValues({"Immanuel Swaniawski": Name.IMMANUEL_SWANIAWSKI});

class Link {
  Link({
    this.url,
    this.label,
    this.active,
  });

  String url;
  String label;
  bool active;

  factory Link.fromJson(Map<String, dynamic> json) => Link(
        url: json["url"] == null ? null : json["url"],
        label: json["label"],
        active: json["active"],
      );

  Map<String, dynamic> toJson() => {
        "url": url == null ? null : url,
        "label": label,
        "active": active,
      };
}

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
