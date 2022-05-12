import 'package:mivent/features/_share/domain/entities/shareable.dart';
import 'package:mivent/features/events/domain/entities/event.dart';
import 'package:mivent/global/data/app_data.dart';

class ShareableEvent implements Shareable {
  ShareableEvent(this.item);
  @override
  final Event item;

  @override
  String get title => '${item.name}, on ${AppSettings.appName}';

  @override
  String get link {
    throw UnimplementedError();
  }

  @override
  String toString() {
    var data = "Hey, you have to check out this event:\n${item.name} from the ${AppSettings.appName} app";
    ".\n It's at ${item.location}";
    if (item.dates != null) data += ', on ${item.dates!.range}';
    data += '.';
    data += '\n$link';
    if (item.isFree) data += "\n\nAnd it's free!";
    return data;
  }
}
