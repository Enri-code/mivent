import 'package:mivent/ui/screens/auth/onboard_screen.dart';
import 'package:mivent/ui/screens/auth/register_host.dart';
import 'package:mivent/ui/screens/auth/register_guest.dart';
import 'package:mivent/ui/screens/auth/sign_in.dart';
import 'package:mivent/ui/screens/auth/forgot_password.dart';
import 'package:mivent/ui/screens/auth/password_reset.dart';

import 'package:mivent/ui/screens/menu_pages/menu.dart';

class AppData {
  static const routes = {
    OnboardScreen.routeName: OnboardScreen(),
    RegisterGuestScreen.routeName: RegisterGuestScreen(),
    RegisterHostScreen.routeName: RegisterHostScreen(),
    SignInScreen.routeName: SignInScreen(),
    ForgotPasswordScreen.routeName: ForgotPasswordScreen(),
    ResetPasswordScreen.routeName: ResetPasswordScreen(),
    MenuScreen.routeName: MenuScreen(),
  };
}
