import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mivent/core/utils/helpers/hive_initializer.dart';
import 'package:mivent/features/auth/domain/repos/user_store.dart';
import 'package:mivent/features/auth/presentation/bloc/bloc.dart';
import 'package:mivent/features/auth/presentation/screens/onboard.dart';
import 'package:mivent/features/events/presentation/bloc/event/event_bloc.dart';
import 'package:mivent/features/menu/presentation/menu.dart';
import 'package:mivent/features/store/data/merged_store.dart';
import 'package:mivent/features/store/data/stores/mixins.dart';
import 'package:mivent/features/tickets/domain/entities/owned_ticket.dart';
import 'package:mivent/features/transactions/domain/repos/manager.dart';
import 'package:mivent/global/data/app_data.dart';
import 'package:mivent/global/data/toast.dart';
import 'package:mivent/global/presentation/theme/theme_data.dart';
import 'package:mivent/global/presentation/screens/unknown_page.dart';
import 'package:upgrader/upgrader.dart';

class Mivent extends StatefulWidget {
  const Mivent({Key? key}) : super(key: key);

  @override
  State<Mivent> createState() => _MiventState();
}

class _MiventState extends State<Mivent> with WidgetsBindingObserver {
  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    //StatusBarInitializer.instance().mainInit();
    if (!context.read<IUserStore>().isSignedIn) {
      precacheImage(
          const AssetImage('assets/images/onboard_host.jpg'), context);
      precacheImage(
          const AssetImage('assets/images/onboard_guest.jpg'), context);
    }
  }

  @override
  dispose() {
    WidgetsBinding.instance.removeObserver(this);
    HiveInitializer.dispose();
    super.dispose();
  }

  @override
  didChangeAppLifecycleState(AppLifecycleState state) {
    //StatusBarInitializer.instance().update(state);
    if (state == AppLifecycleState.paused) {
      context.read<EventsBloc>().backup();
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (previous, current) =>
          current.justSignedIn != previous.justSignedIn,
      listener: (context, state) {
        if (state.justSignedIn) {
          print('getting remote data');
          context.read<SavedEventsStore>().getRemoteIDs();
          context.read<AttendingEventsStore>().getRemoteIDs();
          context.read<MergedStore<OwnedTicket>>().getRemoteIDs();
        }
      },
      child: MaterialApp(
        title: AppSettings.appName,
        theme: ThemeSettings.myTheme,
        debugShowCheckedModeBanner: false,
        locale: const Locale('en', 'NG'),
        supportedLocales: const [Locale('en', 'NG')],
        routes: ThemeSettings.routes.map(
          (key, value) => MapEntry(key, (_) => value),
        ),
        onUnknownRoute: (settings) => PageRouteBuilder(
          pageBuilder: (_, anim, ___) => FadeTransition(
            opacity: anim,
            child: const UnknownPage(),
          ),
        ),
        home: Builder(builder: (context) {
          ToastManager.init(context);
          context.read<IPurchaseManager>().setNavContext(context);
          return UpgradeAlert(
            child: context.read<IUserStore>().isSignedIn
                ? const MenuScreen()
                : const OnboardScreen(),
          );
        }),
      ),
    );
  }
}
