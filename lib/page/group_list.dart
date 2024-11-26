import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/provider/app_data_provider.dart';
import '/model/note_data.dart';

Future<String?> inputGroupName({String? noteGroupName, required BuildContext context}) async {
  var add = noteGroupName == null;
  return await showDialog<String?>(
      context: context,
      builder: (context) {
        TextEditingController gNameController = TextEditingController();
        gNameController.text = noteGroupName ?? "";

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
                  Navigator.of(context).pop(gNameController.text.trim());
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

class GroupListWidget extends StatelessWidget {
  const GroupListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print("###################build Group###########################");
    }
    final appData = Provider.of<NoteDataModel>(context);

    var groups = appData.noteGroups;

    return Container(
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(color: Theme.of(context).colorScheme.outlineVariant, width: 1),
        ),
      ),
      child: ListView.builder(
        itemCount: groups.length + 1,
        itemBuilder: (BuildContext context, int index) {
          if (index == groups.length) {
            return IconButton(
              padding: const EdgeInsets.all(8),
              icon: Icon(
                Icons.add,
                color: Theme.of(context).colorScheme.secondary,
              ),
              onPressed: () async {
                var groupName = await inputGroupName(context: context);
                if (groupName != null && groupName.isNotEmpty) {
                  appData.addNoteGroup(NoteGroup(groupName));
                  appData.setIndex(appData.noteGroups.length - 1);
                }
              },
            );
          } else {
            return InkWell(
              child: Container(
                margin: const EdgeInsets.only(left: 8, right: 8),
                padding: const EdgeInsets.only(top: 16, bottom: 16),
                decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(width: 1, color: Theme.of(context).colorScheme.outline)),
                ),
                child: Text(
                  groups[index].name,
                  style: TextStyle(
                    fontSize: 16,
                    color: appData.index == index ? Theme.of(context).colorScheme.primary : null,
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
                    if (!context.mounted) return;
                    var newName =
                        await inputGroupName(noteGroupName: groups[index].name, context: context);

                    if (newName != null && newName.isNotEmpty) {
                      appData.noteGroupSetName(index, newName);
                    }

                  case 2:
                    appData.setIndex(index - 1);
                    appData.noteGroupRemoveAt(index);
                }
              },
            );
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
                  Navigator.of(context).pop(1);
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 6),
                  child: Text('重命名'),
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
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
}
