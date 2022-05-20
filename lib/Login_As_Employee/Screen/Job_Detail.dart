import 'package:eds/Login_As_Employee/Screen/EmployeeDocumentsView.dart';
import 'package:eds/Login_As_Employee/Screen/contactEmployeer.dart';
import 'package:eds/Widget/ClockIN.dart';
import 'package:eds/models/Employee/EmployeeHomeObject.dart';
import 'package:eds/utilities/helper_functions.dart';
import 'package:flutter/material.dart';

import '../../Color.dart';
import 'Comments.dart';
import 'Dismiss.dart';
import 'Flag.dart';
import 'PayRoll.dart';

class JobDetail extends StatefulWidget {
  Employee? employeeData;
  History? history;
  bool isHistory;

  JobDetail({this.employeeData, this.history, this.isHistory = false});

  @override
  _JobDetailState createState() => _JobDetailState();
}

class _JobDetailState extends State<JobDetail> {
  String? emplyeeImage;
  @override
  void initState() {
    super.initState();
    HelperFunctions.getFromPreference("employeeImage").then((value) {
      setState(() {
        emplyeeImage = value;
      });

      print("emplyeeImage" + emplyeeImage!);
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: colorWhite,
      appBar: AppBar(
        backgroundColor: colorWhite,
        centerTitle: false,
        title: Text(
          "Job Details",
          style: TextStyle(
              color: colorText,
              fontSize: size.width * 0.043,
              fontWeight: FontWeight.w700),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.keyboard_backspace_outlined,
            size: size.width * 0.065,
            color: colorText,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: size.height * 0.025,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.045),
              child: Material(
                elevation: 5,
                color: colorWhite,
                borderRadius: BorderRadius.circular(10),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    children: [
                      SizedBox(
                        height: size.width * 0.04,
                      ),
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(size.width * 0.005),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.circular(size.width * 0.06)),
                            child: CircleAvatar(
                              maxRadius: size.width * 0.05,
                              backgroundColor: Colors.black,
                              foregroundImage: NetworkImage(emplyeeImage != null
                                  ? emplyeeImage.toString()
                                  : "https://cdn.pixabay.com/photo/2015/03/04/22/35/head-659652_1280.png"),
                            ),
                          ),
                          SizedBox(
                            width: size.width * 0.03,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "You are an employee at",
                                style: TextStyle(
                                    color: colorgre,
                                    fontSize: size.width * 0.03,
                                    fontWeight: FontWeight.w500),
                              ),
                              SizedBox(height: size.width * 0.015),
                              Text(
                                widget.isHistory
                                    ? widget.history!.employer.toString()
                                    : widget.employeeData!.employer.toString(),
                                style: TextStyle(
                                    color: colorText,
                                    letterSpacing: 0.5,
                                    fontSize: size.width * 0.041,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: size.height * 0.01,
                      ),
                      Divider(
                        color: Colors.grey,
                      ),
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Clock_In(
                                      gid: widget.employeeData?.gid.toString()??'',
                                    )),
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Job title",
                              style: TextStyle(
                                color: colorText,
                                fontSize: size.width * 0.039,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              widget.isHistory == true
                                  ? widget.history!.jobTitle == null
                                      ? ""
                                      : widget.history!.jobTitle.toString()
                                  : widget.employeeData!.jobTitle == null
                                      ? ""
                                      : widget.employeeData!.jobTitle
                                          .toString(),
                              style: TextStyle(
                                  color: colorTex,
                                  fontSize: size.width * 0.033,
                                  letterSpacing: 0,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      _textInput(
                        text: "Documents",
                        image: "assets/images/left.png",
                        onTap: () {

                          widget.isHistory == true
                              ? Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => EmployeeDocumentsView(
                                      gid:
                                          widget.employeeData?.gid.toString())))
                              : Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => EmployeeDocumentsView(
                                      gid: widget.employeeData?.gid
                                          .toString())));
                        },
                      ),
                      _textInput(
                        text: "Payroll",
                        image: "assets/images/left.png",
                        onTap: () {
                          widget.isHistory == false
                              ? Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PayRoll(
                                            gid: widget.employeeData?.gid
                                                .toString(),
                                          )),
                                )
                              : Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PayRoll(
                                            gid: widget.history?.gid.toString(),
                                          )),
                                );
                        },
                      ),
                      _textInput(
                        text: "General Comments",
                        image: "assets/images/left.png",
                        onTap: () {
                          widget.isHistory == false
                              ? Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Comments(
                                            gid: widget.employeeData?.gid
                                                .toString(),
                                          )),
                                )
                              : Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Comments(
                                            gid: widget.history?.gid.toString(),
                                          )),
                                );
                        },
                      ),
                      _textInput(
                        text: "Flag",
                        image: "assets/images/left.png",
                        onTap: () {
                          widget.isHistory == false
                              ? Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Flag(
                                            id: widget.employeeData?.gid
                                                .toString(),
                                          )),
                                )
                              : Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Flag(
                                            id: widget.history?.gid.toString(),
                                          )),
                                );
                        },
                      ),
                      // _textInput(
                      //   text: "Dismiss",
                      //   image: "assets/images/left.png",
                      //   onTap: () {
                      //     widget.isHistory == false
                      //         ? Navigator.push(
                      //             context,
                      //             MaterialPageRoute(
                      //                 builder: (context) => Dismiss(
                      //                     id: widget.employeeData?.gid
                      //                         .toString())),
                      //           )
                      //         : Navigator.push(
                      //             context,
                      //             MaterialPageRoute(
                      //                 builder: (context) => Dismiss(
                      //                       id: widget.history?.gid.toString(),
                      //                     )),
                      //           );
                      //   },
                      // ),
                      SizedBox(
                        height: size.height * 0.01,
                      )
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: size.height * 0.2,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.08,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "If you have any questions, please contact admin",
                    style: TextStyle(
                        color: colorBlack,
                        fontSize: size.width * 0.036,
                        fontWeight: FontWeight.w300),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: size.height * 0.01,
                  ),
                  MaterialButton(
                    color: colorPay,
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ContactEmployer(
                                gid: widget.employeeData!.gid.toString(),
                              )));
                    },
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: size.width * 0.023),
                      child: Text(
                        "Contact Us",
                        style: TextStyle(
                            color: colorBlack,
                            fontSize: size.width * 0.037,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _textInput({text, onTap, image}) {
    var size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Divider(
            color: Colors.grey,
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: size.height * 0.015),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  text ?? "",
                  style: TextStyle(
                      color: Colors.black87,
                      fontSize: size.width * 0.039,
                      fontWeight: FontWeight.w500),
                ),
                Image.asset(
                  image ?? "",
                  height: size.width * 0.05,
                  width: size.width * 0.05,
                  color: colorgre,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
