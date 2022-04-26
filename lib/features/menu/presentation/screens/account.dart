import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mivent/features/auth/presentation/bloc/bloc.dart';
import 'package:mivent/features/auth/presentation/screens/onboard.dart';
import 'package:mivent/features/settings/presentation/screens/edit_account.dart';
import 'package:mivent/global/presentation/theme/colors.dart';
import 'package:mivent/global/presentation/theme/text_styles.dart';
import 'package:mivent/global/presentation/widgets/safe_scaffold.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeScaffold(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(30, 56, 24, 0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              if (context.watch<AuthBloc>().user != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('Account', style: TextStyles.header3),
                    SizedBox(height: 32),
                    _AccountButton(),
                    SizedBox(height: 48),
                    Text('More', style: TextStyles.header3),
                    SizedBox(height: 16),
                  ],
                ),
              const _TileButton(
                title: 'Notifications',
                pageRoute: '',
                icon: Icons.notifications,
                iconColor: Color.fromARGB(255, 245, 118, 0),
              ),
              const _TileButton(
                title: 'Tickets',
                pageRoute: '',
                icon: Icons.airplane_ticket_outlined,
                iconColor: Colors.blue,
              ),
              const _TileButton(
                title: 'Support & Feedback',
                pageRoute: '',
                icon: Icons.support_agent,
                iconColor: Colors.red,
              ),
              const _TileButton(
                title: 'Password Reset',
                pageRoute: '',
                icon: Icons.lock,
                iconColor: Colors.green,
              ),
              const SizedBox(height: 32),
              if (context.watch<AuthBloc>().user != null)
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                      primary: Colors.red[700],
                      side: const BorderSide(width: 2, color: Colors.red)),
                  child: const Text('Sign Out'),
                  onPressed: () {
                    context.read<AuthBloc>().add(SignOutEvent());
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        OnboardScreen.routeName, (_) => false);
                  },
                ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class _TileButton extends StatelessWidget {
  const _TileButton({
    Key? key,
    required this.title,
    required this.pageRoute,
    required this.icon,
    required this.iconColor,
  }) : super(key: key);

  final String title, pageRoute;
  final IconData icon;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamed(pageRoute),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Material(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              children: [
                const SizedBox(width: 4),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: iconColor.withOpacity(0.1),
                  ),
                  child: Icon(icon, color: iconColor, size: 26),
                ),
                const SizedBox(width: 20),
                Expanded(child: Text(title, style: TextStyles.subHeader1)),
                const SizedBox(width: 24),
                const _ForwardButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AccountButton extends StatelessWidget {
  const _AccountButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(EditAccountScreen.routeName);
      },
      child: Material(
        child: SizedBox(
          height: 72,
          child: Row(
            children: [
              const SizedBox(width: 4),
              CircleAvatar(
                radius: 36,
                foregroundColor: ColorPalette.primary,
                backgroundColor: ColorPalette.primary.withOpacity(0.1),
                //foregroundImage: FileImage(''), TODO: saved user image
                child: const Icon(Icons.person, size: 40),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(context.read<AuthBloc>().user!.displayName,
                        style: TextStyles.header4),
                    Text(
                      ' Personal info',
                      style: TextStyles.subHeader2
                          .copyWith(color: Colors.grey[400]),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 24),
              const _ForwardButton(size: 48),
            ],
          ),
        ),
      ),
    );
  }
}

class _ForwardButton extends StatelessWidget {
  const _ForwardButton({Key? key, this.size = 42}) : super(key: key);
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.grey[50],
        boxShadow: const [
          BoxShadow(
            blurRadius: 3,
            color: Colors.black12,
            offset: Offset(0, 2),
          )
        ],
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Icon(Icons.arrow_forward_ios, size: 20),
    );
  }
}
