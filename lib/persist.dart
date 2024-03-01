import 'package:sqlite3/common.dart'
    show CommonDatabase, SqliteException, ResultSet, Row;
import 'sqlite/sqlite3.dart' show openSqliteDb;
import 'note_data.dart';

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
    _database = await openSqliteDb(_databaseName, onCreate: onCreate);
    return _database!;
  }

  factory DatabaseHelper() {
    return _instance;
  }
  // SQL code to create the database table

  void dispose() {
    _database?.dispose();
    _database = null;
  }

  Future<ResultSet> queryRows(String table) async {
    CommonDatabase db = await database;
    return db.select('SELECT * FROM $table');
  }

  Future<void> rowInsert(String table, Map<String, dynamic> values) async {
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

List<NoteGroup> getAllGroup() {
  List<NoteGroup> groups = [];
  DatabaseHelper helper = DatabaseHelper();

  helper.queryRows('note_group').then((value) => {
        for (final Row row in value) {groups.add(NoteGroup.fromJson(row))}
      });

  return groups;
}

List<NoteGroup> insertGroup() {
  List<NoteGroup> groups = [];
  DatabaseHelper helper = DatabaseHelper();

  helper.queryRows('note_group').then((value) => {
        for (final Row row in value) {groups.add(NoteGroup.fromJson(row))}
      });

  return groups;
}

List<NoteAccount> getAllAccount() {
  List<NoteAccount> accounts = [];
  DatabaseHelper helper = DatabaseHelper();

  helper.queryRows('note_account').then((value) => {
        for (final Row row in value) {accounts.add(NoteAccount.fromJson(row))}
      });

  return accounts;
}

void onCreate(CommonDatabase db) {
  db.execute('''
          CREATE TABLE IF NOT EXISTS record_mate (
            id TEXT PRIMARY KEY,
            type INTEGER NOT NULL,
            timestamp INTEGER NOT NULL
          );
          CREATE TABLE IF NOT EXISTS note_group (
            id TEXT PRIMARY KEY,
            name TEXT NOT NULL,
            created_At INTEGER NOT NULL,
            updatedAt INTEGER NOT NULL
          );
          CREATE TABLE IF NOT EXISTS note_account (
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
}
