// To parse this JSON data, do
//
//     final categoryObject = categoryObjectFromMap(jsonString);

import 'dart:convert';

CategoryObject categoryObjectFromMap(String str) => CategoryObject.fromMap(json.decode(str));

String categoryObjectToMap(CategoryObject data) => json.encode(data.toMap());

class CategoryObject {
  CategoryObject({
    required this.message,
    required this.response,
    required this.status,
  });

  String message;
  List<CategoryModel>? response;
  bool status;

  factory CategoryObject.fromMap(Map<String, dynamic> json) => CategoryObject(
    message: json["message"] == null ? null : json["message"],
    response: json["response"] == null ? null : List<CategoryModel>.from(json["response"].map((x) => CategoryModel.fromMap(x))),
    status: json["status"] == null ? null : json["status"],
  );

  Map<String, dynamic> toMap() => {
    "message": message == null ? null : message,
    "response": response == null ? null : List<dynamic>.from(response!.map((x) => x.toMap())),
    "status": status == null ? null : status,
  };
}

class CategoryModel {
  CategoryModel({
    required this.id,
    required this.empid,
    required this.name,
    required this.image,
    required this.createdAt,
    required this.updatedAt,
  });

  String id;
  String empid;
  String name;
  String image;
  String createdAt;
  String updatedAt;

  factory CategoryModel.fromMap(Map<String, dynamic> json) => CategoryModel(
    id: json["id"] == null ? null : json["id"],
    empid: json["empid"] == null ? null : json["empid"],
    name: json["name"] == null ? null : json["name"],
    image: json["image"] == null ? null : json["image"],
    createdAt: json["created_at"] == null ? null : json["created_at"],
    updatedAt: json["updated_at"] == null ? null :json["updated_at"],
  );

  Map<String, dynamic> toMap() => {
    "id": id == null ? null : id,
    "empid": empid == null ? null : empid,
    "name": name == null ? null : name,
    "image": image == null ? null : image,
    "created_at": createdAt == null ? null : createdAt,
    "updated_at": updatedAt == null ? null : updatedAt,
  };
}
