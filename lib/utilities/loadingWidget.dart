import 'package:flutter/material.dart';
loadingWidget(BuildContext context) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return Center(child: CircularProgressIndicator(color: Color(0xFF17C5CC)));
    },
  );
}