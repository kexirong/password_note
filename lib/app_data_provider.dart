part of 'home.dart';

class AppData with ChangeNotifier {
  // AppData() ;
  // final NoteData _noteData;
  final List<NoteGroup> _groups = [];
  final List<NoteAccount> _accounts = [];
  final List<RecordMate> _records = [];
  int _index = 0;

  int get index => _index;

  List<NoteGroup> get noteGroups => _groups;

  String? get _currentGroupID {
    return _groups.isNotEmpty ? _groups[_index].id : null;
  }

  List<RecordMate> get noteRecords => _records;

  List<NoteAccount> get noteAccounts => getNoteAccountsByGroupID(_currentGroupID);

  List<NoteAccount> getNoteAccountsByGroupID(String? groupID) {
    return _accounts.where((element) => element.groupID == groupID).toList();
  }

  void noteGroupSetName(int index, String newName) {
    _groups[index].name = newName;
    notifyListeners();
  }

  void addNoteGroup(NoteGroup group) {
    _groups.add(group);
    notifyListeners();
  }

  void addNoteAccount(NoteAccount account) {
    account.groupID = _currentGroupID;
    _accounts.add(account);
    notifyListeners();
  }

  void updateNoteAccount(int index, NoteAccount account) {
    noteAccounts[index] = account;
    notifyListeners();
  }

  void noteGroupRemoveAt(int index) {
    _groups.removeAt(index);
    notifyListeners();
  }

  void noteAccountRemoveByID(String accountID) {
    int index = _accounts.indexWhere((el) => (el.id == accountID));
    _accounts.removeAt(index);
    notifyListeners();
  }

  void setIndex(int index) {
    if (index >= 0 && index < _groups.length) {
      _index = index;
      if (kDebugMode) {
        print("setIndex: $index");
      }
      notifyListeners();
    }
  }
}
