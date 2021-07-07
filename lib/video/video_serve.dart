import 'dart:convert';
import 'dart:core';

import 'package:flutter/services.dart';
import 'package:mglobalphoto/generated/l10n.dart';
import 'package:mglobalphoto/main.dart';
import 'package:mglobalphoto/serve/source_model.dart';

class VideoServe{

  final List<VideoTypeData> videoTypes = [];
  VideoServe();

  // 初始化
  VideoServe.initData(){
    final context = navigatorKey.currentContext;
    List titles = [
      S.of(context).video_1,
      S.of(context).video_2,
      S.of(context).video_3,
      S.of(context).video_4,
      S.of(context).video_5,
      S.of(context).video_6,
      S.of(context).video_7,
      S.of(context).video_8,
      S.of(context).video_9,
      S.of(context).video_10,
      S.of(context).video_11,
      S.of(context).video_12,
      S.of(context).video_13,
      S.of(context).video_14,
      S.of(context).video_15,
    ];
     for (var i = 0; i < titles.length; i++) {
      VideoTypeData videos = VideoTypeData(titles[i],"images/video_type_$i.jpg","res/$i.json");
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