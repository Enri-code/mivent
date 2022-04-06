import 'package:flutter/material.dart';
import 'package:mivent/theme/text_styles.dart';
import 'package:mivent/ui/widgets/app_bar.dart';
import 'package:mivent/ui/widgets/safe_scaffold.dart';
import 'package:mivent/ui/widgets/text_fields.dart';
import 'package:mivent/utilities/helpers.dart';

class ForgotPasswordScreen extends StatefulWidget {
  static const routeName = '/forgot_password';
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final formKey = GlobalKey<FormState>();

  var email = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    email = ModalRoute.of(context)!.settings.arguments as String? ?? '';
  }

  @override
  Widget build(BuildContext context) {
    precacheImage(const AssetImage('assets/images/email_sent.png'), context);
    return SafeScaffold(
      appBar: NavAppBar(onPressed: () => Navigator.of(context).pop()),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FractionallySizedBox(
              widthFactor: 0.7,
              child: Image.asset('assets/images/forgot_password.png'),
            ),
            const SizedBox(height: 24),
            const Text('Forgot Password?', style: TextStyles.header1),
            const SizedBox(height: 8),
            const Center(
              child: Text(
                'Enter your registered email below to receive your password reset instructions',
                textAlign: TextAlign.center,
                style: TextStyle(height: 1.5),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Form(
                key: formKey,
                child: TextFormWidget(
                  label: 'Enter Your Email',
                  validator: (val) {
                    if (email.isEmpty) {
                      return 'Please enter an email address';
                    }
                    if (!Constants.emailFilter.hasMatch(email)) {
                      return 'Please enter a valid email';
                    }
                    email = val;
                    return null;
                  },
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              child: const Text('Continue'),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
