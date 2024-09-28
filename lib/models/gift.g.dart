// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gift.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetGiftCollection on Isar {
  IsarCollection<Gift> get gifts => this.collection();
}

const GiftSchema = CollectionSchema(
  name: r'Gift',
  id: -1012333367735251209,
  properties: {
    r'isBought': PropertySchema(
      id: 0,
      name: r'isBought',
      type: IsarType.bool,
    )
  },
  estimateSize: _giftEstimateSize,
  serialize: _giftSerialize,
  deserialize: _giftDeserialize,
  deserializeProp: _giftDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {
    r'giftIdea': LinkSchema(
      id: 4603764310928497105,
      name: r'giftIdea',
      target: r'GiftIdea',
      single: true,
    ),
    r'owner': LinkSchema(
      id: -5181856704476086217,
      name: r'owner',
      target: r'Friend',
      single: true,
    )
  },
  embeddedSchemas: {},
  getId: _giftGetId,
  getLinks: _giftGetLinks,
  attach: _giftAttach,
  version: '3.1.0+1',
);

int _giftEstimateSize(
  Gift object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _giftSerialize(
  Gift object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeBool(offsets[0], object.isBought);
}

Gift _giftDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Gift(
    isBought: reader.readBoolOrNull(offsets[0]) ?? false,
  );
  object.id = id;
  return object;
}

P _giftDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readBoolOrNull(offset) ?? false) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _giftGetId(Gift object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _giftGetLinks(Gift object) {
  return [object.giftIdea, object.owner];
}

void _giftAttach(IsarCollection<dynamic> col, Id id, Gift object) {
  object.id = id;
  object.giftIdea.attach(col, col.isar.collection<GiftIdea>(), r'giftIdea', id);
  object.owner.attach(col, col.isar.collection<Friend>(), r'owner', id);
}

extension GiftQueryWhereSort on QueryBuilder<Gift, Gift, QWhere> {
  QueryBuilder<Gift, Gift, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension GiftQueryWhere on QueryBuilder<Gift, Gift, QWhereClause> {
  QueryBuilder<Gift, Gift, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Gift, Gift, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<Gift, Gift, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Gift, Gift, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Gift, Gift, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension GiftQueryFilter on QueryBuilder<Gift, Gift, QFilterCondition> {
  QueryBuilder<Gift, Gift, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Gift, Gift, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Gift, Gift, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Gift, Gift, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Gift, Gift, QAfterFilterCondition> isBoughtEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isBought',
        value: value,
      ));
    });
  }
}

extension GiftQueryObject on QueryBuilder<Gift, Gift, QFilterCondition> {}

extension GiftQueryLinks on QueryBuilder<Gift, Gift, QFilterCondition> {
  QueryBuilder<Gift, Gift, QAfterFilterCondition> giftIdea(
      FilterQuery<GiftIdea> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'giftIdea');
    });
  }

  QueryBuilder<Gift, Gift, QAfterFilterCondition> giftIdeaIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'giftIdea', 0, true, 0, true);
    });
  }

  QueryBuilder<Gift, Gift, QAfterFilterCondition> owner(FilterQuery<Friend> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'owner');
    });
  }

  QueryBuilder<Gift, Gift, QAfterFilterCondition> ownerIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'owner', 0, true, 0, true);
    });
  }
}

extension GiftQuerySortBy on QueryBuilder<Gift, Gift, QSortBy> {
  QueryBuilder<Gift, Gift, QAfterSortBy> sortByIsBought() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isBought', Sort.asc);
    });
  }

  QueryBuilder<Gift, Gift, QAfterSortBy> sortByIsBoughtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isBought', Sort.desc);
    });
  }
}

extension GiftQuerySortThenBy on QueryBuilder<Gift, Gift, QSortThenBy> {
  QueryBuilder<Gift, Gift, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Gift, Gift, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Gift, Gift, QAfterSortBy> thenByIsBought() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isBought', Sort.asc);
    });
  }

  QueryBuilder<Gift, Gift, QAfterSortBy> thenByIsBoughtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isBought', Sort.desc);
    });
  }
}

extension GiftQueryWhereDistinct on QueryBuilder<Gift, Gift, QDistinct> {
  QueryBuilder<Gift, Gift, QDistinct> distinctByIsBought() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isBought');
    });
  }
}

extension GiftQueryProperty on QueryBuilder<Gift, Gift, QQueryProperty> {
  QueryBuilder<Gift, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Gift, bool, QQueryOperations> isBoughtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isBought');
    });
  }
}
