import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart'
    show getApplicationDocumentsDirectory;
import 'package:sqlite3/common.dart' show CommonDatabase;
import 'package:sqlite3/sqlite3.dart' show sqlite3;

Future<CommonDatabase> openSqliteDb(String name,
    {void Function(CommonDatabase db)? onCreate}) async {
  final docsDir = await getApplicationDocumentsDirectory();
  final filename = path.join(docsDir.path, name);
  var created = await File(filename).exists();
  CommonDatabase db = sqlite3.open(filename);

  if (!created && onCreate != null) {
    if (kDebugMode) {
      if (kDebugMode) {
        print('----start initializing the database---------------------------');
        print("detected that the app is running for the first time");
        onCreate(db);
        print('----end initializing the database-----------------------------');
      }
    }
  }
  return db;
}
