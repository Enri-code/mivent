import 'package:flutter/material.dart';

class ImageFrame extends StatelessWidget {
  const ImageFrame({Key? key, this.image}) : super(key: key);

  final ImageProvider<Object>? image;

  static const _decoration = BoxDecoration(
    color: Colors.white,
    gradient: RadialGradient(
      colors: [Color(0xFFFCC6FF), Color(0xFFD28EFF)],
    ),
  );
  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.cover,
      clipBehavior: Clip.hardEdge,
      child: Image(
        image: image ?? const AssetImage(''),
        frameBuilder: (_, child, frame, alreadyLoaded) {
          if (alreadyLoaded) return child;
          return AnimatedCrossFade(
            alignment: Alignment.center,
            crossFadeState: frame == null
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            duration: const Duration(milliseconds: 500),
            firstChild: Container(
              padding: const EdgeInsets.all(12),
              decoration: _decoration,
              child: const Icon(
                Icons.broken_image_outlined,
                color: Colors.white,
              ),
            ),
            secondChild: child,
          );
        },
        errorBuilder: (_, __, ___) => Container(
          padding: const EdgeInsets.all(12),
          decoration: _decoration,
          child: const Icon(Icons.broken_image_outlined, color: Colors.white),
        ),
      ),
    );
  }
}
