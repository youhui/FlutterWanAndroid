import 'dart:async';

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:wanandroid/http/api_service.dart';
import 'package:wanandroid/model/pretty_model.dart';

class PrettyPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new PrettyPageState();
  }
}

class PrettyPageState extends State<PrettyPage> {

  List<ResultsListBean> _datas = new List();

  List<PhotoViewGalleryPageOptions> photos = new List();

  int _page = 1;

  Future<Null> _getData() async {
    ApiService().getPrettyGirl((PrettyModel prettyModel) {
      setState(() {
        _datas = prettyModel.results;
        for (int i = 0; i < _datas.length; i++) {
          PhotoViewGalleryPageOptions pageOptions = PhotoViewGalleryPageOptions(imageProvider: NetworkImage(_datas[i].url));
          photos.add(pageOptions);
        }
      });
    }, _page);
  }

  @override
  void initState() {
    super.initState();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("妹子图"),
      ),
      body: Container(
          child: PhotoViewGallery(
        onPageChanged: (int index) {
          if (index == photos.length - 1) {
            //加载到最有一页
            _page++;
            _getData();
          }
        },
        pageOptions: photos,
        backgroundDecoration: BoxDecoration(color: Colors.black87),
      )),
    );
  }
}
