import 'package:mivent/features/store/domain/store.dart';
import 'package:mivent/global/domain/entities/item_mixin.dart';

mixin AttendingEventsStore<T extends ItemMixin> on IStore<T> {
  Future getRemoteIDs();
}
mixin SavedEventsStore<T extends ItemMixin> on IStore<T> {
  Future backup();
  Future getRemoteIDs();
}
