import 'package:password_note/util.dart';

enum ItemType { entry, group, account }

class NoteData {
  NoteData._privateConstructor(this.groups, this.accounts, this.records);

  static NoteData? _instance;

  factory NoteData.getInstance({
    List<NoteGroup>? groups,
    List<NoteAccount>? accounts,
    Map<ID, RecordMate>? records,
  }) {
    _instance ??= NoteData._privateConstructor(groups ?? [], accounts ?? [], records ?? {});
    return _instance!;
  }

  final List<NoteGroup> groups;
  final List<NoteAccount> accounts;
  final Map<ID, RecordMate> records;

  // void addAccount(NoteAccount account, String groupID) {
  //   accounts.add(account);
  //   account.groupID = groupID;
  // }
  //
  // void addGroup(NoteGroup group) {
  //   groups.add(group);
  // }

  // List<NoteAccount> getAccounts(String groupID) {
  //   return accounts.where((element) => element.groupID == groupID).toList();
  // }

  // NoteGroup groupAt(int index) {
  //   return groups.elementAt(index);
  // }

  // NoteAccount accountAt(int index) {
  //   return accounts.elementAt(index);
  // }

  // int groupIndexById(String id) {
  //   return groups.indexWhere((el) => (el.id == id));
  // }

  // NoteGroup deleteGroup(String groupID) {
  //   int index = groupIndexById(groupID);
  //   return groups.removeAt(index);
  // }
  //
  // NoteAccount deleteAccount(String accountID) {
  //   int index = accountIndexById(accountID);
  //   return accounts.removeAt(index);
  // }
  //
  // int accountIndexById(String id) {
  //   return accounts.indexWhere((el) => (el.id == id));
  // }
}

enum RecordType { create, update, delete }

typedef ID = String;

class RecordMate {
  String id;
  RecordType type;
  int timestamp;

  RecordMate(this.type)
      : id = uuid(),
        timestamp = DateTime.now().millisecondsSinceEpoch;

  RecordMate.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        type = RecordType.values[json['type']],
        timestamp = json['timestamp'];

  Map<String, dynamic> toJson() => <String, dynamic>{'type': type.index, 'timestamp': timestamp};
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
  Map<String, String> extendField;

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
        updatedAt = json.remove('updated_at'),
        extendField = json as Map<String, String>;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {
      'id': id,
      'group_id': groupID,
      'name': name,
      'account': account,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
    json.addAll(extendField);
    return json;
  }
}
