import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mglobalphoto/serve/admob_manage.dart';
import 'package:mglobalphoto/serve/source_model.dart';
import 'package:mglobalphoto/video/video_serve.dart';
import 'package:mglobalphoto/video/video.dart';
import 'package:mglobalphoto/video/video_play_item.dart';
import 'package:mglobalphoto/video/video_play_list.dart';

class VideoListView extends StatefulWidget {
  static const String routeName = "/VideoListView_RouteName";

  @override
  _VideoListViewState createState() => _VideoListViewState();
}

class _VideoListViewState extends State<VideoListView> {
  final VideoServe _serve = VideoServe();
  VideoTypeData _typeData;
  List<Anchor> _anchors = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _typeData = ModalRoute.of(context).settings.arguments as VideoTypeData;
    refreshData();
  }

  void refreshData() {
    _serve.getVideoListData(_typeData.path).then((value) {
      _anchors = value;
      _anchors.shuffle();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder(
          builder: (ctx, asyncs) {
            return Text(_typeData.title);
          },
        ),
      ),
      body: Column(children: [
        Expanded(child: createGridView())
      ]),
    );
  }

  // GridView
  Widget createGridView() {
    return GridView.builder(
        padding: EdgeInsets.all(5),
        itemCount: _anchors.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, //横轴三个子widget
          childAspectRatio: 0.6,
        ),
        itemBuilder: (ctx, index) {
          final itemData = _anchors[index];
          return VideoTypeItem(itemData, () {
            Map map = {"index": index, "list": _anchors};
            Navigator.pushNamed(context, VideoPlayListView.routeName,
                arguments: map);
          });
        });
  }
}

class VideoTypeItem extends StatelessWidget {
  final Anchor data;
  final VoidCallback callback;
  VideoTypeItem(this.data, this.callback);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: CachedNetworkImageProvider(data.headerIcon),
                  fit: BoxFit.cover)),
          child: bottomWidget(),
        ),
      ),
      onTap: callback,
    );
  }

  // 底部昵称和观看人数
  Widget bottomWidget() {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: EdgeInsets.fromLTRB(5, 0, 0, 5),
      child: Row(
        children: [
          Expanded(
              child: Text(
            data.videoTime,
            style: TextStyle(
                color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
          ))
        ],
      ),
    );
  }
}
