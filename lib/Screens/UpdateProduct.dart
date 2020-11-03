import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class UpdateProductScreen extends StatefulWidget {
  @override
  _UpdateProductScreenState createState() => _UpdateProductScreenState();
}

class _UpdateProductScreenState extends State<UpdateProductScreen> {

  CollectionReference User = FirebaseFirestore.instance.collection('Users');
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String uid = "ByTGqE6PLEUBU6vQRC7Utezlk172";
  List productList = [];
  bool loaded = false;
  bool _stock = false;
  TextEditingController _ctrlProdName = new TextEditingController();
  TextEditingController _ctrlPrice = new TextEditingController();


  @override
  void initState(){
    uid = FirebaseAuth.instance.currentUser.uid;
    super.initState();
    getAllProducts();
  }

  Future<void> getAllProducts() async{
    print("getAllProduct");
    var pList = [];
    var result = await User.doc(uid).collection("Products").get().then((QuerySnapshot snapshot) {
      for(var doc in snapshot.docs){
        var data = doc.data();
        data["docId"] = doc.id;
        pList.add(data);
      }
    });
    print(pList);
    setState(() {
      productList = pList;
      loaded = true;
    });
  }


  void deleteLink(String docId) {
    try {
      FirebaseFirestore.instance.collection("Users").doc(uid).collection("Products").doc(docId).delete();
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
      backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Color(0xffeee),
          iconTheme: IconTheme.of(context),
          centerTitle: true,
          title: Text("Update Product",style: TextStyle(color: Colors.black),),
        ),
      body: productList.isNotEmpty ? productListWidget(context): Container(
        alignment: Alignment.topCenter,
        child: loaded? Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            "assets/images/empty.png",
            height: ScreenUtil().setHeight(500),
            width: ScreenUtil().setWidth(500),
          ),
          Text("No Products to Update!",style: GoogleFonts.ubuntu(textStyle: TextStyle(
              fontSize: ScreenUtil().setSp(35),
              fontWeight: FontWeight.w400
          )),
            maxLines: 2,),
        ],
      ): Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Widget productListWidget(BuildContext context) {
    return ListView.builder(
        itemCount: productList.length,
        itemBuilder: (context, i) {
          return loaded? Card(
            child: Container(
              padding: EdgeInsets.all(ScreenUtil().setWidth(17)),
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
                              borderRadius: BorderRadius.circular(10)
                            ),
                            onPressed: () {
                              _settingModalBottomSheet(
                                  productList[i]["docId"],
                                  productList[i]["name"],
                                  productList[i]["stock"],
                                  productList[i]["price"]);
                            },
                            color: Colors.blueAccent,
                            child: Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(15),vertical: ScreenUtil().setHeight(6)),
                                    child: Text("Update",style: TextStyle(color: Colors.white),)),
                                SizedBox(width: ScreenUtil().setWidth(10),),
                                Icon(Icons.edit,color: Colors.white,),
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

   Widget _settingModalBottomSheet(String docId, String pName,bool pStock, int pPrice){
    bool tok = pStock;
    _ctrlProdName.text = pName;
    _ctrlPrice.text = pPrice.toString();
    showModalBottomSheet(
      isScrollControlled: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(15),topLeft: Radius.circular(15))),
        context: context,
        builder: (BuildContext bc){
          return Container(
            padding: EdgeInsets.fromLTRB(ScreenUtil().setWidth(22), ScreenUtil().setHeight(75), ScreenUtil().setWidth(22), 0),
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(ScreenUtil().setWidth(15)),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15)
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        SizedBox(height: ScreenUtil().setHeight(20),),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Update details",
                              style: GoogleFonts.ubuntu(textStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: ScreenUtil().setSp(40),fontWeight: FontWeight.w400),)
                            ),
                            IconButton(
                              icon: Icon(Icons.clear,size: 31,),
                              onPressed: (){
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: ScreenUtil().setHeight(60)),
                        TextFormField(
                          decoration: InputDecoration(
                            hintText: "Product Name",
                          ),
                          validator: (val){
                            if(val.isEmpty){
                              return "Invalid Product Name";
                            }
                          },
                          controller: _ctrlProdName,
                          keyboardType: TextInputType.text,
                        ),
                        SizedBox(height: ScreenUtil().setHeight(30)),
                        TextFormField(
                          decoration: InputDecoration(
                            hintText: "Price",
                          ),
                          validator: (val){
                            if(val.isEmpty){
                              return "Invalid Price";
                            }
                          },
                            controller: _ctrlPrice,
                          keyboardType: TextInputType.number,
                        ),
                        SizedBox(height: ScreenUtil().setHeight(10)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Checkbox(
                              value: tok,
                              onChanged: (val) {
                                setState(() {
                                  tok = val;
                                });
                              },
                            ),
                            Text("In Stock")
                          ],
                        ),
                        SizedBox(height: ScreenUtil().setHeight(30),),
                        Row(
                            children: [
                              Expanded(
                                child: RaisedButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  onPressed: (){
                                    UpdateDetails(docId,_ctrlProdName.text,int.parse(_ctrlPrice.text));
                                  },
                                  child: Padding(
                                      padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
                                      child: Text("Update",
                                        style: TextStyle(color: Colors.white),)
                                  ),
                                  color: Color(0xff2C3335),
                                  ),
                                 )
                                ],
                          ),
                        SizedBox(height: ScreenUtil().setHeight(30),),
                        GestureDetector(
                          onTap: (){
                            Navigator.pop(context);
                          },
                            child: Text("go back",style: TextStyle(fontSize: ScreenUtil().setSp(25),color: Colors.grey,decoration: TextDecoration.underline),))
                      ],
                    ),
                  ),
                )
              ],
            )
          );
        }
    );
  }

  UpdateDetails(String docId,String name,int price) {
    User.doc(uid).collection("Products").doc(docId).update({
      "name": name,
      "price": price
    }).then((value) => Navigator.pop(context));
    setState(() {
      getAllProducts();
    });
  }
}
