import 'package:flutter/material.dart';
import 'package:mivent/global/presentation/widgets/app_bar.dart';
import 'package:mivent/global/presentation/widgets/safe_scaffold.dart';

import 'package:photo_view/photo_view.dart';

class ImageFullViewData {
  const ImageFullViewData({this.image, this.heroTag, this.placeHolder});

  final String? heroTag;
  final Widget? placeHolder;
  final ImageProvider<Object>? image;
}

class ImageFullView extends StatelessWidget {
  static const route = '/image_full_view';
  const ImageFullView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var data = ModalRoute.of(context)?.settings.arguments as ImageFullViewData;
    return SafeScaffold(
      child: Stack(
        fit: StackFit.expand,
        children: [
          PhotoView(
            minScale: PhotoViewComputedScale.contained,
            maxScale: PhotoViewComputedScale.covered * 2,
            heroAttributes: data.heroTag != null
                ? PhotoViewHeroAttributes(tag: data.heroTag!)
                : null,
            imageProvider: data.image,
            loadingBuilder: (_, __) =>
                data.placeHolder ??
                const Center(child: CircularProgressIndicator()),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: NavAppBar(
              foregroundColor: Colors.white,
              backgroundColor: Colors.black26,
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ],
      ),
    );
  }
}
