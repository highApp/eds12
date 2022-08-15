// To parse this JSON data, do
//
//     final bNameModel = bNameModelFromJson(jsonString);

import 'dart:convert';

BNameModel bNameModelFromJson(String str) => BNameModel.fromJson(json.decode(str));

String bNameModelToJson(BNameModel data) => json.encode(data.toJson());

class BNameModel {
  BNameModel({
    this.message,
    this.pNames,
    this.status,
  });

  String? message;
  List<String>? pNames;
  bool? status;

  factory BNameModel.fromJson(Map<String, dynamic> json) => BNameModel(
    message: json["message"],
    pNames: List<String>.from(json["p_names"].map((x) => x)),
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "p_names": List<dynamic>.from(pNames!.map((x) => x)),
    "status": status,
  };
}



