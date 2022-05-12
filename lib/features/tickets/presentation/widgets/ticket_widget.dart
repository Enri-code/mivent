import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:mivent/core/utils/extensions/num_to_currency.dart';
import 'package:mivent/features/tickets/presentation/painters/ticket.dart';
import 'package:mivent/global/presentation/theme/text_styles.dart';
import 'package:mivent/features/tickets/domain/entities/ticket.dart';
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

  final Widget? stub;
  final Ticket? ticket;
  final double pixelScale;
  final Color? outlineColor;
  final List<Shadow> shadows;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: TicketPainter(
          outlineColor: outlineColor,
          stubRatio: 0.45,
          edgeCurveRadius: 20 * pixelScale,
          shadows: shadows),
      child: _TicketTemplate(
        stub: stub,
        ticket: ticket,
        pixelScale: pixelScale,
      ),
    );
  }
}

class _TicketTemplate extends StatefulWidget {
  const _TicketTemplate({
    Key? key,
    required this.pixelScale,
    required this.stub,
    required this.ticket,
  }) : super(key: key);

  final double pixelScale;
  final Widget? stub;
  final Ticket? ticket;

  @override
  State<_TicketTemplate> createState() => _TicketTemplateState();
}

class _TicketTemplateState extends State<_TicketTemplate> {
  @override
  Widget build(BuildContext context) {
    var color = Colors.blue[50];
    var imageGetter =
        widget.ticket!.imageGetter ?? widget.ticket!.event.imageGetter;

    return ClipPath(
      clipper: TicketClipper(
        stubRatio: 0.45,
        edgeCurveRadius: 20 * widget.pixelScale,
      ),
      child: Container(
        color: color,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(32 * widget.pixelScale),
              child: widget.stub ??
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
                    child: FutureBuilder<Uint8List?>(
                      future: Future.value(imageGetter),
                      builder: (_, snap) => snap.hasData
                          ? ImageFrame(image: MemoryImage(snap.data!))
                          : const ImageFrame(),
                    ),
                  ),
                  FractionallySizedBox(
                    heightFactor: 0.4,
                    alignment: Alignment.topCenter,
                    child: Container(
                      padding: EdgeInsets.fromLTRB(
                          12 * widget.pixelScale,
                          14 * widget.pixelScale,
                          20 * widget.pixelScale,
                          10 * widget.pixelScale),
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
                              48 * widget.pixelScale, 32 * widget.pixelScale),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              if (widget.ticket!.name.isNotEmpty)
                                Text(
                                  widget.ticket!.name,
                                  style: TextStyles.header4
                                      .copyWith(
                                      fontSize: 21 * widget.pixelScale),
                                  textAlign: TextAlign.end,
                                ),
                            ],
                          ),
                          Text(
                            widget.ticket!.event.name,
                            style: TextStyles.subHeader2
                                .copyWith(fontSize: 16.5 * widget.pixelScale),
                            textAlign: TextAlign.end,
                          ),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                widget.ticket?.price.nairaString ?? '',
                                style: TextStyles.header4
                                    .copyWith(fontSize: 21 * widget.pixelScale),
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
    );
  }
}
