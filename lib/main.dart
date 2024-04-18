import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'home.dart';
import 'hive.dart';
import 'global.dart';

void main() async {
  await hiveInit();

  runApp(const MyApp());
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
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.blue,
          ),
        ),
        home: const HomePage(title: title),
        navigatorKey: navigatorKey,
      ),
    );
  }
}
