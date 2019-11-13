import 'package:flutter/material.dart';
import 'package:wanandroid/ui/public_ui/webview_page.dart';

class AboutMePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AboutMePageState();
  }
}

class AboutMePageState extends State<AboutMePage> {
  TextStyle textStyle = new TextStyle(
      color: Colors.blue,
      decoration: new TextDecoration.combine([TextDecoration.underline]));

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("关于作者"),
        ),
        body: new Container(
          padding: EdgeInsets.fromLTRB(35, 50, 35, 15),
          child: new Column(
            children: <Widget>[

              CircleAvatar(
                minRadius: 60,
                maxRadius: 60,
                backgroundImage: AssetImage('images/avatar.png'),
              ),

              Padding(padding: EdgeInsets.only(top: 30)),

              new Text("基于Google Flutter的玩Android客户端"),

              Container(
                margin: const EdgeInsets.fromLTRB(0.0, 80.0, 0.0, 0.0),
                child: new Row(

                  children: <Widget>[
                    new Text("邮箱："),
                    new Text(
                      "user@flutter.com",
                      style: TextStyle(color: Colors.blue),

                    ),
                  ],
                ),
              ),

              GestureDetector(
                child: new Container(
                  margin: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
                  child: new Row(

                    children: <Widget>[
                      new Text("flutter："),
                      new Text(
                        "https://flutter.cn",
                        style: textStyle,
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  Navigator.of(context)
                      .push(new MaterialPageRoute(builder: (ctx) {
                    return new WebViewPage(
                        title: "flutter",
                        url: "https://flutter.cn");
                  }));
                },
              ),
              GestureDetector(
                child: new Container(
                  margin: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
                  child: new Row(

                    children: <Widget>[
                      new Text("GitHub："),
                      new Text(
                        "https://github.com/flutter/flutter",
                        style: textStyle,
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  Navigator.of(context)
                      .push(new MaterialPageRoute(builder: (ctx) {
                    return new WebViewPage(
                        title: "GitHub",
                        url: "https://github.com/flutter/flutter");
                  }));
                },
              ),
              Expanded(child: Container(), flex: 1),
              new Text(
                "本项目仅供学习使用，不得用作商业目的",
                style: new TextStyle(fontSize: 12.0),
              )
            ],
          ),
        ));
  }
}
