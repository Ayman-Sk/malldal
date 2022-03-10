import 'package:flutter/foundation.dart';

class PostRequestProvider with ChangeNotifier {
  // int id;
  String title;
  // dynamic deletedAt;
  String body;
  String priceDetails;
  // int avgRate;
  int sellerId;
  // int postRequestId;
  // String categories;
  // String updatedAt;
  List<dynamic> postImages = [];
  List<int> cities = [];
  List<int> categories = [];

  void addCitiesId(int number) {
    this.cities.add(number);
  }

  void addCategories(int number) {
    this.categories.add(number);
  }

  PostRequestProvider({
    this.title,
    this.body,
    this.priceDetails,
    this.sellerId,
    this.categories,
    this.cities,
    this.postImages,
  });
  // PostRequestProvider();

  PostRequestProvider.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    body = json['body'];
    priceDetails = json['priceDetails'];
    sellerId = json['seller_id'];
    postImages = json['postImages'];
    cities = json['cities'];
    categories = json['categories'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['body'] = this.body;
    data['priceDetails'] = this.priceDetails;
    data['seller_id'] = this.sellerId;
    data['postImages'] = this.postImages;
    data['cities'] = this.cities;
    data['categories'] = this.categories;
    return data;
  }
}
