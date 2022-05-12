import 'package:mivent/features/_share/domain/entities/shareable.dart';
import 'package:mivent/features/tickets/domain/entities/ticket.dart';
import 'package:mivent/global/data/app_data.dart';

class ShareableTicket implements Shareable {
  ShareableTicket(this.item);
  @override
  final Ticket item;

  @override
  String get title => '${item.name}, on ${AppSettings.appName}';

  @override
  String get link {
    throw UnimplementedError();
  }

  @override
  String toString() {
    var data = "Get the ticket: ${item.name} for ${item.event.name} event, from the ${AppSettings.appName} app.";
    data += '\n$link';
    if (item.isFree) data += "\n\nAnd it's free!";
    return data;
  }
}
