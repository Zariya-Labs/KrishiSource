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
    r'avgPrice': PropertySchema(
      id: 0,
      name: r'avgPrice',
      type: IsarType.double,
    ),
    r'date': PropertySchema(id: 1, name: r'date', type: IsarType.dateTime),
    r'itemName': PropertySchema(
      id: 2,
      name: r'itemName',
      type: IsarType.string,
    ),
    r'maxPrice': PropertySchema(
      id: 3,
      name: r'maxPrice',
      type: IsarType.double,
    ),
    r'minPrice': PropertySchema(
      id: 4,
      name: r'minPrice',
      type: IsarType.double,
    ),
    r'unit': PropertySchema(id: 5, name: r'unit', type: IsarType.string),
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
  bytesCount += 3 + object.itemName.length * 3;
  bytesCount += 3 + object.unit.length * 3;
  return bytesCount;
}

void _marketPriceSerialize(
  MarketPrice object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDouble(offsets[0], object.avgPrice);
  writer.writeDateTime(offsets[1], object.date);
  writer.writeString(offsets[2], object.itemName);
  writer.writeDouble(offsets[3], object.maxPrice);
  writer.writeDouble(offsets[4], object.minPrice);
  writer.writeString(offsets[5], object.unit);
}

MarketPrice _marketPriceDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = MarketPrice();
  object.avgPrice = reader.readDouble(offsets[0]);
  object.date = reader.readDateTime(offsets[1]);
  object.id = id;
  object.itemName = reader.readString(offsets[2]);
  object.maxPrice = reader.readDouble(offsets[3]);
  object.minPrice = reader.readDouble(offsets[4]);
  object.unit = reader.readString(offsets[5]);
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
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readDouble(offset)) as P;
    case 4:
      return (reader.readDouble(offset)) as P;
    case 5:
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
  QueryBuilder<MarketPrice, MarketPrice, QAfterFilterCondition> avgPriceEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'avgPrice',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<MarketPrice, MarketPrice, QAfterFilterCondition>
  avgPriceGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'avgPrice',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<MarketPrice, MarketPrice, QAfterFilterCondition>
  avgPriceLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'avgPrice',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<MarketPrice, MarketPrice, QAfterFilterCondition> avgPriceBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'avgPrice',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<MarketPrice, MarketPrice, QAfterFilterCondition> dateEqualTo(
    DateTime value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'date', value: value),
      );
    });
  }

  QueryBuilder<MarketPrice, MarketPrice, QAfterFilterCondition> dateGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'date',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<MarketPrice, MarketPrice, QAfterFilterCondition> dateLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'date',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<MarketPrice, MarketPrice, QAfterFilterCondition> dateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'date',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
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

  QueryBuilder<MarketPrice, MarketPrice, QAfterFilterCondition> itemNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'itemName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MarketPrice, MarketPrice, QAfterFilterCondition>
  itemNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'itemName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MarketPrice, MarketPrice, QAfterFilterCondition>
  itemNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'itemName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MarketPrice, MarketPrice, QAfterFilterCondition> itemNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'itemName',
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
  itemNameStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'itemName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MarketPrice, MarketPrice, QAfterFilterCondition>
  itemNameEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'itemName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MarketPrice, MarketPrice, QAfterFilterCondition>
  itemNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'itemName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MarketPrice, MarketPrice, QAfterFilterCondition> itemNameMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'itemName',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MarketPrice, MarketPrice, QAfterFilterCondition>
  itemNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'itemName', value: ''),
      );
    });
  }

  QueryBuilder<MarketPrice, MarketPrice, QAfterFilterCondition>
  itemNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'itemName', value: ''),
      );
    });
  }

  QueryBuilder<MarketPrice, MarketPrice, QAfterFilterCondition> maxPriceEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'maxPrice',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<MarketPrice, MarketPrice, QAfterFilterCondition>
  maxPriceGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'maxPrice',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<MarketPrice, MarketPrice, QAfterFilterCondition>
  maxPriceLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'maxPrice',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<MarketPrice, MarketPrice, QAfterFilterCondition> maxPriceBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'maxPrice',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<MarketPrice, MarketPrice, QAfterFilterCondition> minPriceEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'minPrice',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<MarketPrice, MarketPrice, QAfterFilterCondition>
  minPriceGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'minPrice',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<MarketPrice, MarketPrice, QAfterFilterCondition>
  minPriceLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'minPrice',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<MarketPrice, MarketPrice, QAfterFilterCondition> minPriceBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'minPrice',
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
  QueryBuilder<MarketPrice, MarketPrice, QAfterSortBy> sortByAvgPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'avgPrice', Sort.asc);
    });
  }

  QueryBuilder<MarketPrice, MarketPrice, QAfterSortBy> sortByAvgPriceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'avgPrice', Sort.desc);
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

  QueryBuilder<MarketPrice, MarketPrice, QAfterSortBy> sortByItemName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemName', Sort.asc);
    });
  }

  QueryBuilder<MarketPrice, MarketPrice, QAfterSortBy> sortByItemNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemName', Sort.desc);
    });
  }

  QueryBuilder<MarketPrice, MarketPrice, QAfterSortBy> sortByMaxPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maxPrice', Sort.asc);
    });
  }

  QueryBuilder<MarketPrice, MarketPrice, QAfterSortBy> sortByMaxPriceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maxPrice', Sort.desc);
    });
  }

  QueryBuilder<MarketPrice, MarketPrice, QAfterSortBy> sortByMinPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'minPrice', Sort.asc);
    });
  }

  QueryBuilder<MarketPrice, MarketPrice, QAfterSortBy> sortByMinPriceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'minPrice', Sort.desc);
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
  QueryBuilder<MarketPrice, MarketPrice, QAfterSortBy> thenByAvgPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'avgPrice', Sort.asc);
    });
  }

  QueryBuilder<MarketPrice, MarketPrice, QAfterSortBy> thenByAvgPriceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'avgPrice', Sort.desc);
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

  QueryBuilder<MarketPrice, MarketPrice, QAfterSortBy> thenByItemName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemName', Sort.asc);
    });
  }

  QueryBuilder<MarketPrice, MarketPrice, QAfterSortBy> thenByItemNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemName', Sort.desc);
    });
  }

  QueryBuilder<MarketPrice, MarketPrice, QAfterSortBy> thenByMaxPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maxPrice', Sort.asc);
    });
  }

  QueryBuilder<MarketPrice, MarketPrice, QAfterSortBy> thenByMaxPriceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maxPrice', Sort.desc);
    });
  }

  QueryBuilder<MarketPrice, MarketPrice, QAfterSortBy> thenByMinPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'minPrice', Sort.asc);
    });
  }

  QueryBuilder<MarketPrice, MarketPrice, QAfterSortBy> thenByMinPriceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'minPrice', Sort.desc);
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
  QueryBuilder<MarketPrice, MarketPrice, QDistinct> distinctByAvgPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'avgPrice');
    });
  }

  QueryBuilder<MarketPrice, MarketPrice, QDistinct> distinctByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'date');
    });
  }

  QueryBuilder<MarketPrice, MarketPrice, QDistinct> distinctByItemName({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'itemName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MarketPrice, MarketPrice, QDistinct> distinctByMaxPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'maxPrice');
    });
  }

  QueryBuilder<MarketPrice, MarketPrice, QDistinct> distinctByMinPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'minPrice');
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

  QueryBuilder<MarketPrice, double, QQueryOperations> avgPriceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'avgPrice');
    });
  }

  QueryBuilder<MarketPrice, DateTime, QQueryOperations> dateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'date');
    });
  }

  QueryBuilder<MarketPrice, String, QQueryOperations> itemNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'itemName');
    });
  }

  QueryBuilder<MarketPrice, double, QQueryOperations> maxPriceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'maxPrice');
    });
  }

  QueryBuilder<MarketPrice, double, QQueryOperations> minPriceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'minPrice');
    });
  }

  QueryBuilder<MarketPrice, String, QQueryOperations> unitProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'unit');
    });
  }
}
