import 'package:flutter/material.dart';

class WaitingForAdminApproval extends StatefulWidget {
  WaitingForAdminApproval({Key? key}) : super(key: key);

  @override
  _WaitingForAdminApprovalState createState() =>
      _WaitingForAdminApprovalState();
}

class _WaitingForAdminApprovalState extends State<WaitingForAdminApproval> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: Image.asset(
          "assets/images/waiting.png",
          height: size.width * 0.85,
          width: size.width * 0.85,
        ),
      ),
    );
  }
}
