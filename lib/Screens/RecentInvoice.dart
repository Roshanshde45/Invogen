import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';

class RecentInvoiceScreen extends StatefulWidget {
  @override
  _RecentInvoiceScreenState createState() => _RecentInvoiceScreenState();
}

class _RecentInvoiceScreenState extends State<RecentInvoiceScreen> {
List productList = [];
bool loaded = false;
String uid;


  getInvoice() async{
    List pList = [];
    var result = FirebaseFirestore.instance.collection("UserInvoices").doc(uid).collection("Invoices").get().then((QuerySnapshot snapshot){
      for(var doc in snapshot.docs){
        pList.add(doc.data());
      }
      setState(() {
        productList = pList;
        loaded = true;
      });
    });
  }

  @override
  void initState() {
    uid = FirebaseAuth.instance.currentUser.uid;
    super.initState();
    getInvoice();
  }
  
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: false);
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor:  Color(0xff2C3335),
        centerTitle: true,
        title: Text("Recent Invoice",style: TextStyle(color: Colors.white),),
      ),
      body: !loaded? Center(child: CircularProgressIndicator(),):RecentInvoiceWidget(context),
    );
  }

  Widget RecentInvoiceWidget(BuildContext context,) {
    print(productList.length);
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) => Column(
        children: [
          Container(
            alignment: Alignment.topLeft,
            decoration: BoxDecoration(
              color: Colors.white
            ),
            padding: EdgeInsets.all(ScreenUtil().setWidth(18)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "# ${productList[index]["invoId"]}",style: TextStyle(fontWeight: FontWeight.bold),),
                Text("To: ${productList[index]["custName"]}"),
                Text("Date Generated: ${productList[index]["dateGenerated"]}"),
                Text("Total Ammount: ${productList[index]["total"]}"),
              ],
            ),
          ),
          Divider(),
        ],
      ),
      itemCount: productList.length,
    );
  }
}
