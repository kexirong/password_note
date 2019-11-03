class NoteData {
  Map _data = {
    '分组一': [
      {'name': 'aaa'},
      {'name': 'bbb'},
      {'name': 'ccc'}
    ],
    '分组二': [
      {'name': 'aaa'},
      {'name': 'bbb'},
      {'name': 'ccc'}
    ],
    '分组三': [
      {'name': 'aaa'},
      {'name': 'bbb'},
      {'name': 'ccc'}
    ]
  };

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
    return _data.length;
  }

  String getKeyAt(int index) {
    return _data.keys.elementAt(index);
  }

  List getElement(String key) {
    return _data[key];
  }
}
