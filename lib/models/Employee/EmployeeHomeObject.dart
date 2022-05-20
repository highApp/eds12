// class EmployeeHomeObject {
//   EmployeeHomeObject({
//     this.message,
//     this.response,
//     this.status,
//   });

//   String? message;
//   EmployeObject? response;
//   bool? status;

//   factory EmployeeHomeObject.fromMap(Map<String, dynamic> json) =>
//       EmployeeHomeObject(
//         message: json["message"] == null ? null : json["message"],
//         response: json["response"] == null
//             ? null
//             : EmployeObject.fromMap(json["response"]),
//         status: json["status"] == null ? null : json["status"],
//       );

//   Map<String, dynamic> toMap() => {
//         "message": message == null ? null : message,
//         "response": response == null ? null : response!.toMap(),
//         "status": status == null ? null : status,
//       };
// }

// class EmployeObject {
//   EmployeObject({
//     this.employee,
//     this.history,
//   });

//   Employee? employee;
//   List<Employee>? history;

//   factory EmployeObject.fromMap(Map<String, dynamic> json) => EmployeObject(
//         employee: json["employee"] == null
//             ? null
//             : Employee.fromMap(json["employee"]),
//         history: json["history"] == null
//             ? null
//             : List<Employee>.from(
//                 json["history"].map((x) => Employee.fromMap(x))),
//       );

//   Map<String, dynamic> toMap() => {
//         "employee": employee == null ? null : employee!.toMap(),
//         "history": history == null
//             ? null
//             : List<dynamic>.from(history!.map((x) => x.toMap())),
//       };
// }

// class Employee {
//   Employee({
//     required this.id,
//     required this.gid,
//     required this.user,
//     required this.password,
//     required this.image,
//     required this.empid,
//     required this.name,
//     required this.surname,
//     required this.cnic,
//     required this.address,
//     required this.phone,
//     required this.jobTitle,
//     this.oldEmployer,
//     this.oldEmployerPhone,
//     this.fingerid,
//     this.faceid,
//     required this.createdAt,
//     required this.updatedAt,
//   });

//   int id;
//   String gid;
//   String user;
//   String password;
//   String image;
//   String empid;
//   String name;
//   String surname;
//   String cnic;
//   String address;
//   String phone;
//   String jobTitle;
//   dynamic oldEmployer;
//   dynamic oldEmployerPhone;
//   dynamic fingerid;
//   dynamic faceid;
//   DateTime? createdAt;
//   DateTime? updatedAt;

//   factory Employee.fromMap(Map<String, dynamic> json) => Employee(
//         id: json["id"] == null ? null : json["id"],
//         gid: json["gid"] == null ? null : json["gid"],
//         user: json["user"] == null ? null : json["user"],
//         password: json["password"] == null ? null : json["password"],
//         image: json["image"] == null ? null : json["image"],
//         empid: json["empid"] == null ? null : json["empid"],
//         name: json["name"] == null ? null : json["name"],
//         surname: json["surname"] == null ? null : json["surname"],
//         cnic: json["cnic"] == null ? null : json["cnic"],
//         address: json["address"] == null ? null : json["address"],
//         phone: json["phone"] == null ? null : json["phone"],
//         jobTitle: json["jobTitle"] == null ? null : json["jobTitle"],
//         oldEmployer: json["oldEmployer"],
//         oldEmployerPhone: json["oldEmployerPhone"],
//         fingerid: json["fingerid"],
//         faceid: json["faceid"],
//         createdAt: json["created_at"] == null
//             ? null
//             : DateTime.parse(json["created_at"]),
//         updatedAt: json["updated_at"] == null
//             ? null
//             : DateTime.parse(json["updated_at"]),
//       );

//   Map<String, dynamic> toMap() => {
//         "id": id == null ? null : id,
//         "gid": gid == null ? null : gid,
//         "user": user == null ? null : user,
//         "password": password == null ? null : password,
//         "image": image == null ? null : image,
//         "empid": empid == null ? null : empid,
//         "name": name == null ? null : name,
//         "surname": surname == null ? null : surname,
//         "cnic": cnic == null ? null : cnic,
//         "address": address == null ? null : address,
//         "phone": phone == null ? null : phone,
//         "jobTitle": jobTitle == null ? null : jobTitle,
//         "oldEmployer": oldEmployer,
//         "oldEmployerPhone": oldEmployerPhone,
//         "fingerid": fingerid,
//         "faceid": faceid,
//         "created_at": createdAt == null ? null : createdAt,
//         "updated_at": updatedAt == null ? null : updatedAt,
//       };
// }
// To parse this JSON data, do
//
//     final employeeHomeObject = employeeHomeObjectFromMap(jsonString);

import 'dart:convert';

EmployeeHomeObject employeeHomeObjectFromMap(String str) =>
    EmployeeHomeObject.fromMap(json.decode(str));

String employeeHomeObjectToMap(EmployeeHomeObject data) =>
    json.encode(data.toMap());

class EmployeeHomeObject {
  EmployeeHomeObject({
    required this.message,
    required this.response,
    required this.status,
  });

  String message;
  EmployerObject? response;
  bool status;

  factory EmployeeHomeObject.fromMap(Map<String, dynamic> json) =>
      EmployeeHomeObject(
        message: json["message"] == null ? null : json["message"],
        response: json["response"] == null
            ? null
            : EmployerObject.fromMap(json["response"]),
        status: json["status"] == null ? null : json["status"],
      );

  Map<String, dynamic> toMap() => {
        "message": message == null ? null : message,
        "response": response == null ? null : response!.toMap(),
        "status": status == null ? null : status,
      };
}

class EmployerObject {
  EmployerObject({
    required this.employee,
    required this.history,
  });

  Employee? employee;
  List<History>? history;

  factory EmployerObject.fromMap(Map<String, dynamic> json) => EmployerObject(
        employee: json["employee"] == null
            ? null
            : Employee.fromMap(json["employee"]),
        history: json["history"] == null
            ? null
            : List<History>.from(
                json["history"].map((x) => History.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "employee": employee == null ? null : employee!.toMap(),
        "history": history == null
            ? null
            : List<dynamic>.from(history!.map((x) => x.toMap())),
      };
}

class Employee {
  Employee({
    this.employer,
    this.jobTitle,
    required this.gid,
  });

  String? employer;
  String? jobTitle;
  int gid;

  factory Employee.fromMap(Map<String, dynamic> json) => Employee(
        employer: json["employer"] == null ? null : json["employer"],
        jobTitle: json["jobTitle"],
        gid: json["gid"] == null ? null : json["gid"],
      );

  Map<String, dynamic> toMap() => {
        "employer": employer == null ? null : employer,
        "jobTitle": jobTitle,
        "gid": gid == null ? null : gid,
      };
}

class History {
  History({
    this.employer,
    this.jobTitle,
    this.gid,
  });

  String? employer;
  String? jobTitle;
  String? gid;

  factory History.fromMap(Map<String, dynamic> json) => History(
        employer: json["employer"] == null ? null : json["employer"],
        jobTitle: json["jobTitle"] == null ? null : json["jobTitle"],
        gid: json["gid"] == null ? null : json["gid"],
      );

  Map<String, dynamic> toMap() => {
        "employer": employer == null ? null : employer,
        "jobTitle": jobTitle == null ? null : jobTitle,
        "gid": gid == null ? null : gid,
      };
}
