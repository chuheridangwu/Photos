import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mglobalphoto/home/home_server.dart';
import 'package:mglobalphoto/serve/source_model.dart';
import 'package:mglobalphoto/video/video_play_list.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomeVideoView extends StatefulWidget {
  const HomeVideoView({ Key key }) : super(key: key);

  @override
  _HomeVideoViewState createState() => _HomeVideoViewState();
}

class _HomeVideoViewState extends State<HomeVideoView>{

  bool get wantKeepAlive => true;
  List<Anchor> _anchors = [];
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
    HomeServe.getLiveAnchors().then((value){
        setState(() {
          _anchors = value;
        });
    });
  }

    @override
  Widget build(BuildContext context) {
    return  SmartRefresher(
        enablePullDown: false,
        enablePullUp: false,
        controller: _refreshController,
        child: createCardView()
    );
  }

  // 创建CardView
  Widget createCardView(){
    return GridView.builder(
        padding: EdgeInsets.all(5),
        itemCount: _anchors.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, //横轴三个子widget
          childAspectRatio: 1, //宽高比为1时，子widget
        ),
        itemBuilder: (ctx, index) {
          Anchor anchor = _anchors[index];
          return createAnchorItem(anchor, () { 
             Map map = {"index": index, "list": _anchors};
            Navigator.pushNamed(context, VideoPlayListView.routeName,
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