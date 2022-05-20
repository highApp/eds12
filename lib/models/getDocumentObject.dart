class GetDocumentObject {
  GetDocumentObject({
    required this.message,
    required this.response,
    required this.status,
  });

  String message;
  DocumentRespose response;
  bool status;

  factory GetDocumentObject.fromMap(Map<String, dynamic> json) =>
      GetDocumentObject(
        message: json["message"],
        response: DocumentRespose?.fromMap(json["response"]),
        status: json["status"],
      );
}

class DocumentRespose {
  DocumentRespose({
    required this.id,
    required this.gid,
    required this.cnic,
    required this.contract,
    required this.warning,
    required this.ccma,
    required this.other,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  String gid;
  String cnic;
  String contract;
  String warning;
  String ccma;
  String? other;
  DateTime createdAt;
  DateTime updatedAt;

  factory DocumentRespose.fromMap(Map<String, dynamic> json) => DocumentRespose(
        id: json["id"],
        gid: json["gid"],
        cnic: json["cnic"] == null ? null : json["cnic"],
        contract: json["contract"] == null ? null : json["contract"],
        warning: json["warning"] == null ? null : json["warning"],
        ccma: json["ccma"] == null ? null : json["ccma"],
        other: json["other"] == null ? null : json["other"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );
}
