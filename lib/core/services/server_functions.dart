import 'package:http/http.dart' as http;

abstract class ServerFunctions {
  static Future<int> get epochTimeOfMinutes async {
    late int time;
    try {
      var epochMins = await http.get(
        Uri.parse(
            'https://currentmillis.com/time/minutes-since-unix-epoch.php'),
      );
      time = int.parse(epochMins.body) * 60000;
    } catch (_) {
      time = DateTime.now().toUtc().millisecondsSinceEpoch;
    }
    return time;
  }
}
