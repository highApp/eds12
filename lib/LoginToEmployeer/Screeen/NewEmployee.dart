import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:eds/Widget/LabelWidget.dart';
import 'package:eds/Widget/btn_widget.dart';
import 'package:eds/managers/api_manager.dart';
import 'package:eds/models/homeDashboardObject.dart';
import 'package:eds/utilities/api_constants.dart';
import 'package:eds/utilities/customloader.dart';
import 'package:eds/utilities/helper_functions.dart';
import 'package:eds/utilities/image_bottom_sheet.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../Color.dart';
import 'Login.dart';

class NewEmployee extends StatefulWidget {
  Users? users;
  int? employerid;
  bool isEdit;

  NewEmployee({
    this.employerid,
    this.users,
    this.isEdit = false,
  });

  @override
  _NewEmployeeState createState() => _NewEmployeeState();
}

class _NewEmployeeState extends State<NewEmployee> {
  @override
  void initState() {
    super.initState();
    if (widget.users != null && widget.users?.name != null) {
      txtNameController.text = widget.users!.name!;
    }
    if (widget.users != null && widget.users?.cnic != null) {
      txtidController.text = widget.users!.cnic!;
    }
    if (widget.users != null && widget.users?.surname != null) {
      txtsurnameController.text = widget.users!.surname!;
    }
    if (widget.users != null && widget.users?.jobTitle != null) {
      txtjobController.text = widget.users!.jobTitle!;
    }
    if (widget.users != null && widget.users?.address != null) {
      txtAddressController.text = widget.users!.address!;
    }
    if (widget.users != null && widget.users?.phone != null) {
      txtContactController.text = widget.users!.phone!;
    }
    if (widget.users != null && widget.users?.user != null) {
      txtusernameController.text = widget.users!.user!;
    }
    if (widget.users != null && widget.users!.password != null) {
      txtpasswordController.text = widget.users!.password!;
    }
    if (widget.users != null && widget.users!.password != null) {
      txtconfirmPasswordControler.text = widget.users!.password!;
    }
    if (widget.users != null && widget.users!.image != null) {
      dummyImage = widget.users!.image!;
    }
  }

  bool reviewSelected = false;
  int selectedView = 1;

  final txtNameController = TextEditingController();
  final txtsurnameController = TextEditingController();
  final txtidController = TextEditingController();
  final txtjobController = TextEditingController();
  final txtAddressController = TextEditingController();
  final txtContactController = TextEditingController();
  final txtpreviousJobController = TextEditingController();
  final txtpreviousEpmConteactController = TextEditingController();
  final txtusernameController = TextEditingController();
  final txtpasswordController = TextEditingController();
  final txtconfirmPasswordControler = TextEditingController();
  File? _image;
  final imagePicker = ImagePicker();
  List<CustomMultipartObject> files = [];
  Future chooseImage(BuildContext context, ImageSource source) async {
    final pickedFile = await imagePicker.getImage(
      source: source,
      imageQuality: 50,
    );
    Navigator.pop(context);
    setState(() {
      _image = File(pickedFile!.path);
    });
  }

