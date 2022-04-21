import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:boxy/boxy.dart';

class _ScrollSliverDelegate extends SliverBoxyDelegate {
  _ScrollSliverDelegate({this.overlapPadding = 30, this.headerMinHeight = 0});
  final double overlapPadding, headerMinHeight;
  double? headerHeight;

  @override
  SliverGeometry layout() {
    final header = getChild(#header) as BoxyChild;
    final body = getChild(#body) as BoxyChild;

    if (headerHeight == null) {
      headerHeight = header.layout(constraints.asBoxConstraints()).height;
    } else {
      var height =
          headerHeight! - constraints.scrollOffset.clamp(0, headerHeight!);
      if (height >= headerMinHeight) {
        header.layoutRect(
          Offset.zero & Size(constraints.crossAxisExtent, height),
        );
      } else {
        header.layoutRect(
          Offset(0, height - headerMinHeight) &
              Size(constraints.crossAxisExtent, headerMinHeight),
        );
      }
    }
    body.position(header.rect.bottomLeft - Offset(0, overlapPadding));
    body.layout(constraints.asBoxConstraints());

    var fullHeight = body.size.height + headerHeight! - overlapPadding;

    var geometry = SliverGeometry(
      scrollExtent: fullHeight,
      paintExtent: constraints.remainingPaintExtent,
      cacheExtent: constraints.remainingCacheExtent,
      hitTestExtent: constraints.remainingPaintExtent,
      maxPaintExtent: max(fullHeight, constraints.remainingPaintExtent),
    );
    return geometry;
  }
}

class OverlappedHeaderScrollView extends StatefulWidget {
  const OverlappedHeaderScrollView({
    Key? key,
    required this.header,
    required this.body,
    this.headerMinHeight = 90,
    this.clipBehaviour = Clip.hardEdge,
  }) : super(key: key);

  final Clip clipBehaviour;
  final double headerMinHeight;
  final Widget header, body;

  @override
  State<OverlappedHeaderScrollView> createState() =>
      _OverlappedHeaderScrollViewState();
}

class _OverlappedHeaderScrollViewState
    extends State<OverlappedHeaderScrollView> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      clipBehavior: widget.clipBehaviour,
      slivers: [
        CustomBoxy.sliver(
          delegate:
              _ScrollSliverDelegate(headerMinHeight: widget.headerMinHeight),
          children: [
            BoxyId(
              id: #header,
              child: SizedBox(width: double.infinity, child: widget.header),
            ),
            BoxyId(id: #body, child: widget.body),
          ],
        ),
      ],
    );
  }
}
