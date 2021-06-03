import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mglobalphoto/home/home_page/home_album_item.dart';
import 'package:mglobalphoto/serve/data_manage.dart';
import 'package:mglobalphoto/serve/source_model.dart';

class HomePageAlbum extends StatefulWidget {
  @override
  _HomePageAlbumState createState() => _HomePageAlbumState();
}

class _HomePageAlbumState extends State<HomePageAlbum> with AutomaticKeepAliveClientMixin {
  
  bool get wantKeepAlive => true;

  List<Anchor> _anchors = [];

  @override
  void initState() {
    super.initState();
    DataManage().albums.then((value){
      setState(() {
        _anchors = value;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _anchors.length,
      itemBuilder: (ctx,index){
      final Anchor anchor = _anchors[index];
        return Card(
          child: ListTile(
            title: Text(anchor.userName),
            subtitle: Text(anchor.desc,maxLines: 2,),
            leading: CachedNetworkImage(imageUrl: anchor.headerIcon,fit: BoxFit.cover,height: 60,width: 60,),
            trailing: Icon(Icons.arrow_forward_ios,size: 16,),
            onTap: (){
                Navigator.pushNamed(context, HomePageAlbumItem.routeName,arguments: anchor);
            },
          ),
        );
    });
  }
}