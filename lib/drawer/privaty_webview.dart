import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PrivatyWebView extends StatefulWidget {
  static const routeName = "/PrivatyWebView";
  const PrivatyWebView({ Key key }) : super(key: key);

  @override
  _PrivatyWebViewState createState() => _PrivatyWebViewState();
}

class _PrivatyWebViewState extends State<PrivatyWebView> {

   final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  String _content = "";

       @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    initData();
  }

  void initData() async {
    String src = await rootBundle.loadString("res/yinsi.txt");
    setState(() {
      _content = src;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("隐私政策"),),
      body: Builder(builder: (BuildContext context) {
        return ListView(children:[
            Text(_content),
        ]);
      }),
    );
  }
}