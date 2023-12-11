import 'package:sqlite3/common.dart'
    show CommonDatabase, SqliteException, ResultSet, Row;
import 'sqlite/sqlite3.dart' show openSqliteDb;

class DatabaseHelper {
  static const _databaseName = "note.db";
  // make this a singleton class
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper _instance = DatabaseHelper._privateConstructor();

  // only have a single app-wide reference to the database
  CommonDatabase? _database;

  Future<CommonDatabase> get database async {
    if (_database != null) return _database!;
    // lazily instantiate the db the first time it is accessed
    _database = await openSqliteDb(_databaseName, onCreate: _onCreate);
    return _database!;
  }

  factory DatabaseHelper() {
    return _instance;
  }
  // SQL code to create the database table
  void _onCreate(CommonDatabase db) {
    try {
      db.execute('select 1 from note_group');
    } on SqliteException {
      db.execute('''
          CREATE TABLE note_group (
            id TEXT PRIMARY KEY,
            name TEXT NOT NULL,
            created_At INTEGER NOT NULL,
            updatedAt INTEGER NOT NULL
          );
          CREATE TABLE note_account (
            id TEXT PRIMARY KEY,
            group_id TEXT NOT NULL,
            name TEXT NOT NULL,
            account TEXT NOT NULL,
            password TEXT NOT NULL,
            extendField TEXT NOT NULL,
            created_At INTEGER NOT NULL,
            updatedAt INTEGER NOT NULL
          );
          ''');
    } finally {
      //  db.dispose();
    }
  }

  void dispose() {
    _database?.dispose();
    _database = null;
  }

  Future<ResultSet> queryRows(String table) async {
    CommonDatabase db = await database;
    return db.select('SELECT * FROM $table');
  }

  Future<void> insertRow(String table, Map<String, dynamic> values) async {
    CommonDatabase db = await database;

    final insert = StringBuffer();
    insert.write('INSERT INTO ');
    insert.write(table);
    insert.write(' (');
    var i = 0;
    List<Object?> parameters = <Object?>[];
    final sbValues = StringBuffer(') VALUES (');
    values.forEach((String colName, Object? value) {
      if (i++ > 0) {
        insert.write(', ');
        sbValues.write(', ');
      }
      insert.write(colName);
      sbValues.write('?');
      parameters.add(value);
    });
    insert.write(sbValues);
    return db.execute(insert.toString(), parameters);
  }

  Future<void> rowUpdate(String table, Map<String, dynamic> values) async {
    CommonDatabase db = await database;
    var id = values.remove('id');
    final update = StringBuffer();
    // UPDATE COMPANY SET ADDRESS = 'Texas' WHERE ID = 6;
    update.write('UPDATE ');
    update.write(table);
    update.write(' SET ');
    var i = 0;
    List<Object?> parameters = <Object?>[];
    values.forEach((String colName, Object? value) {
      if (i++ > 0) {
        update.write(', ');
      }
      update.write(colName);
      update.write(' = ?');
      parameters.add(value);
    });
    update.write(' WHERE id = ?');
    parameters.add(id);
    return db.execute(update.toString(), parameters);
  }

  Future<void> rowDelete(String table, Object id) async {
    CommonDatabase db = await database;
    final delete = StringBuffer();
    delete.write('DELETE FROM ');
    delete.write(table);
    delete.write(' WHERE id = ?');

    return db.execute(delete.toString(), [id]);
  }
}
