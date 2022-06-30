class NotificationData {
  String status;
  int code;
  PageData pageData;

  NotificationData({this.status, this.code, this.pageData});

  NotificationData.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    pageData = PageData.fromJson(json['data']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['code'] = this.code;
    data['data'] = this.pageData.toJson();
    return data;
  }
}

class PageData {
  int currentPage;
  List<Data> data = [];
  String firstPageUrl;
  int from;
  int lastPage;
  String lastPageUrl;
  String path;
  int perPage;

  int to;
  int total;

  PageData(
      {this.currentPage,
      this.data,
      this.firstPageUrl,
      this.from,
      this.lastPage,
      this.lastPageUrl,
      this.path,
      this.perPage,
      this.to,
      this.total});

  PageData.fromJson(Map<String, dynamic> json) {
    print(json['data']);

    currentPage = json['current_page'];

    json['data'].forEach((v) {
      data.add(new Data.fromJson(v));
    });

    firstPageUrl = json['first_page_url'];
    from = json['from'];
    lastPage = json['last_page'];
    lastPageUrl = json['last_page_url'];

    path = json['path'];
    perPage = json['per_page'];
    to = json['to'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['current_page'] = this.currentPage;
    data['current_page'] = this.currentPage;

    data['data'] = this.data.map((v) => v.toJson()).toList();

    data['first_page_url'] = this.firstPageUrl;
    data['from'] = this.from;
    data['last_page'] = this.lastPage;
    data['last_page_url'] = this.lastPageUrl;

    data['path'] = this.path;
    data['per_page'] = this.perPage;
    data['to'] = this.to;
    data['total'] = this.total;
    return data;
  }
}

class Data {
  String id;
  String title;
  String body;
  String image;
  String userId;
  String createdAt;
  String updatedAt;

  Data(
      {this.id,
      this.title,
      this.body,
      this.image,
      this.userId,
      this.createdAt,
      this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    print(json);
    id = json['id'];
    title = json['title'];
    body = json['body'];
    image = json['image'];
    userId = json['user_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['body'] = this.body;
    data['image'] = this.image;
    data['user_id'] = this.userId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
