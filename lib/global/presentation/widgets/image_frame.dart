import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';

class ImageFrame extends StatelessWidget {
  const ImageFrame({Key? key, this.image, this.placeHolder, this.iconData})
      : super(key: key);

  final Widget? placeHolder;
  final IconData? iconData;
  final ImageProvider<Object>? image;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.cover,
      clipBehavior: Clip.hardEdge,
      child: image == null
          ? placeHolder ??
              _ImageFrameBG(
                child:
                    Icon(iconData ?? Icons.image_outlined, color: Colors.white),
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
                  firstChild: const _ImageFrameBG(
                    child:
                        Icon(Icons.image_search_rounded, color: Colors.white),
                  ),
                  secondChild: child,
                );
              },
              errorBuilder: (_, __, ___) => const _ImageFrameBG(
                child: Icon(Icons.broken_image_outlined, color: Colors.white),
              ),
            ),
    );
  }
}

class ImageFutureFrame extends StatelessWidget {
  const ImageFutureFrame(this.future, {Key? key}) : super(key: key);
  final FutureOr<Uint8List?>? future;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List?>(
      future: Future.value(future),
      builder: (_, res) {
        if (res.hasData) {
          return ImageFrame(image: MemoryImage(res.data!));
        }
        if (res.hasError) {
          return const ImageFrame(iconData: Icons.broken_image_outlined);
        }
        if (future == null) {
          return const ImageFrame(iconData: Icons.image_outlined);
        }
        return const ImageFrame(iconData: Icons.image_search_outlined);
      },
    );
  }
}

class _ImageFrameBG extends StatelessWidget {
  const _ImageFrameBG({Key? key, this.child}) : super(key: key);
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
