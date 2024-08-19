import 'package:webdav_client/webdav_client.dart';

class WebdavClient {
  String url;
  String user;
  String password;
  bool debug;

  WebdavClient(this.url, this.user, this.password, {this.debug = false});

  Client _getClient() {
    var client = newClient(
      url,
      user: user,
      password: password,
      debug: debug,
    );

    client.setHeaders({'accept-charset': 'utf-8'});

    return client;
  }

  Future<List<String>> _getData(String name) async {
    var result = <String>[];
    var client = _getClient();
    var data = await client.readDir('');
    for (var i in data) {
      if (i.name!.contains(name)) {
        var bytes = await client.read(i.path!);
        result.add(String.fromCharCodes(bytes));
      }
    }

    return result;
  }

  Future<List<String>> getGroupData(String name) async {
    return _getData('group');
  }

  Future<List<String>> getAccountData(String name) async {
    return _getData('account');
  }
}
