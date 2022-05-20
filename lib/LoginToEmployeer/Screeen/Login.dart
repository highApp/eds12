import 'package:eds/LoginToEmployeer/Screeen/Dashboard.dart';
import 'package:eds/LoginType.dart';
import 'package:eds/Widget/InputText.dart';
import 'package:eds/Widget/WaitngForApproval.dart';
import 'package:eds/Widget/btn_widget.dart';
import 'package:eds/managers/api_manager.dart';
import 'package:eds/models/loginResponse.dart';
import 'package:eds/utilities/api_constants.dart';
import 'package:eds/utilities/customloader.dart';
import 'package:eds/utilities/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

import '../../Color.dart';
import 'ContactAdmin.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

LogedInUser? logedInUser;
EmplyerLogin? emplyerLogin;

class _LoginState extends State<Login> {
  final txtUserNamecontroller = TextEditingController();
  final txtPasswordController = TextEditingController();
  String? employeerEmail;

  @override
  void initState() {
    super.initState();
    HelperFunctions.getFromPreference("userId")
        .then((value) => employerid = value);
    HelperFunctions.getFromPreference('Email').then((value) {
      txtUserNamecontroller.text = value;
    });

    setState(() {
      txtUserNamecontroller.text = employeerEmail.toString();
    });

    auth.isDeviceSupported().then(
          (isSupported) => setState(() => _supportState = isSupported
              ? _SupportState.supported
              : _SupportState.unsupported),
        );
  }

  _btnActionSignIn(BuildContext context) {
    FocusScope.of(context).requestFocus(new FocusNode());
    if (txtUserNamecontroller.text == '') {
      HelperFunctions.showAlert(
          context: context,
          header: "EDS",
          widget: Text("username is required"),
          btnDoneText: "ok",
          onDone: () {},
          onCancel: () {});
    } else if (txtPasswordController.text == '') {
      HelperFunctions.showAlert(
        context: context,
        header: "EDS",
        widget: Text("password is required"),
        btnDoneText: "ok",
        onDone: () {},
        onCancel: () {},
      );
    } else {
      _callAPILogin(context);
    }
  }

  bool isLoading = false;
  _callAPILogin(BuildContext context) {
    this.setState(() {
      isLoading = true;
    });

    Map<String, dynamic> body = Map<String, dynamic>();
    body['email'] = txtUserNamecontroller.text;
    body['password'] = txtPasswordController.text;

    Map<String, String> header = Map<String, String>();

    FocusScope.of(context).requestFocus(FocusNode());

    ApiManager networkCal = ApiManager(APIConstants.logIn, body, false, header);
    print(APIConstants.baseURL + APIConstants.logIn);
    networkCal.callPostAPI(context).then((response) {
      print('Back from api');

      this.setState(() {
        isLoading = false;
      });

      bool status = response['status'];
      if (status == true) {
        emplyerLogin = EmplyerLogin.fromMap(response);

        logedInUser = emplyerLogin!.response;
        print("Loged in employer id" + logedInUser!.employer.id.toString());
        HelperFunctions.saveInPreference(
            "userId", logedInUser!.employer.id.toString());
        if (logedInUser?.employer.image != null) {
          HelperFunctions.saveInPreference(
              "userImage", logedInUser?.employer.image);
        }

        HelperFunctions.saveInPreference(
          "userName",
          logedInUser!.employer.name,
        );
        HelperFunctions.saveInPreference("Email", logedInUser!.employer.email);

        HelperFunctions.saveInPreference("status", emplyerLogin!.message);
        if (emplyerLogin!.message == "Active") {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => Dashboard(
                    employerId: logedInUser!.employer.id.toString(),
                  )));
        } else {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => WaitingForAdminApproval()));
        }
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

  String? employerid;

  final LocalAuthentication auth = LocalAuthentication();
  _SupportState _supportState = _SupportState.unknown;

  bool _canCheckBiometrics = false;
  List<BiometricType> _availableBiometrics = [];
  String _authorized = 'Not Authorized';
  bool _isAuthenticating = false;

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
              builder: (context) => Dashboard(
                employerId: employerid.toString(),
              ),
            ),
          )
        : setState(() =>
            _authorized = authenticated ? 'Authorized' : 'Not Authorized');
  }

  void _cancelAuthentication() async {
    await auth.stopAuthentication();
    setState(() => _isAuthenticating = false);
  }

  _btnActionSigniLoacalAuth() {
    if (employerid != null && employerid != "") {
      _authenticate();
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
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: size.height * 0.10,
              ),
              Image.asset(
                "assets/images/splash.png",
                height: size.height * 0.12,
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Welcome to EDS",
                style: TextStyle(
                    color: colorSplash,
                    fontSize: size.width * 0.055,
                    fontWeight: FontWeight.w800),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: size.height * 0.04,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.09,
                ),
                child: Text(
                  "Login as Employer ",
                  style: TextStyle(
                      color: colorTex,
                      fontSize: 13,
                      fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: size.height * 0.09,
              ),
              inputWidget(
                icon: Icon(
                  Icons.person_outline_outlined,
                  color: colorTex,
                ),
                hintText: "User email",
                txtController: txtUserNamecontroller,
              ),
              inputWidget(
                icon: Icon(
                  Icons.lock_outline,
                  color: colorTex,
                ),
                hintText: "Password",
                txtController: txtPasswordController,
                isSecure: true,
              ),
              SizedBox(
                height: size.height * 0.03,
              ),
              custom_btn(
                onPressed: () {
                  _btnActionSignIn(context);
                },
                textColor: colorWhite,
                backcolor: colorPrimary,
                text: "Log In",
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
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: size.height * 0.03,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
                child: Text(
                  "Don’t have an account yet? Contact admin to upload your company/business ",
                  style: TextStyle(
                    color: colorTex,
                    fontSize: size.width * 0.039,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: size.height * 0.01,
              ),
              custom_btn(
                textColor: colorTex,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ContactAdmin()),
                  );
                },
                text: "Contact admin",
              )
            ],
          ),
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
