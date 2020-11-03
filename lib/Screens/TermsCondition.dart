import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:invogen/Screens/AddTermsCondition.dart';

import 'DeleteTermsCondition.dart';

class TermsConditionScreen extends StatefulWidget {
  @override
  _TermsConditionScreenState createState() => _TermsConditionScreenState();
}

class _TermsConditionScreenState extends State<TermsConditionScreen> {
  String uid;
  List terms = [];

  Future<void> getTerms() async{
    List Terms = [];
    var result = await FirebaseFirestore.instance.collection("Users").doc(uid).collection("UserInfo").doc(uid).get().then((value){
      Terms = value.data()["terms"];
      setState(() {
        terms = Terms;
      });
    });
    print(terms);
  }

  @override
  void initState() {
    uid = FirebaseAuth.instance.currentUser.uid;
    super.initState();
    getTerms();
  }

  refresh() {
    getTerms();
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
        title: Text("Terms & Conditions*",style: TextStyle(color: Colors.black),),
        actions: [
          IconButton(icon: Icon(Icons.refresh), onPressed: refresh)
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(ScreenUtil().setWidth(25)),
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(ScreenUtil().setWidth(30)),
              decoration: BoxDecoration(
                color: Color(0xffEAF0F1),
                borderRadius: BorderRadius.circular(10)
              ),
              child: terms != null ? Column(
                crossAxisAlignment:  CrossAxisAlignment.start,
                children:  terms.map((e) => Text("*$e\n",style: TextStyle(fontSize: ScreenUtil().setSp(27)),textAlign: TextAlign.start,)).toList()
              ): Container(
                child: Center(
                  child: Text("No Terms Or Condition Added !!"),
                ),
              )
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
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => AddTermsConditionScreen()));
                      },
                      child: Text("Add",style: TextStyle(color: Colors.white),),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(ScreenUtil().setWidth(20)),
                    child: FlatButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(13)
                      ),
                      color: Color(0xff2C3335),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => DeleteTermsConditionScreen(terms: terms)));
                      },
                      child: Text("Delete",style: TextStyle(color: Colors.white),),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
