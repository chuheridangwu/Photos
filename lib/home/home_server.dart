import 'dart:convert';

import 'package:mglobalphoto/serve/http_request.dart';
import 'package:mglobalphoto/serve/source_model.dart';

class HomeServe {
  // 禁止加载更多
  bool _isStopRefresh = false;

  // 获取明星详细数据
  Future<List<Anchor>> getStartList(int idx, int index) async {
    if (_isStopRefresh) {
      return [];
    }
    String src = await HttpRequrst.requestJsonData(
        "http://api.bizhi.51app.cn/w/showCatSub/$idx/0/$index.do");
    Map<String, dynamic> data = jsonDecode(src);
    List<Anchor> anchors = [];
    if (data["msgCode"] == 0) {
      List<dynamic> items = data["body"]["list"];
      if (items != null) {
        for (var item in items) {
          int uid = item["id"];
          String url = item["url"] + "@235,417.jpg";
          Anchor anchor =
              Anchor(uid: uid, headerIcon: url, width: 235, height: 417);
          anchors.add(anchor);
        }
      }
    }

    _isStopRefresh = anchors.length < 10;

    return anchors;
  }

  // 获取专题数据
  Future<List<Anchor>> getAlbumList(String key, int skip) async {
    if (_isStopRefresh) {
      return [];
    }
    Map<String, dynamic> data = await HttpRequrst.request(
        "http://service.aibizhi.adesk.com/v1/wallpaper/album/$key/wallpaper?limit=30&adult=false&first=1&order=new&skip=$skip");
    List<Anchor> anchors = [];
    if (data["msg"] == "success") {
      List<dynamic> items = data["res"]["wallpaper"];
      if (items != null) {
        for (var item in items) {
          Anchor anchor = Anchor(
            thumb: item["thumb"],
            headerIcon: item["img"],
          );
          anchors.add(anchor);
        }
      }
    }
    _isStopRefresh = anchors.length < 10;

    return anchors;
  }

   // 获取分类数据
  static Future<List<Anchor>> getClassifyData() async {
    Map<String, dynamic> data = await HttpRequrst.request(
        "http://service.aibizhi.adesk.com/v1/wallpaper/category");
    List<Anchor> anchors = [];
    if (data["msg"] == "success") {
      List<dynamic> items = data["res"]["category"];
      if (items != null) {
        for (var item in items) {
          Anchor anchor = Anchor(
            userName: item["name"],
            strUid: item["id"],
            headerIcon: item["cover"],
          );
          anchors.add(anchor);
        }
      }
    }
    return anchors;
  }

  // 获取某个分类数据
  static Future<List<Anchor>> getClassifyList(String key,int skip,{String desc="new"}) async {
    Map<String, dynamic> data = await HttpRequrst.request(
        "http://service.picasso.adesk.com/v1/vertical/category/$key/vertical?limit=30&adult=false&first=1&order=$desc&skip=$skip");
    List<Anchor> anchors = [];
    if (data["msg"] == "success") {
      List<dynamic> items = data["res"]["vertical"];
      if (items != null) {
        for (var item in items) {
          Anchor anchor = Anchor(
            thumb: item["thumb"],
            headerIcon: item["img"]
          );
          anchors.add(anchor);
        }
      }
    }
    return anchors;
  }
}

/*
// 获取单个明星详细相片地址 0,do是索引
http://api.bizhi.51app.cn/w/showCatSub//14048/0/0.do

// 明星图片地址
http://img.bizhi.51app.cn/100000/1/1476685214557@235,417.jpg

// 获取专题数据 zhuanti.json
http://service.aibizhi.adesk.com/v1/wallpaper/album/522b093148d5b939bf1000ac/wallpaper?limit=30&adult=false&first=1&order=new&skip=30"

// 爱壁纸获取所有分类
http://service.aibizhi.adesk.com/v1/wallpaper/category

// 获取某一个分类下的数据
http://service.picasso.adesk.com/v1/vertical/category/4ef0a35c0569795756000000/vertical?limit=30&adult=false&first=1&order=new
http://service.picasso.adesk.com/v1/vertical/category/4ef0a35c0569795756000000/vertical?limit=30&adult=false&first=1&order=hot
*/
