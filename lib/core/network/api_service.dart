import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ApiService {
  // Use Android emulator loopback IP on Android, otherwise localhost
  final String _baseUrl = Platform.isAndroid 
      ? 'http://10.0.2.2:8000' 
      : 'http://localhost:8000';

  Future<List<Map<String, dynamic>>> fetchDailyPrices() async {
    final url = Uri.parse('$_baseUrl/api/prices');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> decodedList = json.decode(response.body);
      return decodedList.map((item) => Map<String, dynamic>.from(item)).toList();
    } else {
      throw HttpException(
        'Failed to fetch daily prices. Status code: ${response.statusCode}',
        uri: url,
      );
    }
  }
}
