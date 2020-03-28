import 'package:flutter/material.dart';
import 'package:pi_pic_take/image_view.dart';
import 'package:pi_pic_take/setting.dart';
import 'home.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '树莓派远程拍照',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/': (BuildContext context) => HomePage(title: '树莓派远程拍照'),
        '/setting': (BuildContext context) => SettingPage(title: '设置'),
        '/image': (BuildContext context) => ImageViewPage(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
