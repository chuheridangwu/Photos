import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mglobalphoto/generated/l10n.dart';
import 'package:mglobalphoto/home/home_page/home_all_page.dart';
import 'package:mglobalphoto/home/home_page/home_avatar_page.dart';
import 'package:mglobalphoto/home/home_page/home_sex_page.dart';
import 'package:mglobalphoto/home/home_page/home_start_page.dart';
import 'package:mglobalphoto/main.dart';
import 'package:mglobalphoto/search/search.dart';
import 'package:mglobalphoto/style/app_config.dart';

import 'home_page/home_classify_page.dart';
import 'home_page/home_album_page.dart';

class HomeLiveView extends StatefulWidget {
  @override
  _HomeLiveViewState createState() => _HomeLiveViewState();
}

class _HomeLiveViewState extends State<HomeLiveView>
    with TickerProviderStateMixin {

  //需要定义一个Controller
  TabController _tabController;

  final navContext = navigatorKey.currentContext;
  List tabs = [
    S.of(navigatorKey.currentContext).home_tab_1,
    S.of(navigatorKey.currentContext).home_tab_2,
    S.of(navigatorKey.currentContext).home_tab_4,
    S.of(navigatorKey.currentContext).home_tab_5,
   ];

  @override
  void initState() {
    super.initState();

    // 创建Controller
    _tabController = TabController(length: tabs.length, vsync: this);

    _initData();

  }

  void _initData() {
    
    Future.delayed(Duration(seconds: 6)).then((value){
      if (AppConfig().isClose == false) {
        setState(() {
          tabs.insert(1,S.of(navigatorKey.currentContext).home_tab_6);
          tabs.add(S.of(navigatorKey.currentContext).home_tab_3);

          _tabController = TabController(length: tabs.length, vsync: this);
          _tabController.animateTo(0);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return  DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: createAppBar(),
        body: TabBarView(
            controller: _tabController,
            children: tabs.map((e) {
              if (e == S.of(navigatorKey.currentContext).home_tab_2) {
                return HomePageClassify();
              }
              if (e == S.of(navigatorKey.currentContext).home_tab_3) {
                return HomePageAlbum();
              }
              if (e == S.of(navigatorKey.currentContext).home_tab_4) {
                return HomePageAvatar();
              }
              if (e == S.of(navigatorKey.currentContext).home_tab_5) {
                return HomePageAll();
              }
              if (e == S.of(navigatorKey.currentContext).home_tab_6) {
                return HomeSexPage();
              }
              return HomePageView();
            }).toList()
          ),
        floatingActionButton: floatingBtn(),
      ),
    );
  }

  // AppBar 设置顶部AppBar
  Widget createAppBar() {
    return PreferredSize(
      preferredSize: Size.fromHeight(44),
      child: AppBar(
        backgroundColor: Colors.white,
        elevation: 0, //隐藏底部阴影分割线
        bottom: TabBar(
          // labelColor: Colors.red,
          indicatorColor: Theme.of(context).primaryColor,
          unselectedLabelColor: Colors.grey,
          isScrollable: true,
          controller: _tabController,
          tabs: tabs.map((e) {
            return Container(
                margin: EdgeInsets.only(bottom: 8), child: Text(e));
          }).toList(),
        ),
      ),
    );
  }

  // floatingActivitionButton
  Widget floatingBtn() {
    return FloatingActionButton(
      child: Icon(Icons.search),
      onPressed: () {
        Navigator.of(context).pushNamed(SearchView.routeName);
      },
    );
  }
}
