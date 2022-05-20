import 'dart:convert';
import 'dart:developer';
import 'package:eds/LoginToEmployeer/Screeen/Login.dart';
import 'package:eds/Widget/LabelWidget.dart';
import 'package:eds/Widget/btn_widget.dart';
import 'package:eds/models/signupResponse.dart';
import 'package:eds/utilities/api_constants.dart';
import 'package:eds/utilities/customloader.dart';
import 'package:eds/utilities/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../Color.dart';

class SetPassword extends StatefulWidget {
  Response response;
  VoidCallback onsuccess;
  SetPassword({required this.response, required this.onsuccess});

  @override
  _SetPasswordState createState() => _SetPasswordState();
}

class _SetPasswordState extends State<SetPassword> {
  final txtPasswordController = TextEditingController();
  final txtconfirmPasswordController = TextEditingController();

  bool isLoading = false;
  Future<SignUpResponse?> _ContactAdmin() async {
    this.setState(() {
      isLoading = true;
    });

    String apiUrl = APIConstants.baseURL + APIConstants.signUp;

    print(apiUrl);
    // final mimeTypeData =
    // lookupMimeType(image.path, headerBytes: [0xFF, 0xD8]).split('/');

    // Attach the file in the request
    final file1 = await http.MultipartFile.fromPath(
        'regDocument', widget.response.regDocument.toString());
    final file2 = await http.MultipartFile.fromPath(
        'bankLetter', widget.response.bankLetter.toString());

    // Intilize the multipart request
    final imageUploadRequest = http.MultipartRequest('POST', Uri.parse(apiUrl));

    imageUploadRequest.fields['name'] = widget.response.name.toString();
    imageUploadRequest.fields['email'] = widget.response.email.toString();
    imageUploadRequest.fields['number'] = widget.response.number.toString();
    imageUploadRequest.fields['message'] = widget.response.message.toString();
    imageUploadRequest.fields['password'] = txtPasswordController.text;
    imageUploadRequest.fields['confirmPassword'] =
        txtconfirmPasswordController.text;
    imageUploadRequest.files.add(file1);
    imageUploadRequest.files.add(file2);

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
        txtPasswordController.clear();
        txtconfirmPasswordController.clear();
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (BuildContext context) {
              return Login();
            },
          ),
        );
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

        // HelperFunctions.showAlert(
        //   context: context,
        //   header: "EDS",
        //   widget: Text(message["message"]),
        //   onDone: () {
        //     widget.onsuccess();
        //   },
        //   btnDoneText: "ok",
        //   onCancel: () {},
        // );
        return signUpResponseFromJSON(responseString);
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return CustomLoader(
      isLoading: isLoading,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: colorWhite,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    SizedBox(
                      height: size.height * 0.04,
                    ),
                    Text("Set Password",
                        style: TextStyle(
                            color: colorText,
                            fontSize: 20,
                            fontWeight: FontWeight.w800)),
                    SizedBox(
                      height: size.height * 0.01,
                    ),
                    Text(
                      "Create new account",
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
                      labelText: "Password",
                      max: 1,
                      controller: txtPasswordController,
                      isSecure: true,
                    ),
                    LabelWidget(
                      labelText: "Confirm Password",
                      controller: txtconfirmPasswordController,
                      max: 1,
                      isSecure: true,
                    ),
                  ],
                ),
                custom_btn(
                  onPressed: () {
                    FocusScopeNode currentFocus = FocusScope.of(context);

                    if (!currentFocus.hasPrimaryFocus) {
                      currentFocus.unfocus();
                    }
                    _ContactAdmin();
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => Dashboard()),
                    // );
                  },
                  text: "Send",
                  textColor: colorWhite,
                  backcolor: colorPrimary,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
