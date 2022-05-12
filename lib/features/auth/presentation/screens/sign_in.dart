import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mivent/core/utils/definitions.dart';
import 'package:mivent/features/auth/presentation/bloc/bloc.dart';
import 'package:mivent/features/auth/domain/failure_causes.dart';
import 'package:mivent/features/menu/presentation/menu.dart';
import 'package:mivent/global/data/toast.dart';
import 'package:mivent/global/presentation/theme/text_styles.dart';
import 'package:mivent/global/presentation/widgets/safe_scaffold.dart';
import 'package:mivent/global/presentation/widgets/text_fields.dart';
import 'package:mivent/core/utils/constants.dart';

class SignInScreen extends StatefulWidget {
  static const route = '/sign_in';
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final formKey = GlobalKey<FormState>();
  var invalidEmail = false;
  var email = '', password = '';
  var emailError = '', passwordError = '';

  @override
  Widget build(BuildContext context) {
    return SafeScaffold(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Hello Again!', style: TextStyles.big2),
              const SizedBox(height: 16),
              const Text(
                "It's time to sign you back in.",
                style: TextStyles.header4,
              ),
              const SizedBox(height: 40),
              Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
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
                        if (invalidEmail) {
                          return "This email doesn't exist. Sign up instead";
                        }
                        if (emailError.isNotEmpty) return emailError;
                        email = val;
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    PasswordFormWidget(
                      validator: (val) {
                        if (val.isEmpty) {
                          return 'Please enter your password';
                        }
                        if (val.length < 8 || val.length > 20) {
                          return 'Password use a stronger password';
                        }
                        if (passwordError.isNotEmpty) return passwordError;
                        password = val;
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Visibility(
                maintainSize: true,
                maintainState: true,
                maintainAnimation: true,
                visible: !invalidEmail,
                child: Align(
                  alignment: Alignment.topRight,
                  child: TextButton(
                    child: const Text('Forgot your password?'),
                    onPressed: () {},
                  ),
                ),
              ),
              const SizedBox(height: 48),
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
                                    context.read<AuthBloc>().add(SignInEvent(
                                        email: email, password: password));
                                  }
                                },
                          child: state
                              ? const SizedBox(
                                  width: 45,
                                  height: 45,
                                  child: Center(
                                    child: CircularProgressIndicator(
                                        color: Colors.white),
                                  ),
                                )
                              : const Text('Sign In'),
                        );
                      },
                    ),
                    const SizedBox(height: 32),
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
                            side: const BorderSide(
                                color: Colors.black, width: 2)),
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
                              ),
                            ),
                            Text(
                              'Continue with Google',
                              style: TextStyle(color: Color(0xff787878)),
                            ),
                          ],
                        ),
                        onPressed: () {
                          context
                              .read<AuthBloc>()
                              .add(const GoogleAuthEvent(false));
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
