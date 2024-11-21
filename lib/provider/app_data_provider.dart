import 'package:flutter/material.dart';

import '/model/note_data.dart';
import '/db/db.dart';
import '/store/account.dart';
import '/store/group.dart';
import '/store/record_mate.dart';

class NoteDataModel extends ChangeNotifier {
  final List<NoteGroup> _groups;
  final List<NoteAccount> _accounts;
  final List<RecordMate> _records;

  // late Database _db;

  NoteDataModel({List<NoteGroup>? groups, List<NoteAccount>? accounts, List<RecordMate>? records})
      : _groups = groups ?? [],
        _accounts = accounts ?? [],
        _records = records ?? [];

  Future<void> loadData() async {
    _accounts.addAll(await NoteAccountStore().getAll(await getDBC()));
    _groups.addAll(await NoteGroupStore().getAll(await getDBC()));
    _records.addAll(await RecordMateStore().getAll(await getDBC()));
  }

  int _index = 0;

  int get index => _index;

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

  // void recordChange(RecordType type, String itemID, ItemType itemType) {
  //   var recordBox = Hive.box<String>(hiveRecordMateBox);
  //   var rm = RecordMate(itemID, itemType, type);
  //   _records.add(rm);
  //   recordBox.put(rm.id, json.encode(rm));
  // }

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
    });
    _groups.add(group);
    notifyListeners();
  }

  Future<void> addNoteAccount(NoteAccount account) async {
    account.groupID = _currentGroupID;

    var rm = RecordMate(account.id, ItemType.account, RecordType.create);
    var db = await getDBC();
    await db.transaction((txn) async {
      await NoteAccountStore().add(txn, account);
      await RecordMateStore().add(txn, rm);
    });
    _accounts.add(account);

    notifyListeners();
  }

  Future<void> updateNoteAccount(NoteAccount account) async {
    account.updatedAt = DateTime.now().millisecondsSinceEpoch;

    var rm = RecordMate(account.id, ItemType.account, RecordType.update);
    var db = await getDBC();
    await db.transaction((txn) async {
      await NoteAccountStore().update(txn, account);
      await RecordMateStore().add(txn, rm);
    });
    notifyListeners();
  }

  Future<void> noteGroupRemoveAt(int index) async {
    var rm = RecordMate(_groups[index].id, ItemType.group, RecordType.delete);
    var db = await getDBC();
    await db.transaction((txn) async {
      await NoteGroupStore().delete(txn, _groups[index]);
      await RecordMateStore().add(txn, rm);
    });
    _groups.removeAt(index);
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
    });
    _accounts.removeAt(index);
    notifyListeners();
  }

  void setIndex(int index) {
    if (index >= 0 && index < _groups.length) {
      _index = index;
      notifyListeners();
    }
  }
}
