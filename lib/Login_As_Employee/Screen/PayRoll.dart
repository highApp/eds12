import 'dart:convert';
import 'dart:developer';
import 'package:eds/Login_As_Employee/Screen/contactEmployeer.dart';
import 'package:eds/managers/api_manager.dart';
import 'package:eds/models/payslipViewObject.dart';
import 'package:eds/utilities/api_constants.dart';
import 'package:eds/utilities/customloader.dart';
import 'package:eds/utilities/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';

import '../../Color.dart';

class PayRoll extends StatefulWidget {
  String? gid;
  PayRoll({this.gid});

  @override
  _PayRollState createState() => _PayRollState();
}

class _PayRollState extends State<PayRoll> {
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance!.addPostFrameCallback((_) {
      _callAPIGetPayRoll(context);
    });
  }

  DateFormat ourFormat = DateFormat('dd-MM-yyyy');
  bool isLoading = false;
  PayrollviewObject? paySlipObject;
  PayRlView? paySlip;

  final txtbankController = TextEditingController();
  final txtsalaryController = TextEditingController();
  final txtpayDayController = TextEditingController();

  _callAPIGetPayRoll(BuildContext context) {
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
        paySlipObject = PayrollviewObject.fromMap(response);
        if (paySlipObject != null) {
          paySlip = paySlipObject!.response;
        }
      } else {
        setState(() {
          isEmpty = true;
        });
        HelperFunctions.showAlert(
          context: context,
          header: "EDS",
          widget: Text(response["message"]),
          btnDoneText: "ok",
          onDone: () {},
          onCancel: () {},
        );
      }
    });
  }

  bool isEmpty = false;

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
        body: ListView(
          shrinkWrap: true,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: size.height * 0.03,
            ),
            PayRollCell(
              prefixText: "Bank Details",
              suffixText: paySlip?.bank,
            ),
            SizedBox(
              height: size.height * 0.02,
            ),
            PayRollCell(
              prefixText: "Salary",
              suffixText: paySlip?.salary,
            ),
            SizedBox(
              height: size.height * 0.02,
            ),
            PayRollCell(
              prefixText: "Paid Via",
              suffixText: paySlip?.payMethod,
            ),
            SizedBox(
              height: size.height * 0.02,
            ),
            PayRollCell(
              prefixText: "Paid",
              suffixText: paySlip?.paid,
            ),
            SizedBox(
              height: size.height * 0.02,
            ),
            PayRollCell(
              prefixText: "Payday",
              suffixText: paySlip?.payDay,
            ),
            SizedBox(
              height: size.height * 0.3,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.08,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    " If you have any questions, please contact admin",
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
                                gid: widget.gid.toString(),
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
}

class PayRollCell extends StatelessWidget {
  String? prefixText;
  String? suffixText;
  PayRollCell({this.prefixText, this.suffixText});
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
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
              prefixText == null ? "" : prefixText.toString(),
              style: TextStyle(
                  color: colorText,
                  fontSize: size.width * 0.03,
                  fontWeight: FontWeight.w600),
            ),
            Text(
              suffixText == null ? "" : suffixText.toString(),
              style: TextStyle(
                  color: colorText,
                  fontSize: size.width * 0.03,
                  fontWeight: FontWeight.w600),
            )
          ],
        ),
      ),
    );
  }
}
