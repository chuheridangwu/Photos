import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mglobalphoto/home/home_server.dart';
import 'package:mglobalphoto/serve/source_model.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'photo_preview.dart';

class PhotoListView extends StatefulWidget {
  static const routeName = "/PhotoListView";

  @override
  _PhotoListViewState createState() => _PhotoListViewState();
}

class _PhotoListViewState extends State<PhotoListView>
    with AutomaticKeepAliveClientMixin {
  bool get wantKeepAlive => true;
  List<Anchor> _imgs = [];
  String _title = "";

  // 监听滑动
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
    _onRefreshData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Map map = ModalRoute.of(context)?.settings.arguments as Map;
    String linkUrl = map["linkUrl"];
    String title = map["title"];
    
    HomeServe.getPhotosData(linkUrl).then((value) {
      setState(() {
        _imgs = value;
        _title = title;
      });
    });
  }

  void _onRefreshData() {
    _onLoadData();
  }

  void _onLoadData() {
    _refreshController.refreshCompleted();
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
      ),
      body: createSmartRefresher(),
    );
  }

  Widget createSmartRefresher(){
    return SmartRefresher(
        enablePullDown: true,
        enablePullUp: false,
        onRefresh: _onRefreshData,
        header: WaterDropHeader(),
        controller: _refreshController,
        child: createCardView());
  }

  // 创建CardView
  Widget createCardView() {
    return GridView.builder(
        padding: EdgeInsets.all(5),
        itemCount: _imgs.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, //横轴三个子widget
          childAspectRatio: 236 / 354, //宽高比为1时，子widget
        ),
        itemBuilder: (ctx, index) {
          final anchor = _imgs[index];
          return createView(anchor.headerIcon, () {
            Map map = {"index": index, "list": _imgs};
            Navigator.pushNamed(context, PhotoPreView.routeName,
                arguments: map);
          });
        });
  }

  Widget createView(String anchor, VoidCallback callback) {
    return GestureDetector(
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: CachedNetworkImageProvider(anchor),
                  fit: BoxFit.cover)),
        ),
      ),
      onTap: callback,
    );
  }
}
