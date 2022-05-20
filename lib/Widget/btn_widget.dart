import 'package:flutter/material.dart';

import '../Color.dart';

class custom_btn extends StatelessWidget {
  final String text;
  late final VoidCallback? onPressed;
  late final Color? backcolor;
  late final Color? textColor;

  custom_btn(
      {Key? key,
      this.text = "",
      this.onPressed,
      this.backcolor,
      this.textColor})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          color: backcolor,
          borderRadius: BorderRadius.circular(20.0),
          border: Border.all(color: colorTex, width: 0.9),
        ),
        margin: EdgeInsets.symmetric(horizontal: 30, vertical: 8),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
                fontSize: 16, color: textColor, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
