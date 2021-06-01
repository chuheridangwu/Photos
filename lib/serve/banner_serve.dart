import 'package:flutter/services.dart';

class BannerServe{
  List<BannerType> types = [];  
  BannerServe.initData(){
    List titles = ["1","2","3"];
    for (var i = 0; i < titles.length; i++) {
      BannerType banner = BannerType(titles[i],"video_type_0.jpg",i);
      types.add(banner);
    }
  }
  
}

class BannerType{
  String title;
  String icon;
  int type;
  BannerType(this.title,this.icon,this.type,);
}
