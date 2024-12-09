import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '/provider/app_data_provider.dart';
import '/page/home.dart';
import '/store/setting.dart';
import '/db/db.dart';

import 'sync/sync_webdav.dart';

void main() async {
  runApp(const MyApp());

  var webdavConf = await SettingStore().getWebdav(await getDBC());

  if (webdavConf != null) {
    var syncWebdav = SyncWebdav();
    syncWebdav.start(webdavConf);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const title = '密码本子';
    var ndm = NoteDataModel();
    ndm.loadData();

    return ChangeNotifierProvider(
      create: (context) => ndm,
      child: MaterialApp(
        title: title,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue, primary: Colors.blue),
        ),
        home: const HomePage(title: title),
        //   navigatorKey: navigatorKey,
      ),
    );
  }
}
