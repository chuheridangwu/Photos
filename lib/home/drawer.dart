import 'package:flutter/material.dart';

class PhotoDrawer extends StatefulWidget {
  @override
  _PhotoDrawerState createState() => _PhotoDrawerState();
}

class _PhotoDrawerState extends State<PhotoDrawer> {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: 250,
        color: Colors.white,
        child: Column(
          children: [
            createHeaderView(),
          ],
        ));
  }

  // 创建头部
  Widget createHeaderView() {
    return Container(
      decoration: BoxDecoration(color: Theme.of(context).primaryColor),
      height: 220,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
           Image.asset("images/other/app.png"),
          SizedBox(height: 10,),
          Text("Demo")
        ],
      ),
    );
  }
}
