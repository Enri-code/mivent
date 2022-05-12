import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mivent/app.dart';

import 'package:mivent/core/utils/helpers/fire_helpers.dart';
import 'package:mivent/core/utils/helpers/hive_initializer.dart';
//import 'package:mivent/core/utils/helpers/status_bar_initializer.dart';
import 'package:mivent/features/auth/data/repos/fire_auth_repo.dart';
import 'package:mivent/features/auth/data/repos/hive_user_store.dart';
import 'package:mivent/features/auth/domain/repos/user_store.dart';
import 'package:mivent/features/auth/presentation/bloc/bloc.dart';
import 'package:mivent/features/cart/data/repos/cart.dart';
import 'package:mivent/features/cart/presentation/bloc/base_bloc/bloc.dart';
import 'package:mivent/features/cart/presentation/bloc/ticket_cart_bloc.dart';
import 'package:mivent/features/encryptor/data/encryptor.dart';
import 'package:mivent/features/encryptor/domain/encryptor.dart';
import 'package:mivent/features/events/data/fire_repo/events.dart';
import 'package:mivent/features/events/data/fire_repo/get_details.dart';
import 'package:mivent/features/events/domain/entities/event.dart';
import 'package:mivent/features/events/domain/repos/get_details.dart';
import 'package:mivent/features/events/presentation/bloc/event/event_bloc.dart';
import 'package:mivent/features/store/data/hive_storage.dart';
import 'package:mivent/features/store/data/merged_store.dart';
import 'package:mivent/features/store/data/stores/fire_event_store.dart';
import 'package:mivent/features/store/data/stores/fire_ticket_orders_store.dart';
import 'package:mivent/features/store/data/stores/mixins.dart';
import 'package:mivent/features/tickets/domain/entities/owned_ticket.dart';
import 'package:mivent/features/tickets/domain/entities/ticket.dart';
import 'package:mivent/features/transactions/data/repos/manager.dart';
import 'package:mivent/features/transactions/domain/repos/manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveInitializer.mainInit();
  IUserStore store = HiveUserStore();
  await store.init();
  FireSetup.mainInit();
  runApp(App(userStore: store));
}

class App extends StatelessWidget {
  const App({Key? key, required this.userStore}) : super(key: key);
  final IUserStore userStore;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<IUserStore>.value(value: userStore),
        RepositoryProvider<IEncryptor>(create: (_) => AESEncryptor()),
        RepositoryProvider<IEventDetails>(create: (_) => FireEventDetails()),
        RepositoryProvider<IPurchaseManager>(
          create: (context) => PurchaseManager(),
          lazy: !userStore.isSignedIn,
        ),
        RepositoryProvider<AttendingEventsStore>(
          create: (context) => MergedStore<Event>(
            localStore: HiveStore('attending_events', selfInit: false),
            remoteStore: FireEventStorage(
              'attending_events',
              autoUpdate: false,
            ),
          ),
          lazy: !userStore.isSignedIn,
        ),
        RepositoryProvider<SavedEventsStore>(
          create: (context) => MergedStore<Event>(
            localStore: HiveStore('saved_events', selfInit: false),
            remoteStore: FireEventStorage('saved_events', autoUpdate: false),
          ),
          lazy: !userStore.isSignedIn,
        ),
        RepositoryProvider(
          create: (context) => MergedStore<OwnedTicket>(
            localStore: HiveStore('ticket_orders', selfInit: false),
            remoteStore: FireOwnedTicketStorage(context.read<IEncryptor>()),
          ),
          lazy: !userStore.isSignedIn,
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            create: (context) =>
                AuthBloc(FireAuth(context.read<IUserStore>()), context.read),
            lazy: false,
          ),
          BlocProvider<TicketCartBloc>(
            create: (context) => CartBloc(Cart(HiveStore<Ticket>('tickets'))),
            lazy: !userStore.isSignedIn,
          ),
          BlocProvider(
            create: (context) => EventsBloc(context.read,
                eventMan: FireEventManager(context.read)),
          ),
        ],
        child: const Mivent(),
      ),
    );
  }
}
