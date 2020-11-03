import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:invogen/Screens/AddProduct.dart';
import 'package:invogen/Screens/DeleteProduct.dart';
import 'package:invogen/Screens/UpdateProduct.dart';
import 'package:pin_entry_text_field/pin_entry_text_field.dart';

class AdminAuthScreen extends StatefulWidget {
  final int screenInt;

  AdminAuthScreen({this.screenInt});

  @override
  _AdminAuthScreenState createState() => _AdminAuthScreenState();
}

class _AdminAuthScreenState extends State<AdminAuthScreen> {
  String pin = "1234";
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: false);
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Color(0xffeee),
        iconTheme: IconTheme.of(context),
        centerTitle: true,
        title: Text("Enter Admin PIN",style: TextStyle(color: Colors.black),),
      ),
      body: Container(
        child: Column(
          children: [
            SizedBox(height: ScreenUtil().setHeight(100),),
            Image.asset("assets/images/pin.png",
              height: ScreenUtil().setHeight(200),
              width: ScreenUtil().setWidth(200),
            ),
            SizedBox(height: ScreenUtil().setHeight(20),),
            PinEntryTextField(
              showFieldAsBox: true,
              isTextObscure: true,
              onSubmit: (String val){
                  if(val == pin) {
                    switch(widget.screenInt) {
                      case 0: {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => AddProductScreen()));
                      }break;
                      case 1: {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => UpdateProductScreen()));
                      }break;
                      case 2: {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => DeleteProductScreen()));
                      }break;
                      default: {
                        print("Something went Wrong");
                      }
                    }
                  }
                  else{
//                    showDialog(
//                        context: context,
//                        builder: (context){
//                          return AlertDialog(
//                            title: Icon(Icons.error,color: Colors.redAccent,size: 50,),
//                            content: Row(
//                              mainAxisAlignment: MainAxisAlignment.center,
//                              children: [
//                                Text("*Invalid Pin*",style: TextStyle(
//                                  fontSize: ScreenUtil().setSp(36),
//                                  fontWeight: FontWeight.bold,
//                                  letterSpacing: 1.5
//                                ),)
//                              ],),
//
//                          );
//                        }
//                    );
                    AwesomeDialog(
                      context: context,
                      width: 480,
                      dialogType: DialogType.WARNING,
                      headerAnimationLoop: false,
                      animType: AnimType.BOTTOMSLIDE,
                      title: 'Invalid',
                      desc: "Password does not match",
//                      btnCancelOnPress: () {
////                                  dismiss()
//                      },
//                      btnOkOnPress: () {
//                      },
                    )..show();
                  }
              }, // end onSubmit
            ),
          ],
        ), // end,
      ),
    );
  }
}


