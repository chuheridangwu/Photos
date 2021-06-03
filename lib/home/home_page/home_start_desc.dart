import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mglobalphoto/serve/source_model.dart';

class HomeItem extends StatelessWidget {
  final Anchor anchor;
  final VoidCallback onPress; // 回调函数
  HomeItem(this.anchor, this.onPress);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: CachedNetworkImageProvider(anchor.headerIcon),
                  fit: BoxFit.fill)),
          child: bottomWidget(),
        ),
      ),
      onTap: onPress,
    );
  }

  // 底部昵称和观看人数
  Widget bottomWidget() {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: EdgeInsets.fromLTRB(5, 0, 0, 5),
      child: Row(
        children: [
          Expanded(
              child: Text(
            anchor.userName,
            style: TextStyle(
                color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
          ))
        ],
      ),
    );
  }
}
