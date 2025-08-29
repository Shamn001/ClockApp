import 'dart:convert';
import 'package:http/http.dart' as http;

class TimeService {
  Future<Map<String, String>> fetchTime() async {
    final url = Uri.parse(
        'https://timeapi.io/api/Time/current/zone?timeZone=Asia/Kolkata');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      // Example response:
      // {
      //   "year": 2025,
      //   "month": 8,
      //   "day": 22,
      //   "hour": 10,
      //   "minute": 20,
      //   "seconds": 45,
      //   "dateTime": "2025-08-22T10:20:45",
      //   "timeZone": "Asia/Kolkata"
      // }

      String currentTime =
          "${data['hour'].toString().padLeft(2, '0')}:${data['minute'].toString().padLeft(2, '0')}:${data['seconds'].toString().padLeft(2, '0')}";

      return {
        "time": currentTime,
        "timezone": data['timeZone'],
      };
    } else {
      throw Exception("Failed to load time");
    }
  }
}
