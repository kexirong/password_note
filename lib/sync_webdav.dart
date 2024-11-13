import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

import 'note_data.dart';
import 'hive.dart';
import 'webdav.dart';

const lockFile = '.lock';

class SyncWebdav {
  static final SyncWebdav _singleton = SyncWebdav._internal();

  factory SyncWebdav() {
    return _singleton;
  }

  SyncWebdav._internal();

  bool isInit = false;
  bool isRunning = false;
  Duration _duration = const Duration(seconds: 30);
  late DateTime lastTime;

  Timer? timer;
  late WebdavClient _client;

  DateTime get nextTime {
    return lastTime.add(_duration);
  }

  void init(String webdavUrl, String webdavUser, String webdavPwd, String webdavPath,
      {Duration? duration}) {
    _client = WebdavClient(webdavUrl, webdavUser, webdavPwd, path: webdavPath, debug: false);
    if (duration != null) {
      _duration = duration;
    }
    lastTime = DateTime.now().subtract(_duration);
    loop();
    isInit = true;
  }

  void loop() {
    timer = Timer.periodic(const Duration(seconds: 5), _loopCallback);
  }

  void _loopCallback(Timer timer) async {
    try {
      if (DateTime.now().isBefore(nextTime) || !isInit || isRunning) {
        if (kDebugMode) {
          print('sync skip');
        }
        return;
      }

      if (await hasLock()) return;
      isRunning = true;

      await lock();
      var records = hiveGetRecords();
      var lzRecords = zipRecords(records);
      var ret = await _client.download('record_mate');
      var cRecords = _toRecords(json.decode(ret));

      var downWait = diffRecords(lzRecords, cRecords);
      var upWait = diffRecords(cRecords, lzRecords);

      lastTime = DateTime.now();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    } finally {
      await unlock();
      isRunning = false;
    }
  }

  Future<bool> hasLock() async {
    try {
      var ret = await _client.download(lockFile);
      var jRet = json.decode(ret);
      int expired = jRet['expired'];
      if (DateTime.now().millisecondsSinceEpoch > expired) {
        return false;
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return false;
      }
    }
    return true;
  }

  Future<void> lock() async {
    var settingBox = Hive.box<String>(hiveSettingBox);
    var deviceID = settingBox.get('device_id');
    var lockData = <String, dynamic>{
      'device_id': deviceID!,
      'expired': DateTime.now().add(_duration).millisecondsSinceEpoch,
    };
    await _client.upload(lockFile, json.encode(lockData));
  }

  Future<void> unlock() async {
    await _client.remove(lockFile);
  }
}

var syncWebdav = SyncWebdav();

Map<String, RecordMate> _toRecords(List<dynamic> jsonInstance) {
  List<RecordMate> records = [];
  for (var i in jsonInstance) {
    var rm = RecordMate.fromJson(i);
    records.add(rm);
  }
  return zipRecords(records);
}
