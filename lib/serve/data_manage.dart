import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:mglobalphoto/serve/source_model.dart';

class DataManage {
  // 单利公开访问
  factory DataManage() => _shareInstance();
  // 静态私有成员
  static DataManage _dataManage = DataManage._();

  // 数据
  Future<List<Anchor>> jingxuans;

  DataManage._() {
    jingxuans = initJingXuanData();
  }

  // 精选数据
   Future<List<Anchor>> initJingXuanData() async {
    String jsonString = await rootBundle.loadString("res/mn51.json");
    Map<String, dynamic> jsonData = json.decode(jsonString);
    List<dynamic> items = jsonData["body"]["cats"];
    List<Anchor> anchors = [];
    for (var item in items) {
      int uid = item["id"];
      String name = item["title"];
      String url = item["url"] + "@360,413.jpg";
      Anchor anchor = Anchor(uid: uid,userName: name,headerIcon: url);
      anchors.add(anchor);
    }
    return  anchors;
  }

  static DataManage _shareInstance() {
    if (_dataManage == null) {
      _dataManage = DataManage();
    }
    return _dataManage;
  }
}
