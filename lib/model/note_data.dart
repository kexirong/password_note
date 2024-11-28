import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart';

import '/util.dart';

enum RecordType { create, update, delete }

enum ItemType { group, account }

typedef ID = String;

class RecordMate {
  String id;
  ItemType itemType;
  RecordType recordType;
  int timestamp;

  RecordMate(this.id, this.itemType, this.recordType)
      : timestamp = DateTime.now().millisecondsSinceEpoch;

  RecordMate.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        recordType = RecordType.values[json['record_type']],
        itemType = ItemType.values[json['item_type']],
        timestamp = json['timestamp'];

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'record_type': recordType.index,
        'item_type': itemType.index,
        'timestamp': timestamp
      };

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}

class NoteGroup {
  String id, name;
  int createdAt;
  int updatedAt = 0;

  NoteGroup(this.name)
      : id = uuid(),
        createdAt = DateTime.now().millisecondsSinceEpoch;

  NoteGroup.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        createdAt = json['created_at'],
        updatedAt = json['updated_at'];

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'name': name,
        'created_at': createdAt,
        'updated_at': updatedAt,
      };

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}

class NoteAccount {
  String id;
  String name;
  String? groupID;
  int createdAt;
  int updatedAt = 0;

  NoteAccount(this.name, {String? id, int? createdAt})
      : id = id ?? uuid(),
        createdAt = createdAt ?? DateTime.now().millisecondsSinceEpoch;

  NoteAccount.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        groupID = json['group_id'],
        createdAt = json['created_at'],
        updatedAt = json['updated_at'];

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'name': name,
        'group_id': groupID,
        'created_at': createdAt,
        'updated_at': updatedAt,
      };

  factory NoteAccount.copy(NoteAccount acct) {
    if (acct is PlainAccount) {
      return PlainAccount.fromJson(acct.toJson());
    }
    if (acct is EncryptAccount) {
      return EncryptAccount.fromJson(acct.toJson());
    }
    return NoteAccount.fromJson(acct.toJson());
  }
}

class PlainAccount extends NoteAccount {
  String? account, password;

  Map<String, String> extendField = {};

  PlainAccount(super.name);

  PlainAccount.fromJson(Map<String, dynamic> json)
      : account = json['account'],
        password = json['password'],
        super.fromJson(json) {
    json['extend_field'].forEach((key, value) {
      if (value is String) {
        extendField[key] = value;
      }
    });
  }

  Map<String, dynamic> _toJson() =>
      <String, dynamic>{'account': account, 'password': password, 'extend_field': extendField};

  @override
  Map<String, dynamic> toJson() {
    var json = super.toJson();
    json.addAll(_toJson());
    return json;
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }

  EncryptAccount encrypt(String password) {
    var iv = IV.fromLength(16);
    final encrypter = Encrypter(AES(keyFromPassword(password), mode: AESMode.cbc));
    final encrypted = encrypter.encrypt(
      jsonEncode(_toJson()),
      iv: iv,
    );
    var eAccount = EncryptAccount(
      name,
      iv.base64,
      md5.convert(utf8.encode(password)).toString(),
      encrypted.base64,
      DateTime.now().millisecondsSinceEpoch,
      id: id,
      createdAt: createdAt,
    );
    eAccount.groupID = groupID;
    eAccount.updatedAt = eAccount.encryptedAt;
    return eAccount;
  }

  void assign(PlainAccount acct) {
    id = acct.id;
    name = acct.name;
    groupID = acct.groupID;
    createdAt = acct.createdAt;
    updatedAt = acct.updatedAt;
    account = acct.account;
    password = acct.password;
    extendField = acct.extendField;
  }
}

class EncryptAccount extends NoteAccount {
  String cipher = 'AES';
  AESMode mode = AESMode.cbc;
  String iv;
  String mKey;
  int encryptedAt;
  String data;

  EncryptAccount(super.name, this.iv, this.mKey, this.data, this.encryptedAt,
      {super.id, super.createdAt});

  EncryptAccount.fromJson(super.json)
      : cipher = json['cipher'],
        mode = AESMode.values.firstWhere((el) => el.name == json['mode']),
        iv = json['iv'],
        mKey = json['m_key'],
        encryptedAt = json['encrypted_at'],
        data = json['data'],
        super.fromJson();

  Map<String, dynamic> _toJson() => <String, dynamic>{
        'cipher': cipher,
        'mode': mode.name,
        'iv': iv,
        'encrypted_at': encryptedAt,
        'm_key': mKey,
        'data': data
      };

  @override
  Map<String, dynamic> toJson() {
    var json = super.toJson();
    json.addAll(_toJson());
    return json;
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }

  PlainAccount decrypt(
    String pwd,
  ) {
    var key = keyFromPassword(pwd);

    var encrypter = Encrypter(AES(key, mode: mode));
    var decrypted = encrypter.decrypt64(
      data,
      iv: IV.fromBase64(iv),
    );
    var json = super.toJson();
    json.addAll(jsonDecode(decrypted));
    return PlainAccount.fromJson(json);
  }

  void assign(EncryptAccount acct) {
    id = acct.id;
    name = acct.name;
    groupID = acct.groupID;
    createdAt = acct.createdAt;
    updatedAt = acct.updatedAt;
    cipher = acct.cipher;
    mode = acct.mode;
    iv = acct.iv;
    mKey = acct.mKey;
    encryptedAt = acct.encryptedAt;
    data = acct.data;
  }
}

Key keyFromPassword(String password) {
  var pwdB = utf8.encode(password);
  var pwdSha = md5.convert(pwdB);
  pwdSha = md5.convert(pwdSha.bytes + pwdB);
  return Key(Uint8List.fromList(pwdSha.bytes));
}

Map<ID, RecordMate> zipRecords(List<RecordMate> records) {
  Map<ID, RecordMate> recs = {};
  for (var rec in records) {
    var item = recs[rec.id];
    if (item == null) {
      recs[rec.id] = rec;
      continue;
    }

    if (item.recordType.index > rec.recordType.index) {
      continue;
    }

    recs[rec.id] = rec;
  }
  return recs;
}

List<RecordMate> diffRecords(Map<ID, RecordMate> records1, Map<ID, RecordMate> records2) {
  List<RecordMate> recs = [];
  for (var key in records2.keys) {
    var item = records1[key];
    if (item == null) {
      recs.add(records2[key]!);
      continue;
    }
    if (item.timestamp > records2[key]!.timestamp ||
        item.recordType.index > records2[key]!.recordType.index) {
      continue;
    }
    recs.add(records2[key]!);
  }
  return recs;
}
