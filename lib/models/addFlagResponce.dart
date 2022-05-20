import 'dart:convert';

AddFlagRespoce documentResponceFromJSON(String str) =>
    AddFlagRespoce.fromJson(json.decode(str));

String documentResponceToJSON(AddFlagRespoce str) => json.encode(str);

class AddFlagRespoce {
  String? message;
  AddedFlag? response;
  bool? status;

  AddFlagRespoce(
      {required this.message, required this.response, required this.status});

  AddFlagRespoce.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    response = (json['response'] != null
        ? new AddedFlag.fromJson(json['response'])
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

class AddedFlag {
  int? gid;
  String? flag;
  String? policeReport;
  String? otherDoc;
  String? updatedAt;
  String? createdAt;
  int? id;

  AddedFlag(
      {required this.gid,
      required this.flag,
      required this.policeReport,
      required this.otherDoc,
      required this.updatedAt,
      required this.createdAt,
      required this.id});

  AddedFlag.fromJson(Map<String, dynamic> json) {
    gid = json['gid'];
    flag = json['flag'];
    policeReport = json['policeReport'];
    otherDoc = json['otherDoc'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['gid'] = this.gid;
    data['flag'] = this.flag;
    data['policeReport'] = this.policeReport;
    data['otherDoc'] = this.otherDoc;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    data['id'] = this.id;
    return data;
  }
}
