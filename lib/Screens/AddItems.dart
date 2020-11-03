
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:invogen/Models/ItemModel.dart';
import 'package:invogen/Screens/ReviewItem.dart';

class AddItemsScreen extends StatefulWidget {
  @override
  _AddItemsScreenState createState() => _AddItemsScreenState();
}

class _AddItemsScreenState extends State<AddItemsScreen> {
  String uid;
  List productList = [];
  bool loaded = false;

  @override
  void initState() {
    uid = FirebaseAuth.instance.currentUser.uid;
    super.initState();
    getAllProducts();
  }


  Future<void> getAllProducts() async{
    var pList = [];
    var result = await FirebaseFirestore.instance.collection("Users").doc(uid).collection("Products").get().then((QuerySnapshot snapshot) {
      for(var doc in snapshot.docs){
        var data = doc.data();
        data["added"] = true;
        pList.add(data);
      }
    });
    setState(() {
      productList = pList;
      loaded = true;
    });
  }

  List<ItemModel> _itemList = [
    ItemModel(
      name: "Dlecta Cheese Spread Jar",
      price: 3000,
      stock: true,
      added: true,
    ),
    ItemModel(
      name: "Dlecta Cheese Spread Jar",
      price: 3000,
      stock: false,
      added: true,
    ),
    ItemModel(
      name: "Dlecta Cheese Spread Jar",
      price: 3000,
      stock: false,
      added: true,
    ),
    ItemModel(
      name: "Dlecta Cheese Spread Jar",
      price: 3000,
      stock: false,
      added: true,
    )
  ];

  List<ItemModel> _addedtoList = [];

  ItemModel _addtoCartList(String Name, int Price,) {
    return ItemModel(
        name: Name,
        price: Price
    );
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: false);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor:  Color(0xff2C3335),
        centerTitle: true,
        title: Text("STEP 1 : Add Items",style: TextStyle(color: Colors.white),),
      ),
      body:  productList.isNotEmpty ? Stack(
        children: [
         ListView.builder(
            padding: EdgeInsets.only(bottom: ScreenUtil().setHeight(80)),
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: productList.length,
            itemBuilder: (context, i) => Container(
              padding: EdgeInsets.all(ScreenUtil().setWidth(5)),
              child: Column(
                  children: <Widget>[
                    ItemCard(
                      name: productList[i]["name"],
                      price: productList[i]["price"],
                      stock: productList[i]["stock"],
                      addToList: () {
                        _addedtoList.add(ItemModel(name:productList[i]["name"],price: productList[i]["price"]));
                        print(_addedtoList);
                        setState(() {
                          productList[i]["added"] = !productList[i]["added"];
                        });
                      },
                      added:productList[i]["added"],
                    )
                  ]
              ),
            ),
          ),
          Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(height: ScreenUtil().setHeight(80),)),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              children: [
                Expanded(
                  child: FlatButton(
                    color: Color(0xff2C3335),
                    onPressed: () async{
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ReviewItemScreen(addedtoList: _addedtoList)));
                    },
                    child: Padding(
                      padding: EdgeInsets.only(top: ScreenUtil().setHeight(25),bottom: ScreenUtil().setHeight(25)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(width: ScreenUtil().setWidth(10),),
                          Text("Next",style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(28),letterSpacing: 1
                          ),),
                          SizedBox(width: ScreenUtil().setWidth(20),),
                          Icon(Icons.arrow_forward,color: Colors.white,),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ): loaded? Container(
        child: Center(child: Column(
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
        ),
        )
      ):Center(child: CircularProgressIndicator(),),
    );
  }
}

class ItemCard extends StatelessWidget {
  final String name;
  final int price;
  final bool stock;
  final Function addToList;
  final bool added;
  const ItemCard({
    this.name,
    this.price,
    this.stock,
    this.addToList,
    this.added,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
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
                    child: Text(name,
                      style: TextStyle(color: Colors.black,fontSize: ScreenUtil().setSp(25)),overflow: TextOverflow.ellipsis,)),
                SizedBox(height: ScreenUtil().setHeight(10),),
                Text("Price: $price",
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
                        color: stock?Color(0xff1BCA9B):Color(0xffE83350)
                      ),
                    ),
                    SizedBox(width: ScreenUtil().setWidth(10),),
                    Text(stock? "In stock": "Out of Stock",style: TextStyle(color: stock ? Color(0xff1BCA9B):Color(0xffE83350),fontSize: ScreenUtil().setSp(20),)),
                  ],
                ),
                added? FlatButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)
                  ),
                  onPressed: added ? addToList: null,
                  color: added? Color(0xff2C3335):Colors.grey,
                  child: Text("Add to List",style: TextStyle(color: Colors.white),),
                ): Icon(Icons.check,color: Colors.black,)
              ],
            )
          ],
        ),
      ),
    );
  }
}
