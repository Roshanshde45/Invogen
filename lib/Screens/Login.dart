

import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:invogen/Screens/Dashboard.dart';
import 'package:invogen/Screens/SignUp.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:progress_dialog/progress_dialog.dart';


class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  ProgressDialog progressDialog;
  String _email,_password;
  String uid;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    Firebase.initializeApp().whenComplete(() {
      print("completed");
      setState(() {});
    });
    super.initState();
    checkUserLog();
  }


  Future<void> _logIn() async {
    final formState = _formKey.currentState;
    if(formState.validate()){
      formState.save();
//      await progressDialog.show();
      try{
          await FirebaseAuth.instance.signInWithEmailAndPassword(email: _email, password: _password);
//          progressDialog.hide();
          Navigator.push(context, MaterialPageRoute(builder: (context) => DashboardScreen()));
      }catch (e){
        print(e);
      }

    }
  }

  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Enter Valid Email';
    else
      return null;
  }

  Future<void> checkUserLog() async{
//    await FirebaseAuth.instance.currentUser.then((currentUser){
//      if(currentUser != null){
//        Navigator.pushNamed(context, '/new');
//        print(authRes);
//      }else{
//        Navigator.pushNamed(context, '/GettingStarted');
//        print(authRes);
//      }
//    }).catchError((err) => print(err));
  var res = await FirebaseAuth.instance.currentUser.uid;
      if(res!=null){
        Navigator.push(context, MaterialPageRoute(builder: (context) => DashboardScreen()));
      }
      else{

      }
  }

  @override
  Widget build(BuildContext context) {
    progressDialog = ProgressDialog(
      context,
      type: ProgressDialogType.Normal,
    );
    progressDialog.style(
        message: 'Loading...',
        borderRadius: 10.0,
        backgroundColor: Colors.white,
        progressWidget: Container(
          child: SpinKitRing(size: 45,color: Colors.blue,lineWidth: 2.3,),
          height: 20,
          width: 20,
        ),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        progress: 0.0,
        maxProgress: 100.0,
        progressTextStyle: TextStyle(
            color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600)
    );


    ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: false);
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.fromLTRB(ScreenUtil().setWidth(55), 0,ScreenUtil().setWidth(60), 0),
          alignment: Alignment.topLeft,
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: ScreenUtil().setHeight(40),),
//                Image.asset("assets/images/invogen.png",width: ScreenUtil().setWidth(80),height: ScreenUtil().setHeight(80),),
                  Text("invogen",style: GoogleFonts.ubuntu(textStyle: TextStyle(fontSize: ScreenUtil().setSp(60),fontWeight: FontWeight.bold)),),
                  SizedBox(height: ScreenUtil().setHeight(100),),
                  Text("Welcome back!",style: TextStyle(color: Color(0xff2C3335),fontSize: ScreenUtil().setSp(70),fontWeight: FontWeight.w300),),
                  Text("Sign in to continue",style: TextStyle(color: Color(0xff616C6F),fontSize: ScreenUtil().setSp(70),fontWeight: FontWeight.w300)),
                  Text("to invogen.",style: TextStyle(color: Color(0xff616C6F),fontSize: ScreenUtil().setSp(70),fontWeight: FontWeight.w300)),
                  SizedBox(height: ScreenUtil().setHeight(70),),
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          decoration: InputDecoration(
                              hintText: "Email",
                          border: InputBorder.none,
                              fillColor: Color(0xffDAE0E2),
                              filled: true
                          ),
                          onSaved: (val) {
                            _email = val;
                          },
                          validator: (val) {
                            if(val.isEmpty) {
                              return "Please enter your Email";
                            }
                          },
                          keyboardType: TextInputType.emailAddress,
                        ),
                        SizedBox(height: ScreenUtil().setHeight(20),),
                        TextFormField(
                          obscureText: true,
                          cursorWidth: 1,
                          onSaved: (val) {
                            _password = val;
                          },
                          validator: (val) {
                            if(val.isEmpty) {
                              return "Invalid Password";
                            }
                            else if(val.length<8){
                              return "password should pe of 8 characters";
                            }
                          },
                          decoration: InputDecoration(
                            hintText: "Password",
                            border: InputBorder.none,
                            filled: true,
                            fillColor: Color(0xffDAE0E2),
                            suffixIcon: Icon(Icons.remove_red_eye),
                          ),
                        ),
                        SizedBox(height: ScreenUtil().setHeight(20),),
                      ],
                    ),
                  ),
//                Row(
//                  mainAxisAlignment: MainAxisAlignment.end,
//                  children: [
//                    GestureDetector(
//                      onTap: _logIn,
//                      child: Container(
//                        alignment: Alignment.center,
//                        height: ScreenUtil().setHeight(75),
//                        width: ScreenUtil().setWidth(200),
//                        decoration: BoxDecoration(
//                            color: Color(0xff2C3335),
//                            borderRadius: BorderRadius.circular(10)
//                        ),
//                        child: Row(
//                          mainAxisAlignment: MainAxisAlignment.center,
//                          children: [
//                            Text("Login",style: TextStyle(color: Colors.white),),
//                            SizedBox(width: ScreenUtil().setWidth(10),),
//                            Icon(Icons.arrow_forward,color: Colors.white,)
//                          ],
//                        ),
//                      ),
//                    ),
//                  ],
//                )
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ArgonButton(
                        height:ScreenUtil().setHeight(70),
                        roundLoadingShape: true,
                        width: MediaQuery.of(context).size.width * 0.30,
                        onTap: (startLoading, stopLoading, btnState) {
                          if (btnState == ButtonState.Idle) {
                            startLoading();
                            _logIn();
                          } else {
                            stopLoading();
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Login",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700),
                            ),
                            SizedBox(width: ScreenUtil().setWidth(10),),
                            Icon(Icons.arrow_forward,color: Colors.white,)
                          ],
                        ),
                        loader: Container(
                          padding: EdgeInsets.all(10),
                          child: SpinKitRing(
                            color: Colors.white,
                            lineWidth: 3,
                            // size: loaderWidth ,
                          ),
                        ),
                        borderRadius: 5.0,
                        color: Color(0xFF2C3335),
                      ),
                    ],
                  ),
                ],
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.only(bottom: ScreenUtil().setHeight(23)),
                  child: GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (_) => SignUpScreen()));
                    },
                    child: RichText(
                      text: TextSpan(
                        text: "Don't have an account?  ",
                        style: TextStyle(color: Colors.grey[500],fontSize: ScreenUtil().setSp(25)),
                        children: [
                              TextSpan(
                                text: "Sign up",
                                style: TextStyle(color: Colors.grey[700],fontSize: ScreenUtil().setSp(25))
                              ),
                        ]
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )
        ),
      ),
    );
  }
}
