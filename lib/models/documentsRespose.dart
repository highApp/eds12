import 'dart:convert';

DocumentsResponce documentResponceFromJSON(String str) =>
    DocumentsResponce.fromJson(json.decode(str));

String documentResponceToJSON(DocumentsResponce str) => json.encode(str);

class DocumentsResponce {
  String? message;
  Response? response;
  bool? status;

  DocumentsResponce(
      {required this.message, required this.response, required this.status});

  DocumentsResponce.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    response = (json['response'] != null
        ? new Response.fromJson(json['response'])
        : null)!;
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.response != null) {
      data['response'] = this.response!.toJson();
    }
    data['status'] = this.status;
    return data;
  }
}

class Response {
  int? id;
  String? gid;
  String? cnic;
  String? contract;
  String? warning;
  String? ccma;
  String? other;
  String? createdAt;
  String? updatedAt;

  Response(
      {required this.id,
      required this.gid,
      required this.cnic,
      required this.contract,
      required this.warning,
      required this.ccma,
      required this.other,
      required this.createdAt,
      required this.updatedAt});

  Response.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    gid = json['gid'];
    cnic = json['cnic'];
    contract = json['contract'];
    warning = json['warning'];
    ccma = json['ccma'];
    other = json['other'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['gid'] = this.gid;
    data['cnic'] = this.cnic;
    data['contract'] = this.contract;
    data['warning'] = this.warning;
    data['ccma'] = this.ccma;
    data['other'] = this.other;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
