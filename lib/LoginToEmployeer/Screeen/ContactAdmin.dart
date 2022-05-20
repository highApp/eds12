import 'dart:io';
import 'package:eds/LoginToEmployeer/Screeen/SetPassword.dart';
import 'package:eds/Widget/LabelWidget.dart';
import 'package:eds/Widget/btn_widget.dart';

import 'package:eds/models/signupResponse.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../Color.dart';

class ContactAdmin extends StatefulWidget {
  const ContactAdmin({Key? key}) : super(key: key);

  @override
  _ContactAdminState createState() => _ContactAdminState();
}

class _ContactAdminState extends State<ContactAdmin> {
  final txtNameController = TextEditingController();
  final txtEmailController = TextEditingController();
  final txtNumberController = TextEditingController();
  final txtMessageController = TextEditingController();

  bool isLoading = false;
  File? _file1;
  File? _file2;

  String firstimagep = "";
  String secondImagePath = "";
  // late CustomMultipartObject fileObject1;
  // late CustomMultipartObject fileObject2;

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

  late Response response;

  onpressSend() {
    response = Response(
      id: 1,
      name: txtNameController.text,
      email: txtEmailController.text,
      number: txtNumberController.text,
      message: txtMessageController.text,
      bankLetter: _file1!.path,
      regDocument: _file2!.path,
    );
    FocusScopeNode currentFocus = FocusScope.of(context);

    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.transparent,
        elevation: 0,
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
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.red,
              ),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: size.height * 0.09,
                  ),
                  Text("Contact Us",
                      style: TextStyle(
                          color: colorText,
                          fontSize: 22,
                          fontWeight: FontWeight.w800)),
                  SizedBox(
                    height: size.height * 0.01,
                  ),
                  Text(
                    "Create a new account",
                    style: TextStyle(
                        color: colorTex,
                        fontSize: 17,
                        fontWeight: FontWeight.w400),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: size.height * 0.03,
                  ),
                  LabelWidget(
                    labelText: "Name",
                    max: 1,
                    controller: txtNameController,
                  ),
                  LabelWidget(
                    labelText: "Email",
                    max: 1,
                    controller: txtEmailController,
                  ),
                  LabelWidget(
                    labelText: "Number",
                    max: 1,
                    controller: txtNumberController,
                  ),
                  LabelWidget(
                    max: 3,
                    labelText: "Message",
                    controller: txtMessageController,
                  ),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Company/Business\nRegistration Documents",
                          style: TextStyle(
                              color: colorTex,
                              fontSize: 16,
                              fontWeight: FontWeight.w400),
                          textAlign: TextAlign.justify,
                        ),
                        GestureDetector(
                          onTap: () {
                            _getPDFDocument(true);
                          },
                          child: Container(
                            color: colorall,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 20),
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    'Upload',
                                    style: TextStyle(
                                        color: colorText,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Icon(Icons.file_upload)
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  _file1 == null
                      ? Container()
                      : Column(
                          children: [
                            Text(
                              firstimagep,
                              style: TextStyle(
                                  color: colorText,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.01,
                            ),
                          ],
                        ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Business Bank\nConfirmation Letter",
                          style: TextStyle(
                              color: colorTex,
                              fontSize: 16,
                              fontWeight: FontWeight.w400),
                          textAlign: TextAlign.justify,
                        ),
                        GestureDetector(
                          onTap: () {
                            _getPDFDocument(false);
                          },
                          child: Container(
                            color: colorall,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 20),
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    'Upload',
                                    style: TextStyle(
                                        color: colorText,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Icon(Icons.file_upload)
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  _file2 == null
                      ? Container()
                      : Column(
                          children: [
                            Text(
                              secondImagePath,
                              style: TextStyle(
                                  color: colorText,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.01,
                            ),
                          ],
                        ),
                  SizedBox(
                    height: size.height * 0.03,
                  ),
                  custom_btn(
                    onPressed: () {
                      onpressSend();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SetPassword(
                            response: response,
                            onsuccess: () {
                              print("this is test message");
                              setState(() {
                                txtNameController.clear();
                                txtEmailController.clear();
                                txtNumberController.clear();
                                txtMessageController.clear();
                                _file1 = null;
                                _file2 = null;
                                setState(() {});
                              });
                            },
                          ),
                        ),
                      );
                    },
                    text: "Send",
                    textColor: colorWhite,
                    backcolor: colorPrimary,
                  )
                ],
              ),
            ),
    );
  }
}
