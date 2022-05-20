import 'package:eds/Login_As_Employee/Screen/Flag.dart';
import 'package:eds/Login_As_Employee/Screen/Job_Detail.dart';
import 'package:eds/Login_As_Employee/Screen/PayRoll.dart';
import 'package:eds/models/Employee/EmployeeHomeObject.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Color.dart';

class EmployeeHome extends StatelessWidget {
  Employee? employee;

  EmployeeHome({this.employee});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Material(
        borderRadius: BorderRadius.circular(20),
        elevation: 5,
        color: Colors.white,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                  vertical: size.width * 0.05, horizontal: size.width * 0.03),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(size.width * 0.05),
                  topLeft: Radius.circular(size.width * 0.05),
                ),
                color: colorbackground.withOpacity(0.15),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _text("Employer", size),
                  _text("Job Title", size),
                  _text("Payroll", size),
                  _text("Flag", size),
                  _text("Action", size),
                ],
              ),
            ),
            Container(
              width: size.width * 0.85,
              child: Row(children: [
                _employeeDetail(employee?.employer, size),
                SizedBox(
                  width: size.width * 0.08,
                ),
                _employeeDetail(employee?.jobTitle, size),
                SizedBox(
                  width: size.width * 0.07,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => PayRoll(
                              gid: employee!.gid.toString(),
                            )));
                  },
                  child: Image.asset(
                    "assets/images/dollar.png",
                    height: size.width * 0.047,
                    width: size.width * 0.047,
                  ),
                ),
                SizedBox(
                  width: size.width * 0.1,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            Flag(id: employee!.gid.toString())));
                  },
                  child: Icon(
                    Icons.flag_outlined,
                    color: colorgre,
                    size: size.width * 0.06,
                  ),
                ),
                SizedBox(
                  width: size.width * 0.085,
                ),
                Expanded(
                  child: IconButton(
                      icon: Icon(
                        Icons.remove_red_eye_outlined,
                        color: colorPrimary,
                        size: size.width * 0.05,
                      ),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => JobDetail(
                                  employeeData: employee,
                                )));
                      }),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _text(text, size) {
    return Text(
      text == null ? "" : text,
      style: TextStyle(
        color: colorText,
        fontSize: size.width * 0.035,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _employeeDetail(text, size) {
    return Container(
      width: size.width * 0.155,
      child: Text(
        text == null ? "" : text,
        maxLines: 2,
        overflow: TextOverflow.visible,
        style: TextStyle(
            color: colorgre,
            fontSize: size.width * 0.035,
            fontWeight: FontWeight.w500),
      ),
    );
  }
}
