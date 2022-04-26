import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mivent/core/utils/initializers/fire_initializer.dart';
import 'package:mivent/core/utils/initializers/hive_initializer.dart';
import 'package:mivent/core/utils/initializers/status_bar_initializer.dart';
import 'package:mivent/core/utils/initializers/user_initializer.dart';

import 'package:mivent/features/auth/data/repos/fire_auth_repo.dart';
import 'package:mivent/features/auth/data/repos/hive_user_store.dart';
import 'package:mivent/features/auth/presentation/bloc/bloc.dart';
import 'package:mivent/features/auth/presentation/screens/onboard.dart';
import 'package:mivent/features/cart/data/cart.dart';
import 'package:mivent/features/cart/presentation/bloc/base_bloc/bloc.dart';
import 'package:mivent/features/cart/presentation/bloc/ticket_cart_bloc.dart';
import 'package:mivent/features/events/domain/entities/event.dart';
import 'package:mivent/features/store/data/fire_storage.dart';
import 'package:mivent/features/store/data/hive_storage.dart';
import 'package:mivent/features/store/data/merged_store.dart';
import 'package:mivent/features/store/presentation/bloc/base_bloc/bloc.dart';
import 'package:mivent/features/store/presentation/bloc/events_store.dart';
import 'package:mivent/features/menu/presentation/menu.dart';
import 'package:mivent/features/tickets/domain/models/ticket.dart';
import 'package:mivent/global/presentation/theme/theme_data.dart';
import 'package:mivent/global/presentation/screens/unknown_page.dart';

void main() async {
  await HiveInitializer.mainInit();
  await LocalStoreInitializer.init(HiveUserStore());
  runApp(App(signedIn: LocalStoreInitializer.signedIn));
  FireInitializer.mainInit();
}

class App extends StatefulWidget {
  const App({Key? key, required this.signedIn}) : super(key: key);
  final bool signedIn;

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> with WidgetsBindingObserver {
  @override
  initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    StatusBarInitializer.instance().mainInit();
    if (!widget.signedIn) {
      precacheImage(const AssetImage('assets/images/host.png'), context);
      precacheImage(const AssetImage('assets/images/guest.png'), context);
    }
  }

  @override
  dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    HiveInitializer.dispose();
    super.dispose();
  }

  @override
  didChangeAppLifecycleState(AppLifecycleState state) {
    StatusBarInitializer.instance().update(state);
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
            create: (_) => AuthBloc(FireAuth(HiveUserStore.instance)),
            lazy: false),
        BlocProvider<TicketCartBloc>(
          create: (_) => CartBloc(Cart(HiveStore<Ticket>('tickets'))),
          lazy: !widget.signedIn,
        ),
        BlocProvider<EventStore>(
          create: (_) => StoreBloc(MergedStore(HiveStore<Event>('saved_events'),
              remoteStore:
                  FirestoreStore<Event>('saved_events', privateToUser: true))),
          lazy: !widget.signedIn,
        ),
      ],
      child: MaterialApp(
        title: ThemeSettings.appName,
        theme: ThemeSettings.myTheme,
        locale: const Locale('en', 'NG'),
        supportedLocales: const [Locale('en', 'NG')],
        debugShowCheckedModeBanner: false,
        routes: ThemeSettings.routes
            .map((key, value) => MapEntry(key, (_) => value)),
        onUnknownRoute: (settings) => PageRouteBuilder(
          pageBuilder: (_, __, ___) => const UnknownPage(),
        ),
        home: widget.signedIn ? const MenuScreen() : const OnboardScreen(),
      ),
    );
  }
}
