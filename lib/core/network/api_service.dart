import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../database/market_price_model.dart';

class ApiService {
  // Use Android emulator loopback IP on Android, otherwise localhost
  final String _baseUrl = Platform.isAndroid 
      ? 'http://10.0.2.2:8000' 
      : 'http://localhost:8000';

  Future<List<MarketPrice>> fetchLatestPrices() async {
    final url = Uri.parse('$_baseUrl/api/v1/prices/latest');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> decodedList = json.decode(response.body);
      return decodedList
          .map((item) => MarketPrice.fromJson(Map<String, dynamic>.from(item)))
          .toList();
    } else {
      throw HttpException(
        'Failed to fetch latest prices. Status code: ${response.statusCode}',
        uri: url,
      );
    }
  }
}
