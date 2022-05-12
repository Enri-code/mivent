import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';

import 'package:mivent/features/auth/domain/entities/user_type.dart';
import 'package:mivent/features/auth/domain/repos/user_store.dart';
import 'package:mivent/features/auth/presentation/bloc/bloc.dart';
import 'package:mivent/features/cart/presentation/bloc/ticket_cart_bloc.dart';
import 'package:mivent/features/events/data/fire_repo/preview/discover_events/popular_events.dart';
import 'package:mivent/features/events/data/fire_repo/preview/discover_events/random.dart';
import 'package:mivent/features/events/data/fire_repo/sections.dart';
import 'package:mivent/features/events/domain/repos/sections.dart';
import 'package:mivent/features/events/presentation/bloc/event/event_bloc.dart';
import 'package:mivent/features/events/presentation/bloc/remote_events_bloc/remote_events_bloc.dart';
import 'package:mivent/features/menu/presentation/screens/account.dart';
import 'package:mivent/features/menu/presentation/screens/discover.dart';
import 'package:mivent/features/menu/presentation/screens/manage.dart';
import 'package:mivent/features/menu/presentation/screens/tickets.dart';
import 'package:mivent/features/menu/presentation/screens/your_events.dart';
import 'package:mivent/features/menu/presentation/widgets/fade_indexed_stack.dart';
import 'package:mivent/global/presentation/theme/mivent_icons.dart';

class MenuScreen extends StatefulWidget {
  static const route = '/menu';
  const MenuScreen({Key? key}) : super(key: key);

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  int currentPage = 0;
  bool isHost = false;

  @override
  void initState() {
    context.read<EventsBloc>();
    context.read<TicketCartBloc>();
    context.read<IUserStore>().isSignedIn = true;
    imageCache.clearLiveImages();
    imageCache.clear();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    isHost = context.watch<AuthBloc>().userType is HostUser;
    if (isHost) currentPage = 3;
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
          child: RepositoryProvider<IRemoteEventsProvider>(
            create: (context) => FireEventsProvider(context.read),
            child: FadeIndexedStack(
              index: currentPage,
              children: [
                BlocProvider<GetRemoteEventsBloc>(
                  create: (context) => GetRemoteEventsBloc([
                    FirePopularEventsRepo(
                      context.read<IRemoteEventsProvider>()
                          as FireEventsProvider,
                    ),
                    FireRandomEventsRepo(
                      context.read<IRemoteEventsProvider>()
                          as FireEventsProvider,
                    ),
                    //context.read<IEventsProvider>().randomRepo,
                  ]),
                  child: const DiscoverPage(),
                ),
                // ignore: prefer_const_constructors
                YourEventsPage(),
                const TicketsPage(),
                if (isHost) const ManageEventsPage() else const AccountPage(),
              ],
            ),
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
                icon: const Icon(MiventIcons.compass, size: 26),
                title: const Text('Discover'),
              ),
              TabData(
                icon: const Icon(Icons.event, size: 27),
                title: const Text('Your Events'),
              ),
              TabData(
                icon: const Icon(MiventIcons.ticket, size: 18),
                title: const Text('Tickets'),
              ),
              if (isHost)
                TabData(
                  icon: const Icon(MiventIcons.edit_event, size: 22),
                  title: const Text('Manage'),
                )
              else
                TabData(
                  icon: const Icon(MiventIcons.user, size: 21),
                  title: const Text('You'),
                ),
            ],
            onTabChangedListener: (i) => setState(() => currentPage = i),
          ),
        ),
      ),
    );
  }
}
