import 'package:flutter/material.dart';
import 'package:invogen/Screens/Login.dart';
import 'package:invogen/Screens/Splash.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Color(0xff2C3335),
      ),
      home: SplashScreen(),
    );
  }
}

