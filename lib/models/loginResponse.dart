// To parse this JSON data, do
//
//     final emplyerLogin = emplyerLoginFromMap(jsonString);

import 'dart:convert';

EmplyerLogin emplyerLoginFromMap(String str) =>
    EmplyerLogin.fromMap(json.decode(str));

String emplyerLoginToMap(EmplyerLogin data) => json.encode(data.toMap());

class EmplyerLogin {
  EmplyerLogin({
    required this.message,
    required this.response,
    required this.status,
  });

  String message;
  LogedInUser response;
  bool status;

  factory EmplyerLogin.fromMap(Map<String, dynamic> json) => EmplyerLogin(
        message: json["message"],
        response: LogedInUser.fromMap(json["response"]),
        status: json["status"],
      );

  Map<String, dynamic> toMap() => {
        "message": message,
        "response": response.toMap(),
        "status": status,
      };
}

class LogedInUser {
  LogedInUser({
    required this.employer,
    required this.owners,
    required this.contacts,
  });

  Employer employer;
  List<Contact> owners;
  List<Contact> contacts;

  factory LogedInUser.fromMap(Map<String, dynamic> json) => LogedInUser(
        employer: Employer.fromMap(json["Employer"]),
        owners:
            List<Contact>.from(json["Owners"].map((x) => Contact.fromMap(x))),
        contacts:
            List<Contact>.from(json["Contacts"].map((x) => Contact.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "Employer": employer.toMap(),
        "Owners": List<dynamic>.from(owners.map((x) => x)),
        "Contacts": List<dynamic>.from(contacts.map((x) => x)),
      };
}

class Contact {
  Contact({
    required this.id,
    required this.empid,
    required this.number,
    required this.createdAt,
    required this.updatedAt,
    required this.name,
  });

  int id;
  String empid;
  String number;
  DateTime? createdAt;
  DateTime? updatedAt;
  String name;

  factory Contact.fromMap(Map<String, dynamic> json) => Contact(
        id: json["id"],
        empid: json["empid"],
        number: json["number"] == null ? "" : json["number"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        name: json["name"] == null ? "" : json["name"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "empid": empid,
        "number": number == null ? null : number,
        "created_at": createdAt == null ? null : createdAt,
        "updated_at": updatedAt == null ? null : updatedAt,
        "name": name == null ? null : name,
      };
}

class Employer {
  Employer({
    required this.id,
    required this.name,
    required this.email,
    this.address,
    required this.message,
    this.image,
    required this.regDocument,
    required this.bankLetter,
    required this.password,
    required this.status,
    required this.view,
    this.rememberToken,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  String name;
  String email;
  dynamic address;
  String message;
  dynamic image;
  String regDocument;
  String bankLetter;
  String password;
  String status;
  String view;
  dynamic rememberToken;
  DateTime createdAt;
  DateTime updatedAt;

  factory Employer.fromMap(Map<String, dynamic> json) => Employer(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        address: json["address"],
        message: json["message"],
        image: json["image"],
        regDocument: json["regDocument"],
        bankLetter: json["bankLetter"],
        password: json["password"],
        status: json["status"],
        view: json["view"],
        rememberToken: json["remember_token"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "email": email,
        "address": address,
        "message": message,
        "image": image,
        "regDocument": regDocument,
        "bankLetter": bankLetter,
        "password": password,
        "status": status,
        "view": view,
        "remember_token": rememberToken,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
