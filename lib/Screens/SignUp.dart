import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:invogen/Screens/Dashboard.dart';
import 'package:invogen/Screens/Login.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:progress_dialog/progress_dialog.dart';


class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
ProgressDialog progressDialog;
String _name,_email,_password,_brandName,_address,_phone,_brandWeb,_brandEmail;
File _image;
int _pin,_cpin;
String uid;
GlobalKey<FormState> _formKey = GlobalKey<FormState>();

Future<FirebaseUser> createAccount(BuildContext context) async{
  String _uid = "";
  String url;
  final formstate = _formKey.currentState;
  if(formstate.validate()) {
    await progressDialog.show();
    formstate.save();
    try{
      String filename = basename(_image.path);
      StorageReference firebaseStrorageRef = FirebaseStorage.instance.ref().child(filename);
      UserCredential  userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: _email, password: _password);
      if(userCredential != null){
        _uid = userCredential.user.uid;
        StorageUploadTask uploadTask = firebaseStrorageRef.putFile(_image);
        StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
        if(taskSnapshot.error == null) {
          url = await taskSnapshot.ref.getDownloadURL();
          print(url);
        } else {
          await progressDialog.hide();
          print(taskSnapshot.error);
        }
        print(_uid);
        var  user = FirebaseFirestore.instance.collection("Users").doc(_uid).collection("UserInfo").doc(_uid).set({
          "name": _name,
          "phone": _phone,
          "address": _address,
          "brandName": _brandName,
          "pin": _pin,
          "bImageURL": url,
          "uid": _uid,
          "brandWeb": _brandWeb,
          "brandEmail": _brandEmail,
        }).then((value) => userCredential.user.updateProfile(displayName: _name));
        await progressDialog.hide();
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DashboardScreen()));
      }
    } on FirebaseAuthException catch(e) {
        print(e);
        await progressDialog.hide();
    }catch(e){
      print(e);
      await progressDialog.hide();
    }
  }
}

Future getImage() async{
  var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);
  setState(() {
    _image = tempImage;
  });
}


@override
  void initState() {
    getUid();
    super.initState();
  }

