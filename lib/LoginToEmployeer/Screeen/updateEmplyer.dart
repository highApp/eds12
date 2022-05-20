import 'dart:convert';
import 'dart:developer';
import 'package:eds/LoginToEmployeer/Screeen/Login.dart';
import 'package:eds/Widget/LabelWidget.dart';
import 'package:eds/Widget/btn_widget.dart';
import 'package:eds/managers/api_manager.dart';
import 'package:eds/models/loginResponse.dart';

import 'package:eds/utilities/api_constants.dart';
import 'package:eds/utilities/customloader.dart';
import 'package:eds/utilities/helper_functions.dart';
import 'package:flutter/material.dart';

import '../../Color.dart';

class UpdateEmployer extends StatefulWidget {
  LogedInUser logedInUser;
  UpdateEmployer(this.logedInUser);

  @override
  _UpdateEmployerState createState() => _UpdateEmployerState();
}

class _UpdateEmployerState extends State<UpdateEmployer> {
  final txtNameController = TextEditingController();
  final txtEmailController = TextEditingController();
  final txtNumberController = TextEditingController();
  final txtaddressController = TextEditingController();
  final txtpasswordController = TextEditingController();

  bool isLoading = false;
  @override
  void initState() {
    super.initState();

    setState(() {
      txtNameController.text = widget.logedInUser.employer.name;
      txtEmailController.text = widget.logedInUser.employer.email;
      txtNumberController.text = widget.logedInUser.contacts.first.number;
      txtaddressController.text = widget.logedInUser.employer.address??'';
    });
  }

  _btnActionUpdate(BuildContext context) {
    FocusScope.of(context).requestFocus(new FocusNode());

    if (txtNameController.text == '') {
      HelperFunctions.showAlert(
          context: context,
          header: "EDS",
          widget: Text("Name is required"),
          btnDoneText: "ok",
          onDone: () {},
          onCancel: () {});
    } else if (txtEmailController.text == '') {
      HelperFunctions.showAlert(
        context: context,
        header: "EDS",
        widget: Text("Email is required"),
        btnDoneText: "ok",
        onDone: () {},
        onCancel: () {},
      );
    } else if (txtNumberController.text == '') {
      HelperFunctions.showAlert(
        context: context,
        header: "EDS",
        widget: Text("Number is required"),
        btnDoneText: "ok",
        onDone: () {},
        onCancel: () {},
      );
    } else if (txtaddressController.text == '') {
      HelperFunctions.showAlert(
        context: context,
        header: "EDS",
        widget: Text("Address is required"),
        btnDoneText: "ok",
        onDone: () {},
        onCancel: () {},
      );
    } else {
      _callAPIUpdateEmployer(context);
    }
  }

  _callAPIUpdateEmployer(BuildContext context) {
    this.setState(() {
      isLoading = true;
    });

    Map<String, dynamic> body = Map<String, dynamic>();

    body['empid'] = widget.logedInUser.employer.id;
    body['email'] = txtEmailController.text;
    body['name'] = txtNameController.text;
    body['address'] = txtaddressController.text;
    body['password'] = txtpasswordController.text;
    body['number'] = txtNumberController.text;

    log(jsonEncode(body));

    Map<String, String> header = Map<String, String>();

    FocusScope.of(context).requestFocus(FocusNode());

    ApiManager networkCal =
        ApiManager(APIConstants.employerUpdate, body, false, header);

    networkCal.callPostAPI(context).then((response) {
      // log(jsonEncode(response));
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
            btnDoneText: "",
            onDone: () {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => Login()),
                  (Route<dynamic> route) => false);
            },
            onCancel: () {});
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
    var size = MediaQuery.of(context).size;
    return CustomLoader(
      isLoading: isLoading,
      child: Scaffold(
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
        body: SingleChildScrollView(
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
                "Update account information",
                style: TextStyle(
                    color: colorTex, fontSize: 17, fontWeight: FontWeight.w400),
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

                max: 1,
                labelText: "Password Required",
                controller: txtpasswordController,
              ),
              LabelWidget(
                max: 1,
                labelText: "Address",
                controller: txtaddressController,
              ),
              SizedBox(
                height: size.height * 0.02,
              ),
              SizedBox(
                height: size.height * 0.03,
              ),
              custom_btn(
                onPressed: () {
                  _btnActionUpdate(context);

                  },
                text: "Request Update",
                textColor: colorWhite,
                backcolor: colorPrimary,
              )
            ],
          ),
        ),
      ),
    );
  }
}
