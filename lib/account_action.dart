import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:toast/toast.dart';
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

class TextEditingHelper {
  List<FocusNode> nodes;
  List<TextEditingController> controllers;

  TextEditingHelper(int length) {
    this.nodes = List(length);
    this.controllers = List(length);
    for (int i = 0; i < length; i++) {
      this.nodes[i] = FocusNode();
    }
  }
}

class _MyAccountActionState extends State<AccountAction> {
  _MyAccountActionState();

  bool _saved = true;

  List<TextEditingHelper> _accountFields;

  @override
  void initState() {
    super.initState();

    _accountFields = <TextEditingHelper>[];

    TextEditingHelper helper = TextEditingHelper(2);
    helper.controllers[0] = TextEditingController(text: '名称');
    helper.controllers[1] = TextEditingController(text: widget.account.name);
    _accountFields.add(helper);

    helper = TextEditingHelper(2);
    helper.controllers[0] = TextEditingController(text: '账号');
    helper.controllers[1] = TextEditingController(text: widget.account.account);
    _accountFields.add(helper);

    helper = TextEditingHelper(2);
    helper.controllers[0] = TextEditingController(text: '密码');
    helper.controllers[1] =
        TextEditingController(text: widget.account.password);
    _accountFields.add(helper);

    widget.account.extendField.forEach((k, v) {
      helper = TextEditingHelper(2);
      helper.controllers[0] = TextEditingController(text: k);
      helper.controllers[1] = TextEditingController(text: v);
      _accountFields.add(helper);
    });
  }

