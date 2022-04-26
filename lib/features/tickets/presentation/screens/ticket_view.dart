import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mivent/features/events/presentation/screens/event_details.dart';
import 'package:mivent/features/tickets/domain/models/ticket.dart';
import 'package:mivent/features/tickets/presentation/widgets/ticket_widget.dart';
import 'package:mivent/global/presentation/theme/text_styles.dart';
import 'package:mivent/global/presentation/widgets/ink_material.dart';

class TicketFullView extends StatefulWidget {
  static const routeName = '/ticket_full_view';
  const TicketFullView({Key? key}) : super(key: key);

  @override
  State<TicketFullView> createState() => _TicketFullViewState();
}

class _TicketFullViewState extends State<TicketFullView> {
  late Ticket ticket;

  @override
  void didChangeDependencies() {
    ticket = ModalRoute.of(context)!.settings.arguments as Ticket;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        IgnorePointer(child: Container(color: Colors.black54)),
        Positioned.fill(
          child: SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 32),
                Expanded(
                  child: AspectRatio(
                    aspectRatio: TicketWidget.defaultAspectRatio,
                    child: Hero(
                      tag: 'event_${ticket.event!.id}_ticket_${ticket.id}',
                      createRectTween: ((begin, end) =>
                          RectTween(begin: begin, end: end)),
                      flightShuttleBuilder: (_, anim, __, ___, ____) =>
                          InkMaterial(
                        child: AnimatedBuilder(
                          animation: anim,
                          builder: (_, __) => TicketWidget(
                            ticket,
                            pixelScale: lerpDouble(0.6, 1.125, anim.value)!,
                          ),
                        ),
                      ),
                      child: InkMaterial(
                        child: TicketWidget(ticket,
                            pixelScale: 1.125,
                            shadows: const [
                              Shadow(blurRadius: 8, color: Colors.black54)
                            ],
                            stub: null

                            ///TODO: add QR code here
                            ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    primary: Colors.white,
                    textStyle: TextStyles.subHeader1,
                    side: const BorderSide(width: 2, color: Colors.white),
                  ),
                  child: const Text('Open Event'),
                  onPressed: () {
                    Navigator.of(context).pushNamed(
                        EventDetailsScreen.routeName,
                        arguments: ticket.event);
                  },
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
