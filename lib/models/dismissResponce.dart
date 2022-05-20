import 'dart:convert';

DismissREsponse dismissResponceFromJSON(String str) =>
    DismissREsponse.fromJson(json.decode(str));

String dismissResponceToJSON(DismissREsponse str) => json.encode(str);

class DismissREsponse {
  String? message;
  bool? status;

  DismissREsponse({required this.message, required this.status});

  DismissREsponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['status'] = this.status;
    return data;
  }
}
