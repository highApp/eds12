class GetEmployeeObject {
  GetEmployeeObject({
    required this.message,
    required this.response,
    required this.status,
  });

  String? message;
  Response? response;
  bool? status;

  factory GetEmployeeObject.fromMap(Map<String, dynamic> json) =>
      GetEmployeeObject(
        message: json["message"],
        response: Response.fromMap(json["response"]),
        status: json["status"],
      );

  Map<String, dynamic> toMap() => {
        "message": message,
        "response": response!.toMap(),
        "status": status,
      };
}

class Response {
  Response({
    required this.id,
    required this.empid,
    required this.name,
    required this.surname,
    required this.cnic,
    required this.address,
    required this.phone,
    required this.jobTitle,
    this.oldEmployer,
    this.oldEmployerPhone,
    required this.fingerid,
    this.faceid,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  String empid;
  String name;
  String surname;
  String cnic;
  String address;
  String phone;
  String jobTitle;
  dynamic oldEmployer;
  dynamic oldEmployerPhone;
  String fingerid;
  dynamic faceid;
  DateTime createdAt;
  DateTime updatedAt;

  factory Response.fromMap(Map<String, dynamic> json) => Response(
        id: json["id"],
        empid: json["empid"],
        name: json["name"],
        surname: json["surname"],
        cnic: json["cnic"],
        address: json["address"],
        phone: json["phone"],
        jobTitle: json["jobTitle"],
        oldEmployer: json["oldEmployer"],
        oldEmployerPhone: json["oldEmployerPhone"],
        fingerid: json["fingerid"],
        faceid: json["faceid"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "empid": empid,
        "name": name,
        "surname": surname,
        "cnic": cnic,
        "address": address,
        "phone": phone,
        "jobTitle": jobTitle,
        "oldEmployer": oldEmployer,
        "oldEmployerPhone": oldEmployerPhone,
        "fingerid": fingerid,
        "faceid": faceid,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
