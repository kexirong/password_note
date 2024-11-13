import 'package:password_note/util.dart';

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
}

class NoteGroup {
  String id, name;
  int createdAt, updatedAt = 0;

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
}

class NoteAccount {
  String id, name;
  String? groupID, account, password;
  int createdAt, updatedAt = 0;
  Map<String, String> extendField = {};

  NoteAccount(this.name)
      : id = uuid(),
        createdAt = DateTime.now().millisecondsSinceEpoch,
        extendField = <String, String>{};

  int get length {
    return extendField.length + 2;
  }

  NoteAccount.fromJson(Map<String, dynamic> json)
      : id = json.remove('id'),
        groupID = json.remove('group_id'),
        name = json.remove('name'),
        account = json.remove('account'),
        password = json.remove('password'),
        createdAt = json.remove('created_at'),
        updatedAt = json.remove('updated_at') {
    json.forEach((key, value) => extendField[key] = value!.toString());
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {
      'id': id,
      'group_id': groupID,
      'name': name,
      'account': account,
      'password': password,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
    json.addAll(extendField);
    return json;
  }
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

