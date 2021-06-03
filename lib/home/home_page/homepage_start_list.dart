import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mglobalphoto/home/home_server.dart';
import 'package:mglobalphoto/home/photo_preview.dart';
import 'package:mglobalphoto/serve/source_model.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomePageStartList extends StatefulWidget {
  static const routeName = "/HomePageStartList";
  @override
  _HomePageStartListState createState() => _HomePageStartListState();
}

class _HomePageStartListState extends State<HomePageStartList> {
  List<Anchor> _anchors = [];
  Anchor _anchor;
  int _page = 0;
  final HomeServe _serve = HomeServe();
  // 监听滑动
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _anchor = ModalRoute.of(context).settings.arguments as Anchor;
    requestData();
  }

  // 加载更多
  void loadMoreData() {
    _page += 1;
    requestData();
  }

  // 网络请求
  void requestData() {
    _serve.getStartList(_anchor.uid, _page).then((value) {
      setState(() {
        if (_page == 0) {
          _anchors = value;
        } else {
          _anchors.addAll(value);
        }
        _refreshController.loadComplete();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder(
          builder: (ctx, asyncs) {
            return Text(_anchor.userName);
          },
        ),
      ),
      body: createSmartView(),
    );
  }

  // 创建smart
  Widget createSmartView() {
    return SmartRefresher(
        enablePullDown: false,
        enablePullUp: true,
        onLoading: loadMoreData,
        footer: ClassicFooter(
          loadStyle: LoadStyle.ShowWhenLoading,
        ),
        controller: _refreshController,
        child: createCardView());
  }

  // 创建CardView
  Widget createCardView() {
    return GridView.builder(
        padding: EdgeInsets.all(5),
        itemCount: _anchors.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, //横轴三个子widget
          childAspectRatio: 235 / 417, //宽高比为1时，子widget
        ),
        itemBuilder: (ctx, index) {
          final anchor = _anchors[index];
          return GestureDetector(
            onTap: () {
              Map map = {"index":index,"list":_anchors};
              Navigator.pushNamed(context, PhotoPreView.routeName,arguments: map);
            },
            child: CachedNetworkImage(
              placeholder: (context, url) => Container(),
              errorWidget: (context, url, _) => Container(),
              imageUrl: anchor.headerIcon,
              fit: BoxFit.cover,
            ),
          );
        });
  }
}
