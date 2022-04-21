import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:mivent/features/auth/bloc/bloc.dart';
import 'package:mivent/features/auth/domain/entities/user_type.dart';
import 'package:mivent/features/onboard/presentation/paints/onboard_choice_button.dart';
import 'package:mivent/features/onboard/presentation/screens/register.dart';
import 'package:mivent/features/onboard/presentation/screens/sign_in.dart';
import 'package:mivent/global/presentation/theme/colors.dart';
import 'package:mivent/global/presentation/theme/text_styles.dart';
import 'package:mivent/global/presentation/theme/theme_data.dart';
import 'package:mivent/global/presentation/widgets/safe_scaffold.dart';

class OnboardScreen extends StatefulWidget {
  static const routeName = '/onboard';
  const OnboardScreen({Key? key}) : super(key: key);

  @override
  State<OnboardScreen> createState() => _OnboardScreenState();
}

class _OnboardScreenState extends State<OnboardScreen> {
  bool? isHost;
  @override
  Widget build(BuildContext context) {
    precacheImage(const AssetImage('assets/images/google.png'), context);
    precacheImage(const AssetImage('assets/images/sign_in.png'), context);
    var lowerSectionOffset = MediaQuery.of(context).size.width * 0.98148 - 32;
    var query = MediaQuery.of(context);
    return SafeScaffold(
      child: Stack(
        children: [
          Hero(
            tag: 'sign_up_animation',
            transitionOnUserGestures: true,
            flightShuttleBuilder: (_, _anim, __, ___, ____) {
              var anim = CurvedAnimation(parent: _anim, curve: Curves.easeIn);
              return Material(
                child: Stack(
                  children: [
                    AnimatedBuilder(
                      animation: anim,
                      builder: (_, child) => Padding(
                        padding: EdgeInsets.only(top: 130 * (1 - anim.value)),
                        child: child!,
                      ),
                      child: ImageSection(isHost: isHost),
                    ),
                    AnimatedBuilder(
                      animation: anim,
                      builder: (_, child) => FractionalTranslation(
                        translation: Offset(0, -anim.value),
                        child: child,
                      ),
                      child: const _TitleSection(),
                    ),
                    AnimatedBuilder(
                      animation: anim,
                      builder: (_, child) {
                        var yOff = 130 *
                            (1 - Curves.easeOutBack.transform(anim.value));
                        return Transform.translate(
                          offset: Offset(0, yOff + 32 * (1 - anim.value)),
                          child: child!,
                        );
                      },
                      child: Padding(
                        padding: EdgeInsets.only(top: lowerSectionOffset - 32),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 2),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(29)),
                          ),
                          child: const BodySection(),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: lowerSectionOffset + 130),
                      child: AnimatedBuilder(
                        animation: anim,
                        builder: (_, child) {
                          return FractionalTranslation(
                            translation: Offset(0, anim.value),
                            child: child,
                          );
                        },
                        child: _LowerSection(
                          isHost: isHost,
                          minHeight: query.size.height -
                              query.viewPadding.vertical -
                              lowerSectionOffset -
                              130,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 130),
                  child: ImageSection(isHost: isHost),
                ),
                const _TitleSection(),
                Padding(
                  padding: EdgeInsets.only(top: lowerSectionOffset + 130),
                  child: _LowerSection(
                    isHost: isHost,
                    minHeight: query.size.height -
                        query.viewPadding.vertical -
                        lowerSectionOffset -
                        130,
                    onUserTypeChange: (val) {
                      setState(() => isHost = val);
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

class _TitleSection extends StatelessWidget {
  const _TitleSection({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(bottomLeft: Radius.elliptical(100, 32)),
        boxShadow: [BoxShadow(blurRadius: 16, color: Colors.black12)],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome to',
            style: TextStyles.header4.copyWith(fontWeight: FontWeight.normal),
          ),
          const SizedBox(height: 2),
          Text(
            ThemeSettings.appName,
            style: TextStyles.big1.apply(color: Theme.of(context).primaryColor),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: DefaultTextStyle(
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: const [
                      DefaultTextStyle(
                        style: TextStyle(
                            color: ColorPalette.secondaryColor,
                            fontSize: 23,
                            fontWeight: FontWeight.bold),
                        child: _DiscoverBuildWidget(),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 2.8, left: 7),
                        child: Text('amazing events'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  const Text('All in one app'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ImageSection extends StatelessWidget {
  const ImageSection({Key? key, required this.isHost}) : super(key: key);
  final bool? isHost;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: FractionallySizedBox(
        widthFactor: 2,
        alignment: Alignment.centerLeft,
        child: AnimatedSlide(
          offset: () {
            if (isHost == null) return const Offset(-0.25, 0);
            if (isHost!) return Offset.zero;
            return const Offset(-0.5, 0);
          }(),
          curve: Curves.easeInOut,
          duration: const Duration(milliseconds: 300),
          child: Row(
            children: const [
              Expanded(
                  child: Image(
                      image: AssetImage('assets/images/onboard_host.jpg'))),
              Expanded(
                  child: Image(
                      image: AssetImage('assets/images/onboard_guest.jpg'))),
            ],
          ),
        ),
      ),
    );
  }
}

class _LowerSection extends StatelessWidget {
  const _LowerSection({
    Key? key,
    required this.minHeight,
    this.onUserTypeChange,
    this.isHost,
  }) : super(key: key);

  final bool? isHost;
  final double minHeight;
  final Function(bool)? onUserTypeChange;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 6),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        decoration: BoxDecoration(
          color: Colors.blueGrey[900],
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: DefaultTextStyle(
          style: TextStyles.subHeader1.copyWith(color: Colors.grey[300]),
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: max(300, minHeight)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text("I'm here to"),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: (isHost ?? false)
                                      ? null
                                      : () {
                                          context.read<AuthBloc>().userType =
                                              const HostUser();
                                          onUserTypeChange?.call(true);
                                        },
                                  child: CustomPaint(
                                    painter: OnboardChoiceButton(
                                      (isHost ?? false)
                                          ? Colors.white
                                          : Colors.transparent,
                                    ),
                                    child: SizedBox(
                                      height: 60,
                                      child: Center(
                                        child: Text(
                                          'Host',
                                          style: (isHost ?? false)
                                              ? const TextStyle(
                                                  color: Colors.black)
                                              : null,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: (isHost ?? true)
                                      ? () {
                                          context.read<AuthBloc>().userType =
                                              const AttenderUser();
                                          onUserTypeChange?.call(false);
                                        }
                                      : null,
                                  child: Stack(
                                    alignment: AlignmentDirectional.center,
                                    children: [
                                      RotatedBox(
                                        quarterTurns: 2,
                                        child: CustomPaint(
                                          painter: OnboardChoiceButton(
                                              isHost ?? true
                                                  ? Colors.transparent
                                                  : Colors.white),
                                          child: const SizedBox(
                                              height: 60,
                                              width: double.infinity),
                                        ),
                                      ),
                                      Text(
                                        'Find',
                                        style: isHost ?? true
                                            ? null
                                            : const TextStyle(
                                                color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          const Align(
                            alignment: Alignment.centerRight,
                            child: Text('Events'),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 200,
                        child: ElevatedButton(
                          child: const Text('Get started'),
                          onPressed: isHost == null
                              ? null
                              : () {
                                  Navigator.of(context).push(
                                    PageRouteBuilder(
                                      transitionDuration:
                                          const Duration(milliseconds: 700),
                                      reverseTransitionDuration:
                                          const Duration(milliseconds: 500),
                                      pageBuilder: (_, __, ___) =>
                                          const RegisterScreen(),
                                    ),
                                  );
                                },
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Already have an account?',
                            style: TextStyles.subHeader2,
                          ),
                          TextButton(
                            child: const Text('Log in'),
                            onPressed: () {
                              Navigator.of(context)
                                  .pushNamed(SignInScreen.routeName);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DiscoverBuildWidget extends StatefulWidget {
  const _DiscoverBuildWidget({Key? key}) : super(key: key);

  @override
  State<_DiscoverBuildWidget> createState() => _DiscoverBuildWidgetState();
}

class _DiscoverBuildWidgetState extends State<_DiscoverBuildWidget> {
  var showFirst = true;

  @override
  void initState() {
    Timer.periodic(const Duration(seconds: 2), (timer) {
      if (mounted) {
        setState(() => showFirst = !showFirst);
      } else {
        timer.cancel();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      crossFadeState:
          showFirst ? CrossFadeState.showFirst : CrossFadeState.showSecond,
      duration: const Duration(milliseconds: 400),
      alignment: Alignment.bottomRight,
      firstChild: const Text('Discover'),
      secondChild: const Text('Build'),
    );
  }
}
