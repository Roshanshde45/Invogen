import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:invogen/Screens/AddItems.dart';
import 'package:invogen/Screens/Profile.dart';
import 'package:invogen/Screens/RecentInvoice.dart';
import 'package:invogen/Screens/ViewProducts.dart';

import 'AdminAuth.dart';
import 'CompanyInfo.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}


class _DashboardScreenState extends State<DashboardScreen> {
  String name;
  bool loaded = true;

  @override
  void initState() {
    super.initState();
    getName();
    print(name);
  }

  Future<void> getName() async{
    String nam;
    nam = await FirebaseAuth.instance.currentUser.displayName;
    setState(() {
      name = nam;
      loaded = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: false);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(ScreenUtil().setWidth(35)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Hello,",style: GoogleFonts.ubuntu(fontStyle: FontStyle.normal,fontSize: ScreenUtil().setSp(25),color: Color(0xff535C68),),),
                          SizedBox(height: ScreenUtil().setHeight(10),),
                          Text(name.toString(),style: GoogleFonts.ubuntu(fontWeight: FontWeight.w500,fontSize: ScreenUtil().setSp(50),color: Colors.black,),),
                        ],
                      ),
                      GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen()));
                        },
                        child: CircleAvatar(
                          backgroundColor: Colors.black12,
                          backgroundImage: AssetImage("assets/images/profile.png"),
                          radius: ScreenUtil().setWidth(40),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(ScreenUtil().setWidth(30), 0, ScreenUtil().setWidth(30), 0),
                  child: Row(
                    children: [
                      Expanded(
                        child: FlatButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)
                          ),
                          color: Color(0xff2C3335),
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => AddItemsScreen()));
                          },
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(0, 16, 0, 16),
                              child: Text("Generate Invoice",style: TextStyle(color: Colors.white,letterSpacing: 0,fontSize: ScreenUtil().setSp(30)),)),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Card(
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)
                    ),
                    child: Container(
                      padding: EdgeInsets.all(30),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                height: ScreenUtil().setHeight(80),
                                width: ScreenUtil().setWidth(80),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.purple[100],
                                ),
                                child: Image.asset("assets/images/docs.png")
                              ),
                              SizedBox(width: ScreenUtil().setWidth(30),),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("350",style: GoogleFonts.ubuntu(fontWeight: FontWeight.w500,fontSize: ScreenUtil().setSp(30),color: Colors.black,),),
                                  Text("Total Invoice",style: GoogleFonts.ubuntu(fontWeight: FontWeight.w500,fontSize: ScreenUtil().setSp(25),color: Colors.grey,),),
                                ],
                              )
                            ],
                          ),
                          SizedBox(height: ScreenUtil().setHeight(40),),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                height: ScreenUtil().setHeight(80),
                                width: ScreenUtil().setWidth(80),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.blue[100],
                                ),
                                child: Image.asset("assets/images/month.png")
                              ),
                              SizedBox(width: ScreenUtil().setWidth(30),),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("400,000",style: GoogleFonts.ubuntu(fontWeight: FontWeight.w500,fontSize: ScreenUtil().setSp(30),color: Colors.black,),),
                                  Text("Over Last Month",style: GoogleFonts.ubuntu(fontWeight: FontWeight.w500,fontSize: ScreenUtil().setSp(25),color: Colors.grey,),),
                                ],
                              )
                            ],
                          ),
                          SizedBox(height: ScreenUtil().setHeight(40),),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                height: ScreenUtil().setHeight(80),
                                width: ScreenUtil().setWidth(80),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.deepPurple[100],
                                ),
                                child:  Image.asset("assets/images/year.png")
                              ),
                              SizedBox(width: ScreenUtil().setWidth(30),),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("45,500,000",style: GoogleFonts.ubuntu(fontWeight: FontWeight.w500,fontSize: ScreenUtil().setSp(30),color: Colors.black,),),
                                  Text("Over Last Year",style: GoogleFonts.ubuntu(fontWeight: FontWeight.w500,fontSize: ScreenUtil().setSp(25),color: Colors.grey,),),
                                ],
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(ScreenUtil().setWidth(10), ScreenUtil().setHeight(0), ScreenUtil().setWidth(10), 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: ScreenUtil().setWidth(20),top: ScreenUtil().setHeight(20)),
                        child: Text("Product Management",style: GoogleFonts.ubuntu(textStyle: TextStyle(
                          fontSize: ScreenUtil().setSp(40),
                          fontWeight: FontWeight.w500
                        )),),
                      ),
                      SizedBox(height: ScreenUtil().setHeight(25),),
                      Container(
                        padding: EdgeInsets.only(left: ScreenUtil().setWidth(25), right: ScreenUtil().setWidth(25)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Material(
                              child: InkWell(
                                borderRadius: BorderRadius.circular(13),
                                splashColor: Colors.white,
                                onTap: (){
                                  int ScreenInt = 0;
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => AdminAuthScreen(screenInt: ScreenInt,)));
                                },
                                child: Ink(
                                  height: ScreenUtil().setHeight(200),
                                  width: ScreenUtil().setWidth(320),
                                  decoration: BoxDecoration(
                                      color: Color(0xff74B9FF),
                                      borderRadius: BorderRadius.circular(13)
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset("assets/images/add_product.png",
                                        height: ScreenUtil().setHeight(80),
                                        color: Colors.white,
                                      ),
                                      SizedBox(height: ScreenUtil().setHeight(10),),
                                      Text("Add Products",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: ScreenUtil().setSp(30)),)
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Spacer(),
                            Material(
                              child: InkWell(
                                borderRadius: BorderRadius.circular(13),
                                splashColor: Colors.white,
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => ViewProductsScreen()));
                                },
                                child: Ink(
                                  height: ScreenUtil().setHeight(200),
                                  width: ScreenUtil().setWidth(320),
                                  decoration: BoxDecoration(
                                      color: Color(0xff1BCA9B),
                                      borderRadius: BorderRadius.circular(13)
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset("assets/images/product.png",
                                        height: ScreenUtil().setHeight(80),
                                        color: Colors.white,
                                      ),
                                      SizedBox(height: ScreenUtil().setHeight(10),),
                                      Text("View all Products",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: ScreenUtil().setSp(30)),)
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: ScreenUtil().setHeight(20),),
                      Container(
                        padding: EdgeInsets.only(left: ScreenUtil().setWidth(25), right: ScreenUtil().setWidth(25)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Material(
                              child: InkWell(
                                borderRadius: BorderRadius.circular(13),
                                splashColor: Colors.white,
                                onTap: (){
                                  int ScreenInt = 1;
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => AdminAuthScreen(screenInt: ScreenInt,)));
                                },
                                child: Ink(
                                  height: ScreenUtil().setHeight(200),
                                  width: ScreenUtil().setWidth(320),
                                  decoration: BoxDecoration(
                                      color: Color(0xff01CBC6),
                                      borderRadius: BorderRadius.circular(13)
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset("assets/images/modify.png",
                                        height: ScreenUtil().setHeight(80),
                                        color: Colors.white,
                                      ),
                                      SizedBox(height: ScreenUtil().setHeight(10),),
                                      Text("Update Details",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: ScreenUtil().setSp(30)),)
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Spacer(),
                            Material(
                              child: InkWell(
                                borderRadius: BorderRadius.circular(13),
                                splashColor: Colors.white,
                                onTap: (){
                                  int screenInt = 2;
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => AdminAuthScreen(screenInt: screenInt)));
                                },
                                child: Ink(
                                  height: ScreenUtil().setHeight(200),
                                  width: ScreenUtil().setWidth(320),
                                  decoration: BoxDecoration(
                                      color: Colors.redAccent[100],
                                      borderRadius: BorderRadius.circular(13)
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset("assets/images/delete.png",
                                        height: ScreenUtil().setHeight(80),
                                        color: Colors.white,
                                      ),
                                      SizedBox(height: ScreenUtil().setHeight(10),),
                                      Text("Delete Products",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: ScreenUtil().setSp(30)),)
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: ScreenUtil().setHeight(30),)
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: ScreenUtil().setWidth(13),right: ScreenUtil().setWidth(13)),
                  child: Card(
                    margin: EdgeInsets.zero,
                    elevation: 3,
                    color: Color(0xff2C3335),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(topRight: Radius.circular(20),topLeft: Radius.circular(20))
                    ),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
//                    color: Colors.blueAccent,
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight:  Radius.circular(20))
                      ),
                      alignment: Alignment.topLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Image.asset("assets/images/menu.png",
                              height: ScreenUtil().setHeight(30),),
                              SizedBox(width: ScreenUtil().setWidth(20),),
                              Container(
                                alignment: Alignment.center,
                                width: ScreenUtil().setWidth(130),
                                height: ScreenUtil().setHeight(50),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10)
                                ),
                                child: Text("Menu",style: GoogleFonts.ubuntu(textStyle: TextStyle(fontWeight: FontWeight.w400)),),
                              )
                            ],
                          ),
                          SizedBox(height: ScreenUtil().setHeight(20),),
                          GestureDetector(
                            onTap: (){},
                            child: Row(
                              children: [
                                Image.asset("assets/images/iset.png",height: ScreenUtil().setHeight(50),width: ScreenUtil().setWidth(50),),
                                SizedBox(width: ScreenUtil().setWidth(20),),
                                Text("Invoice Settings",style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(30)),),
                                Spacer(),
                                IconButton(
                                  onPressed: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (_) => CompanyInfoScreen()));
                                  },
                                    icon: Icon(Icons.arrow_forward_ios,size: 20,color: Colors.white,))
                              ],
                            ),
                          ),
                          SizedBox(height: ScreenUtil().setHeight(11),),
                          GestureDetector(
                            onTap: (){},
                            child: Row(
                              children: [
                                Image.asset("assets/images/stats.png",height: ScreenUtil().setHeight(50),width: ScreenUtil().setWidth(50),),
                                SizedBox(width: ScreenUtil().setWidth(20),),
                                Text("Product Statistics",style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(30)),),
                                Spacer(),
                                IconButton(
                                  onPressed: (){},
                                    icon: Icon(Icons.arrow_forward_ios,size: 20,color: Colors.white,))
                              ],
                            ),
                          ),
                          SizedBox(height: ScreenUtil().setHeight(11),),
                          GestureDetector(
                            onTap: (){},
                            child: Row(
                              children: [
                                Image.asset("assets/images/recent.png",height: ScreenUtil().setHeight(50),width: ScreenUtil().setWidth(50),),
                                SizedBox(width: ScreenUtil().setWidth(20),),
                                Text("Recent Invoice",style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(30)),),
                                Spacer(),
                                IconButton(
                                  onPressed: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (_) => RecentInvoiceScreen()));
                                  },
                                    icon: Icon(Icons.arrow_forward_ios,size: 20,color: Colors.white,))
                              ],
                            ),
                          ),
                          SizedBox(height: ScreenUtil().setHeight(11),),
                          GestureDetector(
                            onTap: (){},
                            child: Row(
                              children: [
                                Image.asset("assets/images/profile.png",height: ScreenUtil().setHeight(50),width: ScreenUtil().setWidth(50)),
                                SizedBox(width: ScreenUtil().setWidth(20),),
                                Text("Profile",style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(30)),),
                                Spacer(),
                                IconButton(
                                  onPressed: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (_) => ProfileScreen()));
                                  },
                                    icon: Icon(Icons.arrow_forward_ios,size: 20,color: Colors.white,))
                              ],
                            ),
                          ),
                          SizedBox(height: ScreenUtil().setHeight(15),)
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
