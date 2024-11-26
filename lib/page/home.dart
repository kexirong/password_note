import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:password_note/page/account_search.dart';

import 'package:provider/provider.dart';

import 'account_list.dart';
import 'group_list.dart';
import '/model/note_data.dart';
import 'account_action.dart';

import '/provider/app_data_provider.dart';
import 'setting_password.dart';
import 'setting_sync.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.title});

  final String title;


  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print("###################build home###########################");
    }
    final appData = Provider.of<NoteDataModel>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        // title: Text(title),
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
                    return AccountAction(PlainAccount(''));
                  }),
                );

                if (result is NoteAccount) {
                  appData.addNoteAccount(result);
                }
              }
            },
          ),
          IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return const AccountSearch();
                  }),
                );
              }),
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
      drawer: const EndDrawer(),
    );
  }
}

class EndDrawer extends StatelessWidget {
  const EndDrawer({super.key});

  @override
  Widget build(BuildContext context) {


    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            padding: EdgeInsets.fromLTRB(16.0, 48.0, 16.0, 8.0),
            decoration: BoxDecoration(),
            child: Text('设置'),
          ),
          ListTile(
            leading: const Icon(Icons.password),
            title: const Text('加密'),
            onTap: () {
              // Update the state of the app

              // Then close the drawer
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return const SettingPasswordForm();
                }),
              );
            },
          ),
          //
          ListTile(
            leading: const Icon(Icons.sync),
            title: const Text('同步'),
            onTap: () {
              // Update the state of the app
              // Then close the drawer
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return const SettingSyncForm();
                }),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('关于'),
            onTap: () {

              // Then close the drawer
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
