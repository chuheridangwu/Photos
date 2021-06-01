import 'package:flutter/material.dart';
import 'package:mglobalphoto/serve/banner_serve.dart';

class BannerView extends StatefulWidget {
  @override
  _BannerViewState createState() => _BannerViewState();
}

class _BannerViewState extends State<BannerView> {
  final BannerServe _serve = BannerServe.initData();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: _serve.types.length,
        itemBuilder: (ctx,index){
          return Text("data");
      }),
    );
  }
}

class BannerItemView extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}