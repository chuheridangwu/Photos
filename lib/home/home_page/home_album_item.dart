import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mglobalphoto/home/home_page/home_start_desc.dart';
import 'package:mglobalphoto/home/home_page/home_start_item.dart';
import 'package:mglobalphoto/home/home_server.dart';
import 'package:mglobalphoto/home/photo_preview.dart';
import 'package:mglobalphoto/serve/admob_manage.dart';
import 'package:mglobalphoto/serve/source_model.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomePageAlbumItem extends StatefulWidget {
  static const routeName = "/HomePageAlbumItem";
  @override
  _HomePageAlbumItemState createState() => _HomePageAlbumItemState();
}

class _HomePageAlbumItemState extends State<HomePageAlbumItem> {
  List<Anchor> _anchors = [];
  Anchor _anchor;
  int _index = 0;
  final HomeServe _serve = HomeServe();
  BannerAd _anchoredBanner;

  // 监听滑动
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _anchor = ModalRoute.of(context).settings.arguments as Anchor;
    AdmobManage().createAnchoredBanner(context, (ad) {
      setState(() {
        _anchoredBanner = ad;
      });
    });
    refreshData();
  }

  void refreshData() {
    _index = 0;
    requestData();
  }

  // 加载更多
  void loadMoreData() {
    _index += 30;
    requestData();
  }

  // 网络请求
  void requestData() {
    _serve.getAlbumList(_anchor.pathID, _index).then((value) {
      setState(() {
        if (_index == 0) {
          _anchors = value;
        } else {
          _anchors.addAll(value);
        }
      });
    });
    _refreshController.refreshCompleted();
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder(
          builder: (ctx, async) {
            return Text(_anchor.userName);
          },
        ),
      ),
      body: Column(
        children: [
          _anchoredBanner != null
              ? Container(
                  height: AdSize.banner.height.toDouble(),
                  width: AdSize.banner.width.toDouble(),
                  child: AdWidget(ad: _anchoredBanner),
                )
              : Container(),
          Expanded(child: createSmartView())
        ],
      ),
    );
  }

  Widget createSmartView() {
    return SmartRefresher(
        enablePullUp: true,
        onRefresh: refreshData,
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
        ),
        itemBuilder: (ctx, index) {
          final anchor = _anchors[index];
          return createAnchorItem(anchor, () {
            Map map = {"index": index, "list": _anchors};
            Navigator.pushNamed(context, PhotoPreView.routeName,
                arguments: map);
          });
        });
  }

  // 单个Item
  Widget createAnchorItem(Anchor anchor, VoidCallback callback) {
    return GestureDetector(
      child: Card(
          clipBehavior: Clip.antiAlias,
          child: CachedNetworkImage(
            imageUrl: anchor.headerIcon,
            fit: BoxFit.cover,
          )),
      onTap: callback,
    );
  }
}
