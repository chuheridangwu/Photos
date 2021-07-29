import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mglobalphoto/home/home_page/home_start_desc.dart';
import 'package:mglobalphoto/home/home_server.dart';
import 'package:mglobalphoto/home/photo_preview.dart';
import 'package:mglobalphoto/serve/source_model.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../photo_list.dart';

class HomeSexPage extends StatefulWidget {
  const HomeSexPage({ Key key }) : super(key: key);

  @override
  _HomeSexPageState createState() => _HomeSexPageState();
}

class _HomeSexPageState extends State<HomeSexPage> with AutomaticKeepAliveClientMixin {
  
  bool get wantKeepAlive => true;
  List<Anchor> _anchors = [];
  int _index = 1;

  // 监听滑动
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
    void initState() {
      super.initState();
      String link = "https://www.mzitu.com/hot/page/" + _index.toString();
      HomeServe.getMztAnchorData(link).then((value){
          setState(() {
            _anchors = value;
          });
      });
    }

    void refreshData(){
      _index += 1;
      String link = "https://www.mzitu.com/page/" + _index.toString();
      HomeServe.getMztAnchorData(link).then((value){
          setState(() {
            _anchors.addAll(value);
          });
      });
      _refreshController.loadComplete();
        _refreshController.refreshCompleted();
    }

  @override
  Widget build(BuildContext context) {
    return  SmartRefresher(
        enablePullDown: false,
        enablePullUp: _anchors.length != 0 ?  true : false,
        onLoading: refreshData,
        footer: ClassicFooter(
          loadStyle: LoadStyle.ShowWhenLoading,
        ),
        controller: _refreshController,
        child: createCardView()
    );
  }

  // 创建CardView
  Widget createCardView(){
    return GridView.builder(
        padding: EdgeInsets.all(5),
        itemCount: _anchors.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, //横轴三个子widget
          childAspectRatio: 120/200, //宽高比为1时，子widget
        ),
        itemBuilder: (ctx, index) {
          Anchor anchor = _anchors[index];
          return createAnchorItem(anchor, () { 
            Map map = {"linkUrl":anchor.linkUrl,"title":anchor.userName};
            Navigator.pushNamed(context, PhotoListView.routeName,
                    arguments: map);
          });
        });
  }

    // 单个Item
  Widget createAnchorItem(Anchor anchor, VoidCallback callback) {
    return GestureDetector(
      child: Card(
          clipBehavior: Clip.antiAlias,
          child: CachedNetworkImage(
            imageUrl: anchor.headerIcon,
            fit: BoxFit.cover,
          )),
      onTap: callback,
    );
  }
}