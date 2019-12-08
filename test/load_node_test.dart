import "package:flutter_test/flutter_test.dart";
import "package:password_note/note_data.dart";

import 'package:password_note/util.dart';

void main() {
  var test_groups = [
    {"type": ItemType.group.index, 'content': '{"name": "分组一"}'},
    {"type": ItemType.group.index, 'content': '{"name": "分组二"}'},
    {"type": ItemType.group.index, 'content': '{"name": "分组三"}'},
  ];
  var test_accounts = [
    {
      "type": ItemType.account.index,
      "group": "分组三",
      'content': '"name": "aaa3", "account": "12321", "pass": "123312"}'
    },
    {
      "type": ItemType.account.index,
      "group": "分组三",
      'content': '"name": "bbb3", "account": "12321", "pass": "123312"}'
    },
    {
      "type": ItemType.account.index,
      "group": "分组三",
      'content': '"name": "ccc3", "account": "12321", "pass": "123312"}'
    },
    {
      "type": ItemType.account.index,
      "group": "分组二",
      'content': '"name": "aaa2", "account": "12321", "pass": "123312"}'
    },
    {
      "type": ItemType.account.index,
      "group": "分组二",
      'content': '"name": "bbb2", "account": "12321", "pass": "123312"}'
    },
    {
      "type": ItemType.account.index,
      "group": "分组二",
      'content': '"name": "ccc2", "account": "12321", "pass": "123312"}'
    },
    {
      "type": ItemType.account.index,
      "group": "分组一",
      'content': '"name": "aaa1", "account": "12321", "pass": "123312"}'
    },
    {
      "type": ItemType.account.index,
      "group": "分组一",
      'content': '"name": "bbb1", "account": "12321", "pass": "123312"}'
    },
    {
      "type": ItemType.account.index,
      "group": "分组一",
      'content': '"name": "ccc1", "account": "12321", "pass": "123312"}'
    },
  ];
  test("测试 value 递增", () {
    final noteData = NoteData();
    print(uuid());
    expect(noteData, noteData);
  });
}
