import 'package:dal/network/dio_helper.dart';
import 'package:dal/network/end_points.dart';
import 'package:flutter/cupertino.dart';

class AddsProvider extends ChangeNotifier {
  String status;
  int code;
  dynamic message;
  dynamic messageAr;
  Data data;

  int index;
  List<String> _adds = [];

  // List<String> _adds = [
  //   'image',
  //   'image',
  // ];

  List<String> get adds => _adds;

  Future<Map<String, dynamic>> getAdds(int pageSize, int pageNumber) async {
    try {
      dynamic response = await DioHelper.getAdds(
        url: EndPoints.getAllAdds(pageSize,pageNumber),
      );
      print('\nget adds Response : ${response.data}\n');
      if (response.data['data'] != null) {
        // int postId = response.data['data'][0]['id'];
        // print('\nuser Id : $postId\n');
        // CachHelper.saveData(key: 'userId', value: userId);
        return response.data;
      } else {
        print('***\nError In get Adds\n***');
        return null;
      }
    } catch (e) {
      print('get Adds Is error is $e');
      return Future.value();
    }
  }
}

class Adds {
  int id;
  String title;
  String deletedAt;
  int important;
  String url;
  String createdAt;
  String updatedAt;

  Adds({
    @required id,
    @required title,
    @required deletedAt,
    @required important,
    @required url,
    @required createdAt,
    @required updatedAt,
  });

  factory Adds.fromJson(Map<String, dynamic> json) => Adds(
        id: json["id"],
        title: json["title"],
        deletedAt: json["deletedAt"],
        important: json["important"],
        url: json["url"],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'deletedAt': deletedAt,
        'important': important,
        'url': url,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
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
  List<Adds> data;
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
        data: List<Adds>.from(json["data"].map((x) => Adds.fromJson(x))),
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
