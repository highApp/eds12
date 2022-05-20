// To parse this JSON data, do
//
//     final flagsObject = flagsObjectFromMap(jsonString);

import 'dart:convert';

FlagsObject flagsObjectFromMap(String str) =>
    FlagsObject.fromMap(json.decode(str));

String flagsObjectToMap(FlagsObject data) => json.encode(data.toMap());

class FlagsObject {
  FlagsObject({
    required this.message,
    required this.response,
    required this.status,
  });

  String message;
  List<Flags> response;
  bool status;

  factory FlagsObject.fromMap(Map<String, dynamic> json) => FlagsObject(
        message: json["message"],
        response:
            List<Flags>.from(json["response"].map((x) => Flags.fromMap(x))),
        status: json["status"],
      );

  Map<String, dynamic> toMap() => {
        "message": message,
        "response": List<dynamic>.from(response.map((x) => x.toMap())),
        "status": status,
      };
}

class Flags {
  Flags({
    required this.id,
    required this.gid,
    required this.flag,
    required this.policeReport,
    this.otherDoc,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  String gid;
  String flag;
  String policeReport;
  dynamic otherDoc;
  DateTime createdAt;
  DateTime updatedAt;

  factory Flags.fromMap(Map<String, dynamic> json) => Flags(
        id: json["id"],
        gid: json["gid"],
        flag: json["flag"],
        policeReport: json["policeReport"],
        otherDoc: json["otherDoc"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "gid": gid,
        "flag": flag,
        "policeReport": policeReport,
        "otherDoc": otherDoc,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
