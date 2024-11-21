import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:sembast_sqflite/sembast_sqflite.dart';
import 'package:sembast_web/sembast_web.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart' as sqflite_ffi;

import 'package:sqflite/sqflite.dart' as sqflite;


/// Sembast sqflite ffi based database factory.
/// Supports Windows/Linux/MacOS for now.
sqflite_ffi.DatabaseFactory get _defaultDatabaseFactory => (Platform.isLinux || Platform.isWindows)
    ? sqflite_ffi.databaseFactoryFfi
    : sqflite.databaseFactory;

DatabaseFactory get databaseFactory =>
    (kIsWeb) ? databaseFactoryWeb : getDatabaseFactorySqflite(_defaultDatabaseFactory);
