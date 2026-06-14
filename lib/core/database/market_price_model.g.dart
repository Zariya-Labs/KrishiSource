// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'market_price_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetMarketPriceCollection on Isar {
  IsarCollection<MarketPrice> get marketPrices => this.collection();
}

const MarketPriceSchema = CollectionSchema(
  name: r'MarketPrice',
  id: -2526803194536702617,
  properties: {
    r'averagePrice': PropertySchema(
      id: 0,
      name: r'averagePrice',
      type: IsarType.double,
    ),
    r'commodityNameEn': PropertySchema(
      id: 1,
      name: r'commodityNameEn',
      type: IsarType.string,
    ),
    r'commodityNameNp': PropertySchema(
      id: 2,
      name: r'commodityNameNp',
      type: IsarType.string,
    ),
    r'date': PropertySchema(id: 3, name: r'date', type: IsarType.string),
    r'maximumPrice': PropertySchema(
      id: 4,
      name: r'maximumPrice',
      type: IsarType.double,
    ),
    r'minimumPrice': PropertySchema(
      id: 5,
      name: r'minimumPrice',
      type: IsarType.double,
    ),
    r'unit': PropertySchema(id: 6, name: r'unit', type: IsarType.string),
  },

  estimateSize: _marketPriceEstimateSize,
  serialize: _marketPriceSerialize,
  deserialize: _marketPriceDeserialize,
  deserializeProp: _marketPriceDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},

  getId: _marketPriceGetId,
  getLinks: _marketPriceGetLinks,
  attach: _marketPriceAttach,
  version: '3.3.2',
);

int _marketPriceEstimateSize(
  MarketPrice object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.commodityNameEn.length * 3;
  bytesCount += 3 + object.commodityNameNp.length * 3;
  bytesCount += 3 + object.date.length * 3;
  bytesCount += 3 + object.unit.length * 3;
  return bytesCount;
}

void _marketPriceSerialize(
  MarketPrice object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDouble(offsets[0], object.averagePrice);
  writer.writeString(offsets[1], object.commodityNameEn);
  writer.writeString(offsets[2], object.commodityNameNp);
  writer.writeString(offsets[3], object.date);
  writer.writeDouble(offsets[4], object.maximumPrice);
  writer.writeDouble(offsets[5], object.minimumPrice);
  writer.writeString(offsets[6], object.unit);
}

MarketPrice _marketPriceDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = MarketPrice();
  object.averagePrice = reader.readDouble(offsets[0]);
  object.commodityNameEn = reader.readString(offsets[1]);
  object.commodityNameNp = reader.readString(offsets[2]);
  object.date = reader.readString(offsets[3]);
  object.id = id;
  object.maximumPrice = reader.readDouble(offsets[4]);
  object.minimumPrice = reader.readDouble(offsets[5]);
  object.unit = reader.readString(offsets[6]);
  return object;
}

