import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:invogen/Screens/Dashboard.dart';
import 'package:invogen/Screens/Login.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {


  Future<Timer> loadData() async {
    return Timer(Duration(milliseconds: 1700,),() {
      checkUserLog();
    });
  }

  Future<void> checkUserLog() async{
    if(FirebaseAuth.instance.currentUser == null){
      Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
    }else{
      Navigator.push(context, MaterialPageRoute(builder: (context) => DashboardScreen()));
    }
  }

  @override
  void initState() {
    Firebase.initializeApp().whenComplete(() {
      print("completed");
      setState(() {});
    });
    super.initState();
    loadData();
  }



  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: false);
    return Scaffold(
      body: Stack(
        children: [
          Center(child: Text("invogen",style: GoogleFonts.ubuntu(textStyle: TextStyle(fontSize: ScreenUtil().setSp(110),fontWeight: FontWeight.bold)),)),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: ScreenUtil().setHeight(1)),
                child: Text("@Verac association",style: TextStyle(color: Colors.grey,fontSize: ScreenUtil().setSp(25)),)),
          )
        ]
      ),
    );
  }
}
