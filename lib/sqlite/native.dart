import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart'
    show getApplicationDocumentsDirectory;
import 'package:sqlite3/common.dart' show CommonDatabase;
import 'package:sqlite3/sqlite3.dart' show sqlite3;

Future<CommonDatabase> openSqliteDb(String name,
    {void Function(CommonDatabase db)? onCreate}) async {
  final docsDir = await getApplicationDocumentsDirectory();
  final filename = path.join(docsDir.path, name);
  CommonDatabase db =  sqlite3.open(filename);
  if (onCreate != null) {
    onCreate(db);
  }
  return db;
}
