import 'dart:convert';
import 'dart:developer';

import 'package:eds/Login_As_Employee/Screen/EmployeeProfile.dart';
import 'package:eds/Widget/EmployeHomeList.dart';
import 'package:eds/Widget/EmplyeeHome.dart';
import 'package:eds/managers/api_manager.dart';
import 'package:eds/models/Employee/EmployeeHomeObject.dart';
import 'package:eds/utilities/api_constants.dart';
import 'package:eds/utilities/customloader.dart';
import 'package:eds/utilities/helper_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../../Color.dart';

class HomePage extends StatefulWidget {
  String? gid;
  String? employeeName;
  String? employeeImage;
  HomePage({required this.gid, this.employeeImage, this.employeeName});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    print("printing GID " + widget.gid.toString());
    SchedulerBinding.instance!.addPostFrameCallback((_) {
      _callAPIEmployeHome(context);
    });
  }

  EmployeeHomeObject? employeeHomeObject;
  EmployerObject? employeObject;
  List<History>? newArray = [];

  _callAPIEmployeHome(BuildContext context) {
    this.setState(() {
      isLoading = true;
    });

    Map<String, dynamic> body = Map<String, dynamic>();

    body['gid'] = widget.gid;

    Map<String, String> header = Map<String, String>();

    FocusScope.of(context).requestFocus(FocusNode());
    log(jsonEncode(body));

    ApiManager networkCal =
        ApiManager(APIConstants.employeeHome, body, false, header);

    networkCal.callPostAPI(context).then((response) {
      // log(jsonEncode(response));
      print('Back from api');

      this.setState(() {
        isLoading = false;
      });

      bool status = response['status'];
      if (status == true) {
        employeeHomeObject = EmployeeHomeObject.fromMap(response);

        employeObject = employeeHomeObject?.response;
        newArray = employeObject!.history;
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

  onItemChanged(String value) {
    setState(() {
      print("change called");
      if (employeObject!.history != null) {
        employeObject!.history = employeObject?.history!
            .where((select) =>
                select.employer!.toLowerCase().startsWith(value.toLowerCase()))
            .toList();
      }
    });
  }

  bool isEmpty = false;
  void showHide() {
    if (employeObject!.history != null) {
      if (employeObject!.history!.isEmpty) {
        setState(() {
          isEmpty = true;
        });
      } else {
        setState(() {
          isEmpty = false;
        });
      }
    } else {
      setState(() {
        setState(() {
          isEmpty = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return CustomLoader(
      isLoading: isLoading,
      child: Scaffold(
          body: SingleChildScrollView(
        child: Stack(
          children: [
            Image.asset(
              "assets/images/home.png",
              width: size.width,
              fit: BoxFit.cover,
            ),
            Positioned(
              top: size.height * 0.07,
              child: Row(
                children: [
                  SizedBox(
                    width: size.width * 0.03,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => EmployeeProfileScreen(
                                employeeGid: widget.gid,
                              )));
                    },
                    child: Container(
                      padding: EdgeInsets.all(size.width * 0.005),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.circular(size.width * 0.06)),
                      child: CircleAvatar(
                        maxRadius: size.width * 0.05,
                        backgroundColor: Colors.black,
                        foregroundImage: NetworkImage(widget.employeeImage ==
                                null
                            ? "https://cdn.pixabay.com/photo/2015/03/04/22/35/head-659652_1280.png"
                            : widget.employeeImage.toString()),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: size.width * 0.03,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Welcome",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: size.width * 0.034,
                            fontWeight: FontWeight.w400),
                      ),
                      Text(
                        "Hi, " + widget.employeeName.toString(),
                        style: TextStyle(
                          letterSpacing: 0.5,
                          color: Colors.white,
                          fontSize: size.width * 0.05,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: size.height * 0.18,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.03),
                  child: Material(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.white,
                    elevation: 5,
                    child: TextField(
                      cursorColor: colorPrimary,
                      decoration: InputDecoration(
                        hintText: "Search",
                        hintStyle: TextStyle(
                            color: colorgre,
                            fontWeight: FontWeight.w500,
                            fontSize: size.width * 0.037),
                        prefixIcon: Icon(
                          Icons.search,
                          color: colorgre,
                          size: size.width * 0.055,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          vertical: size.width * 0.04,
                        ),
                      ),
                      onChanged: (value) {
                        if (value == null || value == "") {
                          print(value);
                          print(newArray?.length);
                          setState(() {
                            employeObject?.history = newArray;
                          });
                          showHide();
                        } else {
                          employeObject?.history = newArray;
                          onItemChanged(value);
                          showHide();
                        }
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height * 0.03,
                ),
                employeObject?.employee == null
                    ? Center(child: Text("Currently Not Working"))
                    : EmployeeHome(
                        employee: employeObject?.employee,
                      ),
                SizedBox(
                  height: size.height * 0.03,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.06,
                      vertical: size.height * 0.01),
                  child: Text(
                    "Employment History",
                    style: TextStyle(
                      color: colorText,
                      fontSize: size.width * 0.039,
                      letterSpacing: 0.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                isEmpty
                    ? Center(
                        child: Text("Nothing Matches the Search"),
                      )
                    : EmployeeHomeList(
                        employerObject: employeObject,
                      )
              ],
            )
          ],
        ),
      )),
    );
  }
}
