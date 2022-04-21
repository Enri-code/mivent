import 'package:flutter/material.dart';
import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:mivent/features/auth/bloc/bloc.dart';
import 'package:mivent/features/auth/domain/entities/user_type.dart';
import 'package:mivent/features/cart/presentation/bloc/cart_bloc/bloc.dart';
import 'package:mivent/features/cart/presentation/bloc/ticket_cart_bloc.dart';
import 'package:mivent/features/menu/presentation/screens/account.dart';
import 'package:mivent/features/menu/presentation/screens/discover.dart';
import 'package:mivent/features/menu/presentation/screens/manage.dart';
import 'package:mivent/features/menu/presentation/screens/tickets.dart';
import 'package:mivent/features/menu/presentation/screens/your_events.dart';
import 'package:mivent/features/menu/presentation/widgets/fade_indexed_stack.dart';
import 'package:mivent/global/presentation/theme/mivent_icons.dart';

class MenuScreen extends StatefulWidget {
  static const routeName = '/menu';
  const MenuScreen({Key? key}) : super(key: key);

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  late int currentPage;
  bool isHost = false;

  @override
  void initState() {
    super.initState();
    isHost = (context.read<AuthBloc>().user?.type ?? false) == const HostUser();
    currentPage = 0;
    context.read<TicketCartBloc>().add(InitEvent());
    Hive.box('user').put('first_time', false);
    imageCache!.clearLiveImages();
    imageCache!.clear();
  }

  @override
  Widget build(BuildContext context) {
    isHost = (context.read<AuthBloc>().user?.type ?? false) == const HostUser();
    return WillPopScope(
      onWillPop: () {
        if (currentPage != 0) {
          setState(() => currentPage = 0);
          return Future.value(false);
        } else {
          return Future.value(true);
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: FadeIndexedStack(
            index: currentPage,
            children: [
              const DicoverPage(),
              const YourEventsPage(),
              const TicketsPage(),
              if (isHost) const ManageEventsPage() else const AccountPage(),
            ],
          ),
        ),
        bottomNavigationBar: DefaultTextStyle(
          style: const TextStyle(
            fontSize: 15.5,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
          child: FancyBottomNavigation(
            selection: currentPage,
            tabs: [
              TabData(
                icon: const Icon(MiventIcons.compass_outlined),
                title: const Text('Discover'),
              ),
              TabData(
                icon: const Icon(Icons.event),
                title: const Text('Your Events'),
              ),
              TabData(
                //TODO: get a ticket icon
                icon: const Icon(Icons.airplane_ticket_outlined),
                title: const Text('Tickets'),
              ),
              if (isHost)
                TabData(
                  icon: const Icon(MiventIcons.event_planning),
                  title: const Text('Manage'),
                )
              else
                TabData(
                  icon: const Icon(MiventIcons.user),
                  title: const Text('You'),
                ),
            ],
            onTabChangedListener: (index) =>
                setState(() => currentPage = index),
          ),
        ),
      ),
    );
  }
}
