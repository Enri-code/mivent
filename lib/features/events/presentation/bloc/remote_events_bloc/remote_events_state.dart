part of 'remote_events_bloc.dart';

class RemoteEventsState extends Equatable {
  const RemoteEventsState._(
    this.status, {
    this.sections = const [],
    this.lastSectionId,
    this.lastSection,
  });

  factory RemoteEventsState.initial(
          [List<IEventSectionRepo> initialSectionProviders = const []]) =>
      RemoteEventsState._(
        OperationStatus.initial,
        sections: List.generate(
          initialSectionProviders.length,
          (i) => EventSectionData(id: i, provider: initialSectionProviders[i]),
        ),
      );

  final int? lastSectionId;
  final EventSectionData? lastSection;
  final OperationStatus status;
  final List<EventSectionData> sections;

  bool get isCompleteFail =>
      sections.every((e) => e.status == OperationStatus.minorFail);

  RemoteEventsState copyWith({
    int? lastSectionId,
    EventSectionData? lastSection,
    OperationStatus? status,
    EventSectionData? updateSection,
  }) {
    List<EventSectionData>? sections;
    if (updateSection != null) {
      sections = this.sections;
      sections[this.sections.indexOf(updateSection)] = updateSection;
    }
    return RemoteEventsState._(
      status ?? this.status,
      sections: sections ?? this.sections,
      lastSectionId: lastSectionId ?? this.lastSectionId,
      lastSection: lastSection ?? this.lastSection,
    );
  }

  @override
  List<Object?> get props => [status, sections, lastSectionId, lastSection];
}
