import 'package:hive_flutter/hive_flutter.dart';

Future<void> hiveInit() async {
  await Hive.initFlutter();
  await Hive.openBox<String>('settings');
  await Hive.openBox<String>('record_mates');
  await Hive.openBox<String>('note_groups');
  await Hive.openBox<String>('note_accounts');
}
