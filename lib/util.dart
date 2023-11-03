import 'dart:math';

final _intToHex = () {
  List<String> _cache = List<String>.filled(256, "");

  for (int i = 0; i < 256; i++) {
    _cache[i] = i.toRadixString(16);
  }
  return _cache;
}();

String uuid() {
  var rands = List<int>.filled(16, 0);
  int rand = 0;
  var _rand = Random();
  for (var i = 0; i < 16; i++) {
    if ((i & 0x03) == 0) {
      rand = (_rand.nextDouble() * 0x100000000).floor().toInt();
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
