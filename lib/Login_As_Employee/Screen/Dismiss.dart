import 'dart:convert';
import 'dart:developer';

import 'package:eds/Login_As_Employee/Screen/contactEmployeer.dart';
import 'package:eds/managers/api_manager.dart';
import 'package:eds/models/Employee/getdismissalObject.dart';
import 'package:eds/utilities/api_constants.dart';
import 'package:eds/utilities/customloader.dart';
import 'package:eds/utilities/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Color.dart';

class Dismiss extends StatefulWidget {
  String? id;
  Dismiss({this.id});

  @override
  _DismissState createState() => _DismissState();
}

class _DismissState extends State<Dismiss> {
  bool fired = false;
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance!.addPostFrameCallback((_) {
      _callAPIGetDismissal(context);
    });
  }

  bool contract = false;
  bool Ret = false;
  bool isLoading = false;

  GetDismissalObject? getDismissalObject;
  GetDismissal? dismissal;
  _callAPIGetDismissal(BuildContext context) {
    this.setState(() {
      isLoading = true;
    });

    Map<String, dynamic> body = Map<String, dynamic>();

    body['gid'] = widget.id;

    Map<String, String> header = Map<String, String>();

    FocusScope.of(context).requestFocus(FocusNode());
    log(jsonEncode(body));

    ApiManager networkCal =
        ApiManager(APIConstants.getDismissal, body, false, header);

    networkCal.callPostAPI(context).then((response) {
      // log(jsonEncode(response));
      print('Back from api');

      this.setState(() {
        isLoading = false;
      });

      bool status = response['status'];
      if (status == true) {
        getDismissalObject = GetDismissalObject.fromMap(response);
        if (getDismissalObject != null) {
          dismissal = getDismissalObject!.response;
          if (dismissal?.reason == "contract ended") {
            this.contract = true;
          } else if (dismissal?.reason == "fired") {
            this.fired = true;
          } else if (dismissal?.reason == "Retired") {
            this.Ret = true;
          }
        }
      } else {
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

  DateFormat ourFormat = DateFormat('dd-MM-yyyy');
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
          appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.black),
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(
                Icons.keyboard_backspace_outlined,
                size: size.width * 0.065,
                color: colorText,
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: SafeArea(
              child: Column(children: [
                SizedBox(
                  height: size.height * 0.04,
                ),
                Image.asset(
                  "assets/images/delt.png",
                  height: size.height * 0.09,
                ),
                SizedBox(
                  height: size.height * 0.01,
                ),
                Text(
                  'Dismiss',
                  style: TextStyle(
                      color: colorText,
                      fontWeight: FontWeight.w800,
                      fontSize: size.width * 0.055),
                  textAlign: TextAlign.justify,
                ),
                SizedBox(
                  height: size.height * 0.01,
                ),
                Text(
                  'Reason For Dismissal',
                  style: TextStyle(fontSize: size.width * 0.045),
                  textAlign: TextAlign.justify,
                ),
                SizedBox(
                  height: size.height * 0.04,
                ),
                Row(
                  children: [
                    Checkbox(
                      checkColor: colorWhite,
                      activeColor: colorPrimary,
                      value: this.fired,
                      onChanged: (value) {
                        // setState(() {
                        //   this.fired = value!;
                        // });
                      },
                    ),
                    SizedBox(
                      width: size.width * 0.01,
                    ),
                    Text(
                      'Fired',
                      style: TextStyle(fontSize: size.width * 0.039),
                      textAlign: TextAlign.justify,
                    ),
                  ],
                ),
                Row(
                  children: [
                    Checkbox(
                      checkColor: colorWhite,
                      activeColor: colorPrimary,
                      value: this.contract,
                      onChanged: (value) {
                        // setState(() {
                        //   this.contract = value!;
                        // });
                      },
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      'Contract Ended',
                      style: TextStyle(fontSize: size.width * 0.039),
                      textAlign: TextAlign.justify,
                    ),
                  ],
                ),
                Row(
                  children: [
                    Checkbox(
                      checkColor: colorWhite,
                      activeColor: colorPrimary,
                      value: this.Ret,
                      onChanged: (value) {
                        // setState(() {
                        //   this.Ret = value!;
                        // });
                      },
                    ),
                    SizedBox(
                      width: size.width * 0.01,
                    ),
                    Text(
                      'Retrenched',
                      style: TextStyle(fontSize: size.width * 0.039),
                      textAlign: TextAlign.justify,
                    ),
                  ],
                ),
                SizedBox(
                  height: size.height * 0.04,
                ),
                RichText(
                  text: TextSpan(
                    text: 'Dismissal Date: ',
                    style: TextStyle(
                        fontSize: size.width * 0.041,
                        color: colorText,
                        fontWeight: FontWeight.w800),
                    children: [
                      TextSpan(
                          text: dismissal?.date,
                          style: TextStyle(
                              fontSize: size.width * 0.039,
                              color: Colors.black,
                              fontWeight: FontWeight.w400)),
                    ],
                  ),
                ),
                SizedBox(
                  height: size.height * 0.06,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      'Official Notice',
                      style: TextStyle(fontSize: size.width * 0.043),
                    ),
                    Text(
                      'Other Docs',
                      style: TextStyle(fontSize: size.width * 0.043),
                    ),
                  ],
                ),
                SizedBox(
                  height: size.height * 0.02,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MaterialButton(
                      color: Color(0xFFF3F3F3),
                      onPressed: () {
                        if (dismissal?.notice != null) {
                          _openPDF(dismissal!.notice);
                        }
                      },
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: size.width * 0.03),
                        child: Row(
                          children: <Widget>[
                            Text(
                              'Download',
                              style: TextStyle(
                                  color: colorText,
                                  fontWeight: FontWeight.w500,
                                  fontSize: size.width * 0.039),
                            ),
                            SizedBox(
                              width: size.width * 0.01,
                            ),
                            Icon(Icons.download_outlined)
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
                        if (dismissal?.otherDoc != null) {
                          _openPDF(dismissal!.otherDoc);
                        }
                      },
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: size.width * 0.03),
                        child: Row(
                          children: [
                            Text(
                              'Download',
                              style: TextStyle(
                                  color: colorText,
                                  fontWeight: FontWeight.w500,
                                  fontSize: size.width * 0.039),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Icon(Icons.download_outlined)
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: size.height * 0.05,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.055,
                      vertical: size.width * 0.045),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "If you have any questions, please contact admin",
                        style: TextStyle(
                            color: colorTex,
                            fontSize: size.width * 0.039,
                            fontWeight: FontWeight.w300),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: size.width * 0.03,
                      ),
                      MaterialButton(
                        color: colorPay,
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  ContactEmployer(gid: widget.id.toString())));
                        },
                        child: Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: size.width * 0.03),
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
            ),
          )),
    );
  }
}
