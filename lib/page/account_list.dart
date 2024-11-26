import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:password_note/util.dart';
import 'package:provider/provider.dart';

import 'account_action.dart';
import '/provider/app_data_provider.dart';
import '/model/note_data.dart';

class AccountListWidget extends StatelessWidget {
  const AccountListWidget({super.key, String? filter}) : _filter = filter;
  final String? _filter;

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print("###################build Account###########################");
    }
    final appData = Provider.of<NoteDataModel>(context);

    List<NoteAccount> accounts;
    if (_filter == null) {
      accounts = appData.noteAccounts;
    } else if (_filter.isNotEmpty) {
      accounts =
          appData.allNoteAccounts.where((element) => element.name.contains(_filter)).toList();
    } else {
      accounts = appData.allNoteAccounts;
    }

    return ListView.builder(
      itemCount: accounts.length,
      itemBuilder: (BuildContext context, int index) {
        var account = NoteAccount.copy(accounts[index]);
        if (account is EncryptAccount) {
          var secret = appData.getAttSecret(account.mKey);
          if (secret != null) {
            account = account.decrypt(secret);
          }
        }
        return InkWell(
            onTap: () async {
              if (account is EncryptAccount) {
                const snackBar = SnackBar(
                  content: Text('已加密，请设置密码'),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                return;
              }
              var result = await showAccountDetail(account as PlainAccount, context);
              if (result is NoteAccount) {
                appData.updateNoteAccount(result);
              }
            },
            child: Container(
              clipBehavior: Clip.hardEdge,
              decoration: const BoxDecoration(),
              child: Slidable(
                // The end action pane is the one at the right or the bottom side.
                endActionPane: ActionPane(
                  motion: const ScrollMotion(),
                  children: [
                    SlidableAction(
                      onPressed: (_) async {
                        if (account is EncryptAccount) {
                          const snackBar = SnackBar(
                            content: Text('已加密，请设置密码'),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          return;
                        }
                        var result = await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) {
                            return AccountAction(account as PlainAccount);
                          }),
                        );

                        if (result is NoteAccount) {
                          appData.updateNoteAccount(result);
                        }
                      },
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Theme.of(context).colorScheme.surface,
                      icon: Icons.edit,
                      label: '编辑',
                    ),
                    SlidableAction(
                      onPressed: (_) {
                        appData.noteAccountRemoveByID(account.id);
                      },
                      backgroundColor: Theme.of(context).colorScheme.error,
                      foregroundColor: Theme.of(context).colorScheme.surface,
                      icon: Icons.delete,
                      label: '删除',
                    ),
                  ],
                ),

                child: Container(
                  margin: const EdgeInsets.only(left: 8, right: 8),
                  padding: const EdgeInsets.only(top: 16, bottom: 16),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        width: 1,
                        color: Theme.of(context).colorScheme.outline,
                      ),
                    ),
                  ),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Text(account.name,
                            textAlign: TextAlign.left, overflow: TextOverflow.ellipsis),
                      ),
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(getAccount(account),
                              textAlign: TextAlign.left, overflow: TextOverflow.ellipsis),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ));
      },
    );
  }

  Future<NoteAccount?> showAccountDetail(PlainAccount account, BuildContext context) async {
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
                  // splashColor: Theme.of(context).colorScheme.outline,
                  // highlightColor: Theme.of(context).colorScheme.outline,
                  padding: const EdgeInsets.all(0),
                  icon: Icon(
                    Icons.content_copy,
                    size: 20,
                    color: Theme.of(context).colorScheme.secondary,
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
