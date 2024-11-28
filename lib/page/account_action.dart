import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/model/note_data.dart';

enum _Action { add, edit }

class AccountAction extends StatefulWidget {
  AccountAction(this.account, {super.key})
      : _action = account.name.isEmpty ? _Action.add : _Action.edit;
  final PlainAccount account;
  final _Action _action;

  @override
  AccountActionState createState() => AccountActionState();
}

class TextEditingHelper {
  List<FocusNode> nodes;
  List<TextEditingController> controllers;

  TextEditingHelper(int length)
      : nodes = List.filled(length, FocusNode()),
        controllers = List.filled(length, TextEditingController());
}

class AccountActionState extends State<AccountAction> {
  AccountActionState();

  bool _saved = true;

  final List<TextEditingHelper> _accountFields = <TextEditingHelper>[];

  @override
  void initState() {
    super.initState();
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
    helper.controllers[1] = TextEditingController(text: widget.account.password);
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
    return PopScope<PlainAccount>(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: Text(widget._action == _Action.add ? '添加账号' : '编辑账号'),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: () {
                if (!save()) {
                  return;
                }
                const snackBar = SnackBar(
                  content: Text('已保存'),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);

                Navigator.pop(context, widget.account);
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8),
                child: Table(
                  columnWidths: const {
                    0: FlexColumnWidth(1.0),
                    1: FlexColumnWidth(3.0),
                  },
                  border: TableBorder.all(
                    color: Theme.of(context).colorScheme.outline,
                    width: 1,
                  ),
                  children: _buildTableRow(),
                ),
              ),
              OverflowBar(
                alignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  OutlinedButton(
                      onPressed: rndPassword,
                      style: ButtonStyle(
                        shape: WidgetStateProperty.all(
                            const RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
                      ),
                      child: const Text(
                        "随机密码",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16),
                      )),
                  OutlinedButton(
                    style: ButtonStyle(
                      shape: WidgetStateProperty.all(
                          const RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
                    ),
                    onPressed: () {
                      const snackBar = SnackBar(
                        content: Text('功能未实现'),
                      );

                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    },
                    child: const Text(
                      "清空所有",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  OutlinedButton(
                    style: ButtonStyle(
                      shape: WidgetStateProperty.all(
                          const RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
                    ),
                    onPressed: () {
                      _addItem();
                      _saved = false;
                    },
                    child: const Text(
                      "添加条目",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
      onPopInvokedWithResult: (bool didPop, PlainAccount? account) async {
        if (didPop) return;
        bool? doPop = false;
        if (!_saved) {
          doPop = await showDialog<bool>(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("提示"),
                content: const Text("确认不保存退出?"),
                actions: <Widget>[
                  TextButton(
                    child: const Text("取消"),
                    onPressed: () => Navigator.pop(context, false), // 关闭对话框
                  ),
                  TextButton(
                    child: const Text("确认"),
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                  ),
                ],
              );
            },
          );
        }
        if (!context.mounted) return;
        if ((_saved || doPop!)) {
          Navigator.pop(context);
        }
      },
    );
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
                maxLength: 12,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                ),
                controller: _accountFields[index].controllers[0],
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.only(left: 8, right: 8, top: 12, bottom: 12),
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
                      maxLines: 4,
                      minLines: 1,
                      style: const TextStyle(fontSize: 16),
                      controller: _accountFields[index].controllers[1],
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.only(left: 8, right: 0, top: 12, bottom: 12),
                        border: InputBorder.none,
                        counterText: '',
                      ),
                      onChanged: (_) => _saved = false,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: IconButton(
                      // splashColor: Colors.transparent,
                      // highlightColor: Colors.transparent,
                      padding: const EdgeInsets.all(0),
                      icon: Icon(
                        Icons.highlight_off,
                        size: 20,
                        color: Theme.of(context).colorScheme.secondary,
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

    bool? capital = true;
    bool? lowercase = true;
    bool? punctuation = false;
    String gen() {
      //重复一次, 增大数字出现概率
      String chars = '01234567890123456789';
      if (capital!) {
        chars += "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
      }
      if (lowercase!) {
        chars += 'abcdefghijklmnopqrstuvwxyz';
      }
      if (punctuation!) {
        chars += '!"#\$%&\'()*+,-./:;<=>?@[\\]^_`{|}~';
      }
      var rnd = Random();
      return String.fromCharCodes(
        Iterable.generate(slider.truncate(), (_) => chars.codeUnitAt(rnd.nextInt(chars.length))),
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
            TextSpan(
              text: '生成随机密码',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.normal,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: '[${slider.truncate()}]',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
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
              Text(password),
              Slider(
                value: slider,
                max: 32.0,
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
                    onChanged: (bool? value) {
                      capital = value;
                      password = gen();
                      (context as Element).markNeedsBuild();
                    },
                  ),
                  const Text("包含大写字母"),
                ],
              ),
              Row(
                children: <Widget>[
                  Checkbox(
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    value: lowercase,
                    onChanged: (bool? value) {
                      lowercase = value;
                      password = gen();
                      (context as Element).markNeedsBuild();
                    },
                  ),
                  const Text("包含小写字母"),
                ],
              ),
              Row(
                children: <Widget>[
                  Checkbox(
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    value: punctuation,
                    onChanged: (bool? value) {
                      punctuation = value;
                      password = gen();
                      (context as Element).markNeedsBuild();
                    },
                  ),
                  const Text("包含特殊符号"),
                ],
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("取消"),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: const Text("刷新"),
              onPressed: () {
                password = gen();
                (context as Element).markNeedsBuild();
              },
            ),
            TextButton(
              child: const Text("复制密码"),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: password));
                const snackBar = SnackBar(
                  content: Text('已复制到剪贴板!'),
                );

                ScaffoldMessenger.of(context).showSnackBar(snackBar);

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
      if (text0.trim().isEmpty) {
        const snackBar = SnackBar(
          content: Text('此字段不能为空!'),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);

        FocusScope.of(context).requestFocus(element.nodes[0]);
        return false;
      }
      if (text1.isEmpty) {
        const snackBar = SnackBar(
          content: Text('此字段不能为空!'),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
}
