import 'package:encrypt/encrypt.dart';

abstract class ICryptKey {
  const ICryptKey();
}

class EncryptKey extends ICryptKey {
  const EncryptKey({required this.key, required this.iv});
  final Key key;
  final IV iv;
}
