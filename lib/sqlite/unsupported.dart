import 'package:sqlite3/common.dart' show CommonDatabase;

Future<CommonDatabase> openSqliteDb(String name, {void  Function (CommonDatabase db)? onCreate}) async {
  throw UnsupportedError('Sqlite3 is unsupported on this platform.');
}
