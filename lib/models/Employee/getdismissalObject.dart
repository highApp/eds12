class GetDismissalObject {
  GetDismissalObject({
    required this.message,
    this.response,
    required this.status,
  });

  String message;
  GetDismissal? response;
  bool status;

  factory GetDismissalObject.fromMap(Map<String, dynamic> json) =>
      GetDismissalObject(
        message: json["message"] == null ? null : json["message"],
        response: json["response"] == null
            ? null
            : GetDismissal.fromMap(json["response"]),
        status: json["status"] == null ? null : json["status"],
      );
}

class GetDismissal {
  GetDismissal({
    required this.id,
    required this.gid,
    required this.reason,
    required this.date,
    required this.notice,
    this.otherDoc,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  String gid;
  String reason;
  String date;
  String notice;
  dynamic otherDoc;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory GetDismissal.fromMap(Map<String, dynamic> json) => GetDismissal(
        id: json["id"] == null ? null : json["id"],
        gid: json["gid"] == null ? null : json["gid"],
        reason: json["reason"] == null ? null : json["reason"],
        date: json["date"] == null ? null : json["date"],
        notice: json["notice"] == null ? null : json["notice"],
        otherDoc: json["otherDoc"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );
}
