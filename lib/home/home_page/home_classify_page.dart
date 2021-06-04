import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mglobalphoto/home/home_classify/home_classify_tabbar.dart';
import 'package:mglobalphoto/home/home_page/home_start_desc.dart';
import 'package:mglobalphoto/home/home_server.dart';
import 'package:mglobalphoto/serve/source_model.dart';

class HomePageClassify extends StatefulWidget {
  @override
  _HomePageClassifyState createState() => _HomePageClassifyState();
}

class _HomePageClassifyState extends State<HomePageClassify> {

  List<Anchor> _anchors = [];

  @override
  void initState() {
    super.initState();
    HomeServe.isLoadMoreData().then((value){
         HomeServe.getClassifyData(value["app"]).then((value){
      setState(() {
        _anchors = value;
      });
    });
    });
 
  }
  
  @override
  Widget build(BuildContext context) {
    return createCardView();
  }

    // 创建CardView
  Widget createCardView() {
    return GridView.builder(
        padding: EdgeInsets.all(5),
        itemCount: _anchors.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, //横轴三个子widget
          crossAxisSpacing: 5,
          mainAxisSpacing: 5,
        ),
        itemBuilder: (ctx, index) {
          final anchor = _anchors[index];
          return HomeItem(anchor, (){
            Navigator.pushNamed(context, HomeClassifyTabbar.routeName,arguments: anchor);
          });
        });
  }
}