import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const _title = '密码本子';
    return MaterialApp(
      title: _title,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MyHomePage(title: _title),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Map noteData = {
    'aaa': [
      {'name': 'aaa'},
      {'name': 'bbb'},
      {'name': 'ccc'}
    ],
    'bbb': [
      {'name': 'aaa'},
      {'name': 'bbb'},
      {'name': 'ccc'}
    ]
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.add), onPressed: () {}),
          IconButton(icon: Icon(Icons.search), onPressed: () {}),
          IconButton(icon: Icon(Icons.menu), onPressed: () {}),
        ],
      ),
      body: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.topCenter,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(right: BorderSide(color: Colors.grey[400])),
              ),
              child: ListView(
                shrinkWrap: true,
                children: <Widget>[
                  const ListTile(title: Text('aaaaa')),
                  const ListTile(title: Text('bbbbb')),
                  const ListTile(title: Text('ccccc')),
                  const ListTile(title: Text('ddddd')),
                  IconButton(icon: Icon(Icons.add), onPressed: () {}),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
