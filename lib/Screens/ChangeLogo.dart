import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';

class ChangeLogoScreen extends StatefulWidget {
  @override
  _ChangeLogoScreenState createState() => _ChangeLogoScreenState();
}

class _ChangeLogoScreenState extends State<ChangeLogoScreen> {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: false);
    return Scaffold(
      appBar: AppBar(
        title: Text("Change Brand Logo",style: TextStyle(color: Colors.black),),
        centerTitle: true,
        elevation: 0.0,
        iconTheme: IconTheme.of(context),
        backgroundColor: Color(0xffeee),
      ),
      body: Container(
        padding: EdgeInsets.all(ScreenUtil().setWidth(30)),
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: ScreenUtil().setHeight(50),),
            CircleAvatar(
              backgroundColor: Colors.blue,
              radius: ScreenUtil().setWidth(150),
              foregroundColor: Colors.white,
              backgroundImage: NetworkImage("https://i.pinimg.com/236x/71/b3/e4/71b3e4159892bb319292ab3b76900930.jpg"),
            ),
            SizedBox(height: ScreenUtil().setHeight(30),),
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
                      onPressed: () {
                        
                      },
                      child: Text("Change Photo",style: TextStyle(color: Colors.white),),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
