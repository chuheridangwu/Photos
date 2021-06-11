import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:lpinyin/lpinyin.dart';
import 'package:mglobalphoto/banner/banner.dart';
import 'package:mglobalphoto/banner/banner_list.dart';
import 'package:mglobalphoto/demo.dart';
import 'package:mglobalphoto/drawer/drawer.dart';
import 'package:mglobalphoto/drawer/shuffle_photo.dart';
import 'package:mglobalphoto/drawer/shuffle_serve.dart';
import 'package:mglobalphoto/drawer/shuffle_video.dart';
import 'package:mglobalphoto/drawer/privaty_webview.dart';
import 'package:mglobalphoto/home/home.dart';
import 'package:mglobalphoto/home/home_classify/home_classify_tabbar.dart';
import 'package:mglobalphoto/home/home_page/home_start_item.dart';
import 'package:mglobalphoto/home/home_page/home_album_item.dart';
import 'package:mglobalphoto/home/photo_preview.dart';
import 'package:mglobalphoto/search/search.dart';
import 'package:mglobalphoto/search/search_result.dart';
import 'package:mglobalphoto/serve/admob_manage.dart';
import 'package:mglobalphoto/style/app_config.dart';
import 'package:mglobalphoto/style/style.dart';
import 'package:mglobalphoto/video/video.dart';
import 'package:mglobalphoto/video/video_list.dart';
import 'package:mglobalphoto/video/video_play_list.dart';
import 'package:share/share.dart';

import 'generated/l10n.dart';
import 'home/home_page/home_all_item.dart';

void main() {
  // 进制横屏
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
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

final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();
const MaterialColor primaryBlack = MaterialColor(
  _blackPrimaryValue,
  <int, Color>{
    50: Color(0xFF000000),
    100: Color(0xFF000000),
    200: Color(0xFF000000),
    300: Color(0xFF000000),
    400: Color(0xFF000000),
    500: Color(_blackPrimaryValue),
    600: Color(0xFF000000),
    700: Color(0xFF000000),
    800: Color(0xFF000000),
    900: Color(0xFF000000),
  },
);
const int _blackPrimaryValue = 0xFFFFCDD2;
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // AdmobManage();
    return MaterialApp(
      title: 'MGlobal Photo',
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate, // 指定本地化的字符串和一些其他的值
        GlobalCupertinoLocalizations.delegate, // 对应的Cupertino风格
        GlobalWidgetsLocalizations.delegate, // 指定默认的文本排列方向, 由左到右或由右到左
        S.delegate
      ],
      supportedLocales: S.delegate.supportedLocales,
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      theme: ThemeData(
        primarySwatch: primaryBlack
      ),
      home: MainPageView(),
      routes: {
        SearchView.routeName: (ctx) => SearchView(),
        SearchListView.routeName: (ctx) => SearchListView(),
        VideoListView.routeName: (ctx) => VideoListView(),
        VideoPlayListView.routeName: (ctx) => VideoPlayListView(),
        BannerListView.routeName: (ctx) => BannerListView(),
        HomePageStartList.routeName: (ctx) => HomePageStartList(),
        ShuffleVideoPlay.routeName: (ctx) => ShuffleVideoPlay(),
        PrivatyWebView.routeName: (ctx) => PrivatyWebView(),
        PhotoPreView.routeName: (ctx) => PhotoPreView(),
        ShufflePhoto.routeName: (ctx) => ShufflePhoto(),
        HomePageAlbumItem.routeName: (ctx) => HomePageAlbumItem(),
        HomeClassifyTabbar.routeName: (ctx) => HomeClassifyTabbar(),
        HomeAllItem.routeName: (ctx) => HomeAllItem(),
      },
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
  void didChangeDependencies() {
    super.didChangeDependencies();
    Future.delayed(Duration(seconds: 5))
        .then((value) => AdmobManage().showInterstitialAd());
  }

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
          selectedFontSize: 14,
          selectedItemColor: Colors.black,
          items: navBarItems),
    );
  }

  // APPBar
  Widget createAppbar() {
    return AppBar(
      title: Text('MGlobal Photo'),
      elevation: 0, //隐藏底部阴影分割线
      leading: Builder(builder: (ctx) {
        return IconButton(
            icon: Icon(Icons.list),
            onPressed: () {
              Scaffold.of(ctx).openDrawer();
            });
      }),
      actions: [
        // 分享
        IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              Share.share('check out my website https://example.com');
              if (Platform.isAndroid) {
                
              } else {
                Share.share("分享当前应用 http://itunes.apple.com/cn/app/id1571237171?mt=8");
              }
            })
      ],
    );
  }
}

class MyNavBarItem extends BottomNavigationBarItem {
  MyNavBarItem(String title, IconData icon, IconData activeIcon)
      : super(
            label: title,
            icon: Icon(icon),
            activeIcon: Icon(
              activeIcon,
            ));
}

List<BottomNavigationBarItem> navBarItems = [
  MyNavBarItem(S.of(navigatorKey.currentContext).home, Icons.home, Icons.home_outlined),
  MyNavBarItem(S.of(navigatorKey.currentContext).video, Icons.play_circle_fill, Icons.play_circle_outline),
  MyNavBarItem(S.of(navigatorKey.currentContext).banner, Icons.view_headline, Icons.view_headline),
];

List<Widget> pages = [
  HomeLiveView(),
  VideoTypeView(),
  BannerView(),
];
