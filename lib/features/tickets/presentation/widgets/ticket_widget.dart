import 'package:flutter/material.dart';
import 'package:mivent/core/utils/extensions/num_to_currency.dart';
import 'package:mivent/features/menu/presentation/painters/ticket.dart';
import 'package:mivent/global/presentation/theme/text_styles.dart';
import 'package:mivent/features/tickets/domain/models/ticket.dart';
import 'package:mivent/global/presentation/widgets/image_frame.dart';

/*
class _HoricontalTicketWidget extends StatelessWidget {
  const _HoricontalTicketWidget(this.ticket, {Key? key}) : super(key: key);

  final Ticket? ticket;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2.75,
      child: CustomPaint(
        painter: TicketPainter(ticketTopRatio: 0.73),
        child: ClipPath(
          clipper: TicketClipper(ticketTopRatio: 0.73),
          child: Container(
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      FractionallySizedBox(
                        widthFactor: 0.55,
                        alignment: Alignment.centerLeft,
                        child: ImageFrame(
                          image: ticket!.image ??
                              ticket!.event?.image ??
                              const AssetImage(
                                  'assets/images/ticket_default.png'),
                        ),
                      ),
                      FractionallySizedBox(
                        widthFactor: 0.55,
                        alignment: Alignment.centerRight,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(32),
                            ),
                          ),
                          child: Column(
                            children: [
                              Text(
                                ticket?.event?.name ?? 'Loading...',
                                style: TextStyles.subHeader2,
                              ),
                              Text(ticket?.event?.location ?? ''),
                              Text(ticket?.event?.dates?.range ?? ''),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: const [
                        Expanded(child: Icon(Icons.image, size: 64)),
                        Text(
                          'This should be kept private',
                          style: TextStyle(fontSize: 10, height: .92),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
 */

class TicketWidget extends StatelessWidget {
  const TicketWidget(
    this.ticket, {
    Key? key,
    this.stub,
    this.outlineColor = Colors.white,
  }) : super(key: key);

  final Ticket? ticket;
  final Color outlineColor;
  final Widget? stub;

  @override
  Widget build(BuildContext context) {
    var color = Colors.white;
    return CustomPaint(
      painter: TicketPainter(
          outlineColor: outlineColor, stubRatio: 0.4, edgeCurveRadius: 20),
      child: ClipPath(
        clipper: TicketClipper(stubRatio: 0.4, edgeCurveRadius: 20),
        child: Container(
          color: color,
          child: Column(
            children: [
              Expanded(
                flex: 2,
                child: stub ?? const SizedBox(),
              ),
              Expanded(
                flex: 3,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    FractionallySizedBox(
                      heightFactor: 0.55,
                      alignment: Alignment.bottomCenter,
                      child: ImageFrame(
                        image: ticket!.image ??
                            ticket!.event?.image ??
                            const AssetImage(
                                'assets/images/ticket_default.png'),
                      ),
                    ),
                    FractionallySizedBox(
                      heightFactor: 0.54,
                      alignment: Alignment.topCenter,
                      child: Container(
                        padding: const EdgeInsets.only(bottom: 2),
                        decoration: const BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(38)),
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 8,
                                offset: Offset(0, -4),
                                color: Colors.black26)
                          ],
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: const BorderRadius.only(
                              bottomRight: Radius.circular(40),
                            ),
                          ),
                          child: DefaultTextStyle(
                            style: const TextStyle(
                                fontSize: 16, color: Colors.black),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 8, bottom: 4),
                                  child: Text(
                                    ticket!.name,
                                    style: TextStyles.header4,
                                    textAlign: TextAlign.end,
                                  ),
                                ),
                                Text(
                                  ticket!.event?.name ?? '',
                                  style: TextStyles.subHeader2,
                                  textAlign: TextAlign.end,
                                ),
                                Text(
                                  ticket?.event?.location ?? '',
                                  textAlign: TextAlign.end,
                                ),
                                Text(
                                  ticket?.event?.dates?.range ?? '',
                                  textAlign: TextAlign.end,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Center(
                                    child: Text(
                                      ticket?.price.nairaString ?? '',
                                      style: TextStyles.header4,
                                      textAlign: TextAlign.end,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
