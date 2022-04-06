import 'package:mivent/theme/text_styles.dart';
import 'package:mivent/ui/widgets/app_bar.dart';
import 'package:mivent/ui/widgets/safe_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:mivent/ui/widgets/text_fields.dart';
import 'package:mivent/utilities/helpers.dart';

class RegisterHostScreen extends StatefulWidget {
  static const routeName = '/register_host';
  const RegisterHostScreen({Key? key}) : super(key: key);

  @override
  State<RegisterHostScreen> createState() => _RegisterHostScreenState();
}

class _RegisterHostScreenState extends State<RegisterHostScreen> {
  final formKey = GlobalKey<FormState>();

  var emailExists = false;
  var firstName = '', lastName = '', email = '', password = '';

  @override
  Widget build(BuildContext context) {
    return SafeScaffold(
      appBar: NavAppBar(onPressed: () => Navigator.of(context).pop()),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FractionallySizedBox(
                widthFactor: 0.7,
                child: Hero(
                  tag: 'host',
                  flightShuttleBuilder: (_, anim, __, ___, ____) => Image.asset(
                    'assets/images/host.png',
                    opacity: anim.drive(Tween(begin: 0.7, end: 1)),
                  ),
                  child: Image.asset('assets/images/host.png'),
                ),
              ),
              const SizedBox(height: 24),
              const Center(
                child: Padding(
                  padding: EdgeInsets.only(left: 8, right: 8),
                  child: Text('Welcome To The Team', style: TextStyles.header1),
                ),
              ),
              const SizedBox(height: 8),
              Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextFormWidget(
                            label: 'First Name',
                            keyboardType: TextInputType.name,
                            validator: (val) {
                              if (val.isEmpty) {
                                return 'Please fill in your name';
                              }
                              firstName = val;
                              return null;
                            },
                          ),
                        ),
                        Expanded(
                          child: TextFormWidget(
                            label: 'Last Name',
                            keyboardType: TextInputType.name,
                            validator: (val) {
                              if (val.isEmpty) {
                                return 'Please fill in your name';
                              }
                              lastName = val;
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
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
                        if (emailExists) {
                          return 'You have an account with this email';
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
                    const Text('Sign up with Google'),
                  ],
                ),
                onPressed: () {
                  ///
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
