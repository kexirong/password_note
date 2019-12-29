import 'package:flutter/material.dart';
import 'note_data.dart';
import 'account_action.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState(NoteData());
}

class _MyHomePageState extends State<MyHomePage> {
  _MyHomePageState(this.noteData);

  final NoteData noteData;

  int _index = 0;

  void _updateIndex(int index) {
    setState(() => _index = index);
  }

  void _addGroup(String name) {
    setState(() => noteData.addGroup(NoteGroup(name: name)));
  }

  var _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () async {
                if (noteData.length == 0) {
                  _scaffoldKey.currentState.showSnackBar(SnackBar(
                    content: Text('无分组，先创建分组'),
                    duration: Duration(seconds: 1),
                  ));
                  addGroup();
                } else {
                  var result = await Navigator.push(context,
                      MaterialPageRoute(builder: (context) {
                    return AccountAction(NoteAccount());
                  }));
                  print(result);
                }
              }),
          IconButton(icon: Icon(Icons.search), onPressed: () {}),
          IconButton(icon: Icon(Icons.menu), onPressed: () {}),
        ],
      ),
      body: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  right: BorderSide(color: Colors.grey[300], width: 0.5),
                ),
              ),
              child: ListView.builder(
                itemCount: noteData.length + 1,
                itemBuilder: (BuildContext context, int index) {
                  if (index == noteData.length) {
                    return IconButton(
                      padding: const EdgeInsets.all(8),
                      icon: Icon(
                        Icons.add,
                        color: Colors.black54,
                      ),
                      onPressed: addGroup,
                    );
                  } else {
                    return InkWell(
                      child: Container(
                        margin: const EdgeInsets.only(left: 8, right: 8),
                        padding: const EdgeInsets.only(top: 16, bottom: 16),
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                          width: 1,
                          color: Colors.grey[200],
                        ))),
                        child: Text(
                          noteData.getGroupAt(index).name,
                          style: TextStyle(
                            fontSize: 16,
                            color: _index == index
                                ? Theme.of(context).accentColor
                                : null,
                          ),
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      onTap: () {
                        _updateIndex(index);
                      },
                    );
                  }
                },
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                    right: BorderSide(color: Colors.grey[300], width: 0.5)),
              ),
              child: ListView.separated(
                padding:
                    const EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0),
                itemCount: noteData.getAccountsAt(_index)?.length ?? 0,
                itemBuilder: (BuildContext context, int index) {
                  final noteAccount = noteData.getAccountsAt(_index)[index];
                  return Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                      child: Row(
//                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: Text(noteAccount.name,
                                textAlign: TextAlign.left,
                                overflow: TextOverflow.ellipsis),
                          ),
                          Expanded(
                            flex: 2,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(noteAccount.account,
                                  textAlign: TextAlign.left,
                                  overflow: TextOverflow.ellipsis),
                            ),
                          ),
                        ],
                      ));
                },
                separatorBuilder: (BuildContext context, int index) {
                  return Divider(
                    thickness: 0.2,
                    color: Colors.grey,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void addGroup() async {
    await showDialog<bool>(
        context: context,
        builder: (context) {
          TextEditingController _gNameController = TextEditingController();

          return AlertDialog(
            title: Text("添加分组"),
            content: TextField(
              autofocus: true,
              maxLength: 6,
              controller: _gNameController,
              decoration: InputDecoration(
                hintText: "分组名最多6个字符",
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text("取消"),
                onPressed: () => Navigator.pop(context),
              ),
              FlatButton(
                child: Text("确认"),
                onPressed: () {
                  _addGroup(_gNameController.text);
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }
}
