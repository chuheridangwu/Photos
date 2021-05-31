import 'package:flutter/material.dart';
import 'package:mglobalphoto/serve/source_model.dart';
import 'package:mglobalphoto/serve/video_serve.dart';
import 'package:mglobalphoto/video/video_list.dart';

class VideoTypeView extends StatefulWidget {
  @override
  _VideoTypeViewState createState() => _VideoTypeViewState();
}

class _VideoTypeViewState extends State<VideoTypeView> {
  final VideoServe _serve = VideoServe.initData();

  @override
  Widget build(BuildContext context) {
    print(_serve.videoTypes);
    return createCardView();
  }

  // 创建CardView
  Widget createCardView() {
    return GridView.builder(
        padding: EdgeInsets.all(5),
        itemCount: _serve.videoTypes.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, //横轴三个子widget
        ),
        itemBuilder: (ctx, index) {
          final itemData = _serve.videoTypes[index];
          return VideoTypeItem(itemData, () {
            Navigator.pushNamed(context, VideoListView.routeName,
                arguments: itemData);
          });
        });
  }
}

class VideoTypeItem extends StatelessWidget {
  final VideoTypeData data;
  final VoidCallback callback;
  VideoTypeItem(this.data, this.callback);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: ExactAssetImage(data.icon), fit: BoxFit.fill)),
          child: bottomWidget(),
        ),
      ),
      onTap: callback,
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
            data.title,
            style: TextStyle(
                color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
          ))
        ],
      ),
    );
  }
}
