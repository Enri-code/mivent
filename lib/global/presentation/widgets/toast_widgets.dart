import 'package:flutter/material.dart';
import 'package:mivent/global/data/toast.dart';
import 'package:mivent/global/presentation/theme/colors.dart';
import 'package:mivent/global/presentation/theme/text_styles.dart';

class ToastWidget extends StatelessWidget {
  const ToastWidget({
    Key? key,
    required this.title,
    this.body,
    this.color = ColorPalette.primary,
    this.icon = Icons.info_outline_rounded,
    this.canRemove = true,
    this.iconSize = 32,
    this.onTap,
    this.onTapCancel,
  }) : super(key: key);

  final String title;
  final String? body;
  final bool canRemove;
  final Color color;
  final IconData icon;
  final double iconSize;
  final Function()? onTap, onTapCancel;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Color.lerp(color, Colors.white, 0.4)!,
          width: 2,
        ),
        color: Color.lerp(color, const Color(0xECFFFFFF), 0.9),
        boxShadow: const [
          BoxShadow(blurRadius: 16, spreadRadius: 2, color: Colors.black12)
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
              child: Icon(icon, size: iconSize, color: color),
            ),
            Expanded(
              child: ConstrainedBox(
                constraints:
                    const BoxConstraints(minHeight: 56, maxHeight: 160),
                child: (body?.isEmpty ?? true)
                    ? Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          title,
                          style: TextStyles.subHeader2.copyWith(fontSize: 18),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.only(top: 14, bottom: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(title,
                                style: TextStyles.subHeader2.copyWith(
                                  fontSize: 18,
                                )),
                            const SizedBox(height: 6),
                            Text(
                              body!,
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 16, height: 1.2),
                            ),
                          ],
                        ),
                      ),
              ),
            ),
            if (canRemove)
              Center(
                child: GestureDetector(
                  child: const Icon(Icons.close, size: 26),
                  onTap: () {
                    ToastManager.remove();
                    onTapCancel?.call();
                  },
                ),
              )
            else
              const SizedBox(width: 16),
            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }
}
