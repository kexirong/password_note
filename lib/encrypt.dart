import 'package:encrypt/encrypt.dart';

Map<String, dynamic> encrypt(String pwd, plain) {
  final key = Key.fromUtf8(pwd);
  final iv = IV.fromSecureRandom(32);
  final encrypter = Encrypter(AES(key, mode: AESMode.cbc, padding: null));
  final encrypted = encrypter.encrypt(
    plain,
    iv: iv,
  );
  return <String, dynamic>{
    "cipher": 'AES',
    "mode": 'cbc',
    "iv": iv.base64,
    "data": encrypted.base64,
  };
}

String decrypt(String pwd, Map<String, dynamic> input) {
  final key = Key.fromUtf8(pwd);
  final iv = IV.fromBase64(input['iv']);
  final encrypter = Encrypter(AES(key, mode: AESMode.values[input['mode']], padding: null));
  final decrypted = encrypter.decrypt(
    input['data'],
    iv: iv,
  );
  return decrypted;
}
