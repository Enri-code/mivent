import 'package:mivent/utilities/settings.dart';
import 'package:mivent/utilities/size_config.dart';
import 'package:mivent/ui/screens/unknown_page.dart';
import 'package:mivent/theme/theme_data.dart';
import 'package:mivent/ui/screens/auth/onboard_screen.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
//import 'firebase_options.dart';

void main() => runApp(const App());

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //TODO:
    //Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    return MaterialApp(
      title: ThemeSettings.appName,
      theme: ThemeSettings().myTheme,
      onGenerateRoute: (settings) => PageRouteBuilder(
        settings: settings,
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (_, __, ___) => AppData.routes[settings.name]!,
        transitionsBuilder: (_, animation1, __, child) =>
            FadeTransition(opacity: animation1, child: child),
      ),
      onUnknownRoute: (settings) => PageRouteBuilder(
        pageBuilder: (_, __, ___) => const UnknownPage(),
      ),
      home: const Responsive(
        screenWidth: 411.4,
        screenHeight: 868.6,
        child: OnboardScreen(),
      ),
    );
  }
}
