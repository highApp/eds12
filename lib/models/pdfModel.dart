// To parse this JSON data, do
//
//     final printModel = printModelFromJson(jsonString);

import 'dart:convert';

PrintModel printModelFromJson(String str) => PrintModel.fromJson(json.decode(str));

String printModelToJson(PrintModel data) => json.encode(data.toJson());

class PrintModel {
  PrintModel({
    this.status,
    this.expensesPdf,
  });

  bool? status;
  String? expensesPdf;

  factory PrintModel.fromJson(Map<String, dynamic> json) => PrintModel(
    status: json["status"],
    expensesPdf: json["expenses_pdf"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "expenses_pdf": expensesPdf,
  };
}
