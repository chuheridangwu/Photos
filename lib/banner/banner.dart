import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mglobalphoto/banner/banner_list.dart';
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
        itemCount: _serve.tabs.length,
        itemBuilder: (ctx,index){
          final BannerType type = _serve.tabs[index];
          return BannerItemView(type,callback: (){
            Navigator.pushNamed(context, BannerListView.routeName,arguments: type);
          },);
      }),
    );
  }
}

class BannerItemView extends StatelessWidget {
  final BannerType data;
  final VoidCallback callback;
  BannerItemView(this.data,{this.callback});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: callback,
      child: Container(
        height: 280,
        margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage(data.icon),fit: BoxFit.cover),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(data.title,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.white),),
            SizedBox(height: 8,),
          ],
        )
      ),
    );
  }
}