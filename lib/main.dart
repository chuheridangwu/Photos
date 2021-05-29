import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mglobalphoto/demo.dart';
import 'package:mglobalphoto/home/drawer.dart';
import 'package:mglobalphoto/home/home.dart';
import 'package:mglobalphoto/video/video.dart';
import 'package:share/share.dart';

void main() {
  // 进制横屏
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(new MyApp());
    if (Platform.isAndroid) {
      //设置Android头部的导航栏透明
      SystemUiOverlayStyle systemUiOverlayStyle =
          SystemUiOverlayStyle(statusBarColor: Colors.transparent);
      SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
    }
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MGlobal Photo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.yellow,
      ),
      home: MainPageView(),
    );
  }
}

class MainPageView extends StatefulWidget {
  @override
  _MainPageViewState createState() => _MainPageViewState();
}

class _MainPageViewState extends State<MainPageView> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: createAppbar(),
      drawer: PhotoDrawer(),
      body: IndexedStack(
        index: _currentIndex,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          fixedColor: Colors.black,
          items: navBarItems),
    );
  }

  // APPBar
  Widget createAppbar(){
    return AppBar(
        title: Text("MGlobal Photo"),
        elevation: 0,//隐藏底部阴影分割线
        leading: Builder(builder: (ctx){
          return IconButton(icon: Icon(Icons.list), onPressed: (){
            Scaffold.of(ctx).openDrawer();
          });
        }),
        actions: [
          // 分享
          IconButton(icon: Icon(Icons.share), onPressed: (){
            Share.share('check out my website https://example.com');
          })
        ],
      );
  }
}

class MyNavBarItem extends BottomNavigationBarItem {
  MyNavBarItem(String title, IconData icon, IconData activeIcon)
      : super(label: title, icon: Icon(icon), activeIcon: Icon(activeIcon));
}

List<BottomNavigationBarItem> navBarItems = [
  MyNavBarItem("Home", Icons.home, Icons.home_outlined),
  MyNavBarItem("Video", Icons.play_circle_fill, Icons.play_circle_outline),
  MyNavBarItem("Video", Icons.play_circle_fill, Icons.play_circle_outline),

];

List<Widget> pages = [
  HomeLiveView(),
  VideoListView(),
  TabbarBgColorTest(),
];
