import 'dart:convert';
import 'package:mglobalphoto/serve/http_request.dart';
import 'package:mglobalphoto/serve/source_model.dart';

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
    List titles = ["横屏", "竖屏", "壁纸", "头像", "搜狗", "360"];
    List enums = [
      SearchEnum.HENGPING,
      SearchEnum.SHUPING,
      SearchEnum.BIZHI,
      SearchEnum.TOUXIANG,
      SearchEnum.SOUGOU,
      SearchEnum.QIHOO
    ];
    for (var i = 0; i < titles.length; i++) {
      SearchTypeData typeData = SearchTypeData(titles[i], 0, enums[i]);
      types.add(typeData);
    }
  }

  Future<List<Anchor>> getSearchResult(SearchTypeData typeData) async {
    List<Anchor> anchors = [];

    if (typeData.type == SearchEnum.HENGPING) {
      Map<String, dynamic> data = await HttpRequrst.request(typeData.path);
      if (int.parse(data["errno"]) == 0) {
        List<dynamic> items = data["data"];
        for (var item in items) {
          Anchor anchor =
              Anchor(userName: item["utag"], headerIcon: item["img_1024_768"]);
          anchors.add(anchor);
        }
      }
    }else if(typeData.type == SearchEnum.SHUPING){
      shupingRequest(typeData, anchors);
    }else {
      qihooRequest(typeData, anchors);
    }

    return anchors;
  }

  // 竖屏搜索
  void shupingRequest(SearchTypeData typeData, List<Anchor> anchors)async{
    String src = await HttpRequrst.requestJsonData(typeData.path);
    Map<String,dynamic> data = jsonDecode(src);
    List<dynamic> items = data["res"]["vertical"];
     for (var item in items) {
          Anchor anchor =
              Anchor(userName: item["form"]["name"], headerIcon: item["img"]);
          anchors.add(anchor);
      }
  }

  // 360搜索
  void qihooRequest(SearchTypeData typeData, List<Anchor> anchors) async {
    String src = await HttpRequrst.requestJsonData(typeData.path);

      Map<String, dynamic> data = jsonDecode(src);
        
        List<dynamic> items = data["list"];
        for (var item in items) {
          Anchor anchor =
              Anchor(userName: item["title"], headerIcon: item["thumb_bak"],width: int.parse(item["width"]),height: int.parse(item["height"]));
          anchors.add(anchor);
      }
  }
}

enum SearchEnum {
  HENGPING,
  SHUPING,
  BIZHI,
  TOUXIANG,
  SOUGOU,
  QIHOO,
}

class SearchTypeData {
  String title;
  int skip;
  SearchEnum type;
  SearchTypeData(this.title, this.skip, this.type);

  get path {
    String src =
        "http://wallpaper.apc.360.cn/index.php?c=WallPaper&a=search&count=99&kw=美女&start=0";
    switch (type) {
      case SearchEnum.SHUPING:
        src =
            "http://so.picasso.adesk.com/v1/search/vertical/resource/美女?limit=30&channel=m&adult=false&first=0&order=new&skip=0";
        break;
      case SearchEnum.BIZHI:
        src =
            " http://api-theme.meizu.com/wallpapers/public/search?os=0&mzos=1.0&screen_size=1x1&language=zh-CN&locale=cn&country=&imei=1&sn=1&device_model=M&firmware=Flyme2.1.2Y&v=5&vc=1&net=wifi&max=30&q=美女&start=0";
        break;
      case SearchEnum.SOUGOU:
        src =
            "https://pic.sogou.com/pics?query=美女&mood=0&picformat=0&mode=1&di=0&p=40030500&dp=1&w=05009900&dr=1&_asf=pic.sogou.com&reqType=ajax&tn=0&reqFrom=result&start=0";
        break;
      case SearchEnum.TOUXIANG:
        src =
            "http://service.avatar.adesk.com/v1/avatar/search?key=美女&adult=0&first=1&limit=30&order=&skip=0";
        break;
      case SearchEnum.QIHOO:
        src = "https://image.so.com/j?src=srp&q=美女&pn=30&sn=0";
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