P _marketPriceDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDouble(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readDouble(offset)) as P;
    case 5:
      return (reader.readDouble(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _marketPriceGetId(MarketPrice object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _marketPriceGetLinks(MarketPrice object) {
  return [];
}

void _marketPriceAttach(
  IsarCollection<dynamic> col,
  Id id,
  MarketPrice object,
) {
  object.id = id;
}

extension MarketPriceQueryWhereSort
    on QueryBuilder<MarketPrice, MarketPrice, QWhere> {
  QueryBuilder<MarketPrice, MarketPrice, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension MarketPriceQueryWhere
    on QueryBuilder<MarketPrice, MarketPrice, QWhereClause> {
  QueryBuilder<MarketPrice, MarketPrice, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<MarketPrice, MarketPrice, QAfterWhereClause> idNotEqualTo(
    Id id,
  ) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<MarketPrice, MarketPrice, QAfterWhereClause> idGreaterThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<MarketPrice, MarketPrice, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<MarketPrice, MarketPrice, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.between(
          lower: lowerId,
          includeLower: includeLower,
          upper: upperId,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension MarketPriceQueryFilter
    on QueryBuilder<MarketPrice, MarketPrice, QFilterCondition> {
  QueryBuilder<MarketPrice, MarketPrice, QAfterFilterCondition>
  averagePriceEqualTo(double value, {double epsilon = Query.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'averagePrice',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<MarketPrice, MarketPrice, QAfterFilterCondition>
  averagePriceGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'averagePrice',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<MarketPrice, MarketPrice, QAfterFilterCondition>
  averagePriceLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'averagePrice',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<MarketPrice, MarketPrice, QAfterFilterCondition>
  averagePriceBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'averagePrice',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<MarketPrice, MarketPrice, QAfterFilterCondition>
  commodityNameEnEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'commodityNameEn',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MarketPrice, MarketPrice, QAfterFilterCondition>
  commodityNameEnGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'commodityNameEn',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MarketPrice, MarketPrice, QAfterFilterCondition>
  commodityNameEnLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'commodityNameEn',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MarketPrice, MarketPrice, QAfterFilterCondition>
  commodityNameEnBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'commodityNameEn',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MarketPrice, MarketPrice, QAfterFilterCondition>
  commodityNameEnStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'commodityNameEn',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MarketPrice, MarketPrice, QAfterFilterCondition>
  commodityNameEnEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'commodityNameEn',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MarketPrice, MarketPrice, QAfterFilterCondition>
  commodityNameEnContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'commodityNameEn',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MarketPrice, MarketPrice, QAfterFilterCondition>
  commodityNameEnMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'commodityNameEn',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MarketPrice, MarketPrice, QAfterFilterCondition>
  commodityNameEnIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'commodityNameEn', value: ''),
      );
    });
  }

  QueryBuilder<MarketPrice, MarketPrice, QAfterFilterCondition>
  commodityNameEnIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'commodityNameEn', value: ''),
      );
    });
  }

  QueryBuilder<MarketPrice, MarketPrice, QAfterFilterCondition>
  commodityNameNpEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'commodityNameNp',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MarketPrice, MarketPrice, QAfterFilterCondition>
  commodityNameNpGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'commodityNameNp',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MarketPrice, MarketPrice, QAfterFilterCondition>
  commodityNameNpLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'commodityNameNp',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MarketPrice, MarketPrice, QAfterFilterCondition>
  commodityNameNpBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'commodityNameNp',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MarketPrice, MarketPrice, QAfterFilterCondition>
  commodityNameNpStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'commodityNameNp',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MarketPrice, MarketPrice, QAfterFilterCondition>
  commodityNameNpEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'commodityNameNp',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MarketPrice, MarketPrice, QAfterFilterCondition>
  commodityNameNpContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'commodityNameNp',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MarketPrice, MarketPrice, QAfterFilterCondition>
  commodityNameNpMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'commodityNameNp',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MarketPrice, MarketPrice, QAfterFilterCondition>
  commodityNameNpIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'commodityNameNp', value: ''),
      );
    });
  }

  QueryBuilder<MarketPrice, MarketPrice, QAfterFilterCondition>
  commodityNameNpIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'commodityNameNp', value: ''),
      );
    });
  }

  QueryBuilder<MarketPrice, MarketPrice, QAfterFilterCondition> dateEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'date',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MarketPrice, MarketPrice, QAfterFilterCondition> dateGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'date',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MarketPrice, MarketPrice, QAfterFilterCondition> dateLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'date',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MarketPrice, MarketPrice, QAfterFilterCondition> dateBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'date',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MarketPrice, MarketPrice, QAfterFilterCondition> dateStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'date',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MarketPrice, MarketPrice, QAfterFilterCondition> dateEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'date',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MarketPrice, MarketPrice, QAfterFilterCondition> dateContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'date',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MarketPrice, MarketPrice, QAfterFilterCondition> dateMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'date',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MarketPrice, MarketPrice, QAfterFilterCondition> dateIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'date', value: ''),
      );
    });
  }

  QueryBuilder<MarketPrice, MarketPrice, QAfterFilterCondition>
  dateIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'date', value: ''),
      );
    });
  }

  QueryBuilder<MarketPrice, MarketPrice, QAfterFilterCondition> idEqualTo(
    Id value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<MarketPrice, MarketPrice, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<MarketPrice, MarketPrice, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<MarketPrice, MarketPrice, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'id',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<MarketPrice, MarketPrice, QAfterFilterCondition>
  maximumPriceEqualTo(double value, {double epsilon = Query.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'maximumPrice',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<MarketPrice, MarketPrice, QAfterFilterCondition>
  maximumPriceGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'maximumPrice',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<MarketPrice, MarketPrice, QAfterFilterCondition>
  maximumPriceLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'maximumPrice',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<MarketPrice, MarketPrice, QAfterFilterCondition>
  maximumPriceBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'maximumPrice',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<MarketPrice, MarketPrice, QAfterFilterCondition>
  minimumPriceEqualTo(double value, {double epsilon = Query.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'minimumPrice',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<MarketPrice, MarketPrice, QAfterFilterCondition>
  minimumPriceGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'minimumPrice',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<MarketPrice, MarketPrice, QAfterFilterCondition>
  minimumPriceLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'minimumPrice',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<MarketPrice, MarketPrice, QAfterFilterCondition>
  minimumPriceBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'minimumPrice',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<MarketPrice, MarketPrice, QAfterFilterCondition> unitEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'unit',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MarketPrice, MarketPrice, QAfterFilterCondition> unitGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'unit',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MarketPrice, MarketPrice, QAfterFilterCondition> unitLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'unit',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MarketPrice, MarketPrice, QAfterFilterCondition> unitBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'unit',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MarketPrice, MarketPrice, QAfterFilterCondition> unitStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'unit',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MarketPrice, MarketPrice, QAfterFilterCondition> unitEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'unit',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MarketPrice, MarketPrice, QAfterFilterCondition> unitContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'unit',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MarketPrice, MarketPrice, QAfterFilterCondition> unitMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'unit',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MarketPrice, MarketPrice, QAfterFilterCondition> unitIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'unit', value: ''),
      );
    });
  }

  QueryBuilder<MarketPrice, MarketPrice, QAfterFilterCondition>
  unitIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'unit', value: ''),
      );
    });
  }
}

