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
  Anchor({this.liveAddres,String userName, String headerIcon, int uid,  int level,int coins,this.width,this.height}) : super(userName:userName, headerIcon:headerIcon, uid:uid);
}