import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wanandroid/base/_base_widget.dart';
import 'package:wanandroid/http/api_service.dart';
import 'package:wanandroid/model/article_model.dart';
import 'package:wanandroid/ui/public_ui/webview_page.dart';

class HomePage extends BaseWidget {
  @override
  BaseWidgetState<BaseWidget> getState() {
    return HomePageState();
  }
}

class HomePageState extends BaseWidgetState<HomePage> {
  List<Article> _datas = new List();
  ScrollController _scrollController = ScrollController();
  bool showToTopBtn = false;
  int _page = 0;

  @override
  void initState() {
    super.initState();

    setAppBarVisible(false);

    _getData();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        _getMore();
      }
      if (_scrollController.offset < 200 && showToTopBtn) {
        setState(() {
          showToTopBtn = false;
        });
      } else if (_scrollController.offset >= 200 && showToTopBtn == false) {
        setState(() {
          showToTopBtn = true;
        });
      }
    });
  }

  Future<Null> _getData() async {
    _page = 0;
    ApiService().getArticleList((ArticleModel model) {
      if (model.errorCode == 0) {
        if (model.data.datas.length > 0) {
          showContent();
          setState(() {
            _datas.clear();
            _datas.addAll(model.data.datas);
          });
        } else {
          showEmpty();
        }
      } else {
        Fluttertoast.showToast(msg: model.errorMsg);
      }
    }, (DioError error) {
      setState(() {
        showError();
      });
    }, _page);
  }

  Future<Null> _getMore() async {
    _page++;
    ApiService().getArticleList((ArticleModel model) {
      if (model.errorCode == 0) {
        if (model.data.datas.length > 0) {
          showContent();
          setState(() {
            _datas.addAll(model.data.datas);
          });
        } else {
          Fluttertoast.showToast(msg: "没有更多数据了");
        }
      } else {
        Fluttertoast.showToast(msg: model.errorMsg);
      }
    }, (DioError error) {
      print(error.response);
      setState(() {
        showError();
      });
    }, _page);
  }

  @override
  AppBar getAppBar() {
    return AppBar(
      title: Text("不显示"),
    );
  }

  @override
  Widget getContentWidget(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        displacement: 15,
        onRefresh: _getData,
        child: ListView.separated(
            itemBuilder: _renderRow,
            physics: new AlwaysScrollableScrollPhysics(),
            separatorBuilder: (BuildContext context, int index) {
              return Container(
                height: 0.5,
                color: Colors.black12,
              );
            },
            controller: _scrollController,
            itemCount: _datas.length),
      ),
      floatingActionButton: !showToTopBtn
          ? null
          : FloatingActionButton(
              child: Icon(Icons.arrow_upward),
              onPressed: () {
                _scrollController.animateTo(.0, duration: Duration(milliseconds: 200), curve: Curves.ease);
              }),
    );
  }

  Widget _renderRow(BuildContext context, int index) {
    return new InkWell(
      onTap: () {
        Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
          return new WebViewPage(title: _datas[index].title, url: _datas[index].link);
        }));
      },
      child: Column(
        children: <Widget>[
          Container(
            color: Colors.white,
            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              children: <Widget>[
                Text(
                  _datas[index].author,
                  style: TextStyle(fontSize: 12),
                  textAlign: TextAlign.left,
                ),
                Expanded(
                  child: Text(
                    _datas[index].niceDate,
                    style: TextStyle(fontSize: 12),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          ),
          Container(
            color: Colors.white,
            padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    _datas[index].title,
                    maxLines: 2,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF3D4E5F),
                    ),
                    textAlign: TextAlign.left,
                  ),
                )
              ],
            ),
          ),
          Container(
            color: Colors.white,
            padding: EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    _datas[index].superChapterName,
                    style: TextStyle(fontSize: 12),
                    textAlign: TextAlign.left,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  bool get wantKeepAlive => true;

  @override
  void onClickErrorWidget() {
    showloading();
    _getData();
  }
}
