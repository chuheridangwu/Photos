import 'package:flutter/material.dart';
import 'package:lpinyin/lpinyin.dart';
import 'package:mglobalphoto/generated/l10n.dart';
import 'package:mglobalphoto/home/home_classify/home_classify_item.dart';
import 'package:mglobalphoto/main.dart';
import 'package:mglobalphoto/serve/source_model.dart';

class HomeClassifyTabbar extends StatefulWidget {
  static const routeName = "/HomeClassifyTabbar";
  @override
  _HomeClassifyTabbarState createState() => _HomeClassifyTabbarState();
}

class _HomeClassifyTabbarState extends State<HomeClassifyTabbar> with SingleTickerProviderStateMixin {

  TabController _tabController;
  final _tabs = [S.of(navigatorKey.currentContext).cat_hot_1,S.of(navigatorKey.currentContext).cat_hot_2];
  Anchor _anchor;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _anchor = ModalRoute.of(context).settings.arguments as Anchor;
    _tabController = TabController(initialIndex: 0,length: _tabs.length,vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(length: _tabs.length, child: Scaffold(
      appBar: AppBar(
        title: FutureBuilder(builder: (ctx,asyncs){
          return Text(PinyinHelper.getPinyin(_anchor.userName));
        },),
        bottom: TabBar(
          labelStyle: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),
          controller: _tabController,
          tabs: _tabs.map((e){
            return Tab(text: e,);
          }).toList()),
      ),
      body: TabBarView(
      controller: _tabController,
      children: _tabs.map((e){
        return HomeClassifyItem(_anchor,e);
      }).toList(),),
    ));
  }

}