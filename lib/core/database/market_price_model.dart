import 'package:isar_community/isar.dart';

part 'market_price_model.g.dart';

@Collection()
class MarketPrice {
  Id id = Isar.autoIncrement;

  late String itemName;
  late String unit; // e.g., Kg, Piece
  late double minPrice;
  late double maxPrice;
  late double avgPrice;
  late DateTime date;
}
