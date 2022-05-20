import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:eds/Widget/btn_widget.dart';
import 'package:eds/models/addFlagResponce.dart';
import 'package:eds/utilities/api_constants.dart';
import 'package:eds/utilities/customloader.dart';
import 'package:eds/utilities/helper_functions.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../Color.dart';

class SelectFlag extends StatefulWidget {
  String gid;
  SelectFlag({required this.gid});

  @override
  _SelectFlagState createState() => _SelectFlagState();
}

class _SelectFlagState extends State<SelectFlag> {
  bool isLoading = false;
  File? _file1;
  File? _file2;
  String firstimagep = "";
  String secondImagePath = "";

  _getPDFDocument(bool firstFile) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      if (firstFile) {
        _file1 = File(result.files.single.path.toString());
        print(_file1);
        _splitText(imagePath: _file1.toString(), isFirst: true);
      } else {
        _file2 = File(result.files.single.path.toString());
        print(_file2);
        _splitText(imagePath: _file2.toString(), isFirst: false);
      }
    } else {
      // User canceled the picker
    }
  }

  _splitText({required String imagePath, required bool isFirst}) {
    isFirst
        ? setState(() {
            firstimagep = imagePath.split("/").last.toString();
          })
        : setState(() {
            secondImagePath = imagePath.split("/").last.toString();
          });
  }

  Future<AddFlagRespoce?> _addFlag() async {
    this.setState(() {
      isLoading = true;
    });

    String apiUrl = APIConstants.baseURL + APIConstants.addFlag;

    print(apiUrl);
    // final mimeTypeData =
    // lookupMimeType(image.path, headerBytes: [0xFF, 0xD8]).split('/');

    // Attach the file in the request
    var file1;
    if (_file1 != null) {
      file1 = await http.MultipartFile.fromPath(
          'policeReport', _file1!.path.toString());
    }

    var file2;
    if (secondImagePath != "") {
      file2 = await http.MultipartFile.fromPath(
          'otherDoc', _file2!.path.toString());
    }

    // Intilize the multipart request
    final imageUploadRequest = http.MultipartRequest('POST', Uri.parse(apiUrl));
    print(imageUploadRequest.fields);

    imageUploadRequest.fields['gid'] = widget.gid;
    if (redFlag == true) {
      imageUploadRequest.fields['flag'] = "red";
    } else if (orangeFlag == true) {
      imageUploadRequest.fields['flag'] = "orange";
    }
    if (_file1 != null) {
      imageUploadRequest.files.add(file1);
    }

    if (secondImagePath != "") {
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
            widget: Text("'The connection has timed out, Please try again!'"),
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
          onDone: () {},
          btnDoneText: "ok",
          onCancel: () {},
        );
        return documentResponceFromJSON(responseString);
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  bool? redFlag = false;
  bool? orangeFlag = false;
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
            "Select Flag",
            style: TextStyle(
                color: colorText,
                fontSize: size.width * 0.043,
                fontWeight: FontWeight.w700),
          ),
          iconTheme: IconThemeData(color: Colors.black),
        ),
        body: ListView(
          shrinkWrap: true,
          primary: false,
          padding: EdgeInsets.all(8),
          children: [
            Container(
              margin: EdgeInsets.symmetric(
                  horizontal: size.width * 0.04, vertical: size.width * 0.03),
              decoration: BoxDecoration(
                  color: Color(0xFFFBF9F9),
                  borderRadius: BorderRadius.circular(size.width * 0.04)),
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.04, vertical: size.width * 0.01),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: size.height * 0.01,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.flag,
                                color: Colors.red,
                                size: size.width * 0.06,
                              ),
                              SizedBox(
                                width: size.width * 0.02,
                              ),
                              Text(
                                'Red Flag',
                                style: TextStyle(
                                    color: colorText,
                                    fontWeight: FontWeight.w600,
                                    fontSize: size.width * 0.045),
                                textAlign: TextAlign.justify,
                              ),
                              SizedBox(
                                width: size.width * 0.01,
                              ),
                              Icon(
                                Icons.info_outline_rounded,
                                color: colorTex,
                                size: size.width * 0.055,
                              ),
                            ],
                          ),
                          Checkbox(
                            checkColor: colorWhite,
                            activeColor: colorPrimary,
                            value: this.redFlag,
                            onChanged: (value) {
                              setState(() {
                                this.redFlag = value;
                                this.orangeFlag = false;
                                _file1 = null;
                                _file2 = null;
                              });
                            },
                          ),
                        ],
                      ),
                      SizedBox(
                        height: size.height * 0.01,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Police Report:',
                            style: TextStyle(
                                color: colorgre,
                                fontWeight: FontWeight.w500,
                                fontSize: size.width * 0.04),
                            textAlign: TextAlign.justify,
                          ),
                          Text(
                            'Other Docs:',
                            style: TextStyle(
                                color: colorgre,
                                fontWeight: FontWeight.w500,
                                fontSize: size.width * 0.04),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    if (this.redFlag == true) {
                                      _getPDFDocument(true);
                                    }
                                  },
                                  child: Image.asset(
                                    "assets/images/upload.png",
                                    height: size.width * 0.1,
                                    width: size.width * 0.25,
                                  ),
                                ),
                                SizedBox(
                                  height: size.width * 0.01,
                                ),
                                redFlag == true
                                    ? Text(
                                        firstimagep,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: size.width * 0.033),
                                      )
                                    : Container(),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    if (this.redFlag == true) {
                                      _getPDFDocument(false);
                                    }
                                  },
                                  child: Image.asset(
                                    "assets/images/upload.png",
                                    height: size.width * 0.1,
                                    width: size.width * 0.25,
                                  ),
                                ),
                                SizedBox(
                                  height: size.width * 0.01,
                                ),
                                redFlag == true
                                    ? Text(
                                        secondImagePath,
                                        overflow: TextOverflow.clip,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: size.width * 0.033),
                                      )
                                    : Container(),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: size.height * 0.01,
                      ),
                    ]),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(
                  horizontal: size.width * 0.04, vertical: size.width * 0.03),
              decoration: BoxDecoration(
                  color: Color(0xFFFBF9F9),
                  borderRadius: BorderRadius.circular(size.width * 0.04)),
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.04, vertical: size.width * 0.01),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: size.height * 0.01,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.flag,
                                color: Colors.orange,
                                size: size.width * 0.06,
                              ),
                              SizedBox(
                                width: size.width * 0.02,
                              ),
                              Text(
                                'Orange Flag',
                                style: TextStyle(
                                    color: colorText,
                                    fontWeight: FontWeight.w600,
                                    fontSize: size.width * 0.045),
                                textAlign: TextAlign.justify,
                              ),
                              SizedBox(
                                width: size.width * 0.01,
                              ),
                              Icon(
                                Icons.info_outline_rounded,
                                color: colorTex,
                                size: size.width * 0.055,
                              ),
                            ],
                          ),
                          Checkbox(
                            checkColor: colorWhite,
                            activeColor: colorPrimary,
                            value: this.orangeFlag,
                            onChanged: (value) {
                              setState(() {
                                this.orangeFlag = value;
                                this.redFlag = false;
                                firstimagep = "";
                                secondImagePath = "";
                                _file1 = null;
                                _file2 = null;
                              });
                            },
                          ),
                        ],
                      ),
                      SizedBox(
                        height: size.height * 0.01,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Police Report:',
                            style: TextStyle(
                                color: colorgre,
                                fontWeight: FontWeight.w500,
                                fontSize: size.width * 0.04),
                            textAlign: TextAlign.justify,
                          ),
                          Text(
                            'Other Docs:',
                            style: TextStyle(
                                color: colorgre,
                                fontWeight: FontWeight.w500,
                                fontSize: size.width * 0.04),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    if (this.orangeFlag == true) {
                                      _getPDFDocument(true);
                                    }
                                  },
                                  child: Image.asset(
                                    "assets/images/upload.png",
                                    fit: BoxFit.fill,
                                    height: size.width * 0.1,
                                    width: size.width * 0.25,
                                  ),
                                ),
                                orangeFlag == true
                                    ? Text(
                                        firstimagep,
                                        overflow: TextOverflow.clip,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: size.width * 0.033),
                                      )
                                    : Container(),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    if (this.orangeFlag == true) {
                                      _getPDFDocument(false);
                                    }
                                  },
                                  child: Image.asset(
                                    "assets/images/upload.png",
                                    height: size.width * 0.1,
                                    width: size.width * 0.25,
                                  ),
                                ),
                                orangeFlag == true
                                    ? Text(
                                        secondImagePath,
                                        overflow: TextOverflow.clip,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: size.width * 0.033),
                                      )
                                    : Container(),
                              ],
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: size.height * 0.01,
                      ),
                    ]),
              ),
            ),
            SizedBox(height: size.height * 0.2),
            custom_btn(
              onPressed: () {
                _addFlag();
              },
              text: "Submit",
              textColor: colorWhite,
              backcolor: colorPrimary,
            )
          ],
        ),
      ),
    );
  }
}
