import 'package:flutter/material.dart';
import 'note_data.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const _title = '密码本子';
    return MaterialApp(
      title: _title,
      //debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MyHomePage(title: _title),
    );
  }
}

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                if (noteData.length == 0) {
                  addGroup();
                } else {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return AccountAction(NoteAccount());
                  }));
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
              alignment: Alignment.topCenter,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  right: BorderSide(color: Colors.grey[300], width: 0.5),
                ),
              ),
              child: ListView.separated(
                padding:
                    const EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0),
                itemCount: noteData.length + 1,
                itemBuilder: (BuildContext context, int index) {
                  if (index == noteData.length) {
                    return Material(
                      color: Colors.white,
                      child: IconButton(
                          icon: Icon(Icons.add),
                          iconSize: 24,
                          onPressed: addGroup,
                          padding: const EdgeInsets.all(0.0)),
                    );
                  } else {
                    return Material(
                      color: Colors.white,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(50),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                          child: Text(
                            noteData.getGroupAt(index).name,
                            style: TextStyle(
                                color: _index == index
                                    ? Theme.of(context).accentColor
                                    : null),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        onTap: () {
                          _updateIndex(index);
                        },
                      ),
                    );
                  }
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
          Expanded(
            flex: 3,
            child: Container(
              alignment: Alignment.topCenter,
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
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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

enum _Action { add, edit }

class AccountAction extends StatefulWidget {
  AccountAction(this.account, {Key key})
      : this._action = account.name == null ? _Action.add : _Action.edit,
        super(key: key);
  final NoteAccount account;
  final _Action _action;

  @override
  _MyAccountActionState createState() => _MyAccountActionState();
}

class _MyAccountActionState extends State<AccountAction> {
  _MyAccountActionState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget._action == _Action.add ? '添加账号' : '编辑账号'),
      ),
      body: Center(
        child: Text("This is new route"),
      ),
    );
  }
}
