import 'dart:convert';
import 'package:crypto/crypto.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'note_data.dart';
import 'encrypt.dart';

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
  var secret = hiveGetStringSecret();
  // var secretId = md5.convert(utf8.encode(secret ?? "")).toString();
  for (var element in accountBox.values) {
    var jsonMap = json.decode(element) as Map<String, dynamic>;
    if (jsonMap.containsKey('cipher')) {
      try {
        var deSting = decrypt(secret!, jsonMap);
        jsonMap = json.decode(deSting) as Map<String, dynamic>;
      } catch (e) {
        continue;
      }
    }

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

String? hiveGetStringSecret() {
  var settingBox = Hive.box<String>(hiveSettingBox);

  var secret = settingBox.get('secret');
  return secret;
}

void hiveSetStringSecret(String secret) {
  var settingBox = Hive.box<String>(hiveSettingBox);
  var accountBox = Hive.box<String>(hiveNoteAccountBox);

  var accounts = hiveGetAllAccounts();

  for (var account in accounts) {
    if (secret.isNotEmpty) {
      var accountE = encrypt(secret, json.encode(account.toJson()));
      accountE['id'] = account.id;
      accountE['updated_at'] = account.updatedAt;
      accountE['encrypt_at'] = DateTime.now().millisecondsSinceEpoch;
      accountBox.put(account.id, json.encode(accountE));
    } else {
      accountBox.put(account.id, json.encode(account));
    }
  }
  settingBox.put('secret', secret);
}
