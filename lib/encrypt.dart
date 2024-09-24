import 'package:encrypt/encrypt.dart';

import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'dart:typed_data';

Key keyFromPassword(String password) {
  var pwdB = utf8.encode(password);
  var pwdSha = md5.convert(pwdB);
  pwdSha = md5.convert(pwdSha.bytes + pwdB);

  return Key(Uint8List.fromList(pwdSha.bytes));
}

Map<String, dynamic> encrypt(String password, String plain) {
  final key = keyFromPassword(password);
  final iv = IV.fromLength(16);

  final encrypter = Encrypter(AES(key, mode: AESMode.cbc));

  final encrypted = encrypter.encrypt(
    plain,
    iv: iv,
  );
  return <String, dynamic>{
    "cipher": 'AES',
    "mode": AESMode.cbc.name,
    "iv": iv.base64,
    "data": encrypted.base64,
  };
}

String decrypt(String pwd, Map<String, dynamic> input) {
  var key = keyFromPassword(pwd);
  var iv = IV.fromBase64(input['iv']);
  var mode = AESMode.values.firstWhere((el) => el.name == input['mode']);

  var encrypter = Encrypter(AES(key, mode: mode));
  var decrypted = encrypter.decrypt64(
    input['data'],
    iv: iv,
  );

  return decrypted;
}