extension MarketPriceQueryObject
    on QueryBuilder<MarketPrice, MarketPrice, QFilterCondition> {}

extension MarketPriceQueryLinks
    on QueryBuilder<MarketPrice, MarketPrice, QFilterCondition> {}

extension MarketPriceQuerySortBy
    on QueryBuilder<MarketPrice, MarketPrice, QSortBy> {
  QueryBuilder<MarketPrice, MarketPrice, QAfterSortBy> sortByAveragePrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'averagePrice', Sort.asc);
    });
  }

  QueryBuilder<MarketPrice, MarketPrice, QAfterSortBy>
  sortByAveragePriceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'averagePrice', Sort.desc);
    });
  }

  QueryBuilder<MarketPrice, MarketPrice, QAfterSortBy> sortByCommodityNameEn() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'commodityNameEn', Sort.asc);
    });
  }

  QueryBuilder<MarketPrice, MarketPrice, QAfterSortBy>
  sortByCommodityNameEnDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'commodityNameEn', Sort.desc);
    });
  }

  QueryBuilder<MarketPrice, MarketPrice, QAfterSortBy> sortByCommodityNameNp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'commodityNameNp', Sort.asc);
    });
  }

  QueryBuilder<MarketPrice, MarketPrice, QAfterSortBy>
  sortByCommodityNameNpDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'commodityNameNp', Sort.desc);
    });
  }

  QueryBuilder<MarketPrice, MarketPrice, QAfterSortBy> sortByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<MarketPrice, MarketPrice, QAfterSortBy> sortByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<MarketPrice, MarketPrice, QAfterSortBy> sortByMaximumPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maximumPrice', Sort.asc);
    });
  }

  QueryBuilder<MarketPrice, MarketPrice, QAfterSortBy>
  sortByMaximumPriceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maximumPrice', Sort.desc);
    });
  }

  QueryBuilder<MarketPrice, MarketPrice, QAfterSortBy> sortByMinimumPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'minimumPrice', Sort.asc);
    });
  }

  QueryBuilder<MarketPrice, MarketPrice, QAfterSortBy>
  sortByMinimumPriceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'minimumPrice', Sort.desc);
    });
  }

  QueryBuilder<MarketPrice, MarketPrice, QAfterSortBy> sortByUnit() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unit', Sort.asc);
    });
  }

  QueryBuilder<MarketPrice, MarketPrice, QAfterSortBy> sortByUnitDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unit', Sort.desc);
    });
  }
}

