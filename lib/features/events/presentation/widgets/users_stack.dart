import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';

class UsersStack extends StatelessWidget {
  const UsersStack(this.imageProvidersFutures, {Key? key, this.size = 24})
      : super(key: key);
  final double size;
  final List<FutureOr<Uint8List?>> imageProvidersFutures;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: List.generate(
        imageProvidersFutures.length,
        (i) => FutureBuilder<Uint8List?>(
          future: Future.value(imageProvidersFutures[i]),
          builder: (_, snap) {
            if (snap.hasData) {
              return _CircleContainer(
                  size: size, offset: i * size * 0.8, imageBytes: snap.data!);
            }
            return _CircleContainer(size: size, offset: i * size * 0.8);
          },
        ),
      ),
    );
  }
}

class _CircleContainer extends StatelessWidget {
  const _CircleContainer({
    Key? key,
    required this.size,
    required this.offset,
    this.imageBytes,
  }) : super(key: key);

  final double size, offset;
  final Uint8List? imageBytes;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      margin: EdgeInsets.only(left: offset),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(width: 2, color: Colors.white),
        image: imageBytes != null
            ? DecorationImage(image: MemoryImage(imageBytes!))
            : null,
      ),
    );
  }
}
