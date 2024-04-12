part of 'home.dart';

class AppData extends ChangeNotifier {
  AppData(NoteData noteData) : _noteData = noteData;
  final NoteData _noteData;
  int _index = 0;

  int get index => _index;

  List<NoteGroup> get noteGroups => _noteData.groups;

  String? get _currentGroupID {
    return _noteData.groups.isNotEmpty ? _noteData.groups[_index].id : null;
  }

  List<NoteAccount> get noteAccounts => getNoteAccountsByGroupID(_currentGroupID);

  List<NoteAccount> getNoteAccountsByGroupID(String? groupID) {
    return _noteData.accounts.where((element) => element.groupID == groupID).toList();
  }

  void noteGroupSetName(String newName) {
    _noteData.groups[_index].name = newName;
    notifyListeners();
  }

  void addNoteGroup(NoteGroup group) {
    _noteData.groups.add(group);
    // notifyListeners();
  }

  void addNoteAccount(NoteAccount account) {
    account.groupID = _currentGroupID;
    _noteData.accounts.add(account);
    notifyListeners();
  }

  void noteGroupRemoveAt(int index) {
    _noteData.groups.removeAt(index);
    notifyListeners();
  }

  void noteAccountRemoveByID(String accountID) {
    int index = _noteData.accounts.indexWhere((el) => (el.id == accountID));
    _noteData.accounts.removeAt(index);
    notifyListeners();
  }

  void setIndex(int index) {
    if (index >= 0 && index < _noteData.groups.length) {
      _index = index;
      notifyListeners();
    }
  }
}

// // 定义一个全局的 InheritedWidget
// class AppDataProvider extends InheritedWidget {
//   final AppData appData;
//
//   const AppDataProvider({
//     super.key,
//     required this.appData,
//     required super.child,
//   });
//
//   static AppDataProvider of(BuildContext context) {
//     return context.dependOnInheritedWidgetOfExactType<AppDataProvider>()!;
//   }
//
//   @override
//   bool updateShouldNotify(covariant InheritedWidget oldWidget) {
//     return true;
//   }
// }
