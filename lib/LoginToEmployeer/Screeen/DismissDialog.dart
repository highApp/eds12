import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../Color.dart';
import 'Dismiss.dart';

class DismissDialog extends StatefulWidget {
  String gid;
  DismissDialog({
    required this.gid,
  });
  @override
  _DismissDialogState createState() => _DismissDialogState();
}

class _DismissDialogState extends State<DismissDialog> {
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
                  color: colorText, fontWeight: FontWeight.w800, fontSize: 22),
              textAlign: TextAlign.justify,
            ),
            SizedBox(
              height: size.height * 0.01,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Do you wish to dismiss this employee?',
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
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return SingleChildScrollView(
                            child: Dismiss(
                              gid: widget.gid,
                            ),
                          );
                        },
                      );
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
                      Navigator.pop(context);
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
