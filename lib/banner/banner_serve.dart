import 'dart:convert';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:mglobalphoto/generated/l10n.dart';
import 'package:mglobalphoto/main.dart';
import 'package:mglobalphoto/serve/http_request.dart';
import 'package:mglobalphoto/serve/source_model.dart';

class BannerServe{
  List<BannerType> tabs = [];  
  BannerServe.initData(){
    final context = navigatorKey.currentContext;
    List titles = [
      S.of(context).banner_1,
      S.of(context).banner_2,
      S.of(context).banner_3,
      S.of(context).banner_4,
      S.of(context).banner_5,
      S.of(context).banner_6,
      S.of(context).banner_7,
      S.of(context).banner_8,
      S.of(context).banner_9,
      S.of(context).banner_10,
      S.of(context).banner_11,
      S.of(context).banner_12,
      ];
    List ids = [6,9,10,11,12,14,15,16,22,26,30,35];
    for (var i = 0; i < titles.length; i++) {
      BannerType banner = BannerType(titles[i],"images/banner/banner_type_$i.jpg",ids[i]);
      tabs.add(banner);
    }
  }

  // 获取对应的分类数据
  Future<List<Anchor>> getCategoryData(String path) async {
      Map<String,dynamic> data = await HttpRequrst.request(path);
      List<Anchor> anchors = [];
      if (int.parse(data["errno"]) == 0) {
        List<dynamic> items = data["data"];
        for (var item in items) {
          Anchor anchor = Anchor(headerIcon:item["url"]);
          anchors.add(anchor);
        }
      }
      return anchors;
  }
  
}

class BannerType{
  String title;
  String icon;
  int id;

  int start = 0;  //开始的索引
  int count = 30; //结束的索引

  BannerType(this.title,this.icon,this.id,);
  get path{
    return "http://wallpaper.apc.360.cn/index.php?c=WallPaperAndroid&a=getAppsByCategory&cid=${this.id}&start=${this.start}&count=${this.count}";
  }
}

/* 分类
// 获取360壁纸分类 
http://wallpaper.apc.360.cn/index.php?c=WallPaperAndroid&a=getAllCategories

1：每日精选
5：游戏
6：美女
9：风景
10：视觉创意
11：明星影视
12：汽车
14：萌宠动物
15：小清新
16：体育
22：军事
26：动漫卡通 
30：情感
35：文字

// 获取某一个分类下的图片
http://wallpaper.apc.360.cn/index.php?c=WallPaperAndroid&a=getAppsByCategory&cid=1&start=0&count=99
*/