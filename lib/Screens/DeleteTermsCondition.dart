import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';

class DeleteTermsConditionScreen extends StatefulWidget {
  List terms;
  DeleteTermsConditionScreen({this.terms});

  @override
  _DeleteTermsConditionScreenState createState() => _DeleteTermsConditionScreenState();
}

class _DeleteTermsConditionScreenState extends State<DeleteTermsConditionScreen> {
  List Terms = [];
  String uid;

  @override
  void initState() {
    uid = FirebaseAuth.instance.currentUser.uid;
    super.initState();
    getTerms();
//    Terms = widget.terms;
  }


  deleteTerm(String term) async{
    DocumentReference docref = FirebaseFirestore.instance.collection("Users").doc(uid).collection("UserInfo").doc(uid);
    DocumentSnapshot doc = await docref.get();
    List terms = doc.data()["terms"];
      if(terms.contains(term) == true){
        docref.update({
          "terms": FieldValue.arrayRemove([term])
        });
        refresh();
      }else {
        print("Not deleted");
      }
  }


  Future<void> getTerms() async{
    List terms = [];
    var result = await FirebaseFirestore.instance.collection("Users").doc(uid).collection("UserInfo").doc(uid).get().then((value){
      terms = value.data()["terms"];
      setState(() {
        Terms = terms;
      });
    });
    print(Terms);
  }

  refresh() {
    setState(() {
      getTerms();
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
        title: Text("Delete Terms & Conditions*",style: TextStyle(color: Colors.black),),
        actions: [
          IconButton(icon: Icon(Icons.refresh), onPressed: getTerms)
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(ScreenUtil().setWidth(16)),
        child: Column(
          children: [
            SizedBox(height: ScreenUtil().setHeight(20),),
            Container(
              padding: EdgeInsets.all(ScreenUtil().setWidth(30)),
              decoration: BoxDecoration(
                  color: Color(0xffEAF0F1),
                  borderRadius: BorderRadius.circular(15)
              ),
              child: Column(
                  crossAxisAlignment:  CrossAxisAlignment.start,
                  children: Terms != null? Terms.map((e) => Column(
                        children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  icon: Image.asset("assets/images/cross.png",height: ScreenUtil().setHeight(58),width: ScreenUtil().setWidth(58),),
                                  onPressed: (){
                                    deleteDialog(context,e);
                                },
                              ),
                                SizedBox(width: ScreenUtil().setWidth(20),)
                            ],
                          ),
                            Flexible(child: Text("•$e\n",style: TextStyle(fontSize: ScreenUtil().setSp(27)),textAlign: TextAlign.start,))
                            ],
                        ),
                        SizedBox(height: ScreenUtil().setHeight(12),)
                        ],
                        )).toList():
                        Container()
                ),
            ),
          ],
    )
    )
  );
  }

  Future<bool> deleteDialog(BuildContext context, String term) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            title: Align(
              alignment: Alignment.topLeft,
              child: Text(
                "Remove",
                textAlign: TextAlign.start,
              ),
            ),
            content: Padding(
              padding: EdgeInsets.only(left: 12),
              child: Text(
                "Remove this Terms/Condition from the list?",
                style: TextStyle(fontSize: 18),
              ),
            ),
            contentPadding: EdgeInsets.all(10.0),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  FlatButton(
                    child: Text("Cancel",style: TextStyle(color: Colors.white),),
                    color: Color(0xff4BCFFA),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  FlatButton(
                    child: Text("Delete"),
                    color: Colors.redAccent,
                    onPressed: () {
                      print("Delete");
                      deleteTerm(term);
                      Navigator.of(context).pop();
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  )
                ],
              )
            ],
          );
        });
  }
}
