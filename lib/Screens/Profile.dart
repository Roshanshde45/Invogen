import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:invogen/Screens/Login.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String uid;
  String _name,_email,_phone,_adminPass,_bName,_bImage,_brandEmail,_brandWeb;
  
  @override
  void initState() {
    uid = FirebaseAuth.instance.currentUser.uid;
    _email = FirebaseAuth.instance.currentUser.email;
    _name = FirebaseAuth.instance.currentUser.displayName;
    getUserDetails();
    print(uid);
    super.initState();
  }

  Future <LoginScreen> SignOut() async{
    await FirebaseAuth.instance.signOut();
    return new LoginScreen();
  }
  
  Future<void> getUserDetails() async{
     await Firestore.instance.collection("Users").doc(uid).collection("UserInfo").get().then((value) => {
         value.docs.forEach((doc) {
           setState(() {
             _name = doc.data()["name"];
             _phone = doc.data()["phone"];
             _adminPass = doc.data()["pin"].toString();
             _bName = doc.data()["brandName"];
             _bImage = doc.data()["bImageURL"];
             _brandEmail = doc.data()["brandEmail"];
             _brandWeb = doc.data()["brandWeb"];
           });
         })
     });
  }
  
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: false);
    return Scaffold(
      backgroundColor: Color(0xff2C3335),
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Color(0xff2C3335),
        centerTitle: false,
        title: Text("Profile",style: TextStyle(color: Colors.white),),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: (){},
          )
        ],
      ),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.only(left: ScreenUtil().setWidth(30)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: ScreenUtil().setHeight(25),),
                   FadeInImage.assetNetwork(placeholder: "assets/images/noImage.png",height: ScreenUtil().setWidth(200), image: _bImage,fit: BoxFit.cover,),
                  SizedBox(height: ScreenUtil().setHeight(30),),
                  Text(_name.toString(),style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(50)),),
                  SizedBox(height: ScreenUtil().setHeight(20),)
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SingleChildScrollView(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(topRight: Radius.circular(30),topLeft: Radius.circular(30)),
                  color: Colors.white
                ),
                padding: EdgeInsets.all(ScreenUtil().setWidth(30)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: ScreenUtil().setHeight(40),),
                    Text("Account Holder Details",style: GoogleFonts.ubuntu(textStyle: TextStyle(fontSize: ScreenUtil().setSp(40),fontWeight: FontWeight.w400)),),
                    SizedBox(height: ScreenUtil().setHeight(48),),
                    Text("Name",style: TextStyle(color: Colors.grey,fontSize: ScreenUtil().setSp(26)),),
                    Text("$_name",style: TextStyle(fontSize: ScreenUtil().setSp(28)),),

                    SizedBox(height: ScreenUtil().setHeight(30),),
                    Text("Email",style: TextStyle(color: Colors.grey,fontSize: ScreenUtil().setSp(26)),),
                    Text("$_email",style: TextStyle(fontSize: ScreenUtil().setSp(28)),),
//                      Container(
//                        height: 1,
//                        color: Colors.grey,
//                      ),
                    SizedBox(height: ScreenUtil().setHeight(30),),
                    Text("Phone",style: TextStyle(color: Colors.grey,fontSize: ScreenUtil().setSp(26)),),
                    Text("+91 $_phone",style: TextStyle(fontSize: ScreenUtil().setSp(28)),),
//                      Container(
//                        height: 1,
//                        color: Colors.grey,
//                      ),
                    SizedBox(height: ScreenUtil().setHeight(30),),
                    Text("Admin Password",style: TextStyle(color: Colors.grey,fontSize: ScreenUtil().setSp(26)),),
                    Text("$_adminPass",style: TextStyle(fontSize: ScreenUtil().setSp(28)),),
//                      Container(
//                        height: 1,
//                        color: Colors.grey,
//                      ),
                    SizedBox(height: ScreenUtil().setHeight(30),),
                    Text("Brand Name",style: TextStyle(color: Colors.grey,fontSize: ScreenUtil().setSp(26)),),
                    Text("$_bName",style: TextStyle(fontSize: ScreenUtil().setSp(28)),),
//                      Container(
//                        height: 1,
//                        color: Colors.grey,
//                      ),
                    SizedBox(height: ScreenUtil().setHeight(30),),
                    Text("Brand Website",style: TextStyle(color: Colors.grey,fontSize: ScreenUtil().setSp(26)),),
                    Text(_brandWeb,style: TextStyle(fontSize: ScreenUtil().setSp(28)),),
//                      Container(
//                        height: 1,
//                        color: Colors.grey,
//                      ),
                    SizedBox(height: ScreenUtil().setHeight(30),),
                    Row(
                      children: [
                        Expanded(
                          child: FlatButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)
                            ),
                            child: Text("Edit Profile",style: TextStyle(color: Colors.white)),
                            onPressed: (){},
                            color: Color(0xff2C3335),
                          ),
                        )  ,
                        SizedBox(width: ScreenUtil().setWidth(15),),
                        Expanded(
                          child: FlatButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)
                            ),
                            child: Text("Sign out",style: TextStyle(color: Colors.white),),
                            onPressed: SignOut,
                            color: Color(0xff2C3335),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: ScreenUtil().setHeight(50),),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
