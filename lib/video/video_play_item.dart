import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mglobalphoto/main.dart';
import 'package:mglobalphoto/serve/source_model.dart';
import 'package:mglobalphoto/style/button.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerItem extends StatefulWidget {
  final Anchor anchor;
  VideoPlayerItem(this.anchor);

  @override
  _VideoPlayerItemState createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends State<VideoPlayerItem> {
  VideoPlayerController _videoController;
  bool _isLiveEnd = false;

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.network(widget.anchor.liveAddres)
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        print("播放器初始化完成");

        setState(() {});
      }).onError((error, stackTrace) {
        print("播放器播放视频失败 - ${error.toString()}");
        setState(() {
          _isLiveEnd = true;
        });
      });
    _videoController.addListener(() {
      if (_videoController.value.isPlaying) {
        print("播放视频 - ${widget.anchor.liveAddres}");
      } else if (_videoController.value.hasError) {
        setState(() {
          _isLiveEnd = true;
        });
      }
    });
    _videoController.play();
  }

  @override
  void dispose() {
    super.dispose();
    print("视频播放器销毁 - ${widget.anchor.liveAddres}");
    _videoController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return FutureBuilder(builder: (ctx, asyncs) {
      return Container(
        width: size.width,
        height: size.height,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Positioned(
              bottom: 10,
              right: 10,
              child: IconButton(icon: Icon(Icons.close,),onPressed: (){
              Navigator.of(context).pop();
            },)),
            liveViewWidget(size),
          ],
        ),
      );
    });
  }

  // 直播界面
  Widget liveViewWidget(Size size) {
    return _videoController.value.isInitialized
        ? VideoPlayer(_videoController)
        : CachedNetworkImage(
            imageUrl: widget.anchor.headerIcon,
            width: size.width,
            height: size.height,
            fit: BoxFit.cover,
          );
  }
}
