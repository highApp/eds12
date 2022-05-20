import 'dart:convert';
import 'dart:developer';

import 'package:eds/Color.dart';
import 'package:eds/Login_As_Employee/Screen/SignIn.dart';
import 'package:eds/managers/api_manager.dart';
import 'package:eds/models/Employee/EmployeeObject.dart';
import 'package:eds/utilities/api_constants.dart';
import 'package:eds/utilities/customloader.dart';
import 'package:eds/utilities/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';

class EmployeeProfileScreen extends StatefulWidget {
  String? employeeGid;
  EmployeeProfileScreen({required this.employeeGid});

  @override
  _EmployeeProfileScreenState createState() => _EmployeeProfileScreenState();
}

class _EmployeeProfileScreenState extends State<EmployeeProfileScreen> {
  bool isLoading = false;
  EmployeeObject? emplyeeObject;
  EmployeeDetailsObject? employee;
  DateFormat ourFormat = DateFormat('dd-MM-yyyy');
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance!.addPostFrameCallback((_) {
      _callAPIGetEmployee(context);
    });
  }

  _callAPIGetEmployee(BuildContext context) {
    this.setState(() {
      isLoading = true;
    });

    Map<String, dynamic> body = Map<String, dynamic>();

    body['gid'] = widget.employeeGid;

    Map<String, String> header = Map<String, String>();

    FocusScope.of(context).requestFocus(FocusNode());
    log(jsonEncode(body));

    ApiManager networkCal =
        ApiManager(APIConstants.getEmployee, body, false, header);

    networkCal.callPostAPI(context).then((response) {
      print('Back from api');

      this.setState(() {
        isLoading = false;
      });

      bool status = response['status'];
      // log(jsonEncode(response));
      if (status == true) {
        emplyeeObject = EmployeeObject.fromMap(response);
        if (emplyeeObject != null) {
          employee = emplyeeObject!.response;
        }

        // userLogedin = emplyerLogin?.response;
      } else {
        HelperFunctions.showAlert(
            context: context,
            header: "EDS",
            widget: Text(response["message"]),
            btnDoneText: "ok",
            onDone: () {},
            onCancel: () {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return CustomLoader(
      isLoading: isLoading,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: colorPrimary,
          elevation: 0,
        ),
        body: Column(
          children: [
            Container(
              height: size.height * 0.13,
              child: Stack(
                children: [
                  Container(
                    height: size.height * 0.05,
                    width: size.width,
                    decoration: BoxDecoration(
                      color: colorPrimary,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(
                          size.width * 0.065,
                        ),
                        bottomRight: Radius.circular(
                          size.width * 0.065,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: size.height * 0.001,
                    right: size.width * 0.4,
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: colorPrimary, width: size.width * 0.009),
                          borderRadius:
                              BorderRadius.circular(size.width * 0.9)),
                      child: CircleAvatar(
                        maxRadius: size.width * 0.095,
                        backgroundColor: Colors.black,
                        foregroundImage: NetworkImage(
                          employee?.image == "" || employee?.image == null
                              ? "https://cdn.pixabay.com/photo/2015/03/04/22/35/head-659652_1280.png"
                              : employee!.image,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Text(
              employee?.name == null ? "" : employee!.name,
              style: TextStyle(
                color: Colors.black,
                fontSize: size.width * 0.047,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: size.height * 0.005,
            ),
            Text(
              employee?.cnic == null ? " " : employee!.cnic,
              style: TextStyle(
                color: colorgre,
                fontSize: size.width * 0.037,
              ),
            ),
            SizedBox(
              height: size.height * 0.025,
            ),
            Column(
              children: [
                ProfileRows(
                  prefixImage: "assets/images/calender.png",
                  suffixtext:
                      employee?.jobTitle == null ? "" : employee!.jobTitle,
                  title: "Working As:",
                ),
                Divider(
                  color: colorgre,
                  height: size.width * 0.001,
                ),
                ProfileRows(
                  prefixImage: "assets/images/Gender.png",
                  suffixtext:
                      employee?.address == null ? "" : employee!.address,
                  title: "Address:",
                ),
                Divider(
                  color: colorgre,
                  height: size.width * 0.001,
                ),
                ProfileRows(
                  prefixImage: "assets/images/contacts.png",
                  suffixtext: employee?.phone.toString(),
                  title: "Contact No:",
                ),
                Divider(
                  color: colorgre,
                  height: size.width * 0.001,
                ),
              ],
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    "Logout",
                    style: TextStyle(
                      color: Colors.black,
                      letterSpacing: 0.6,
                      fontSize: size.width * 0.04,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        HelperFunctions.saveInPreference("employeeGid", "");
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (context) => SignIn()),
                            (Route<dynamic> route) => false);
                      },
                      icon: Icon(Icons.login_outlined))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileRows extends StatelessWidget {
  String prefixImage;
  String title;
  String? suffixtext;
  ProfileRows(
      {required this.prefixImage,
      required this.title,
      required this.suffixtext});
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Column(
      children: [
        SizedBox(
          height: size.height * 0.025,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.045),
          child: Row(
            children: [
              Image.asset(
                prefixImage,
                width: size.width * 0.065,
                height: size.width * 0.065,
                fit: BoxFit.cover,
              ),
              SizedBox(
                width: size.width * 0.06,
              ),
              Text(
                title == null ? "" : title,
                style: TextStyle(
                  color: Colors.black,
                  letterSpacing: 0.6,
                  fontSize: size.width * 0.04,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                width: size.width * 0.08,
              ),
              Expanded(
                child: Text(
                  suffixtext == null ? "" : suffixtext.toString(),
                  style: TextStyle(
                    color: colorgre,
                    fontSize: size.width * 0.039,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: size.height * 0.025,
        ),
      ],
    );
  }
}
