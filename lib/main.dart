import 'package:flutter/material.dart';
import 'home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const title = '密码本子';
    return const MaterialApp(
      title: title,
      // theme: ThemeData(
      //   platform:
      // ),
      home: MyHomePage(title: title),
    );
  }
}
