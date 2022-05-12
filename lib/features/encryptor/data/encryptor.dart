import 'package:encrypt/encrypt.dart';
import 'package:mivent/features/encryptor/domain/encryptor.dart';
import 'package:mivent/features/encryptor/domain/enities/key.dart';

class AESEncryptor extends IEncryptor {
  @override
  EncryptKey generateKey() {
    return EncryptKey(
      iv: IV.fromSecureRandom(16),
      key: Key.fromSecureRandom(32),
    );
    /*
      return SecureRandom(32).nextString(
        length: 32,
        charset:
            r"!#%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~€‚ƒ„…†‡ˆ‰Š‹ŒŽ‘’“”•–—˜™š›œžŸ¡¢£¤¥¦§¨©ª«¬­®¯°±²³´µ¶·¸¹º»¼½¾¿ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖ×ØÙÚÛÜÝÞßàáâãäåæçèéêëìíîïðñòóôõö÷øùúûüýþÿĀāĂăĄąĆćĈĉĊċČčĎďĐđĒēĔĕĖėĘę",
      );
    */
  }

  @override
  encrypt(String message, ICryptKey cryptKeys) {
    print('before encryption: ${DateTime.now()}');
    final encrypted = Encrypter(AES((cryptKeys as EncryptKey).key))
        .encrypt(message, iv: cryptKeys.iv);
    print('after encryption, at ${DateTime.now()}: ${encrypted.base64}');
    return encrypted.base64;
  }

  @override
  decrypt(String encryptedBase64, ICryptKey cryptKeys) {
    print('before decryption, at ${DateTime.now()}');
    final decrypted = Encrypter(AES((cryptKeys as EncryptKey).key))
        .decrypt(Encrypted.fromBase64(encryptedBase64), iv: cryptKeys.iv);
    print('after decryption, at ${DateTime.now()}: $decrypted');
    return decrypted;
  }
}
