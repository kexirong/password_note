import 'package:flutter/foundation.dart';
import 'package:sqlite3/common.dart' show CommonDatabase;
import 'package:sqlite3/wasm.dart' show IndexedDbFileSystem, WasmSqlite3;

Future<CommonDatabase> openSqliteDb(String name,
    {void Function(CommonDatabase db)? onCreate}) async {
  // Please download `sqlite3.wasm` from https://github.com/simolus3/sqlite3.dart/releases
  // into the `web/` dir of your Flutter app. See `README.md` for details.
  final sqlite = await WasmSqlite3.loadFromUrl(Uri.parse('sqlite3.wasm'));
  final fileSystem = await IndexedDbFileSystem.open(dbName: name);

  sqlite.registerVirtualFileSystem(fileSystem, makeDefault: true);
  CommonDatabase db = sqlite.open(name);

  var tables = db
      .select(
          "select count(1) as count from sqlite_master where type = 'table'")
      .first;

  if (tables['count'] == 0 && onCreate != null) {
    if (kDebugMode) {
      print('----start initializing the database-----------------------------');
      print("detected that the app is running for the first time");
      onCreate(db);
      print('----end initializing the database-------------------------------');
    }
  }

  return db;
}
