import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mivent/core/services/media.dart';
import 'package:mivent/core/utils/enums.dart';
import 'package:mivent/features/cart/presentation/bloc/base_bloc/bloc.dart';
import 'package:mivent/features/cart/presentation/bloc/ticket_cart_bloc.dart';
import 'package:mivent/features/share/data/models/ticket.dart';
import 'package:mivent/features/tickets/presentation/widgets/ticket_widget.dart';
import 'package:mivent/global/presentation/theme/colors.dart';
import 'package:mivent/global/presentation/theme/mivent_icons.dart';
import 'package:mivent/global/presentation/theme/text_styles.dart';
import 'package:mivent/features/events/domain/entities/event.dart';
import 'package:mivent/features/tickets/domain/models/ticket.dart';
import 'package:mivent/samples/data.dart';
import 'package:mivent/global/presentation/widgets/app_bar.dart';
import 'package:mivent/global/presentation/widgets/safe_scaffold.dart';

class EventTicketsScreen extends StatefulWidget {
  static const routeName = '/event_tickets';
  const EventTicketsScreen({Key? key}) : super(key: key);

  @override
  State<EventTicketsScreen> createState() => _EventTicketsScreenState();
}

class _EventTicketsScreenState extends State<EventTicketsScreen> {
  final pageController = PageController(viewportFraction: .94);

  List<Ticket> tickets = List.from(SampleData.tickets);
  late List<int> ticketAmounts;
  Event? event;
  late bool anyChosen;

