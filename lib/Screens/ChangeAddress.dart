import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';

import 'UpdateAddress.dart';

class ChangeAddressScreen extends StatefulWidget {
  @override
  _ChangeAddressScreenState createState() => _ChangeAddressScreenState();
}

class _ChangeAddressScreenState extends State<ChangeAddressScreen> {
  String uid;
  String address;

  @override
  void initState() {
    super.initState();
    uid = FirebaseAuth.instance.currentUser.uid;
    getUserDetails();
  }

  Future<void> getUserDetails() async{
    await FirebaseFirestore.instance.collection("Users").doc(uid).collection("UserInfo").get().then((value) => {
      value.docs.forEach((doc) {
        setState(() {
          address = doc.data()["address"];
        });
      })
    });

  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: false);
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Color(0xffeee),
        iconTheme: IconTheme.of(context),
        centerTitle: true,
        title: Text("Company Address",style: TextStyle(color: Colors.black),),
      ),
      body: Container(
        padding: EdgeInsets.all(ScreenUtil().setWidth(30)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Seller Address : ",style: TextStyle(color: Color(0xff333945),fontSize: ScreenUtil().setSp(30),fontStyle: FontStyle.italic),),
            SizedBox(height: ScreenUtil().setHeight(30),),
            Container(
              width: MediaQuery.of(context).size.width*0.8,
                child: Text(address.toString(),style: TextStyle(fontSize: ScreenUtil().setSp(26)),)),
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
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => UpdateAddressScreen()));
                      },
                      child: Text("Change Address",style: TextStyle(color: Colors.white),),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
