import 'package:flutter/material.dart';

import '../Color.dart';

class Activation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorWhite,
      body: Center(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 30),
          child: Flexible(child: Image.asset("assets/images/activation.png")),
        ),
      ),
    );
  }
}
