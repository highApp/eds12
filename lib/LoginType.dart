import 'package:eds/LoginToEmployeer/Screeen/Login.dart';
import 'package:eds/utilities/helper_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Color.dart';

import 'Login_As_Employee/Screen/SignIn.dart';

class LoginType extends StatefulWidget {
  @override
  _LoginTypeState createState() => _LoginTypeState();
}

class _LoginTypeState extends State<LoginType> {
  bool reviewSelected = false;
  int selectedView = 2;

  String? userId;
  String? status;
  // String? employeeGid;
  // String? emplyeeImage;
  // String? employeeName;
  @override
  void initState() {
    super.initState();
    HelperFunctions.getFromPreference('userId').then((value) {
      userId = value;
      print("User id" + userId!);
    });
    HelperFunctions.getFromPreference('status').then((value) {
      status = value;
      print("status" + status!);
    });
  }

  void moveToNextEmployeeNextScreen(BuildContext ctx) {
    print('In Next Screen');
    // print(employeeGid);

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) {
          return SignIn();
        },
      ),
    );
  }

  void moveToNextScreen(BuildContext ctx) {
    print('In Next Screen');
    print(userId);
    if (userId != null && userId != "" && status == "Active") {
      _moveToLoginVC(context);
    } else {
      _moveToLoginVC(context);
    }
  }

  // _moveToHomeVC(BuildContext context) {
  //   Navigator.of(context).pushReplacement(
  //     MaterialPageRoute(
  //       builder: (_) {
  //         return Dashboard(
  //           employerId: userId.toString(),
  //         );
  //       },
  //     ),
  //   );
  // }

  _moveToLoginVC(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) {
          return Login();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [
              Image.asset(
                "assets/images/splash.png",
                height: size.width * 0.25,
                width: size.width * 0.25,
              ),
              SizedBox(
                height: size.height * 0.05,
              ),
              Text(
                "Welcome to EDS ",
                style: TextStyle(
                    color: colorSplash,
                    fontSize: size.width * 0.054,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: size.width * 0.01,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.02,
                ),
                child: Text(
                  "Employee Management with Precision and \nSafety in Mind",
                  style: TextStyle(
                      color: colorText.withOpacity(0.4),
                      fontSize: size.width * 0.031,
                      fontWeight: FontWeight.w400),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          Column(
            children: [
              _btn(
                text: "Login as Employee",
                textColor: selectedView == 0 ? colorWhite : Colors.black,
                colorBack: selectedView == 0 ? colorPrimary : Colors.white,
                image: "assets/images/asemp.png",
                subtitle: "Check your status, salary etc.",
                onTap: () {
                  moveToNextEmployeeNextScreen(context);
                  setState(() {
                    reviewSelected = false;
                    selectedView = 0;
                  });
                },
              ),
              _btn(
                text: "Login as Employer",
                textColor: selectedView == 1 ? colorWhite : Colors.black,
                colorBack: selectedView == 1 ? colorPrimary : colorWhite,
                image: "assets/images/toemp.png",
                subtitle:
                    "Add or edit an employee’s details, status, salary etc.",
                onTap: () {
                  moveToNextScreen(context);
                  setState(() {
                    reviewSelected = false;
                    selectedView = 1;
                  });
                },
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _btn({
    image,
    text,
    onTap,
    textColor,
    colorBack,
    subtitle,
  }) {
    var size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: size.width * 0.13, vertical: size.height * 0.02),
        child: Material(
          borderRadius: BorderRadius.circular(size.width * 0.045),
          color: colorBack,
          elevation: 5,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: size.height * 0.013),
            child: Row(
              children: [
                SizedBox(
                  width: size.width * 0.04,
                ),
                Image.asset(
                  image,
                  height: size.height * 0.085,
                  width: size.width * 0.085,
                  color: Colors.black.withOpacity(0.5),
                ),
                Flexible(
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: size.width * 0.045,
                      right: size.width * 0.045,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          text,
                          style: TextStyle(
                              color: textColor,
                              fontSize: size.width * 0.036,
                              fontWeight: FontWeight.w900),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        Text(
                          subtitle,
                          style: TextStyle(
                              color: Colors.black.withOpacity(0.4),
                              fontSize: size.width * 0.033,
                              fontWeight: FontWeight.w500),
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
