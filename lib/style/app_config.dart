import 'package:mglobalphoto/serve/http_request.dart';

class AppConfig{

    // 单利公开访问
  factory AppConfig() => _shareInstance();
  // 静态私有成员
  static AppConfig _appConfig = AppConfig._();

  AppConfig._() {
    initData();
  }

  static AppConfig _shareInstance() {
    if (_appConfig == null) {
      _appConfig = AppConfig();
    }
    return _appConfig;
  }

  // true是关闭 false是放开
  bool isClose = true;

  // 初始化数据
  Future initData() async {
      AppConfig.isLoadMoreData().then((value) {
        isClose = value["isClose"] == 1 ? true : false;
     }).then((value){
       return Future((){});
     });
  }

  static Future<Map> isLoadMoreData() async {
    return await HttpRequrst.request("https://pandaboy.top/config.json");
  }
}