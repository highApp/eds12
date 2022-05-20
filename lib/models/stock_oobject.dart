class StockObject {
  StockObject({
    this.message,
    this.response,
    this.status,
  });

  String? message;
  List<StockObj>? response;
  bool? status;

  factory StockObject.fromMap(Map<String, dynamic> json) => StockObject(
        message: json["message"] == null ? null : json["message"],
        response: json["response"] == null
            ? null
            : List<StockObj>.from(
                json["response"].map((x) => StockObj.fromMap(x))),
        status: json["status"] == null ? null : json["status"],
      );
}

class StockObj {
  StockObj({
    this.date,
    this.stock,
  });

  String? date;
  List<Stock>? stock;

  factory StockObj.fromMap(Map<String, dynamic> json) => StockObj(
        date: json["date"] == null ? null : json["date"],
        stock: json["stock"] == null
            ? null
            : List<Stock>.from(json["stock"].map((x) => Stock.fromMap(x))),
      );
}

class Stock {
  Stock({
    this.id,
    this.empid,
    this.cid,
    this.scid,
    this.productName,
    this.amount,
    this.totalAmount,
    this.remainingAmount,
    this.description,
    this.image,
    this.optionalAmount,
    this.rent,
    this.labour,
    this.quantity,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  String? empid;
  String? cid;
  String? scid;
  String? productName;
  String? amount;
  String? totalAmount;
  String? remainingAmount;
  String? description;
  String? image;
  String? optionalAmount;
  String? rent;
  String? labour;
  String? quantity;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory Stock.fromMap(Map<String, dynamic> json) => Stock(
        id: json["id"] == null ? null : json["id"],
        empid: json["empid"] == null ? null : json["empid"],
        cid: json["cid"] == null ? null : json["cid"],
        scid: json["scid"] == null ? null : json["scid"],
        productName: json["productName"] == null ? null : json["productName"],
        amount: json["amount"] == null ? null : json["amount"],
        totalAmount: json["totalAmount"] == null ? null : json["totalAmount"],
        remainingAmount:
            json["remainingAmount"] == null ? null : json["remainingAmount"],
        description: json["description"] == null ? null : json["description"],
        image: json["image"] == null ? null : json["image"],
        optionalAmount:
            json["optionalAmount"] == null ? null : json["optionalAmount"],
        rent: json["rent"] == null ? null : json["rent"],
        labour: json["labour"] == null ? null : json["labour"],
        quantity: json["quantity"] == null ? null : json["quantity"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );
}
