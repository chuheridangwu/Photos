import 'package:flutter/material.dart';
import 'package:mglobalphoto/serve/source_model.dart';
import 'package:mglobalphoto/video/video_play_item.dart';

class VideoPlayListView extends StatefulWidget {
  static const routeName = "/VideoPlayListView";
  @override
  _VideoPlayListViewState createState() => _VideoPlayListViewState();
}

class _VideoPlayListViewState extends State<VideoPlayListView> {
  List<Anchor> _anchors = [];
  int _index = 0;
  PageController _pageController;

  @override
  void initState() {
    super.initState();
  }

  // 滚动视图
  void onPageChangeVlaue(int page) {
    setState(() {
      _index += 1;
      if (_index == _anchors.length) {
        _index = 0;
        _pageController.jumpToPage(_index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Map data = ModalRoute.of(context).settings.arguments as Map;
    _anchors = data["list"];
    _index = data["index"];
    _pageController = PageController(initialPage: _index);
    return  Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.close),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        body: PageView.builder(
            onPageChanged: onPageChangeVlaue,
            controller: _pageController,
            scrollDirection: Axis.vertical,
            itemCount: _anchors.length,
            itemBuilder: (ctx, index) {
              final Anchor anchor = _anchors[index];
              return VideoPlayerItem(anchor);
            }),
    );
  }
}
