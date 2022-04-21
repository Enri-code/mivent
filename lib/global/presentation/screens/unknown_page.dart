import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mivent/features/menu/presentation/menu.dart';
import 'package:mivent/features/onboard/presentation/screens/onboard.dart';
import 'package:mivent/global/presentation/theme/text_styles.dart';

class UnknownPage extends StatelessWidget {
  const UnknownPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "This page is currently unavailable.\nPlease try again later or wait for the next app update",
              textAlign: TextAlign.center,
              style: TextStyles.header4,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: TextButton(
                child: const Text('Go back',
                    style:
                        TextStyle(fontSize: 26, fontWeight: FontWeight.w500)),
                onPressed: () {
                  if (Navigator.of(context).canPop()) {
                    Navigator.of(context).pop();
                  } else {
                    var onboard = Hive.box('user').get(
                      'first_time',
                      defaultValue: true,
                    );
                    Navigator.of(context).pushReplacementNamed(onboard
                        ? OnboardScreen.routeName
                        : MenuScreen.routeName);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
