import 'package:flutter/material.dart';

class FacebookUser {
  String facebookId;
  String name;
  String email;
  String profileImage;
  String customerSessionExpirationDate;

  FacebookUser({
    this.facebookId,
    this.name,
    this.email,
    this.profileImage,
    this.customerSessionExpirationDate,
  });

  void setProfileImage(String image) {
    this.profileImage = image;
  }

  void setEamil(String email) {
    this.email = email;
  }

  void setFacebookId(String id) {
    this.facebookId = id;
  }

  void setName(String name) {
    this.name = name;
  }

  void setCustomerSessionExpirationDate(String date) {
    this.customerSessionExpirationDate = date;
  }

  FacebookUser.fromJson(
    Map<String, dynamic> json,
    this.facebookId,
    this.name,
    this.email,
    this.profileImage,
    this.customerSessionExpirationDate,
  ) {
    facebookId = json['facebook_id'];
    name = json['name'];
    email = json['email'];
    profileImage = json['profile_image'];
    this.customerSessionExpirationDate =
        json['customer_session_expiration_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['facebook_id'] = facebookId;
    data['name'] = name;
    data['email'] = email;
    data['profile_image'] = profileImage;
    data['customer_session_expiration_date'] =
        this.customerSessionExpirationDate;

    print(data.runtimeType);

    return data;
  }
}
