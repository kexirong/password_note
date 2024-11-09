import 'dart:async';
import 'package:flutter/foundation.dart';

import 'package:path/path.dart' as p;

import 'webdav.dart';

class SyncWebdav {
  static final SyncWebdav _singleton = SyncWebdav._internal();

  factory SyncWebdav() {
    return _singleton;
  }

  SyncWebdav._internal();

  bool isInit = false;
  bool isRunning = false;

  Timer? timer;
  late WebdavClient _client;

  void init(String webdavUrl, String webdavUser, String webdavPwd, String webdavPath) {
    _client = WebdavClient(webdavUrl, webdavUser, webdavPwd, path: webdavPath, debug: false);

    loop();
    isInit = true;
  }

  void loop() {
    timer = Timer.periodic(const Duration(seconds: 30), _loopCallback);
  }

  void _loopCallback(Timer timer) async {
    try {
      if (!isInit || isRunning) {
        return;
      }
      isRunning = true;
      var list = await _client.client.readDir(p.join('/', 'Note'));
      for (var f in list) {
        if (kDebugMode) {
          print('${f.name} ${f.path} isDir:${f.isDir}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    } finally {
      isRunning = false;
    }
  }

  // Future<List<String>> getGroupData(String name) async {
  //   return _client.getData('group');
  // }
  //
  // Future<List<String>> getAccountData(String name) async {
  //   return _client.getData('account');
  // }
}

var syncWebdav = SyncWebdav();
