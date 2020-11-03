import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';


class UpdateAddressScreen extends StatefulWidget {
  @override
  _UpdateAddressScreenState createState() => _UpdateAddressScreenState();
}

class _UpdateAddressScreenState extends State<UpdateAddressScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String newAddress;
  String uid;


  Future<void> updateAddress() async{
    FormState formState = _formKey.currentState;
    if(formState.validate()){
      formState.save();
      try{
        var res = await FirebaseFirestore.instance.collection("Users").doc(uid).collection("UserInfo").doc(uid).update({
          "address": newAddress,
        });
      }catch(e){
        print(e);
      }
    }
  }

  @override
  void initState() {
    uid = FirebaseAuth.instance.currentUser.uid;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Color(0xffeee),
        iconTheme: IconTheme.of(context),
        centerTitle: true,
        title: Text("New Address",style: TextStyle(color: Colors.black),),
      ),
      body: Container(
        padding: EdgeInsets.all(ScreenUtil().setWidth(20)),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    maxLines: 6,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                      ),
                      fillColor: Color(0xffEAF0F1),
                      filled: true,
                      hintText: "New Address here...",
                      hintStyle: TextStyle(fontSize: ScreenUtil().setSp(23)),
                    ),
                    onSaved: (val){
                        setState(() {
                          newAddress = val;
                        });
                    },
                  ),
                  SizedBox(height: ScreenUtil().setHeight(38),),
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(ScreenUtil().setWidth(20)),
                          child: FlatButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(13)
                            ),
                            color: Color(0xff2C3335),
                            onPressed: updateAddress,
                            child: Text("Update Address",style: TextStyle(color: Colors.white),),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

