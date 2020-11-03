import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:invogen/Screens/Login.dart';
import 'SignUp.dart';


class RegisterUserScreen extends StatefulWidget {
  @override
  _RegisterUserScreenState createState() => _RegisterUserScreenState();
}

class _RegisterUserScreenState extends State<RegisterUserScreen> {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: false);
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(20),
        child: Stack(
//          crossAxisAlignment: CrossAxisAlignment.center,
//          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Hero(
                    tag: "invogen",
                      child: Image.asset("assets/images/invogenlogo.png",
                        height: ScreenUtil().setHeight(300),
                        width: ScreenUtil().setWidth(300),)),
                  SizedBox(height: ScreenUtil().setHeight(20),),
                  Text("Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s,",style: TextStyle(fontSize: ScreenUtil().setSp(30),color: Colors.grey),textAlign: TextAlign.center),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                alignment: Alignment.center,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: FlatButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => SignUpScreen()),
                              );
                            },
                            child: Padding(
                                padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
                                child: Text("Sign Up",style: TextStyle(color: Colors.white),)),
                            color: Color(0xff2C3335),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: ScreenUtil().setHeight(10),),
                    Row(
                      children: [
                        Expanded(
                          child: OutlineButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => LoginScreen()),
                              );
                            },
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
                                child: Text("Log in",style: TextStyle(color: Colors.black),)),
                            color: Color(0xff2C3335),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
