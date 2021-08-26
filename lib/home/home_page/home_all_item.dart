import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mglobalphoto/home/home_server.dart';
import 'package:mglobalphoto/home/photo_preview.dart';
import 'package:mglobalphoto/serve/source_model.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomeAllItem extends StatefulWidget {
  static const routeName = "/HomeAllItem";

  @override
  _HomeAllItemState createState() => _HomeAllItemState();
}

class _HomeAllItemState extends State<HomeAllItem> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  List<Anchor> _anchors = [];
  int _index = 0;
  Anchor _anchor;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _anchor = ModalRoute.of(context).settings.arguments as Anchor;
    requestData();
  }

  void refreshData() {
    Future.delayed(Duration(seconds: 1)).then((value) {
      _refreshController.refreshCompleted();
    });
  }

  void loadMoreData() {
    _index += 30;
    requestData();
  }

  void requestData() {
    HomeServe.getAllList(_anchor.strUid, _index,desc: _anchor.desc).then((value) {
      setState(() {
        if (_index > 0) {
          _anchors.addAll(value);
        } else {
          _anchors = value;
        }
      });
    });
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _anchor.userName,
        ),
      ),
      body: createSmartView(),
    );
  }

  Widget createSmartView() {
    return SmartRefresher(
        enablePullUp: true,
        onRefresh: refreshData,
        onLoading: loadMoreData,
        header: WaterDropHeader(),
        footer: ClassicFooter(
          loadStyle: LoadStyle.ShowWhenLoading,
        ),
        controller: _refreshController,
        child: createGridView());
  }

  // GaridView
  Widget createGridView() {
    return GridView.builder(
        itemCount: _anchors.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          mainAxisSpacing: 5,
          crossAxisSpacing: 5,
          crossAxisCount: 2,
          childAspectRatio: 350 / 500,
        ),
        itemBuilder: (ctx, index) {
          Anchor anchor = _anchors[index];
          return imgItem(anchor, index);
        });
  }

  // itemView
  Widget imgItem(Anchor anchor, int index) {
    return GestureDetector(
      child: CachedNetworkImage(
        imageUrl: anchor.headerIcon,
        fit: BoxFit.cover,
      ),
      onTap: () {
        Map map = {"index": index, "list": _anchors};
        Navigator.pushNamed(context, PhotoPreView.routeName, arguments: map);
      },
    );
  }
}
