import 'dart:math';
import '/model/note_data.dart';

final _intToHex = () {
  List<String> cache = List<String>.filled(256, "");

  for (int i = 0; i < 256; i++) {
    cache[i] = i.toRadixString(16);
  }
  return cache;
}();

String uuid() {
  var rands = List<int>.filled(16, 0);
  int rand = 0;
  var random = Random();
  for (var i = 0; i < 16; i++) {
    if ((i & 0x03) == 0) {
      rand = (random.nextDouble() * 0x100000000).floor().toInt();
    }
    rands[i] = rand >> ((i & 0x03) << 3) & 0xff;
  }

  rands[6] = (rands[6] & 0x0f) | 0x40;
  rands[8] = (rands[8] & 0x3f) | 0x80;

  var i = 0;
  return '${_intToHex[rands[i++]]}${_intToHex[rands[i++]]}'
      '${_intToHex[rands[i++]]}${_intToHex[rands[i++]]}'
      '${_intToHex[rands[i++]]}${_intToHex[rands[i++]]}'
      '${_intToHex[rands[i++]]}${_intToHex[rands[i++]]}'
      '${_intToHex[rands[i++]]}${_intToHex[rands[i++]]}'
      '${_intToHex[rands[i++]]}${_intToHex[rands[i++]]}'
      '${_intToHex[rands[i++]]}${_intToHex[rands[i++]]}'
      '${_intToHex[rands[i++]]}${_intToHex[rands[i++]]}';
}

bool isNotEmptyString(String? str) {
  return str != null && str.isNotEmpty;
}

String getAccount(NoteAccount account) {
  if (account is EncryptAccount) {
    return '***未解密***';
  }
  return (account as PlainAccount).account ?? '';
}
