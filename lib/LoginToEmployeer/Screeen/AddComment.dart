import 'dart:convert';
import 'dart:developer';
import 'dart:ui';

import 'package:eds/Widget/LabelWidget.dart';
import 'package:eds/Widget/btn_widget.dart';
import 'package:eds/managers/api_manager.dart';
import 'package:eds/utilities/api_constants.dart';
import 'package:eds/utilities/customloader.dart';
import 'package:eds/utilities/helper_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../../Color.dart';

class AddComments extends StatefulWidget {
  String gid;
  VoidCallback onAddCommentSuccess;
  AddComments({required this.gid, required this.onAddCommentSuccess});
  @override
  _AddCommentsState createState() => _AddCommentsState();
}

class _AddCommentsState extends State<AddComments> {
  late DateTime dateTime;
  late Duration duration;

  final txtDateController = TextEditingController();
  final txtCommentsController = TextEditingController();
  DateFormat ourFormat = DateFormat('dd-MM-yyyy');

  bool isLoading = false;
  _btnActionAddComment(BuildContext context) {
    FocusScope.of(context).requestFocus(new FocusNode());
    if (txtDateController.text == '') {
      HelperFunctions.showAlert(
          context: context,
          header: "EDS",
          widget: Text("Date is required"),
          btnDoneText: "ok",
          onDone: () {},
          onCancel: () {});
    } else if (txtDateController.text == '') {
      HelperFunctions.showAlert(
        context: context,
        header: "EDS",
        widget: Text("Comment is required"),
        btnDoneText: "ok",
        onDone: () {},
        onCancel: () {},
      );
    } else {
      _callAPIAddComments(context);
    }
  }

  _callAPIAddComments(BuildContext context) {
    this.setState(() {
      isLoading = true;
    });

    Map<String, dynamic> body = Map<String, dynamic>();

    body['gid'] = widget.gid;
    body['date'] = txtDateController.text;
    body['comment'] = txtCommentsController.text;
    log(jsonEncode(body));

    Map<String, String> header = Map<String, String>();

    FocusScope.of(context).requestFocus(FocusNode());

    ApiManager networkCal =
        ApiManager(APIConstants.addComment, body, false, header);

    networkCal.callPostAPI(context).then((response) {
      // log(jsonEncode(response));
      print('Back from api');

      this.setState(() {
        isLoading = false;
      });

      bool status = response['status'];
      Navigator.pop(context);
      if (status == true) {
        widget.onAddCommentSuccess();
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
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  contentBox(context) {
    var size = MediaQuery.of(context).size;
    return CustomLoader(
      isLoading: isLoading,
      child: Stack(children: <Widget>[
        Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
              SizedBox(
                height: size.height * 0.03,
              ),
              Container(
                decoration: BoxDecoration(color: colorComment),
                child: Text(
                  "Add Comments",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                      fontSize: 22),
                  textAlign: TextAlign.center,
                ),
              ),
              GestureDetector(
                onTap: () {
                  showDatePicker(
                    // builder: ,
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2018),
                    lastDate: DateTime(2025),
                    builder: (context, child) {
                      return Theme(
                        data: ThemeData.light().copyWith(
                          colorScheme: ColorScheme.light(primary: colorPrimary),
                          buttonTheme: ButtonThemeData(
                              textTheme: ButtonTextTheme.accent),
                        ), // This will change to light theme.
                        child: child!,
                      );
                    },
                  ).then((date) {
                    if (date != null) {
                      setState(() {
                        txtDateController.text = ourFormat.format(date);
                      });
                    }
                  });
                },
                child: AbsorbPointer(
                  child: LabelWidget(
                    labelText: "Select Date",
                    controller: txtDateController,
                  ),
                ),
              ),
              LabelWidget(
                labelText: "Comments",
                controller: txtCommentsController,
                max: 3,
              ),
              Row(
                children: [
                  Expanded(
                    child: custom_btn(
                      onPressed: () {
                        _btnActionAddComment(context);
                      },
                      text: "Submit",
                      textColor: colorWhite,
                      backcolor: colorPrimary,
                    ),
                  ),
                  Expanded(
                    child: custom_btn(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      text: "Cancel",
                      textColor: colorWhite,
                      backcolor: colorgre,
                    ),
                  ),
                ],
              )
            ]))
      ]),
    );
  }
}
