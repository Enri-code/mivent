import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mivent/features/auth/bloc/bloc.dart';
import 'package:mivent/features/auth/domain/entities/user.dart';
import 'package:mivent/features/auth/domain/entities/user_type.dart';

import 'package:mivent/features/menu/presentation/menu.dart';
import 'package:mivent/features/onboard/presentation/screens/onboard.dart';
import 'package:mivent/global/presentation/theme/text_styles.dart';

import 'package:mivent/global/presentation/widgets/safe_scaffold.dart';
import 'package:mivent/global/presentation/widgets/text_fields.dart';
import 'package:mivent/core/constants.dart';

class RegisterScreen extends StatelessWidget {
  static const routeName = '/register';
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeScaffold(
      child: Hero(
        tag: 'sign_up_animation',
        transitionOnUserGestures: true,
        child: Stack(
          children: [
            ImageSection(
              isHost: context.read<AuthBloc>().userType == const HostUser(),
            ),
            Positioned.fill(
              top: MediaQuery.of(context).size.width * 0.98148 - 64,
              child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 2),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(29)),
                  ),
                  child: const BodySection()),
            ),
          ],
        ),
      ),
    );
  }
}

class BodySection extends StatefulWidget {
  const BodySection({Key? key}) : super(key: key);

  @override
  State<BodySection> createState() => _BodySectionState();
}

class _BodySectionState extends State<BodySection> {
  final formKey = GlobalKey<FormState>();
  var name = '', email = '', password = '';
  var error = '', emailError = '', passwordError = '';

  @override
  Widget build(BuildContext context) {
    bool isHost = context.read<AuthBloc>().userType == const HostUser();

    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 28),
          if (!isHost)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Let's Get Started", style: TextStyles.header3),
                TextButton(
                  child: const Text('Skip'),
                  onPressed: () {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      MenuScreen.routeName,
                      (_) => false,
                    );
                  },
                ),
              ],
            ),
          if (isHost)
            const Text("Welcome to the team!", style: TextStyles.header3),
          const SizedBox(height: 16),
          Form(
            key: formKey,
            child: Column(
              children: [
                TextFormWidget(
                  prefixIcon: const Icon(Icons.person_outline),
                  label: 'Full name',
                  validator: (val) {
                    if (val.isEmpty) {
                      return 'Please fill in your name';
                    }
                    name = val;
                    return null;
                  },
                ),
                const SizedBox(height: 4),
                TextFormWidget(
                  label: 'Email address',
                  prefixIcon: const Icon(Icons.email_outlined),
                  keyboardType: TextInputType.emailAddress,
                  validator: (val) {
                    if (val.isEmpty) {
                      return 'Please enter your email address';
                    }
                    if (!Constants.emailFilter.hasMatch(val)) {
                      return 'Please enter a valid email';
                    }
                    if (emailError.isNotEmpty) return emailError;
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
                    if (passwordError.isNotEmpty) return passwordError;

                    password = val;
                    return null;
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                BlocSelector<AuthBloc, AuthState, bool>(
                  selector: (state) => state.status == AuthStatus.miniLoading,
                  builder: (_, state) {
                    return ElevatedButton(
                      child: state
                          ? const SizedBox(
                              width: 40,
                              height: 40,
                              child: Center(
                                child: CircularProgressIndicator(
                                    color: Colors.white),
                              ),
                            )
                          : const Text('Continue'),
                      onPressed: state
                          ? null
                          : () {
                              emailError = passwordError = '';
                              if (formKey.currentState!.validate()) {
                                context.read<AuthBloc>().add(SignUpEvent(
                                      name: name,
                                      email: email,
                                      password: password,
                                    ));
                              }
                            },
                    );
                  },
                ),
                const SizedBox(height: 16),
                BlocListener<AuthBloc, AuthState>(
                  listener: (context, state) {
                    if (state.status == AuthStatus.success) {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        MenuScreen.routeName,
                        (_) => false,
                      );
                    } else if (state.status == AuthStatus.failed) {
                      switch (state.error?.cause) {
                        case AuthErrorCause.email:
                          emailError = state.error!.message;
                          formKey.currentState!.validate();
                          break;
                        case AuthErrorCause.password:
                          passwordError = state.error!.message;
                          formKey.currentState!.validate();
                          break;
                        default:
                          setState(() => error = AuthError.defaultMessage);
                          break;
                      }
                    }
                  },
                  child: OutlinedButton(
                    child: Stack(
                      alignment: AlignmentDirectional.center,
                      children: const [
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: EdgeInsets.only(left: 8),
                              child: Image(
                                  image:
                                      AssetImage('assets/images/google.png')),
                            )),
                        Text(
                          'Continue with Google',
                          style: TextStyle(color: Color(0xff787878)),
                        ),
                      ],
                    ),
                    onPressed: () {
                      context.read<AuthBloc>().add(GoogleAuthEvent());
                    },
                  ),
                ),
                if (error.isNotEmpty)
                  Align(
                    alignment: Alignment.centerLeft,
                    child:
                        Text(error, style: const TextStyle(color: Colors.red)),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
