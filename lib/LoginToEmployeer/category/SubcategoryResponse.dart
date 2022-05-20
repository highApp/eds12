// To parse this JSON data, do
//
//     final subCategoryObject = subCategoryObjectFromMap(jsonString);

import 'dart:convert';

SubCategoryObject subCategoryObjectFromMap(String str) => SubCategoryObject.fromMap(json.decode(str));

String subCategoryObjectToMap(SubCategoryObject data) => json.encode(data.toMap());

class SubCategoryObject {
  SubCategoryObject({
    required this.message,
    required this.response,
    required this.status,
  });

  String message;
  List<SubcategModel>? response;
  bool status;

  factory SubCategoryObject.fromMap(Map<String, dynamic> json) => SubCategoryObject(
    message: json["message"] == null ? null : json["message"],
    response: json["response"] == null ? null : List<SubcategModel>.from(json["response"].map((x) => SubcategModel.fromMap(x))),
    status: json["status"] == null ? null : json["status"],
  );

  Map<String, dynamic> toMap() => {
    "message": message == null ? null : message,
    "response": response == null ? null : List<dynamic>.from(response!.map((x) => x.toMap())),
    "status": status == null ? null : status,
  };
}

class SubcategModel {
  SubcategModel({
    required this.id,
    required this.cid,
    required this.name,
    required this.image,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  String cid;
  String name;
  String image;
  String createdAt;
  String updatedAt;

  factory SubcategModel.fromMap(Map<String, dynamic> json) => SubcategModel(
    id: json["id"] == null ? null : json["id"],
    cid: json["cid"] == null ? null : json["cid"],
    name: json["name"] == null ? null : json["name"],
    image: json["image"] == null ? null : json["image"],
    createdAt: json["created_at"] == null ? null : json["created_at"],
    updatedAt: json["updated_at"] == null ? null : json["updated_at"],
  );

  Map<String, dynamic> toMap() => {
    "id": id == null ? null : id,
    "cid": cid == null ? null : cid,
    "name": name == null ? null : name,
    "image": image == null ? null : image,
    "created_at": createdAt == null ? null : createdAt,
    "updated_at": updatedAt == null ? null : updatedAt,
  };
}
