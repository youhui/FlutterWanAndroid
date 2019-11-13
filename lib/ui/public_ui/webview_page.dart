import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:wanandroid/util/theme_util.dart';

class WebViewPage extends StatefulWidget {
  String title;
  String url;

  WebViewPage({
    Key key,
    @required this.title,
    @required this.url,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new WebViewPageState();
  }
}

class WebViewPageState extends State<WebViewPage> {
  bool isLoad = true;
  final flutterWebviewPlugin = new FlutterWebviewPlugin();

  @override
  void initState() {
    super.initState();

    flutterWebviewPlugin.onStateChanged.listen((state) {
      if (state.type == WebViewState.finishLoad) {
        setState(() {
          isLoad = false;
        });
      } else if (state.type == WebViewState.startLoad) {
        setState(() {
          isLoad = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      url: widget.url,
      appBar: AppBar(
        elevation: 0.4,
        title: Text(widget.title),
        bottom: PreferredSize(
          child: isLoad ? new LinearProgressIndicator() : new Divider(height: 1.0, color: ThemeUtils.currentColorTheme),
          preferredSize: const Size.fromHeight(1.0),
        ),
      ),
      withJavascript: true,
      withZoom: false,
      withLocalStorage: true,
    );
  }
}
