import 'package:eds/LoginType.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'provider/core_provider.dart';

void main() async {
  runApp( MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => CoreProvider())],child:

      MyApp()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginType(),
    );
  }
}