  _getFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      _image = File(result.files.single.path.toString());
    } else {
      // User canceled the picker
    }
    Navigator.pop(context);
    setState(() {
      this._image = _image;
    });
  }

  String dummyImage =
      "https://cdn.pixabay.com/photo/2015/03/04/22/35/head-659652_1280.png";

  bool isLoading = false;
  _btnActionAddEmployee(BuildContext context) {
    FocusScope.of(context).requestFocus(new FocusNode());
    if (_image == null) {
      HelperFunctions.showAlert(
          context: context,
          header: "EDS",
          widget: Text("Profile picture is required"),
          btnDoneText: "ok",
          onDone: () {},
          onCancel: () {});
    } else if (txtusernameController.text == '') {
      HelperFunctions.showAlert(
          context: context,
          header: "EDS",
          widget: Text("username is required"),
          btnDoneText: "ok",
          onDone: () {},
          onCancel: () {});
    } else if (txtpasswordController.text == '') {
      HelperFunctions.showAlert(
          context: context,
          header: "EDS",
          widget: Text("password is required"),
          btnDoneText: "ok",
          onDone: () {},
          onCancel: () {});
    } else if (txtconfirmPasswordControler.text == '') {
      HelperFunctions.showAlert(
          context: context,
          header: "EDS",
          widget: Text("confirm password is required"),
          btnDoneText: "ok",
          onDone: () {},
          onCancel: () {});
    } else if (txtconfirmPasswordControler.text != txtpasswordController.text) {
      HelperFunctions.showAlert(
          context: context,
          header: "EDS",
          widget: Text("password & confirm is does not"),
          btnDoneText: "ok",
          onDone: () {},
          onCancel: () {});
    } else if (txtNameController.text == '') {
      HelperFunctions.showAlert(
          context: context,
          header: "EDS",
          widget: Text("password is required"),
          btnDoneText: "ok",
          onDone: () {},
          onCancel: () {});
    } else if (txtNameController.text == '') {
      HelperFunctions.showAlert(
          context: context,
          header: "EDS",
          widget: Text("name is required"),
          btnDoneText: "ok",
          onDone: () {},
          onCancel: () {});
    } else if (txtsurnameController.text == '') {
      HelperFunctions.showAlert(
        context: context,
        header: "EDS",
        widget: Text("surname is required"),
        btnDoneText: "ok",
        onDone: () {},
        onCancel: () {},
      );
    } else if (txtidController.text == '') {
      HelperFunctions.showAlert(
        context: context,
        header: "EDS",
        widget: Text("ID/Passport is required"),
        btnDoneText: "ok",
        onDone: () {},
        onCancel: () {},
      );
    } else if (txtAddressController.text == '') {
      HelperFunctions.showAlert(
        context: context,
        header: "EDS",
        widget: Text("address is required"),
        btnDoneText: "ok",
        onDone: () {},
        onCancel: () {},
      );
    } else if (txtContactController.text == '') {
      HelperFunctions.showAlert(
        context: context,
        header: "EDS",
        widget: Text("Contact# is required"),
        btnDoneText: "ok",
        onDone: () {},
        onCancel: () {},
      );
    } else if (txtjobController.text == '') {
      HelperFunctions.showAlert(
        context: context,
        header: "EDS",
        widget: Text("Job is required"),
        btnDoneText: "ok",
        onDone: () {},
        onCancel: () {},
      );
    } else {
      _callAddNewEmploeeApi(context);
    }
  }

  _callAddNewEmploeeApi(BuildContext context) {
    this.setState(() {
      isLoading = true;
    });

    Map<String, String> body = Map<String, String>();

    body['name'] = txtNameController.text;
    body['surname'] = txtsurnameController.text;
    body['cnic'] = txtidController.text;
    body['address'] = txtAddressController.text;
    body['phone'] = txtContactController.text;

    body['jobTitle'] = txtjobController.text;
    body['empid'] = widget.employerid.toString();
    body['user'] = txtusernameController.text;
    body['password'] = txtpasswordController.text;
    log(jsonEncode(body));

    Map<String, String> header = Map<String, String>();

    FocusScope.of(context).requestFocus(FocusNode());
    CustomMultipartObject obj =
        CustomMultipartObject(file: _image, param: "image");
    files.add(obj);
    ApiCallMultiPart networkCall =
        ApiCallMultiPart(APIConstants.addnewEmployee, body, header);

    networkCall.callMultipartPostAPI(files, context).then((response) async {
      log(jsonEncode(response));
      print('Back from api');

      this.setState(() {
        isLoading = false;
      });

      bool status = response['status'];
      if (status == true) {
        HelperFunctions.showAlert(
            context: context,
            header: "EDS",
            widget: Text(response["message"]),
            btnDoneText: "ok",
            onDone: () {
              txtusernameController.clear();
              txtpasswordController.clear();
              txtNameController.clear();
              txtsurnameController.clear();
              txtidController.clear();
              txtAddressController.clear();
              txtContactController.clear();
              txtjobController.clear();
              txtpreviousJobController.clear();
              txtpreviousEpmConteactController.clear();

              Navigator.of(context).pop(
                context,
              );
            },
            onCancel: () {});
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

  _callEditEmploeeApi(BuildContext context) {
    this.setState(() {
      isLoading = true;
    });

    Map<String, String> body = Map<String, String>();

    body['name'] = txtNameController.text;
    body['surname'] = txtsurnameController.text;
    body['cnic'] = txtidController.text;
    body['address'] = txtAddressController.text;
    body['phone'] = txtContactController.text;
    // body['oldEmployer'] = txtpreviousJobController.text;
    // body['oldEmployerPhone'] = txtpreviousEpmConteactController.text;
    body['jobTitle'] = txtjobController.text;
    body['empid'] = widget.employerid.toString();
    body['user'] = txtusernameController.text;
    body['password'] = txtpasswordController.text;
    log(jsonEncode(body));

    Map<String, String> header = Map<String, String>();

    FocusScope.of(context).requestFocus(FocusNode());
    if (_image != null) {
      CustomMultipartObject obj =
          CustomMultipartObject(file: _image, param: "image");
      files.add(obj);
    }

    ApiCallMultiPart networkCall =
        ApiCallMultiPart(APIConstants.editEmployee, body, header);

    networkCall.callMultipartPostAPI(files, context).then((response) async {
      log(jsonEncode(response));
      print('Back from api');

      this.setState(() {
        isLoading = false;
      });

      bool status = response['status'];
      if (status == true) {
        HelperFunctions.showAlert(
            context: context,
            header: "EDS",
            widget: Text(response["message"]),
            btnDoneText: "ok",
            onDone: () {
              txtusernameController.clear();
              txtpasswordController.clear();
              txtNameController.clear();
              txtsurnameController.clear();
              txtidController.clear();
              txtAddressController.clear();
              txtContactController.clear();
              txtjobController.clear();
              txtpreviousJobController.clear();
              txtpreviousEpmConteactController.clear();

              Navigator.pop(context, true);
            },
            onCancel: () {});
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
        body: ListView(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          // mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: size.height * 0.09,
            ),
            Text(
              widget.isEdit ? "Edit Employee" : "New Employee ",
              style: TextStyle(
                  color: colorBlack, fontSize: 20, fontWeight: FontWeight.w800),
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
              child: Text(
                widget.isEdit
                    ? " "
                    : "This is a new Employee. Please complete the form below",
                style: TextStyle(
                  color: colorTex,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: size.height * 0.01),
            Center(
              child: Stack(
                children: [
                  ClipOval(
                    child: Container(
                      color: Colors.grey[300],
                      width: size.width * 0.23,
                      height: size.width * 0.23,
                      child: _image == null
                          ? Image.network(
                              dummyImage,
                              fit: BoxFit.cover,
                            )
                          : Image.file(
                              _image!,
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                  Positioned(
                      top: size.height * 0.058,
                      left: size.width * 0.138,
                      child: IconButton(
                        icon: Icon(
                          Icons.camera_alt_outlined,
                          color: colorPrimary,
                        ),
                        onPressed: () {
                          CustomBottomSheetCamera.bottomSheet(context, () {
                            chooseImage(context, ImageSource.camera);
                          }, () {
                            _getFile();
                            // chooseImage(context, ImageSource.gallery);
                          });
                        },
                      ))
                ],
              ),
            ),
            SizedBox(height: size.height * 0.01),
            widget.isEdit
                ? GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("You can't edit username"),
                      ));
                    },
                    child: AbsorbPointer(
                      child: LabelWidget(
                        labelText: "Username",
                        controller: txtusernameController,
                        max: 1,
                      ),
                    ),
                  )
                : LabelWidget(
                    labelText: "Username",
                    controller: txtusernameController,
                    max: 1,
                  ),
            LabelWidget(
              labelText: "Password",
              controller: txtpasswordController,
              max: 1,
              isSecure: true,
            ),
            LabelWidget(
              labelText: "Confirm Password",
              controller: txtconfirmPasswordControler,
              max: 1,
              isSecure: true,
            ),
            LabelWidget(
              labelText: "Name",
              controller: txtNameController,
              max: 1,
            ),
            LabelWidget(
              labelText: "Surname",
              controller: txtsurnameController,
              max: 1,
            ),
            LabelWidget(
              labelText: "ID/Passport No.",
              controller: txtidController,
              max: 1,
            ),
            LabelWidget(
              labelText: "Address",
              controller: txtAddressController,
              max: 2,
            ),
            LabelWidget(
              labelText: "Contact No.",
              controller: txtContactController,
              max: 1,
            ),
            LabelWidget(
              labelText: "Job Title",
              controller: txtjobController,
              max: 1,
            ),
            // LabelWidget(
            //   labelText: "Previous Employer",
            //   controller: txtpreviousJobController,
            //   max: 1,
            // ),
            // LabelWidget(
            //   labelText: "PE Contact No.",
            //   controller: txtpreviousEpmConteactController,
            //   max: 1,
            // ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //   children: [
            //     Material(
            //       elevation: 5,
            //       color: colorWhite,
            //       borderRadius: BorderRadius.circular(10),
            //       child: Padding(
            //         padding: const EdgeInsets.symmetric(
            //             horizontal: 15, vertical: 10),
            //         child: Stack(
            //           children: [
            //             Image.asset(
            //               "assets/images/face.png",
            //               height: size.height * 0.13,
            //             ),
            //             Positioned(
            //               right: 0,
            //               child: InkWell(
            //                 onTap: () {
            //                   setState(() {
            //                     reviewSelected = false;
            //                     selectedView = 0;
            //                   });
            //                 },
            //                 child: Container(
            //                   alignment: Alignment.bottomRight,
            //                   height: size.height * 0.03,
            //                   width: size.width * 0.06,
            //                   decoration: BoxDecoration(
            //                       color: selectedView == 0
            //                           ? colorPrimary
            //                           : Colors.grey,
            //                       borderRadius: BorderRadius.circular(30),
            //                       border: Border.all(color: Colors.grey)),
            //                   child: Icon(
            //                     Icons.check,
            //                     color: selectedView == 0
            //                         ? colorWhite
            //                         : Colors.grey,
            //                     size: 20,
            //                   ),
            //                 ),
            //               ),
            //             )
            //           ],
            //         ),
            //       ),
            //     ),
            //     Material(
            //       elevation: 5,
            //       color: colorWhite,
            //       borderRadius: BorderRadius.circular(10),
            //       child: Padding(
            //         padding: const EdgeInsets.symmetric(
            //             horizontal: 15, vertical: 10),
            //         child: Stack(
            //           children: [
            //             Image.asset(
            //               "assets/images/finger.png",
            //               height: size.height * 0.13,
            //             ),
            //             Positioned(
            //               right: 0,
            //               child: InkWell(
            //                 onTap: () {
            //                   setState(() {
            //                     reviewSelected = false;
            //                     selectedView = 1;
            //                   });
            //                 },
            //                 child: Container(
            //                   height: size.height * 0.03,
            //                   width: size.width * 0.06,
            //                   decoration: BoxDecoration(
            //                       color: selectedView == 1
            //                           ? colorPrimary
            //                           : Colors.grey,
            //                       borderRadius: BorderRadius.circular(30),
            //                       border: Border.all(color: Colors.grey)),
            //                   child: Icon(
            //                     Icons.check,
            //                     color: selectedView == 1
            //                         ? colorWhite
            //                         : Colors.grey,
            //                     size: 20,
            //                   ),
            //                 ),
            //               ),
            //             )
            //           ],
            //         ),
            //       ),
            //     )
            //   ],
            // ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: custom_btn(
                onPressed: () {
                  widget.isEdit == true
                      ? _callEditEmploeeApi(context)
                      : _btnActionAddEmployee(context);
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => Login()),
                  // );
                },
                text: widget.isEdit ? "Update" : "Save",
                textColor: colorWhite,
                backcolor: colorPrimary,
              ),
            )
          ],
        ),
      ),
    );
  }
}
