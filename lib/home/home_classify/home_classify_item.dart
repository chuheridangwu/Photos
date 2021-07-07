import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mglobalphoto/home/home_server.dart';
import 'package:mglobalphoto/home/photo_preview.dart';
import 'package:mglobalphoto/serve/source_model.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomeClassifyItem extends StatefulWidget {
  final Anchor anchor;
  final String desc;
  HomeClassifyItem(this.anchor, this.desc);
  @override
  _HomeClassifyItemState createState() => _HomeClassifyItemState();
}

class _HomeClassifyItemState extends State<HomeClassifyItem>
    with AutomaticKeepAliveClientMixin {
  // 维持widget状态
  @override
  bool get wantKeepAlive => true;

  final RefreshController _refreshController =
      RefreshController(initialRefresh: true);
  List<Anchor> _anchors = [];
  int _index = 0;

  @override
  void initState() {
    super.initState();
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
    String desc = widget.desc == "热门" ? "hot" : "new";
    HomeServe.getClassifyList(widget.anchor.strUid, _index, desc: desc)
        .then((value) {
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
          childAspectRatio: 350 / 540,
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
