import 'dart:convert';
import 'dart:developer';

import 'package:eds/Login_As_Employee/Screen/contactEmployeer.dart';
import 'package:eds/managers/api_manager.dart';
import 'package:eds/models/Employee/AttendenceObject.dart';
import 'package:eds/utilities/api_constants.dart';
import 'package:eds/utilities/customloader.dart';
import 'package:eds/utilities/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';

import '../Color.dart';

class Clock_In extends StatefulWidget {
  String gid;
  Clock_In({required this.gid});
  @override
  _Clock_InState createState() => _Clock_InState();
}

class _Clock_InState extends State<Clock_In> {
  DateFormat ourFormat = DateFormat('dd-MM-yyyy');
  @override
  void initState() {
    super.initState();
    attendenceDate = ourFormat.format(DateTime.now());
    currentTime = ourFormat.format(DateTime.now());
    SchedulerBinding.instance!.addPostFrameCallback((_) {
      _callAPIGetAttence(context: context);
    });
  }

  bool isLoading = false;
  AttendenceObject? attendenceObject;
  Attendence? attendence;
  String attendenceDate = "";
  String showTime = "";
  String? prefsStartTime = "";
  String? prefsStopTime = "";
  String currentTime = "";

  _callAPIAttence({
    required BuildContext context,
    required String time,
    bool isStartTime = false,
  }) {
    this.setState(() {
      isLoading = true;
    });

    Map<String, dynamic> body = Map<String, dynamic>();

    body['gid'] = widget.gid;
    body['date'] = attendenceDate;
    if (attendence?.stop == null && isStartTime == true) {
      body['start'] = time;
    }

    if (attendence?.start != null && isStartTime != true) {
      body['stop'] = time;
    }

    Map<String, String> header = Map<String, String>();

    FocusScope.of(context).requestFocus(FocusNode());
    log(jsonEncode(body));

    ApiManager networkCal =
        ApiManager(APIConstants.employeeAttendance, body, false, header);

    networkCal.callPostAPI(context).then((response) {
      print('Back from api');

      this.setState(() {
        isLoading = false;
      });

      bool status = response['status'];
      if (status == true) {
        attendenceObject = AttendenceObject.fromMap(response);
        if (attendenceObject != null) {
          attendence = attendenceObject?.response;

          showTime = attendence?.start == null && attendence?.stop == null
              ? ""
              : attendence!.stop != null
                  ? attendence!.stop.toString()
                  : attendence!.start.toString();
        }
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

  _callAPIGetAttence({
    required BuildContext context,
  }) {
    this.setState(() {
      isLoading = true;
    });

    Map<String, dynamic> body = Map<String, dynamic>();

    body['gid'] = widget.gid;
    body['date'] = currentTime;

    Map<String, String> header = Map<String, String>();

    FocusScope.of(context).requestFocus(FocusNode());
    log(jsonEncode(body));

    ApiManager networkCal =
        ApiManager(APIConstants.getEmployeeAttendance, body, false, header);

    networkCal.callPostAPI(context).then((response) {
      print('Back from api');

      this.setState(() {
        isLoading = false;
      });

      bool status = response['status'];
      if (status == true) {
        attendenceObject = AttendenceObject.fromMap(response);
        if (attendenceObject != null) {
          attendence = attendenceObject?.response;

          showTime = attendence?.start == null && attendence?.stop == null
              ? ""
              : attendence!.stop != null
                  ? attendence!.stop.toString()
                  : attendence!.start.toString();
        }
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
            iconTheme: IconThemeData(color: Colors.black),
            backgroundColor: Colors.white,
            elevation: 0,
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
            child: Column(children: [
              SizedBox(
                height: size.height * 0.07,
              ),
              Image.asset(
                "assets/images/clock.png",
                height: size.height * 0.15,
                width: size.width * 0.15,
              ),
              Text(
                attendence?.start == null && attendence?.stop == null
                    ? ""
                    : attendence!.stop != null
                        ? 'Clock out'
                        : 'Clock In',
                style: TextStyle(
                  letterSpacing: 1,
                  color: colorText,
                  fontWeight: FontWeight.w800,
                  fontSize: size.width * 0.065,
                ),
                textAlign: TextAlign.justify,
              ),
              SizedBox(
                height: size.height * 0.01,
              ),
              Text(
                showTime,
                style: TextStyle(
                    fontSize: size.width * 0.037, fontWeight: FontWeight.w400),
                textAlign: TextAlign.justify,
              ),
              SizedBox(
                height: size.height * 0.06,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MaterialButton(
                    color: Color(0xFFF3F3F3),
                    onPressed: () {

                      String formattedTime =
                          DateFormat.Hms().format(DateTime.now());
                      _callAPIAttence(
                        context: context,
                        time: formattedTime,
                        isStartTime: true,
                      );
                    },
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: size.width * 0.065),
                      child: Row(
                        children: [
                          InkWell(

                            child: Text(
                              'Start',
                              style: TextStyle(
                                color: colorText,
                                fontWeight: FontWeight.w500,
                                fontSize: size.width * 0.037,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: size.width * 0.01,
                  ),
                  MaterialButton(
                    color: Color(0xFFF3F3F3),
                    onPressed: () {
                      if (attendence!.start != null) {
                        String formattedTime =
                            DateFormat.Hms().format(DateTime.now());
                        _callAPIAttence(
                            context: context,
                            time: formattedTime,
                            isStartTime: false);
                      }
                    },
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: size.width * 0.065),
                      child: Row(
                        children: [
                          Text(
                            'Stop',
                            style: TextStyle(
                              color: colorText,
                              fontWeight: FontWeight.w500,
                              fontSize: size.width * 0.037,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: size.height * 0.25),
              Padding(
                padding: EdgeInsets.symmetric(vertical: size.width * 0.01),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 30),
                      alignment: Alignment.center,
                      child: Text(
                        " If you have any questions, please contact admin",
                        style: TextStyle(
                            color: colorTex,
                            fontSize: size.width * 0.037,
                            fontWeight: FontWeight.w300),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.03,
                    ),
                    MaterialButton(
                      color: colorPay,
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                ContactEmployer(gid: widget.gid)));
                      },
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: size.width * 0.034),
                        child: Text(
                          "Contact Us",
                          style: TextStyle(
                              color: colorText,
                              fontSize: size.width * 0.039,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ]),
          )),
    );
  }
}
