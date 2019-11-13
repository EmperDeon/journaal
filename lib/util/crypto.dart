import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pointycastle/export.dart';

class Crypto {
  Crypto() {
    initCommon();
    initDerivators();
  }

  //
  // Common functions
  //

  final _random = FortunaRandom();
  final _baseEncoder = Base64Encoder();
  final _baseDecoder = Base64Decoder();

  void initCommon() {
    var temp = Random.secure();
    var bytes = List.generate(32, (index) => temp.nextInt(256));

    _random.seed(KeyParameter(Uint8List.fromList(bytes)));
  }

  String toBase64(Uint8List bytes) {
    return _baseEncoder.convert(bytes);
  }

  Uint8List fromBase64(String base) {
    return _baseDecoder.convert(base);
  }

  Uint8List randomKey(int length) {
    return _random.nextBytes(length);
  }

  //
  // Derivator
  //

  KeyDerivator passwordDerivator =
      PBKDF2KeyDerivator(new HMac(new SHA1Digest(), 32));

  void initDerivators() {
    passwordDerivator.init(Pbkdf2Parameters(derivatorSalt(), 100, 128));
  }

  String derivePassword(String pass) {
    var bytes = Utf8Encoder().convert(pass);
    return toBase64(passwordDerivator.process(bytes));
  }

  Uint8List derivatorSalt() => fromBase64(DotEnv().env['CRYPTO_DERIVATOR_KEY']);
}
