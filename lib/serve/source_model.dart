class UserInfo{
  final String userName; 
  final String headerIcon;
  final int uid; // 用户idx
  UserInfo({this.userName,this.headerIcon,this.uid});
}

class Anchor extends UserInfo{
  final String liveAddres;  // 直播地址
  int width;
  int height;
  String videoTime;
  String desc;
  String pathID; //接口id
  int index = 0; // 接口数据索引值，懒的创建模型了
  Anchor({this.liveAddres,String userName, String headerIcon, int uid, this.videoTime, int level,int coins,this.width,this.height,this.desc,this.pathID}) : super(userName:userName, headerIcon:headerIcon, uid:uid);
}