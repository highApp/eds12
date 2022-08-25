// class BListModel {
//   bool? status;
//   List<Expenses>? expenses;
//   double? totalExpenseAmount;
//
//   BListModel({this.status, this.expenses, this.totalExpenseAmount});
//
//   BListModel.fromJson(Map<String, dynamic> json) {
//     status = json['status'];
//     if (json['expenses'] != null) {
//       expenses = <Expenses>[];
//       json['expenses'].forEach((v) {
//         expenses!.add(new Expenses.fromJson(v));
//       });
//     }
//     totalExpenseAmount = json['total_expense_amount'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['status'] = this.status;
//     if (this.expenses != null) {
//       data['expenses'] = this.expenses!.map((v) => v.toJson()).toList();
//     }
//     data['total_expense_amount'] = this.totalExpenseAmount;
//     return data;
//   }
// }
//
// class Expenses {
//   String? productName;
//   String? quantity;
//   double? unitPrice;
//   double? totalPrice;
//
//   Expenses({this.productName, this.quantity, this.unitPrice, this.totalPrice});
//
//   Expenses.fromJson(Map<String, dynamic> json) {
//     productName = json['product_name'];
//     quantity = json['quantity'];
//     unitPrice = json['unit_price'];
//     totalPrice = json['total_price'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['product_name'] = this.productName;
//     data['quantity'] = this.quantity;
//     data['unit_price'] = this.unitPrice;
//     data['total_price'] = this.totalPrice;
//     return data;
//   }
// }
// To parse this JSON data, do
//
//     final bListModel = bListModelFromJson(jsonString);

import 'dart:convert';

BListModel bListModelFromJson(String str) =>
    BListModel.fromJson(json.decode(str));

String bListModelToJson(BListModel data) => json.encode(data.toJson());

class BListModel {
  BListModel({
    this.status,
    this.expenses,
    this.totalExpenseAmount,
  });

  bool? status;
  List<Expense>? expenses;
  var totalExpenseAmount;

  factory BListModel.fromJson(Map<String, dynamic> json) {
    return BListModel(
      status: json["status"],
      expenses:
          List<Expense>.from(json["expenses"].map((x) => Expense.fromJson(x))),
      totalExpenseAmount: json["total_expense_amount"],
    );
  }

  Map<String, dynamic> toJson() => {
        "status": status,
        "expenses": List<dynamic>.from(expenses!.map((x) => x.toJson())),
        "total_expense_amount": totalExpenseAmount,
      };
}

class Expense {
  Expense({
    this.productName,
    this.quantity,
    this.unitPrice,
    this.totalPrice,
  });

  String? productName;
  String? quantity;
  double? unitPrice;
  double? totalPrice;

  factory Expense.fromJson(Map<String, dynamic> json) => Expense(
        productName: json["product_name"],
        quantity: json["quantity"],
        unitPrice: json["unit_price"].toDouble(),
        totalPrice: json["total_price"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "product_name": productName,
        "quantity": quantity,
        "unit_price": unitPrice,
        "total_price": totalPrice,
      };
}
