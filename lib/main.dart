import 'package:flutter/material.dart';
import 'home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const _title = '密码本子';
    return MaterialApp(
      title: _title,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue,
          canvasColor:Colors.white),
      home: MyHomePage(title: _title),
    );
  }
}
