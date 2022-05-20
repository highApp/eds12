class EmplyerDashboardObject {
  EmplyerDashboardObject({
    required this.message,
    required this.response,
    required this.status,
  });

  String message;
  List<Users> response;
  bool status;

  factory EmplyerDashboardObject.fromMap(Map<String, dynamic> json) =>
      EmplyerDashboardObject(
        message: json["message"],
        response:
            List<Users>.from(json["response"].map((x) => Users.fromMap(x))),
        status: json["status"],
      );

  Map<String, dynamic> toMap() => {
        "message": message,
        "response": List<dynamic>.from(response.map((x) => x.toMap())),
        "status": status,
      };
}

class Users {
  Users({
    required this.id,
    required this.gid,
    this.user,
    this.password,
    this.image,
    required this.empid,
    this.name,
    this.surname,
    this.cnic,
    this.address,
    this.phone,
    this.jobTitle,
    this.oldEmployer,
    this.oldEmployerPhone,
    this.fingerid,
    this.faceid,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  String gid;
  String? user;
  String? password;
  String? image;
  String empid;
  String? name;
  String? surname;
  String? cnic;
  String? address;
  String? phone;
  String? jobTitle;
  dynamic oldEmployer;
  dynamic oldEmployerPhone;
  dynamic fingerid;
  dynamic faceid;
  DateTime createdAt;
  DateTime updatedAt;

  factory Users.fromMap(Map<String, dynamic> json) => Users(
        id: json["id"],
        gid: json["gid"],
        user: json["user"],
        password: json["password"],
        image: json["image"],
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
        "gid": gid,
        "user": user,
        "password": password,
        "image": image,
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
