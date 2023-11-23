import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'note_data.dart';
import 'account_action.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  final NoteData noteData = NoteData();

  int _index = -1;

  void _updateIndex(int index) {
    setState(() => _index = index);
  }

  void _addAccount(NoteAccount acct) {
    setState(() => noteData.addAccount(acct, noteData.groupAt(_index).id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.add),
              onPressed: () async {
                if (noteData.groupsLength == 0) {
                  Fluttertoast.showToast(
                      msg: "无分组，先创建分组", gravity: ToastGravity.CENTER);
                  addGroup();
                } else {
                  var result = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return AccountAction(NoteAccount(''));
                    }),
                  );

                  if (result is NoteAccount) {
                    _addAccount(result);
                  }
                }
              }),
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          IconButton(icon: const Icon(Icons.menu), onPressed: () {}),
        ],
      ),
      body: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  right: BorderSide(color: Colors.grey.shade300, width: 0.5),
                ),
              ),
              child: ListView.builder(
                itemCount: noteData.groupsLength + 1,
                itemBuilder: (BuildContext context, int index) {
                  if (index == noteData.groupsLength) {
                    return IconButton(
                      padding: const EdgeInsets.all(8),
                      icon: const Icon(
                        Icons.add,
                        color: Colors.black54,
                      ),
                      onPressed: () => addGroup(),
                    );
                  } else {
                    return InkWell(
                        child: Container(
                          margin: const EdgeInsets.only(left: 12, right: 12),
                          padding: const EdgeInsets.only(top: 16, bottom: 16),
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                            width: 1,
                            color: Colors.grey.shade200,
                          ))),
                          child: Text(
                            noteData.groupAt(index).name,
                            style: TextStyle(
                              fontSize: 16,
                              color: _index == index
                                  ? Theme.of(context).colorScheme.secondary
                                  : null,
                            ),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        onTap: () {
                          _updateIndex(index);
                        },
                        onLongPress: () async {
                          await groupOption(noteData.groupAt(index));
                        });
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
                    right: BorderSide(color: Colors.grey.shade300, width: 0.5)),
              ),
              child: ListView.builder(
                itemCount: _index >= 0
                    ? noteData.getAccounts(noteData.groupAt(_index).id).length
                    : 0,
                itemBuilder: (BuildContext context, int index) {
                  final noteAccount =
                      noteData.getAccounts(noteData.groupAt(_index).id)[index];
                  return InkWell(
                    onTap: () async {
                      await showAccountDetail(noteAccount);
                    },
                    child: Container(
                      margin: const EdgeInsets.only(left: 12, right: 12),
                      padding: const EdgeInsets.only(top: 16, bottom: 16),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                        width: 1,
                        color: Colors.grey.shade200,
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
                              child: Text(noteAccount.account ?? '',
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

  void addGroup({NoteGroup? noteGroup}) async {
    var add = noteGroup == null;
    await showDialog<bool>(
        context: context,
        builder: (context) {
          TextEditingController gNameController = TextEditingController();
          gNameController.text = noteGroup?.name ?? "";

          return AlertDialog(
            title: Text(add ? "添加分组" : '重命名'),
            content: TextField(
              autofocus: true,
              maxLength: 6,
              controller: gNameController,
              decoration: const InputDecoration(
                hintText: "分组名最多6个字符",
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text("取消"),
                onPressed: () => Navigator.pop(context),
              ),
              TextButton(
                child: const Text("确认"),
                onPressed: () {
                  if (gNameController.text.trim().isNotEmpty) {
                    if (noteGroup == null) {
                      setState(() {
                        noteData.addGroup(NoteGroup(gNameController.text));
                        _index = noteData.groupsLength - 1;
                      });
                    } else {
                      setState(() {
                        noteGroup.name = gNameController.text;
                        _index = noteData.groupIndexById(noteGroup.id);
                      });
                    }
                    Navigator.pop(context);
                  } else {
                    Fluttertoast.showToast(
                        msg: "分组名不能为空", gravity: ToastGravity.TOP);
                  }
                },
              ),
            ],
          );
        });
  }

  Future<void> showAccountDetail(NoteAccount account) {
    return showDialog<void>(
      context: context,
      builder: (context) {
        var fieldMap = <String, String>{
          '账号': account.account ?? '',
          '密码': account.password ?? ''
        }..addAll(account.extendField);

        var extend = <Widget>[];
        fieldMap.forEach((String k, String v) {
          extend.add(Row(
            children: <Widget>[
              Expanded(flex: 7, child: Text('$k: $v')),
              Expanded(
                flex: 1,
                child: IconButton(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  padding: const EdgeInsets.all(0),
                  icon: const Icon(
                    Icons.content_copy,
                    size: 20,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: v));
                    Fluttertoast.showToast(
                        msg: "已复制到剪贴板", gravity: ToastGravity.BOTTOM);
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
                        style: const TextStyle(fontSize: 22),
                      )),
                  Expanded(
                      flex: 1,
                      child: TextButton(
                        style: TextButton.styleFrom(
                            foregroundColor: Theme.of(context).primaryColor),
                        child: const Text(
                          "编辑",
                        ),
                        onPressed: () async {
                          Navigator.pop(context);
                          var result = await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) {
                              return AccountAction(account);
                            }),
                          );
                          if (result is NoteAccount) {
                            setState(() => account = result);
                          }
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

  Future<void> groupOption(NoteGroup noteGroup) async {
    int? i = await showDialog<int>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () {
                  // 返回1
                  Navigator.pop(context, 1);
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 6),
                  child: Text('重命名'),
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  // 返回2
                  Navigator.pop(context, 2);
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 6),
                  child: Text('删除'),
                ),
              ),
            ],
          );
        });

    if (i != null) {
      print("选择了：${i == 1 ? "重命名" : "删除"}");
    }
    switch (i) {
      case 1:
        addGroup(noteGroup: noteGroup);
    }
  }
}
