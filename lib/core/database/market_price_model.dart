import 'package:isar_community/isar.dart';

part 'market_price_model.g.dart';

@Collection()
class MarketPrice {
  Id id = Isar.autoIncrement;

  late String date;
  late String commodityNameNp;
  late String commodityNameEn;
  late String unit;
  late double minimumPrice;
  late double maximumPrice;
  late double averagePrice;

  MarketPrice();

  factory MarketPrice.fromJson(Map<String, dynamic> json) {
    return MarketPrice()
      ..date = json['date'] as String
      ..commodityNameNp = json['commodity_name_np'] as String
      ..commodityNameEn = json['commodity_name_en'] as String
      ..unit = json['unit'] as String
      ..minimumPrice = (json['minimum_price'] as num).toDouble()
      ..maximumPrice = (json['maximum_price'] as num).toDouble()
      ..averagePrice = (json['average_price'] as num).toDouble();
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'commodity_name_np': commodityNameNp,
      'commodity_name_en': commodityNameEn,
      'unit': unit,
      'minimum_price': minimumPrice,
      'maximum_price': maximumPrice,
      'average_price': averagePrice,
    };
  }
}
