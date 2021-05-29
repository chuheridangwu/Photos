import 'package:mglobalphoto/serve/http_request.dart';

class SearchServe{

  /// 获取搜索关键字
  Future<List> getKeywords(int index) async {
    String path = "http://service.picasso.adesk.com/v1/push/keyword?versionCode=212&channel=huawei&adult=false&first=$index";
    Map<String,dynamic> data = await HttpRequrst.request(path);
    List keys =[];
    if (data["code"] == 0) {
      Map<String,dynamic> items = data["res"]["keyword"][0];
      keys = items["items"].cast<String>();
    }
     return keys;
  }

}