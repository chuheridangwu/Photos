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
          child: Container(),
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
        fixedColor: Colors.white,
        onTap: (index){
          setState(() {
            _selectedIndex = index;
          });
          print(_selectedIndex);
        },
      )
    );
  }

  // textfield
  Widget createField(){
  return Expanded(
                child:ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: 40,
                        ), 
                        child: TextField(
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 15),
                            fillColor: Color(0XFFFFF8F4),
                            filled: true,
                            enabledBorder: OutlineInputBorder(
                              /*边角*/
                              borderRadius: BorderRadius.all(
                                Radius.circular(5), //边角为5
                              ),
                              borderSide: BorderSide(
                                color: Colors.white, //边线颜色为白色
                                width: 1, //边线宽度为2
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.white, //边框颜色为白色
                                  width: 1, //宽度为5
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(5), //边角为30
                                ),
                            ),
                          ),
                        ),
                      ),
                      
                    );
  }
}