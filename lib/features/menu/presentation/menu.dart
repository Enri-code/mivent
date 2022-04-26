import 'package:flutter/material.dart';
import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:mivent/features/auth/data/models/user_type_model.dart';
import 'package:mivent/features/auth/domain/entities/user_type.dart';
import 'package:mivent/features/cart/presentation/bloc/ticket_cart_bloc.dart';
import 'package:mivent/features/store/presentation/bloc/events_store.dart';
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
  int currentPage = 0;
  bool isHost = false;

  @override
  void initState() {
    context.read<EventStore>();
    context.read<TicketCartBloc>();
    Hive.box('user').put('signed_in', true);
    imageCache!.clearLiveImages();
    imageCache!.clear();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    isHost = UserTypeModel.fromString(Hive.box('user')
        .get('user_type', defaultValue: 'attender') as String) is HostUser;
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
          child: FadeIndexedStack(
            index: currentPage,
            children: [
              const DicoverPage(),
              // ignore: prefer_const_constructors
              YourEventsPage(),
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
                icon: const Icon(MiventIcons.compass, size: 26),
                title: const Text('Discover'),
              ),
              TabData(
                icon: const Icon(Icons.event, size: 27),
                title: const Text('Your Events'),
                onclick: () {},
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
            onTabChangedListener: (index) =>
                setState(() => currentPage = index),
          ),
        ),
      ),
    );
  }
}