  void _addItem() {
    setState(() {
      TextEditingHelper helper = TextEditingHelper(2);
      helper.controllers[0] = TextEditingController(text: '');
      helper.controllers[1] = TextEditingController(text: '');
      _accountFields.add(helper);
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
                  onPressed: () {
                    if (!save()) {
                      return;
                    }

                    Toast.show("已保存", context, gravity: Toast.CENTER);
                    Navigator.pop(context, widget.account);
                  },
                ),
              ]),
          body: SingleChildScrollView(
            child: Column(
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
                                left:
                                    BorderSide(color: Colors.grey, width: 0.5),
                                bottom:
                                    BorderSide(color: Colors.grey, width: 0.5),
                                top:
                                    BorderSide(color: Colors.grey, width: 0.5)),
                            padding: const EdgeInsets.only(top: 12, bottom: 12),
                            child: Text(
                              "随机密码",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 16),
                            ),
                            onPressed: rndPassword,
                          )),
                      Expanded(
                          flex: 1,
                          child: FlatButton(
                            padding: const EdgeInsets.only(top: 12, bottom: 12),
                            shape: const Border(
                                left:
                                    BorderSide(color: Colors.grey, width: 0.5),
                                bottom:
                                    BorderSide(color: Colors.grey, width: 0.5),
                                top:
                                    BorderSide(color: Colors.grey, width: 0.5)),
                            child: Text(
                              "清空所有",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 16),
                            ),
                            onPressed: () {
                              Toast.show("功能未实现", context, gravity: Toast.TOP);
                            },
                          )),
                      Expanded(
                          flex: 1,
                          child: FlatButton(
                            padding: const EdgeInsets.only(top: 12, bottom: 12),
                            shape: const Border(
                                left:
                                    BorderSide(color: Colors.grey, width: 0.5),
                                bottom:
                                    BorderSide(color: Colors.grey, width: 0.5),
                                top: BorderSide(color: Colors.grey, width: 0.5),
                                right:
                                    BorderSide(color: Colors.grey, width: 0.5)),
                            child: Text(
                              "添加条目",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 16),
                            ),
                            onPressed: () {
                              _addItem();
                              _saved = false;
                            },
                          ))
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        onWillPop: () async {
          bool confirm = false;
          if (!_saved) {
            confirm = await showReturnConfirm();
          }

          if (_saved || confirm) {
            Navigator.pop(context);
            return Future.value(true);
          }
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
                enabled: index > 2,
//                autofocus: _accountFields[index][0].text == '新增',
                focusNode: _accountFields[index].nodes[0],
                maxLength: 12,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                ),
                controller: _accountFields[index].controllers[0],
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.only(
                      left: 8, right: 8, top: 12, bottom: 12),
                  border: InputBorder.none,
                  counterText: '',
                ),
                onChanged: (_) => _saved = false,
              ),
            ),
            TableCell(
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 5,
                    child: TextField(
                      autofocus:
                          _accountFields[index].controllers[1].text.length == 0,
                      focusNode: _accountFields[index].nodes[1],
                      maxLines: 4,
                      minLines: 1,
                      style: TextStyle(fontSize: 16),
                      controller: _accountFields[index].controllers[1],
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.only(
                            left: 8, right: 0, top: 12, bottom: 12),
                        border: InputBorder.none,
                        counterText: '',
                      ),
                      onChanged: (_) => _saved = false,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: IconButton(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      padding: EdgeInsets.all(0),
                      icon: Icon(
                        Icons.highlight_off,
                        size: 20,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        if (_accountFields[index].controllers[1].text != '') {
                          _accountFields[index].controllers[1].text = '';
                        } else if (index > 2) {
                          setState(() {
                            _accountFields.removeAt(index);
                          });
                        }
                      },
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

  Future<void> rndPassword() async {
    double slider = 8;

    bool capital = true;
    bool lowercase = true;
    bool punctuation = false;
    String gen() {
      //重复一次, 增大数字出现概率
      String chars = '01234567890123456789';
      if (capital) {
        chars += "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
      }
      if (lowercase) {
        chars += 'abcdefghijklmnopqrstuvwxyz';
      }
      if (punctuation) {
        chars += '!"#\$%&\'()*+,-./:;<=>?@[\\]^_`{|}~';
      }
      var _rnd = Random();
      return String.fromCharCodes(
        Iterable.generate(slider.truncate(),
            (_) => chars.codeUnitAt(_rnd.nextInt(chars.length))),
      );
    }

    String password = gen();
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 0),
          actionsPadding: const EdgeInsets.only(right: 24),
          title: Text.rich(
            new TextSpan(
              text: '生成随机密码',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.normal,
              ),
              children: <TextSpan>[
                new TextSpan(
                  text: ' [${slider.truncate()}]',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 18,
                    fontWeight: FontWeight.normal,
                  ),
                )
              ],
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text('$password'),
              Slider(
                value: slider,
                max: 16.0,
                min: 6.0,
                onChanged: (double val) {
                  slider = val.roundToDouble();
                  (context as Element).markNeedsBuild();
                },
                onChangeEnd: (double val) {
                  password = gen();
                  (context as Element).markNeedsBuild();
                },
              ),
              Row(
                children: <Widget>[
                  Checkbox(
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    value: capital,
                    onChanged: (bool value) {
                      capital = value;
                      password = gen();
                      (context as Element).markNeedsBuild();
                    },
                  ),
                  Text("包含大写字母"),
                ],
              ),
              Row(
                children: <Widget>[
                  Checkbox(
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    value: lowercase,
                    onChanged: (bool value) {
                      lowercase = value;
                      password = gen();
                      (context as Element).markNeedsBuild();
                    },
                  ),
                  Text("包含小写字母"),
                ],
              ),
              Row(
                children: <Widget>[
                  Checkbox(
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    value: punctuation,
                    onChanged: (bool value) {
                      punctuation = value;
                      password = gen();
                      (context as Element).markNeedsBuild();
                    },
                  ),
                  Text("包含特殊符号"),
                ],
              ),
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: Text("取消"),
              onPressed: () => Navigator.pop(context),
            ),
            FlatButton(
              child: Text("刷新"),
              onPressed: () {
                password = gen();
                (context as Element).markNeedsBuild();
              },
            ),
            FlatButton(
              child: Text("复制密码"),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: password));
                Toast.show("已复制到剪贴板", context, gravity: Toast.BOTTOM);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  bool save() {
    for (var element in _accountFields) {
      var text0 = element.controllers[0].text.trim();
      var text1 = element.controllers[1].text.trim();
      if (text0.trim().length == 0) {
        Toast.show("此字段不能为空", context, gravity: Toast.TOP);
        FocusScope.of(context).requestFocus(element.nodes[0]);
        return false;
      }
      if (text1.trim().length == 0) {
        Toast.show("此字段不能为空", context, gravity: Toast.TOP);
        FocusScope.of(context).requestFocus(element.nodes[1]);
        return false;
      }

      switch (element.controllers[0].text) {
        case '名称':
          widget.account.name = text1;
          break;
        case '账号':
          widget.account.account = text1;
          break;
        case '密码':
          widget.account.password = text1;
          break;
        default:
          widget.account.extendField[text0] = text1;
      }
    }

    return _saved = true;
  }

  Future<bool> showReturnConfirm() {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("提示"),
          content: Text("确认不保存退出?"),
          actions: <Widget>[
            FlatButton(
              child: Text("取消"),
              onPressed: () => Navigator.of(context).pop(false), // 关闭对话框
            ),
            FlatButton(
              child: Text("确认"),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
  }
}
