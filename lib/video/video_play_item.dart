import 'package:cached_network_image/cached_network_image.dart';
import 'package:fijkplayer/fijkplayer.dart';
import 'package:flutter/material.dart';
import 'package:mglobalphoto/main.dart';
import 'package:mglobalphoto/serve/source_model.dart';
import 'package:mglobalphoto/style/button.dart';

class VideoPlayerItem extends StatefulWidget {
  final Anchor anchor;
  VideoPlayerItem(this.anchor);

  @override
  _VideoPlayerItemState createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends State<VideoPlayerItem> {
  final FijkPlayer _player = FijkPlayer();
  bool _isLiveEnd = true;

  @override
  void initState() {
    super.initState();
    _player.addListener(_fijkValueListener);
    _player.setLoop(0);
    _player.setDataSource(widget.anchor.liveAddres,autoPlay: true);
  }

  void _fijkValueListener() {
    if (_player.value.state == FijkState.initialized) {
      print("开始播放 -- ${widget.anchor.liveAddres}");
      _isLiveEnd = false;
      setState(() {});
    }
    if (_player.value.state == FijkState.error) {
      print("播放视频失败");
      _isLiveEnd = true;
      setState(() {});
    }
  }

  @override
  void dispose() {
    super.dispose();
    print("视频播放器销毁 - ${widget.anchor.liveAddres}");
    _player.removeListener(_fijkValueListener);
    _player.release();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return FutureBuilder(builder: (ctx, asyncs) {
      return Scaffold(
        body: Container(
          width: size.width,
          height: size.height,
          child: Stack(
            fit: StackFit.expand,
            children: [
              liveViewWidget(size),
            ],
          ),
        ),
      );
    });
  }

  // 直播界面
  Widget liveViewWidget(Size size) {
    return FijkView(
            fit: FijkFit.fill,
            player: _player,
            cover: CachedNetworkImageProvider(widget.anchor.headerIcon),
            panelBuilder: (a, _, c, f, g) {
              return Container();
            });
  }
}
