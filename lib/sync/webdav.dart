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
    _client.setHeaders({'content-type': 'text/html'});
    _client.setConnectTimeout(30000);
    _client.setSendTimeout(5000);
    _client.setReceiveTimeout(5000);
  }

  Future<List<String>> list({String? prefix, String? path}) async {
    path ??= rootPath;
    var result = <String>[];
    var data = await _client.readDir(path);
    for (var i in data) {
      if (i.name == null || (prefix != null && !prefix.startsWith(i.name!))) {
        continue;
      }
      result.add(i.name!);
    }
    return result;
  }

  Future<String> download(String name, {String? path}) async {
    path ??= rootPath;
    var fPath = p.join(path, name);

    var bytes = await _client.read(fPath);
    return String.fromCharCodes(bytes);
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
