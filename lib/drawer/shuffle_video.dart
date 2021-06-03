import 'package:flutter/material.dart';
import 'package:mglobalphoto/drawer/shuffle_serve.dart';
import 'package:mglobalphoto/serve/source_model.dart';
import 'package:video_player/video_player.dart';

class ShuffleVideoPlay extends StatefulWidget {
  static const String routeName = "/ShuffleVideoPlay";
  const ShuffleVideoPlay({Key key}) : super(key: key);

  @override
  _ShuffleVideoPlayState createState() => _ShuffleVideoPlayState();
}

class _ShuffleVideoPlayState extends State<ShuffleVideoPlay> {
  Anchor _anchor;
  VideoPlayerController _videoController;
  bool _isplay = false;

  @override
  void initState() {
    super.initState();
    createVideoController();
  }

  void createVideoController() {
    ShuffleServe().getShuffleVideo().then((value) {
      _anchor = value;
      _videoController = VideoPlayerController.network(_anchor.liveAddres)
        ..initialize().then((_) {
          // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
          print("播放器初始化完成");
          _isplay = true;
          setState(() {});
        }).onError((error, stackTrace) {
          print("播放器播放视频失败 - ${error.toString()}");
          setState(() {
            _isplay = false;
          });
        });
      _videoController.addListener(() {
        if (_videoController.value.isPlaying) {
          print("播放视频 - ${_anchor.liveAddres}");
        } else if (_videoController.value.hasError) {
          setState(() {
            _isplay = false;
          });
        }
      });
      _videoController.setLooping(true);
      _videoController.play();
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    print("视频播放器销毁 - ${_anchor.liveAddres}");
    _videoController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: createLiveView(),
      floatingActionButton: createFloatingBtn(),
    );
  }

  // 创建播放界面
  Widget createLiveView() {
    return _isplay
        ? VideoPlayer(_videoController)
        : Image.asset(
            "images/other/shuffle_bg.png",
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            fit: BoxFit.cover,
          );
  }

  // 创建FloatButton
  Widget createFloatingBtn() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FloatingActionButton(
          heroTag: "2",
          onPressed: () {
            createVideoController();
          },
          child: Icon(Icons.restart_alt),
        ),
        SizedBox(
          height: 10,
        ),
        FloatingActionButton(
          heroTag: "1",
          onPressed: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.close),
        ),
      ],
    );
  }
}
