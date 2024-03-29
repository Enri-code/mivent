import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mivent/core/utils/definitions.dart';
import 'package:mivent/features/cart/presentation/bloc/base_bloc/bloc.dart';
import 'package:mivent/features/cart/presentation/bloc/ticket_cart_bloc.dart';
import 'package:mivent/features/events/domain/failure_causes.dart';
import 'package:mivent/features/events/presentation/bloc/event/event_bloc.dart';
import 'package:mivent/features/tickets/domain/entities/ticket.dart';
import 'package:mivent/features/tickets/presentation/widgets/ticket_widget.dart';
import 'package:mivent/global/data/toast.dart';
import 'package:mivent/global/presentation/theme/mivent_icons.dart';
import 'package:mivent/global/presentation/theme/text_styles.dart';
import 'package:mivent/global/presentation/widgets/app_bar.dart';
import 'package:mivent/global/presentation/widgets/safe_scaffold.dart';

class TicketCartScreen extends StatefulWidget {
  static const route = '/ticket_cart';
  const TicketCartScreen({Key? key}) : super(key: key);

  @override
  State<TicketCartScreen> createState() => _TicketCartScreenState();
}

class _TicketCartScreenState extends State<TicketCartScreen> {
  final _listKey = GlobalKey<AnimatedListState>();