void getUid() async{
  String Userid;
  Userid = await FirebaseAuth.instance.currentUser.uid;
  setState(() {
    uid = Userid;
  });
  print(uid);
}


  @override
  Widget build(BuildContext context) {

    progressDialog = ProgressDialog(
      context,
      type: ProgressDialogType.Normal,
    );
    progressDialog.style(
        message: 'Setting up...',
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
      body: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xffeee),
          elevation: 0.0,
          title:  Text("Create New Account ",style: GoogleFonts.ubuntu(fontStyle: FontStyle.normal,fontSize: ScreenUtil().setSp(40),color: Colors.black)),
          centerTitle:  true,
          iconTheme: IconTheme.of(context),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(left: ScreenUtil().setWidth(23),right: ScreenUtil().setWidth(23)),
            alignment: Alignment.topLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: ScreenUtil().setHeight(10)),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: ScreenUtil().setWidth(6)),
                          child: Text("Email")),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30)
                        ),
                        child: TextFormField(
                          decoration: InputDecoration(
//                            labelText: "Email",
//                            labelStyle: TextStyle(color: Colors.black),
//                            floatingLabelBehavior: FloatingLabelBehavior.always,
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
                        ),
                      ),
                      SizedBox(height: ScreenUtil().setHeight(17),),
                      Padding(
                          padding: EdgeInsets.only(left: ScreenUtil().setWidth(6)),
                          child: Text("Password")),
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
                          border: InputBorder.none,
                          filled: true,
                          fillColor: Color(0xffDAE0E2),
                          suffixIcon: Icon(Icons.remove_red_eye),
                        ),
                      ),
                      SizedBox(height: ScreenUtil().setHeight(17),),
                      Padding(
                          padding: EdgeInsets.only(left: ScreenUtil().setWidth(6)),
                          child: Text("Full Name")),
                      TextFormField(
                        decoration: InputDecoration(
                          filled: true,
                          border: InputBorder.none,
                          fillColor: Color(0xffDAE0E2),
                        ),
                        keyboardType: TextInputType.name,
                        onSaved: (val) {
                          _name = val;
                        },
                        validator: (val) {
                          if(val.isEmpty) {
                            return "Name is necessary";
                          }
                        },
                      ),
                      SizedBox(height: ScreenUtil().setHeight(17),),
                      Padding(
                          padding: EdgeInsets.only(left: ScreenUtil().setWidth(6)),
                          child: Text("Phone")),
                      TextFormField(
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          filled: true,
                          fillColor: Color(0xffDAE0E2),
                        ),
                        onSaved: (val) {
                          _phone = val;
                        },
                        validator: (val) {
                          if(val.isEmpty) {
                            return "Invalid Email";
                          }else if(val.length<10) {
                            return "Enter valid Phone Number";
                          }
                        },
                        maxLength: 10,
                      ),
                      SizedBox(height: ScreenUtil().setHeight(17),),
                      Padding(
                          padding: EdgeInsets.only(left: ScreenUtil().setWidth(6)),
                          child: Text("Permanent Address")),
                      TextFormField(
                        decoration: InputDecoration(
                          helperText: "*Company Billing Address",
                          border: InputBorder.none,
                          filled: true,
                          fillColor: Color(0xffDAE0E2),
                        ),
                        keyboardType: TextInputType.streetAddress,
                        maxLines: 4,
                        onSaved: (val) {
                          _address = val;
                        },
                        validator: (val) {
                          if(val.isEmpty) {
                            return "Invalid Address";
                          }
                        },
                      ),
                      SizedBox(height: ScreenUtil().setHeight(27),),
                      Padding(
                          padding: EdgeInsets.only(left: ScreenUtil().setWidth(6)),
                          child: Text("Brand Name")),
                      TextFormField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          filled: true,
                          fillColor: Color(0xffDAE0E2),
                        ),
                        onSaved: (val) {
                          _brandName = val;
                        },
                        validator: (val) {
                          if(val.isEmpty) {
                            return "Brand Name should not be empty";
                          }
                        },
                      ),
                      SizedBox(height: ScreenUtil().setHeight(17),),
                      Padding(
                          padding: EdgeInsets.only(left: ScreenUtil().setWidth(6)),
                          child: Text("Brand Website")),
                      TextFormField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          filled: true,
                          fillColor: Color(0xffDAE0E2),
                          hintText: "www.abc.com",
                          hintStyle: TextStyle(fontSize: ScreenUtil().setSp(20))
                        ),
                        onSaved: (val) {
                          _brandWeb = val;
                        },
                        validator: (val) {
                          if(val.isEmpty) {
                            return "Brand Website should not be empty";
                          }
                        },
                      ),
                      SizedBox(height: ScreenUtil().setHeight(17),),
                      Padding(
                          padding: EdgeInsets.only(left: ScreenUtil().setWidth(6)),
                          child: Text("Brand Email Address")),
                      TextFormField(
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            filled: true,
                            fillColor: Color(0xffDAE0E2),
//                            hintText: "www.abc.com",
//                            hintStyle: TextStyle(fontSize: ScreenUtil().setSp(20))
                        ),
                        onSaved: (val) {
                          _brandEmail = val;
                        },
                        validator: (val) {
                          if(val.isEmpty) {
                            return "Brand Email Address should not be empty";
                          }
                        },
                      ),
                      SizedBox(height: ScreenUtil().setHeight(17),),
                      Padding(
                          padding: EdgeInsets.only(left: ScreenUtil().setWidth(6)),
                          child: Text("Create Admin PIN")),
                      TextFormField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          filled: true,
                          fillColor: Color(0xffDAE0E2),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (val) {
                          if(val.isEmpty) {
                            return "Create PIN";
                          }
                        },
                        onSaved: (val) {
                          _pin = int.parse(val);
                        },
                        maxLength: 4,
                        obscureText: true,
                      ),
                      SizedBox(height: ScreenUtil().setHeight(17),),
                      Padding(
                          padding: EdgeInsets.only(left: ScreenUtil().setWidth(6)),
                          child: Text("Re-Enter Admin PIN")),
                      TextFormField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          helperText: "Re-enter PIN",
                          filled: true,
                          fillColor: Color(0xffDAE0E2),
                        ),
                        keyboardType: TextInputType.number,
                        onSaved: (val) {
                          _cpin = int.parse(val);
                        },
                        validator: (val) {
                          if(val.isEmpty) {
                            return "Create PIN";
                          }
                        },
                        obscureText: true,
                        maxLength: 4,
                      ),
                      SizedBox(height: ScreenUtil().setHeight(50),),
                      Material(
                        child: InkWell(
                          onTap: (){
                            getImage();
                          },
                          child: Container(
//                            height: ScreenUtil().setHeight(200),
//                            width: ScreenUtil().setWidth(300),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10)
                            ),
                            child: Column(
                              children: [
                                _image == null? Image.asset("assets/images/pickimg.png",
                                  height: ScreenUtil().setHeight(200)
                                  ,width: ScreenUtil().setWidth(300),): enableupload(),
                                SizedBox(height: ScreenUtil().setHeight(8),),
                                Text("Select Brand Logo",style: GoogleFonts.ubuntu(
                                    textStyle: TextStyle(
                                        fontWeight: FontWeight.w300,
                                        letterSpacing: 1
                                    )),)
                              ],
                            )
                          ),
                        ),
                      ),
                      SizedBox(height: ScreenUtil().setHeight(30),)
                    ],
                  )
                ),
                Row(
                  children: [
                    Expanded(
                      child: FlatButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        onPressed: () {
                          createAccount(context);
//                          uploadPic(context,uid);
                        },
                        child: Padding(
                            padding: EdgeInsets.fromLTRB(0, 14, 0, 14),
                            child: Text("Sign Up",style: TextStyle(color: Colors.white),)),
                        color: Color(0xff2C3335),
                      ),
                    )
                  ],
                ),
                SizedBox(height: ScreenUtil().setHeight(30),),
                GestureDetector(
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Already having account!",style: GoogleFonts.ubuntu(fontStyle: FontStyle.normal,fontSize: ScreenUtil().setSp(25),color: Colors.grey),),
                      ]
                    ),
                ),
                SizedBox(height: ScreenUtil().setHeight(100),),
                ]
            ),
          ),
        ),
      ),
    );
  }

  Widget enableupload() {
    return Container(
      child: Image.file(
        _image,
        height: ScreenUtil().setHeight(200),
        width: ScreenUtil().setWidth(300),),
    );
  }
}
