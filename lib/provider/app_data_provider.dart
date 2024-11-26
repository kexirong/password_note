import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';

import '/model/setting.dart';
import '/model/note_data.dart';
import '/db/db.dart';
import '/store/account.dart';
import '/store/group.dart';
import '/store/record_mate.dart';
import '/store/setting.dart';

class NoteDataModel extends ChangeNotifier {
  final List<NoteGroup> _groups;
  final List<NoteAccount> _accounts;
  final List<RecordMate> _records;
  final Map<String, String> _attSecrets;
  String? _secret;
  WebdavConfig? _webdavConf;

  // late Database _db;

  NoteDataModel(
      {List<NoteGroup>? groups,
      List<NoteAccount>? accounts,
      List<RecordMate>? records,
      Map<String, String>? secrets})
      : _groups = groups ?? [],
        _accounts = accounts ?? [],
        _records = records ?? [],
        _attSecrets = secrets ?? {};

  Future<void> loadData() async {
    var db = await getDBC();
    _accounts.addAll(await NoteAccountStore().getAll(db));
    _groups.addAll(await NoteGroupStore().getAll(db));
    _records.addAll(await RecordMateStore().getAll(db));
    _secret = await SettingStore().getSecret(db);
    _webdavConf = await SettingStore().getWebdav(db);
    if (_secret != null) {
      _addAttSecret(_secret!);
    }

    var secrets = await SettingStore().getAttSecrets(db);
    for (var secret in secrets) {
      _addAttSecret(secret);
    }
    notifyListeners();
  }

  int _index = 0;

  int get index => _index;

  String? get secret => _secret;

  WebdavConfig? get webdavConf => _webdavConf;

  List<NoteGroup> get noteGroups => _groups;

  String? get _currentGroupID {
    return _groups.isNotEmpty ? _groups[_index].id : null;
  }

  List<RecordMate> get noteRecords => _records;

  List<NoteAccount> get noteAccounts => getNoteAccountsByGroupID(_currentGroupID);

  List<NoteAccount> get allNoteAccounts => _accounts;

  List<NoteAccount> getNoteAccountsByGroupID(String? groupID) {
    return _accounts.where((element) => element.groupID == groupID).toList();
  }

  //解密密钥从getAttSecret方法获取
  String? getAttSecret(String mKey) {
    return _attSecrets[mKey];
  }

  //添加了密钥会重新保存到数据库
  void addAttSecret(String secret) {
    _addAttSecret(secret);
    // 未完成
  }

  void _addAttSecret(String secret) {
    var mKey = md5.convert(utf8.encode(secret)).toString();
    _attSecrets[mKey] = secret;
  }

  Future<void> setSecret(String secret) async {
    var db = await getDBC();
    db.transaction((txn) async {
      await SettingStore().setSecret(await getDBC(), secret);
      for (var acct in _accounts) {
        if (acct is EncryptAccount) {
          //已加密数据不处理
          //使用当前主密钥加密的数据需要重新加密
          continue;
        }
        //PlainAccount需做加密处理
        acct = (acct as PlainAccount).encrypt(secret);
        acct.encryptedAt = DateTime.now().millisecondsSinceEpoch;
        var rm = RecordMate(acct.id, ItemType.account, RecordType.update);
        await NoteAccountStore().update(txn, acct);
        await RecordMateStore().add(txn, rm);
      }
      _secret = secret;
    });

    notifyListeners();
  }

  Future<void> setWebdavConfig(WebdavConfig conf) async {
    await SettingStore().setWebdav(await getDBC(), conf);
    _webdavConf = conf;
  }

  Future<void> noteGroupSetName(int index, String newName) async {
    var g = _groups[index];
    g.name = newName;
    g.updatedAt = DateTime.now().millisecondsSinceEpoch;
    var rm = RecordMate(g.id, ItemType.group, RecordType.update);
    var db = await getDBC();
    await db.transaction((txn) async {
      await NoteGroupStore().update(txn, g);
      await RecordMateStore().add(txn, rm);
    });
    notifyListeners();
  }

  Future<void> addNoteGroup(NoteGroup group) async {
    var rm = RecordMate(group.id, ItemType.group, RecordType.create);
    var db = await getDBC();
    await db.transaction((txn) async {
      await NoteGroupStore().add(txn, group);
      await RecordMateStore().add(txn, rm);
      _groups.add(group);
    });
    notifyListeners();
  }

  Future<void> addNoteAccount(NoteAccount account) async {
    if (_secret != null && _secret!.isNotEmpty && account is PlainAccount) {
      account = account.encrypt(_secret!);
    }
    account.groupID = _currentGroupID;

    var rm = RecordMate(account.id, ItemType.account, RecordType.create);
    var db = await getDBC();
    await db.transaction((txn) async {
      await NoteAccountStore().add(txn, account);
      await RecordMateStore().add(txn, rm);
      _accounts.add(account);
    });
    notifyListeners();
  }

  Future<void> updateNoteAccount(NoteAccount account) async {
    int index = _accounts.indexWhere((el) => (el.id == account.id));
    account.updatedAt = DateTime.now().millisecondsSinceEpoch;
    if (_secret != null && _secret!.isNotEmpty && account is PlainAccount) {
      account = account.encrypt(_secret!);
    }

    var rm = RecordMate(account.id, ItemType.account, RecordType.update);
    var db = await getDBC();
    await db.transaction((txn) async {
      await NoteAccountStore().update(txn, account);
      await RecordMateStore().add(txn, rm);
    });
    _accounts[index] = account;
    notifyListeners();
  }

  Future<void> noteGroupRemoveAt(int index) async {
    var rm = RecordMate(_groups[index].id, ItemType.group, RecordType.delete);
    var db = await getDBC();
    await db.transaction((txn) async {
      await NoteGroupStore().delete(txn, _groups[index]);
      await RecordMateStore().add(txn, rm);
      _groups.removeAt(index);
    });
    notifyListeners();
  }

  Future<void> noteAccountRemoveByID(String accountID) async {
    int index = _accounts.indexWhere((el) => (el.id == accountID));

    if (index < 0) return;
    var rm = RecordMate(_accounts[index].id, ItemType.account, RecordType.delete);
    var db = await getDBC();
    await db.transaction((txn) async {
      await NoteAccountStore().delete(txn, _accounts[index]);
      await RecordMateStore().add(txn, rm);
      _accounts.removeAt(index);
    });
    notifyListeners();
  }

  void setIndex(int index) {
    if (index >= 0 && index < _groups.length) {
      _index = index;
      notifyListeners();
    }
  }
}