  @override
  Widget build(BuildContext context) {
    var items = context.watch<TicketCartBloc>().items.cast<Ticket>();
    return SafeScaffold(
      appBar: NavAppBar(
        title: const Text('Checkout'),
        onPressed: () => Navigator.of(context).pop(),
      ),
      child: Column(
        children: [
          Expanded(
            child: Stack(
              alignment: AlignmentDirectional.center,
              children: [
                if (items.isNotEmpty)
                  AnimatedList(
                    key: _listKey,
                    shrinkWrap: items.length == 1,
                    initialItemCount: items.length,
                    clipBehavior: Clip.none,
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemBuilder: (_, i, __) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: _TicketItem(
                        items[i],
                        onItemRemoved: () {
                          _listKey.currentState!.removeItem(
                            i,
                            (_, anim) {
                              return SlideTransition(
                                position: CurvedAnimation(
                                        parent: anim,
                                        curve: const Interval(0, 0.6))
                                    .drive(
                                  Tween(
                                      begin: const Offset(0, 1.1),
                                      end: Offset.zero),
                                ),
                                child: SizeTransition(
                                  sizeFactor: CurvedAnimation(
                                      parent: anim,
                                      curve: const Interval(0.5, 1)),
                                  axis: Axis.horizontal,
                                  child: FadeTransition(
                                    opacity: anim,
                                    child: _TicketItem(items[i]),
                                  ),
                                ),
                              );
                            },
                            duration: const Duration(milliseconds: 400),
                          );
                        },
                      ),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(32),
                  child: AnimatedOpacity(
                    duration: kTabScrollDuration,
                    opacity: items.isEmpty ? 1 : 0,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "You don't have any ticket in your cart!",
                          style: TextStyles.header4.copyWith(height: 2),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32),
                        const FractionallySizedBox(
                          widthFactor: 0.3,
                          child: FittedBox(
                            child: Icon(MiventIcons.ticket_cart,
                                color: Colors.grey),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          AnimatedSlide(
            offset: items.isEmpty ? const Offset(0, 1) : Offset.zero,
            duration: kThemeChangeDuration,
            child: Container(
              height: 190,
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.fromLTRB(36, 14, 36, 16),
              decoration: BoxDecoration(
                color: Colors.blueGrey[900],
                boxShadow: const [
                  BoxShadow(blurRadius: 12, color: Colors.black38)
                ],
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(32)),
              ),
              child: DefaultTextStyle(
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w500),
                child: Builder(
                  builder: (context) {
                    var amount =
                        items.fold<int>(0, (prev, e) => prev + e.amount);
                    var ticketText = 'ticket${amount == 1 ? '' : 's'}';
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Content :',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w400),
                            ),
                            Text(
                              '$amount $ticketText${items.length > 1
                                      ? '  |  ${items.length} types'
                                      : ''}',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                        const Divider(color: Colors.white, height: 2),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Total :',
                                style: TextStyle(fontSize: 16)),
                            Text(
                              context.read<TicketCartBloc>().totalPrice,
                              style: const TextStyle(fontSize: 17),
                            ),
                          ],
                        ),
                        BlocListener<EventsBloc, EventsState>(
                          listener: (context, state) {
                            if (state.status == OperationStatus.minorFail) {
                              if (state.failure!.cause is GetTicketsFailure) {
                                ToastManager.error(
                                  title: "Couldn't get tickets",
                                  body: state.failure?.message ??
                                      'There was a problem purchasing these tickets. Please try again later',
                                );
                              }
                            } else if (state.status ==
                                OperationStatus.success) {}
                          },
                          child: const SizedBox(width: 20),
                        ),
                        FractionallySizedBox(
                          widthFactor: 1.07,
                          child: ElevatedButton(
                            child: Text('Buy $ticketText'),
                            onPressed: () {
                              context
                                  .read<EventsBloc>()
                                  .add(GetTicketsEvent(items));
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TicketItem extends StatefulWidget {
  const _TicketItem(this.ticket, {Key? key, this.onItemRemoved})
      : super(key: key);

  final Ticket ticket;
  final VoidCallback? onItemRemoved;

  @override
  State<_TicketItem> createState() => _TicketItemState();
}

class _TicketItemState extends State<_TicketItem> {
  late int amount;
  @override
  void initState() {
    amount = widget.ticket.amount;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: TicketWidget.defaultAspectRatio,
      child: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 44),
            child: AspectRatio(
              aspectRatio: TicketWidget.defaultAspectRatio,
              child: TicketWidget(
                widget.ticket,
                pixelScale: 0.9,
                shadows: const [Shadow(blurRadius: 8, color: Colors.black54)],
                stub: AspectRatio(
                  aspectRatio: 1,
                  child: Container(
                    color: Colors.grey[50]!,
                    child: Center(
                      child: Text(
                        'Your unique QR code\nwill appear here.\n\n Show it at the party entrance\nto get in',
                        textAlign: TextAlign.center,
                        style:
                            TextStyles.subHeader2.copyWith(color: Colors.grey),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (widget.ticket.isAvailable)
            DefaultTextStyle(
              style: TextStyles.subHeader2.copyWith(color: Colors.black),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: amount > 1
                            ? () {
                                setState(() => amount--);
                                widget.ticket.update(amount: amount);
                                context
                                    .read<TicketCartBloc>()
                                    .add(UpdateItemEvent(widget.ticket));
                              }
                            : null,
                        child: const Icon(Icons.arrow_left_rounded, size: 39),
                      ),
                      Text(amount.toString(), style: TextStyles.header4),
                      GestureDetector(
                        onTap: amount < widget.ticket.maxBuyable
                            ? () {
                                setState(() => amount++);
                                widget.ticket.update(amount: amount);
                                context
                                    .read<TicketCartBloc>()
                                    .add(UpdateItemEvent(widget.ticket));
                              }
                            : null,
                        child: const Icon(Icons.arrow_right_rounded, size: 39),
                      ),
                    ],
                  ),
                  if ((widget.ticket.unitsLeft ?? 110) <= 100)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 1),
                      child: Text(
                        '|  ${widget.ticket.unitsLeft!} left  ',
                        style: TextStyles.subHeader2,
                      ),
                    ),
                ],
              ),
            )
          else
            const Padding(
              padding: EdgeInsets.only(bottom: 9),
              child: Text('Sold Out!', style: TextStyles.subHeader1),
            ),
          Align(
            alignment: Alignment.bottomRight,
            child: IconButton(
              iconSize: 30,
              padding: const EdgeInsets.only(bottom: 3),
              icon: const Icon(Icons.delete_forever, color: Colors.red),
              onPressed: () {
                context
                    .read<TicketCartBloc>()
                    .add(RemoveItemEvent(widget.ticket));
                widget.onItemRemoved?.call();
              },
            ),
          ),
        ],
      ),
    );
  }
}
