import 'dart:math';

final _byteToHex = (() {
  List<String> _cache = List<String>(256);

  for (int i = 0; i < 256; i++) {
    _cache[i] = i.toRadixString(16);
  }
  return _cache;
})();

String uuid() {
  var rnds = List<int>(16);
  int rand;
  var _rand = Random();
  for (var i = 0; i < 16; i++) {
    if ((i & 0x03) == 0) {
      rand = (_rand.nextDouble() * 0x100000000).floor().toInt();
    }
    rnds[i] = rand >> ((i & 0x03) << 3) & 0xff;
  }

  rnds[6] = (rnds[6] & 0x0f) | 0x40;
  rnds[8] = (rnds[8] & 0x3f) | 0x80;

  var i = 0;
  return '${_byteToHex[rnds[i++]]}${_byteToHex[rnds[i++]]}'
      '${_byteToHex[rnds[i++]]}${_byteToHex[rnds[i++]]}'
      '${_byteToHex[rnds[i++]]}${_byteToHex[rnds[i++]]}'
      '${_byteToHex[rnds[i++]]}${_byteToHex[rnds[i++]]}'
      '${_byteToHex[rnds[i++]]}${_byteToHex[rnds[i++]]}'
      '${_byteToHex[rnds[i++]]}${_byteToHex[rnds[i++]]}'
      '${_byteToHex[rnds[i++]]}${_byteToHex[rnds[i++]]}'
      '${_byteToHex[rnds[i++]]}${_byteToHex[rnds[i++]]}';
}
