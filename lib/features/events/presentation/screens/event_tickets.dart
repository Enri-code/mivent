import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:mivent/core/utils/definitions.dart';
import 'package:mivent/features/auth/presentation/bloc/bloc.dart';
import 'package:mivent/features/cart/presentation/bloc/base_bloc/bloc.dart';
import 'package:mivent/features/cart/presentation/bloc/ticket_cart_bloc.dart';
import 'package:mivent/features/events/domain/entities/event.dart';
import 'package:mivent/features/events/domain/failure_causes.dart';
import 'package:mivent/features/events/domain/repos/get_details.dart';
import 'package:mivent/features/events/presentation/bloc/event/event_bloc.dart';
import 'package:mivent/global/data/toast.dart';

import 'package:mivent/global/presentation/theme/colors.dart';
import 'package:mivent/global/presentation/theme/mivent_icons.dart';
import 'package:mivent/global/presentation/theme/text_styles.dart';
import 'package:mivent/global/presentation/widgets/app_bar.dart';
import 'package:mivent/global/presentation/widgets/safe_scaffold.dart';

import 'package:mivent/features/tickets/domain/entities/ticket.dart';
import 'package:mivent/features/tickets/presentation/widgets/ticket_widget.dart';

class EventTicketsScreen extends StatefulWidget {
  static const route = '/event_tickets';
  const EventTicketsScreen({Key? key}) : super(key: key);

  @override
  State<EventTicketsScreen> createState() => _EventTicketsScreenState();
}

class _EventTicketsScreenState extends State<EventTicketsScreen> {
  final pageController = PageController(viewportFraction: .94);

  bool anyChosen = false, anyBuyableChosen = false;

  ///TODO: [hasError] UI isn't ready
  bool hasError = false;
  List<Ticket>? tickets;
  late Event event;
  late List<int> ticketAmounts;

