import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mglobalphoto/home/photo_preview.dart';
import 'package:mglobalphoto/search/serarch_serve.dart';
import 'package:mglobalphoto/serve/source_model.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class SearchPageView extends StatefulWidget {
  final SearchTypeData data;
  const SearchPageView(this.data);
  @override
  _SearchPageViewState createState() => _SearchPageViewState();
}

class _SearchPageViewState extends State<SearchPageView> with AutomaticKeepAliveClientMixin {
 
  @override
  bool get wantKeepAlive => true;

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  final SearchServe _serve = SearchServe.initData();

  void refreshData() {
    Future.delayed(Duration(seconds: 1)).then((value){
      _refreshController.refreshCompleted();
    });
  }

  void loadMoreData() {
    widget.data.index += widget.data.anchors.length;
    searchRequest();
  }

  @override
  void initState() {
    super.initState();
    if (widget.data.anchors.length == 0) {
      searchRequest();
    }
  }

  void searchRequest() {
    _serve.getSearchResult(widget.data).then((value) {
      setState(() {
        widget.data.anchors.addAll(value);
      });
    });
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
        enablePullUp: true,
        onRefresh: refreshData,
        onLoading: loadMoreData,
        header: WaterDropHeader(),
        footer: ClassicFooter(
          loadStyle: LoadStyle.ShowWhenLoading,
        ),
        controller: _refreshController,
        child: createGridView());
  }

  // GaridView
  Widget createGridView() {
    return GridView.builder(
        itemCount: widget.data.anchors.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          mainAxisSpacing: 5,
          crossAxisSpacing: 5,
          crossAxisCount: 2,
        ),
        itemBuilder: (ctx, index) {
          Anchor anchor = widget.data.anchors[index];
          return imgItem(anchor, index);
        });
  }

  // itemView
  Widget imgItem(Anchor anchor, int index) {
    return GestureDetector(
      child: CachedNetworkImage(
        imageUrl: anchor.headerIcon,
        fit: BoxFit.cover,
      ),
      onTap: () {
        Map map = {"index": index, "list": widget.data.anchors};
        Navigator.pushNamed(context, PhotoPreView.routeName, arguments: map);
      },
    );
  }
}
