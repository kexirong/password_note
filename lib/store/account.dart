import 'dart:convert';

import 'package:sembast/sembast.dart';

import '/model/note_data.dart';

class NoteAccountStore {
  static final _storeName = 'note_account';
  final StoreRef<String, String> _store = StoreRef<String, String>(_storeName);

  NoteAccountStore();

  Future<List<NoteAccount>> getAll(DatabaseClient dbc) async {
    var nas = <NoteAccount>[];
    var records = await _store.find(dbc);
    for (var rec in records) {
      print(rec);
      var jsonMap = jsonDecode(rec.value) as Map<String, dynamic>;

      if (jsonMap.containsKey('cipher')) {
        nas.add(EncryptAccount.fromJson(jsonMap));
      } else {
        nas.add(PlainAccount.fromJson(jsonMap));
      }
    }
    return nas;
  }

  Future<NoteAccount?> get(DatabaseClient dbc, String key) async {
    var rec = await _store.record(key).get(dbc);
    if (rec == null) return null;
    var jsonMap = jsonDecode(rec);
    return NoteAccount.fromJson(jsonMap);
  }

  Future<String?> add(DatabaseClient dbc, NoteAccount na) async {
    return _store.record(na.id).add(dbc, jsonEncode(na));
  }

  Future<String?> update(DatabaseClient dbc, NoteAccount na) async {
    return _store.record(na.id).put(dbc, jsonEncode(na));
  }

  Future<String?> delete(DatabaseClient dbc, NoteAccount na) async {
    return _store.record(na.id).delete(dbc);
  }
}
