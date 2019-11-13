import 'package:flutter/material.dart';
import 'package:wanandroid/common/application.dart';
import 'package:wanandroid/common/user.dart';
import 'package:wanandroid/event/change_theme_event.dart';
import 'package:wanandroid/util/theme_util.dart';
import 'package:wanandroid/util/utils.dart';
import './app.dart';
import 'dart:io';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  _getLoginInfo();
  
  runApp(MyApp());
 
  if (Platform.isAndroid) {
    SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
}

_getLoginInfo() async {
  User.shared.getUserInfo();
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  
  Color themeColor = ThemeUtils.currentColorTheme;
  
  @override
  void initState() {
    super.initState();
    
    Utils.getColorThemeIndex().then((index) {
      if (index != null) {
        ThemeUtils.currentColorTheme = ThemeUtils.supportColors[index];
        Application.eventBus.fire(new ChangeThemeEvent(ThemeUtils.supportColors[index]));
      }
    });

    Application.eventBus.on<ChangeThemeEvent>().listen((event) {
      setState(() {
        themeColor = event.color;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "玩Android",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: themeColor, brightness: Brightness.light),
      home: App(),
    );
  }
}
