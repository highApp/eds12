// To parse this JSON data, do
//
//     final stockModel = stockModelFromJson(jsonString);

import 'dart:convert';

StockModel stockModelFromJson(String str) => StockModel.fromJson(json.decode(str));

String stockModelToJson(StockModel data) => json.encode(data.toJson());

class StockModel {
  StockModel({
    this.message,
    this.response,
    this.status,
  });

  String? message;
  String? response;
  bool? status;

  factory StockModel.fromJson(Map<String, dynamic> json) => StockModel(
    message: json["message"],
    response: json["response"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "response": response,
    "status": status,
  };
}
