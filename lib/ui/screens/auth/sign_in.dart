import 'package:mivent/theme/text_styles.dart';
import 'package:mivent/ui/screens/auth/forgot_password.dart';
import 'package:mivent/ui/widgets/app_bar.dart';
import 'package:mivent/ui/widgets/safe_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:mivent/ui/widgets/text_fields.dart';
import 'package:mivent/utilities/helpers.dart';

class SignInScreen extends StatefulWidget {
  static const routeName = '/sign_in';
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _RegisterGuestScreenState();
}

class _RegisterGuestScreenState extends State<SignInScreen> {
  final formKey = GlobalKey<FormState>();

  var invalidEmail = false;
  var email = '', password = '';

  @override
  Widget build(BuildContext context) {
    precacheImage(
        const AssetImage('assets/images/forgot_password.png'), context);
    return SafeScaffold(
      appBar: NavAppBar(onPressed: () => Navigator.of(context).pop()),

      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FractionallySizedBox(
              widthFactor: 0.9,
              child: Hero(
                tag: 'sign_in',
                flightShuttleBuilder: (_, anim, __, ___, ____) {
                  return Image.asset(
                    'assets/images/sign_in.png',
                    opacity: anim.drive(Tween(begin: 0.7, end: 1)),
                  );
                },
                child: Image.asset('assets/images/sign_in.png'),
              ),
            ),
            const SizedBox(height: 32),
            const Text('Sign In', style: TextStyles.header1),
            const SizedBox(height: 8),
            Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormWidget(
                    label: 'Email address',
                    keyboardType: TextInputType.emailAddress,
                    validator: (val) {
                      if (val.isEmpty) {
                        return 'Please enter your email address';
                      }
                      if (!Constants.emailFilter.hasMatch(val)) {
                        return 'Please enter a valid email';
                      }
                      if (invalidEmail) {
                        return "This email doesn't exist. Sign up instead";
                      }
                      email = val;
                      return null;
                    },
                  ),
                  const SizedBox(height: 4),
                  PasswordFormWidget(
                    validator: (val) {
                      if (val.isEmpty) {
                        return 'Please enter your password';
                      }
                      if (val.length < 8 || val.length > 20) {
                        return 'Password should be between 8 to 20 characters';
                      }
                      password = val;
                      return null;
                    },
                  ),
                ],
              ),
            ),
            Visibility(
              maintainSize: true,
              maintainState: true,
              maintainAnimation: true,
              visible: !invalidEmail,
              child: Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  child: const Text('Forgot your password?'),
                  onPressed: () {
                    Navigator.of(context).pushNamed(
                      ForgotPasswordScreen.routeName,
                      arguments: email,
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              child: const Text('Continue'),
              onPressed: () {
                if (formKey.currentState!.validate()) {}
              },
            ),
            const SizedBox(height: 16),
            const Text('or', style: TextStyles.header4),
            const SizedBox(height: 12),
            OutlinedButton(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset('assets/images/google.png', width: 24),
                  const SizedBox(width: 6),
                  const Text('Log in with Google'),
                ],
              ),
              onPressed: () {
                ///
              },
            ),
          ],
        ),
      ),
    );
  }
}
