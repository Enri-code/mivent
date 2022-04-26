import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mivent/features/auth/presentation/bloc/bloc.dart';
import 'package:mivent/features/menu/presentation/menu.dart';
import 'package:mivent/features/auth/presentation/screens/onboard.dart';
import 'package:mivent/global/presentation/theme/text_styles.dart';

class UnknownPage extends StatelessWidget {
  const UnknownPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ///TODO: report page name and route to server
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const FractionallySizedBox(
                widthFactor: 0.4,
                child: FittedBox(
                  child: Icon(Icons.error_outline_rounded, color: Colors.grey),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "This page is currently unavailable.\nPlease try again later or wait for the next app update",
                textAlign: TextAlign.center,
                style:
                    TextStyles.header4.copyWith(height: 2, color: Colors.grey),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                style: ElevatedButton.styleFrom(),
                child: const Text('Go back'),
                onPressed: () async {
                  if (Navigator.of(context).canPop()) {
                    Navigator.of(context).pop();
                  } else {
                    Navigator.of(context).pushReplacementNamed(
                        context.read<AuthBloc>().user == null
                            ? OnboardScreen.routeName
                            : MenuScreen.routeName);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
