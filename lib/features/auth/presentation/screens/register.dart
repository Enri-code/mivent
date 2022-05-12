import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mivent/core/utils/definitions.dart';
import 'package:mivent/features/auth/presentation/bloc/bloc.dart';
import 'package:mivent/features/auth/domain/entities/user_type.dart';
import 'package:mivent/features/auth/domain/failure_causes.dart';

import 'package:mivent/features/menu/presentation/menu.dart';
import 'package:mivent/features/auth/presentation/screens/onboard.dart';
import 'package:mivent/global/data/toast.dart';
import 'package:mivent/global/presentation/theme/text_styles.dart';

import 'package:mivent/global/presentation/widgets/safe_scaffold.dart';
import 'package:mivent/global/presentation/widgets/text_fields.dart';
import 'package:mivent/core/utils/constants.dart';

class RegisterScreen extends StatelessWidget {
  static const route = '/register';
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

  String? phoneNumber;
  String displayName = '', email = '', password = '';
  String emailError = '', passwordError = '';

  @override
  Widget build(BuildContext context) {
    bool isHost = context.read<AuthBloc>().userType == const HostUser();

    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 28),
          if (!isHost)
            const Text("Let's Get Started", style: TextStyles.header3)
          else
            const Text("Welcome to the team!", style: TextStyles.header3),
          const SizedBox(height: 24),
          Form(
            key: formKey,
            child: Column(
              children: [
                TextFormWidget(
                  prefixIcon: const Icon(Icons.person_outline),
                  label: 'Full name',
                  validator: (val) {
                    if (val.isNotEmpty) {
                      return 'Please fill in your name';
                    }
                    displayName = val;
                    return null;
                  },
                ),
                if (isHost) const SizedBox(height: 4),
                if (isHost)
                  TextFormWidget(
                    prefixIcon: const Icon(Icons.phone),
                    label: 'Phone number',
                    validator: (val) {
                      if (val.length < 11 ||
                          !Constants.phoneNumberFilter.hasMatch(val)) {
                        return 'Please input a valid phone number';
                      }
                      if (val.isEmpty) {
                        phoneNumber = null;
                      } else {
                        phoneNumber = val;
                      }
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
                  selector: (state) =>
                      state.status == OperationStatus.minorLoading,
                  builder: (_, state) {
                    return ElevatedButton(
                      onPressed: state
                          ? null
                          : () {
                              emailError = passwordError = '';
                              if (formKey.currentState!.validate()) {
                                context.read<AuthBloc>().add(SignUpEvent(
                                      email: email,
                                      password: password,
                                      extraData: {
                                        'display_name': displayName,
                                        'phone_number': phoneNumber
                                      },
                                    ));
                              }
                            },
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
                    );
                  },
                ),
                const SizedBox(height: 24),
                BlocListener<AuthBloc, AuthState>(
                  listener: (context, state) {
                    if (state.status == OperationStatus.success) {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        MenuScreen.route,
                        (_) => false,
                      );
                    } else if (state.status == OperationStatus.minorFail) {
                      var cause = state.failure!.cause;
                      if (cause is EmailFailure) {
                        emailError = state.failure!.message!;
                        formKey.currentState!.validate();
                      } else if (cause is PasswordFailure) {
                        passwordError = state.failure!.message!;
                        formKey.currentState!.validate();
                      } else {
                        ToastManager.error(body: state.failure!.message);
                      }
                    }
                  },
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.black, width: 2)),
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
                      context.read<AuthBloc>().add(const GoogleAuthEvent(true));
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
