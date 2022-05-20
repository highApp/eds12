import 'package:flutter/material.dart';

import '../Color.dart';

class inputWidget extends StatelessWidget {
  final Icon? icon;
  final String hintText;
  final txtController;
  bool isSecure;

  inputWidget(
      {this.hintText = "",
      this.icon,
      this.txtController,
      this.isSecure = false});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: colorInput)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: TextField(
          cursorColor: colorBlack,
          decoration: InputDecoration(
              border: InputBorder.none,
              prefixIcon: icon,
              hintText: hintText,
              hintStyle: TextStyle(color: colorTex),
              contentPadding: EdgeInsets.symmetric(vertical: 18)),
          controller: txtController,
          obscureText: isSecure,
        ),
      ),
    );
  }
}
