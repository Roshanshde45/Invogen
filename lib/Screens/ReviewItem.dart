import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:invogen/Models/InvoDetails.dart';
import 'package:invogen/Models/ItemModel.dart';
import 'package:invogen/Screens/InvoicePreview.dart';
import 'package:pdf/pdf.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;


class ReviewItemScreen extends StatefulWidget {
  List<ItemModel> addedtoList;
  bool contactEnabled = false;

  ReviewItemScreen({this.addedtoList});

  @override
  _ReviewItemScreenState createState() => _ReviewItemScreenState();
}

class _ReviewItemScreenState extends State<ReviewItemScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String phone;
  String email,_brandEmail;
  List terms = [];
  bool showContact = false;
  double TotalAmount = 0,subTotal = 0;
  final pdf = pw.Document();
  String brandlogo,brandName;
  int productTotal = 0;
  double finalAmount = 0;
  double tax = 15.0;
  String uid;
  String invoid;
  String custName,custAddress,address;

  @override
  void initState() {
    super.initState();
    uid = FirebaseAuth.instance.currentUser.uid;
    email = FirebaseAuth.instance.currentUser.email;
    getBrandDetails();
    currentDate();
    totalAmount();
    getTerms();
    getSettings();
    getUserAddress();
    print(widget.addedtoList);
  }

  Future<void> getUserAddress() async{
    await FirebaseFirestore.instance.collection("Users").doc(uid).collection("UserInfo").get().then((value) => {
      value.docs.forEach((doc) {
        setState(() {
          address = doc.data()["address"];
          _brandEmail = doc.data()["brandEmail"];
        });
      })
    });

  }


  void totalAmount() {
    int i;
    double total = 0,interest;
    for(i=0;i<widget.addedtoList.length;i++){
      total = total + widget.addedtoList[i].qty * widget.addedtoList[i].price;
    }
    setState(() {
      subTotal = total;
    });
    interest = total*0.05;
    total = total + interest;
    setState(() {
      TotalAmount = total;
    });
  }

  int total(int price , int qty) {
    print(price);
    print(qty);
      setState(() {
        productTotal  = productTotal + price*qty;
      });
      print(productTotal);
    return price*qty;
  }

  double taxcalc(int val) {
    double a,b;
    a = (productTotal* tax)/100;
    b = productTotal + a;
      setState(() {
        finalAmount = b;
      });
      return b;
  }

  String currentDate(){
    var now = new DateTime.now();
    var formatter = new DateFormat('dd-MM-yyyy');
    String formattedDate = formatter.format(now);
    print(formattedDate);
    return formattedDate;// 2016-01-25
  }

  String timeStamp() {
    String r;
    var ts = DateTime.now().millisecondsSinceEpoch;
    r = ts.toString();
    return r;
  }
  
  getBrandDetails() async{
    var result = FirebaseFirestore.instance.collection("Users").doc(uid).collection("UserInfo").get().then((value) => {
      value.docs.forEach((doc) {
        setState(() {
          brandName = doc.data()["brandName"];
          brandlogo = doc.data()["bImageURL"];
          phone = doc.data()["phone"];
        });
      })
    });
  }

  Future<void> SaveInvoiceDetails() async {
    print("Save invoice called");
    await FirebaseFirestore.instance.collection("UserInvoices").doc(uid).collection("Invoices").doc().set({
      "invoId": invoid,
      "custName": custName,
      "custAddress": custAddress,
//      "productList": FieldValue.arrayUnion(widget.addedtoList),
      "dateGenerated": currentDate(),
      "subTotal": subTotal,
      "tax": tax,
      "total": TotalAmount,
    }).then((value) => print("Data Saved "));
  }

  generateInvoId() {
    String a;
    a = timeStamp();
    setState(() {
      invoid = a;
    });
    print(invoid);
  }

  Future<void> getSettings() async{
    bool a;
    await FirebaseFirestore.instance.collection("Users").doc(uid).collection("Settings").doc(uid).get().then((value){
      a = value.data()["contactEnabled"];
    }).then((value){
      setState(() {
        showContact = a;
      });
    });
  }

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
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: false);
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
          backgroundColor:  Color(0xff2C3335),
        centerTitle: true,
        title: Text("STEP 2 : Review Items",style: TextStyle(color: Colors.white),),
      ),
      resizeToAvoidBottomPadding: true,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(ScreenUtil().setWidth(10)),
              child: Column( 
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: widget.addedtoList.length,
                        itemBuilder: (BuildContext context, int index) => Container(
                          child: Container(
                            padding: EdgeInsets.all(ScreenUtil().setWidth(15)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(widget.addedtoList[index].name,style: TextStyle(fontSize: ScreenUtil().setSp(30),fontWeight: FontWeight.w500),),
                                    SizedBox(height: ScreenUtil().setHeight(10),),
                                    Text(widget.addedtoList[index].price.toString(),style: TextStyle(fontSize: ScreenUtil().setSp(27),fontWeight: FontWeight.w500,color: Colors.red),),
                                    Container(
                                      height: ScreenUtil().setHeight(5),
                                      decoration: BoxDecoration(
                                        color: Colors.black,
                                      ),
                                    )
                                  ],
                                ),
                                Container(
                                  child: Row(
                                    children: [
                                      GestureDetector(
                                        onTap: (){
                                          setState(() {
                                            ++widget.addedtoList[index].qty;
                                            totalAmount();
                                          });
                                        },
                                        child: Material(
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: Color(0xff2C3335),
                                                borderRadius: BorderRadius.circular(50)
                                            ),
                                            child: Padding(
                                                padding: EdgeInsets.all(ScreenUtil().setWidth(7)),
                                                child: Icon(Icons.add,color: Colors.white,)),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: ScreenUtil().setWidth(10),),
                                      Text(widget.addedtoList[index].qty.toString(),style: TextStyle(color: Colors.black,fontSize: ScreenUtil().setSp(35)),),
                                      SizedBox(width: ScreenUtil().setWidth(10),),
                                      GestureDetector(
                                        onTap: (){
                                          if(widget.addedtoList[index].qty>0)
                                            setState(() {
                                              --widget.addedtoList[index].qty;
                                              totalAmount();
                                            });
                                        },
                                        child: Material(
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: Color(0xff2C3335),
                                                borderRadius: BorderRadius.circular(50)
                                            ),
                                            child: Padding(
                                                padding: EdgeInsets.all(ScreenUtil().setWidth(7)),
                                                child: Icon(Icons.remove,color: Colors.white,)),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                    ),
                  ),
                  SizedBox(height: ScreenUtil().setHeight(20),),
                  Padding(
                      padding: EdgeInsets.only(left: ScreenUtil().setWidth(13)),
                      child: Text("Total",style: TextStyle(fontSize: ScreenUtil().setSp(37),color: Colors.blueAccent),)),
                  SizedBox(height: ScreenUtil().setHeight(15),),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)
                    ),
                    elevation: 0,
                    child: Container(
                      padding: EdgeInsets.all(ScreenUtil().setWidth(15)),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Subtotal: ",style: TextStyle(fontSize: ScreenUtil().setSp(30)),),
                              Text(subTotal.toString(),style: TextStyle(fontSize: ScreenUtil().setSp(34),fontWeight: FontWeight.w500),),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Tax: ",style: TextStyle(fontSize: ScreenUtil().setSp(30)),),
                              Text("$tax %",style: TextStyle(fontSize: ScreenUtil().setSp(34),fontWeight: FontWeight.w500),),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Total Amount: ",style: TextStyle(fontSize: ScreenUtil().setSp(30)),),
                              Text(TotalAmount.toString(),style: TextStyle(fontSize: ScreenUtil().setSp(34),fontWeight: FontWeight.w500),),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: ScreenUtil().setHeight(20),),
                  Form(
                    key: _formKey,
                    child: Container(
                      padding: EdgeInsets.all(ScreenUtil().setWidth(20)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Customer Details",style: TextStyle(color: Colors.blueAccent,fontSize: ScreenUtil().setSp(37),fontWeight: FontWeight.w400,),),
                          SizedBox(height: ScreenUtil().setHeight(30),),
                          Container(
                            alignment: Alignment.topLeft,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            color: Colors.white
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextFormField(
                                  onSaved: (val) {
                                    setState(() {
                                      custName = val;
                                    });
                                  },
                                  decoration: InputDecoration(
                                    fillColor: Color(0xffDAE0E2),
                                    filled: true,
                                    hintText: "Customer Name",
                                    border: InputBorder.none
                                  ),
                                  validator: (val) {
                                    if(val.isEmpty){
                                      return "Invalid Name";
                                    }
                                  },
                                  keyboardType: TextInputType.name,
                                ),
                                SizedBox(height: ScreenUtil().setHeight(25),),
                                TextFormField(
                                  onSaved: (val) {
                                    setState(() {
                                      custAddress = val;
                                    });
                                  },
                                  decoration: InputDecoration(
                                    hintText: "Customer Address",
                                      fillColor: Color(0xffDAE0E2),
                                      filled: true,
                                      border: InputBorder.none
                                  ),
                                  validator: (val) {
                                    if(val.isEmpty){
                                      return "Invalid Customer Address";
                                    }
                                  },
                                  keyboardType: TextInputType.name,
                                  maxLines: 4,
                                ),
                                Container(height: ScreenUtil().setHeight(100),)
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              children: [
                Expanded(
                  child: FlatButton(
                    color: Color(0xff2C3335),
                    onPressed: () async {
                      generateInvoId();
                      final formState = _formKey.currentState;
                      if(formState.validate()){
                        formState.save();
                        SaveInvoiceDetails();
                        print("$custName \n$custAddress \n$invoid \n${widget.addedtoList} \n$subTotal \n$tax \n$TotalAmount \n$terms \n$brandName \n$brandlogo \n$showContact \n$_brandEmail \n$phone \n$address");
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => InvoicePreviewScreen(
                                    invoDetails: InvoDetails(
                                      custName: custName,
                                      custAddress: custAddress,
                                      invoId: invoid,
                                      dateGenerated: currentDate(),
                                      addedList: widget.addedtoList,
                                      subTotal: subTotal,
                                      tax: tax,
                                      total: TotalAmount,
                                      terms: terms,
                                      brandName: brandName,
                                      brandimage: brandlogo,
                                      showContact: showContact,
                                      brandEmail: _brandEmail,
                                      phone: phone,
                                      companyAddress: address
                                    )
                                )));
                      }
                    },
                    child: Padding(
                      padding: EdgeInsets.only(top: ScreenUtil().setHeight(25),bottom: ScreenUtil().setHeight(25)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.assignment,color: Colors.white,),
                          SizedBox(width: ScreenUtil().setWidth(10),),
                          Text("Generate Invoice",style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(28),letterSpacing: 1
                          ),),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
