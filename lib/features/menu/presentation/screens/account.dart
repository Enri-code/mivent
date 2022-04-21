import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mivent/features/auth/bloc/bloc.dart';
import 'package:mivent/features/onboard/presentation/screens/onboard.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: context.watch<AuthBloc>().user == null
          ? ElevatedButton(
              child: const Text('Sign In'),
              onPressed: () {
                context.read<AuthBloc>().add(SignOutEvent());
              },
            )
          : ElevatedButton(
              child: const Text('Sign Out'),
              onPressed: () {
                context.read<AuthBloc>().add(SignOutEvent());
                //Hive.box('user').put('first_time', true);
                Navigator.of(context)
                    .pushReplacementNamed(OnboardScreen.routeName);
              },
            ),
    );
  }
}
