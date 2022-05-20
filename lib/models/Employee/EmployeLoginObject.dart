class EmployeeLoginObject {
  EmployeeLoginObject({
    required this.message,
    required this.response,
    required this.status,
  });

  String message;
  EmployeeLogin? response;
  bool status;

  factory EmployeeLoginObject.fromMap(Map<String, dynamic> json) =>
      EmployeeLoginObject(
        message: json["message"] == null ? null : json["message"],
        response: json["response"] == null
            ? null
            : EmployeeLogin.fromMap(json["response"]),
        status: json["status"] == null ? null : json["status"],
      );
}

class EmployeeLogin {
  EmployeeLogin({
    required this.id,
    required this.gid,
    required this.user,
    this.password,
    required this.image,
    this.empid,
    required this.name,
    this.surname,
    this.cnic,
    this.address,
    this.phone,
    this.jobTitle,
    this.oldEmployer,
    this.oldEmployerPhone,
    this.fingerid,
    this.faceid,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  String gid;
  String user;
  String? password;
  String image;
  String? empid;
  String name;
  String? surname;
  String? cnic;
  String? address;
  String? phone;
  String? jobTitle;
  dynamic oldEmployer;
  dynamic oldEmployerPhone;
  dynamic fingerid;
  dynamic faceid;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory EmployeeLogin.fromMap(Map<String, dynamic> json) => EmployeeLogin(
        id: json["id"] == null ? null : json["id"],
        gid: json["gid"] == null ? null : json["gid"],
        user: json["user"] == null ? null : json["user"],
        password: json["password"] == null ? null : json["password"],
        image: json["image"] == null ? null : json["image"],
        empid: json["empid"] == null ? null : json["empid"],
        name: json["name"] == null ? null : json["name"],
        surname: json["surname"] == null ? null : json["surname"],
        cnic: json["cnic"] == null ? null : json["cnic"],
        address: json["address"] == null ? null : json["address"],
        phone: json["phone"] == null ? null : json["phone"],
        jobTitle: json["jobTitle"] == null ? null : json["jobTitle"],
        oldEmployer: json["oldEmployer"],
        oldEmployerPhone: json["oldEmployerPhone"],
        fingerid: json["fingerid"],
        faceid: json["faceid"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );
}
