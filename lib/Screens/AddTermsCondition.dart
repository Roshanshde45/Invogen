import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';

class AddTermsConditionScreen extends StatefulWidget {
  @override
  _AddTermsConditionScreenState createState() => _AddTermsConditionScreenState();
}

class _AddTermsConditionScreenState extends State<AddTermsConditionScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String uid;
  List terms = [];

  Future<void> addOldTerms() async{
    List Terms = [];
    var result = await FirebaseFirestore.instance.collection("Users").doc(uid).collection("UserInfo").doc(uid).get().then((value){
      Terms = value.data()["terms"];
    }).then((value) => {
    if(Terms != null) {
        setState(() {
          terms = Terms;
        })
      }
    });
    print(terms);
  }
  
  Future<void> addNewTerms() async{
    FormState formState = _formKey.currentState;
    print(terms);
    if(formState.validate()){
      formState.save();
      await FirebaseFirestore.instance.collection("Users").doc(uid).collection("UserInfo").doc(uid).update({
        "terms": terms
      }).then((value) => Navigator.pop(context));
    }
  }
  
  @override
  void initState() {
    uid = FirebaseAuth.instance.currentUser.uid;
    super.initState();
    addOldTerms();
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
        title: Text("Add new Terms & Conditions*",style: TextStyle(color: Colors.black),),
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
                      hintText: "Type new Term & Condition here...",
                      hintStyle: TextStyle(fontSize: ScreenUtil().setSp(23))
                    ),
                    onSaved: (val) {
                      setState(() {
                        terms.add(val);
                        print(terms);
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
                            onPressed: addNewTerms,
                            child: Text("Add new T&C",style: TextStyle(color: Colors.white),),
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
