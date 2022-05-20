import 'dart:convert';
import 'dart:developer';

import 'package:eds/Widget/LabelWidget.dart';
import 'package:eds/Widget/btn_widget.dart';
import 'package:eds/managers/api_manager.dart';
import 'package:eds/utilities/api_constants.dart';
import 'package:eds/utilities/customloader.dart';
import 'package:eds/utilities/helper_functions.dart';
import 'package:flutter/material.dart';

import '../../Color.dart';

class ContactEmployer extends StatefulWidget {
  String gid;
  ContactEmployer({required this.gid});

  @override
  _ContactEmployerState createState() => _ContactEmployerState();
}

class _ContactEmployerState extends State<ContactEmployer> {
  final emailController = TextEditingController();
  final subjectController = TextEditingController();
  final msgController = TextEditingController();
  bool isLoading = false;

  _btnActionEditComment(BuildContext context) {
    FocusScope.of(context).requestFocus(new FocusNode());

    if (emailController.text == '') {
      HelperFunctions.showAlert(
          context: context,
          header: "EDS",
          widget: Text("Email is required"),
          btnDoneText: "ok",
          onDone: () {},
          onCancel: () {});
    } else if (subjectController.text == '') {
      HelperFunctions.showAlert(
        context: context,
        header: "EDS",
        widget: Text("Subject is required"),
        btnDoneText: "ok",
        onDone: () {},
        onCancel: () {},
      );
    } else if (msgController.text == '') {
      HelperFunctions.showAlert(
        context: context,
        header: "EDS",
        widget: Text("Message is required"),
        btnDoneText: "ok",
        onDone: () {},
        onCancel: () {},
      );
    } else {
      _callAPIContactEmployer(context);
    }
  }

  _callAPIContactEmployer(BuildContext context) {
    this.setState(() {
      isLoading = true;
    });

    Map<String, dynamic> body = Map<String, dynamic>();

    body['gid'] = widget.gid;
    body['email'] = emailController.text;
    body['message'] = msgController.text;
    body['subject'] = subjectController.text;
    log(jsonEncode(body));

    Map<String, String> header = Map<String, String>();

    FocusScope.of(context).requestFocus(FocusNode());

    ApiManager networkCal =
        ApiManager(APIConstants.contactUs, body, false, header);

    networkCal.callPostAPI(context).then((response) {
      // log(jsonEncode(response));
      print('Back from api');

      this.setState(() {
        isLoading = false;
      });

      bool status = response['status'];

      if (status == true) {
        showDialog(
            barrierDismissible: true,
            barrierColor: Colors.grey.withOpacity(0.5),
            useSafeArea: true,
            context: context,
            builder: (BuildContext context) {
              return Center(
                child: Container(
                    height: MediaQuery.of(context).size.height * 0.3,
                    width: MediaQuery.of(context).size.width * 0.8,
                    decoration: BoxDecoration(
                      color: colorWhite,
                      borderRadius: BorderRadius.circular(
                        MediaQuery.of(context).size.width * 0.045,
                      ),
                    ),
                    child: Center(
                      child: Image(
                          height: MediaQuery.of(context).size.height * 0.3,
                          width: MediaQuery.of(context).size.width * 0.75,
                          image: AssetImage(
                            "assets/images/thankyou.png",
                          )),
                    )),
              );
            });
        emailController.clear();
        subjectController.clear();
        msgController.clear();
      } else {
        HelperFunctions.showAlert(
            context: context,
            header: "EDS",
            widget: Text(response["message"]),
            btnDoneText: "",
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
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: size.height * 0.1,
              ),
              Text(
                "Contact us",
                style: TextStyle(
                  color: colorBlack,
                  fontSize: size.width * 0.067,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: size.height * 0.03,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.045),
                child: Text(
                  " If you have any questions, please contact admin",
                  style: TextStyle(
                      color: colorBlack,
                      fontSize: size.width * 0.034,
                      fontWeight: FontWeight.w300),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: size.height * 0.03,
              ),
              LabelWidget(
                labelText: "Email",
                controller: emailController,
              ),
              LabelWidget(
                labelText: "Subject",
                controller: subjectController,
              ),
              LabelWidget(
                labelText: "Message",
                controller: msgController,
                max: 3,
              ),
              custom_btn(
                onPressed: () {
                  _btnActionEditComment(context);
                },
                text: "Submit",
                textColor: colorWhite,
                backcolor: colorPrimary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
