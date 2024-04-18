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

  void recordChange(RecordType type, String itemID, ItemType itemType) {
    _records.add(RecordMate(itemID, itemType, type));
  }

  void noteGroupSetName(int index, String newName) {
    _groups[index].name = newName;
    recordChange(RecordType.update, _groups[index].id, ItemType.group);
    notifyListeners();
  }

  void addNoteGroup(NoteGroup group) {
    _groups.add(group);
    recordChange(RecordType.create, group.id, ItemType.group);
    notifyListeners();
  }

  void addNoteAccount(NoteAccount account) {
    account.groupID = _currentGroupID;
    _accounts.add(account);
    recordChange(RecordType.create, account.id, ItemType.account);
    notifyListeners();
  }

  void updateNoteAccount(NoteAccount account) {
    // var index = noteAccounts.indexOf(account);


    // int lIndex = _accounts.indexWhere((el) => (el.id == account.id));
    // noteAccounts[lIndex] = account;
    recordChange(RecordType.update, account.id, ItemType.account);
    notifyListeners();
  }

  void noteGroupRemoveAt(int index) {
    var group = _groups.removeAt(index);
    recordChange(RecordType.delete, group.id, ItemType.group);
    notifyListeners();
  }

  void noteAccountRemoveByID(String accountID) {
    int index = _accounts.indexWhere((el) => (el.id == accountID));
    var account= _accounts.removeAt(index);
    recordChange(RecordType.delete, account.id, ItemType.account);
    notifyListeners();
  }

  void setIndex(int index) {
    if (index >= 0 && index < _groups.length) {
      _index = index;
      notifyListeners();
    }
  }
}
