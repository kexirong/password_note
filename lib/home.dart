import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
// import 'package:password_note/util.dart';
import 'note_data.dart';
import 'account_action.dart';

// import 'package:hive/hive.dart';

part 'app_data_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  void _addGroupCB() {
    addGroup();
  }

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print("++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++HomePageState rebuild");
    }
    final appData = Provider.of<AppData>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.add),
              onPressed: () async {
                if (appData.noteGroups.isEmpty) {
                  const snackBar = SnackBar(
                    content: Text('无分组，先创建分组'),
                  );

                  ScaffoldMessenger.of(context).showSnackBar(snackBar);

                  addGroup();
                } else {
                  var result = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return AccountAction(NoteAccount(''));
                    }),
                  );

                  if (result is NoteAccount) {
                    appData.addNoteAccount(result);
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
            child: GroupListWidget(addGroup: _addGroupCB),
          ),
          const Expanded(
            flex: 3,
            child: AccountList(),
          ),
        ],
      ),
    );
  }

  void addGroup({NoteGroup? noteGroup}) async {
    final appData = Provider.of<AppData>(context);
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
                      appData.addNoteGroup(NoteGroup(gNameController.text));
                      appData.setIndex(appData.noteGroups.length - 1);
                      // setState(() {
                      //   noteData.addGroup(NoteGroup(gNameController.text));
                      //   _index = noteData.groups.length - 1;
                      // });
                    } else {
                      appData.noteGroupSetName(gNameController.text);
                      // setState(() {
                      //   noteGroup.name = gNameController.text;
                      //   _index = noteData.groupIndexById(noteGroup.id);
                      // });
                    }
                    Navigator.pop(context);
                  } else {
                    const snackBar = SnackBar(
                      content: Text('分组名不能为空'),
                    );

                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                },
              ),
            ],
          );
        });
  }
}

class GroupListWidget extends StatelessWidget {
  const GroupListWidget({super.key, required this.addGroup});

  final void Function() addGroup;

  @override
  Widget build(BuildContext context) {
    final appData = Provider.of<AppData>(context);

    var groups = appData.noteGroups;

    return Container(
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
      ),
      child: ListView.builder(
        itemCount: groups.length + 1,
        itemBuilder: (BuildContext context, int index) {
          if (index == groups.length) {
            return IconButton(
              padding: const EdgeInsets.all(8),
              icon: const Icon(
                Icons.add,
                color: Colors.black54,
              ),
              onPressed: () => addGroup(),
            );
          } else {
            if (kDebugMode) {
              print(Theme.of(context).colorScheme.secondary);
            }
            return InkWell(
                child: Container(
                  margin: const EdgeInsets.only(left: 12, right: 12),
                  padding: const EdgeInsets.only(top: 16, bottom: 16),
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(width: 1, color: Colors.grey.shade200)),
                  ),
                  child: Text(
                    groups[index].name,
                    style: TextStyle(
                      fontSize: 16,
                      color:
                          appData.index == index ? Theme.of(context).colorScheme.secondary : null,
                    ),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                onTap: () {
                  appData.setIndex(index);
                },
                onLongPress: () async {
                  var action = await groupOption(groups[index], context);

                  switch (action) {
                    case 1:
                      if (kDebugMode) {
                        print("重命名");
                      }
                      if (!context.mounted) return;
                      var newName = await _renameNoteGroup(groups[index], context);

                      if (newName != null && newName.isNotEmpty) {
                        groups[index].name = newName;
                        // noteGroupWidget.rename(index, newName);
                      }

                    case 2:
                      if (kDebugMode) {
                        print("删除");
                      }
                      appData.noteGroupRemoveAt(index);
                  }
                });
          }
        },
      ),
    );
  }

  Future<int?> groupOption(NoteGroup noteGroup, BuildContext context) async {
    return await showDialog<int>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () {
                  // 返回1
                  // if (!context.mounted) return;
                  Navigator.of(context).pop(1);
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 6),
                  child: Text('重命名'),
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  // 返回2
                  // if (!context.mounted) return;
                  Navigator.of(context).pop(2);
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 6),
                  child: Text('删除'),
                ),
              ),
            ],
          );
        });
  }

  Future<String?> _renameNoteGroup(NoteGroup noteGroup, BuildContext context) async {
    return await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        TextEditingController controller = TextEditingController();
        controller.text = noteGroup.name;
        return AlertDialog(
          title: const Text('重命名'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(labelText: '新名称'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // if (!context.mounted) return;
                Navigator.of(context).pop();
              },
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () {
                String newName = controller.text;
                // if (!context.mounted) return;
                Navigator.of(context).pop(newName);
              },
              child: const Text('确认'),
            ),
          ],
        );
      },
    );
  }
}

class AccountList extends StatelessWidget {
  const AccountList({super.key});

  @override
  Widget build(BuildContext context) {
    final appData = Provider.of<AppData>(context);

    var accounts = appData.noteAccounts;
    return Container(
      decoration: BoxDecoration(
//                color: Colors.white,
        border: Border(right: BorderSide(color: Colors.grey.shade300, width: 0.5)),
      ),
      child: ListView.builder(
        itemCount: accounts.length,
        itemBuilder: (BuildContext context, int index) {
          if (kDebugMode) {
            print("${accounts.length}:$index");
          }

          final noteAccount = accounts[index];
          return InkWell(
            onTap: () async {
              var result = await showAccountDetail(noteAccount, context);
              if (result is NoteAccount) {
                accounts[index] = result;
              }
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
                        textAlign: TextAlign.left, overflow: TextOverflow.ellipsis),
                  ),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(noteAccount.account ?? '',
                          textAlign: TextAlign.left, overflow: TextOverflow.ellipsis),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<NoteAccount?> showAccountDetail(NoteAccount account, BuildContext context) async {
    return await showDialog<NoteAccount>(
      context: context,
      builder: (context) {
        var fieldMap = <String, String>{'账号': account.account ?? '', '密码': account.password ?? ''}
          ..addAll(account.extendField);

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
                    const snackBar = SnackBar(
                      content: Text('已复制到剪贴板'),
                    );

                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
                        style:
                            TextButton.styleFrom(foregroundColor: Theme.of(context).primaryColor),
                        child: const Text("编辑"),
                        onPressed: () async {
                          var result = await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) {
                              return AccountAction(account);
                            }),
                          );
                          if (!context.mounted) return;

                          Navigator.of(context).pop(result);
                          // setState(() => account = result);
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
