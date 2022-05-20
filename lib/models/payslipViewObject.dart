class PayrollviewObject {
  PayrollviewObject({
    required this.message,
    this.response,
    required this.status,
  });

  String message;
  PayRlView? response;
  bool status;

  factory PayrollviewObject.fromMap(Map<String, dynamic> json) =>
      PayrollviewObject(
        message: json["message"] == null ? null : json["message"],
        response: json["response"] == null
            ? null
            : PayRlView.fromMap(json["response"]),
        status: json["status"] == null ? null : json["status"],
      );
}

class PayRlView {
  PayRlView({
    required this.id,
    required this.gid,
    required this.timeLog,
    required this.bank,
    this.paySlip,
    required this.salary,
    required this.payDay,
    required this.payMethod,
    required this.paid,
    this.createdAt,
    this.updatedAt,
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

  factory PayRlView.fromMap(Map<String, dynamic> json) => PayRlView(
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
