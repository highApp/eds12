import 'dart:convert';

SignUpResponse signUpResponseFromJSON(String str) =>
    SignUpResponse.fromJson(json.decode(str));

String signUpResponseToJSON(SignUpResponse str) => json.encode(str);

class SignUpResponse {
  String? message;
  List<Response>? response;
  bool? status;

  SignUpResponse(
      {required this.message, required this.response, required this.status});

  SignUpResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['response'] != null) {
      List<Response> response = [];
      json['response'].forEach((v) {
        response.add(new Response.fromJson(v));
      });
    }
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.response != null) {
      data['response'] = this.response!.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    return data;
  }
}

class Response {
  int? id;
  String? name;
  String? email;
  String? number;
  String? message;
  String? regDocument;
  String? bankLetter;

  Response(
      {required this.id,
      required this.name,
      required this.email,
      required this.number,
      required this.message,
      required this.regDocument,
      required this.bankLetter});

  Response.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    number = json['number'];
    message = json['message'];
    regDocument = json['regDocument'];
    bankLetter = json['bankLetter'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['number'] = this.number;
    data['message'] = this.message;
    data['regDocument'] = this.regDocument;
    data['bankLetter'] = this.bankLetter;
    return data;
  }
}
