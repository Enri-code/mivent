import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mivent/features/cart/presentation/bloc/cart_bloc/bloc.dart';
import 'package:mivent/features/cart/presentation/bloc/ticket_cart_bloc.dart';
import 'package:mivent/features/tickets/presentation/widgets/ticket_widget.dart';
import 'package:mivent/global/presentation/theme/colors.dart';
import 'package:mivent/global/presentation/theme/text_styles.dart';
import 'package:mivent/features/events/domain/models/event.dart';
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
  Event? event;
  List<Ticket> tickets = List.from(SampleData.tickets);

  @override
  void didChangeDependencies() {
    event ??= ModalRoute.of(context)!.settings.arguments as Event;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var ticketAmounts = List.filled(tickets.length, 0);

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
            child: ListView.builder(
              clipBehavior: Clip.none,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.all(16),
              itemCount: tickets.length,
              shrinkWrap: tickets.length == 1,
              itemBuilder: (_, i) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: _TicketButton(
                  ticket: tickets[i],
                  onChange: (amount) {
                    ticketAmounts[i] = amount;
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      primary: Colors.white,
                      side: const BorderSide(color: Colors.white, width: 2),
                    ),
                    child: const Text('Add to cart'),
                    onPressed: () {
                      for (var i = 0; i < tickets.length; i++) {
                        if (ticketAmounts[i] > 0) {
                          context
                              .read<TicketCartBloc>()
                              .add(AddEvent(tickets[i]));
                        }
                      }
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Hero(
                    tag: 'checkout_button',
                    transitionOnUserGestures: true,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: ColorPalette.secondaryColor),
                      child: const Text('Get tickets now'),
                      onPressed: () {},
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
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
  static const _duration = Duration(milliseconds: 200);

  var amount = 1;
  var selected = false;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return AspectRatio(
      aspectRatio: 1 / 2.2,
      child: Stack(
        children: [
          BlocListener<TicketCartBloc, CartState>(
            listenWhen: (prev, current) =>
                prev.status == CartOperationStatus.loading &&
                prev.status == CartOperationStatus.success,
            listener: (_, __) => setState(() => selected = false),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: AnimatedOpacity(
                duration: _duration,
                opacity: selected ? 1 : 0,
                curve: Curves.easeIn,
                child: DefaultTextStyle(
                  style: TextStyles.subHeader2,
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      if (!widget.ticket.isFree)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 3),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text('Amount:',
                                  style: TextStyles.subHeader2),
                              GestureDetector(
                                child: const Icon(
                                  Icons.arrow_left_rounded,
                                  color: Colors.white,
                                  size: 32,
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
                                  size: 32,
                                ),
                                onTap: amount < 10
                                    ? () {
                                        setState(() => amount++);
                                        widget.onChange(amount);
                                      }
                                    : null,
                              ),
                              if (widget.ticket.leftInStock != null)
                                Text(
                                    'out  of  ${widget.ticket.leftInStock!.toString}'),
                              if (widget.ticket.leftInStock != null)
                                const SizedBox(width: 24),
                            ],
                          ),
                        ),
                      if (widget.ticket.isFree)
                        const Padding(
                          padding: EdgeInsets.only(bottom: 8),
                          child:
                              Text('1 ticket', style: TextStyle(fontSize: 20)),
                        ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: IconButton(
                          color: Colors.white,
                          icon: const Icon(Icons.share),
                          onPressed: () {
                            //TODO: share dynamic link
                          },
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
            duration: _duration,
            child: GestureDetector(
              child: TicketWidget(
                widget.ticket,
                outlineColor: selected ? ColorPalette.primary : Colors.white,
                //TODO: qr code of dynamic link to the ticket
                stub: Container(
                  margin: const EdgeInsets.fromLTRB(0, 24, 0, 16),
                  padding: const EdgeInsets.all(8.0),
                  color: Colors.grey[200]!,
                  child: const AspectRatio(
                    aspectRatio: 1,
                    child: Center(
                      child: Text(
                        'Your QR code will be here.\n\n Show it at the party entrance',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
              onTap: () {
                setState(() => selected = !selected);
                widget.onChange(selected ? amount : 0);
                updateKeepAlive();
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => selected;
}
