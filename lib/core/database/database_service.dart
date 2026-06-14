import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'market_price_model.dart';

class DatabaseService {
  static late Isar instance;

  static Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    instance = await Isar.open(
      [MarketPriceSchema],
      directory: dir.path,
    );
  }

  /// Saves the updated list of prices to the local database in a single transaction,
  /// replacing any old cached records.
  static Future<void> savePrices(List<MarketPrice> prices) async {
    await instance.writeTxn(() async {
      await instance.marketPrices.clear();
      await instance.marketPrices.putAll(prices);
    });
  }

  /// Returns the locally cached market prices.
  static Future<List<MarketPrice>> getCachedPrices() async {
    return await instance.marketPrices.where().anyId().findAll();
  }
}
