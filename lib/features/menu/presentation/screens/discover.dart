import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mivent/core/utils/definitions.dart';
import 'package:mivent/features/events/domain/entities/event_section.dart';

import 'package:mivent/features/events/domain/repos/sections.dart';
import 'package:mivent/features/events/presentation/bloc/remote_events_bloc/remote_events_bloc.dart';
import 'package:mivent/features/menu/presentation/widgets/bubbles.dart';
import 'package:mivent/features/menu/presentation/widgets/remote_event_section.dart';
import 'package:mivent/global/presentation/theme/colors.dart';
import 'package:mivent/global/presentation/theme/text_styles.dart';
import 'package:mivent/global/presentation/widgets/text_fields.dart';

class DiscoverPage extends StatelessWidget {
  const DiscoverPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      alignment: AlignmentDirectional.center,
      children: [
        const BubblesWidget(),
        BlocSelector<GetRemoteEventsBloc, RemoteEventsState, bool>(
          selector: (state) => state.status == OperationStatus.majorFail,
          builder: (context, state) {
            if (state) return const Center(child: _ErrorWidget());
            return const _ScrollView();
          },
        ),
      ],
    );
  }
}

class _ScrollView extends StatefulWidget {
  const _ScrollView({Key? key}) : super(key: key);

  @override
  State<_ScrollView> createState() => _ScrollViewState();
}

class _ScrollViewState extends State<_ScrollView> {
  final controller = ScrollController();
  final _listKey = GlobalKey<SliverAnimatedListState>();

  void _addMore(GetRemoteEventsBloc bloc) async {
    if (bloc.state.sections.last.status == OperationStatus.success) {
      bloc.add(AddSectionEvent(EventSectionData(
        id: bloc.state.sections.length - 1,
        provider: context.read<IRemoteEventsProvider>().randomRepo,
      )));
    }
  }

  void _checkScrollExtent() {
    if (controller.position.extentAfter < 200) {
      var bloc = context.read<GetRemoteEventsBloc>();
      _addMore(bloc);
    }
  }

  @override
  void initState() {
    super.initState();
    controller.addListener(_checkScrollExtent);
  }

  @override
  void dispose() {
    controller.removeListener(_checkScrollExtent);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: controller,
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Events',
                        style: TextStyles.header1.copyWith(
                          fontSize: 32,
                          color: ColorPalette.primary,
                        ),
                      ),
                      Text(
                        'waiting for you',
                        style: TextStyles.header1.copyWith(
                          height: 1.2,
                          color: ColorPalette.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 64,
                  child: TextFormWidget(
                    label: 'Find events',
                    backgroundColor: Colors.white70,
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
                const SizedBox(height: 4),
              ],
            ),
          ),
        ),
        BlocListener<GetRemoteEventsBloc, RemoteEventsState>(
          listener: (_, state) {
            if (state.lastSectionId == null) return;
            if (state.status == OperationStatus.minorFail) {
              ///TODO remove animatedList and use Slack's method
              _listKey.currentState!.removeItem(
                state.lastSectionId!,
                (_, anim) => SizeTransition(
                  sizeFactor: anim,
                  axisAlignment: 1,
                  child: FadeTransition(
                    opacity: anim,
                    child: RemoteEventSection(state.lastSection!),
                  ),
                ),
                duration: const Duration(milliseconds: 600),
              );
            } else if (state.status == OperationStatus.minorLoading) {
              _listKey.currentState!.insertItem(state.lastSectionId!);
            }
          },
          child: SliverAnimatedList(
            key: _listKey,
            initialItemCount:
                context.read<GetRemoteEventsBloc>().initialSectionCount,
            itemBuilder: (_, i, anim) {
              anim.addStatusListener((status) {
                if (status == AnimationStatus.completed) _checkScrollExtent();
              });
              return SizeTransition(
                axisAlignment: 1,
                sizeFactor: anim,
                child: FadeTransition(
                  opacity: anim,
                  child: RemoteEventSection(
                    context.read<GetRemoteEventsBloc>().state.sections[i],
                    onStatusChanged: (status, data) {
                      if (status == OperationStatus.minorFail) {
                        context
                            .read<GetRemoteEventsBloc>()
                            .add(SectionErrorEvent(data));
                      } else if (status == OperationStatus.success &&
                          data.status != OperationStatus.success) {
                        context
                            .read<GetRemoteEventsBloc>()
                            .add(SectionSuccessEvent(data));
                      }
                    },
                  ),
                ),
              );
            },
          ),
        ),
        /*  if (context.watch<RemoteEventsBloc>().state.status ==
            OperationStatus.minorFail)
          const SliverToBoxAdapter(
            child: Center(child: _ErrorWidget()),
          ), */
      ],
    );
  }
}

class _ErrorWidget extends StatelessWidget {
  const _ErrorWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.all(8),
            child: Text('An error has occured', style: TextStyles.subHeader1),
          ),
          TextButton(child: const Text('Try again'), onPressed: () {}),
        ],
      ),
    );
  }
}
