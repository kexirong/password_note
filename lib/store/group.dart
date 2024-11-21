import 'dart:convert';

import 'package:sembast/sembast.dart';

import '/model/note_data.dart';

class NoteGroupStore {
  static final _storeName = 'note_group';
  final StoreRef<String, String> _store = StoreRef<String, String>(_storeName);

  NoteGroupStore();

  Future<List<NoteGroup>> getAll(DatabaseClient dbc) async {
    var ngs = <NoteGroup>[];
    var records = await _store.find(dbc);
    for (var rec in records) {
      var jsonMap = jsonDecode(rec.value);
      ngs.add(NoteGroup.fromJson(jsonMap));
    }
    return ngs;
  }

  Future<NoteGroup?> get(DatabaseClient dbc, String key) async {
    var rec = await _store.record(key).get(dbc);
    if (rec == null) return null;
    var jsonMap = jsonDecode(rec);
    return NoteGroup.fromJson(jsonMap);
  }

  Future<String?> add(DatabaseClient dbc, NoteGroup ng) async {
    return _store.record(ng.id).add(dbc, jsonEncode(ng));
  }

  Future<String?> update(DatabaseClient dbc, NoteGroup ng) async {
    return _store.record(ng.id).put(dbc, jsonEncode(ng));
  }

  Future<String?> delete(DatabaseClient dbc, NoteGroup ng) async {
    return _store.record(ng.id).delete(dbc);
  }
}
