import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';
import 'hive.dart';
import 'note_data.dart';

class NoteDataModel extends ChangeNotifier {
  // NoteDataModel({List<NoteGroup>? groups, List<NoteAccount>? accounts, List<RecordMate>? records})
  //     : _groups = groups ?? [],
  //       _accounts = accounts ?? [],
  //       _records = records ?? [];

  late final List<NoteGroup> _groups;

  late final List<NoteAccount> _accounts;

  late final List<RecordMate> _records;

  NoteDataModel() {
    _groups = hiveGetAllGroups();
    _accounts = hiveGetAllAccounts();
    _records = hiveGetRecords();
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

  void recordChange(RecordType type, String itemID, ItemType itemType) {
    var recordBox = Hive.box<String>(hiveRecordMateBox);
    var rm = RecordMate(itemID, itemType, type);
    _records.add(rm);
    recordBox.put(rm.id, json.encode(rm));
  }

  void noteGroupSetName(int index, String newName) {
    var g = _groups[index];
    g.name = newName;
    g.updatedAt = DateTime.now().millisecondsSinceEpoch;
    recordChange(RecordType.update, _groups[index].id, ItemType.group);
    var groupBox = Hive.box<String>(hiveNoteGroupBox);
    groupBox.put(g.id, json.encode(g));
    notifyListeners();
  }

  void addNoteGroup(NoteGroup group) {
    _groups.add(group);
    recordChange(RecordType.create, group.id, ItemType.group);
    var groupBox = Hive.box<String>(hiveNoteGroupBox);
    groupBox.put(group.id, json.encode(group));
    notifyListeners();
  }

  void addNoteAccount(NoteAccount account) {
    account.groupID = _currentGroupID;
    _accounts.add(account);
    recordChange(RecordType.create, account.id, ItemType.account);
    hivePutAccount(account);

    notifyListeners();
  }

  void updateNoteAccount(NoteAccount account) {
    account.updatedAt = DateTime.now().millisecondsSinceEpoch;

    recordChange(RecordType.update, account.id, ItemType.account);
    hivePutAccount(account);

    notifyListeners();
  }

  void noteGroupRemoveAt(int index) {
    var group = _groups.removeAt(index);
    recordChange(RecordType.delete, group.id, ItemType.group);
    var groupBox = Hive.box<String>(hiveNoteGroupBox);
    groupBox.delete(group.id);
    notifyListeners();
  }

  void noteAccountRemoveByID(String accountID) {
    int index = _accounts.indexWhere((el) => (el.id == accountID));
    var account = _accounts.removeAt(index);
    recordChange(RecordType.delete, account.id, ItemType.account);
    var accountBox = Hive.box<String>(hiveNoteAccountBox);
    accountBox.delete(account.id);
    notifyListeners();
  }

  void setIndex(int index) {
    if (index >= 0 && index < _groups.length) {
      _index = index;
      notifyListeners();
    }
  }
}
