class AttendenceObject {
  AttendenceObject({
    required this.message,
    this.response,
    required this.status,
  });

  String message;
  Attendence? response;
  bool status;

  factory AttendenceObject.fromMap(Map<String, dynamic> json) =>
      AttendenceObject(
        message: json["message"] == null ? null : json["message"],
        response: json["response"] == null
            ? null
            : Attendence.fromMap(json["response"]),
        status: json["status"] == null ? null : json["status"],
      );
}

class Attendence {
  Attendence({
    required this.id,
    required this.gid,
    required this.date,
    this.start,
    this.stop,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  String gid;
  String date;
  String? start;
  String? stop;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory Attendence.fromMap(Map<String, dynamic> json) => Attendence(
        id: json["id"] == null ? null : json["id"],
        gid: json["gid"] == null ? null : json["gid"],
        date: json["date"] == null ? null : json["date"],
        start: json["start"] == null ? null : json["start"],
        stop: json["stop"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );
}
