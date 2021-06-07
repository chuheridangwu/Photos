import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mglobalphoto/drawer/shuffle_serve.dart';
import 'package:mglobalphoto/home/home_server.dart';
import 'package:mglobalphoto/serve/admob_manage.dart';
import 'package:mglobalphoto/serve/source_model.dart';
import 'package:mglobalphoto/style/app_config.dart';
import 'package:photo_view/photo_view.dart';

class ShufflePhoto extends StatefulWidget {
  static const routeName = "/ShufflePhoto";
  const ShufflePhoto({Key key}) : super(key: key);

  @override
  _ShufflePhotoState createState() => _ShufflePhotoState();
}

class _ShufflePhotoState extends State<ShufflePhoto> {
  int _count = 0;
  Anchor _anchor;
  final ShuffleServe _serve = ShuffleServe();

  @override
  void initState() {
    super.initState();
    getPhotoUrl();
  }

  // 获取图片数据
  void getPhotoUrl() {
    if (AppConfig().isClose) {
      _serve.getShufflePhoto().then((value) {
          setState(() {
            _anchor = value;
          });
        });
    } else {
      _serve.getShuffleSeexPhoto().then((value) {
          setState(() {
            _anchor = value;
          });
        });
    }
    _count += 1;
    if (_count % 20 == 0) {
      AdmobManage().showRewardedAd();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _anchor != null
          ? PhotoView(
              imageProvider: CachedNetworkImageProvider(_anchor.headerIcon),
              loadingBuilder: (ctx, event) {
                return Container();
              },
            )
          : Container(),
      floatingActionButton: createFloatingBtn(),
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
            getPhotoUrl();
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
