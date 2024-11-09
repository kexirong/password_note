import 'dart:typed_data';
import 'package:webdav_client/webdav_client.dart' as webdav;
import 'package:path/path.dart' as p;

class WebdavClient {
  final webdav.Client _client;
  String rootPath = '';

  WebdavClient(
    String url,
    String user,
    String password, {
    String path = '',
    debug = false,
  })  : _client = webdav.newClient(
          url,
          user: user,
          password: password,
          debug: debug,
        ),
        rootPath = p.join('/', path) {
    _client.setHeaders({'accept-charset': 'utf-8'});
    _client.setConnectTimeout(8000);
    _client.setSendTimeout(8000);
    _client.setReceiveTimeout(8000);
  }

  Future<List<String>> list({String? path}) async {
    path ??= rootPath;
    var result = <String>[];
    var data = await _client.readDir(path);
    for (var i in data) {
      if (i.name != null) {
        result.add(i.name!);
      }
    }
    return result;
  }

  Future<List<String>> download(String name, {String? path}) async {
    var result = <String>[];
    var data = await _client.readDir('');
    for (var i in data) {
      if (i.isDir != null && !i.isDir! && i.name!.startsWith(name)) {
        var bytes = await _client.read(i.path!);
        result.add(String.fromCharCodes(bytes));
      }
    }
    return result;
  }

  Future<void> upload(String name, String data, {String? path}) async {
    path ??= rootPath;
    var fPath = p.join(path, name);
    await _client.write(fPath, Uint8List.fromList(data.codeUnits));
  }

  Future<void> remove(String name, {String? path}) async {
    path ??= rootPath;
    var fPath = p.join(path, name);
    return await _client.removeAll(fPath);
  }

  webdav.Client get client => _client;
}
