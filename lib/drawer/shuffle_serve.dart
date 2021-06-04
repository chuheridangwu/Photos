import 'dart:convert';
import 'dart:math';

import 'package:mglobalphoto/serve/http_request.dart';
import 'package:mglobalphoto/serve/source_model.dart';

class ShuffleServe {
  // 获取随机视频
  Future<Anchor> getShuffleVideo() async {
    String url = await HttpRequrst.request("http://mm.jbus.net/get/get1.php");
    final Anchor anchor = Anchor(liveAddres: url);
    return anchor;
  }

  // 获取某个直播视频
  Future<Anchor> getShuffleLive() async {
    String src =
        await HttpRequrst.request("http://api.hclyz.com:81/mf/jsonmihu.txt");
    Map<String, dynamic> data = jsonDecode(src);
    List<dynamic> items = data["zhubo"];
    Map<String, dynamic> item = items[Random().nextInt(items.length - 1)];
    final Anchor anchor = Anchor(liveAddres: item["address"]);
    return anchor;
  }

  // 随机图片
  Future<Anchor> getShufflePhoto() async {
    if (_index < _anchors.length - 2 && _anchors.length != 0) {
      _index += 1;
      return _anchors[_index];
    }
    _anchors = [];
    int index = Random().nextInt(30);
    String src = await HttpRequrst.request(
        "https://image.so.com/j?src=srp&q=%E6%80%A7%E6%84%9F%E7%BE%8E%E5%A5%B3&pn=30&sn=$index");
    Map map = jsonDecode(src);
    List items = map["list"];
    for (var item in items) {
      final Anchor anchor = Anchor(headerIcon: item["thumb"]);
      _anchors.add(anchor);
    }
    _anchors.shuffle();
    Anchor ramAnchor = _anchors[_index];
    return ramAnchor;
  }

  // 性感图片
  List<Anchor> _anchors = [];
  int _index = 0;
  // 因为先调用上面的接口，数组内是有数组的，需要清除掉
  bool _isClean = true; 
  Future<Anchor> getShuffleSeexPhoto() async {

    if (_isClean) {
      _anchors = [];
      _isClean = false;
    }

    if (_index < _anchors.length - 2 && _anchors.length != 0) {
      _index += 1;
      return _anchors[_index];
    }
    _anchors = [];

    String src = await HttpRequrst.request(
        "http://ziti2.com/bizhi/content/public_time_line.php?channel=2&count=100&device=2&start=$_index&version=1");
    Map map = jsonDecode(src);
    if (map["succ"] == 1) {
      List items = map["feeds"];
      for (var item in items) {
        final Anchor anchor = Anchor(headerIcon: item["image_large"]);
        _anchors.add(anchor);
      }
    }
    Anchor ramAnchor = _anchors[_index];

    return ramAnchor;
  }
}
