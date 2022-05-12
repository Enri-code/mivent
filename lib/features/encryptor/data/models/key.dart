import 'package:encrypt/encrypt.dart';
import 'package:mivent/features/encryptor/domain/enities/key.dart';

class EncryptKeyModel extends EncryptKey {
  EncryptKeyModel.fromMap(Map<String, dynamic> map)
      : super(
            key: Key.fromBase64('encryption_key'),
            iv: IV.fromBase64('encryption_iv'));
}
