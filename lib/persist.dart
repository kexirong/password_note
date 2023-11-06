import 'package:sqlite3/common.dart' show CommonDatabase;
import 'sqlite/sqlite3.dart' show openSqliteDb;


class DatabaseHelper {
  static const _databaseName = "note.db";
  static const table = 'cars_table';

  static const columnId = 'id';
  static const columnName = 'name';
  static const columnMiles = 'miles';

  // make this a singleton class
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // only have a single app-wide reference to the database
  CommonDatabase? _database;

  Future<CommonDatabase> get database async {
    if (_database != null) return _database!;
    // lazily instantiate the db the first time it is accessed
    _database = await openSqliteDb(_databaseName, onCreate: _onCreate);
    return _database!;
  }

  // SQL code to create the database table
  void _onCreate(CommonDatabase db) {
    db.select('');
    db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
            $columnName TEXT NOT NULL,
            $columnMiles INTEGER NOT NULL
          )
          ''');
  }

//   // Helper methods
//
//   // Inserts a row in the database where each key in the Map is a column name
//   // and the value is the column value. The return value is the id of the
//   // inserted row.
//   Future<int> insert(Car car) async {
//     Database db = await instance.database;
//     return await db.insert(table, {'name': car.name, 'miles': car.miles});
//   }
//
//   // All of the rows are returned as a list of maps, where each map is
//   // a key-value list of columns.
//   Future<List<Map<String, dynamic>>> queryAllRows() async {
//     Database db = await instance.database;
//     return await db.query(table);
//   }
//
//   // Queries rows based on the argument received
//   Future<List<Map<String, dynamic>>> queryRows(name) async {
//     Database db = await instance.database;
//     return await db.query(table, where: "$columnName LIKE '%$name%'");
//   }
//
//   // All of the methods (insert, query, update, delete) can also be done using
//   // raw SQL commands. This method uses a raw query to give the row count.
//   Future<int> queryRowCount() async {
//     Database db = await instance.database;
//     return Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $table'));
//   }
//
//   // We are assuming here that the id column in the map is set. The other
//   // column values will be used to update the row.
//   Future<int> update(Car car) async {
//     Database db = await instance.database;
//     int id = car.toMap()['id'];
//     return await db.update(table, car.toMap(), where: '$columnId = ?', whereArgs: [id]);
//   }
//
//   // Deletes the row specified by the id. The number of affected rows is
//   // returned. This should be 1 as long as the row exists.
//   Future<int> delete(int id) async {
//     Database db = await instance.database;
//     return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
//   }
}
