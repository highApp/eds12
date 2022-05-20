import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../Color.dart';

class CommentDlete extends StatefulWidget {
  late VoidCallback onConfirm;
  late VoidCallback onCancel;
  CommentDlete({required this.onConfirm, required this.onCancel});
  @override
  _CommentDleteState createState() => _CommentDleteState();
}

class _CommentDleteState extends State<CommentDlete> {
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
    return Stack(children: <Widget>[
      Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
            SizedBox(
              height: size.height * 0.02,
            ),
            Image.asset(
              "assets/images/delet.png",
              height: size.height * 0.09,
            ),
            SizedBox(
              height: size.height * 0.01,
            ),
            Text(
              'Dismiss',
              style: TextStyle(
                  color: colorText, fontWeight: FontWeight.w800, fontSize: 22),
              textAlign: TextAlign.justify,
            ),
            SizedBox(
              height: size.height * 0.01,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Do you wish to delete this comment?',
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: size.height * 0.02,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                      widget.onConfirm();
                    },
                    color: colorPrimary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Text(
                      "Yes",
                      style: TextStyle(
                          color: colorWhite,
                          fontSize: size.width * 0.04,
                          fontWeight: FontWeight.w600),
                    )),
                // ignore: deprecated_member_use
                FlatButton(
                    onPressed: () {
                      widget.onCancel();
                    },
                    color: colorgre,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Text(
                      "No",
                      style: TextStyle(
                          color: colorWhite,
                          fontSize: size.width * 0.04,
                          fontWeight: FontWeight.w600),
                    )),
              ],
            ),
          ]))
    ]);
  }
}
