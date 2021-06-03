import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mglobalphoto/home/home_page/home_start_page.dart';
import 'package:mglobalphoto/search/search.dart';
import 'package:mglobalphoto/serve/data_manage.dart';
import 'package:mglobalphoto/serve/source_model.dart';
import 'package:mglobalphoto/style/appconfig.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'home_page/home_start_desc.dart';
import 'home_page/home_album_page.dart';

class HomeLiveView extends StatefulWidget {
  @override
  _HomeLiveViewState createState() => _HomeLiveViewState();
}

class _HomeLiveViewState extends State<HomeLiveView> with SingleTickerProviderStateMixin {

  // 切换大小图
  int _rowCount = 2;
  //需要定义一个Controller
  TabController _tabController;
  List tabs = ["精选", "分类", "专题", "头像", "大全"];

  @override
  void initState() {
    super.initState();
    // 创建Controller
    _tabController = TabController(length: tabs.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: createAppBar(),
        body: TabBarView(
            controller: _tabController,
            children: tabs.map((e) {
              if (e == "专题") {
                return HomePageAlbum();
              }
              return HomePageView();
            }).toList()),
        floatingActionButton: floatingBtn(),
      ),
    );
  }

  // AppBar 设置顶部AppBar
  Widget createAppBar() {
    return PreferredSize(
      preferredSize: Size.fromHeight(35),
      child: AppBar(
        backgroundColor: Colors.white,
        elevation: 0, //隐藏底部阴影分割线
        bottom: TabBar(
          // labelColor: Colors.red,
          indicatorColor: Theme.of(context).primaryColor,
          // unselectedLabelColor: Colors.blue,
          isScrollable: true,
          controller: _tabController,
          tabs: tabs.map((e){
            return Text(e);
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