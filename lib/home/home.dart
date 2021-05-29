import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mglobalphoto/serve/data_manage.dart';
import 'package:mglobalphoto/serve/source_model.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'home_item.dart';

class HomeLiveView extends StatefulWidget {
  @override
  _HomeLiveViewState createState() => _HomeLiveViewState();
}

class _HomeLiveViewState extends State<HomeLiveView>
    with SingleTickerProviderStateMixin {
  // 主播数据
  List<Anchor> anchorList = [];
  // 切换大小图
  int _rowCount = 2;
  //需要定义一个Controller
  TabController _tabController;
  List tabs = ["精选", "分类", "专题", "头像", "大全"];
  // 监听滑动
  RefreshController _refreshController =
      RefreshController(initialRefresh: true);

  @override
  void initState() {
    super.initState();
    // 创建Controller
    _tabController = TabController(length: tabs.length, vsync: this);
  }

  void _onRefresh() {
    getAnchorListData();
  }

  void _onLoading() async {
    getAnchorListData();
  }

  // 获取主播数据
  void getAnchorListData() {
    _refreshController.refreshCompleted();
    _refreshController.loadComplete();
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
          labelColor: Colors.red,
          indicatorColor: Colors.green,
          unselectedLabelColor: Colors.blue,
          isScrollable: true,
          controller: _tabController,
          tabs: tabs.map((e){
            return Text(e);
          }).toList(),
        ),
      ),
    );
  }

  // 创建列表
  Widget createListView() {
    return SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        header: WaterDropHeader(),
        footer: ClassicFooter(
          loadStyle: LoadStyle.ShowWhenLoading,
        ),
        controller: _refreshController,
        child: gardViewWidget());
  }

  // 卡片View
  Widget gardViewWidget() {
    return GridView.builder(
        padding: EdgeInsets.all(5),
        itemCount: anchorList.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: _rowCount, //横轴三个子widget
          childAspectRatio: 1, //宽高比为1时，子widget
        ),
        itemBuilder: (ctx, index) {
          final anchor = anchorList[index];
          return HomeItem(anchor, () {
            Navigator.push(context, MaterialPageRoute(builder: (_) {}));
          });
        });
  }

  // floatingActivitionButton
  Widget floatingBtn() {
    return FloatingActionButton(
      child: Icon(_rowCount == 1 ? Icons.menu : Icons.apps),
      onPressed: () {
        setState(() {
          _rowCount = _rowCount == 1 ? 2 : 1;
        });
      },
    );
  }
}

class HomePageView extends StatefulWidget {
  @override
  _HomePageViewState createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {

  List<Anchor> anchorList = [];

  @override
    void initState() {
      super.initState();
      DataManage().jingxuans.then((value){
        setState(() {
                  anchorList = value;
                  anchorList.shuffle();
                });
      });
    }

  @override
  Widget build(BuildContext context) {
    return  GridView.builder(
        padding: EdgeInsets.all(5),
        itemCount: anchorList.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, //横轴三个子widget
          childAspectRatio: 0.85, //宽高比为1时，子widget
        ),
        itemBuilder: (ctx, index) {
          final anchor = anchorList[index];
          return HomeItem(anchor, () {
            Navigator.push(context, MaterialPageRoute(builder: (_) {}));
          });
        });
  }
}
