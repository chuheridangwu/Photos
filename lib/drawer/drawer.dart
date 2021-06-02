import 'package:flutter/material.dart';
import 'package:mglobalphoto/drawer/cacheManage.dart';
import 'package:mglobalphoto/drawer/privaty_webview.dart';
import 'package:mglobalphoto/drawer/shuffle_video.dart';
import 'package:mglobalphoto/main.dart';
import 'package:package_info/package_info.dart';

class PhotoDrawer extends StatefulWidget {
  @override
  _PhotoDrawerState createState() => _PhotoDrawerState();
}

class _PhotoDrawerState extends State<PhotoDrawer> {
  String _appName = "MGlobal";
  String _version = "1.0.0";

  @override
  void initState() {
    super.initState();
    PackageInfo.fromPlatform().then((value) {
      setState(() {
        _appName = value.appName;
        _version = value.version;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 250,
        color: Colors.white,
        child: Column(
          children: [
            createHeaderView(),
            createRowListView(),
          ],
        ));
  }

  // 创建头部
  Widget createHeaderView() {
    return Container(
      color: Theme.of(context).primaryColor,
      width: 250,
      height: 220,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 20,
          ),
          ClipOval(
            child: Image.asset(
              "images/other/logo.png",
              width: 90,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          FutureBuilder(builder: (ctx, asyncs) {
            return Text(
              _appName,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            );
          }),
        ],
      ),
    );
  }

  // 创建列表Widget
  Widget createRowListView() {
    return Expanded(
      child: ListView(
        children: [
          
          createRowView(Icons.shuffle, "随机视频", () {
              Navigator.pushNamed(context,ShuffleVideoPlay.routeName);
           }),
          createRowView(Icons.cached, "清除缓存", () {
              Future.delayed(Duration(seconds: 1)).then((value){
                showDialog(context: context, builder: (ctx){
                  return createDialog();
                });
              });
           }),
           createRowView(Icons.policy, "隐私政策", () {
             Navigator.pushNamed(context, PrivatyWebView.routeName);
           }),
           ListTile(
            leading: Icon(Icons.error),
            title:  Text("版本号 $_version"),
          ),
        ],
      ),
    );
  }

  // 单行row
  Widget createRowView(IconData icon,String title,VoidCallback onTap){
    return ListTile(
            leading: Icon(icon),
            title:  Text(title),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: onTap
          );
  }

  // 弹窗widget
  Widget createDialog(){
    return AlertDialog(
      title: Text("缓存清除完毕"),
      actions: [
        TextButton(onPressed:(){
          Navigator.pop(context);
        }, child: Text("确定",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.black),))
      ],
    );
  }

}
