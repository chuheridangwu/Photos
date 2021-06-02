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
  Future<Anchor> getShuffleLive() async{
    String src = await HttpRequrst.request("http://api.hclyz.com:81/mf/jsonmihu.txt");
    Map<String,dynamic> data  = jsonDecode(src);
    List<dynamic> items = data["zhubo"];
    Map<String,dynamic> item = items[Random().nextInt(items.length-1)]; 
    final Anchor anchor = Anchor(liveAddres: item["address"]);
    return anchor;
  }
}