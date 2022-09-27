class NotificationData {
  List<Data> data;

  NotificationData({this.data});

  NotificationData.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String title;
  String body;
  String createdAt;

  Data({this.title, this.body, this.createdAt});

  Data.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    body = json['body'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['body'] = this.body;
    data['created_at'] = this.createdAt;
    return data;
  }
}
