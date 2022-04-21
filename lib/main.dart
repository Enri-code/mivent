import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mivent/core/utils/hive_adapters/cart.dart';
import 'package:mivent/features/auth/bloc/bloc.dart';
import 'package:mivent/features/auth/data/fire_auth_repo.dart';
import 'package:mivent/features/cart/data/cart.dart';
import 'package:mivent/features/cart/presentation/bloc/cart_bloc/bloc.dart';
import 'package:mivent/features/cart/presentation/bloc/ticket_cart_bloc.dart';
import 'package:mivent/features/menu/presentation/menu.dart';
import 'package:mivent/features/onboard/presentation/screens/onboard.dart';
import 'package:mivent/global/presentation/theme/colors.dart';
import 'package:mivent/global/presentation/theme/theme_data.dart';

import 'firebase_options.dart';
import 'package:mivent/global/presentation/screens/unknown_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(CartItemsAdapter());
  var box = await Hive.openBox('user');
  runApp(App(firstTime: box.get('first_time', defaultValue: true)));
}

class App extends StatefulWidget {
  const App({Key? key, required this.firstTime}) : super(key: key);
  final bool firstTime;

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> with WidgetsBindingObserver {
  bool? _useWhiteStatusBarForeground;

  @override
  initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    Firebase.initializeApp(
        name: 'mivent-app', options: DefaultFirebaseOptions.currentPlatform);

    WidgetsBinding.instance!.addObserver(this);
    FlutterStatusbarcolor.setStatusBarColor(ColorPalette.appBarColor).then((_) {
      if (useWhiteForeground(ColorPalette.appBarColor)) {
        FlutterStatusbarcolor.setStatusBarWhiteForeground(true);
        _useWhiteStatusBarForeground = true;
      } else {
        FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
        _useWhiteStatusBarForeground = false;
      }
    });
    if (widget.firstTime) {
      precacheImage(const AssetImage('assets/images/host.png'), context);
      precacheImage(const AssetImage('assets/images/guest.png'), context);
    }
  }

  @override
  dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    Hive.close();
    super.dispose();
  }

  @override
  didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed &&
        _useWhiteStatusBarForeground != null) {
      FlutterStatusbarcolor.setStatusBarWhiteForeground(
          _useWhiteStatusBarForeground!);
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthBloc(FireAuth())),
        BlocProvider<TicketCartBloc>(
          create: (_) => CartBloc(HiveCart('tickets')),
        ),
      ],
      child: MaterialApp(
        title: ThemeSettings.appName,
        theme: ThemeSettings.myTheme,
        locale: const Locale('en', 'NG'),
        supportedLocales: const [
          Locale('en', 'NG'),
        ],
        routes: ThemeSettings.routes
            .map((key, value) => MapEntry(key, (_) => value)),
        /* onGenerateRoute: (settings) => PageRouteBuilder(
          settings: settings,
          transitionDuration: const Duration(milliseconds: 400),
          pageBuilder: (_, __, ___) => AppData.routes[settings.name]!,
          transitionsBuilder: (_, _anim, __, child) {
            var anim = CurvedAnimation(parent: _anim, curve: Curves.easeIn);
            return SlideTransition(
                position: Tween(begin: const Offset(1, 0), end: Offset.zero)
                    .animate(anim),
                child: FadeTransition(opacity: anim, child: child));
          },
        ), */
        onUnknownRoute: (settings) => PageRouteBuilder(
          pageBuilder: (_, __, ___) => const UnknownPage(),
        ),
        home: widget.firstTime ? const OnboardScreen() : const MenuScreen(),
      ),
    );
  }
}
