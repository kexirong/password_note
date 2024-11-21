import 'dart:convert';

class WebdavConfig {
  String url;
  String user;
  String password;
  String path;

  WebdavConfig(this.url, this.user, this.password, this.path);

  WebdavConfig.fromJson(Map<String, dynamic> json)
      : url = json['url'],
        user = json['user'],
        password = json['password'],
        path = json['path'];

  Map<String, dynamic> toJson() => <String, dynamic>{
        'url': url,
        'user': user,
        'password': password,
        'path': path,
      };

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}
