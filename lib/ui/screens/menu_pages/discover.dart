import 'package:flutter/material.dart';
import 'package:mivent/models/event.dart';
import 'package:mivent/samples/data.dart';
import 'package:mivent/theme/text_styles.dart';
import 'package:mivent/ui/widgets/text_fields.dart';

class DicoverPage extends StatelessWidget {
  const DicoverPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Events For You',
                      style: TextStyles.header1.copyWith(
                        fontFamily: FontFamily.chuckry,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const SizedBox(
                    height: 64,
                    child: TextFormWidget(
                      label: 'Find amazing mivents...',
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 24, right: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Popular', style: TextStyles.header2),
                  TextButton(
                    child: const Text('View more'),
                    //TODO: open more
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 320,
              child: ListView.builder(
                //clipBehavior: Clip.none,
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(left: 8),
                itemCount: SampleData.popularEventsPreview.length,
                itemBuilder: (_, i) =>
                    EventCard(SampleData.popularEventsPreview[i]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EventCard extends StatelessWidget {
  const EventCard(this.data, {Key? key}) : super(key: key);
  final Event data;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 0.96,
      child: Container(
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey[300]!, width: 2),
          borderRadius: BorderRadius.circular(24),
          boxShadow: const [BoxShadow(blurRadius: 12, color: Colors.black12)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: data.image != null ? null : const EdgeInsets.all(6),
              decoration: BoxDecoration(
                gradient: data.image != null
                    ? null
                    : RadialGradient(colors: [Colors.white, Colors.grey[100]!]),
                borderRadius:
                    data.image != null ? null : BorderRadius.circular(16),
                border: data.image != null
                    ? null
                    : Border.all(
                        color: Colors.grey[200]!,
                        width: 8,
                      ),
                boxShadow: const [
                  BoxShadow(blurRadius: 6, color: Colors.black38)
                ],
              ),
              child: AspectRatio(
                aspectRatio: 3 / 2,
                child: data.image != null
                    ? Image(image: data.image!)
                    : const Icon(
                        Icons.image_search,
                        size: 100,
                        color: Colors.grey,
                      ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12, right: 4),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          data.name,
                          style: TextStyles.body1.copyWith(
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      SwitchWidget(
                        offWidget: const Icon(Icons.favorite_border),
                        onWidget: const Icon(Icons.favorite),
                        onSwitched: (val) {},
                      ),
                    ],
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

class SwitchWidget extends StatefulWidget {
  const SwitchWidget({
    Key? key,
    required this.offWidget,
    required this.onWidget,
    required this.onSwitched,
    this.initialState = false,
  }) : super(key: key);

  final bool initialState;
  final Widget offWidget, onWidget;
  final Function(bool) onSwitched;

  @override
  State<SwitchWidget> createState() => _SwitchWidgetState();
}

class _SwitchWidgetState extends State<SwitchWidget> {
  late bool state;
  @override
  void initState() {
    super.initState();
    state = widget.initialState;
  }

  @override
  Widget build(BuildContext context) {
    const _dur = Duration(milliseconds: 300);
    return Material(
      type: MaterialType.transparency,
      child: InkResponse(
        containedInkWell: true,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: [
              AnimatedOpacity(
                duration: _dur,
                opacity: state ? 1 : 0,
                child: widget.onWidget,
              ),
              AnimatedOpacity(
                duration: _dur,
                opacity: state ? 0 : 1,
                child: widget.offWidget,
              ),
            ],
          ),
        ),
        onTap: () {
          setState(() {
            state = !state;
          });
          widget.onSwitched(state);
        },
      ),
    );
  }
}
