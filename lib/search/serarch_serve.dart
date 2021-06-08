import 'dart:convert';
import 'package:mglobalphoto/generated/l10n.dart';
import 'package:mglobalphoto/main.dart';
import 'package:mglobalphoto/serve/http_request.dart';
import 'package:mglobalphoto/serve/source_model.dart';

enum SearchEnum {
  HENGPING,
  SHUPING,
  BIZHI,
  TOUXIANG,
  SOUGOU,
  QIHOO,
}

class SearchServe {
  /// 获取搜索关键字
  Future<List> getKeywords(int index) async {
    String path =
        "http://service.picasso.adesk.com/v1/push/keyword?versionCode=212&channel=huawei&adult=false&first=$index";
    Map<String, dynamic> data = await HttpRequrst.request(path);
    List keys = [];
    if (data["code"] == 0) {
      Map<String, dynamic> items = data["res"]["keyword"][0];
      keys = items["items"].cast<String>();
    }
    return keys;
  }

  List<SearchTypeData> types = [];
  SearchServe.initData() {
    final context = navigatorKey.currentContext;
    List titles = [
      S.of(context).search_sougou,
      S.of(context).search_360,
      S.of(context).search_heng,
      S.of(context).search_shu,
      S.of(context).search_bizhi,
      S.of(context).search_icon,
    ];
    List enums = [
      SearchEnum.SOUGOU,
      SearchEnum.QIHOO,
      SearchEnum.HENGPING,
      SearchEnum.SHUPING,
      SearchEnum.BIZHI,
      SearchEnum.TOUXIANG
    ];
    for (var i = 0; i < titles.length; i++) {
      SearchTypeData typeData = SearchTypeData(titles[i], 0, enums[i], []);
      types.add(typeData);
    }
  }

  Future<List<Anchor>> getSearchResult(SearchTypeData typeData) async {
    if (typeData.type == SearchEnum.HENGPING) {
      return hengpingRequest(typeData);
    } else if (typeData.type == SearchEnum.SHUPING) {
      return shupingRequest(typeData);
    } else if (typeData.type == SearchEnum.BIZHI) {
      return bizhiRequest(typeData);
    } else if (typeData.type == SearchEnum.TOUXIANG) {
      return touxiangRequest(typeData);
    } else if (typeData.type == SearchEnum.SOUGOU) {
      return sougouRequest(typeData);
    } else {
      return qihooRequest(typeData);
    }
  }

  // 横屏
  Future<List<Anchor>> hengpingRequest(SearchTypeData typeData) async {
    List<Anchor> anchors = [];
    Map<String, dynamic> data = await HttpRequrst.request(typeData.path);
    if (int.parse(data["errno"]) == 0) {
      List<dynamic> items = data["data"];
      if (items != null) {
        for (var item in items) {
          Anchor anchor =
              Anchor(userName: item["utag"], headerIcon: item["img_1024_768"]);
          anchors.add(anchor);
        }
      }
    }
    return anchors;
  }

  // 竖屏搜索
  Future<List<Anchor>> shupingRequest(SearchTypeData typeData) async {
    List<Anchor> anchors = [];

    String src = await HttpRequrst.requestJsonData(typeData.path);
    Map<String, dynamic> data = jsonDecode(src);
    List<dynamic> items = data["res"]["vertical"];
    if (items != null) {
      for (var item in items) {
        Anchor anchor =
            Anchor(userName: item["form"]["name"], headerIcon: item["img"]);
        anchors.add(anchor);
      }
    }

    return anchors;
  }

  // 头像搜索
  Future<List<Anchor>> touxiangRequest(SearchTypeData typeData) async {
    List<Anchor> anchors = [];

    Map<String, dynamic> data =
        await HttpRequrst.requestJsonData(typeData.path);
    if (data["code"] == 0) {
      List<dynamic> items = data["res"]["avatar"];
      if (items != null) {
        for (var item in items) {
          Anchor anchor =
              Anchor(userName: item["user"]["name"], headerIcon: item["thumb"]);
          anchors.add(anchor);
        }
      }
    }
    return anchors;
  }

  // 搜狗搜索
  Future<List<Anchor>> sougouRequest(SearchTypeData typeData) async {
    List<Anchor> anchors = [];

    String src = await HttpRequrst.requestJsonData(typeData.path);
    Map<String, dynamic> data = jsonDecode(src);
    List<dynamic> items = data["items"];
    if (items != null) {
      for (var item in items) {
        Anchor anchor =
            Anchor(userName: item["title"], headerIcon: item["thumbUrl"]);
        anchors.add(anchor);
      }
    }
    return anchors;
  }

