class BListModel {
  bool? status;
  List<Expenses>? expenses;

  BListModel({this.status, this.expenses});

  BListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['expenses'] != null) {
      expenses = <Expenses>[];
      json['expenses'].forEach((v) {
        expenses!.add(new Expenses.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.expenses != null) {
      data['expenses'] = this.expenses!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Expenses {
  String? id;
  String? sid;
  String? pname;
  String? quantity;
  String? price;
  String? total;
  String? profit;
  String? createdAt;
  String? updatedAt;

  Expenses(
      {this.id,
        this.sid,
        this.pname,
        this.quantity,
        this.price,
        this.total,
        this.profit,
        this.createdAt,
        this.updatedAt});

  Expenses.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    sid = json['sid'];
    pname = json['pname'];
    quantity = json['quantity'];
    price = json['price'];
    total = json['total'];
    profit = json['profit'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['sid'] = this.sid;
    data['pname'] = this.pname;
    data['quantity'] = this.quantity;
    data['price'] = this.price;
    data['total'] = this.total;
    data['profit'] = this.profit;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
