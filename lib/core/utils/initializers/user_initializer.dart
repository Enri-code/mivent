import 'package:mivent/features/auth/domain/repos/user_store.dart';

class LocalStoreInitializer {
  static Future init(IUserStore _userStore) async {
    await _userStore.init();
    LocalStoreInitializer.userStore = _userStore;
  }

  static IUserStore? userStore;

  static bool get signedIn => userStore!.isSignedIn;
}
