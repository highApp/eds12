import 'package:eds/LoginToEmployeer/Screeen/Comments_View.dart';

import 'package:eds/LoginToEmployeer/Screeen/DismissDialog.dart';
import 'package:eds/LoginToEmployeer/Screeen/DocumentsView.dart';
import 'package:eds/LoginToEmployeer/Screeen/FlagView.dart';
import 'package:eds/LoginToEmployeer/Screeen/PayRollView.dart';
import 'package:eds/managers/api_manager.dart';
import 'package:eds/models/homeDashboardObject.dart';
import 'package:eds/utilities/api_constants.dart';
import 'package:eds/utilities/customloader.dart';
import 'package:eds/utilities/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Color.dart';

class EmployeeView extends StatefulWidget {
  Users? singleUser;
  EmployeeView({Key? key, required this.singleUser}) : super(key: key);

  @override
  _EmployeeViewState createState() => _EmployeeViewState();
}

class _EmployeeViewState extends State<EmployeeView> {
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance!.addPostFrameCallback((_) {
      _callAPIEmploeeyPdf(context);
    });
  }

  _openPDF(String fileName) async {
    String url = fileName;
    print(url);
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Can not open $url';
    }
  }

  bool isLoading = false;
  String? emlpoyeePdf;
  _callAPIEmploeeyPdf(BuildContext context) {
    this.setState(() {
      isLoading = true;
    });

    Map<String, dynamic> body = Map<String, dynamic>();

    body['gid'] = widget.singleUser?.gid;

    Map<String, String> header = Map<String, String>();

    FocusScope.of(context).requestFocus(FocusNode());

    ApiManager networkCal =
        ApiManager(APIConstants.getEmployeePDF, body, false, header);

    networkCal.callPostAPI(context).then((response) {
      // log(jsonEncode(response));
      print('Back from api');

      this.setState(() {
        isLoading = false;
      });

      bool status = response['status'];
      if (status == true) {
        emlpoyeePdf = response['filename'];
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
          backgroundColor: Colors.transparent,
          title: Text(
            "Employee View",
            style: TextStyle(color: Colors.black, fontSize: size.width * 0.047),
          ),
        ),
        body: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(size.width * 0.05),
                color: Color(0xFFFBF9F9),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.06,
                    vertical: size.height * 0.01),
                child: Column(
                  children: [
                    SizedBox(
                      height: size.height * 0.04,
                    ),
                    Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CircleAvatar(
                          maxRadius: size.width * 0.07,
                          backgroundColor: colorBlack,
                          backgroundImage:
                              NetworkImage(widget.singleUser!.image.toString()),
                        ),
                        SizedBox(
                          width: size.height * 0.02,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.singleUser?.name == null
                                    ? ""
                                    : widget.singleUser!.name.toString(),
                                style: TextStyle(
                                    letterSpacing: 1,
                                    color: Colors.black,
                                    fontSize: size.width * 0.041,
                                    fontWeight: FontWeight.w500),
                              ),
                              SizedBox(
                                height: size.height * 0.01,
                              ),
                              Text(
                                widget.singleUser?.jobTitle == null
                                    ? " "
                                    : widget.singleUser!.jobTitle.toString(),
                                style: TextStyle(
                                    color: Colors.black.withOpacity(0.6),
                                    fontSize: size.width * 0.031,
                                    fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            _openPDF(emlpoyeePdf!);
                          },
                          child: Image.asset(
                            "assets/images/view.png",
                            height: size.height * 0.05,
                            width: size.width * 0.05,
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: size.height * 0.02,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Address:",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: size.width * 0.039,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              widget.singleUser?.address == null
                                  ? ""
                                  : widget.singleUser!.address.toString(),
                              style: TextStyle(
                                color: Colors.black.withOpacity(0.6),
                                fontSize: size.width * 0.039,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: size.height * 0.025,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Contact No:",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: size.width * 0.039,
                              fontWeight: FontWeight.w600),
                        ),
                        Text(
                          widget.singleUser?.phone == null
                              ? ""
                              : widget.singleUser!.phone.toString(),
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.6),
                            fontSize: size.width * 0.039,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: size.height * 0.025,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "ID/Passport No:",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: size.width * 0.039,
                              fontWeight: FontWeight.w600),
                        ),
                        Text(
                          widget.singleUser?.cnic == null
                              ? ""
                              : widget.singleUser!.cnic.toString(),
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.6),
                            fontSize: size.width * 0.039,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: size.height * 0.025,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Previous Employer:",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: size.width * 0.039,
                              fontWeight: FontWeight.w600),
                        ),
                        Text(
                          widget.singleUser!.oldEmployer == null
                              ? ""
                              : widget.singleUser!.oldEmployer,
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.6),
                            fontSize: size.width * 0.039,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: size.height * 0.02,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Previous Employer\nContact No:",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: size.width * 0.039,
                              fontWeight: FontWeight.w600),
                        ),
                        Text(
                          widget.singleUser?.oldEmployer == null
                              ? ""
                              : widget.singleUser!.oldEmployerPhone,
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.6),
                            fontSize: size.width * 0.039,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: size.height * 0.03,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Color(0xFFFBF9F9)),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: size.height * 0.01,
                            horizontal: size.width * 0.04),
                        child: Column(
                          children: [
                            _textInput(
                              text: "Documents",
                              image: "assets/images/left.png",
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => DocumentsView(
                                            gid: widget.singleUser!.gid,
                                          )),
                                );
                              },
                            ),
                            _textInput(
                              text: "Payroll",
                              image: "assets/images/left.png",
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PayRollView(
                                            gid: widget.singleUser!.gid,
                                          )),
                                );
                              },
                            ),
                            _textInput(
                              text: "General Comments",
                              image: "assets/images/left.png",
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CommentsView(
                                            gid: widget.singleUser!.gid,
                                          )),
                                );
                              },
                            ),
                            _textInput(
                              text: "Flag",
                              image: "assets/images/left.png",
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => FlagView(
                                            id: widget.singleUser!.gid,
                                          )),
                                );
                              },
                            ),
                            _textInput(
                              text: "Dismiss",
                              image: "assets/images/left.png",
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return DismissDialog(
                                        gid: widget.singleUser!.gid,
                                      );
                                    });
                              },
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
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
            color: Colors.grey.withOpacity(0.5),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: size.height * 0.015),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  text == null ? "" : text,
                  style: TextStyle(
                    fontSize: size.width * 0.040,
                    fontWeight: FontWeight.w800,
                    color: Colors.black,
                  ),
                ),
                Image.asset(
                  image ?? "",
                  height: size.width * 0.05,
                  width: size.width * 0.05,
                  color: Colors.grey,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
