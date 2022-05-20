import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:ui';
import 'package:eds/LoginToEmployeer/Screeen/Dashboard.dart';
import 'package:eds/Widget/LabelWidget.dart';
import 'package:eds/models/dismissResponce.dart';
import 'package:eds/utilities/api_constants.dart';
import 'package:eds/utilities/helper_functions.dart';
import 'package:eds/utilities/loadingWidget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../Color.dart';

class Dismiss extends StatefulWidget {
  String gid;
  Dismiss({
    required this.gid,
  });
  @override
  _DismissState createState() => _DismissState();
}

class _DismissState extends State<Dismiss> {
  bool fired = false;
  bool contract = false;
  bool Ret = false;
  bool date = false;
  bool isLoading = false;
  File? _file1;
  File? _file2;
  String firstPath = "";
  String secondPath = "";
  final txtDateController = TextEditingController();
  DateFormat ourFormat = DateFormat('dd-MM-yyyy');

  String? employerid;

  @override
  void initState() {
    super.initState();
    HelperFunctions.getFromPreference("userId")
        .then((value) => employerid = value);
  }

  String reason = "";

  _getPDFDocument({required int fileNumber}) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      if (fileNumber == 1) {
        _file1 = File(result.files.single.path.toString());

        _splitText(imagePath: _file1.toString(), path: "firstPath");
      } else if (fileNumber == 2) {
        _file2 = File(result.files.single.path.toString());
        print(_file2);
        _splitText(imagePath: _file2.toString(), path: "secondPath");
      }
    } else {
      // User canceled the picker
    }
  }

  _splitText({required String imagePath, required String path}) {
    print("Splinting text");
    if (path == "firstPath") {
      print("in first ");
      setState(() {
        firstPath = imagePath.split("/").last.toString();
        print("first path  = " + firstPath);
      });
    } else if (path == "secondPath") {
      setState(() {
        secondPath = imagePath.split("/").last.toString();
      });
    }
  }

  _btnActionDismissal(BuildContext context) {

    FocusScope.of(context).requestFocus(new FocusNode());
    if (this.Ret == false && this.fired == false && this.contract == false) {
      HelperFunctions.showAlert(
          context: context,
          header: "EDS",
          widget: Text("Dismissal reason is required"),
          btnDoneText: "ok",
          onDone: () {},
          onCancel: () {});
    } else if (txtDateController.text == '') {
      HelperFunctions.showAlert(
        context: context,
        header: "EDS",
        widget: Text("Date is required"),
        btnDoneText: "ok",
        onDone: () {},
        onCancel: () {},
      );
    } else if (_file1 == null) {
      HelperFunctions.showAlert(
        context: context,
        header: "EDS",
        widget: Text("Official notice is required"),
        btnDoneText: "ok",
        onDone: () {},
        onCancel: () {},
      );
    } else {
      _DismissApi();
    }
  }

  Future<DismissREsponse?> _DismissApi() async {
    this.setState(() {
      isLoading = true;
      print('hello');

    });
    String apiUrl = APIConstants.baseURL + APIConstants.dismissEmployee;

    print(apiUrl);
    loadingWidget(context);


    // Attach the file in the request
    final file1 =
        await http.MultipartFile.fromPath('notice', _file1!.path.toString());
    var file2;
    if (secondPath != "") {
      file2 = await http.MultipartFile.fromPath(
          'otherDoc', _file2!.path.toString());
    }

    // Intilize the multipart request
    final imageUploadRequest = http.MultipartRequest('POST', Uri.parse(apiUrl));
    print(imageUploadRequest.fields);

    imageUploadRequest.fields['gid'] = widget.gid;

    if (this.fired) {
      reason = "fired";
    } else if (this.Ret) {
      reason = "Retired";
    } else if (this.contract) {
      reason = "contract ended";
    }
    imageUploadRequest.fields['reason'] = reason;
    imageUploadRequest.fields['date'] = txtDateController.text;

    imageUploadRequest.files.add(file1);
    if (secondPath != "") {
      imageUploadRequest.files.add(file2);
    }

    try {
      final streamedResponse = await imageUploadRequest
          .send()
          .timeout(const Duration(seconds: 15), onTimeout: () {
        // Time has run out, do what you wanted to do.
        return HelperFunctions.showAlert(
            context: context,
            header: "EDS",
            widget: Text("The connection has timed out, Please try again!"),
            onDone: () {
              setState(() {
                isLoading = false;
              });
            },
            btnDoneText: "ok",
            onCancel: () {}); // Replace 500 with your http code.
      });
      final response = await http.Response.fromStream(streamedResponse);
      log(response.body);
      if (response.statusCode != 200) {
        this.setState(() {
          isLoading = false;
        });

        // Fluttertoast.showToast(msg: "Cannot Connect with server");

        return null;
      } else {


        this.setState(() {
          isLoading = false;
        });
        final String responseString = response.body;
        var message = jsonDecode(responseString);

        HelperFunctions.showAlert(
          context: context,
          header: "EDS",
          widget: Text(message["message"]),
          onDone: () {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (context) =>
                        Dashboard(employerId: employerid.toString())),
                (route) => false);
          },
          btnDoneText: "ok",
          onCancel: () {},
        );
        return dismissResponceFromJSON(responseString);
      }
    } catch (e) {
      print(e);
      return null;
    }
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
    return Stack(children: [
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
                color: colorText,
                fontWeight: FontWeight.w800,
                fontSize: size.width * 0.051,
              ),
              textAlign: TextAlign.justify,
            ),
            SizedBox(
              height: size.height * 0.01,
            ),
            Text(
              'Reason For Dismissal',
              style: TextStyle(fontSize: size.width * 0.039),
              textAlign: TextAlign.justify,
            ),
            SizedBox(
              height: size.height * 0.02,
            ),
            Row(
              children: [
                Checkbox(
                  checkColor: colorWhite,
                  activeColor: colorPrimary,
                  value: this.fired,
                  onChanged: (value) {
                    setState(() {
                      this.fired = value!;
                      this.contract = false;
                      this.Ret = false;
                    });
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
                    setState(() {
                      this.contract = value!;
                      this.fired = false;
                      this.Ret = false;
                    });
                  },
                ),
                SizedBox(
                  width: size.width * 0.01,
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
                    setState(() {
                      this.Ret = value!;
                      this.fired = false;
                      this.contract = false;
                    });
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
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Current Date',
                  style: TextStyle(fontSize: size.width * 0.039),
                  textAlign: TextAlign.justify,
                ),
                SizedBox(
                  width: size.width * 0.02,
                ),
                Checkbox(
                  checkColor: colorWhite,
                  activeColor: colorPrimary,
                  value: this.date,
                  onChanged: (value) {
                    setState(() {
                      this.date = value!;

                      txtDateController.text = ourFormat.format(DateTime.now());
                    });
                  },
                ),
              ],
            ),
            GestureDetector(
              onTap: () {
                showDatePicker(
                  // builder: ,
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2019),
                  lastDate: DateTime(2025),
                  builder: (context, child) {
                    return Theme(
                      data: ThemeData.light().copyWith(
                        colorScheme: ColorScheme.light(primary: colorPrimary),
                        buttonTheme:
                            ButtonThemeData(textTheme: ButtonTextTheme.accent),
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
                  max: 1,
                  labelText: "Select Date",
                  controller: txtDateController,
                  icon: Icon(
                    Icons.calendar_today,
                    color: colorgre,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: size.height * 0.01,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: size.width * 0.02,
                ),
                Expanded(
                  child: Text(
                    firstPath == ""
                        ? 'Official Notice'
                        : _file1!.path.split("/").last.toString(),
                    style: TextStyle(fontSize: size.width * 0.039),
                  ),
                ),
                SizedBox(
                  width: size.width * 0.1,
                ),
                Expanded(
                  child: Text(
                    secondPath == ""
                        ? 'Other Docs'
                        : _file2!.path.split("/").last.toString(),
                    style: TextStyle(fontSize: size.width * 0.039),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: size.height * 0.01,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                MaterialButton(
                  padding: EdgeInsets.zero,
                  color: Color(0xFFF3F3F3),
                  onPressed: () {
                    _getPDFDocument(fileNumber: 1);
                  },
                  child: Image.asset(
                    "assets/images/upload.png",
                    fit: BoxFit.fill,
                    height: size.width * 0.1,
                    width: size.width * 0.25,
                  ),
                ),
                SizedBox(
                  width: size.width * 0.01,
                ),
                MaterialButton(
                  padding: EdgeInsets.zero,
                  color: Color(0xFFF3F3F3),
                  onPressed: () {
                    _getPDFDocument(fileNumber: 2);
                  },
                  child: Image.asset(
                    "assets/images/upload.png",
                    fit: BoxFit.fill,
                    height: size.width * 0.1,
                    width: size.width * 0.25,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: size.height * 0.01,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FlatButton(
                    onPressed: () {
                      _btnActionDismissal(context);
                    },
                    color: colorPrimary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40)),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: size.width * 0.03,
                          vertical: size.height * 0.02),
                      child: Text(
                        "Confirm",
                        style: TextStyle(
                            color: colorWhite,
                            fontSize: size.width * 0.04,
                            fontWeight: FontWeight.w600),
                      ),
                    )),
                // ignore: deprecated_member_use
                FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    color: colorgre,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40)),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: size.width * 0.03,
                          vertical: size.height * 0.02),
                      child: Text(
                        "Cancel",
                        style: TextStyle(
                            color: colorWhite,
                            fontSize: size.width * 0.04,
                            fontWeight: FontWeight.w600),
                      ),
                    )),
              ],
            ),
          ]))
    ]);
  }
}
