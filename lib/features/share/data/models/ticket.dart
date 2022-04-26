import 'package:mivent/features/share/domain/entities/shareable.dart';
import 'package:mivent/features/tickets/domain/models/ticket.dart';
import 'package:mivent/global/presentation/theme/theme_data.dart';

class ShareableTicket implements Shareable {
  ShareableTicket(this.item);
  @override
  final Ticket item;

  @override
  String get title => item.name;

  @override
  String get link {
    throw UnimplementedError();
  }

  @override
  String toString() {
    var data = "Get the ticket: " +
        item.name +
        " for " +
        item.event!.name +
        " event, from the " +
        ThemeSettings.appName +
        " app.";
    data += '\n' + link;
    if (item.isFree) data += "\n\nAnd it's free!";
    return data;
  }
}
