import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mglobalphoto/home/photo_preview.dart';
import 'package:mglobalphoto/search/search.dart';
import 'package:mglobalphoto/search/search_page.dart';
import 'package:mglobalphoto/search/serarch_serve.dart';
import 'package:mglobalphoto/serve/source_model.dart';

class SearchListView extends StatefulWidget {
  static const routeName = "/SearchListView";
  @override
  _SearchListViewState createState() => _SearchListViewState();
}

class _SearchListViewState extends State<SearchListView>
    with SingleTickerProviderStateMixin {

  final SearchServe _serve = SearchServe.initData();
  TabController _tabController;
  String _keyword = "";

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _serve.types.length, vsync: this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    String key = ModalRoute.of(context).settings.arguments as String;
    setState(() {
      _keyword = key;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: _serve.types.length,
        child: Scaffold(
          appBar: createAppBar(),
          body: TabBarView(
            controller: _tabController,
            children: _serve.types.map((e) {
              e.keyword = _keyword;
              return SearchPageView(e);
            }).toList(),
          ),
        ));
  }

  // AppBar 设置顶部AppBar
  Widget createAppBar() {
    return AppBar(
      title: Text("$_keyword"),
      elevation: 0, //隐藏底部阴影分割线
      bottom: TabBar(
        controller: _tabController,
        isScrollable: true,
        labelColor: Colors.white,
        indicatorColor: Theme.of(context).primaryColor,
        unselectedLabelColor: Colors.black87,
        tabs: _serve.types.map((e) {
          return Tab(
            text:e.title,
          );
        }).toList(),
      ),
    );
  }

}