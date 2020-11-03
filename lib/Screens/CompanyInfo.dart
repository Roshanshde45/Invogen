import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:invogen/Screens/ChangeAddress.dart';
import 'package:invogen/Screens/ChangeLogo.dart';
import 'package:invogen/Screens/TermsCondition.dart';

class CompanyInfoScreen extends StatefulWidget {
  @override
  _CompanyInfoScreenState createState() => _CompanyInfoScreenState();
}

class _CompanyInfoScreenState extends State<CompanyInfoScreen> {
  bool contact = true;
  String uid;
  
  Future<void> saveSettings(bool enabled) async{
    var res = await FirebaseFirestore.instance.collection("Users").doc(uid).collection("Settings").doc(uid).set({
      "contactEnabled": enabled
    }).then((value) => print("settings Saved"));
  }

  @override
  void initState() {
    uid = FirebaseAuth.instance.currentUser.uid;
    super.initState();
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
        title: Text("Invoice Settings",style: TextStyle(color: Colors.black),),
      ),
      body: Container(
        child: Column(
          children: [
            ListTile(
              title: Text("Brand Logo"),
              subtitle: Text("Change brand logo"),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => ChangeLogoScreen()));
              },
            ),
            Divider(),
            ListTile(
              title: Text("Billing Address"),
              subtitle: Text("Address of the company"),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => ChangeAddressScreen()));
              },
            ),
            Divider(),
            ListTile(
              title: Text("Terms & Conditions"),
              subtitle: Text("T&C included in Invoice"),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => TermsConditionScreen()));
              },
            ),
            Divider(),
            ListTile(
              title: Text("Enable Contacts Details"),
              subtitle: contact? Row(
                children: [
                  Container(height: ScreenUtil().setHeight(10),width: ScreenUtil().setWidth(10),
                  decoration: BoxDecoration(color: Colors.greenAccent,borderRadius: BorderRadius.circular(50)),),
                  SizedBox(width: ScreenUtil().setWidth(10),),
                  Text("Enabled"),
                ],
              ): Row(
                children: [
                  Container(height: ScreenUtil().setHeight(10),width: ScreenUtil().setWidth(10),
                    decoration: BoxDecoration(color: Colors.redAccent,borderRadius: BorderRadius.circular(50)),),
                  SizedBox(width: ScreenUtil().setWidth(10),),
                  Text("Disabled"),
                ],
              ),
              onTap: (){
                setState(() {
                  contact = !contact;
                });
                saveSettings(contact);
              },
            ),
          ],
        ),
      ),
    );
  }
}
