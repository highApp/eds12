class PaySlipObject {
  PaySlipObject({
    required this.message,
    required this.response,
    required this.filename,
    required this.status,
  });

  String message;
  PaySlip? response;
  String filename;
  bool status;

  factory PaySlipObject.fromMap(Map<String, dynamic> json) => PaySlipObject(
        message: json["message"] == null ? null : json["message"],
        response:
            json["response"] == null ? null : PaySlip.fromMap(json["response"]),
        filename: json["filename"] == null ? null : json["filename"],
        status: json["status"] == null ? null : json["status"],
      );
}

class PaySlip {
  PaySlip({
    required this.id,
    required this.gid,
    required this.timeLog,
    required this.bank,
    this.paySlip,
    required this.salary,
    required this.payDay,
    required this.payMethod,
    required this.paid,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  String gid;
  String timeLog;
  String bank;
  dynamic paySlip;
  String salary;
  String payDay;
  String payMethod;
  String paid;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory PaySlip.fromMap(Map<String, dynamic> json) => PaySlip(
        id: json["id"] == null ? null : json["id"],
        gid: json["gid"] == null ? null : json["gid"],
        timeLog: json["timeLog"] == null ? null : json["timeLog"],
        bank: json["bank"] == null ? null : json["bank"],
        paySlip: json["paySlip"],
        salary: json["salary"] == null ? null : json["salary"],
        payDay: json["payDay"] == null ? null : json["payDay"],
        payMethod: json["payMethod"] == null ? null : json["payMethod"],
        paid: json["paid"] == null ? null : json["paid"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );
}
