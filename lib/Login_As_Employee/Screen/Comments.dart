import 'dart:convert';
import 'dart:developer';

import 'package:eds/LoginToEmployeer/Screeen/CommentDelete.dart';
import 'package:eds/LoginToEmployeer/Screeen/ContactAdmin.dart';
import 'package:eds/Login_As_Employee/Screen/contactEmployeer.dart';
import 'package:eds/managers/api_manager.dart';
import 'package:eds/models/commentsObect.dart';
import 'package:eds/utilities/api_constants.dart';
import 'package:eds/utilities/customloader.dart';
import 'package:eds/utilities/helper_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../../Color.dart';

class Comments extends StatefulWidget {
  String? gid;
  Comments({required this.gid});
  @override
  _CommentsState createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance!.addPostFrameCallback((_) {
      _callAPIGetComments(context);
    });
  }

  bool isLoading = false;

  late CommentsObject commentsObject;
  late List<Comment> comments = [];

  _callAPIGetComments(BuildContext context) {
    this.setState(() {
      isLoading = true;
    });

    Map<String, dynamic> body = Map<String, dynamic>();

    body['gid'] = widget.gid;

    Map<String, String> header = Map<String, String>();

    FocusScope.of(context).requestFocus(FocusNode());

    ApiManager networkCal =
        ApiManager(APIConstants.getcomment, body, false, header);

    networkCal.callPostAPI(context).then((response) {
      // log(jsonEncode(response));
      print('Back from api');

      this.setState(() {
        isLoading = false;
      });

      bool status = response['status'];
      if (status == true) {
        commentsObject = CommentsObject.fromMap(response);

        comments = commentsObject.response;
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
        key: _scaffoldKey,
        backgroundColor: colorWhite,
        appBar: AppBar(
          backgroundColor: colorWhite,
          centerTitle: false,
          title: Text(
            "Comments",
            style: TextStyle(
                color: colorText, fontSize: 17, fontWeight: FontWeight.w700),
          ),
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
        body: Column(
          children: [
            comments.length == 0
                ? Expanded(child: Center(child: Text("No Comments Found")))
                : Expanded(
                    child: ListView.builder(
                      primary: false,
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: comments == null ? 0 : comments.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: size.width * 0.04,
                              vertical: size.width * 0.04),
                          decoration: BoxDecoration(
                              color: colorPay,
                              borderRadius:
                                  BorderRadius.circular(size.width * 0.04)),
                          child: Padding(
                            padding: EdgeInsets.all(size.width * 0.035),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: size.height * 0.01,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        comments[index].date,
                                        style: TextStyle(
                                          color: colorText,
                                          fontWeight: FontWeight.w500,
                                          fontSize: size.width * 0.037,
                                        ),
                                        textAlign: TextAlign.justify,
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: size.height * 0.01,
                                  ),
                                  Text(
                                    comments[index].comment,
                                    style: TextStyle(
                                      color: colorText,
                                      fontWeight: FontWeight.w400,
                                      fontSize: size.width * 0.034,
                                    ),
                                    textAlign: TextAlign.justify,
                                  ),
                                  SizedBox(
                                    height: size.height * 0.01,
                                  ),
                                ]),
                          ),
                        );
                      },
                    ),
                  ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.08,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "If you have any questions, please contact admin ",
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
