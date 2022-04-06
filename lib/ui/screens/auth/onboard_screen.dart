import 'package:mivent/ui/screens/auth/sign_in.dart';
import 'package:mivent/utilities/size_config.dart';
import 'package:mivent/ui/screens/auth/register_guest.dart';
import 'package:mivent/ui/screens/auth/register_host.dart';
import 'package:mivent/theme/text_styles.dart';
import 'package:mivent/theme/theme_data.dart';
import 'package:mivent/ui/widgets/safe_scaffold.dart';

import 'package:flutter/material.dart';

class OnboardScreen extends StatelessWidget {
  static const routeName = '/onboard';
  const OnboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    precacheImage(const AssetImage('assets/images/google.png'), context);
    precacheImage(const AssetImage('assets/images/sign_in.png'), context);
    //print(MediaQuery.of(context).size);
    return SafeScaffold(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              SizedBox(height: 16.h()),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Welcome To ',
                    style: TextStyles.header1
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    ThemeSettings.appName,
                    style: TextStyles.big1.apply(
                      fontFamily: FontFamily.chuckry,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: _TypeOfUserCard(
                        title: 'Want to host an event?',
                        body:
                            'Create a top-tier event with our tools, services and audience',
                        imageName: 'host',
                        onPressed: () {
                          Navigator.of(context)
                              .pushNamed(RegisterHostScreen.routeName);
                        },
                      ),
                    ),
                    Expanded(
                      child: _TypeOfUserCard(
                        title: 'Looking for an event?',
                        body:
                            'Discover our amazing events, tailored to your taste',
                        imageName: 'guest',
                        onPressed: () {
                          Navigator.of(context)
                              .pushNamed(RegisterGuestScreen.routeName);
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 2),
                    child: Text('Already have an account?'),
                  ),
                  TextButton(
                    child: const Text('Sign In again'),
                    onPressed: () {
                      Navigator.of(context).pushNamed(SignInScreen.routeName);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TypeOfUserCard extends StatelessWidget {
  const _TypeOfUserCard({
    Key? key,
    required this.title,
    required this.body,
    required this.imageName,
    required this.onPressed,
  }) : super(key: key);

  final String imageName, title, body;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: GestureDetector(
        onTap: onPressed,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Padding(
              padding: EdgeInsets.only(right: 16, top: 8, bottom: 4),
              child: Text('Tap to Continue', style: TextStyles.hint1),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Center(
                        child: Hero(
                          tag: imageName,
                          child: Image.asset(
                            'assets/images/$imageName.png',
                            opacity: const AlwaysStoppedAnimation(0.7),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(title, style: TextStyles.header4),
                    const SizedBox(height: 6),
                    Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: Text(body),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
