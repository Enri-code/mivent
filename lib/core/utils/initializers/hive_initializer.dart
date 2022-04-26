import 'package:hive_flutter/hive_flutter.dart';
import 'package:mivent/core/utils/hive_adapters/date_range.dart';
import 'package:mivent/core/utils/hive_adapters/event.dart';
import 'package:mivent/core/utils/hive_adapters/price_range.dart';
import 'package:mivent/core/utils/hive_adapters/ticket.dart';
import 'package:mivent/core/utils/hive_adapters/user.dart';

class HiveInitializer {
  static Future mainInit() async {
    await Hive.initFlutter();
    Hive
      ..registerAdapter(EventAdapter())
      ..registerAdapter(UserAdapter())
      ..registerAdapter(TicketAdapter())
      ..registerAdapter(DateRangeAdapter())
      ..registerAdapter(PriceRangeAdapter());
  }

  static dispose() => Hive.close();
}
