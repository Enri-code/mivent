import 'package:flutter/material.dart';

class ImageFrame extends StatelessWidget {
  const ImageFrame({Key? key, this.image}) : super(key: key);

  final ImageProvider<Object>? image;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.cover,
      clipBehavior: Clip.hardEdge,
      child: image == null
          ? const ImageFrameBG(
              child: Icon(Icons.event_outlined, color: Colors.white),
            )
          : Image(
              image: image!,
              frameBuilder: (_, child, frame, alreadyLoaded) {
                if (alreadyLoaded) return child;
                return AnimatedCrossFade(
                  alignment: Alignment.center,
                  crossFadeState: frame == null
                      ? CrossFadeState.showFirst
                      : CrossFadeState.showSecond,
                  duration: const Duration(milliseconds: 500),
                  firstChild: const ImageFrameBG(
                    child:
                        Icon(Icons.image_search_rounded, color: Colors.white),
                  ),
                  secondChild: child,
                );
              },
              errorBuilder: (_, __, ___) => const ImageFrameBG(
                child: Icon(Icons.broken_image_outlined, color: Colors.white),
              ),
            ),
    );
  }
}

class ImageFrameBG extends StatelessWidget {
  const ImageFrameBG({Key? key, this.child}) : super(key: key);
  final Widget? child;

  static const _decoration = BoxDecoration(
    color: Colors.white,
    gradient: RadialGradient(
      colors: [Color(0xFFFCC6FF), Color(0xFFD28EFF)],
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Container(
        clipBehavior: Clip.hardEdge,
        padding: const EdgeInsets.all(12),
        decoration: _decoration,
        child: child);
  }
}
