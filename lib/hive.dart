import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'note_data.dart';

const hiveSettingBox = 'settings';
const hiveRecordMateBox = 'record_mates';
const hiveNoteGroupBox = 'note_groups';
const hiveNoteAccountBox = 'note_accounts';

Future<void> hiveInit() async {
  await Hive.initFlutter();
  await Hive.openBox<String>(hiveSettingBox);
  await Hive.openBox<String>(hiveRecordMateBox);
  await Hive.openBox<String>(hiveNoteGroupBox);
  await Hive.openBox<String>(hiveNoteAccountBox);
}

List<NoteGroup> hiveGetAllGroups() {
  var groups = <NoteGroup>[];
  var groupBox = Hive.box<String>(hiveNoteGroupBox);

  for (var element in groupBox.values) {
    var jsonMap = json.decode(element);
    groups.add(NoteGroup.fromJson(jsonMap));
  }
  return groups;
}

List<NoteAccount> hiveGetAllAccounts() {
  var accounts = <NoteAccount>[];
  var accountBox = Hive.box<String>(hiveNoteAccountBox);

  for (var element in accountBox.values) {
    if (kDebugMode) {
      print("hiveGetAllAccounts: $element");
    }
    var jsonMap = json.decode(element);
    accounts.add(NoteAccount.fromJson(jsonMap));
  }
  return accounts;
}

List<RecordMate> hiveGetRecords() {
  var records = <RecordMate>[];
  var recordBox = Hive.box<String>(hiveRecordMateBox);

  for (var element in recordBox.values) {
    var jsonMap = json.decode(element);
    records.add(RecordMate.fromJson(jsonMap));
  }
  return records;
}
