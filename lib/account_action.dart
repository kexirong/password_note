import 'package:flutter/material.dart';
import 'note_data.dart';

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
    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
              title: Text(widget._action == _Action.add ? '添加账号' : '编辑账号'),
              actions: <Widget>[
                SizedBox(
                  width: 70,
                  child: FlatButton(
                    textColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)),
                    child: Text("保存"),
                    onPressed: () {},
                  ),
                ),
              ]),
          body: Container(
              decoration: BoxDecoration(
                border: Border(
                    top: BorderSide(
                        color: Colors.grey, width: 0.5),
                    right: BorderSide(
                        color: Colors.grey, width: 0.5),
                    left: BorderSide(
                        color: Colors.grey, width: 0.5),
                ),
              ),
              margin: const EdgeInsets.all(8),
              child: ListView.builder(
                  itemCount: 3,
                  shrinkWrap: true,
                  itemExtent: 50.0, //强制高度为50.0
                  itemBuilder: (BuildContext context, int index) {
                    return Row(children: <Widget>[
                      Expanded(
                          flex: 1,
                          child: Container(
                              decoration: BoxDecoration(
                                border:  Border(
                                        bottom: BorderSide(
                                            color: Colors.grey, width: 0.5),
                                        right: BorderSide(
                                            color: Colors.grey, width: 0.5)),
                              ),
                              child: ListTile(
                                title: Text(
                                  "$index",
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                onTap: () {
                                  print('点击');
                                },
                              ))),
                      Expanded(
                          flex: 2,
                          child: Container(
                              decoration: BoxDecoration(
                                border: Border(
                                        bottom: BorderSide(
                                            color: Colors.grey, width: 0.5),
                                      ),
                              ),
                              child: ListTile(
                                title: Text(
                                  "$index",
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                onTap: () {
                                  print('点击');
                                },
                              )))
                    ]);
                  })),
        ),
        onWillPop: () {
          print("返回键点击了");
          Navigator.pop(context, 'hehe');
          return Future.value(false);
        });
  }
}
