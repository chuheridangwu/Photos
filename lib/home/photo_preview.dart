import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mglobalphoto/serve/admob_manage.dart';
import 'package:mglobalphoto/serve/source_model.dart';
import 'package:photo_view/photo_view.dart';

class PhotoPreView extends StatefulWidget {
  static const routeName = "/PhotoPreView";
  const PhotoPreView({Key key}) : super(key: key);

  @override
  _PhotoPreViewState createState() => _PhotoPreViewState();
}

class _PhotoPreViewState extends State<PhotoPreView> {
  List<Anchor> _anchors = [];
  int _index = 0;
  PageController _pageController;

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Map map = ModalRoute.of(context).settings.arguments as Map;
    _anchors = map["list"];
    _index = map["index"];
    _pageController = PageController(initialPage: _index);
    _pageController.addListener(() {
      print(_pageController.page);
      if (_pageController.page % 20 == 0) {
        AdmobManage().showInterstitialAd();
      }
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView(
        controller: _pageController,
        children: _anchors.map((e) {
          return PhotoView(
            imageProvider: CachedNetworkImageProvider(e.headerIcon),
            loadingBuilder: (ctx, event) {
              return Container();
            },
          );
        }).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.close),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
