import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mglobalphoto/home/home_server.dart';
import 'package:mglobalphoto/home/photo_preview.dart';
import 'package:mglobalphoto/serve/source_model.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomePageAvatar extends StatefulWidget {
  @override
  _HomePageAvatarState createState() => _HomePageAvatarState();
}

class _HomePageAvatarState extends State<HomePageAvatar>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final RefreshController _refreshController =
      RefreshController(initialRefresh: true);
  int _index = 0;
  List<Anchor> _anchors = [];

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
    HomeServe.getAvatarList(_index).then((value) {
      setState(() {
        if (_index == 0) {
          _anchors = value;
        } else {
          _anchors.addAll(value);
        }
      });
    });
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          crossAxisCount: 3,
        ),
        itemBuilder: (ctx, index) {
          Anchor anchor = _anchors[index];
          return imgItem(anchor, index);
        });
  }

  // itemView
  Widget imgItem(Anchor anchor, int index) {
    return GestureDetector(
      child: Card(
        clipBehavior: Clip.hardEdge,
        child: CachedNetworkImage(
          imageUrl: anchor.headerIcon,
          fit: BoxFit.cover,
        ),
      ),
      onTap: () {
        Map map = {"index": index, "list": _anchors};
        Navigator.pushNamed(context, PhotoPreView.routeName, arguments: map);
      },
    );
  }
}
