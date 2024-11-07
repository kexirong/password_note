import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_data_provider.dart';
import 'home.dart';
import 'package:hive/hive.dart';
import 'hive.dart';
import 'sync_webdav.dart';

void main() async {
  await hiveInit();

  runApp(const MyApp());
  var settingBox = Hive.box<String>(hiveSettingBox);

  var webdavUrl = settingBox.get('webdav_url', defaultValue: '')!;
  var webdavUser = settingBox.get('webdav_user', defaultValue: '')!;
  var webdavPwd = settingBox.get('webdav_pwd', defaultValue: '')!;
  var webdavPath = settingBox.get('webdav_path', defaultValue: '')!;
  if (webdavUrl.isNotEmpty && webdavUser.isNotEmpty && webdavPwd.isNotEmpty) {
    syncWebdav.init(webdavUrl, webdavUser, webdavPwd, webdavPath);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const title = '密码本子';

    var groups = hiveGetAllGroups();
    var accounts = hiveGetAllAccounts();
    var records = hiveGetRecords();

    return ChangeNotifierProvider(
      create: (context) => AppData(groups: groups, accounts: accounts, records: records),
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