extension MarketPriceQuerySortThenBy
    on QueryBuilder<MarketPrice, MarketPrice, QSortThenBy> {
  QueryBuilder<MarketPrice, MarketPrice, QAfterSortBy> thenByAveragePrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'averagePrice', Sort.asc);
    });
  }

  QueryBuilder<MarketPrice, MarketPrice, QAfterSortBy>
  thenByAveragePriceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'averagePrice', Sort.desc);
    });
  }

  QueryBuilder<MarketPrice, MarketPrice, QAfterSortBy> thenByCommodityNameEn() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'commodityNameEn', Sort.asc);
    });
  }

  QueryBuilder<MarketPrice, MarketPrice, QAfterSortBy>
  thenByCommodityNameEnDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'commodityNameEn', Sort.desc);
    });
  }

  QueryBuilder<MarketPrice, MarketPrice, QAfterSortBy> thenByCommodityNameNp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'commodityNameNp', Sort.asc);
    });
  }

  QueryBuilder<MarketPrice, MarketPrice, QAfterSortBy>
  thenByCommodityNameNpDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'commodityNameNp', Sort.desc);
    });
  }

  QueryBuilder<MarketPrice, MarketPrice, QAfterSortBy> thenByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<MarketPrice, MarketPrice, QAfterSortBy> thenByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<MarketPrice, MarketPrice, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<MarketPrice, MarketPrice, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<MarketPrice, MarketPrice, QAfterSortBy> thenByMaximumPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maximumPrice', Sort.asc);
    });
  }

  QueryBuilder<MarketPrice, MarketPrice, QAfterSortBy>
  thenByMaximumPriceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maximumPrice', Sort.desc);
    });
  }

  QueryBuilder<MarketPrice, MarketPrice, QAfterSortBy> thenByMinimumPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'minimumPrice', Sort.asc);
    });
  }

  QueryBuilder<MarketPrice, MarketPrice, QAfterSortBy>
  thenByMinimumPriceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'minimumPrice', Sort.desc);
    });
  }

  QueryBuilder<MarketPrice, MarketPrice, QAfterSortBy> thenByUnit() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unit', Sort.asc);
    });
  }

  QueryBuilder<MarketPrice, MarketPrice, QAfterSortBy> thenByUnitDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unit', Sort.desc);
    });
  }
}

extension MarketPriceQueryWhereDistinct
    on QueryBuilder<MarketPrice, MarketPrice, QDistinct> {
  QueryBuilder<MarketPrice, MarketPrice, QDistinct> distinctByAveragePrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'averagePrice');
    });
  }

  QueryBuilder<MarketPrice, MarketPrice, QDistinct> distinctByCommodityNameEn({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'commodityNameEn',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<MarketPrice, MarketPrice, QDistinct> distinctByCommodityNameNp({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'commodityNameNp',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<MarketPrice, MarketPrice, QDistinct> distinctByDate({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'date', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MarketPrice, MarketPrice, QDistinct> distinctByMaximumPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'maximumPrice');
    });
  }

  QueryBuilder<MarketPrice, MarketPrice, QDistinct> distinctByMinimumPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'minimumPrice');
    });
  }

  QueryBuilder<MarketPrice, MarketPrice, QDistinct> distinctByUnit({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'unit', caseSensitive: caseSensitive);
    });
  }
}

extension MarketPriceQueryProperty
    on QueryBuilder<MarketPrice, MarketPrice, QQueryProperty> {
  QueryBuilder<MarketPrice, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<MarketPrice, double, QQueryOperations> averagePriceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'averagePrice');
    });
  }

  QueryBuilder<MarketPrice, String, QQueryOperations>
  commodityNameEnProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'commodityNameEn');
    });
  }

  QueryBuilder<MarketPrice, String, QQueryOperations>
  commodityNameNpProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'commodityNameNp');
    });
  }

  QueryBuilder<MarketPrice, String, QQueryOperations> dateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'date');
    });
  }

  QueryBuilder<MarketPrice, double, QQueryOperations> maximumPriceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'maximumPrice');
    });
  }

  QueryBuilder<MarketPrice, double, QQueryOperations> minimumPriceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'minimumPrice');
    });
  }

  QueryBuilder<MarketPrice, String, QQueryOperations> unitProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'unit');
    });
  }
}
