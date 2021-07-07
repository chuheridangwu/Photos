import 'package:fijkplayer/fijkplayer.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mglobalphoto/drawer/shuffle_serve.dart';
import 'package:mglobalphoto/serve/source_model.dart';

class ShuffleVideoPlay extends StatefulWidget {
  static const String routeName = "/ShuffleVideoPlay";
  const ShuffleVideoPlay({Key key}) : super(key: key);

  @override
  _ShuffleVideoPlayState createState() => _ShuffleVideoPlayState();
}

class _ShuffleVideoPlayState extends State<ShuffleVideoPlay> {
  Anchor _anchor;
  final FijkPlayer _player = FijkPlayer();
  bool _isplay = false;

  @override
  void initState() {
    super.initState();

    _player.setLoop(0);
    _player.addListener(_fijkValueListener);

    createVideoController();
  }

  void createVideoController() {
    ShuffleServe().getShuffleVideo().then((value) {
      _anchor = value;
      _player.setDataSource(_anchor.liveAddres, autoPlay: true);
    });
  }

  void _fijkValueListener() {
    if (_player.value.state == FijkState.initialized) {
      print("开始播放 -- ${_anchor.liveAddres}");
      _isplay = true;
      setState(() {});
    }
    if (_player.value.state == FijkState.error) {
      print("播放视频失败");
      _isplay = false;
      setState(() {});
    }
  }

  @override
  void dispose() {
    super.dispose();
    print("视频播放器销毁 - ${_anchor.liveAddres}");
    _player.removeListener(_fijkValueListener);
    _player.release();
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
        ? FijkView(
            fit: FijkFit.fill,
            player: _player,
            panelBuilder: (a, _, c, f, g) {
              return Container();
            })
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
            _player.reset();
            createVideoController();
          },
          child: Icon(Icons.refresh_sharp),
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
