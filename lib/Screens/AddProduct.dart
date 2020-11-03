
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';

class AddProductScreen extends StatefulWidget {
  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  bool _stock = false;
  String _productName;
  int _price;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  CollectionReference userRef = FirebaseFirestore.instance.collection('Users');

  Future<void> addProduct() async{
    String user;
    user = await FirebaseAuth.instance.currentUser.uid;
    print(user);
    final formState = _formKey.currentState;
    try{
      if(formState.validate()){
        formState.save();
          var res = await userRef.doc(user).collection("Products").add({
            "name": _productName,
            "price": _price,
            "stock": _stock,
          }).then((value){
            print(value.documentID);
            formState.reset();
          })
            .catchError((error) => print("Failed to add product: $error"));
      }
    }catch(e){
      debugPrint(":::::Something went wrong:::::");
      print(e);
    }
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
          title: Text("Add New Product",style: TextStyle(color: Colors.black),),
        ),
      body: Builder(
        builder: (BuildContext context){
            return Container(
//              color: Colors.blueAccent,
              padding: EdgeInsets.all(ScreenUtil().setHeight(26)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(ScreenUtil().setWidth(10)),
                    decoration: BoxDecoration(
//                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15)
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            decoration: InputDecoration(
                              hintText: "Product Name",
                            ),
                            validator: (val){
                              if(val.isEmpty){
                                return "Invalid Product Name";
                              }
                            },
                            onSaved: (val){
                              _productName = val;
                            },
                            keyboardType: TextInputType.text,
                          ),
                          SizedBox(height: ScreenUtil().setHeight(20)),
                          TextFormField(
                            decoration: InputDecoration(
                              hintText: "Price",
                            ),
                            validator: (val){
                              if(val.isEmpty){
                                return "Invalid Price";
                              }
                            },
                            onSaved: (val) {
                              _price = int.parse(val);
                            },
                            keyboardType: TextInputType.number,
                          ),
                          SizedBox(height: ScreenUtil().setHeight(10)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Checkbox(
                                value: _stock,
                                onChanged: (val) {
                                  setState(() {
                                    _stock = val;
                                  });
                                },
                              ),
                              Text("In Stock")
                            ],
                          ),
                          SizedBox(height: ScreenUtil().setHeight(20),),
                          Row(
                            children: [
                              Expanded(
                                child: FlatButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)
                                  ),
                                  color: Color(0xff2C3335),
                                  onPressed: (){
                                    addProduct();
                                    AwesomeDialog(
                                      context: context,
                                      width: 480,
                                      dialogType: DialogType.SUCCES,
                                      headerAnimationLoop: false,
                                      animType: AnimType.BOTTOMSLIDE,
                                      title: 'Success',
                                      desc: "New Product added Successfully!!",
                                      btnOkOnPress: () {
                                      },
                                    )..show();
//                                    Scaffold.of(context).showSnackBar(SnackBar(
//                                      content: Text("New Product added Successfully!!"),
//                                      duration: Duration(seconds: 2),
//                                    ));
                                  },
                                  child: Text("Add Product",style: TextStyle(color: Colors.white),),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: ScreenUtil().setHeight(30),),
                  Text("1. Give your Product's name.",style: TextStyle(fontSize: ScreenUtil().setSp(25),color: Colors.grey),),
                  Text("2. Give its price.",style: TextStyle(fontSize: ScreenUtil().setSp(25),color: Colors.grey)),
                  Text("3. Fill the checkbox if the product is available.",style: TextStyle(fontSize: ScreenUtil().setSp(25),color: Colors.grey))
                ],
              ),
            );
          },
      ),
    );
  }
}
