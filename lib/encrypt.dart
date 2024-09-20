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

Map<String, dynamic> encrypt(String password, plain) {
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
    // "key_id": md5.convert(utf8.encode(pwd)).toString(),
    "data": encrypted.base64,
  };
}

String decrypt(String pwd, Map<String, dynamic> input) {
  final key = keyFromPassword(pwd);
  final iv = IV.fromBase64(input['iv']);
  final encrypter = Encrypter(AES(key, mode: AESMode.values[input['mode']], padding: null));
  final decrypted = encrypter.decrypt(
    input['data'],
    iv: iv,
  );
  return decrypted;
}
