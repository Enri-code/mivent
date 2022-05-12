import 'dart:async';

import 'package:mivent/features/encryptor/domain/enities/key.dart';

abstract class IEncryptor {
  FutureOr<ICryptKey> generateKey();
  String encrypt(String message, ICryptKey cryptKeys);
  String decrypt(String encryptedBase64, ICryptKey cryptKeys);
}
