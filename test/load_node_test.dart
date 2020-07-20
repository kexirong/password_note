import 'dart:convert';

import "package:flutter_test/flutter_test.dart";
import "package:password_note/note_data.dart";

void main() {
  var testGroups = [
    {"type": ItemType.group.index, 'id': 'g1111', 'content': '{"name": "分组一"}'},
    {"type": ItemType.group.index, 'id': 'g2222', 'content': '{"name": "分组二"}'},
    {"type": ItemType.group.index, 'id': 'g3333', 'content': '{"name": "分组三"}'},
  ];
  var testAccounts = [
    {
      "type": ItemType.account.index,
      "id": "a111",
      "parent_id": "g3333",
      'content': '"name": "aaa3", "account": "12321", "pass": "123312"}'
    },
    {
      "type": ItemType.account.index,
      "id": "a222",
      "parent_id": "g3333",
      'content': '"name": "bbb3", "account": "12321", "pass": "123312"}'
    },
    {
      "type": ItemType.account.index,
      "id": "a333",
      "parent_id": "g3333",
      'content': '"name": "ccc3", "account": "12321", "pass": "123312"}'
    },
    {
      "type": ItemType.account.index,
      "id": "a4444",
      "parent_id": "g2222",
      'content': '"name": "aaa2", "account": "12321", "pass": "123312"}'
    },
    {
      "type": ItemType.account.index,
      "id": "a5555",
      "parent_id": "g2222",
      'content': '"name": "bbb2", "account": "12321", "pass": "123312"}'
    },
    {
      "type": ItemType.account.index,
      "id": "a6666",
      "parent_id": "g2222",
      'content': '"name": "ccc2", "account": "12321", "pass": "123312"}'
    },
    {
      "type": ItemType.account.index,
      "id": "a7777",
      "parent_id": "g1111",
      'content': '"name": "aaa1", "account": "12321", "pass": "123312"}'
    },
    {
      "type": ItemType.account.index,
      "id": "a8888",
      "parent_id": "1111",
      'content': '"name": "bbb1", "account": "12321", "pass": "123312"}'
    },
    {
      "type": ItemType.account.index,
      "parent_id": "1111",
      'content': '"name": "ccc1", "account": "12321", "pass": "123312"}'
    },
  ];
  assert(testAccounts.length > 0);
  test("NoteData", () {
    final noteData = NoteData();
    print(noteData.id);
    NoteGroup group;
    for (var e in testGroups) {
      Map groupMap = json.decode(e['content']);
      group = NoteGroup.fromJson(groupMap);
      print(group.name);
      noteData.addGroup(group);
    }
    for (int i = 0; i < noteData.length; i++) {
      print(noteData.getGroupAt(i).name);
    }
    expect(noteData, noteData);
  });
}