  // 壁纸搜索
  Future<List<Anchor>> bizhiRequest(SearchTypeData typeData) async {
    List<Anchor> anchors = [];

    Map<String, dynamic> data =
        await HttpRequrst.requestJsonData(typeData.path);
    if (data["code"] == 200) {
      List<dynamic> items = data["value"]["data"];
      if (items != null) {
        for (var item in items) {
          Anchor anchor =
              Anchor(userName: item["cp_name"], headerIcon: item["small"]);
          anchors.add(anchor);
        }
      }
    }
    return anchors;
  }

  // 360搜索
  Future<List<Anchor>> qihooRequest(SearchTypeData typeData) async {
    List<Anchor> anchors = [];

    String src = await HttpRequrst.requestJsonData(typeData.path);

    Map<String, dynamic> data = jsonDecode(src);

    List<dynamic> items = data["list"];
    if (items != null) {
      for (var item in items) {
        Anchor anchor = Anchor(
            userName: item["title"],
            headerIcon: item["thumb_bak"],
            width: int.parse(item["width"]),
            height: int.parse(item["height"]));
        anchors.add(anchor);
      }
    }

    return anchors;
  }
}

class SearchTypeData {
  String title;
  int skip;
  SearchEnum type;
  String keyword;
  List<Anchor> anchors = [];
  int count = 30;
  int index = 0;
  SearchTypeData(this.title, this.skip, this.type, this.anchors,
      {this.keyword});

  get path {
    String src =
        "http://wallpaper.apc.360.cn/index.php?c=WallPaper&a=search&count=99&kw=$keyword&start=$index";
    switch (type) {
      case SearchEnum.SHUPING:
        src =
            "http://so.picasso.adesk.com/v1/search/vertical/resource/$keyword?limit=30&channel=m&adult=false&first=0&order=new&skip=$index";
        break;
      case SearchEnum.BIZHI:
        src =
            "http://api-theme.meizu.com/wallpapers/public/search?os=0&mzos=1.0&screen_size=1x1&language=zh-CN&locale=cn&country=&imei=1&sn=1&device_model=M&firmware=Flyme2.1.2Y&v=5&vc=1&net=wifi&max=30&q=$keyword&start=$index";
        break;
      case SearchEnum.SOUGOU:
        src =
            "https://pic.sogou.com/pics?query=$keyword&mood=0&picformat=0&mode=1&di=0&p=40030500&dp=1&w=05009900&dr=1&_asf=pic.sogou.com&reqType=ajax&tn=0&reqFrom=result&start=$index";
        break;
      case SearchEnum.TOUXIANG:
        src =
            "http://service.avatar.adesk.com/v1/avatar/search?key=$keyword&adult=0&first=1&limit=30&order=&skip=$index";
        break;
      case SearchEnum.QIHOO:
        src = "https://image.so.com/j?src=srp&q=$keyword&pn=30&sn=$index";
        break;

      default:
    }
    return src;
  }
}
/*
竖屏: http://so.picasso.adesk.com/v1/search/vertical/resource/美女?limit=30&channel=m&adult=false&first=0&order=new&skip=0
横屏: http://wallpaper.apc.360.cn/index.php?c=WallPaper&a=search&count=99&kw=美女&start=0
壁纸： http://api-theme.meizu.com/wallpapers/public/search?os=0&mzos=1.0&screen_size=1x1&language=zh-CN&locale=cn&country=&imei=1&sn=1&device_model=M&firmware=Flyme2.1.2Y&v=5&vc=1&net=wifi&max=30&q=美女&start=0
头像: http://service.avatar.adesk.com/v1/avatar/search?key=美女&adult=0&first=1&limit=30&order=&skip=0
搜狗: https://pic.sogou.com/pics?query=美女&mood=0&picformat=0&mode=1&di=0&p=40030500&dp=1&w=05009900&dr=1&_asf=pic.sogou.com&reqType=ajax&tn=0&reqFrom=result&start=0
360: https://image.so.com/j?src=srp&q=美女&pn=30&sn=0

// 图片加载失败，要使用占位图
http://img.xgo-img.com.cn/pics/ori/1563/1562029.jpg

*/
