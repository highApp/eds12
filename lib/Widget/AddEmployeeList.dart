import 'package:eds/LoginToEmployeer/Screeen/DismissDialog.dart';
import 'package:eds/LoginToEmployeer/Screeen/EmployeeView.dart';
import 'package:eds/LoginToEmployeer/Screeen/FlagView.dart';
import 'package:eds/LoginToEmployeer/Screeen/NewEmployee.dart';
import 'package:eds/LoginToEmployeer/Screeen/PayRollView.dart';
import 'package:eds/models/homeDashboardObject.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Color.dart';

class AddEmployee extends StatefulWidget {
  List<Users> user;
  VoidCallback editDone;

  AddEmployee({
    required this.user,
    required this.editDone,
  });

  @override
  _AddEmployeeState createState() => _AddEmployeeState();
}

class _AddEmployeeState extends State<AddEmployee> {
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
              itemCount: widget.user.length == null ? 0 : widget.user.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  padding: EdgeInsets.only(
                      bottom: size.width * 0.015, top: size.width * 0.01),
                  decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            color: widget.user.last == widget.user[index]
                                ? Colors.transparent
                                : Colors.grey,
                            style: BorderStyle.solid)),
                  ),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: size.width * 0.005,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context)
                                    .push(MaterialPageRoute(
                                        builder: (context) => NewEmployee(
                                              users: widget.user[index],
                                              isEdit: true,
                                            )))
                                    .then((value) => widget.editDone());
                              },
                              child: _employeeDetail(
                                widget.user[index].name,
                                size,
                              ),
                            ),
                          ],
                        ),

                        Row(
                          children: [
                            SizedBox(
                              width: size.width * 0.09,
                            ),
                            _employeeDetail(widget.user[index].jobTitle,size),
                          ],
                        ),

                        Row(
                          children: [
                            SizedBox(
                              width: size.width * 0.08,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => PayRollView(
                                        gid: widget.user[index].gid)));
                              },
                              child: Image.asset(
                                "assets/images/dollar.png",
                                height: size.width * 0.047,
                                width: size.width * 0.047,
                              ),
                            ),
                          ],
                        ),

                        Row(
                          children: [
                            SizedBox(
                              width: size.width * 0.09,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        FlagView(id: widget.user[index].gid)));
                              },
                              child: Icon(
                                Icons.flag_outlined,
                                color: colorgre,
                                size: size.width * 0.06,
                              ),
                            ),
                          ],
                        ),

                        Row(
                          children: [
                            SizedBox(
                              width: size.width * 0.05,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => EmployeeView(
                                          singleUser: widget.user[index],
                                        )));
                              },
                              child: Icon(
                                Icons.remove_red_eye_outlined,
                                color: colorPrimary,
                                size: size.width * 0.05,
                              ),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return DismissDialog(
                                      gid: widget.user[index].gid);
                                });
                          },
                          child: Image.asset(
                            "assets/images/del.png",
                            fit: BoxFit.contain,
                            height: size.width * 0.042,
                            width: size.width * 0.04,
                          ),
                        ),
                        // SizedBox(
                        //   width: size.width * 0.0001,
                        // )
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
      width: size.width * 0.12,
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