  void _updateButtons() {
    setState(() => anyBuyableChosen = anyChosen = false);
    for (var i = 0; i < tickets!.length; i++) {
      if (anyChosen && anyBuyableChosen) break;
      if (ticketAmounts[i] > 0) {
        setState(() => anyChosen = true);
        if (!tickets![i].isFree) {
          setState(() => anyBuyableChosen = true);
          break;
        }
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (tickets == null) {
      event = ModalRoute.of(context)!.settings.arguments as Event;
      context.read<IEventDetails>().getRemoteEventTickets(event).then((value) {
        if (mounted) {
          value.fold(
            (l) => setState(() => hasError = true),
            (r) => setState(() {
              tickets = r;
              ticketAmounts = List.filled(tickets!.length, 0);
            }),
          );
        }
      });
    }
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
            child: () {
              if (hasError) {
                return Center(
                    child: Text(
                  'An error occured',
                  style: TextStyles.header4.copyWith(color: Colors.white),
                ));
              }
              if (tickets == null) {
                return const Center(child: CircularProgressIndicator());
              }
              if (tickets!.isEmpty) {
                return Center(
                    child: Text(
                  "This event doesn't have any tickets",
                  style: TextStyles.header4.copyWith(color: Colors.white),
                ));
              }
              return PageView.builder(
                padEnds: false,
                itemCount: tickets!.length,
                controller: pageController,
                scrollDirection: Axis.vertical,
                itemBuilder: (_, i) => Padding(
                  padding: const EdgeInsets.only(top: 12, bottom: 32),
                  child: Center(
                    child: _TicketButton(
                      ticket: tickets![i],
                      onChange: (amount) {
                        ticketAmounts[i] = amount;
                        _updateButtons();
                      },
                    ),
                  ),
                ),
              );
            }(),
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
                        color: anyBuyableChosen ? Colors.black : Colors.grey,
                      ),
                    ),
                    onPressed: anyBuyableChosen
                        ? () {
                            var added = false;
                            for (var i = 0; i < tickets!.length; i++) {
                              if (ticketAmounts[i] > 0 && !tickets![i].isFree) {
                                added = true;
                                context.read<TicketCartBloc>().add(AddItemEvent(
                                    tickets![i],
                                    amount: ticketAmounts[i]));
                                ticketAmounts[i] = 0;
                              }
                            }
                            if (!added) return;
                            ToastManager.success(title: 'Tickets added');
                            //_updateButtons();
                          }
                        : null,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          MiventIcons.ticket_cart,
                          color: anyBuyableChosen ? Colors.black : Colors.grey,
                        ),
                        const SizedBox(width: 8),
                        const Text('Add to cart',
                            style: TextStyle(fontWeight: FontWeight.w400)),
                        const SizedBox(width: 8),
                      ],
                    ),
                  ),
                ),
                BlocListener<EventsBloc, EventsState>(
                  listener: (context, state) {
                    if (state.status == OperationStatus.minorFail) {
                      if (state.failure!.cause is GetTicketsFailure) {
                        ToastManager.error(
                          title: "Error getting tickets",
                          body: state.failure?.message,
                        );
                      }
                    } else if (state.status == OperationStatus.success) {}
                  },
                  child: const SizedBox(width: 20),
                ),
                Expanded(
                  child: Hero(
                    tag: 'checkout_button',
                    transitionOnUserGestures: true,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: ColorPalette.secondaryColor,
                      ),
                      onPressed: anyChosen
                          ? () {
                              if (context.read<AuthBloc>().state.user == null ||
                                  tickets == null) return;

                              var items = [
                                for (var i = 0; i < tickets!.length; i++)
                                  if (ticketAmounts[i] > 0)
                                    tickets![i]
                                      ..update(amount: ticketAmounts[i])
                              ];
                              if (items.isNotEmpty) {
                                context
                                    .read<EventsBloc>()
                                    .add(GetTicketsEvent(items));
                              }
                            }
                          : null,
                      child: const Text('Get tickets'),
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

  _reset() {
    setState(() {
      selected = false;
      amount = 1;
    });
    widget.onChange(0);
    updateKeepAlive();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var items = context.read<TicketCartBloc>().items;
    var ticketIndex = items.indexOf(widget.ticket);
    var ticket =
        ticketIndex < 0 ? widget.ticket : items[ticketIndex] as Ticket;
    return AspectRatio(
      aspectRatio: TicketWidget.defaultAspectRatio,
      child: Stack(
        children: [
          BlocListener<EventsBloc, EventsState>(
            listener: (_, state) {
              if (!selected) return;
              if (state.status == OperationStatus.success) _reset();
            },
            child: BlocListener<TicketCartBloc, CartState>(
              listener: (_, state) {
                if (!selected) return;
                if (state.status == OperationStatus.success) {
                  if (!ticket.isFree) _reset();
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
                                      onTap: amount > 1
                                          ? () {
                                              setState(() => amount--);
                                              widget.onChange(amount);
                                            }
                                          : null,
                                      child: const Icon(
                                        Icons.arrow_left_rounded,
                                        color: Colors.white,
                                        size: 38,
                                      ),
                                    ),
                                    Text(amount.toString()),
                                    GestureDetector(
                                      onTap: amount < ticket.amountBuyable
                                          ? () {
                                              setState(() => amount++);
                                              widget.onChange(amount);
                                            }
                                          : null,
                                      child: const Icon(
                                        Icons.arrow_right_rounded,
                                        color: Colors.white,
                                        size: 38,
                                      ),
                                    ),
                                  ],
                                )
                              else
                                const Padding(
                                  padding:
                                      EdgeInsets.only(right: 12, bottom: 8),
                                  child: Text('1 ticket'),
                                ),
                              if ((ticket.unitsLeft ?? 110) <= 100)
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text('|  ${ticket.unitsLeft!} left  '),
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
                            onPressed: () {
                              //TODO: share button
                            },
                          ),
                        ),
                      ],
                    ),
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
              onTap: ticket.amountBuyable > 0
                  ? () {
                      setState(() => selected = !selected);
                      widget.onChange(selected ? amount : 0);
                      updateKeepAlive();
                    }
                  : null,
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
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => selected;
}
