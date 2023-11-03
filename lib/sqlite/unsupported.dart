import 'package:sqlite3/common.dart' show CommonDatabase;

Future<CommonDatabase> openSqliteDb(String name) async {
  throw UnsupportedError('Sqlite3 is unsupported on this platform.');
}
