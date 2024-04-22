import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'account_list.dart';
import 'group_list.dart';
import 'note_data.dart';
import 'account_action.dart';

import 'app_data_provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print("%%%%%%%%%%%%%%%%%%%%%%%%%%HomePageState rebuild%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%");
    }
    final appData = Provider.of<AppData>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(title),
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.add),
              onPressed: () async {
                if (appData.noteGroups.isEmpty) {
                  const snackBar = SnackBar(
                    content: Text('无分组，先创建分组'),
                  );

                  ScaffoldMessenger.of(context).showSnackBar(snackBar);

                  var groupName = await inputGroupName(context: context);
                  if (groupName != null && groupName.isNotEmpty) {
                    appData.addNoteGroup(NoteGroup(groupName));
                    appData.setIndex(appData.noteGroups.length - 1);
                  }
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
      body: const Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: GroupListWidget(),
          ),
          Expanded(
            flex: 3,
            child: AccountListWidget(),
          ),
        ],
      ),
    );
  }
}
