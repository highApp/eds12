import 'dart:convert';
import 'dart:developer';

import 'package:eds/LoginType.dart';
import 'package:eds/Widget/InputText.dart';
import 'package:eds/Widget/btn_widget.dart';
import 'package:eds/managers/api_manager.dart';
import 'package:eds/models/Employee/EmployeLoginObject.dart';
import 'package:eds/utilities/api_constants.dart';
import 'package:eds/utilities/customloader.dart';
import 'package:eds/utilities/helper_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../Color.dart';
import 'HomePage.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  String? employeeGid;
  String? emplyeeImage;
  String? employeeuserName;
  String? employeeName;
  final LocalAuthentication auth = LocalAuthentication();
  _SupportState _supportState = _SupportState.unknown;

  bool _canCheckBiometrics = false;
  List<BiometricType> _availableBiometrics = [];
  String _authorized = 'Not Authorized';
  bool _isAuthenticating = false;

  @override
  void initState() {
    super.initState();
    HelperFunctions.getFromPreference('employeeGid').then((value) {
      employeeGid = value;
    });
    HelperFunctions.getFromPreference('employeeImage').then((value) {
      emplyeeImage = value;
    });
    HelperFunctions.getFromPreference('employeeName').then((value) {
      employeeName = value;
    });
    HelperFunctions.getFromPreference('employeeuserName').then((value) {
      employeeuserName = value;

      txtuserNamecontroller.text = employeeuserName.toString();
    });
    auth.isDeviceSupported().then(
          (isSupported) => setState(() => _supportState = isSupported
              ? _SupportState.supported
              : _SupportState.unsupported),
        );
  }

  Future<void> _checkBiometrics() async {
    bool canCheckBiometrics;
    try {
      canCheckBiometrics = await auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      canCheckBiometrics = false;
      print(e);
    }
    if (!mounted) return;

    setState(() {
      _canCheckBiometrics = canCheckBiometrics;
    });
  }

  Future<void> _getAvailableBiometrics() async {
    List<BiometricType> availableBiometrics;
    try {
      availableBiometrics = await auth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      availableBiometrics = <BiometricType>[];
      print(e);
    }
    if (!mounted) return;

    setState(() {
      _availableBiometrics = availableBiometrics;
    });
  }

  Future<void> _authenticate() async {
    bool authenticated = false;
    try {
      setState(() {
        _isAuthenticating = true;
        _authorized = 'Authenticating';
      });
      authenticated = await auth.authenticate(
          localizedReason: 'Scan your fingerprint/face to authenticat',
          useErrorDialogs: true,
          stickyAuth: true);
      setState(() {
        _isAuthenticating = false;
      });
    } on PlatformException catch (e) {
      print(e);
      setState(() {
        _isAuthenticating = false;
        _authorized = "Error - ${e.message}";
      });
      return;
    }
    if (!mounted) return;
    authenticated
        ? Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => HomePage(
                gid: employeeGid,
                employeeImage: emplyeeImage,
                employeeName: employeeName,
              ),
            ),
          )
        : setState(() =>
            _authorized = authenticated ? 'Authorized' : 'Not Authorized');
  }

  // Future<void> _authenticateWithBiometrics() async {
  //   bool authenticated = false;
  //   try {
  //     setState(() {
  //       _isAuthenticating = true;
  //       _authorized = 'Authenticating';
  //     });
  //     authenticated = await auth.authenticate(
  //         localizedReason: 'Scan your fingerprint to authenticate',
  //         useErrorDialogs: true,
  //         stickyAuth: true,
  //         biometricOnly: true);
  //     setState(() {
  //       _isAuthenticating = false;
  //       _authorized = 'Authenticating';
  //     });
  //   } on PlatformException catch (e) {
  //     print(e);
  //     setState(() {
  //       _isAuthenticating = false;
  //       _authorized = "Error - ${e.message}";
  //     });
  //     return;
  //   }
  //   if (!mounted) return;

  //   final String message = authenticated ? 'Authorized' : 'Not Authorized';
  //   authenticated
  //       ? Navigator.of(context).pushAndRemoveUntil(
  //           MaterialPageRoute(
  //             builder: (context) => HomePage(
  //               gid: employeeGid,
  //               employeeImage: emplyeeImage,
  //               employeeName: employeeName,
  //             ),
  //           ),
  //           (Route<dynamic> route) => false)
  //       : setState(() {
  //           _authorized = message;
  //         });
  // }

  void _cancelAuthentication() async {
    await auth.stopAuthentication();
    setState(() => _isAuthenticating = false);
  }

  final txtuserNamecontroller = TextEditingController();
  final txtpasswordController = TextEditingController();
  _btnActionSigniLoacalAuth() {
    if (employeeGid != null &&
        employeeGid != "" &&
        employeeuserName != null &&
        employeeuserName != "") {
      _authenticate();

      // Navigator.of(context).push(
      //     MaterialPageRoute(builder: (context) => HomePage(gid: employeeGid)));
    } else {
      HelperFunctions.showAlert(
          context: context,
          header: "EDS",
          widget: Text(
            "Please try again with password",
            style:
                TextStyle(fontSize: MediaQuery.of(context).size.width * 0.037),
          ),
          onDone: () {},
          onCancel: () {});
    }
  }

  _btnActionSignIn(BuildContext context) {
    FocusScope.of(context).requestFocus(new FocusNode());
    if (txtuserNamecontroller.text == '') {
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
        onCancel: () {},
      );
    } else {
      _callAPIEmployeeLogin(context);
    }
  }

  bool isLoading = false;
  late EmployeeLoginObject employeeLoginObject;
  late EmployeeLogin? employeeLogin;
  _callAPIEmployeeLogin(BuildContext context) {
    this.setState(() {
      isLoading = true;
    });

    Map<String, dynamic> body = Map<String, dynamic>();
    body['user'] = txtuserNamecontroller.text;
    body['password'] = txtpasswordController.text;

    Map<String, String> header = Map<String, String>();

    FocusScope.of(context).requestFocus(FocusNode());

    ApiManager networkCal =
        ApiManager(APIConstants.employeeSignin, body, false, header);
    log(jsonEncode(body));
    networkCal.callPostAPI(context).then((response) {
      print('Back from api');

      this.setState(() {
        isLoading = false;
      });

      bool status = response['status'];
      if (status == true) {
        employeeLoginObject = EmployeeLoginObject.fromMap(response);

        employeeLogin = employeeLoginObject.response;
        HelperFunctions.saveInPreference(
            "employeeGid", employeeLogin!.gid.toString());
        HelperFunctions.saveInPreference(
            "employeeuserName", employeeLogin!.user.toString());
        HelperFunctions.saveInPreference(
            "employeeName", employeeLogin!.name.toString());
        if (employeeLogin?.image != null) {
          HelperFunctions.saveInPreference(
              "employeeImage", employeeLogin!.image);
        }

        HelperFunctions.saveInPreference("employeeName", employeeLogin!.name);
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => HomePage(
              gid: employeeLogin!.gid.toString(),
              employeeImage: employeeLogin!.image,
              employeeName: employeeLogin!.name.toString(),
            ),
          ),
          (Route<dynamic> route) => false,
        );
        // }
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
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => LoginType()),
                (Route<dynamic> route) => false,
              );
            },
            icon: Icon(
              Icons.keyboard_backspace_outlined,
              size: size.width * 0.065,
              color: colorText,
            ),
          ),
        ),
        body: ListView(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                SizedBox(height: size.height * 0.1),
                Image.asset(
                  "assets/images/splash.png",
                  height: size.width * 0.23,
                  width: size.width * 0.23,
                ),
                SizedBox(
                  height: size.height * 0.03,
                ),
                Text(
                  "Welcome to EDS ",
                  style: TextStyle(
                      color: colorSplash,
                      fontSize: size.width * 0.055,
                      fontWeight: FontWeight.w800),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: size.height * 0.01,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.02,
                  ),
                  child: Text(
                    "Login as Employee",
                    style: TextStyle(
                        color: colorgre,
                        fontSize: size.width * 0.032,
                        fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            if (_supportState == _SupportState.unknown)
              CircularProgressIndicator()
            else if (_supportState == _SupportState.supported)
              // Text("This device is supported")
              // else
              //   Text("This device is not supported"),
              //   Divider(height: 100),
              // Text('Can check biometrics: $_canCheckBiometrics\n'),
              // ElevatedButton(
              //   child: const Text('Check biometrics'),
              //   onPressed: _checkBiometrics,
              // ),
              // Divider(height: 100),
              //   Text('Available biometrics: $_availableBiometrics\n'),
              // ElevatedButton(
              //   child: const Text('Get available biometrics'),
              //   onPressed: _getAvailableBiometrics,
              // ),
              // Divider(height: 100),
              //   Text('Current State: $_authorized\n'),
              // (_isAuthenticating)
              //     ? ElevatedButton(
              //         onPressed: _cancelAuthentication,
              //         child: Row(
              //           mainAxisSize: MainAxisSize.min,
              //           children: [
              //             Text("Cancel Authentication"),
              //             Icon(Icons.cancel),
              //           ],
              //         ),
              //       )
              //     :

              SizedBox(
                height: size.height * 0.09,
              ),
            inputWidget(
              icon: Icon(
                Icons.person_outline_outlined,
                color: colorTex,
              ),
              hintText: "Username",
              txtController: txtuserNamecontroller,
            ),
            inputWidget(
              icon: Icon(
                Icons.lock_outline,
                color: colorTex,
              ),
              hintText: "Password",
              txtController: txtpasswordController,
              isSecure: true,
            ),
            custom_btn(
              onPressed: () {
                _btnActionSignIn(context);
              },
              textColor: colorWhite,
              backcolor: colorPrimary,
              text: "Log In",
            ),
            SizedBox(
              height: size.height * 0.03,
            ),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _supportState == _SupportState.supported
                        ? GestureDetector(
                            onTap: () {
                              _btnActionSigniLoacalAuth();
                            },
                            child: Image.asset(
                              "assets/images/finger.png",
                              height: size.height * 0.1,
                            ),
                          )
                        : Container()
                    // GestureDetector(
                    //   onTap: () {
                    //     Navigator.push(
                    //         context,
                    //         MaterialPageRoute(
                    //             builder: (context) => HomePage(
                    //                   gid: employeeGid,
                    //                   employeeImage: emplyeeImage,
                    //                   employeeName: employeeuserName,
                    //                 )));
                    //   },
                    //   child: Image.asset(
                    //     "assets/images/face.png",
                    //     height: size.height * 0.1,
                    //   ),
                    // ),
                  ],
                ),
                // ElevatedButton(
                //   child: Row(
                //     mainAxisSize: MainAxisSize.min,
                //     children: [
                //       Text(_isAuthenticating
                //           ? 'Cancel'
                //           : 'Authenticate: biometrics only'),
                //       Icon(Icons.fingerprint),
                //     ],
                //   ),
                //   onPressed: _authenticateWithBiometrics,
                // ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.034,
                vertical: size.height * 0.034,
              ),
              child: Text(
                "DON’T HAVE AN ACCOUNT YET? PLEASE CONTACT YOUR EMPLOYER",
                style: TextStyle(
                  color: colorTex,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum _SupportState {
  unknown,
  supported,
  unsupported,
}
