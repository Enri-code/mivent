import 'package:mivent/ui/screens/auth/onboard_screen.dart';
import 'package:mivent/ui/screens/auth/register_guest.dart';
import 'package:mivent/ui/screens/auth/register_host.dart';
import 'package:mivent/ui/screens/auth/sign_in.dart';

class AppData {
  static final routes = {
    OnboardScreen.routeName: const OnboardScreen(),
    SignInScreen.routeName: const SignInScreen(),
    RegisterHostScreen.routeName: const RegisterHostScreen(),
    RegisterGuestScreen.routeName: const RegisterGuestScreen(),
  };
}
