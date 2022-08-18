import 'package:eds/LoginToEmployeer/printExpences.dart';
import 'package:eds/LoginType.dart';
import 'package:eds/shared%20pref/share_pref.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'provider/core_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  await UserPreferences.init();
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
      home:
      // PrintDetailsScreen(empId: '',)

      LoginType(),
    );
  }
}
