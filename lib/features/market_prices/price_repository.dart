import 'dart:async';
import '../../core/database/database_service.dart';
import '../../core/database/market_price_model.dart';
import '../../core/network/api_service.dart';

class PriceRepository {
  final ApiService _apiService = ApiService();

  /// Fetches market prices using an Offline-First strategy.
  /// 1. Immediately yields the cached data from the local database.
  /// 2. Asynchronously requests the latest prices from the API.
  /// 3. If successful, updates the local cache and yields the fresh data.
  /// 4. If a network error occurs, handles it gracefully and falls back on cached data.
  Stream<List<MarketPrice>> getMarketPrices() async* {
    // a. Yield cached data immediately
    final List<MarketPrice> cachedPrices = await DatabaseService.getCachedPrices();
    yield cachedPrices;

    // b. Fetch latest prices from the network
    try {
      final List<MarketPrice> latestPrices = await _apiService.fetchLatestPrices();
      
      // c. Overwrite local database cache
      await DatabaseService.savePrices(latestPrices);
      
      // Yield updated fresh data
      yield latestPrices;
    } catch (e) {
      // d. Gracefully handle exceptions, falling back entirely on cache
      // (No new yield is emitted, keeping the cachedPrices state intact)
    }
  }

  /// Synchronously fetches and stores latest prices in a single operation.
  Future<void> syncPrices() async {
    final List<MarketPrice> latestPrices = await _apiService.fetchLatestPrices();
    await DatabaseService.savePrices(latestPrices);
  }
}
