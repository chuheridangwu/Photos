import 'package:dio/dio.dart';

class HttpConfig {
  static const baseUrl = "https://api.huangzewei.me";
  static const timeout = 5000;
}

class HttpRequrst {
  static final Dio _dio = Dio();

// 使用泛型方便查看返回结果
  static Future<T> request<T>(
    String path, {
    String method = "get",
    Map<String, dynamic> params,
    Options options,
    Interceptor inter,
  }) async {

  final option = Options(method: method);
  if (options != null) {
    option.headers = options.headers;
  } 

    // 发送网络请求
    try {
      Response response = await _dio.request(path, options: option);
      // 打印当前结果
      print("当前请求接口是:$path\n返回结果是:${response.data}");
      // 返回请求结果
      return response.data;
    } on DioError catch (e) {
      print("当前请求的URL = $path \n 失败信息 $e");
      return Future.error(e);
    }
  }

  // 使用泛型方便查看返回结果
  static Future requestJsonData(
    String path, {
    String method = "get",
    Map<String, dynamic> params,
    Options options,
    Interceptor inter,
  }) async {

  final option = Options(method: method);
  if (options != null) {
    option.headers = options.headers;
  } 

    // 发送网络请求
    try {
      Response response = await _dio.request(path, options: option);
      // 打印当前结果
      print("当前请求接口是:$path\n返回结果是:${response.data}");
      // 返回请求结果
      return response.data;
    } on DioError catch (e) {
      print("当前请求的URL = $path \n 失败信息 $e");
      return Future.error(e);
    }
  }
}

/*

// 美女图片

// 精选图片地址
http://img.bizhi.51app.cn/100000/2/1436852322211@360,413.jpg

// 内容地址
http://img.bizhi.51app.cn/2/49/1434241699365@235,417.jpg

 */