  @override
  void didChangeDependencies() {
    event ??= ModalRoute.of(context)!.settings.arguments as Event;
    ticketAmounts = List.filled(tickets.length, 0);
    anyChosen = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeScaffold(
      backgroundColor: Colors.blueGrey[900],
      appBar: NavAppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.transparent,
        title: const Text('Select your tickets'),
        onPressed: () => Navigator.of(context).pop(),
      ),
      child: Column(
        children: [
          Expanded(
            flex: 5,
            child: PageView.builder(
              padEnds: false,
              itemCount: tickets.length,
              controller: pageController,
              scrollDirection: Axis.vertical,
              itemBuilder: (_, i) => Padding(
                padding: const EdgeInsets.only(top: 12, bottom: 32),
                child: Center(
                  child: _TicketButton(
                    ticket: tickets[i],
                    onChange: (amount) {
                      ticketAmounts[i] = amount;
                      setState(
                          () => anyChosen = ticketAmounts.any((e) => e > 0));
                    },
                  ),
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(blurRadius: 12, color: Colors.black38)],
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      primary: Colors.black,
                      side: BorderSide(
                        width: 2,
                        color: anyChosen ? Colors.black : Colors.grey,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          MiventIcons.ticket_cart,
                          color: anyChosen ? Colors.black : Colors.grey,
                        ),
                        const SizedBox(width: 8),
                        const Text('Add to cart',
                            style: TextStyle(fontWeight: FontWeight.w400)),
                        const SizedBox(width: 8),
                      ],
                    ),
                    onPressed: anyChosen
                        ? () {
                            for (var i = 0; i < tickets.length; i++) {
                              if (ticketAmounts[i] > 0 && !tickets[i].isFree) {
                                context.read<TicketCartBloc>().add(AddEvent(
                                    tickets[i],
                                    amount: ticketAmounts[i]));
                              }
                            }
                          }
                        : null,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Hero(
                    tag: 'checkout_button',
                    transitionOnUserGestures: true,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: ColorPalette.secondaryColor,
                      ),
                      child: const Text('Get tickets now'),
                      onPressed: anyChosen ? () {} : null,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TicketButton extends StatefulWidget {
  const _TicketButton({
    Key? key,
    required this.ticket,
    required this.onChange,
  }) : super(key: key);

  final Ticket ticket;
  final Function(int amount) onChange;

  @override
  State<_TicketButton> createState() => _TicketButtonState();
}

class _TicketButtonState extends State<_TicketButton>
    with AutomaticKeepAliveClientMixin {
  int amount = 1;
  bool selected = false;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var _items = context.read<TicketCartBloc>().items;
    var _ticketIndex = _items.indexOf(widget.ticket);
    var ticket =
        _ticketIndex < 0 ? widget.ticket : _items[_ticketIndex] as Ticket;
    return AspectRatio(
      aspectRatio: TicketWidget.defaultAspectRatio,
      child: Stack(
        children: [
          BlocListener<TicketCartBloc, CartState>(
            listenWhen: (prev, current) =>
                prev.status == OperationStatus.loading,
            listener: (_, state) {
              if (!selected) return;
              if (state.status == OperationStatus.success) {
                if (!ticket.isFree) {
                  setState(() {
                    selected = false;
                    amount = 1;
                  });
                  updateKeepAlive();
                }
              } else {
                //Notify error
              }
            },
            child: Align(
              alignment: Alignment.bottomCenter,
              child: AnimatedOpacity(
                duration: kTabScrollDuration,
                opacity: selected ? 1 : 0,
                curve: Curves.easeIn,
                child: DefaultTextStyle(
                  style: TextStyles.subHeader2,
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      if (ticket.isAvailable)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (ticket.amountBuyable > 1)
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  GestureDetector(
                                    child: const Icon(
                                      Icons.arrow_left_rounded,
                                      color: Colors.white,
                                      size: 38,
                                    ),
                                    onTap: amount > 1
                                        ? () {
                                            setState(() => amount--);
                                            widget.onChange(amount);
                                          }
                                        : null,
                                  ),
                                  Text(amount.toString()),
                                  GestureDetector(
                                    child: const Icon(
                                      Icons.arrow_right_rounded,
                                      color: Colors.white,
                                      size: 38,
                                    ),
                                    onTap: amount < ticket.amountBuyable
                                        ? () {
                                            setState(() => amount++);
                                            widget.onChange(amount);
                                          }
                                        : null,
                                  ),
                                ],
                              )
                            else
                              const Padding(
                                padding: EdgeInsets.only(right: 12, bottom: 8),
                                child: Text('1 ticket'),
                              ),
                            if ((ticket.leftInStock ?? 110) <= 100)
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('|  ${ticket.leftInStock!} left  '),
                                  if (ticket.amountBuyable <= 1)
                                    const SizedBox(height: 8),
                                ],
                              ),
                          ],
                        )
                      else
                        const Padding(
                          padding: EdgeInsets.only(bottom: 6),
                          child:
                              Text('Sold Out!', style: TextStyles.subHeader1),
                        ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: IconButton(
                          color: Colors.white,
                          padding: const EdgeInsets.only(bottom: 1),
                          icon: const Icon(Icons.share),
                          onPressed: () =>
                              MediaService.shareText(ShareableTicket(ticket)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          AnimatedScale(
            scale: selected ? 0.925 : 1,
            curve: Curves.easeOutBack,
            alignment: Alignment.topCenter,
            duration: kTabScrollDuration,
            child: GestureDetector(
              child: Opacity(
                opacity: ticket.amountBuyable > 0 ? 1 : 0.5,
                child: TicketWidget(
                  widget.ticket,
                  outlineColor: selected ? ColorPalette.primary : null,
                  shadows: const [Shadow(blurRadius: 16)],
                  stub: AspectRatio(
                    aspectRatio: 1,
                    child: Container(
                      color: Colors.grey[50]!,
                      child: Center(
                        child: Text(
                          'Your unique QR code\nwill appear here.\n\n Show it at the party entrance\nto get in',
                          textAlign: TextAlign.center,
                          style: TextStyles.subHeader2
                              .copyWith(color: Colors.grey),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              onTap: ticket.amountBuyable > 0
                  ? () {
                      setState(() => selected = !selected);
                      widget.onChange(selected ? amount : 0);
                      updateKeepAlive();
                    }
                  : null,
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => selected;
}
