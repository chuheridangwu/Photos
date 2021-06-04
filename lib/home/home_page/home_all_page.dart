import 'package:flutter/material.dart';
import 'package:mglobalphoto/home/home_page/home_all_item.dart';
import 'package:mglobalphoto/main.dart';
import 'package:mglobalphoto/serve/source_model.dart';

class HomePageAll extends StatelessWidget {
  final List<Anchor> _anchors = [
    Anchor(
        userName: "清纯美女",
        headerIcon: "images/all/all_type_0.jpg",
        strUid: "546c9c1469401b234606da56",
        desc: "new"),
    Anchor(
        userName: "气质美女",
        headerIcon: "images/all/all_type_1.jpg",
        strUid: "5693671669401b7a39308888",
        desc: "new"),
    Anchor(
        userName: "俏皮美女",
        headerIcon: "images/all/all_type_2.jpg",
        strUid: "552cee2469401b5a9162f492",
        desc: "new"),
    Anchor(
        userName: "侧颜美女",
        headerIcon: "images/all/all_type_3.jpg",
        strUid: "55d4284d69401b03a4bb5dab",
        desc: "new"),
    Anchor(
        userName: "惊艳美女",
        headerIcon: "images/all/all_type_4.jpg",
        strUid: "546c9c1469401b234606da56",
        desc: "hot"),
    Anchor(
        userName: "唯美美女",
        headerIcon: "images/all/all_type_5.jpg",
        strUid: "5693671669401b7a39308888",
        desc: "hot"),
    Anchor(
        userName: "巅峰美女",
        headerIcon: "images/all/all_type_6.jpg",
        strUid: "552cee2469401b5a9162f492",
        desc: "hot"),
    Anchor(
        userName: "俏丽美女",
        headerIcon: "images/all/all_type_7.jpg",
        strUid: "55d4284d69401b03a4bb5dab",
        desc: "hot"),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: _anchors.length,
        itemBuilder: (ctx, index) {
          Anchor anchor = _anchors[index];
          return GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, HomeAllItem.routeName,
                    arguments: anchor);
              },
              child: createCardView(anchor));
        });
  }

  // 创建卡片
  Widget createCardView(Anchor anchor) {
    return Card(
      clipBehavior: Clip.hardEdge,
      child: Container(
          height: 180,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(anchor.headerIcon), fit: BoxFit.fitWidth)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                anchor.userName,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              )
            ],
          )),
    );
  }
}
