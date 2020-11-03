import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:invogen/Models/Product.dart';

class ViewProductsScreen extends StatefulWidget {
  @override
  _ViewProductsScreenState createState() => _ViewProductsScreenState();
}

class _ViewProductsScreenState extends State<ViewProductsScreen> {
  CollectionReference User = FirebaseFirestore.instance.collection('Users');
  String uid =  "";
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
    List pList = [];
//    getUid();
    var result = await Firestore.instance.collection("Users").doc(uid).collection("Products").get().then((QuerySnapshot snapshot) {
      for(var doc in snapshot.docs){
        pList.add(doc.data());
      }
    });
    setState(() {
      productList = pList;
      loaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: false);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Color(0xffeee),
        iconTheme: IconTheme.of(context),
        centerTitle: true,
        title: Text("All Products",style: TextStyle(color: Colors.black),),
      ),
      body: productList.isEmpty ? Center(child: loaded? Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            "assets/images/empty.png",
            height: ScreenUtil().setHeight(500),
            width: ScreenUtil().setWidth(500),
          ),
          Text("Looks you haven't added any products!",style: GoogleFonts.ubuntu(textStyle: TextStyle(
            fontSize: ScreenUtil().setSp(35),
            fontWeight: FontWeight.w400
          )),
          maxLines: 2,),
          Text("Go to Product Management section to add Products.",style: GoogleFonts.ubuntu(textStyle: TextStyle(
              fontSize: ScreenUtil().setSp(35),
              fontWeight: FontWeight.w400
          )),
            maxLines: 2,textAlign: TextAlign.center,)
        ],
      ): CircularProgressIndicator(),
      ):  productListWidget(context)
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
                          Container(
                            height: ScreenUtil().setHeight(10),
                            width: ScreenUtil().setWidth(10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: productList[i]["stock"]?Color(0xff1BCA9B):Color(0xffE83350)
                            ),
                          ),
                          SizedBox(width: ScreenUtil().setWidth(10),),
                          Text(productList[i]["stock"]? "In stock": "Out of Stock",style: TextStyle(color: productList[i]["stock"]?Color(0xff1BCA9B):Color(0xffE83350),fontSize: ScreenUtil().setSp(20),)),
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
}
