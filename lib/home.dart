import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:toast/toast.dart';

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

  void _addAccount(NoteAccount acct) {
    setState(() => noteData.getGroupAt(_index).addAccount(acct));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () async {
                if (noteData.length == 0) {
                  Toast.show("无分组，先创建分组", context, gravity: Toast.CENTER);
                  addGroup();
                } else {
                  var result = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return AccountAction(NoteAccount());
                    }),
                  );

                  if (result is NoteAccount) {
                    print(result);
                    _addAccount(result);
                  }
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
//                color: Colors.white,
                border: Border(
                    right: BorderSide(color: Colors.grey[300], width: 0.5)),
              ),
              child: ListView.builder(
                itemCount: noteData.getAccountsAt(_index)?.length ?? 0,
                itemBuilder: (BuildContext context, int index) {
                  final noteAccount = noteData.getAccountsAt(_index)[index];
                  return InkWell(
                    onTap: () async {
                      print(noteAccount.name);
                      await showAccountDetail(noteAccount);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                        width: 1,
                        color: Colors.grey[200],
                      ))),
                      child: Row(
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
                      ),
                    ),
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
                  if (_gNameController.text.trim().length > 0) {
                    _addGroup(_gNameController.text);
                    Navigator.pop(context);
                  } else {
                    Toast.show("分组名不能为空", context, gravity: Toast.TOP);
                  }
                },
              ),
            ],
          );
        });
  }

  Future<bool> showAccountDetail(NoteAccount account) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        var fieldMap = <String, String>{
          '账号': account.account,
          '密码': account.password
        }..addAll(account.extendField);

        var extend = <Widget>[];
        fieldMap.forEach((String k, String v) {
          extend.add(Row(
            children: <Widget>[
              Expanded(flex: 2, child: Text(k)),
              Expanded(flex: 5, child: Text(v)),
              Expanded(
                flex: 1,
                child: IconButton(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  padding: EdgeInsets.all(0),
                  icon: Icon(
                    Icons.content_copy,
                    size: 20,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: v));
                    Toast.show("已复制到剪贴板", context, gravity: Toast.BOTTOM);
                  },
                ),
              )
            ],
          ));
        });

        return AlertDialog(
          contentPadding: const EdgeInsets.all(16.0),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                      flex: 3,
                      child: Text(
                        account.name,
                        style: TextStyle(fontSize: 22),
                      )),
                  Expanded(
                      flex: 1,
                      child: FlatButton(
                        padding:  const EdgeInsets.all(0),
                        textColor: Theme.of(context).primaryColor,
                        child: Text(
                          "编辑",
                          style: TextStyle(fontSize: 16),
                        ),
                        onPressed: () {
                          print('d');
                        },
                      ))
                ],
              ),
              ...extend,
            ],
          ),
        );
      },
    );
  }
}
