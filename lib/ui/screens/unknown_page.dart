import 'package:flutter/material.dart';
import 'package:mivent/theme/text_styles.dart';

class UnknownPage extends StatelessWidget {
  const UnknownPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "This page is currently unavailable. Please try again later or wait for the next app update",
              textAlign: TextAlign.center,
              style: TextStyles.header2,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: TextButton.icon(
                icon: const Icon(Icons.arrow_back),
                label: const Text('Go back',
                    style:
                        TextStyle(fontSize: 26, fontWeight: FontWeight.w500)),
                onPressed: () {
                  if (Navigator.of(context).canPop()) {
                    Navigator.of(context).pop();
                  }
                  else {
                    //TODO: put home screen if logged in or splash screen
                    Navigator.of(context).pushReplacementNamed('');
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
