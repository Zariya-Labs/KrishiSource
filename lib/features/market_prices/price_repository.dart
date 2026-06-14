
import '../../core/database/database_service.dart';
import '../../core/database/market_price_model.dart';
import '../../core/network/api_service.dart';

class PriceRepository {
  final ApiService _apiService = ApiService();

  Future<void> syncPrices() async {
    // 1. Fetch market prices from the FastAPI microservice
    final List<Map<String, dynamic>> rawPrices = await _apiService.fetchDailyPrices();

    // 2. Convert raw JSON entries to Isar model class instances
    final List<MarketPrice> pricesList = rawPrices.map((data) {
      return MarketPrice()
        ..itemName = data['item_name'] as String
        ..unit = data['unit'] as String
        ..minPrice = (data['min_price'] as num).toDouble()
        ..maxPrice = (data['max_price'] as num).toDouble()
        ..avgPrice = (data['avg_price'] as num).toDouble()
        ..date = DateTime.now();
    }).toList();

    // 3. Persist the models to the local database in a single transaction
    await DatabaseService.instance.writeTxn(() async {
      // Clear previous prices on sync to avoid data duplication
      await DatabaseService.instance.marketPrices.clear();
      await DatabaseService.instance.marketPrices.putAll(pricesList);
    });
  }
}
