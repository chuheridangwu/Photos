import 'package:flutter/material.dart';
import 'package:mglobalphoto/home/home_item.dart';
import 'package:mglobalphoto/serve/data_manage.dart';
import 'package:mglobalphoto/serve/source_model.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomePageView extends StatefulWidget {
  @override
  _HomePageViewState createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {

  List<Anchor> anchorList = [];


  // 监听滑动
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
    void initState() {
      super.initState();
      DataManage().jingxuans.then((value){
        setState(() {
                  anchorList = value;
                  anchorList.shuffle();
                });
      });
    }

    void refreshData(){
        _refreshController.refreshCompleted();
    }

  @override
  Widget build(BuildContext context) {
    return  SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
        onRefresh: refreshData,
        header: WaterDropHeader(),
        footer: ClassicFooter(
          loadStyle: LoadStyle.ShowWhenLoading,
        ),
        controller: _refreshController,
        child: createCardView());
  }

  // 创建CardView
  Widget createCardView(){
    return GridView.builder(
        padding: EdgeInsets.all(5),
        itemCount: anchorList.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, //横轴三个子widget
          childAspectRatio: 0.85, //宽高比为1时，子widget
        ),
        itemBuilder: (ctx, index) {
          final anchor = anchorList[index];
          return HomeItem(anchor, () {
            Navigator.push(context, MaterialPageRoute(builder: (_) {}));
          });
        });
  }
}
