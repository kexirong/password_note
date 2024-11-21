import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:sembast/sembast.dart';
import 'dart:io' show Directory;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'factory.dart';
import '/info.dart';

Database? _db;
String _dbName = 'note.db';

// Future<Database> get db async => _db ??= await databaseFactory.openDatabase(_dbName);

Future<Database> getDBC() async {
  var path = await _buildDatabasesPath();
  return _db ??= await databaseFactory.openDatabase(
    path,
    //codec: SembastCodec(signature: 'serialization', codec: AsyncJsonCodec()),
  );
}

Future closeDB() async {
  await _db!.close();
  _db = null;
}

Future<String> _buildDatabasesPath() async {
  if (kIsWeb) {
    return _dbName;
  }

  var docDir = await getApplicationDocumentsDirectory();
  var dbPath = join(docDir.path, packageName);
  var dir = Directory(dbPath);
  await dir.create(recursive: true);
  // try {
  //
  //   if (!await dir.exists()) {
  //     await dir.create(recursive: true);
  //   }
  // } catch (_) {}

  return join(dbPath, _dbName);
}

class AsyncJsonCodec extends AsyncContentCodecBase {
  // String _reverseString(String text) => text.split('').reversed.join();

  @override
  Future<Object?> decodeAsync(String encoded) async {
    return jsonDecode(encoded);
  }

  @override
  Future<String> encodeAsync(Object? input) async {
    return jsonEncode(input);
  }
}
