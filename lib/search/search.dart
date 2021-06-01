import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:mglobalphoto/search/search_result.dart';
import 'package:mglobalphoto/serve/serarch_serve.dart';
import 'package:mglobalphoto/style/button.dart';

class SearchView extends StatefulWidget {
  static const routeName = "/SearchView";
  @override
  _SearchViewState createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final SearchServe _serve = SearchServe.initData();
  final _controller = TextEditingController();
  int _keyIndex = 1;
  List<String> _keywords = [];
  

  @override
  void initState() {
    super.initState();
    refreshKeywords();
  }

  // 刷新列表
  void refreshKeywords() {
    _serve.getKeywords(_keyIndex).then((value) {
      _keywords = value;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("搜索"),
      ),
      body: Column(
        children: [
          createSearchBoard(),
          createTitle(),
          createKeyWords(),
        ],
      ),
    );
  }

  // 搜索框
  Widget createSearchBoard(){
    return  Container(
            height: 40.0,
            margin: EdgeInsets.only(top:10),
            child: new Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: new Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey[300],width: 1),
                  borderRadius: BorderRadius.all(Radius.circular(23)),
                ),
                  child: new Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(width: 12.0,),
                      Icon(Icons.search, color: Colors.grey,size: 20,),
                      Expanded(
                        child: TextField(
                            controller: _controller,
                            decoration: new InputDecoration(
                              contentPadding: EdgeInsets.fromLTRB(8, 0, 0, 10),
                              hintText: 'Search', border: InputBorder.none),
                              // onChanged: onSearchTextChanged,
                            ),
                      ),
                      new IconButton(
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        icon: new Icon(Icons.cancel,color:Colors.grey),
                        iconSize: 18.0,
                        onPressed: () {
                          _controller.clear();
                        },
                      ),
                    ],
                  ),
                )
            ),
      );
  }

  // 标题
  Widget createTitle() {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 3, 10, 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("热门搜索",style: TextStyle(),),
          TextButton(onPressed: (){
            _keyIndex += 1;
            refreshKeywords();
          },  child: Text("换一批",style: TextStyle(color: Colors.black54),)),
        ],
      ),
    );
  }

  // 搜索关键字
  Widget createKeyWords() {
    return Wrap(
      children: _keywords.map((e) {
        return GestureDetector(
          child: Container(
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.all(Radius.circular(5))),
            padding: EdgeInsets.fromLTRB(10, 2, 10, 2),
            margin: EdgeInsets.all(5),
            child: Text(e),
          ),
          onTap: () {
            Navigator.pushNamed(context, SearchListView.routeName,arguments: e);
          },
        );
      }).toList(),
    );
  }
}
