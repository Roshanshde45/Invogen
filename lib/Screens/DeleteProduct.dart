import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class DeleteProductScreen extends StatefulWidget {
  @override
  _DeleteProductScreenState createState() => _DeleteProductScreenState();
}

class _DeleteProductScreenState extends State<DeleteProductScreen> {
  CollectionReference User = FirebaseFirestore.instance.collection('Users');
  String uid;
  List productList = [];
  bool loaded = false;
  Map<String,dynamic> prod;


  @override
  void initState(){
    uid = FirebaseAuth.instance.currentUser.uid;
    super.initState();
    getAllProducts();
  }

  Future<void> getAllProducts() async{
    var pList = [];
    var result = await User.doc(uid).collection("Products").get().then((QuerySnapshot snapshot) {
      for(var doc in snapshot.docs){
        var data = doc.data();
        data["docId"] = doc.id;
        pList.add(data);
      }
    });
    setState(() {
      productList = pList;
      loaded = true;
    });
  }


  void deleteLink(String docId) {
    try {
      Firestore.instance.collection("Users").doc(uid).collection("Products").doc(docId).delete();
      setState(() {
        getAllProducts();
      });
    }catch(e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: false);
    return Scaffold(
      body: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Color(0xffeee),
          iconTheme: IconTheme.of(context),
          centerTitle: true,
          title: Text("Delete Product",style: TextStyle(color: Colors.black),),
        ),
        body: productList.isNotEmpty? productListWidget(context):Center(child: loaded? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/empty.png",
              height: ScreenUtil().setHeight(500),
              width: ScreenUtil().setWidth(500),
            ),
            Text("No Products to Delete!",style: GoogleFonts.ubuntu(textStyle: TextStyle(
                fontSize: ScreenUtil().setSp(35),
                fontWeight: FontWeight.w400
            )),
              maxLines: 2,),
          ],
        ): CircularProgressIndicator(),
        ),
      ),
    );
  }

  Widget productListWidget(BuildContext context) {
    return ListView.builder(
        itemCount: productList.length,
        itemBuilder: (context, i) {
          return loaded? Card(
            child: Container(
              padding: EdgeInsets.all(13),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          width: MediaQuery.of(context).size.width * 0.54,
                          child: Text(productList[i]["name"],
                            style: TextStyle(color: Colors.black,fontSize: ScreenUtil().setSp(25)),overflow: TextOverflow.ellipsis,)),
                      SizedBox(height: ScreenUtil().setHeight(10),),
                      Text("Price: ${productList[i]["price"]}",
                          style: TextStyle(color: Color(0xffE83350),fontSize: ScreenUtil().setSp(22),)),
                      SizedBox(height: ScreenUtil().setHeight(10),),

                    ],
                  ),
                  Column(
                    children: [
                      Row(
                        children: [
                          SizedBox(width: ScreenUtil().setWidth(10),),
                          FlatButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)
                            ),
                            onPressed: (){
                              print(":::::::::::::::::::::::::::::::::::::::::::::::::");
                              print(productList[i]["docId"]);
                              AwesomeDialog(
                                context: context,
                                width: 480,
                                dialogType: DialogType.WARNING,
                                headerAnimationLoop: false,
                                animType: AnimType.BOTTOMSLIDE,
                                title: 'Warning',
                                desc: '!!Delete this Product',
                                btnCancelOnPress: () {
                                },
                                btnOkOnPress: () {
                                  deleteLink(productList[i]["docId"]);
                                },
                              )..show();
                            },
                            color: Colors.redAccent,
                            child: Row(
                              children: [
                                Padding(
                                    padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(15),vertical: ScreenUtil().setHeight(6)),
                                    child: Text("Delete",style: TextStyle(color: Colors.white),)),
                                SizedBox(width: ScreenUtil().setWidth(10),),
                                Icon(Icons.delete,color: Colors.white,)
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          ): Center(
            child: CircularProgressIndicator(),
          );
        });
  }


  Future<bool> deleteDialog(BuildContext context, String docId) {
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
                "Delete",
                textAlign: TextAlign.start,
              ),
            ),
            content: Padding(
              padding: EdgeInsets.only(left: 12),
              child: Text(
                "Do you want to delete this link ?",
                style: TextStyle(fontSize: 18),
              ),
            ),
            contentPadding: EdgeInsets.all(10.0),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  FlatButton(
                    child: Text("Cancel"),
                    color: Colors.blue,
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
                      deleteLink(docId);
                      Navigator.of(context).pop();
                      print("Delete");
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
