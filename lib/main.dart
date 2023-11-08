import 'package:flutter/material.dart';
import 'home.dart';
import 'persist.dart';

void main() {
  DatabaseHelper db = DatabaseHelper();
  db.database;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const title = '密码本子';
    return MaterialApp(
      title: title,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        canvasColor: Colors.white,
      ),
      home: const MyHomePage(title: title),
    );
  }
}
