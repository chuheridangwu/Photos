import 'package:flutter/material.dart';

class PhotoDrawer extends StatefulWidget {
  @override
  _PhotoDrawerState createState() => _PhotoDrawerState();
}

class _PhotoDrawerState extends State<PhotoDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: MediaQuery.removePadding(
          context: context,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: Colors.yellow,
                child: Padding(
                  padding: EdgeInsets.only(top: 30),
                  child: Text("测试"),
                ),
              ),
            ],
          )),
    );
  }
}
