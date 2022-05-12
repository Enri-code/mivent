import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mivent/features/cart/presentation/bloc/ticket_cart_bloc.dart';
import 'package:mivent/features/tickets/domain/entities/ticket.dart';
import 'package:mivent/features/tickets/presentation/screens/ticket_cart.dart';
import 'package:mivent/features/tickets/presentation/screens/ticket_view.dart';
import 'package:mivent/features/tickets/presentation/widgets/ticket_widget.dart';
import 'package:mivent/global/presentation/theme/colors.dart';
import 'package:mivent/global/presentation/theme/mivent_icons.dart';
import 'package:mivent/global/presentation/theme/text_styles.dart';
import 'package:mivent/global/presentation/widgets/ink_material.dart';
import 'package:mivent/global/presentation/widgets/safe_scaffold.dart';

class TicketsPage extends StatelessWidget {
  const TicketsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var cartItemAmount = context.watch<TicketCartBloc>().items.length;
    return DefaultTabController(
      length: 2,
      child: SafeScaffold(
        appBar: AppBar(
          elevation: 8,
          shadowColor: Colors.black26,
          toolbarHeight: 100,
          flexibleSpace: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 20, bottom: 4),
                    child: Center(
                      child: Text('Your Tickets', style: TextStyles.header4),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Stack(
                        children: [
                          IconButton(
                            iconSize: 29,
                            icon: const Icon(MiventIcons.ticket_cart),
                            onPressed: () => Navigator.of(context)
                                .pushNamed(TicketCartScreen.route),
                          ),
                          if (cartItemAmount > 0)
                            Positioned(
                              bottom: 3,
                              right: 4,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.red,
                                ),
                                child: Text(
                                  cartItemAmount.toString(),
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const TabBar(
                indicatorWeight: 3,
                labelStyle: TextStyles.subHeader1,
                labelColor: Color(0xFF582F7E),
                labelPadding: EdgeInsets.zero,
                unselectedLabelColor: Color(0xFFB298CA),
                padding: EdgeInsets.symmetric(horizontal: 16),
                indicatorColor: ColorPalette.primary,
                indicatorSize: TabBarIndicatorSize.label,
                tabs: [
                  Tab(text: '  Upcoming  '),
                  Tab(text: '  Expired  '),
                ],
              ),
            ],
          ),
        ),
        child: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          children: [
            const _UpcomingTickets(),
            Container(),
          ],
        ),
      ),
    );
  }
}

class _UpcomingTickets extends StatelessWidget {
  const _UpcomingTickets({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: 24,
      crossAxisSpacing: 32,
      childAspectRatio: TicketWidget.defaultAspectRatio,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      children: const [],
    );
  }
}

// ignore: unused_element
class _TicketButton extends StatelessWidget {
  const _TicketButton(this.ticket, {Key? key}) : super(key: key);
  final Ticket ticket;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Hero(
        tag: 'event_${ticket.event.id}_ticket_${ticket.id}',
        createRectTween: ((begin, end) => RectTween(begin: begin, end: end)),
        child: InkMaterial(
          child: TicketWidget(ticket,
              pixelScale: 0.6,
              shadows: const [Shadow(blurRadius: 8, color: Colors.black54)],
              stub: null //add QR code here
              ),
        ),
      ),
      onTap: () {
        Navigator.of(context).push(
          PageRouteBuilder(
            settings: RouteSettings(arguments: ticket),
            pageBuilder: (_, anim, __) => const TicketFullView(),
            transitionsBuilder: (_, anim, __, child) =>
                FadeTransition(opacity: anim, child: child),
            opaque: false,
            maintainState: true,
            barrierDismissible: true,
          ),
        );
      },
    );
  }
}
