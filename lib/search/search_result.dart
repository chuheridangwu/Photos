import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mglobalphoto/search/search.dart';
import 'package:mglobalphoto/search/serarch_serve.dart';
import 'package:mglobalphoto/serve/source_model.dart';

class SearchListView extends StatefulWidget {
  static const routeName = "/SearchListView";
  @override
  _SearchListViewState createState() => _SearchListViewState();
}

class _SearchListViewState extends State<SearchListView> with SingleTickerProviderStateMixin {

  final SearchServe _serve = SearchServe.initData();
  TabController _tabController;
  List<Anchor> _anchors = [];
  String _keyword = "";
  @override
  void initState() {
    super.initState();

  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
        String key = ModalRoute.of(context).settings.arguments as String;
    setState(() {
      _keyword = key;
    });

        _tabController = TabController(length: _serve.types.length, vsync: this)..addListener(() {
      SearchTypeData typeData = _serve.types[_tabController.index];
       _serve.getSearchResult(typeData).then((value){
            setState(() {
              _anchors = value;
            });
        });
    });
  }

  @override
  Widget build(BuildContext context) {

    return DefaultTabController(
        length: _serve.types.length,
        child: Scaffold(
        appBar: createAppBar(),
        body: TabBarView(
          controller: _tabController,
          children: _serve.types.map((e){
         return  createGridView();
         }).toList(),
      ),
        )
    );
  }

  // AppBar 设置顶部AppBar
  Widget createAppBar() {
    return AppBar(
        title: Text("$_keyword"),
        elevation: 0, //隐藏底部阴影分割线
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          indicatorColor: Theme.of(context).primaryColor,
          unselectedLabelColor: Colors.black87,
          tabs: _serve.types.map((e){
            return Text(e.title,style: TextStyle(fontSize: 16),);
          }).toList(),
        ),
    );
  }

  // GaridView
  Widget createGridView(){
    return GridView.builder(
      itemCount: _anchors.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        mainAxisSpacing: 5,
        crossAxisSpacing: 5,
        crossAxisCount: 2,
      ), 
      itemBuilder: (ctx,index){
        Anchor anchor = _anchors[index];
        return imgItem(anchor);
      });
  }

  // itemView
  Widget imgItem(Anchor anchor){
    return GestureDetector(
      child: CachedNetworkImage(imageUrl: anchor.headerIcon,fit: BoxFit.cover,),
      onTap: (){},
    );
  }
  
}