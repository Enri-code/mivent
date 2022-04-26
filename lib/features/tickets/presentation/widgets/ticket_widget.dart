import 'package:flutter/material.dart';
import 'package:mivent/core/utils/extensions/num_to_currency.dart';
import 'package:mivent/features/tickets/presentation/painters/ticket.dart';
import 'package:mivent/global/presentation/theme/text_styles.dart';
import 'package:mivent/features/tickets/domain/models/ticket.dart';
import 'package:mivent/global/presentation/widgets/image_frame.dart';

class TicketWidget extends StatelessWidget {
  static const defaultAspectRatio = 0.475;
  const TicketWidget(
    this.ticket, {
    Key? key,
    this.stub,
    this.outlineColor,
    this.pixelScale = 1,
    this.shadows = const [],
  }) : super(key: key);

  final double pixelScale;
  final List<Shadow> shadows;
  final Ticket? ticket;
  final Color? outlineColor;
  final Widget? stub;

  @override
  Widget build(BuildContext context) {
    var color = Colors.blue[50];
    return CustomPaint(
      painter: TicketPainter(
          outlineColor: outlineColor,
          stubRatio: 0.45,
          edgeCurveRadius: 20 * pixelScale,
          shadows: shadows),
      child: ClipPath(
        clipper: TicketClipper(
          stubRatio: 0.45,
          edgeCurveRadius: 20 * pixelScale,
        ),
        child: Container(
          color: color,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(32 * pixelScale),
                child: stub ??
                    AspectRatio(
                      aspectRatio: 1,
                      child: Container(color: Colors.white54),
                    ),
              ),
              Expanded(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    FractionallySizedBox(
                      heightFactor: 0.7,
                      alignment: Alignment.bottomCenter,
                      child: ImageFrame(
                        image: ticket!.image ??
                            ticket!.event?.image ??
                            const AssetImage(
                                'assets/images/ticket_default.png'),
                      ),
                    ),
                    FractionallySizedBox(
                      heightFactor: 0.4,
                      alignment: Alignment.topCenter,
                      child: Container(
                        padding: EdgeInsets.fromLTRB(12 * pixelScale,
                            14 * pixelScale, 20 * pixelScale, 10 * pixelScale),
                        decoration: BoxDecoration(
                          color: color,
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              offset: Offset(0, 4),
                              blurRadius: 4,
                            )
                          ],
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.elliptical(
                                48 * pixelScale, 32 * pixelScale),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                if (ticket!.name.isNotEmpty)
                                  Text(
                                    ticket!.name,
                                    style: TextStyles.header4
                                        .copyWith(fontSize: 21 * pixelScale),
                                    textAlign: TextAlign.end,
                                  ),
                              ],
                            ),
                            Text(
                              ticket!.event?.name ?? '',
                              style: TextStyles.subHeader2
                                  .copyWith(fontSize: 16.5 * pixelScale),
                              textAlign: TextAlign.end,
                            ),
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text(
                                  ticket?.price.nairaString ?? '',
                                  style: TextStyles.header4
                                      .copyWith(fontSize: 21 * pixelScale),
                                ),
                              ),
                            ),
                          ],
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
