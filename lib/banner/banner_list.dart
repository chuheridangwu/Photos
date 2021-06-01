import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mglobalphoto/serve/banner_serve.dart';
import 'package:mglobalphoto/serve/source_model.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class BannerListView extends StatefulWidget {
  static const routeName = "/BannerListView";
  @override
  _BannerListViewState createState() => _BannerListViewState();
}

class _BannerListViewState extends State<BannerListView> {
  List<Anchor> _anchors = [];
  BannerType _bannerType;
  final BannerServe _serve = BannerServe.initData();
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _bannerType = ModalRoute.of(context).settings.arguments as BannerType;
    refreshData();
  }

  // 下拉刷新
  void refreshData() {
      _bannerType.start = 0;
      _bannerType.count = 30;
      requestData();
  }

  // 加载更多
  void loadMoreData(){
    _bannerType.start += 30;
    _bannerType.count += 30;
    requestData();
  }

  // 网络请求
  void requestData(){
      _serve.getCategoryData(_bannerType.path).then((value) {
      setState(() {
        if (_bannerType.start > 0) {
          _anchors.addAll(value);
        }else{
          _anchors = value;
        }
      });
    });
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder(
          builder: (ctx, asyncs) {
            return Text(_bannerType.title);
          },
        ),
      ),
      body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
        onRefresh: refreshData,
        onLoading: loadMoreData,
        header: WaterDropHeader(),
        footer: ClassicFooter(
          loadStyle: LoadStyle.ShowWhenLoading,
        ),
        controller: _refreshController,
        child: createGridView(),
      ),
    );
  }

  // 创建GridView
  Widget createGridView() {
    return GridView.builder(
      itemCount: _anchors.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1
      ),
       itemBuilder: (ctx,index){
       return CachedNetworkImage(
            imageUrl: _anchors[index].headerIcon,
            fit: BoxFit.cover,
          );
    });
  }
}
