import 'dart:convert';
import 'dart:developer';

import 'package:eds/Widget/btn_widget.dart';
import 'package:eds/managers/api_manager.dart';
import 'package:eds/models/payslipViewObject.dart';
import 'package:eds/utilities/api_constants.dart';
import 'package:eds/utilities/customloader.dart';
import 'package:eds/utilities/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Color.dart';

class PayRollView extends StatefulWidget {
  String gid;
  PayRollView({required this.gid});

  @override
  _PayRollViewState createState() => _PayRollViewState();
}

class _PayRollViewState extends State<PayRollView> {
  bool cash = false;
  bool eft = false;
  bool hourly = false;
  bool weekly = false;
  bool month = false;
  bool isLoading = false;
  bool showaddBankField = false;
  late String selectedDate = "";
  DateFormat ourFormat = DateFormat('dd');
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance!.addPostFrameCallback((_) {
      _callAPIPayRollshow(context);
      _callAPIGetPaySlip(context);
      _callAPIGetTimeLog(context);
    });
  }

  final txtbankController = TextEditingController();
  final txtsalaryController = TextEditingController();
  final txtpayDayController = TextEditingController();
  _btnActionPayroll(BuildContext context) {
    FocusScope.of(context).requestFocus(new FocusNode());
    if (txtbankController.text == '') {
      HelperFunctions.showAlert(
          context: context,
          header: "EDS",
          widget: Text("Bank details are required"),
          btnDoneText: "ok",
          onDone: () {},
          onCancel: () {});
    } else if (txtsalaryController.text == '') {
      HelperFunctions.showAlert(
        context: context,
        header: "EDS",
        widget: Text("Salary is required"),
        btnDoneText: "ok",
        onDone: () {},
        onCancel: () {},
      );
    } else if (selectedDate == '') {
      HelperFunctions.showAlert(
        context: context,
        header: "EDS",
        widget: Text("Payday is required"),
        btnDoneText: "ok",
        onDone: () {},
        onCancel: () {},
      );
    } else if (cash == false && eft == false) {
      HelperFunctions.showAlert(
        context: context,
        header: "EDS",
        widget: Text("Paid via option is required"),
        btnDoneText: "ok",
        onDone: () {},
        onCancel: () {},
      );
    } else if (hourly == false && weekly == false && month == false) {
      HelperFunctions.showAlert(
        context: context,
        header: "EDS",
        widget: Text("Select Piad option"),
        btnDoneText: "ok",
        onDone: () {},
        onCancel: () {},
      );
    } else {
      _callAPIPayRollView(context);
    }
  }

  _callAPIPayRollView(BuildContext context) {
    this.setState(() {
      isLoading = true;
    });

    Map<String, dynamic> body = Map<String, dynamic>();

    body['gid'] = widget.gid;
    body['salary'] = txtsalaryController.text;
    body['payDay'] = selectedDate;
    if (this.cash) {
      body['payMethod'] = "cash";
    } else if (this.eft) {
      body['payMethod'] = "eft";
    }

    if (this.hourly) {
      body['paid'] = "hourly";
    } else if (this.weekly) {
      body['paid'] = "weekly";
    } else if (this.month) {
      body['paid'] = "monthly";
    }

    body['bank'] = txtbankController.text;

    Map<String, String> header = Map<String, String>();

    FocusScope.of(context).requestFocus(FocusNode());
    log(jsonEncode(body));

    ApiManager networkCal =
        ApiManager(APIConstants.addPayroll, body, false, header);

    networkCal.callPostAPI(context).then((response) {
      // log(jsonEncode(response));
      print('Back from api');

      this.setState(() {
        isLoading = false;
      });

      bool status = response['status'];
      if (status == true) {
        HelperFunctions.showAlert(
            context: context,
            header: "EDS",
            widget: Text(response["message"]),
            btnDoneText: "ok",
            onDone: () {
              _callAPIPayRollshow(context);
            },
            onCancel: () {});
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

  String paySlip = "";
  String timeLog = "";
  PayrollviewObject? payrollviewObject;
  PayRlView? payRollView;

  _callAPIPayRollshow(BuildContext context) {
    this.setState(() {
      isLoading = true;
    });

    Map<String, dynamic> body = Map<String, dynamic>();

    body['gid'] = widget.gid;

    Map<String, String> header = Map<String, String>();

    FocusScope.of(context).requestFocus(FocusNode());
    log(jsonEncode(body));

    ApiManager networkCal =
        ApiManager(APIConstants.getPayroll, body, false, header);

    networkCal.callPostAPI(context).then((response) {
      // log(jsonEncode(response));
      print('Back from api');

      this.setState(() {
        isLoading = false;
      });

      bool status = response['status'];
      if (status == true) {
        payrollviewObject = PayrollviewObject.fromMap(response);
        if (payrollviewObject != null) {
          payRollView = payrollviewObject!.response;

          setState(() {
            showaddBankField = true;
            txtbankController.text = payRollView!.bank;
            txtsalaryController.text = payRollView!.salary;
            selectedDate = payRollView!.payDay;
            if (payRollView?.paid == "hourly") {
              this.hourly = true;
            } else if (payRollView?.paid == "weekly") {
              this.weekly = true;
            } else if (payRollView?.paid == "monthly") {
              this.month = true;
            }

            if (payRollView?.payMethod == "cash") {
              this.cash = true;
            } else if (payRollView?.payMethod == "eft") {
              this.eft = true;
            }
          });
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

  _callAPIGetPaySlip(BuildContext context) {
    this.setState(() {
      isLoading = true;
    });

    Map<String, dynamic> body = Map<String, dynamic>();

    body['gid'] = widget.gid;

    Map<String, String> header = Map<String, String>();

    FocusScope.of(context).requestFocus(FocusNode());
    log(jsonEncode(body));

    ApiManager networkCal =
        ApiManager(APIConstants.getPaySlip, body, false, header);

    networkCal.callPostAPI(context).then((response) {
      // log(jsonEncode(response));
      print('Back from api');

      this.setState(() {
        isLoading = false;
      });

      bool status = response['status'];
      if (status == true) {
        paySlip = response['filename'];
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

  _callAPIGetTimeLog(BuildContext context) {
    this.setState(() {
      isLoading = true;
    });

    Map<String, dynamic> body = Map<String, dynamic>();
//Todo
    body['gid'] = widget.gid;

    Map<String, String> header = Map<String, String>();

    FocusScope.of(context).requestFocus(FocusNode());
    log(jsonEncode(body));

    ApiManager networkCal =
        ApiManager(APIConstants.getTimeLog, body, false, header);

    networkCal.callPostAPI(context).then((response) {
      // log(jsonEncode(response));
      print('Back from api');

      this.setState(() {
        isLoading = false;
      });

      bool status = response['status'];
      if (status == true) {
        timeLog = response['filename'];
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

  _openPDF(String fileName) async {
    String url = fileName;
    print(url);
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Konnte nicht gestartet werden $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return CustomLoader(
      isLoading: isLoading,
      child: Scaffold(
        backgroundColor: colorWhite,
        appBar: AppBar(
          backgroundColor: colorWhite,
          centerTitle: false,
          title: Text(
            "Payroll",
            style: TextStyle(
                color: colorText,
                fontSize: size.width * 0.04,
                fontWeight: FontWeight.w700),
          ),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.keyboard_backspace_outlined,
              size: size.width * 0.05,
              color: colorText,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: size.height * 0.03,
              ),
              Container(
                margin: EdgeInsets.symmetric(
                  horizontal: size.width * 0.035,
                ),
                decoration: BoxDecoration(
                    color: colorPay,
                    borderRadius: BorderRadius.circular(
                      size.width * 0.02,
                    )),
                child: Padding(
                  padding: EdgeInsets.all(
                    size.height * 0.02,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Download:",
                        style: TextStyle(
                            color: colorText,
                            fontSize: size.width * 0.04,
                            fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      // GestureDetector(
                      //   onTap: () {
                      //     if (timeLog != "") {
                      //       _openPDF(timeLog);
                      //     }
                      //   },
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //     children: [
                      //       Text(
                      //         "Time log:",
                      //         style: TextStyle(
                      //             fontSize: size.width * 0.03,
                      //             fontWeight: FontWeight.w400),
                      //       ),
                      //       Image.asset(
                      //         "assets/images/view.png",
                      //         height: size.height * 0.02,
                      //       )
                      //     ],
                      //   ),
                      // ),
                      // SizedBox(
                      //   height: size.height * 0.02,
                      // ),
                      // Divider(
                      //   color: colorgre,
                      // ),
                      GestureDetector(
                        onTap: () {
                          if (paySlip != "") {
                            _openPDF(paySlip);
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Payslip:",
                              style: TextStyle(
                                  fontSize: size.width * 0.03,
                                  fontWeight: FontWeight.w400),
                            ),
                            Image.asset(
                              "assets/images/view.png",
                              height: size.height * 0.02,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: size.height * 0.02,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: size.width * 0.03),
                decoration: BoxDecoration(
                    color: colorPay,
                    borderRadius: BorderRadius.circular(size.width * 0.02)),
                child: Padding(
                  padding: EdgeInsets.all(size.height * 0.016),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Bank Details:",
                        style: TextStyle(
                            color: colorText,
                            fontSize: size.width * 0.03,
                            fontWeight: FontWeight.w600),
                      ),
                      showaddBankField == false
                          ? MaterialButton(
                              onPressed: () {
                                setState(() {
                                  showaddBankField = !showaddBankField;
                                });
                              },
                              color: colorWhite,
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.comment_bank_outlined,
                                    color: colorText,
                                    size: size.width * 0.035,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    "Add Bank",
                                    style: TextStyle(
                                        color: colorText,
                                        fontSize: size.width * 0.03,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            )
                          : Flexible(
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 20),
                                decoration: BoxDecoration(
                                  color: colorWhite,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: TextField(
                                  controller: txtbankController,
                                  decoration: InputDecoration(
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    hintText: "Bank Details",
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: size.height * 0.02,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: size.width * 0.03),
                decoration: BoxDecoration(
                    color: colorPay,
                    borderRadius: BorderRadius.circular(size.width * 0.02)),
                child: Padding(
                  padding: EdgeInsets.all(size.height * 0.016),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Salary:",
                        style: TextStyle(
                            color: colorText,
                            fontSize: size.width * 0.03,
                            fontWeight: FontWeight.w600),
                      ),
                      Flexible(
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            color: colorWhite,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: TextField(
                            controller: txtsalaryController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 10),
                              hintText: "Please enter employee sallery",
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: size.height * 0.02,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: size.width * 0.03),
                decoration: BoxDecoration(
                    color: colorPay,
                    borderRadius: BorderRadius.circular(size.width * 0.02)),
                child: Padding(
                  padding: EdgeInsets.all(size.height * 0.016),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Payday:",
                        style: TextStyle(
                            color: colorText,
                            fontSize: size.width * 0.03,
                            fontWeight: FontWeight.w600),
                      ),
                      Text(
                        selectedDate,
                        style: TextStyle(
                            color: colorText,
                            fontSize: size.width * 0.037,
                            fontWeight: FontWeight.w600),
                      ),
                      MaterialButton(
                        onPressed: () {
                          showDatePicker(
                            // builder: ,
                            context: context,
                            initialDate: DateTime(2020),
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2025),
                            builder: (context, child) {
                              return Theme(
                                data: ThemeData.light().copyWith(
                                  colorScheme:
                                      ColorScheme.light(primary: colorPrimary),
                                  buttonTheme: ButtonThemeData(
                                      textTheme: ButtonTextTheme.accent),
                                ), // This will change to light theme.
                                child: child!,
                              );
                            },
                          ).then((date) {
                            if (date != null) {
                              setState(() {
                                selectedDate = ourFormat.format(date);
                              });
                            }
                          });
                        },
                        color: colorWhite,
                        child: Row(
                          children: [
                            Icon(
                              Icons.calendar_today,
                              color: colorText,
                              size: size.width * 0.035,
                            ),
                            SizedBox(
                              width: size.width * 0.02,
                            ),
                            Text(
                              "Select Date",
                              style: TextStyle(
                                  color: colorText,
                                  fontSize: size.width * 0.03,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              _text("Paid Via:"),
              Row(
                children: <Widget>[
                  SizedBox(
                    width: 5,
                  ),
                  Checkbox(
                    checkColor: colorWhite,
                    activeColor: colorPrimary,
                    value: this.cash,
                    onChanged: (value) {
                      setState(() {
                        this.cash = value!;
                        this.eft = false;
                      });
                    },
                  ),

                  _textInput(
                    "Cash",
                  ), //T

                  // ext
                  SizedBox(
                    width: 10,
                  ),
                  Checkbox(
                    checkColor: colorWhite,
                    activeColor: colorPrimary,
                    value: this.eft,
                    onChanged: (value) {
                      setState(() {
                        this.eft = value!;
                        this.cash = false;
                      });
                    },
                  ),
                  _textInput(
                    "EFT",
                  ),

                  ///Te
                ],
              ),
              _text(
                "Paid:",
              ),
              Row(
                children: [
                  Checkbox(
                    checkColor: colorWhite,
                    activeColor: colorPrimary,
                    value: this.hourly,
                    onChanged: (value) {
                      setState(() {
                        this.hourly = value!;
                        this.weekly = false;
                        this.month = false;
                      });
                    },
                  ),

                  _textInput(
                    "Hourly",
                  ), //T
                  // ext
                  SizedBox(
                    width: 10,
                  ),

                  Checkbox(
                    checkColor: colorWhite,
                    activeColor: colorPrimary,
                    value: this.weekly,
                    onChanged: (value) {
                      setState(() {
                        this.weekly = value!;
                        this.hourly = false;
                        this.month = false;
                      });
                    },
                  ),
                  _textInput(
                    "Weekly",
                  ),

                  SizedBox(
                    width: 10,
                  ),

                  Checkbox(
                    checkColor: colorWhite,
                    activeColor: colorPrimary,
                    value: this.month,
                    onChanged: (value) {
                      setState(() {
                        this.month = value!;
                        this.weekly = false;
                        this.hourly = false;
                      });
                    },
                  ),

                  _textInput(
                    "Monthly",
                  ),
                ],
              ),
              custom_btn(
                onPressed: () {
                  _btnActionPayroll(context);
                },
                text: "Save",
                textColor: colorWhite,
                backcolor: colorPrimary,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _text(
    text,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 25),
      child: Text(
        text,
        style: TextStyle(
            color: colorText, fontWeight: FontWeight.w600, fontSize: 18),
      ),
    );
  }

  Widget _textInput(text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
      child: Text(
        text,
        style: TextStyle(
            color: colorTex, fontWeight: FontWeight.w600, fontSize: 16),
      ),
    );
  }
}
