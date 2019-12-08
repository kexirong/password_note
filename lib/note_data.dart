enum ItemType { entry, group, account }
class NoteData {
  NoteDataEntry _dataEntry;

//  {
//    '分组一': [
//      {'name': 'aaa1111111111', 'account': '12321', 'pass': '123312'},
//      {'name': 'bbb1', 'account': '12321', 'pass': '123312'},
//      {'name': 'ccc1', 'account': '12321', 'pass': '123312'}
//    ],
//    '分组二': [
//      {'name': 'aaa2', 'account': '12321', 'pass': '123312'},
//      {'name': 'bbb2', 'account': '12321', 'pass': '123312'},
//      {'name': 'ccc2', 'account': '12321', 'pass': '123312'}
//    ],
//    '分组三': [
//      {'name': 'aaa3', 'account': '12321', 'pass': '123312'},
//      {'name': 'bbb3', 'account': '12321', 'pass': '123312'},
//      {'name': 'ccc3', 'account': '12321', 'pass': '123312'}
//    ],
//    '分组四': [
//      {'name': 'aaa4', 'account': '12321', 'pass': '123312'},
//      {'name': 'bbb4', 'account': '12321', 'pass': '123312'},
//      {'name': 'ccc4', 'account': '12321', 'pass': '123312'}
//    ]
//  };

  factory NoteData() => _getInstance();
  static NoteData _instance;


  NoteData._internal() {
    // 初始化
  }

  static NoteData _getInstance() {
    if (_instance == null) {
      _instance = new NoteData._internal();
    }
    return _instance;
  }

  int get length {
    return _dataEntry.groups.length;
  }

  NoteGroup getGroupAt(int index) {
    return index > 0 && length > index ? _dataEntry.groups[index] : null;
  }

  List<NoteAccount> getAccountsAt(int index) {
    return index > 0 && length > index
        ? _dataEntry.groups[index].accounts
        : null;
  }

  void addGroup(String name) {}
}

class NoteDataEntry {
  int createdAt;
  int updatedAt;
  List<NoteGroup> groups;

  NoteDataEntry() : this.createdAt = DateTime.now().millisecondsSinceEpoch;

  NoteDataEntry.fromJson(Map<String, dynamic> json)
      : createdAt = json['created_at'],
        updatedAt = json['updated_at'];

  Map<String, dynamic> toJson() => <String, dynamic>{
        'created_at': createdAt,
        'updated_at': updatedAt,
      };
}

class NoteGroup {
  String name;
  int createdAt;
  int updatedAt;
  List<NoteAccount> accounts;

  NoteGroup(this.name) : this.createdAt = DateTime.now().millisecondsSinceEpoch;

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
  String name;
  String account;
  int createdAt;
  int updatedAt;
  Map<String, String> extendField;

  NoteAccount(this.name, this.account, {this.extendField});

  NoteAccount.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        account = json['account'],
        createdAt = json['created_at'],
        updatedAt = json['updated_at'],
        extendField = <String, String>{} {
    json.removeWhere((key, value) =>
        ['name', 'account', 'created_at', 'updated_at'].contains(key));
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
