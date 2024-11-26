import 'dart:convert';

import 'package:sembast/sembast.dart';

import '/util.dart';
import '/model/setting.dart';

class SettingStore {
  static final _storeName = 'setting';
  final _webdavField = 'webdav';
  final _deviceIDField = 'device_id';
  final _secretField = 'secret';
  final _attSecretsField = 'att_secrets';

  final StoreRef<String, String> _store = StoreRef<String, String>(_storeName);

  SettingStore();

  Future<String> getDeviceID(DatabaseClient dbc) async {
    var record = _store.record(_deviceIDField);
    var devID = await record.get(dbc);
    if (devID == null) {
      devID = uuid();
      await record.add(dbc, devID);
    }
    return devID;
  }

  //secret即主密钥
  //用于所有账号数据加密/重新加密
  //secret运行时包含于attSecrets
  Future<String?> getSecret(DatabaseClient dbc) async {
    return await _store.record(_secretField).get(dbc);
  }

  //attSecrets仅用于数据解密
  Future<List<String>> getAttSecrets(DatabaseClient dbc) async {
    var ret = <String>[];
    var secrets = await _store.record(_attSecretsField).get(dbc);
    if (secrets != null) {
      var jsonList = jsonDecode(secrets);
      for (var i in jsonList) {
        ret.add(i);
      }
    }
    return ret;
  }

  Future<String> setAttSecret(DatabaseClient dbc, String secret) async {
    return await _store.record(_attSecretsField).put(dbc, secret, ifNotExists: true);
  }

  Future<String> setSecret(DatabaseClient dbc, String secret) async {
    return await _store.record(_secretField).put(dbc, secret, ifNotExists: true);
  }

  Future<List<RecordSnapshot<String, String>>> getAll(DatabaseClient dbc) async {
    return await _store.find(dbc);
  }

  Future<WebdavConfig?> getWebdav(DatabaseClient dbc) async {
    var record = _store.record(_webdavField);
    var webdavStr = await record.get(dbc);

    if (webdavStr == null) return null;
    var jsonMap = jsonDecode(webdavStr);
    return WebdavConfig.fromJson(jsonMap);
  }

  Future<String> setWebdav(DatabaseClient dbc, WebdavConfig wc) async {
    var wcStr = jsonEncode(wc);
    return await _store.record(_webdavField).put(dbc, wcStr, ifNotExists: true);
  }

  Future<String?> get(DatabaseClient dbc, String key) async {
    return await _store.record(key).get(dbc);
  }

  Future<String?> add(DatabaseClient dbc, String key, String value) async {
    return _store.record(key).add(dbc, value);
  }
}
