import 'package:flutter/material.dart';

class TabbarBgColorTest extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _TabbarBgColorTesttate();
  }
}

class _TabbarBgColorTesttate extends State<TabbarBgColorTest> with SingleTickerProviderStateMixin{
  int _selectedIndex = 0;
  GlobalKey<ScaffoldState> _key = GlobalKey();
  final List<String> _tabs = ["新闻", "历史", "图片"];
  TabController _tabController;
  // PageController _pageController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _tabController.addListener((){
      print("selected tabBar ${_tabs[_tabController.index]}");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: AppBar(
        title: Text("ScaffoldTest"),
       //TabBar布置
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(48),
          child: Container(
            color: Colors.red,
            child: TabBar(
              // indicator: ColorTabIndicator(Colors.black),//选中标签颜色
              indicatorColor: Colors.black,//选中下划线颜色,如果使用了indicator这里设置无效
              controller: _tabController,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.yellow,
              tabs: _tabs.map((item)=>Tab(text: item,)).toList(),
            ),
          ),
        )
      ),
      body: TabBarView(
        controller: _tabController,
        children: _tabs.map((item) => Container(
          color: Colors.blueGrey,
          alignment: AlignmentDirectional.center,
          child: Text(item),
        )).toList(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              title: Text("Home"),
              icon: Icon(Icons.home)
          ),
          BottomNavigationBarItem(
              title: Text("Business"),
              icon: Icon(Icons.business)
          ),
          BottomNavigationBarItem(
              title: Text("School"),
              icon: Icon(Icons.school)
          )
        ],
        currentIndex: _selectedIndex,
        fixedColor: Colors.green,
        onTap: (index){
          setState(() {
            _selectedIndex = index;
          });
          print(_selectedIndex);
        },
      )
    );
  }
}