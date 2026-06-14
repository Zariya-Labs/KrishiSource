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
}
