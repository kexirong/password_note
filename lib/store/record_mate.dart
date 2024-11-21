import 'dart:convert';

import 'package:sembast/sembast.dart';

import '/model/note_data.dart';

class RecordMateStore {
  static final _storeName = 'record_mate';
  final StoreRef<String, String> _store = StoreRef<String, String>(_storeName);

  RecordMateStore();

  Future<List<RecordMate>> getAll(DatabaseClient dbc) async {
    var rms = <RecordMate>[];
    var records = await _store.find(dbc);
    for (var rec in records) {
      var jsonMap = jsonDecode(rec.value);
      rms.add(RecordMate.fromJson(jsonMap));
    }
    return rms;
  }

  Future<RecordMate?> get(DatabaseClient dbc, String key) async {
    var rec = await _store.record(key).get(dbc);
    if (rec == null) return null;
    var jsonMap = jsonDecode(rec);
    return RecordMate.fromJson(jsonMap);
  }

  Future<String?> add(DatabaseClient dbc, RecordMate rm) async {
    return _store.record(rm.id).add(dbc, jsonEncode(rm));
  }
}
