class AccountType {
  String status;
  int code;
  String message;
  String messageAr;
  List<Account> accounts;

  AccountType(
      {this.status, this.code, this.message, this.messageAr, this.accounts});

  AccountType.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    message = json['message'];
    messageAr = json['messageAr'];
    if (json['data'] != null) {
      accounts = <Account>[];
      json['data'].forEach((v) {
        accounts.add(new Account.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['code'] = this.code;
    data['message'] = this.message;
    data['messageAr'] = this.messageAr;
    if (this.accounts != null) {
      data['data'] = this.accounts.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Account {
  int id;
  int sellerId;
  int contactInfoTypeId;
  String info;
  // Null deletedAt;
  String createdAt;
  String updatedAt;

  Account(
      {this.id,
      this.sellerId,
      this.contactInfoTypeId,
      this.info,
      // this.deletedAt,
      this.createdAt,
      this.updatedAt});

  Account.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    sellerId = json['seller_id'];
    contactInfoTypeId = json['contact_info_type_id'];
    info = json['info'];
    // deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['seller_id'] = this.sellerId;
    data['contact_info_type_id'] = this.contactInfoTypeId;
    data['info'] = this.info;
    // data['deleted_at'] = this.deletedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
