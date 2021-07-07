import 'dart:convert';

import 'package:mglobalphoto/serve/http_request.dart';
import 'package:mglobalphoto/serve/source_model.dart';
import 'package:mglobalphoto/style/app_config.dart';

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
  
   // 获取分类数据 如果 AppConfig().isClose == true 显示分类
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
          if ((anchor.strUid == "4e4d610cdf714d2966000000" && AppConfig().isClose) || 
              (anchor.strUid == "4e4d610cdf714d2966000007" && AppConfig().isClose)) {
            continue;
          }
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

  // 获取美女大全中的数据  气质美女 侧颜美女 俏皮美女
  static Future<List<Anchor>> getAllList(String key,int skip,{String desc="hot"}) async {
    Map<String, dynamic> data = await HttpRequrst.request(
        "http://service.aibizhi.adesk.com/v1/wallpaper/album/$key/wallpaper?limit=30&adult=false&first=1&order=$desc&skip=$skip");
    List<Anchor> anchors = [];
    if (data["msg"] == "success") {
      List<dynamic> items = data["res"]["wallpaper"];
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

  // 获取某个头像数据
    static Future<List<Anchor>> getAvatarList(int index) async {
    Map<String, dynamic> data = await HttpRequrst.request(
        "http://service.picasso.adesk.com/v1/avatar/avatar?limit=30&adult=false&first=1&order=hot&cid=55f7d53769401b2286e9e497&skip=$index");
    List<Anchor> anchors = [];
    if (data["msg"] == "success") {
      List<dynamic> items = data["res"]["avatar"];
      if (items != null) {
        for (var item in items) {
          Anchor anchor = Anchor(
            thumb: item["thumb"],
            headerIcon: item["thumb"]
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

// 美女数据 纯净美女  侧面美女
http://service.aibizhi.adesk.com/v1/wallpaper/album/546c9c1469401b234606da56/wallpaper?limit=30&adult=false&first=1&order=new&skip=30

*/
