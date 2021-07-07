class UserInfo{
  final String userName; 
  final String headerIcon;
  final String thumb; // 缩略图
  final int uid; // 用户idx
  final String strUid; //接口id
  UserInfo({this.userName,this.headerIcon,this.uid,this.strUid,this.thumb});
}

class Anchor extends UserInfo{
  final String liveAddres;  // 直播地址
  int width;
  int height;
  String videoTime;
  String desc;
  int index = 0; // 接口数据索引值，懒的创建模型了
  Anchor({this.liveAddres,String userName, String headerIcon,String thumb, int uid,String strUid, this.videoTime, int level,int coins,this.width,this.height,this.desc}) : super(userName:userName, headerIcon:headerIcon, uid:uid,strUid: strUid,thumb: thumb);
}