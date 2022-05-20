import 'dart:convert';
import 'dart:developer';

import 'package:eds/LoginToEmployeer/Screeen/CommentDelete.dart';
import 'package:eds/LoginToEmployeer/Screeen/EditComment.dart';
import 'package:eds/managers/api_manager.dart';
import 'package:eds/models/commentsObect.dart';
import 'package:eds/utilities/api_constants.dart';
import 'package:eds/utilities/customloader.dart';
import 'package:eds/utilities/helper_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../../Color.dart';
import 'AddComment.dart';

class CommentsView extends StatefulWidget {
  String gid;
  CommentsView({required this.gid});
  @override
  _CommentsViewState createState() => _CommentsViewState();
}

class _CommentsViewState extends State<CommentsView> {
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

  _callAPIDeleteComment({required BuildContext context, required int cid}) {
    this.setState(() {
      isLoading = true;
    });

    Map<String, dynamic> body = Map<String, dynamic>();

    body['cid'] = cid;

    Map<String, String> header = Map<String, String>();

    FocusScope.of(context).requestFocus(FocusNode());

    ApiManager networkCal =
        ApiManager(APIConstants.deleteComment, body, false, header);

    networkCal.callPostAPI(context).then((response) {
      log(jsonEncode(response));
      print('Back from api');

      this.setState(() {
        isLoading = false;
      });

      bool status = response['status'];
      if (status == true) {
        print("Deleting commnet");

        setState(() {
          comments.removeWhere((element) => element.id == cid);
        });
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
          actions: [
            IconButton(
              icon: Icon(
                Icons.add_circle_outline_outlined,
                size: size.width * 0.065,
                color: colorgrey,
              ),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AddComments(
                        gid: widget.gid,
                        onAddCommentSuccess: () {
                          _callAPIGetComments(context);
                        },
                      );
                    });
              },
            )
          ],
        ),
        body: comments.length == 0
            ? Center(child: Text("No Comments Found"))
            : ListView.builder(
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
                        borderRadius: BorderRadius.circular(size.width * 0.04)),
                    child: Padding(
                      padding: EdgeInsets.all(size.width * 0.035),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: size.height * 0.01,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                Row(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return EditComments(
                                                  comment: comments[index],
                                                  onAddCommentSuccess: () {
                                                    _callAPIGetComments(
                                                        context);
                                                  });
                                            });
                                      },
                                      child: Image.asset(
                                        "assets/images/edit.png",
                                        width: size.width * 0.045,
                                        height: size.width * 0.045,
                                      ),
                                    ),
                                    SizedBox(
                                      width: size.width * 0.04,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return CommentDlete(
                                                onConfirm: () {
                                                  _callAPIDeleteComment(
                                                      context: context,
                                                      cid: comments[index].id);
                                                },
                                                onCancel: () {
                                                  Navigator.pop(context);
                                                },
                                              );
                                            });
                                      },
                                      child: Image.asset(
                                        "assets/images/delete.png",
                                        width: size.width * 0.045,
                                        height: size.width * 0.045,
                                      ),
                                    ),
                                  ],
                                )
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
    );
  }
}
