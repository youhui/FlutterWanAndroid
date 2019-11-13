import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wanandroid/base/_base_widget.dart';
import 'package:wanandroid/http/api_service.dart';
import 'package:wanandroid/model/system_tree_model.dart';
import 'package:wanandroid/ui/knowledge/knowledge_content.dart';
import 'package:wanandroid/util/utils.dart';

class KnowledgePage extends BaseWidget {
  @override
  BaseWidgetState<BaseWidget> getState() {
    return KnowledgePageState();
  }
}

class KnowledgePageState extends BaseWidgetState<KnowledgePage> {
  List<SystemTreeData> _datas = new List();
  ScrollController _scrollController = ScrollController();
  bool showToTopBtn = false; //是否显示“返回到顶部”按钮

  @override
  void initState() {
    super.initState();
    setAppBarVisible(false);
    _getData();

    _scrollController.addListener(() {
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
    ApiService().getSystemTree((SystemTreeModel _systemTreeModel) {
      if (_systemTreeModel.errorCode == 0) {
        if (_systemTreeModel.data.length > 0) {
          showContent();
          setState(() {
            _datas.clear();
            _datas.addAll(_systemTreeModel.data);
          });
        } else {
          showEmpty();
        }
      } else {
        Fluttertoast.showToast(msg: _systemTreeModel.errorMsg);
      }
    }, (DioError error) {
      showError();
    });
  }

  Widget _renderRow(BuildContext context, int index) {
    if (index < _datas.length) {
      return InkWell(
          onTap: () {
            Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
              return new KnowledgeContentPage(new ValueKey(_datas[index]));
            }));
          },
          child: Container(
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                    child: Container(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(bottom: 8),
                        child: Text(
                          _datas[index].name,
                          style: TextStyle(fontSize: 16, color: Color(0xFF3D4E5F), fontWeight: FontWeight.bold),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Container(alignment: Alignment.centerLeft, child: buildChildren(_datas[index].children)),
                    ],
                  ),
                )),
                Icon(Icons.chevron_right)
              ],
            ),
          ));
    }
    return null;
  }

  Widget buildChildren(List<SystemTreeChild> children) {
    List<Widget> tiles = [];
    Widget content;
    for (var item in children) {
      tiles.add(
        new Chip(
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          backgroundColor: Utils.getChipBgColor(item.name),
          label: new Text(item.name),
        ),
      );
    }

    content = Wrap(spacing: 12, runSpacing: 12, alignment: WrapAlignment.start, children: tiles);

    return content;
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
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
              color: Colors.black26,
            );
          },
          itemCount: _datas.length,
          controller: _scrollController,
        ),
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

  @override
  void onClickErrorWidget() {
    showloading();
    _getData();
  }
}
