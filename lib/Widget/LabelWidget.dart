import 'package:flutter/material.dart';

import '../Color.dart';

class LabelWidget extends StatelessWidget {
  final String? labelText;

  final TextEditingController? controller;
  final bool? enable;
  final int? max;
  final Icon? icon;
  final isSecure;
  final inputType;

  LabelWidget(
      {Key? key,
      this.labelText,
      this.controller,
      this.enable = true,
      this.max,
      this.icon,
      this.isSecure = false,
      this.inputType})
      : super(key: key);
  @override
  Widget build(BuildContext context) {

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: TextField(

        maxLines: max,
        enabled: enable,
        controller: controller,
        obscureText: this.isSecure,
        keyboardType: inputType,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: TextStyle(color: colorTex),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: colorBorder)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: colorBorder)),
          suffixIcon: icon,
        ),
      ),
    );
  }
}
