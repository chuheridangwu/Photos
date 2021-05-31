import 'dart:convert';
import 'dart:core';

import 'package:flutter/services.dart';
import 'package:mglobalphoto/serve/source_model.dart';

class VideoServe{

  final List<VideoTypeData> videoTypes = [];
  VideoServe();

  // 初始化
  VideoServe.initData(){
    List titles = ["跑马灯","风景建筑","经典影视","动物萌宠","唯美动态","抖音网红","情侣爱情","文字控","炫酷创意","火爆游戏","卡通动漫","娱乐明星","男人","明星","其他"];
    for (var i = 0; i < titles.length; i++) {
      VideoTypeData videos = VideoTypeData(titles[i],"images/video_type_0.jpeg","res/$i.json");
      videoTypes.add(videos);
    }
  }

  Future<List<Anchor>> getVideoListData(String path) async {
    String src = await rootBundle.loadString(path);
    Map<String,dynamic> jsonData = jsonDecode(src);
    List<Anchor> anchors = [];
    for (var item in jsonData["data"]["list"]) {
      String icon = item["smallUrl"];
      String time = item["videoTime"]; 
      String liveUrl = item["movUrl"];
      Anchor anchor = Anchor(headerIcon: icon,videoTime: time,liveAddres: liveUrl);
      anchors.add(anchor);
    }
    return anchors;
  }

}

class VideoTypeData{
  String title;
  String icon;
  String path;
  VideoTypeData(this.title,this.icon,this.path);
}

/*


*/