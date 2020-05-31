import 'package:password_note/util.dart';

enum ItemType { entry, group, account }

class NoteData {
  NoteDataEntry _dataEntry;

  factory NoteData({NoteDataEntry dataEntry}) =>
      _getInstance(dataEntry: dataEntry);
  static NoteData _instance;

  NoteData._internal({NoteDataEntry dataEntry}) {
    // 初始化
    if (dataEntry == null) {
      this._dataEntry = NoteDataEntry();
    } else {
      this._dataEntry = dataEntry;
    }
  }

  static NoteData _getInstance({NoteDataEntry dataEntry}) {
    if (_instance == null || dataEntry != null) {
      _instance = NoteData._internal(dataEntry: dataEntry);
    }
    return _instance;
  }

  int get length {
    return _dataEntry.length;
  }

  String get id {
    return _dataEntry.id;
  }

  NoteGroup getGroupAt(int index) {
    return index >= 0 && length > index ? _dataEntry.groups[index] : null;
  }

  List<NoteAccount> getAccountsAt(int index) {
    return index > 0 && length > index
        ? _dataEntry.groups[index].accounts
        : null;
  }

  void addGroup(NoteGroup group) {
    if (group != null) {
      _dataEntry.groups.add(group);
    }
  }

  NoteGroup getGroup(String id) {
    return _dataEntry.groups
        .firstWhere((el) => (el?.id == id), orElse: () => null);
  }
}

class NoteDataEntry {
  String id;
  int createdAt;
  int updatedAt;
  List<NoteGroup> groups;

  int get length {
    return groups.length;
  }

  NoteDataEntry()
      : this.id = uuid(),
        this.createdAt = DateTime.now().millisecondsSinceEpoch,
        this.groups = <NoteGroup>[];

  NoteDataEntry.fromJson(Map<String, dynamic> json)
      : createdAt = json['created_at'],
        updatedAt = json['updated_at'];

  Map<String, dynamic> toJson() => <String, dynamic>{
        'created_at': createdAt,
        'updated_at': updatedAt,
      };
}

class NoteGroup {
  String id, name;
  int createdAt, updatedAt;
  List<NoteAccount> accounts;

  NoteGroup({this.name})
      : this.id = uuid(),
        this.createdAt = DateTime.now().millisecondsSinceEpoch,
        this.accounts = <NoteAccount>[];

  int get length {
    return accounts.length;
  }

  void addAccount(NoteAccount account) {
    if (account != null) {
      accounts.add(account);
    }
  }

  NoteAccount getAccount(String id) {
    return accounts.firstWhere((el) => (el?.id == id), orElse: () => null);
  }

  NoteAccount getAccountAt(int index) {
    return index > 0 && length > index ? accounts[index] : null;
  }

  NoteGroup.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        createdAt = json['created_at'],
        updatedAt = json['updated_at'];

  Map<String, dynamic> toJson() => <String, dynamic>{
        'name': name,
        'created_at': createdAt,
        'updated_at': updatedAt,
      };
}

class NoteAccount {
  String id, name, account, password;
  int createdAt, updatedAt;
  Map<String, String> extendField;

  NoteAccount({this.name})
      : this.id = uuid(),
        this.createdAt = DateTime.now().millisecondsSinceEpoch,
        this.extendField = <String, String>{};

  int get length {
    return extendField.length + 2;
  }

  NoteAccount.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        account = json['account'],
        password = json['password'],
        createdAt = json['created_at'],
        updatedAt = json['updated_at'],
        extendField = <String, String>{} {
    json.removeWhere((key, value) => [
          'name',
          'account',
          'password',
          'created_at',
          'updated_at'
        ].contains(key));
    extendField.addAll(json);
  }

  Map<String, dynamic> toJson() {
    Map json = <String, dynamic>{
      'name': name,
      'account': account,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
    json.addAll(extendField);
    return json;
  }
}
