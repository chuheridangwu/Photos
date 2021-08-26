import 'package:mglobalphoto/serve/http_request.dart';
import 'package:package_info/package_info.dart';

class AppConfig {
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
  void initData() {
    AppConfig.isLoadMoreData().then((data) {
      return data["version"];
    }).then((version) {
      // 本地的版本号 大于 线上的版本号，则属于审核模式
      PackageInfo.fromPlatform().then((value) {
        int appVersion = int.parse(value.version.replaceAll(".", ""));
        isClose = appVersion > version;
        return isClose;
      });
    });
  }

  static Future<Map> isLoadMoreData() async {
    return await HttpRequrst.request("https://pandaboy.top/config.json");
  }
}
