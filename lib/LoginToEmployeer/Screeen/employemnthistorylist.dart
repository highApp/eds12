import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../Color.dart';
import '../../Login_As_Employee/Screen/Flag.dart';
import '../../Login_As_Employee/Screen/Job_Detail.dart';
import '../../Login_As_Employee/Screen/PayRoll.dart';
import '../../models/Employee/EmployeeHomeObject.dart';
import 'employmentjobdetails.dart';

class employementhistorylist extends StatelessWidget {
  EmployerObject? employerObject;
  employementhistorylist({required this.employerObject});

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
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(size.width * 0.05),
                  topLeft: Radius.circular(size.width * 0.05),
                ),
                color: colorbackground.withOpacity(0.15),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                    vertical: size.width * 0.05, horizontal: size.width * 0.03),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _text("Employee", size),
                    _text("Job Title", size),
                    _text("Payroll", size),
                    _text("Flag", size),
                    _text("Action", size),
                  ],
                ),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              // primary: false,
              // scrollDirection: Axis.vertical,
              itemCount: employerObject?.history == null
                  ? 0
                  : employerObject?.history?.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.05,
                  ),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _employeeDetail(
                            employerObject?.history![index].employer, size),
                        SizedBox(
                          width: size.width * 0.08,
                        ),
                        _employeeDetail(
                            employerObject?.history?[index].jobTitle, size),
                        SizedBox(
                          width: size.width * 0.07,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => PayRoll(
                                  gid: employerObject!.history![index].gid,
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
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => Flag(
                                    id: employerObject!.history![index].gid),
                              ),
                            );
                          },
                          child: Icon(
                            Icons.flag_outlined,
                            color: colorgre,
                            size: size.width * 0.06,
                          ),
                        ),
                        SizedBox(
                          width: size.width * 0.06,
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                child: IconButton(
                                    icon: Icon(
                                      Icons.remove_red_eye_outlined,
                                      color: colorPrimary,
                                      size: size.width * 0.05,
                                    ),
                                    onPressed: () {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                          builder: (context) => employmentjobdetails(
                                            history: employerObject!
                                                .history?[index],
                                            isHistory: true,
                                          )));
                                    }),
                              ),
                              // GestureDetector(
                              //   onTap: () {
                              //     // showDialog(
                              //     //     context: context,
                              //     //     builder: (BuildContext context) {
                              //     //       return DismissDialog(
                              //     //           gid: user[index].gid);
                              //     //     });
                              //   },
                              //   child: Expanded(
                              //     child: Image.asset(
                              //       "assets/images/del.png",
                              //       height: size.width * 0.042,
                              //       width: size.width * 0.042,
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                      ]),
                );
              },
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
