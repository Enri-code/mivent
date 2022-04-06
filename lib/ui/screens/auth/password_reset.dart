import 'package:flutter/material.dart';
import 'package:mivent/theme/text_styles.dart';
import 'package:mivent/ui/screens/auth/sign_in.dart';
import 'package:mivent/ui/widgets/app_bar.dart';
import 'package:mivent/ui/widgets/safe_scaffold.dart';

class ResetPasswordScreen extends StatelessWidget {
  static const routeName = '/resett_password';
  const ResetPasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeScaffold(
      appBar: NavAppBar(onPressed: () => Navigator.of(context).pop()),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('assets/images/email_sent.png'),
              const SizedBox(height: 40),
              const Text('Email Sent Successfully', style: TextStyles.header1),
              const SizedBox(height: 12),
              const Center(
                child: Text(
                  'An email containing a link to reset your password was sent to your email address',
                  textAlign: TextAlign.center,
                  style: TextStyle(height: 1.5),
                ),
              ),
              const SizedBox(height: 32),
              TextButton(
                onPressed: () {
                  Navigator.of(context).popUntil(
                    (route) => route.settings.name == SignInScreen.routeName,
                  );
                },
                child: const Text('Back To Sign In Page'),
              ),
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }
}
