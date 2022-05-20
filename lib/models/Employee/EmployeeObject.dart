class EmployeeObject {
  EmployeeObject({
    required this.message,
    this.response,
    required this.status,
  });

  String? message;
  EmployeeDetailsObject? response;
  bool? status;

  factory EmployeeObject.fromMap(Map<String, dynamic> json) => EmployeeObject(
        message: json["message"] == null ? null : json["message"],
        response: json["response"] == null
            ? null
            : EmployeeDetailsObject?.fromMap(json["response"]),
        status: json["status"] == null ? null : json["status"],
      );

  Map<String, dynamic> toMap() => {
        "message": message == null ? null : message,
        "response": response == null ? null : response!.toMap(),
        "status": status == null ? null : status,
      };
}

class EmployeeDetailsObject {
  EmployeeDetailsObject({
    required this.id,
    required this.gid,
    required this.user,
    // required this.password,
    required this.image,
    required this.empid,
    required this.name,
    required this.surname,
    required this.cnic,
    required this.address,
    required this.phone,
    required this.jobTitle,
    this.oldEmployer,
    this.oldEmployerPhone,
    this.fingerid,
    this.faceid,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  String gid;
  String user;
  // String password;
  String image;
  String empid;
  String name;
  String? surname;
  String cnic;
  String address;
  String phone;
  String jobTitle;
  dynamic oldEmployer;
  dynamic oldEmployerPhone;
  dynamic fingerid;
  dynamic faceid;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory EmployeeDetailsObject.fromMap(Map<String, dynamic> json) =>
      EmployeeDetailsObject(
        id: json["id"] == null ? null : json["id"],
        gid: json["gid"] == null ? null : json["gid"],
        user: json["user"] == null ? null : json["user"],
        // password: json["password"] == null ? null : json["password"],
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

  Map<String, dynamic> toMap() => {
        "id": id == null ? null : id,
        "gid": gid == null ? null : gid,
        "user": user == null ? null : user,
        // "password": password == null ? null : password,
        "image": image == null ? null : image,
        "empid": empid == null ? null : empid,
        "name": name == null ? null : name,
        "surname": surname == null ? null : surname,
        "cnic": cnic == null ? null : cnic,
        "address": address == null ? null : address,
        "phone": phone == null ? null : phone,
        "jobTitle": jobTitle == null ? null : jobTitle,
        "oldEmployer": oldEmployer,
        "oldEmployerPhone": oldEmployerPhone,
        "fingerid": fingerid,
        "faceid": faceid,
        "created_at": createdAt == null ? null : createdAt,
        "updated_at": updatedAt == null ? null : updatedAt,
      };
}
