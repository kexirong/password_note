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

  List<List<TextEditingController>> _accountFields;

  @override
  void initState() {
    super.initState();

    _accountFields = <List<TextEditingController>>[];
    _accountFields.add(
      [
        TextEditingController(text: '名称'),
        TextEditingController(text: widget.account.name),
      ],
    );
    _accountFields.add(
      [
        TextEditingController(text: '账号'),
        TextEditingController(text: widget.account.account),
      ],
    );

    widget.account.extendField.forEach((k, v) {
      _accountFields.add(
        [
          TextEditingController(text: k),
          TextEditingController(text: v),
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
              title: Text(widget._action == _Action.add ? '添加账号' : '编辑账号'),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.save),
                  onPressed: () {},
                ),
              ]),
          body: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16),
                child: Table(
                  columnWidths: const {
                    0: FlexColumnWidth(1.0),
                    1: FlexColumnWidth(2.5),
                  },
                  border: TableBorder.all(
                    color: Colors.grey,
                    width: 0.5,
                  ),
                  children: _buildTableRow(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: Row(
                  children: <Widget>[
                    Expanded(
                        flex: 1,
                        child: FlatButton(
                          shape: const Border(
                              left: BorderSide(color: Colors.grey, width: 0.5),
                              bottom:
                                  BorderSide(color: Colors.grey, width: 0.5),
                              top: BorderSide(color: Colors.grey, width: 0.5)),
                          padding: const EdgeInsets.only(top: 12, bottom: 12),
                          child: Text(
                            "随机密码",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16),
                          ),
                          onPressed: () {},
                        )),
                    Expanded(
                        flex: 1,
                        child: FlatButton(
                          padding: const EdgeInsets.only(top: 12, bottom: 12),
                          shape: const Border(
                              left: BorderSide(color: Colors.grey, width: 0.5),
                              bottom:
                                  BorderSide(color: Colors.grey, width: 0.5),
                              top: BorderSide(color: Colors.grey, width: 0.5)),
                          child: Text(
                            "调整顺序",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16),
                          ),
                          onPressed: () {},
                        )),
                    Expanded(
                        flex: 1,
                        child: FlatButton(
                          padding: const EdgeInsets.only(top: 12, bottom: 12),
                          shape: const  Border(
                              left: BorderSide(color: Colors.grey, width: 0.5),
                              bottom:
                                  BorderSide(color: Colors.grey, width: 0.5),
                              top: BorderSide(color: Colors.grey, width: 0.5),
                              right:
                                  BorderSide(color: Colors.grey, width: 0.5)),
                          child: Text(
                            "添加项目",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16),
                          ),
                          onPressed: () {},
                        ))
                  ],
                ),
              )
            ],
          ),
        ),
        onWillPop: () {
          print("返回键点击了");
          Navigator.pop(context, 'none');
          return Future.value(false);
        });
  }

  List<TableRow> _buildTableRow() {
    var rows = <TableRow>[];
    for (var index = 0; index < _accountFields.length; index++) {
      rows.add(
        TableRow(
          children: <Widget>[
            TableCell(
              verticalAlignment: TableCellVerticalAlignment.middle,
              child: TextField(
                enabled: index > 1,
                autofocus: _accountFields[index][0].text.length == 0,
                maxLength: 12,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                ),
                controller: _accountFields[index][0],
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.only(
                      left: 8, right: 8, top: 16, bottom: 16),
                  border: InputBorder.none,
                  counterText: '',
                ),
              ),
            ),
            TableCell(
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 5,
                    child: TextField(
                      autofocus: _accountFields[index][1].text.length == 0,
                      maxLines: 4,
                      minLines: 1,
                      style: TextStyle(fontSize: 16),
                      controller: _accountFields[index][1],
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.only(
                            left: 8, right: 0, top: 16, bottom: 16),
                        border: InputBorder.none,
                        counterText: '',
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Icon(
                      Icons.highlight_off,
                      size: 20,
                      color: Colors.grey,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      );
    }
    return rows;
  }
}
