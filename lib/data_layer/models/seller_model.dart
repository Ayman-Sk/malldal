class SellerModel {
  int id;
  String name;
  String gender;
  String phone;
  String profileImage;
  String bio;
  int userId;
  String createdAt;
  String updatedAt;

  SellerModel({
    this.id,
    this.name,
    this.gender,
    this.phone,
    this.profileImage,
    this.bio,
    this.userId,
    this.createdAt,
    this.updatedAt,
  });

  SellerModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    gender = json['gender'];
    phone = json['phone'];
    profileImage = json['profile_image'];
    bio = json['bio'];
    userId = json['user_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['gender'] = this.gender;
    data['phone'] = this.phone;
    data['profile_image'] = this.profileImage;
    data['bio'] = this.bio;
    data['user_id'] = this.userId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}