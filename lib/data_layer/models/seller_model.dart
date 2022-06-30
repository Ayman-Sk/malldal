class Seller {
  String id;
  String profileImage;
  String bio;
  String deletedAt;
  String userId;
  String createdAt;
  String updatedAt;
  int userCount;
  User user;

  Seller(
      {this.id,
      this.profileImage,
      this.bio,
      this.deletedAt,
      this.userId,
      this.createdAt,
      this.updatedAt,
      this.userCount,
      this.user});

  Seller.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    profileImage = json['profile_image'];
    bio = json['bio'];
    deletedAt = json['deleted_at'];
    userId = json['user_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    userCount = json['user_count'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['profile_image'] = this.profileImage;
    data['bio'] = this.bio;
    data['deleted_at'] = this.deletedAt;
    data['user_id'] = this.userId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['user_count'] = this.userCount;
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    return data;
  }
}

class User {
  String name;
  String gender;
  String phone;

  User({this.name, this.gender, this.phone});

  User.fromJson(Map<String, dynamic> json) {
    this.name = json['name'];
    this.gender = json['gender'];
    this.phone = json['phone'];
    print('frommmmmmmjsonnnnnnnnnnn');
    print(name);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['gender'] = this.gender;
    data['phone'] = this.phone;
    return data;
  }
}
