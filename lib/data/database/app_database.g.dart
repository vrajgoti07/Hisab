// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $MonthlyBudgetsTable extends MonthlyBudgets
    with TableInfo<$MonthlyBudgetsTable, MonthlyBudget> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MonthlyBudgetsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _yearMeta = const VerificationMeta('year');
  @override
  late final GeneratedColumn<int> year = GeneratedColumn<int>(
    'year',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _monthMeta = const VerificationMeta('month');
  @override
  late final GeneratedColumn<int> month = GeneratedColumn<int>(
    'month',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountPaiseMeta = const VerificationMeta(
    'amountPaise',
  );
  @override
  late final GeneratedColumn<int> amountPaise = GeneratedColumn<int>(
    'amount_paise',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _carryForwardMeta = const VerificationMeta(
    'carryForward',
  );
  @override
  late final GeneratedColumn<bool> carryForward = GeneratedColumn<bool>(
    'carry_forward',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("carry_forward" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _carriedAmountPaiseMeta =
      const VerificationMeta('carriedAmountPaise');
  @override
  late final GeneratedColumn<int> carriedAmountPaise = GeneratedColumn<int>(
    'carried_amount_paise',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    year,
    month,
    amountPaise,
    carryForward,
    carriedAmountPaise,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'monthly_budgets';
  @override
  VerificationContext validateIntegrity(
    Insertable<MonthlyBudget> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('year')) {
      context.handle(
        _yearMeta,
        year.isAcceptableOrUnknown(data['year']!, _yearMeta),
      );
    } else if (isInserting) {
      context.missing(_yearMeta);
    }
    if (data.containsKey('month')) {
      context.handle(
        _monthMeta,
        month.isAcceptableOrUnknown(data['month']!, _monthMeta),
      );
    } else if (isInserting) {
      context.missing(_monthMeta);
    }
    if (data.containsKey('amount_paise')) {
      context.handle(
        _amountPaiseMeta,
        amountPaise.isAcceptableOrUnknown(
          data['amount_paise']!,
          _amountPaiseMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_amountPaiseMeta);
    }
    if (data.containsKey('carry_forward')) {
      context.handle(
        _carryForwardMeta,
        carryForward.isAcceptableOrUnknown(
          data['carry_forward']!,
          _carryForwardMeta,
        ),
      );
    }
    if (data.containsKey('carried_amount_paise')) {
      context.handle(
        _carriedAmountPaiseMeta,
        carriedAmountPaise.isAcceptableOrUnknown(
          data['carried_amount_paise']!,
          _carriedAmountPaiseMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {year, month},
  ];
  @override
  MonthlyBudget map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MonthlyBudget(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      year: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}year'],
      )!,
      month: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}month'],
      )!,
      amountPaise: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_paise'],
      )!,
      carryForward: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}carry_forward'],
      )!,
      carriedAmountPaise: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}carried_amount_paise'],
      )!,
    );
  }

  @override
  $MonthlyBudgetsTable createAlias(String alias) {
    return $MonthlyBudgetsTable(attachedDatabase, alias);
  }
}

class MonthlyBudget extends DataClass implements Insertable<MonthlyBudget> {
  final int id;
  final int year;
  final int month;
  final int amountPaise;
  final bool carryForward;
  final int carriedAmountPaise;
  const MonthlyBudget({
    required this.id,
    required this.year,
    required this.month,
    required this.amountPaise,
    required this.carryForward,
    required this.carriedAmountPaise,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['year'] = Variable<int>(year);
    map['month'] = Variable<int>(month);
    map['amount_paise'] = Variable<int>(amountPaise);
    map['carry_forward'] = Variable<bool>(carryForward);
    map['carried_amount_paise'] = Variable<int>(carriedAmountPaise);
    return map;
  }

  MonthlyBudgetsCompanion toCompanion(bool nullToAbsent) {
    return MonthlyBudgetsCompanion(
      id: Value(id),
      year: Value(year),
      month: Value(month),
      amountPaise: Value(amountPaise),
      carryForward: Value(carryForward),
      carriedAmountPaise: Value(carriedAmountPaise),
    );
  }

  factory MonthlyBudget.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MonthlyBudget(
      id: serializer.fromJson<int>(json['id']),
      year: serializer.fromJson<int>(json['year']),
      month: serializer.fromJson<int>(json['month']),
      amountPaise: serializer.fromJson<int>(json['amountPaise']),
      carryForward: serializer.fromJson<bool>(json['carryForward']),
      carriedAmountPaise: serializer.fromJson<int>(json['carriedAmountPaise']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'year': serializer.toJson<int>(year),
      'month': serializer.toJson<int>(month),
      'amountPaise': serializer.toJson<int>(amountPaise),
      'carryForward': serializer.toJson<bool>(carryForward),
      'carriedAmountPaise': serializer.toJson<int>(carriedAmountPaise),
    };
  }

  MonthlyBudget copyWith({
    int? id,
    int? year,
    int? month,
    int? amountPaise,
    bool? carryForward,
    int? carriedAmountPaise,
  }) => MonthlyBudget(
    id: id ?? this.id,
    year: year ?? this.year,
    month: month ?? this.month,
    amountPaise: amountPaise ?? this.amountPaise,
    carryForward: carryForward ?? this.carryForward,
    carriedAmountPaise: carriedAmountPaise ?? this.carriedAmountPaise,
  );
  MonthlyBudget copyWithCompanion(MonthlyBudgetsCompanion data) {
    return MonthlyBudget(
      id: data.id.present ? data.id.value : this.id,
      year: data.year.present ? data.year.value : this.year,
      month: data.month.present ? data.month.value : this.month,
      amountPaise: data.amountPaise.present
          ? data.amountPaise.value
          : this.amountPaise,
      carryForward: data.carryForward.present
          ? data.carryForward.value
          : this.carryForward,
      carriedAmountPaise: data.carriedAmountPaise.present
          ? data.carriedAmountPaise.value
          : this.carriedAmountPaise,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MonthlyBudget(')
          ..write('id: $id, ')
          ..write('year: $year, ')
          ..write('month: $month, ')
          ..write('amountPaise: $amountPaise, ')
          ..write('carryForward: $carryForward, ')
          ..write('carriedAmountPaise: $carriedAmountPaise')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    year,
    month,
    amountPaise,
    carryForward,
    carriedAmountPaise,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MonthlyBudget &&
          other.id == this.id &&
          other.year == this.year &&
          other.month == this.month &&
          other.amountPaise == this.amountPaise &&
          other.carryForward == this.carryForward &&
          other.carriedAmountPaise == this.carriedAmountPaise);
}

class MonthlyBudgetsCompanion extends UpdateCompanion<MonthlyBudget> {
  final Value<int> id;
  final Value<int> year;
  final Value<int> month;
  final Value<int> amountPaise;
  final Value<bool> carryForward;
  final Value<int> carriedAmountPaise;
  const MonthlyBudgetsCompanion({
    this.id = const Value.absent(),
    this.year = const Value.absent(),
    this.month = const Value.absent(),
    this.amountPaise = const Value.absent(),
    this.carryForward = const Value.absent(),
    this.carriedAmountPaise = const Value.absent(),
  });
  MonthlyBudgetsCompanion.insert({
    this.id = const Value.absent(),
    required int year,
    required int month,
    required int amountPaise,
    this.carryForward = const Value.absent(),
    this.carriedAmountPaise = const Value.absent(),
  }) : year = Value(year),
       month = Value(month),
       amountPaise = Value(amountPaise);
  static Insertable<MonthlyBudget> custom({
    Expression<int>? id,
    Expression<int>? year,
    Expression<int>? month,
    Expression<int>? amountPaise,
    Expression<bool>? carryForward,
    Expression<int>? carriedAmountPaise,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (year != null) 'year': year,
      if (month != null) 'month': month,
      if (amountPaise != null) 'amount_paise': amountPaise,
      if (carryForward != null) 'carry_forward': carryForward,
      if (carriedAmountPaise != null)
        'carried_amount_paise': carriedAmountPaise,
    });
  }

  MonthlyBudgetsCompanion copyWith({
    Value<int>? id,
    Value<int>? year,
    Value<int>? month,
    Value<int>? amountPaise,
    Value<bool>? carryForward,
    Value<int>? carriedAmountPaise,
  }) {
    return MonthlyBudgetsCompanion(
      id: id ?? this.id,
      year: year ?? this.year,
      month: month ?? this.month,
      amountPaise: amountPaise ?? this.amountPaise,
      carryForward: carryForward ?? this.carryForward,
      carriedAmountPaise: carriedAmountPaise ?? this.carriedAmountPaise,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (year.present) {
      map['year'] = Variable<int>(year.value);
    }
    if (month.present) {
      map['month'] = Variable<int>(month.value);
    }
    if (amountPaise.present) {
      map['amount_paise'] = Variable<int>(amountPaise.value);
    }
    if (carryForward.present) {
      map['carry_forward'] = Variable<bool>(carryForward.value);
    }
    if (carriedAmountPaise.present) {
      map['carried_amount_paise'] = Variable<int>(carriedAmountPaise.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MonthlyBudgetsCompanion(')
          ..write('id: $id, ')
          ..write('year: $year, ')
          ..write('month: $month, ')
          ..write('amountPaise: $amountPaise, ')
          ..write('carryForward: $carryForward, ')
          ..write('carriedAmountPaise: $carriedAmountPaise')
          ..write(')'))
        .toString();
  }
}

class $CategoriesTable extends Categories
    with TableInfo<$CategoriesTable, Category> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 50,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _emojiMeta = const VerificationMeta('emoji');
  @override
  late final GeneratedColumn<String> emoji = GeneratedColumn<String>(
    'emoji',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 10,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _colorHexMeta = const VerificationMeta(
    'colorHex',
  );
  @override
  late final GeneratedColumn<String> colorHex = GeneratedColumn<String>(
    'color_hex',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 6,
      maxTextLength: 9,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _monthlyLimitPaiseMeta = const VerificationMeta(
    'monthlyLimitPaise',
  );
  @override
  late final GeneratedColumn<int> monthlyLimitPaise = GeneratedColumn<int>(
    'monthly_limit_paise',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    emoji,
    colorHex,
    monthlyLimitPaise,
    isActive,
    sortOrder,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categories';
  @override
  VerificationContext validateIntegrity(
    Insertable<Category> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('emoji')) {
      context.handle(
        _emojiMeta,
        emoji.isAcceptableOrUnknown(data['emoji']!, _emojiMeta),
      );
    } else if (isInserting) {
      context.missing(_emojiMeta);
    }
    if (data.containsKey('color_hex')) {
      context.handle(
        _colorHexMeta,
        colorHex.isAcceptableOrUnknown(data['color_hex']!, _colorHexMeta),
      );
    } else if (isInserting) {
      context.missing(_colorHexMeta);
    }
    if (data.containsKey('monthly_limit_paise')) {
      context.handle(
        _monthlyLimitPaiseMeta,
        monthlyLimitPaise.isAcceptableOrUnknown(
          data['monthly_limit_paise']!,
          _monthlyLimitPaiseMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_monthlyLimitPaiseMeta);
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Category map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Category(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      emoji: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}emoji'],
      )!,
      colorHex: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}color_hex'],
      )!,
      monthlyLimitPaise: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}monthly_limit_paise'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
    );
  }

  @override
  $CategoriesTable createAlias(String alias) {
    return $CategoriesTable(attachedDatabase, alias);
  }
}

class Category extends DataClass implements Insertable<Category> {
  final int id;
  final String name;
  final String emoji;
  final String colorHex;
  final int monthlyLimitPaise;
  final bool isActive;
  final int sortOrder;
  const Category({
    required this.id,
    required this.name,
    required this.emoji,
    required this.colorHex,
    required this.monthlyLimitPaise,
    required this.isActive,
    required this.sortOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['emoji'] = Variable<String>(emoji);
    map['color_hex'] = Variable<String>(colorHex);
    map['monthly_limit_paise'] = Variable<int>(monthlyLimitPaise);
    map['is_active'] = Variable<bool>(isActive);
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  CategoriesCompanion toCompanion(bool nullToAbsent) {
    return CategoriesCompanion(
      id: Value(id),
      name: Value(name),
      emoji: Value(emoji),
      colorHex: Value(colorHex),
      monthlyLimitPaise: Value(monthlyLimitPaise),
      isActive: Value(isActive),
      sortOrder: Value(sortOrder),
    );
  }

  factory Category.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Category(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      emoji: serializer.fromJson<String>(json['emoji']),
      colorHex: serializer.fromJson<String>(json['colorHex']),
      monthlyLimitPaise: serializer.fromJson<int>(json['monthlyLimitPaise']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'emoji': serializer.toJson<String>(emoji),
      'colorHex': serializer.toJson<String>(colorHex),
      'monthlyLimitPaise': serializer.toJson<int>(monthlyLimitPaise),
      'isActive': serializer.toJson<bool>(isActive),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  Category copyWith({
    int? id,
    String? name,
    String? emoji,
    String? colorHex,
    int? monthlyLimitPaise,
    bool? isActive,
    int? sortOrder,
  }) => Category(
    id: id ?? this.id,
    name: name ?? this.name,
    emoji: emoji ?? this.emoji,
    colorHex: colorHex ?? this.colorHex,
    monthlyLimitPaise: monthlyLimitPaise ?? this.monthlyLimitPaise,
    isActive: isActive ?? this.isActive,
    sortOrder: sortOrder ?? this.sortOrder,
  );
  Category copyWithCompanion(CategoriesCompanion data) {
    return Category(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      emoji: data.emoji.present ? data.emoji.value : this.emoji,
      colorHex: data.colorHex.present ? data.colorHex.value : this.colorHex,
      monthlyLimitPaise: data.monthlyLimitPaise.present
          ? data.monthlyLimitPaise.value
          : this.monthlyLimitPaise,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Category(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('emoji: $emoji, ')
          ..write('colorHex: $colorHex, ')
          ..write('monthlyLimitPaise: $monthlyLimitPaise, ')
          ..write('isActive: $isActive, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    emoji,
    colorHex,
    monthlyLimitPaise,
    isActive,
    sortOrder,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Category &&
          other.id == this.id &&
          other.name == this.name &&
          other.emoji == this.emoji &&
          other.colorHex == this.colorHex &&
          other.monthlyLimitPaise == this.monthlyLimitPaise &&
          other.isActive == this.isActive &&
          other.sortOrder == this.sortOrder);
}

class CategoriesCompanion extends UpdateCompanion<Category> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> emoji;
  final Value<String> colorHex;
  final Value<int> monthlyLimitPaise;
  final Value<bool> isActive;
  final Value<int> sortOrder;
  const CategoriesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.emoji = const Value.absent(),
    this.colorHex = const Value.absent(),
    this.monthlyLimitPaise = const Value.absent(),
    this.isActive = const Value.absent(),
    this.sortOrder = const Value.absent(),
  });
  CategoriesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String emoji,
    required String colorHex,
    required int monthlyLimitPaise,
    this.isActive = const Value.absent(),
    this.sortOrder = const Value.absent(),
  }) : name = Value(name),
       emoji = Value(emoji),
       colorHex = Value(colorHex),
       monthlyLimitPaise = Value(monthlyLimitPaise);
  static Insertable<Category> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? emoji,
    Expression<String>? colorHex,
    Expression<int>? monthlyLimitPaise,
    Expression<bool>? isActive,
    Expression<int>? sortOrder,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (emoji != null) 'emoji': emoji,
      if (colorHex != null) 'color_hex': colorHex,
      if (monthlyLimitPaise != null) 'monthly_limit_paise': monthlyLimitPaise,
      if (isActive != null) 'is_active': isActive,
      if (sortOrder != null) 'sort_order': sortOrder,
    });
  }

  CategoriesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? emoji,
    Value<String>? colorHex,
    Value<int>? monthlyLimitPaise,
    Value<bool>? isActive,
    Value<int>? sortOrder,
  }) {
    return CategoriesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      emoji: emoji ?? this.emoji,
      colorHex: colorHex ?? this.colorHex,
      monthlyLimitPaise: monthlyLimitPaise ?? this.monthlyLimitPaise,
      isActive: isActive ?? this.isActive,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (emoji.present) {
      map['emoji'] = Variable<String>(emoji.value);
    }
    if (colorHex.present) {
      map['color_hex'] = Variable<String>(colorHex.value);
    }
    if (monthlyLimitPaise.present) {
      map['monthly_limit_paise'] = Variable<int>(monthlyLimitPaise.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('emoji: $emoji, ')
          ..write('colorHex: $colorHex, ')
          ..write('monthlyLimitPaise: $monthlyLimitPaise, ')
          ..write('isActive: $isActive, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }
}

class $ExpensesTable extends Expenses with TableInfo<$ExpensesTable, Expense> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExpensesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
    'category_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _whereSpentMeta = const VerificationMeta(
    'whereSpent',
  );
  @override
  late final GeneratedColumn<String> whereSpent = GeneratedColumn<String>(
    'where_spent',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountPaiseMeta = const VerificationMeta(
    'amountPaise',
  );
  @override
  late final GeneratedColumn<int> amountPaise = GeneratedColumn<int>(
    'amount_paise',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _paymentModeMeta = const VerificationMeta(
    'paymentMode',
  );
  @override
  late final GeneratedColumn<String> paymentMode = GeneratedColumn<String>(
    'payment_mode',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 50,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _receiptPathMeta = const VerificationMeta(
    'receiptPath',
  );
  @override
  late final GeneratedColumn<String> receiptPath = GeneratedColumn<String>(
    'receipt_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _splitExpenseIdMeta = const VerificationMeta(
    'splitExpenseId',
  );
  @override
  late final GeneratedColumn<String> splitExpenseId = GeneratedColumn<String>(
    'split_expense_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isRecurringGeneratedMeta =
      const VerificationMeta('isRecurringGenerated');
  @override
  late final GeneratedColumn<bool> isRecurringGenerated = GeneratedColumn<bool>(
    'is_recurring_generated',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_recurring_generated" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    date,
    categoryId,
    whereSpent,
    amountPaise,
    paymentMode,
    note,
    receiptPath,
    splitExpenseId,
    isRecurringGenerated,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'expenses';
  @override
  VerificationContext validateIntegrity(
    Insertable<Expense> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('where_spent')) {
      context.handle(
        _whereSpentMeta,
        whereSpent.isAcceptableOrUnknown(data['where_spent']!, _whereSpentMeta),
      );
    } else if (isInserting) {
      context.missing(_whereSpentMeta);
    }
    if (data.containsKey('amount_paise')) {
      context.handle(
        _amountPaiseMeta,
        amountPaise.isAcceptableOrUnknown(
          data['amount_paise']!,
          _amountPaiseMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_amountPaiseMeta);
    }
    if (data.containsKey('payment_mode')) {
      context.handle(
        _paymentModeMeta,
        paymentMode.isAcceptableOrUnknown(
          data['payment_mode']!,
          _paymentModeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_paymentModeMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('receipt_path')) {
      context.handle(
        _receiptPathMeta,
        receiptPath.isAcceptableOrUnknown(
          data['receipt_path']!,
          _receiptPathMeta,
        ),
      );
    }
    if (data.containsKey('split_expense_id')) {
      context.handle(
        _splitExpenseIdMeta,
        splitExpenseId.isAcceptableOrUnknown(
          data['split_expense_id']!,
          _splitExpenseIdMeta,
        ),
      );
    }
    if (data.containsKey('is_recurring_generated')) {
      context.handle(
        _isRecurringGeneratedMeta,
        isRecurringGenerated.isAcceptableOrUnknown(
          data['is_recurring_generated']!,
          _isRecurringGeneratedMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Expense map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Expense(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}category_id'],
      )!,
      whereSpent: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}where_spent'],
      )!,
      amountPaise: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_paise'],
      )!,
      paymentMode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payment_mode'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      receiptPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}receipt_path'],
      ),
      splitExpenseId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}split_expense_id'],
      ),
      isRecurringGenerated: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_recurring_generated'],
      )!,
    );
  }

  @override
  $ExpensesTable createAlias(String alias) {
    return $ExpensesTable(attachedDatabase, alias);
  }
}

class Expense extends DataClass implements Insertable<Expense> {
  final int id;
  final DateTime date;
  final int categoryId;
  final String whereSpent;
  final int amountPaise;
  final String paymentMode;
  final String? note;
  final String? receiptPath;
  final String? splitExpenseId;
  final bool isRecurringGenerated;
  const Expense({
    required this.id,
    required this.date,
    required this.categoryId,
    required this.whereSpent,
    required this.amountPaise,
    required this.paymentMode,
    this.note,
    this.receiptPath,
    this.splitExpenseId,
    required this.isRecurringGenerated,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date'] = Variable<DateTime>(date);
    map['category_id'] = Variable<int>(categoryId);
    map['where_spent'] = Variable<String>(whereSpent);
    map['amount_paise'] = Variable<int>(amountPaise);
    map['payment_mode'] = Variable<String>(paymentMode);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    if (!nullToAbsent || receiptPath != null) {
      map['receipt_path'] = Variable<String>(receiptPath);
    }
    if (!nullToAbsent || splitExpenseId != null) {
      map['split_expense_id'] = Variable<String>(splitExpenseId);
    }
    map['is_recurring_generated'] = Variable<bool>(isRecurringGenerated);
    return map;
  }

  ExpensesCompanion toCompanion(bool nullToAbsent) {
    return ExpensesCompanion(
      id: Value(id),
      date: Value(date),
      categoryId: Value(categoryId),
      whereSpent: Value(whereSpent),
      amountPaise: Value(amountPaise),
      paymentMode: Value(paymentMode),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      receiptPath: receiptPath == null && nullToAbsent
          ? const Value.absent()
          : Value(receiptPath),
      splitExpenseId: splitExpenseId == null && nullToAbsent
          ? const Value.absent()
          : Value(splitExpenseId),
      isRecurringGenerated: Value(isRecurringGenerated),
    );
  }

  factory Expense.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Expense(
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<DateTime>(json['date']),
      categoryId: serializer.fromJson<int>(json['categoryId']),
      whereSpent: serializer.fromJson<String>(json['whereSpent']),
      amountPaise: serializer.fromJson<int>(json['amountPaise']),
      paymentMode: serializer.fromJson<String>(json['paymentMode']),
      note: serializer.fromJson<String?>(json['note']),
      receiptPath: serializer.fromJson<String?>(json['receiptPath']),
      splitExpenseId: serializer.fromJson<String?>(json['splitExpenseId']),
      isRecurringGenerated: serializer.fromJson<bool>(
        json['isRecurringGenerated'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'date': serializer.toJson<DateTime>(date),
      'categoryId': serializer.toJson<int>(categoryId),
      'whereSpent': serializer.toJson<String>(whereSpent),
      'amountPaise': serializer.toJson<int>(amountPaise),
      'paymentMode': serializer.toJson<String>(paymentMode),
      'note': serializer.toJson<String?>(note),
      'receiptPath': serializer.toJson<String?>(receiptPath),
      'splitExpenseId': serializer.toJson<String?>(splitExpenseId),
      'isRecurringGenerated': serializer.toJson<bool>(isRecurringGenerated),
    };
  }

  Expense copyWith({
    int? id,
    DateTime? date,
    int? categoryId,
    String? whereSpent,
    int? amountPaise,
    String? paymentMode,
    Value<String?> note = const Value.absent(),
    Value<String?> receiptPath = const Value.absent(),
    Value<String?> splitExpenseId = const Value.absent(),
    bool? isRecurringGenerated,
  }) => Expense(
    id: id ?? this.id,
    date: date ?? this.date,
    categoryId: categoryId ?? this.categoryId,
    whereSpent: whereSpent ?? this.whereSpent,
    amountPaise: amountPaise ?? this.amountPaise,
    paymentMode: paymentMode ?? this.paymentMode,
    note: note.present ? note.value : this.note,
    receiptPath: receiptPath.present ? receiptPath.value : this.receiptPath,
    splitExpenseId: splitExpenseId.present
        ? splitExpenseId.value
        : this.splitExpenseId,
    isRecurringGenerated: isRecurringGenerated ?? this.isRecurringGenerated,
  );
  Expense copyWithCompanion(ExpensesCompanion data) {
    return Expense(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      whereSpent: data.whereSpent.present
          ? data.whereSpent.value
          : this.whereSpent,
      amountPaise: data.amountPaise.present
          ? data.amountPaise.value
          : this.amountPaise,
      paymentMode: data.paymentMode.present
          ? data.paymentMode.value
          : this.paymentMode,
      note: data.note.present ? data.note.value : this.note,
      receiptPath: data.receiptPath.present
          ? data.receiptPath.value
          : this.receiptPath,
      splitExpenseId: data.splitExpenseId.present
          ? data.splitExpenseId.value
          : this.splitExpenseId,
      isRecurringGenerated: data.isRecurringGenerated.present
          ? data.isRecurringGenerated.value
          : this.isRecurringGenerated,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Expense(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('categoryId: $categoryId, ')
          ..write('whereSpent: $whereSpent, ')
          ..write('amountPaise: $amountPaise, ')
          ..write('paymentMode: $paymentMode, ')
          ..write('note: $note, ')
          ..write('receiptPath: $receiptPath, ')
          ..write('splitExpenseId: $splitExpenseId, ')
          ..write('isRecurringGenerated: $isRecurringGenerated')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    date,
    categoryId,
    whereSpent,
    amountPaise,
    paymentMode,
    note,
    receiptPath,
    splitExpenseId,
    isRecurringGenerated,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Expense &&
          other.id == this.id &&
          other.date == this.date &&
          other.categoryId == this.categoryId &&
          other.whereSpent == this.whereSpent &&
          other.amountPaise == this.amountPaise &&
          other.paymentMode == this.paymentMode &&
          other.note == this.note &&
          other.receiptPath == this.receiptPath &&
          other.splitExpenseId == this.splitExpenseId &&
          other.isRecurringGenerated == this.isRecurringGenerated);
}

class ExpensesCompanion extends UpdateCompanion<Expense> {
  final Value<int> id;
  final Value<DateTime> date;
  final Value<int> categoryId;
  final Value<String> whereSpent;
  final Value<int> amountPaise;
  final Value<String> paymentMode;
  final Value<String?> note;
  final Value<String?> receiptPath;
  final Value<String?> splitExpenseId;
  final Value<bool> isRecurringGenerated;
  const ExpensesCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.whereSpent = const Value.absent(),
    this.amountPaise = const Value.absent(),
    this.paymentMode = const Value.absent(),
    this.note = const Value.absent(),
    this.receiptPath = const Value.absent(),
    this.splitExpenseId = const Value.absent(),
    this.isRecurringGenerated = const Value.absent(),
  });
  ExpensesCompanion.insert({
    this.id = const Value.absent(),
    required DateTime date,
    required int categoryId,
    required String whereSpent,
    required int amountPaise,
    required String paymentMode,
    this.note = const Value.absent(),
    this.receiptPath = const Value.absent(),
    this.splitExpenseId = const Value.absent(),
    this.isRecurringGenerated = const Value.absent(),
  }) : date = Value(date),
       categoryId = Value(categoryId),
       whereSpent = Value(whereSpent),
       amountPaise = Value(amountPaise),
       paymentMode = Value(paymentMode);
  static Insertable<Expense> custom({
    Expression<int>? id,
    Expression<DateTime>? date,
    Expression<int>? categoryId,
    Expression<String>? whereSpent,
    Expression<int>? amountPaise,
    Expression<String>? paymentMode,
    Expression<String>? note,
    Expression<String>? receiptPath,
    Expression<String>? splitExpenseId,
    Expression<bool>? isRecurringGenerated,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (categoryId != null) 'category_id': categoryId,
      if (whereSpent != null) 'where_spent': whereSpent,
      if (amountPaise != null) 'amount_paise': amountPaise,
      if (paymentMode != null) 'payment_mode': paymentMode,
      if (note != null) 'note': note,
      if (receiptPath != null) 'receipt_path': receiptPath,
      if (splitExpenseId != null) 'split_expense_id': splitExpenseId,
      if (isRecurringGenerated != null)
        'is_recurring_generated': isRecurringGenerated,
    });
  }

  ExpensesCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? date,
    Value<int>? categoryId,
    Value<String>? whereSpent,
    Value<int>? amountPaise,
    Value<String>? paymentMode,
    Value<String?>? note,
    Value<String?>? receiptPath,
    Value<String?>? splitExpenseId,
    Value<bool>? isRecurringGenerated,
  }) {
    return ExpensesCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      categoryId: categoryId ?? this.categoryId,
      whereSpent: whereSpent ?? this.whereSpent,
      amountPaise: amountPaise ?? this.amountPaise,
      paymentMode: paymentMode ?? this.paymentMode,
      note: note ?? this.note,
      receiptPath: receiptPath ?? this.receiptPath,
      splitExpenseId: splitExpenseId ?? this.splitExpenseId,
      isRecurringGenerated: isRecurringGenerated ?? this.isRecurringGenerated,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    if (whereSpent.present) {
      map['where_spent'] = Variable<String>(whereSpent.value);
    }
    if (amountPaise.present) {
      map['amount_paise'] = Variable<int>(amountPaise.value);
    }
    if (paymentMode.present) {
      map['payment_mode'] = Variable<String>(paymentMode.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (receiptPath.present) {
      map['receipt_path'] = Variable<String>(receiptPath.value);
    }
    if (splitExpenseId.present) {
      map['split_expense_id'] = Variable<String>(splitExpenseId.value);
    }
    if (isRecurringGenerated.present) {
      map['is_recurring_generated'] = Variable<bool>(
        isRecurringGenerated.value,
      );
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExpensesCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('categoryId: $categoryId, ')
          ..write('whereSpent: $whereSpent, ')
          ..write('amountPaise: $amountPaise, ')
          ..write('paymentMode: $paymentMode, ')
          ..write('note: $note, ')
          ..write('receiptPath: $receiptPath, ')
          ..write('splitExpenseId: $splitExpenseId, ')
          ..write('isRecurringGenerated: $isRecurringGenerated')
          ..write(')'))
        .toString();
  }
}

class $PaymentModesTable extends PaymentModes
    with TableInfo<$PaymentModesTable, PaymentMode> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PaymentModesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, isActive];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'payment_modes';
  @override
  VerificationContext validateIntegrity(
    Insertable<PaymentMode> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PaymentMode map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PaymentMode(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
    );
  }

  @override
  $PaymentModesTable createAlias(String alias) {
    return $PaymentModesTable(attachedDatabase, alias);
  }
}

class PaymentMode extends DataClass implements Insertable<PaymentMode> {
  final int id;
  final String name;
  final bool isActive;
  const PaymentMode({
    required this.id,
    required this.name,
    required this.isActive,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  PaymentModesCompanion toCompanion(bool nullToAbsent) {
    return PaymentModesCompanion(
      id: Value(id),
      name: Value(name),
      isActive: Value(isActive),
    );
  }

  factory PaymentMode.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PaymentMode(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  PaymentMode copyWith({int? id, String? name, bool? isActive}) => PaymentMode(
    id: id ?? this.id,
    name: name ?? this.name,
    isActive: isActive ?? this.isActive,
  );
  PaymentMode copyWithCompanion(PaymentModesCompanion data) {
    return PaymentMode(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PaymentMode(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, isActive);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PaymentMode &&
          other.id == this.id &&
          other.name == this.name &&
          other.isActive == this.isActive);
}

class PaymentModesCompanion extends UpdateCompanion<PaymentMode> {
  final Value<int> id;
  final Value<String> name;
  final Value<bool> isActive;
  const PaymentModesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.isActive = const Value.absent(),
  });
  PaymentModesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.isActive = const Value.absent(),
  }) : name = Value(name);
  static Insertable<PaymentMode> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<bool>? isActive,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (isActive != null) 'is_active': isActive,
    });
  }

  PaymentModesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<bool>? isActive,
  }) {
    return PaymentModesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PaymentModesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }
}

class $RecurringExpensesTable extends RecurringExpenses
    with TableInfo<$RecurringExpensesTable, RecurringExpense> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecurringExpensesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
    'category_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountPaiseMeta = const VerificationMeta(
    'amountPaise',
  );
  @override
  late final GeneratedColumn<int> amountPaise = GeneratedColumn<int>(
    'amount_paise',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dayOfMonthMeta = const VerificationMeta(
    'dayOfMonth',
  );
  @override
  late final GeneratedColumn<int> dayOfMonth = GeneratedColumn<int>(
    'day_of_month',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _paymentModeMeta = const VerificationMeta(
    'paymentMode',
  );
  @override
  late final GeneratedColumn<String> paymentMode = GeneratedColumn<String>(
    'payment_mode',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('UPI / GPay / PhonePe'),
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    categoryId,
    amountPaise,
    dayOfMonth,
    paymentMode,
    isActive,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recurring_expenses';
  @override
  VerificationContext validateIntegrity(
    Insertable<RecurringExpense> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('amount_paise')) {
      context.handle(
        _amountPaiseMeta,
        amountPaise.isAcceptableOrUnknown(
          data['amount_paise']!,
          _amountPaiseMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_amountPaiseMeta);
    }
    if (data.containsKey('day_of_month')) {
      context.handle(
        _dayOfMonthMeta,
        dayOfMonth.isAcceptableOrUnknown(
          data['day_of_month']!,
          _dayOfMonthMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_dayOfMonthMeta);
    }
    if (data.containsKey('payment_mode')) {
      context.handle(
        _paymentModeMeta,
        paymentMode.isAcceptableOrUnknown(
          data['payment_mode']!,
          _paymentModeMeta,
        ),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RecurringExpense map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RecurringExpense(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}category_id'],
      )!,
      amountPaise: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_paise'],
      )!,
      dayOfMonth: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}day_of_month'],
      )!,
      paymentMode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payment_mode'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
    );
  }

  @override
  $RecurringExpensesTable createAlias(String alias) {
    return $RecurringExpensesTable(attachedDatabase, alias);
  }
}

class RecurringExpense extends DataClass
    implements Insertable<RecurringExpense> {
  final int id;
  final String title;
  final int categoryId;
  final int amountPaise;
  final int dayOfMonth;
  final String paymentMode;
  final bool isActive;
  const RecurringExpense({
    required this.id,
    required this.title,
    required this.categoryId,
    required this.amountPaise,
    required this.dayOfMonth,
    required this.paymentMode,
    required this.isActive,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    map['category_id'] = Variable<int>(categoryId);
    map['amount_paise'] = Variable<int>(amountPaise);
    map['day_of_month'] = Variable<int>(dayOfMonth);
    map['payment_mode'] = Variable<String>(paymentMode);
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  RecurringExpensesCompanion toCompanion(bool nullToAbsent) {
    return RecurringExpensesCompanion(
      id: Value(id),
      title: Value(title),
      categoryId: Value(categoryId),
      amountPaise: Value(amountPaise),
      dayOfMonth: Value(dayOfMonth),
      paymentMode: Value(paymentMode),
      isActive: Value(isActive),
    );
  }

  factory RecurringExpense.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RecurringExpense(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      categoryId: serializer.fromJson<int>(json['categoryId']),
      amountPaise: serializer.fromJson<int>(json['amountPaise']),
      dayOfMonth: serializer.fromJson<int>(json['dayOfMonth']),
      paymentMode: serializer.fromJson<String>(json['paymentMode']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'categoryId': serializer.toJson<int>(categoryId),
      'amountPaise': serializer.toJson<int>(amountPaise),
      'dayOfMonth': serializer.toJson<int>(dayOfMonth),
      'paymentMode': serializer.toJson<String>(paymentMode),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  RecurringExpense copyWith({
    int? id,
    String? title,
    int? categoryId,
    int? amountPaise,
    int? dayOfMonth,
    String? paymentMode,
    bool? isActive,
  }) => RecurringExpense(
    id: id ?? this.id,
    title: title ?? this.title,
    categoryId: categoryId ?? this.categoryId,
    amountPaise: amountPaise ?? this.amountPaise,
    dayOfMonth: dayOfMonth ?? this.dayOfMonth,
    paymentMode: paymentMode ?? this.paymentMode,
    isActive: isActive ?? this.isActive,
  );
  RecurringExpense copyWithCompanion(RecurringExpensesCompanion data) {
    return RecurringExpense(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      amountPaise: data.amountPaise.present
          ? data.amountPaise.value
          : this.amountPaise,
      dayOfMonth: data.dayOfMonth.present
          ? data.dayOfMonth.value
          : this.dayOfMonth,
      paymentMode: data.paymentMode.present
          ? data.paymentMode.value
          : this.paymentMode,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RecurringExpense(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('categoryId: $categoryId, ')
          ..write('amountPaise: $amountPaise, ')
          ..write('dayOfMonth: $dayOfMonth, ')
          ..write('paymentMode: $paymentMode, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    categoryId,
    amountPaise,
    dayOfMonth,
    paymentMode,
    isActive,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RecurringExpense &&
          other.id == this.id &&
          other.title == this.title &&
          other.categoryId == this.categoryId &&
          other.amountPaise == this.amountPaise &&
          other.dayOfMonth == this.dayOfMonth &&
          other.paymentMode == this.paymentMode &&
          other.isActive == this.isActive);
}

class RecurringExpensesCompanion extends UpdateCompanion<RecurringExpense> {
  final Value<int> id;
  final Value<String> title;
  final Value<int> categoryId;
  final Value<int> amountPaise;
  final Value<int> dayOfMonth;
  final Value<String> paymentMode;
  final Value<bool> isActive;
  const RecurringExpensesCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.amountPaise = const Value.absent(),
    this.dayOfMonth = const Value.absent(),
    this.paymentMode = const Value.absent(),
    this.isActive = const Value.absent(),
  });
  RecurringExpensesCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    required int categoryId,
    required int amountPaise,
    required int dayOfMonth,
    this.paymentMode = const Value.absent(),
    this.isActive = const Value.absent(),
  }) : title = Value(title),
       categoryId = Value(categoryId),
       amountPaise = Value(amountPaise),
       dayOfMonth = Value(dayOfMonth);
  static Insertable<RecurringExpense> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<int>? categoryId,
    Expression<int>? amountPaise,
    Expression<int>? dayOfMonth,
    Expression<String>? paymentMode,
    Expression<bool>? isActive,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (categoryId != null) 'category_id': categoryId,
      if (amountPaise != null) 'amount_paise': amountPaise,
      if (dayOfMonth != null) 'day_of_month': dayOfMonth,
      if (paymentMode != null) 'payment_mode': paymentMode,
      if (isActive != null) 'is_active': isActive,
    });
  }

  RecurringExpensesCompanion copyWith({
    Value<int>? id,
    Value<String>? title,
    Value<int>? categoryId,
    Value<int>? amountPaise,
    Value<int>? dayOfMonth,
    Value<String>? paymentMode,
    Value<bool>? isActive,
  }) {
    return RecurringExpensesCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      categoryId: categoryId ?? this.categoryId,
      amountPaise: amountPaise ?? this.amountPaise,
      dayOfMonth: dayOfMonth ?? this.dayOfMonth,
      paymentMode: paymentMode ?? this.paymentMode,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    if (amountPaise.present) {
      map['amount_paise'] = Variable<int>(amountPaise.value);
    }
    if (dayOfMonth.present) {
      map['day_of_month'] = Variable<int>(dayOfMonth.value);
    }
    if (paymentMode.present) {
      map['payment_mode'] = Variable<String>(paymentMode.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecurringExpensesCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('categoryId: $categoryId, ')
          ..write('amountPaise: $amountPaise, ')
          ..write('dayOfMonth: $dayOfMonth, ')
          ..write('paymentMode: $paymentMode, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }
}

class $SavingsGoalsTable extends SavingsGoals
    with TableInfo<$SavingsGoalsTable, SavingsGoal> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SavingsGoalsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetPaiseMeta = const VerificationMeta(
    'targetPaise',
  );
  @override
  late final GeneratedColumn<int> targetPaise = GeneratedColumn<int>(
    'target_paise',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _savedPaiseMeta = const VerificationMeta(
    'savedPaise',
  );
  @override
  late final GeneratedColumn<int> savedPaise = GeneratedColumn<int>(
    'saved_paise',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _deadlineMeta = const VerificationMeta(
    'deadline',
  );
  @override
  late final GeneratedColumn<DateTime> deadline = GeneratedColumn<DateTime>(
    'deadline',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _emojiMeta = const VerificationMeta('emoji');
  @override
  late final GeneratedColumn<String> emoji = GeneratedColumn<String>(
    'emoji',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('🎯'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    targetPaise,
    savedPaise,
    deadline,
    emoji,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'savings_goals';
  @override
  VerificationContext validateIntegrity(
    Insertable<SavingsGoal> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('target_paise')) {
      context.handle(
        _targetPaiseMeta,
        targetPaise.isAcceptableOrUnknown(
          data['target_paise']!,
          _targetPaiseMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_targetPaiseMeta);
    }
    if (data.containsKey('saved_paise')) {
      context.handle(
        _savedPaiseMeta,
        savedPaise.isAcceptableOrUnknown(data['saved_paise']!, _savedPaiseMeta),
      );
    }
    if (data.containsKey('deadline')) {
      context.handle(
        _deadlineMeta,
        deadline.isAcceptableOrUnknown(data['deadline']!, _deadlineMeta),
      );
    }
    if (data.containsKey('emoji')) {
      context.handle(
        _emojiMeta,
        emoji.isAcceptableOrUnknown(data['emoji']!, _emojiMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SavingsGoal map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SavingsGoal(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      targetPaise: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}target_paise'],
      )!,
      savedPaise: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}saved_paise'],
      )!,
      deadline: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deadline'],
      ),
      emoji: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}emoji'],
      )!,
    );
  }

  @override
  $SavingsGoalsTable createAlias(String alias) {
    return $SavingsGoalsTable(attachedDatabase, alias);
  }
}

class SavingsGoal extends DataClass implements Insertable<SavingsGoal> {
  final int id;
  final String name;
  final int targetPaise;
  final int savedPaise;
  final DateTime? deadline;
  final String emoji;
  const SavingsGoal({
    required this.id,
    required this.name,
    required this.targetPaise,
    required this.savedPaise,
    this.deadline,
    required this.emoji,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['target_paise'] = Variable<int>(targetPaise);
    map['saved_paise'] = Variable<int>(savedPaise);
    if (!nullToAbsent || deadline != null) {
      map['deadline'] = Variable<DateTime>(deadline);
    }
    map['emoji'] = Variable<String>(emoji);
    return map;
  }

  SavingsGoalsCompanion toCompanion(bool nullToAbsent) {
    return SavingsGoalsCompanion(
      id: Value(id),
      name: Value(name),
      targetPaise: Value(targetPaise),
      savedPaise: Value(savedPaise),
      deadline: deadline == null && nullToAbsent
          ? const Value.absent()
          : Value(deadline),
      emoji: Value(emoji),
    );
  }

  factory SavingsGoal.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SavingsGoal(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      targetPaise: serializer.fromJson<int>(json['targetPaise']),
      savedPaise: serializer.fromJson<int>(json['savedPaise']),
      deadline: serializer.fromJson<DateTime?>(json['deadline']),
      emoji: serializer.fromJson<String>(json['emoji']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'targetPaise': serializer.toJson<int>(targetPaise),
      'savedPaise': serializer.toJson<int>(savedPaise),
      'deadline': serializer.toJson<DateTime?>(deadline),
      'emoji': serializer.toJson<String>(emoji),
    };
  }

  SavingsGoal copyWith({
    int? id,
    String? name,
    int? targetPaise,
    int? savedPaise,
    Value<DateTime?> deadline = const Value.absent(),
    String? emoji,
  }) => SavingsGoal(
    id: id ?? this.id,
    name: name ?? this.name,
    targetPaise: targetPaise ?? this.targetPaise,
    savedPaise: savedPaise ?? this.savedPaise,
    deadline: deadline.present ? deadline.value : this.deadline,
    emoji: emoji ?? this.emoji,
  );
  SavingsGoal copyWithCompanion(SavingsGoalsCompanion data) {
    return SavingsGoal(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      targetPaise: data.targetPaise.present
          ? data.targetPaise.value
          : this.targetPaise,
      savedPaise: data.savedPaise.present
          ? data.savedPaise.value
          : this.savedPaise,
      deadline: data.deadline.present ? data.deadline.value : this.deadline,
      emoji: data.emoji.present ? data.emoji.value : this.emoji,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SavingsGoal(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('targetPaise: $targetPaise, ')
          ..write('savedPaise: $savedPaise, ')
          ..write('deadline: $deadline, ')
          ..write('emoji: $emoji')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, targetPaise, savedPaise, deadline, emoji);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SavingsGoal &&
          other.id == this.id &&
          other.name == this.name &&
          other.targetPaise == this.targetPaise &&
          other.savedPaise == this.savedPaise &&
          other.deadline == this.deadline &&
          other.emoji == this.emoji);
}

class SavingsGoalsCompanion extends UpdateCompanion<SavingsGoal> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> targetPaise;
  final Value<int> savedPaise;
  final Value<DateTime?> deadline;
  final Value<String> emoji;
  const SavingsGoalsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.targetPaise = const Value.absent(),
    this.savedPaise = const Value.absent(),
    this.deadline = const Value.absent(),
    this.emoji = const Value.absent(),
  });
  SavingsGoalsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required int targetPaise,
    this.savedPaise = const Value.absent(),
    this.deadline = const Value.absent(),
    this.emoji = const Value.absent(),
  }) : name = Value(name),
       targetPaise = Value(targetPaise);
  static Insertable<SavingsGoal> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? targetPaise,
    Expression<int>? savedPaise,
    Expression<DateTime>? deadline,
    Expression<String>? emoji,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (targetPaise != null) 'target_paise': targetPaise,
      if (savedPaise != null) 'saved_paise': savedPaise,
      if (deadline != null) 'deadline': deadline,
      if (emoji != null) 'emoji': emoji,
    });
  }

  SavingsGoalsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<int>? targetPaise,
    Value<int>? savedPaise,
    Value<DateTime?>? deadline,
    Value<String>? emoji,
  }) {
    return SavingsGoalsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      targetPaise: targetPaise ?? this.targetPaise,
      savedPaise: savedPaise ?? this.savedPaise,
      deadline: deadline ?? this.deadline,
      emoji: emoji ?? this.emoji,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (targetPaise.present) {
      map['target_paise'] = Variable<int>(targetPaise.value);
    }
    if (savedPaise.present) {
      map['saved_paise'] = Variable<int>(savedPaise.value);
    }
    if (deadline.present) {
      map['deadline'] = Variable<DateTime>(deadline.value);
    }
    if (emoji.present) {
      map['emoji'] = Variable<String>(emoji.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SavingsGoalsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('targetPaise: $targetPaise, ')
          ..write('savedPaise: $savedPaise, ')
          ..write('deadline: $deadline, ')
          ..write('emoji: $emoji')
          ..write(')'))
        .toString();
  }
}

class $PersonsTable extends Persons with TableInfo<$PersonsTable, Person> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PersonsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _avatarColorMeta = const VerificationMeta(
    'avatarColor',
  );
  @override
  late final GeneratedColumn<String> avatarColor = GeneratedColumn<String>(
    'avatar_color',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('#0D9488'),
  );
  static const VerificationMeta _isArchivedMeta = const VerificationMeta(
    'isArchived',
  );
  @override
  late final GeneratedColumn<bool> isArchived = GeneratedColumn<bool>(
    'is_archived',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_archived" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    phone,
    avatarColor,
    isArchived,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'persons';
  @override
  VerificationContext validateIntegrity(
    Insertable<Person> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    }
    if (data.containsKey('avatar_color')) {
      context.handle(
        _avatarColorMeta,
        avatarColor.isAcceptableOrUnknown(
          data['avatar_color']!,
          _avatarColorMeta,
        ),
      );
    }
    if (data.containsKey('is_archived')) {
      context.handle(
        _isArchivedMeta,
        isArchived.isAcceptableOrUnknown(data['is_archived']!, _isArchivedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Person map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Person(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      ),
      avatarColor: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}avatar_color'],
      )!,
      isArchived: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_archived'],
      )!,
    );
  }

  @override
  $PersonsTable createAlias(String alias) {
    return $PersonsTable(attachedDatabase, alias);
  }
}

class Person extends DataClass implements Insertable<Person> {
  final int id;
  final String name;
  final String? phone;
  final String avatarColor;
  final bool isArchived;
  const Person({
    required this.id,
    required this.name,
    this.phone,
    required this.avatarColor,
    required this.isArchived,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    map['avatar_color'] = Variable<String>(avatarColor);
    map['is_archived'] = Variable<bool>(isArchived);
    return map;
  }

  PersonsCompanion toCompanion(bool nullToAbsent) {
    return PersonsCompanion(
      id: Value(id),
      name: Value(name),
      phone: phone == null && nullToAbsent
          ? const Value.absent()
          : Value(phone),
      avatarColor: Value(avatarColor),
      isArchived: Value(isArchived),
    );
  }

  factory Person.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Person(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      phone: serializer.fromJson<String?>(json['phone']),
      avatarColor: serializer.fromJson<String>(json['avatarColor']),
      isArchived: serializer.fromJson<bool>(json['isArchived']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'phone': serializer.toJson<String?>(phone),
      'avatarColor': serializer.toJson<String>(avatarColor),
      'isArchived': serializer.toJson<bool>(isArchived),
    };
  }

  Person copyWith({
    int? id,
    String? name,
    Value<String?> phone = const Value.absent(),
    String? avatarColor,
    bool? isArchived,
  }) => Person(
    id: id ?? this.id,
    name: name ?? this.name,
    phone: phone.present ? phone.value : this.phone,
    avatarColor: avatarColor ?? this.avatarColor,
    isArchived: isArchived ?? this.isArchived,
  );
  Person copyWithCompanion(PersonsCompanion data) {
    return Person(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      phone: data.phone.present ? data.phone.value : this.phone,
      avatarColor: data.avatarColor.present
          ? data.avatarColor.value
          : this.avatarColor,
      isArchived: data.isArchived.present
          ? data.isArchived.value
          : this.isArchived,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Person(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('avatarColor: $avatarColor, ')
          ..write('isArchived: $isArchived')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, phone, avatarColor, isArchived);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Person &&
          other.id == this.id &&
          other.name == this.name &&
          other.phone == this.phone &&
          other.avatarColor == this.avatarColor &&
          other.isArchived == this.isArchived);
}

class PersonsCompanion extends UpdateCompanion<Person> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> phone;
  final Value<String> avatarColor;
  final Value<bool> isArchived;
  const PersonsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.phone = const Value.absent(),
    this.avatarColor = const Value.absent(),
    this.isArchived = const Value.absent(),
  });
  PersonsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.phone = const Value.absent(),
    this.avatarColor = const Value.absent(),
    this.isArchived = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Person> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? phone,
    Expression<String>? avatarColor,
    Expression<bool>? isArchived,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (phone != null) 'phone': phone,
      if (avatarColor != null) 'avatar_color': avatarColor,
      if (isArchived != null) 'is_archived': isArchived,
    });
  }

  PersonsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String?>? phone,
    Value<String>? avatarColor,
    Value<bool>? isArchived,
  }) {
    return PersonsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      avatarColor: avatarColor ?? this.avatarColor,
      isArchived: isArchived ?? this.isArchived,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (avatarColor.present) {
      map['avatar_color'] = Variable<String>(avatarColor.value);
    }
    if (isArchived.present) {
      map['is_archived'] = Variable<bool>(isArchived.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PersonsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('avatarColor: $avatarColor, ')
          ..write('isArchived: $isArchived')
          ..write(')'))
        .toString();
  }
}

class $SplitExpensesTable extends SplitExpenses
    with TableInfo<$SplitExpensesTable, SplitExpense> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SplitExpensesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _groupNameMeta = const VerificationMeta(
    'groupName',
  );
  @override
  late final GeneratedColumn<String> groupName = GeneratedColumn<String>(
    'group_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _totalAmountPaiseMeta = const VerificationMeta(
    'totalAmountPaise',
  );
  @override
  late final GeneratedColumn<int> totalAmountPaise = GeneratedColumn<int>(
    'total_amount_paise',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _paidByPersonIdMeta = const VerificationMeta(
    'paidByPersonId',
  );
  @override
  late final GeneratedColumn<int> paidByPersonId = GeneratedColumn<int>(
    'paid_by_person_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _splitTypeMeta = const VerificationMeta(
    'splitType',
  );
  @override
  late final GeneratedColumn<String> splitType = GeneratedColumn<String>(
    'split_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
    'category_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    date,
    title,
    groupName,
    totalAmountPaise,
    paidByPersonId,
    splitType,
    categoryId,
    note,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'split_expenses';
  @override
  VerificationContext validateIntegrity(
    Insertable<SplitExpense> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('group_name')) {
      context.handle(
        _groupNameMeta,
        groupName.isAcceptableOrUnknown(data['group_name']!, _groupNameMeta),
      );
    }
    if (data.containsKey('total_amount_paise')) {
      context.handle(
        _totalAmountPaiseMeta,
        totalAmountPaise.isAcceptableOrUnknown(
          data['total_amount_paise']!,
          _totalAmountPaiseMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_totalAmountPaiseMeta);
    }
    if (data.containsKey('paid_by_person_id')) {
      context.handle(
        _paidByPersonIdMeta,
        paidByPersonId.isAcceptableOrUnknown(
          data['paid_by_person_id']!,
          _paidByPersonIdMeta,
        ),
      );
    }
    if (data.containsKey('split_type')) {
      context.handle(
        _splitTypeMeta,
        splitType.isAcceptableOrUnknown(data['split_type']!, _splitTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_splitTypeMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SplitExpense map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SplitExpense(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      groupName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}group_name'],
      ),
      totalAmountPaise: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_amount_paise'],
      )!,
      paidByPersonId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}paid_by_person_id'],
      ),
      splitType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}split_type'],
      )!,
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}category_id'],
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
    );
  }

  @override
  $SplitExpensesTable createAlias(String alias) {
    return $SplitExpensesTable(attachedDatabase, alias);
  }
}

class SplitExpense extends DataClass implements Insertable<SplitExpense> {
  final String id;
  final DateTime date;
  final String title;
  final String? groupName;
  final int totalAmountPaise;
  final int? paidByPersonId;
  final String splitType;
  final int? categoryId;
  final String? note;
  const SplitExpense({
    required this.id,
    required this.date,
    required this.title,
    this.groupName,
    required this.totalAmountPaise,
    this.paidByPersonId,
    required this.splitType,
    this.categoryId,
    this.note,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['date'] = Variable<DateTime>(date);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || groupName != null) {
      map['group_name'] = Variable<String>(groupName);
    }
    map['total_amount_paise'] = Variable<int>(totalAmountPaise);
    if (!nullToAbsent || paidByPersonId != null) {
      map['paid_by_person_id'] = Variable<int>(paidByPersonId);
    }
    map['split_type'] = Variable<String>(splitType);
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<int>(categoryId);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    return map;
  }

  SplitExpensesCompanion toCompanion(bool nullToAbsent) {
    return SplitExpensesCompanion(
      id: Value(id),
      date: Value(date),
      title: Value(title),
      groupName: groupName == null && nullToAbsent
          ? const Value.absent()
          : Value(groupName),
      totalAmountPaise: Value(totalAmountPaise),
      paidByPersonId: paidByPersonId == null && nullToAbsent
          ? const Value.absent()
          : Value(paidByPersonId),
      splitType: Value(splitType),
      categoryId: categoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryId),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
    );
  }

  factory SplitExpense.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SplitExpense(
      id: serializer.fromJson<String>(json['id']),
      date: serializer.fromJson<DateTime>(json['date']),
      title: serializer.fromJson<String>(json['title']),
      groupName: serializer.fromJson<String?>(json['groupName']),
      totalAmountPaise: serializer.fromJson<int>(json['totalAmountPaise']),
      paidByPersonId: serializer.fromJson<int?>(json['paidByPersonId']),
      splitType: serializer.fromJson<String>(json['splitType']),
      categoryId: serializer.fromJson<int?>(json['categoryId']),
      note: serializer.fromJson<String?>(json['note']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'date': serializer.toJson<DateTime>(date),
      'title': serializer.toJson<String>(title),
      'groupName': serializer.toJson<String?>(groupName),
      'totalAmountPaise': serializer.toJson<int>(totalAmountPaise),
      'paidByPersonId': serializer.toJson<int?>(paidByPersonId),
      'splitType': serializer.toJson<String>(splitType),
      'categoryId': serializer.toJson<int?>(categoryId),
      'note': serializer.toJson<String?>(note),
    };
  }

  SplitExpense copyWith({
    String? id,
    DateTime? date,
    String? title,
    Value<String?> groupName = const Value.absent(),
    int? totalAmountPaise,
    Value<int?> paidByPersonId = const Value.absent(),
    String? splitType,
    Value<int?> categoryId = const Value.absent(),
    Value<String?> note = const Value.absent(),
  }) => SplitExpense(
    id: id ?? this.id,
    date: date ?? this.date,
    title: title ?? this.title,
    groupName: groupName.present ? groupName.value : this.groupName,
    totalAmountPaise: totalAmountPaise ?? this.totalAmountPaise,
    paidByPersonId: paidByPersonId.present
        ? paidByPersonId.value
        : this.paidByPersonId,
    splitType: splitType ?? this.splitType,
    categoryId: categoryId.present ? categoryId.value : this.categoryId,
    note: note.present ? note.value : this.note,
  );
  SplitExpense copyWithCompanion(SplitExpensesCompanion data) {
    return SplitExpense(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      title: data.title.present ? data.title.value : this.title,
      groupName: data.groupName.present ? data.groupName.value : this.groupName,
      totalAmountPaise: data.totalAmountPaise.present
          ? data.totalAmountPaise.value
          : this.totalAmountPaise,
      paidByPersonId: data.paidByPersonId.present
          ? data.paidByPersonId.value
          : this.paidByPersonId,
      splitType: data.splitType.present ? data.splitType.value : this.splitType,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      note: data.note.present ? data.note.value : this.note,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SplitExpense(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('title: $title, ')
          ..write('groupName: $groupName, ')
          ..write('totalAmountPaise: $totalAmountPaise, ')
          ..write('paidByPersonId: $paidByPersonId, ')
          ..write('splitType: $splitType, ')
          ..write('categoryId: $categoryId, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    date,
    title,
    groupName,
    totalAmountPaise,
    paidByPersonId,
    splitType,
    categoryId,
    note,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SplitExpense &&
          other.id == this.id &&
          other.date == this.date &&
          other.title == this.title &&
          other.groupName == this.groupName &&
          other.totalAmountPaise == this.totalAmountPaise &&
          other.paidByPersonId == this.paidByPersonId &&
          other.splitType == this.splitType &&
          other.categoryId == this.categoryId &&
          other.note == this.note);
}

class SplitExpensesCompanion extends UpdateCompanion<SplitExpense> {
  final Value<String> id;
  final Value<DateTime> date;
  final Value<String> title;
  final Value<String?> groupName;
  final Value<int> totalAmountPaise;
  final Value<int?> paidByPersonId;
  final Value<String> splitType;
  final Value<int?> categoryId;
  final Value<String?> note;
  final Value<int> rowid;
  const SplitExpensesCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.title = const Value.absent(),
    this.groupName = const Value.absent(),
    this.totalAmountPaise = const Value.absent(),
    this.paidByPersonId = const Value.absent(),
    this.splitType = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SplitExpensesCompanion.insert({
    required String id,
    required DateTime date,
    required String title,
    this.groupName = const Value.absent(),
    required int totalAmountPaise,
    this.paidByPersonId = const Value.absent(),
    required String splitType,
    this.categoryId = const Value.absent(),
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       date = Value(date),
       title = Value(title),
       totalAmountPaise = Value(totalAmountPaise),
       splitType = Value(splitType);
  static Insertable<SplitExpense> custom({
    Expression<String>? id,
    Expression<DateTime>? date,
    Expression<String>? title,
    Expression<String>? groupName,
    Expression<int>? totalAmountPaise,
    Expression<int>? paidByPersonId,
    Expression<String>? splitType,
    Expression<int>? categoryId,
    Expression<String>? note,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (title != null) 'title': title,
      if (groupName != null) 'group_name': groupName,
      if (totalAmountPaise != null) 'total_amount_paise': totalAmountPaise,
      if (paidByPersonId != null) 'paid_by_person_id': paidByPersonId,
      if (splitType != null) 'split_type': splitType,
      if (categoryId != null) 'category_id': categoryId,
      if (note != null) 'note': note,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SplitExpensesCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? date,
    Value<String>? title,
    Value<String?>? groupName,
    Value<int>? totalAmountPaise,
    Value<int?>? paidByPersonId,
    Value<String>? splitType,
    Value<int?>? categoryId,
    Value<String?>? note,
    Value<int>? rowid,
  }) {
    return SplitExpensesCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      title: title ?? this.title,
      groupName: groupName ?? this.groupName,
      totalAmountPaise: totalAmountPaise ?? this.totalAmountPaise,
      paidByPersonId: paidByPersonId ?? this.paidByPersonId,
      splitType: splitType ?? this.splitType,
      categoryId: categoryId ?? this.categoryId,
      note: note ?? this.note,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (groupName.present) {
      map['group_name'] = Variable<String>(groupName.value);
    }
    if (totalAmountPaise.present) {
      map['total_amount_paise'] = Variable<int>(totalAmountPaise.value);
    }
    if (paidByPersonId.present) {
      map['paid_by_person_id'] = Variable<int>(paidByPersonId.value);
    }
    if (splitType.present) {
      map['split_type'] = Variable<String>(splitType.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SplitExpensesCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('title: $title, ')
          ..write('groupName: $groupName, ')
          ..write('totalAmountPaise: $totalAmountPaise, ')
          ..write('paidByPersonId: $paidByPersonId, ')
          ..write('splitType: $splitType, ')
          ..write('categoryId: $categoryId, ')
          ..write('note: $note, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SplitSharesTable extends SplitShares
    with TableInfo<$SplitSharesTable, SplitShare> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SplitSharesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _splitExpenseIdMeta = const VerificationMeta(
    'splitExpenseId',
  );
  @override
  late final GeneratedColumn<String> splitExpenseId = GeneratedColumn<String>(
    'split_expense_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _personIdMeta = const VerificationMeta(
    'personId',
  );
  @override
  late final GeneratedColumn<int> personId = GeneratedColumn<int>(
    'person_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _shareAmountPaiseMeta = const VerificationMeta(
    'shareAmountPaise',
  );
  @override
  late final GeneratedColumn<int> shareAmountPaise = GeneratedColumn<int>(
    'share_amount_paise',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    splitExpenseId,
    personId,
    shareAmountPaise,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'split_shares';
  @override
  VerificationContext validateIntegrity(
    Insertable<SplitShare> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('split_expense_id')) {
      context.handle(
        _splitExpenseIdMeta,
        splitExpenseId.isAcceptableOrUnknown(
          data['split_expense_id']!,
          _splitExpenseIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_splitExpenseIdMeta);
    }
    if (data.containsKey('person_id')) {
      context.handle(
        _personIdMeta,
        personId.isAcceptableOrUnknown(data['person_id']!, _personIdMeta),
      );
    }
    if (data.containsKey('share_amount_paise')) {
      context.handle(
        _shareAmountPaiseMeta,
        shareAmountPaise.isAcceptableOrUnknown(
          data['share_amount_paise']!,
          _shareAmountPaiseMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_shareAmountPaiseMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SplitShare map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SplitShare(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      splitExpenseId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}split_expense_id'],
      )!,
      personId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}person_id'],
      ),
      shareAmountPaise: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}share_amount_paise'],
      )!,
    );
  }

  @override
  $SplitSharesTable createAlias(String alias) {
    return $SplitSharesTable(attachedDatabase, alias);
  }
}

class SplitShare extends DataClass implements Insertable<SplitShare> {
  final int id;
  final String splitExpenseId;
  final int? personId;
  final int shareAmountPaise;
  const SplitShare({
    required this.id,
    required this.splitExpenseId,
    this.personId,
    required this.shareAmountPaise,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['split_expense_id'] = Variable<String>(splitExpenseId);
    if (!nullToAbsent || personId != null) {
      map['person_id'] = Variable<int>(personId);
    }
    map['share_amount_paise'] = Variable<int>(shareAmountPaise);
    return map;
  }

  SplitSharesCompanion toCompanion(bool nullToAbsent) {
    return SplitSharesCompanion(
      id: Value(id),
      splitExpenseId: Value(splitExpenseId),
      personId: personId == null && nullToAbsent
          ? const Value.absent()
          : Value(personId),
      shareAmountPaise: Value(shareAmountPaise),
    );
  }

  factory SplitShare.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SplitShare(
      id: serializer.fromJson<int>(json['id']),
      splitExpenseId: serializer.fromJson<String>(json['splitExpenseId']),
      personId: serializer.fromJson<int?>(json['personId']),
      shareAmountPaise: serializer.fromJson<int>(json['shareAmountPaise']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'splitExpenseId': serializer.toJson<String>(splitExpenseId),
      'personId': serializer.toJson<int?>(personId),
      'shareAmountPaise': serializer.toJson<int>(shareAmountPaise),
    };
  }

  SplitShare copyWith({
    int? id,
    String? splitExpenseId,
    Value<int?> personId = const Value.absent(),
    int? shareAmountPaise,
  }) => SplitShare(
    id: id ?? this.id,
    splitExpenseId: splitExpenseId ?? this.splitExpenseId,
    personId: personId.present ? personId.value : this.personId,
    shareAmountPaise: shareAmountPaise ?? this.shareAmountPaise,
  );
  SplitShare copyWithCompanion(SplitSharesCompanion data) {
    return SplitShare(
      id: data.id.present ? data.id.value : this.id,
      splitExpenseId: data.splitExpenseId.present
          ? data.splitExpenseId.value
          : this.splitExpenseId,
      personId: data.personId.present ? data.personId.value : this.personId,
      shareAmountPaise: data.shareAmountPaise.present
          ? data.shareAmountPaise.value
          : this.shareAmountPaise,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SplitShare(')
          ..write('id: $id, ')
          ..write('splitExpenseId: $splitExpenseId, ')
          ..write('personId: $personId, ')
          ..write('shareAmountPaise: $shareAmountPaise')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, splitExpenseId, personId, shareAmountPaise);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SplitShare &&
          other.id == this.id &&
          other.splitExpenseId == this.splitExpenseId &&
          other.personId == this.personId &&
          other.shareAmountPaise == this.shareAmountPaise);
}

class SplitSharesCompanion extends UpdateCompanion<SplitShare> {
  final Value<int> id;
  final Value<String> splitExpenseId;
  final Value<int?> personId;
  final Value<int> shareAmountPaise;
  const SplitSharesCompanion({
    this.id = const Value.absent(),
    this.splitExpenseId = const Value.absent(),
    this.personId = const Value.absent(),
    this.shareAmountPaise = const Value.absent(),
  });
  SplitSharesCompanion.insert({
    this.id = const Value.absent(),
    required String splitExpenseId,
    this.personId = const Value.absent(),
    required int shareAmountPaise,
  }) : splitExpenseId = Value(splitExpenseId),
       shareAmountPaise = Value(shareAmountPaise);
  static Insertable<SplitShare> custom({
    Expression<int>? id,
    Expression<String>? splitExpenseId,
    Expression<int>? personId,
    Expression<int>? shareAmountPaise,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (splitExpenseId != null) 'split_expense_id': splitExpenseId,
      if (personId != null) 'person_id': personId,
      if (shareAmountPaise != null) 'share_amount_paise': shareAmountPaise,
    });
  }

  SplitSharesCompanion copyWith({
    Value<int>? id,
    Value<String>? splitExpenseId,
    Value<int?>? personId,
    Value<int>? shareAmountPaise,
  }) {
    return SplitSharesCompanion(
      id: id ?? this.id,
      splitExpenseId: splitExpenseId ?? this.splitExpenseId,
      personId: personId ?? this.personId,
      shareAmountPaise: shareAmountPaise ?? this.shareAmountPaise,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (splitExpenseId.present) {
      map['split_expense_id'] = Variable<String>(splitExpenseId.value);
    }
    if (personId.present) {
      map['person_id'] = Variable<int>(personId.value);
    }
    if (shareAmountPaise.present) {
      map['share_amount_paise'] = Variable<int>(shareAmountPaise.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SplitSharesCompanion(')
          ..write('id: $id, ')
          ..write('splitExpenseId: $splitExpenseId, ')
          ..write('personId: $personId, ')
          ..write('shareAmountPaise: $shareAmountPaise')
          ..write(')'))
        .toString();
  }
}

class $SettlementsTable extends Settlements
    with TableInfo<$SettlementsTable, Settlement> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SettlementsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fromPersonIdMeta = const VerificationMeta(
    'fromPersonId',
  );
  @override
  late final GeneratedColumn<int> fromPersonId = GeneratedColumn<int>(
    'from_person_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _toPersonIdMeta = const VerificationMeta(
    'toPersonId',
  );
  @override
  late final GeneratedColumn<int> toPersonId = GeneratedColumn<int>(
    'to_person_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _amountPaiseMeta = const VerificationMeta(
    'amountPaise',
  );
  @override
  late final GeneratedColumn<int> amountPaise = GeneratedColumn<int>(
    'amount_paise',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _modeMeta = const VerificationMeta('mode');
  @override
  late final GeneratedColumn<String> mode = GeneratedColumn<String>(
    'mode',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('UPI / GPay / PhonePe'),
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    date,
    fromPersonId,
    toPersonId,
    amountPaise,
    mode,
    note,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'settlements';
  @override
  VerificationContext validateIntegrity(
    Insertable<Settlement> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('from_person_id')) {
      context.handle(
        _fromPersonIdMeta,
        fromPersonId.isAcceptableOrUnknown(
          data['from_person_id']!,
          _fromPersonIdMeta,
        ),
      );
    }
    if (data.containsKey('to_person_id')) {
      context.handle(
        _toPersonIdMeta,
        toPersonId.isAcceptableOrUnknown(
          data['to_person_id']!,
          _toPersonIdMeta,
        ),
      );
    }
    if (data.containsKey('amount_paise')) {
      context.handle(
        _amountPaiseMeta,
        amountPaise.isAcceptableOrUnknown(
          data['amount_paise']!,
          _amountPaiseMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_amountPaiseMeta);
    }
    if (data.containsKey('mode')) {
      context.handle(
        _modeMeta,
        mode.isAcceptableOrUnknown(data['mode']!, _modeMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Settlement map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Settlement(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      fromPersonId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}from_person_id'],
      ),
      toPersonId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}to_person_id'],
      ),
      amountPaise: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_paise'],
      )!,
      mode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mode'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
    );
  }

  @override
  $SettlementsTable createAlias(String alias) {
    return $SettlementsTable(attachedDatabase, alias);
  }
}

class Settlement extends DataClass implements Insertable<Settlement> {
  final int id;
  final DateTime date;
  final int? fromPersonId;
  final int? toPersonId;
  final int amountPaise;
  final String mode;
  final String? note;
  const Settlement({
    required this.id,
    required this.date,
    this.fromPersonId,
    this.toPersonId,
    required this.amountPaise,
    required this.mode,
    this.note,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date'] = Variable<DateTime>(date);
    if (!nullToAbsent || fromPersonId != null) {
      map['from_person_id'] = Variable<int>(fromPersonId);
    }
    if (!nullToAbsent || toPersonId != null) {
      map['to_person_id'] = Variable<int>(toPersonId);
    }
    map['amount_paise'] = Variable<int>(amountPaise);
    map['mode'] = Variable<String>(mode);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    return map;
  }

  SettlementsCompanion toCompanion(bool nullToAbsent) {
    return SettlementsCompanion(
      id: Value(id),
      date: Value(date),
      fromPersonId: fromPersonId == null && nullToAbsent
          ? const Value.absent()
          : Value(fromPersonId),
      toPersonId: toPersonId == null && nullToAbsent
          ? const Value.absent()
          : Value(toPersonId),
      amountPaise: Value(amountPaise),
      mode: Value(mode),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
    );
  }

  factory Settlement.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Settlement(
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<DateTime>(json['date']),
      fromPersonId: serializer.fromJson<int?>(json['fromPersonId']),
      toPersonId: serializer.fromJson<int?>(json['toPersonId']),
      amountPaise: serializer.fromJson<int>(json['amountPaise']),
      mode: serializer.fromJson<String>(json['mode']),
      note: serializer.fromJson<String?>(json['note']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'date': serializer.toJson<DateTime>(date),
      'fromPersonId': serializer.toJson<int?>(fromPersonId),
      'toPersonId': serializer.toJson<int?>(toPersonId),
      'amountPaise': serializer.toJson<int>(amountPaise),
      'mode': serializer.toJson<String>(mode),
      'note': serializer.toJson<String?>(note),
    };
  }

  Settlement copyWith({
    int? id,
    DateTime? date,
    Value<int?> fromPersonId = const Value.absent(),
    Value<int?> toPersonId = const Value.absent(),
    int? amountPaise,
    String? mode,
    Value<String?> note = const Value.absent(),
  }) => Settlement(
    id: id ?? this.id,
    date: date ?? this.date,
    fromPersonId: fromPersonId.present ? fromPersonId.value : this.fromPersonId,
    toPersonId: toPersonId.present ? toPersonId.value : this.toPersonId,
    amountPaise: amountPaise ?? this.amountPaise,
    mode: mode ?? this.mode,
    note: note.present ? note.value : this.note,
  );
  Settlement copyWithCompanion(SettlementsCompanion data) {
    return Settlement(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      fromPersonId: data.fromPersonId.present
          ? data.fromPersonId.value
          : this.fromPersonId,
      toPersonId: data.toPersonId.present
          ? data.toPersonId.value
          : this.toPersonId,
      amountPaise: data.amountPaise.present
          ? data.amountPaise.value
          : this.amountPaise,
      mode: data.mode.present ? data.mode.value : this.mode,
      note: data.note.present ? data.note.value : this.note,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Settlement(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('fromPersonId: $fromPersonId, ')
          ..write('toPersonId: $toPersonId, ')
          ..write('amountPaise: $amountPaise, ')
          ..write('mode: $mode, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, date, fromPersonId, toPersonId, amountPaise, mode, note);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Settlement &&
          other.id == this.id &&
          other.date == this.date &&
          other.fromPersonId == this.fromPersonId &&
          other.toPersonId == this.toPersonId &&
          other.amountPaise == this.amountPaise &&
          other.mode == this.mode &&
          other.note == this.note);
}

class SettlementsCompanion extends UpdateCompanion<Settlement> {
  final Value<int> id;
  final Value<DateTime> date;
  final Value<int?> fromPersonId;
  final Value<int?> toPersonId;
  final Value<int> amountPaise;
  final Value<String> mode;
  final Value<String?> note;
  const SettlementsCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.fromPersonId = const Value.absent(),
    this.toPersonId = const Value.absent(),
    this.amountPaise = const Value.absent(),
    this.mode = const Value.absent(),
    this.note = const Value.absent(),
  });
  SettlementsCompanion.insert({
    this.id = const Value.absent(),
    required DateTime date,
    this.fromPersonId = const Value.absent(),
    this.toPersonId = const Value.absent(),
    required int amountPaise,
    this.mode = const Value.absent(),
    this.note = const Value.absent(),
  }) : date = Value(date),
       amountPaise = Value(amountPaise);
  static Insertable<Settlement> custom({
    Expression<int>? id,
    Expression<DateTime>? date,
    Expression<int>? fromPersonId,
    Expression<int>? toPersonId,
    Expression<int>? amountPaise,
    Expression<String>? mode,
    Expression<String>? note,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (fromPersonId != null) 'from_person_id': fromPersonId,
      if (toPersonId != null) 'to_person_id': toPersonId,
      if (amountPaise != null) 'amount_paise': amountPaise,
      if (mode != null) 'mode': mode,
      if (note != null) 'note': note,
    });
  }

  SettlementsCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? date,
    Value<int?>? fromPersonId,
    Value<int?>? toPersonId,
    Value<int>? amountPaise,
    Value<String>? mode,
    Value<String?>? note,
  }) {
    return SettlementsCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      fromPersonId: fromPersonId ?? this.fromPersonId,
      toPersonId: toPersonId ?? this.toPersonId,
      amountPaise: amountPaise ?? this.amountPaise,
      mode: mode ?? this.mode,
      note: note ?? this.note,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (fromPersonId.present) {
      map['from_person_id'] = Variable<int>(fromPersonId.value);
    }
    if (toPersonId.present) {
      map['to_person_id'] = Variable<int>(toPersonId.value);
    }
    if (amountPaise.present) {
      map['amount_paise'] = Variable<int>(amountPaise.value);
    }
    if (mode.present) {
      map['mode'] = Variable<String>(mode.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SettlementsCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('fromPersonId: $fromPersonId, ')
          ..write('toPersonId: $toPersonId, ')
          ..write('amountPaise: $amountPaise, ')
          ..write('mode: $mode, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }
}

class $AppSettingsTable extends AppSettings
    with TableInfo<$AppSettingsTable, AppSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _userNameMeta = const VerificationMeta(
    'userName',
  );
  @override
  late final GeneratedColumn<String> userName = GeneratedColumn<String>(
    'user_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('Student'),
  );
  static const VerificationMeta _currencyMeta = const VerificationMeta(
    'currency',
  );
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
    'currency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('INR'),
  );
  static const VerificationMeta _themeModeMeta = const VerificationMeta(
    'themeMode',
  );
  @override
  late final GeneratedColumn<String> themeMode = GeneratedColumn<String>(
    'theme_mode',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('system'),
  );
  static const VerificationMeta _carryForwardDefaultMeta =
      const VerificationMeta('carryForwardDefault');
  @override
  late final GeneratedColumn<bool> carryForwardDefault = GeneratedColumn<bool>(
    'carry_forward_default',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("carry_forward_default" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _pinEnabledMeta = const VerificationMeta(
    'pinEnabled',
  );
  @override
  late final GeneratedColumn<bool> pinEnabled = GeneratedColumn<bool>(
    'pin_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("pin_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _pinCodeMeta = const VerificationMeta(
    'pinCode',
  );
  @override
  late final GeneratedColumn<String> pinCode = GeneratedColumn<String>(
    'pin_code',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notificationsEnabledMeta =
      const VerificationMeta('notificationsEnabled');
  @override
  late final GeneratedColumn<bool> notificationsEnabled = GeneratedColumn<bool>(
    'notifications_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("notifications_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _reminderHourMeta = const VerificationMeta(
    'reminderHour',
  );
  @override
  late final GeneratedColumn<int> reminderHour = GeneratedColumn<int>(
    'reminder_hour',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(21),
  );
  static const VerificationMeta _reminderMinuteMeta = const VerificationMeta(
    'reminderMinute',
  );
  @override
  late final GeneratedColumn<int> reminderMinute = GeneratedColumn<int>(
    'reminder_minute',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userName,
    currency,
    themeMode,
    carryForwardDefault,
    pinEnabled,
    pinCode,
    notificationsEnabled,
    reminderHour,
    reminderMinute,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppSetting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_name')) {
      context.handle(
        _userNameMeta,
        userName.isAcceptableOrUnknown(data['user_name']!, _userNameMeta),
      );
    }
    if (data.containsKey('currency')) {
      context.handle(
        _currencyMeta,
        currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta),
      );
    }
    if (data.containsKey('theme_mode')) {
      context.handle(
        _themeModeMeta,
        themeMode.isAcceptableOrUnknown(data['theme_mode']!, _themeModeMeta),
      );
    }
    if (data.containsKey('carry_forward_default')) {
      context.handle(
        _carryForwardDefaultMeta,
        carryForwardDefault.isAcceptableOrUnknown(
          data['carry_forward_default']!,
          _carryForwardDefaultMeta,
        ),
      );
    }
    if (data.containsKey('pin_enabled')) {
      context.handle(
        _pinEnabledMeta,
        pinEnabled.isAcceptableOrUnknown(data['pin_enabled']!, _pinEnabledMeta),
      );
    }
    if (data.containsKey('pin_code')) {
      context.handle(
        _pinCodeMeta,
        pinCode.isAcceptableOrUnknown(data['pin_code']!, _pinCodeMeta),
      );
    }
    if (data.containsKey('notifications_enabled')) {
      context.handle(
        _notificationsEnabledMeta,
        notificationsEnabled.isAcceptableOrUnknown(
          data['notifications_enabled']!,
          _notificationsEnabledMeta,
        ),
      );
    }
    if (data.containsKey('reminder_hour')) {
      context.handle(
        _reminderHourMeta,
        reminderHour.isAcceptableOrUnknown(
          data['reminder_hour']!,
          _reminderHourMeta,
        ),
      );
    }
    if (data.containsKey('reminder_minute')) {
      context.handle(
        _reminderMinuteMeta,
        reminderMinute.isAcceptableOrUnknown(
          data['reminder_minute']!,
          _reminderMinuteMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AppSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppSetting(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      userName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_name'],
      )!,
      currency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency'],
      )!,
      themeMode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}theme_mode'],
      )!,
      carryForwardDefault: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}carry_forward_default'],
      )!,
      pinEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}pin_enabled'],
      )!,
      pinCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pin_code'],
      ),
      notificationsEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}notifications_enabled'],
      )!,
      reminderHour: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reminder_hour'],
      )!,
      reminderMinute: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reminder_minute'],
      )!,
    );
  }

  @override
  $AppSettingsTable createAlias(String alias) {
    return $AppSettingsTable(attachedDatabase, alias);
  }
}

class AppSetting extends DataClass implements Insertable<AppSetting> {
  final int id;
  final String userName;
  final String currency;
  final String themeMode;
  final bool carryForwardDefault;
  final bool pinEnabled;
  final String? pinCode;
  final bool notificationsEnabled;
  final int reminderHour;
  final int reminderMinute;
  const AppSetting({
    required this.id,
    required this.userName,
    required this.currency,
    required this.themeMode,
    required this.carryForwardDefault,
    required this.pinEnabled,
    this.pinCode,
    required this.notificationsEnabled,
    required this.reminderHour,
    required this.reminderMinute,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['user_name'] = Variable<String>(userName);
    map['currency'] = Variable<String>(currency);
    map['theme_mode'] = Variable<String>(themeMode);
    map['carry_forward_default'] = Variable<bool>(carryForwardDefault);
    map['pin_enabled'] = Variable<bool>(pinEnabled);
    if (!nullToAbsent || pinCode != null) {
      map['pin_code'] = Variable<String>(pinCode);
    }
    map['notifications_enabled'] = Variable<bool>(notificationsEnabled);
    map['reminder_hour'] = Variable<int>(reminderHour);
    map['reminder_minute'] = Variable<int>(reminderMinute);
    return map;
  }

  AppSettingsCompanion toCompanion(bool nullToAbsent) {
    return AppSettingsCompanion(
      id: Value(id),
      userName: Value(userName),
      currency: Value(currency),
      themeMode: Value(themeMode),
      carryForwardDefault: Value(carryForwardDefault),
      pinEnabled: Value(pinEnabled),
      pinCode: pinCode == null && nullToAbsent
          ? const Value.absent()
          : Value(pinCode),
      notificationsEnabled: Value(notificationsEnabled),
      reminderHour: Value(reminderHour),
      reminderMinute: Value(reminderMinute),
    );
  }

  factory AppSetting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppSetting(
      id: serializer.fromJson<int>(json['id']),
      userName: serializer.fromJson<String>(json['userName']),
      currency: serializer.fromJson<String>(json['currency']),
      themeMode: serializer.fromJson<String>(json['themeMode']),
      carryForwardDefault: serializer.fromJson<bool>(
        json['carryForwardDefault'],
      ),
      pinEnabled: serializer.fromJson<bool>(json['pinEnabled']),
      pinCode: serializer.fromJson<String?>(json['pinCode']),
      notificationsEnabled: serializer.fromJson<bool>(
        json['notificationsEnabled'],
      ),
      reminderHour: serializer.fromJson<int>(json['reminderHour']),
      reminderMinute: serializer.fromJson<int>(json['reminderMinute']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userName': serializer.toJson<String>(userName),
      'currency': serializer.toJson<String>(currency),
      'themeMode': serializer.toJson<String>(themeMode),
      'carryForwardDefault': serializer.toJson<bool>(carryForwardDefault),
      'pinEnabled': serializer.toJson<bool>(pinEnabled),
      'pinCode': serializer.toJson<String?>(pinCode),
      'notificationsEnabled': serializer.toJson<bool>(notificationsEnabled),
      'reminderHour': serializer.toJson<int>(reminderHour),
      'reminderMinute': serializer.toJson<int>(reminderMinute),
    };
  }

  AppSetting copyWith({
    int? id,
    String? userName,
    String? currency,
    String? themeMode,
    bool? carryForwardDefault,
    bool? pinEnabled,
    Value<String?> pinCode = const Value.absent(),
    bool? notificationsEnabled,
    int? reminderHour,
    int? reminderMinute,
  }) => AppSetting(
    id: id ?? this.id,
    userName: userName ?? this.userName,
    currency: currency ?? this.currency,
    themeMode: themeMode ?? this.themeMode,
    carryForwardDefault: carryForwardDefault ?? this.carryForwardDefault,
    pinEnabled: pinEnabled ?? this.pinEnabled,
    pinCode: pinCode.present ? pinCode.value : this.pinCode,
    notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
    reminderHour: reminderHour ?? this.reminderHour,
    reminderMinute: reminderMinute ?? this.reminderMinute,
  );
  AppSetting copyWithCompanion(AppSettingsCompanion data) {
    return AppSetting(
      id: data.id.present ? data.id.value : this.id,
      userName: data.userName.present ? data.userName.value : this.userName,
      currency: data.currency.present ? data.currency.value : this.currency,
      themeMode: data.themeMode.present ? data.themeMode.value : this.themeMode,
      carryForwardDefault: data.carryForwardDefault.present
          ? data.carryForwardDefault.value
          : this.carryForwardDefault,
      pinEnabled: data.pinEnabled.present
          ? data.pinEnabled.value
          : this.pinEnabled,
      pinCode: data.pinCode.present ? data.pinCode.value : this.pinCode,
      notificationsEnabled: data.notificationsEnabled.present
          ? data.notificationsEnabled.value
          : this.notificationsEnabled,
      reminderHour: data.reminderHour.present
          ? data.reminderHour.value
          : this.reminderHour,
      reminderMinute: data.reminderMinute.present
          ? data.reminderMinute.value
          : this.reminderMinute,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppSetting(')
          ..write('id: $id, ')
          ..write('userName: $userName, ')
          ..write('currency: $currency, ')
          ..write('themeMode: $themeMode, ')
          ..write('carryForwardDefault: $carryForwardDefault, ')
          ..write('pinEnabled: $pinEnabled, ')
          ..write('pinCode: $pinCode, ')
          ..write('notificationsEnabled: $notificationsEnabled, ')
          ..write('reminderHour: $reminderHour, ')
          ..write('reminderMinute: $reminderMinute')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userName,
    currency,
    themeMode,
    carryForwardDefault,
    pinEnabled,
    pinCode,
    notificationsEnabled,
    reminderHour,
    reminderMinute,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppSetting &&
          other.id == this.id &&
          other.userName == this.userName &&
          other.currency == this.currency &&
          other.themeMode == this.themeMode &&
          other.carryForwardDefault == this.carryForwardDefault &&
          other.pinEnabled == this.pinEnabled &&
          other.pinCode == this.pinCode &&
          other.notificationsEnabled == this.notificationsEnabled &&
          other.reminderHour == this.reminderHour &&
          other.reminderMinute == this.reminderMinute);
}

class AppSettingsCompanion extends UpdateCompanion<AppSetting> {
  final Value<int> id;
  final Value<String> userName;
  final Value<String> currency;
  final Value<String> themeMode;
  final Value<bool> carryForwardDefault;
  final Value<bool> pinEnabled;
  final Value<String?> pinCode;
  final Value<bool> notificationsEnabled;
  final Value<int> reminderHour;
  final Value<int> reminderMinute;
  const AppSettingsCompanion({
    this.id = const Value.absent(),
    this.userName = const Value.absent(),
    this.currency = const Value.absent(),
    this.themeMode = const Value.absent(),
    this.carryForwardDefault = const Value.absent(),
    this.pinEnabled = const Value.absent(),
    this.pinCode = const Value.absent(),
    this.notificationsEnabled = const Value.absent(),
    this.reminderHour = const Value.absent(),
    this.reminderMinute = const Value.absent(),
  });
  AppSettingsCompanion.insert({
    this.id = const Value.absent(),
    this.userName = const Value.absent(),
    this.currency = const Value.absent(),
    this.themeMode = const Value.absent(),
    this.carryForwardDefault = const Value.absent(),
    this.pinEnabled = const Value.absent(),
    this.pinCode = const Value.absent(),
    this.notificationsEnabled = const Value.absent(),
    this.reminderHour = const Value.absent(),
    this.reminderMinute = const Value.absent(),
  });
  static Insertable<AppSetting> custom({
    Expression<int>? id,
    Expression<String>? userName,
    Expression<String>? currency,
    Expression<String>? themeMode,
    Expression<bool>? carryForwardDefault,
    Expression<bool>? pinEnabled,
    Expression<String>? pinCode,
    Expression<bool>? notificationsEnabled,
    Expression<int>? reminderHour,
    Expression<int>? reminderMinute,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userName != null) 'user_name': userName,
      if (currency != null) 'currency': currency,
      if (themeMode != null) 'theme_mode': themeMode,
      if (carryForwardDefault != null)
        'carry_forward_default': carryForwardDefault,
      if (pinEnabled != null) 'pin_enabled': pinEnabled,
      if (pinCode != null) 'pin_code': pinCode,
      if (notificationsEnabled != null)
        'notifications_enabled': notificationsEnabled,
      if (reminderHour != null) 'reminder_hour': reminderHour,
      if (reminderMinute != null) 'reminder_minute': reminderMinute,
    });
  }

  AppSettingsCompanion copyWith({
    Value<int>? id,
    Value<String>? userName,
    Value<String>? currency,
    Value<String>? themeMode,
    Value<bool>? carryForwardDefault,
    Value<bool>? pinEnabled,
    Value<String?>? pinCode,
    Value<bool>? notificationsEnabled,
    Value<int>? reminderHour,
    Value<int>? reminderMinute,
  }) {
    return AppSettingsCompanion(
      id: id ?? this.id,
      userName: userName ?? this.userName,
      currency: currency ?? this.currency,
      themeMode: themeMode ?? this.themeMode,
      carryForwardDefault: carryForwardDefault ?? this.carryForwardDefault,
      pinEnabled: pinEnabled ?? this.pinEnabled,
      pinCode: pinCode ?? this.pinCode,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      reminderHour: reminderHour ?? this.reminderHour,
      reminderMinute: reminderMinute ?? this.reminderMinute,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userName.present) {
      map['user_name'] = Variable<String>(userName.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (themeMode.present) {
      map['theme_mode'] = Variable<String>(themeMode.value);
    }
    if (carryForwardDefault.present) {
      map['carry_forward_default'] = Variable<bool>(carryForwardDefault.value);
    }
    if (pinEnabled.present) {
      map['pin_enabled'] = Variable<bool>(pinEnabled.value);
    }
    if (pinCode.present) {
      map['pin_code'] = Variable<String>(pinCode.value);
    }
    if (notificationsEnabled.present) {
      map['notifications_enabled'] = Variable<bool>(notificationsEnabled.value);
    }
    if (reminderHour.present) {
      map['reminder_hour'] = Variable<int>(reminderHour.value);
    }
    if (reminderMinute.present) {
      map['reminder_minute'] = Variable<int>(reminderMinute.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsCompanion(')
          ..write('id: $id, ')
          ..write('userName: $userName, ')
          ..write('currency: $currency, ')
          ..write('themeMode: $themeMode, ')
          ..write('carryForwardDefault: $carryForwardDefault, ')
          ..write('pinEnabled: $pinEnabled, ')
          ..write('pinCode: $pinCode, ')
          ..write('notificationsEnabled: $notificationsEnabled, ')
          ..write('reminderHour: $reminderHour, ')
          ..write('reminderMinute: $reminderMinute')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $MonthlyBudgetsTable monthlyBudgets = $MonthlyBudgetsTable(this);
  late final $CategoriesTable categories = $CategoriesTable(this);
  late final $ExpensesTable expenses = $ExpensesTable(this);
  late final $PaymentModesTable paymentModes = $PaymentModesTable(this);
  late final $RecurringExpensesTable recurringExpenses =
      $RecurringExpensesTable(this);
  late final $SavingsGoalsTable savingsGoals = $SavingsGoalsTable(this);
  late final $PersonsTable persons = $PersonsTable(this);
  late final $SplitExpensesTable splitExpenses = $SplitExpensesTable(this);
  late final $SplitSharesTable splitShares = $SplitSharesTable(this);
  late final $SettlementsTable settlements = $SettlementsTable(this);
  late final $AppSettingsTable appSettings = $AppSettingsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    monthlyBudgets,
    categories,
    expenses,
    paymentModes,
    recurringExpenses,
    savingsGoals,
    persons,
    splitExpenses,
    splitShares,
    settlements,
    appSettings,
  ];
}

typedef $$MonthlyBudgetsTableCreateCompanionBuilder =
    MonthlyBudgetsCompanion Function({
      Value<int> id,
      required int year,
      required int month,
      required int amountPaise,
      Value<bool> carryForward,
      Value<int> carriedAmountPaise,
    });
typedef $$MonthlyBudgetsTableUpdateCompanionBuilder =
    MonthlyBudgetsCompanion Function({
      Value<int> id,
      Value<int> year,
      Value<int> month,
      Value<int> amountPaise,
      Value<bool> carryForward,
      Value<int> carriedAmountPaise,
    });

class $$MonthlyBudgetsTableFilterComposer
    extends Composer<_$AppDatabase, $MonthlyBudgetsTable> {
  $$MonthlyBudgetsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get month => $composableBuilder(
    column: $table.month,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amountPaise => $composableBuilder(
    column: $table.amountPaise,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get carryForward => $composableBuilder(
    column: $table.carryForward,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get carriedAmountPaise => $composableBuilder(
    column: $table.carriedAmountPaise,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MonthlyBudgetsTableOrderingComposer
    extends Composer<_$AppDatabase, $MonthlyBudgetsTable> {
  $$MonthlyBudgetsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get month => $composableBuilder(
    column: $table.month,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountPaise => $composableBuilder(
    column: $table.amountPaise,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get carryForward => $composableBuilder(
    column: $table.carryForward,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get carriedAmountPaise => $composableBuilder(
    column: $table.carriedAmountPaise,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MonthlyBudgetsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MonthlyBudgetsTable> {
  $$MonthlyBudgetsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get year =>
      $composableBuilder(column: $table.year, builder: (column) => column);

  GeneratedColumn<int> get month =>
      $composableBuilder(column: $table.month, builder: (column) => column);

  GeneratedColumn<int> get amountPaise => $composableBuilder(
    column: $table.amountPaise,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get carryForward => $composableBuilder(
    column: $table.carryForward,
    builder: (column) => column,
  );

  GeneratedColumn<int> get carriedAmountPaise => $composableBuilder(
    column: $table.carriedAmountPaise,
    builder: (column) => column,
  );
}

class $$MonthlyBudgetsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MonthlyBudgetsTable,
          MonthlyBudget,
          $$MonthlyBudgetsTableFilterComposer,
          $$MonthlyBudgetsTableOrderingComposer,
          $$MonthlyBudgetsTableAnnotationComposer,
          $$MonthlyBudgetsTableCreateCompanionBuilder,
          $$MonthlyBudgetsTableUpdateCompanionBuilder,
          (
            MonthlyBudget,
            BaseReferences<_$AppDatabase, $MonthlyBudgetsTable, MonthlyBudget>,
          ),
          MonthlyBudget,
          PrefetchHooks Function()
        > {
  $$MonthlyBudgetsTableTableManager(
    _$AppDatabase db,
    $MonthlyBudgetsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MonthlyBudgetsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MonthlyBudgetsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MonthlyBudgetsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> year = const Value.absent(),
                Value<int> month = const Value.absent(),
                Value<int> amountPaise = const Value.absent(),
                Value<bool> carryForward = const Value.absent(),
                Value<int> carriedAmountPaise = const Value.absent(),
              }) => MonthlyBudgetsCompanion(
                id: id,
                year: year,
                month: month,
                amountPaise: amountPaise,
                carryForward: carryForward,
                carriedAmountPaise: carriedAmountPaise,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int year,
                required int month,
                required int amountPaise,
                Value<bool> carryForward = const Value.absent(),
                Value<int> carriedAmountPaise = const Value.absent(),
              }) => MonthlyBudgetsCompanion.insert(
                id: id,
                year: year,
                month: month,
                amountPaise: amountPaise,
                carryForward: carryForward,
                carriedAmountPaise: carriedAmountPaise,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MonthlyBudgetsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MonthlyBudgetsTable,
      MonthlyBudget,
      $$MonthlyBudgetsTableFilterComposer,
      $$MonthlyBudgetsTableOrderingComposer,
      $$MonthlyBudgetsTableAnnotationComposer,
      $$MonthlyBudgetsTableCreateCompanionBuilder,
      $$MonthlyBudgetsTableUpdateCompanionBuilder,
      (
        MonthlyBudget,
        BaseReferences<_$AppDatabase, $MonthlyBudgetsTable, MonthlyBudget>,
      ),
      MonthlyBudget,
      PrefetchHooks Function()
    >;
typedef $$CategoriesTableCreateCompanionBuilder =
    CategoriesCompanion Function({
      Value<int> id,
      required String name,
      required String emoji,
      required String colorHex,
      required int monthlyLimitPaise,
      Value<bool> isActive,
      Value<int> sortOrder,
    });
typedef $$CategoriesTableUpdateCompanionBuilder =
    CategoriesCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> emoji,
      Value<String> colorHex,
      Value<int> monthlyLimitPaise,
      Value<bool> isActive,
      Value<int> sortOrder,
    });

class $$CategoriesTableFilterComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get emoji => $composableBuilder(
    column: $table.emoji,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get colorHex => $composableBuilder(
    column: $table.colorHex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get monthlyLimitPaise => $composableBuilder(
    column: $table.monthlyLimitPaise,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CategoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get emoji => $composableBuilder(
    column: $table.emoji,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get colorHex => $composableBuilder(
    column: $table.colorHex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get monthlyLimitPaise => $composableBuilder(
    column: $table.monthlyLimitPaise,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CategoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get emoji =>
      $composableBuilder(column: $table.emoji, builder: (column) => column);

  GeneratedColumn<String> get colorHex =>
      $composableBuilder(column: $table.colorHex, builder: (column) => column);

  GeneratedColumn<int> get monthlyLimitPaise => $composableBuilder(
    column: $table.monthlyLimitPaise,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);
}

class $$CategoriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CategoriesTable,
          Category,
          $$CategoriesTableFilterComposer,
          $$CategoriesTableOrderingComposer,
          $$CategoriesTableAnnotationComposer,
          $$CategoriesTableCreateCompanionBuilder,
          $$CategoriesTableUpdateCompanionBuilder,
          (Category, BaseReferences<_$AppDatabase, $CategoriesTable, Category>),
          Category,
          PrefetchHooks Function()
        > {
  $$CategoriesTableTableManager(_$AppDatabase db, $CategoriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CategoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> emoji = const Value.absent(),
                Value<String> colorHex = const Value.absent(),
                Value<int> monthlyLimitPaise = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
              }) => CategoriesCompanion(
                id: id,
                name: name,
                emoji: emoji,
                colorHex: colorHex,
                monthlyLimitPaise: monthlyLimitPaise,
                isActive: isActive,
                sortOrder: sortOrder,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required String emoji,
                required String colorHex,
                required int monthlyLimitPaise,
                Value<bool> isActive = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
              }) => CategoriesCompanion.insert(
                id: id,
                name: name,
                emoji: emoji,
                colorHex: colorHex,
                monthlyLimitPaise: monthlyLimitPaise,
                isActive: isActive,
                sortOrder: sortOrder,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CategoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CategoriesTable,
      Category,
      $$CategoriesTableFilterComposer,
      $$CategoriesTableOrderingComposer,
      $$CategoriesTableAnnotationComposer,
      $$CategoriesTableCreateCompanionBuilder,
      $$CategoriesTableUpdateCompanionBuilder,
      (Category, BaseReferences<_$AppDatabase, $CategoriesTable, Category>),
      Category,
      PrefetchHooks Function()
    >;
typedef $$ExpensesTableCreateCompanionBuilder =
    ExpensesCompanion Function({
      Value<int> id,
      required DateTime date,
      required int categoryId,
      required String whereSpent,
      required int amountPaise,
      required String paymentMode,
      Value<String?> note,
      Value<String?> receiptPath,
      Value<String?> splitExpenseId,
      Value<bool> isRecurringGenerated,
    });
typedef $$ExpensesTableUpdateCompanionBuilder =
    ExpensesCompanion Function({
      Value<int> id,
      Value<DateTime> date,
      Value<int> categoryId,
      Value<String> whereSpent,
      Value<int> amountPaise,
      Value<String> paymentMode,
      Value<String?> note,
      Value<String?> receiptPath,
      Value<String?> splitExpenseId,
      Value<bool> isRecurringGenerated,
    });

class $$ExpensesTableFilterComposer
    extends Composer<_$AppDatabase, $ExpensesTable> {
  $$ExpensesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get whereSpent => $composableBuilder(
    column: $table.whereSpent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amountPaise => $composableBuilder(
    column: $table.amountPaise,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get paymentMode => $composableBuilder(
    column: $table.paymentMode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get receiptPath => $composableBuilder(
    column: $table.receiptPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get splitExpenseId => $composableBuilder(
    column: $table.splitExpenseId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isRecurringGenerated => $composableBuilder(
    column: $table.isRecurringGenerated,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ExpensesTableOrderingComposer
    extends Composer<_$AppDatabase, $ExpensesTable> {
  $$ExpensesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get whereSpent => $composableBuilder(
    column: $table.whereSpent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountPaise => $composableBuilder(
    column: $table.amountPaise,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get paymentMode => $composableBuilder(
    column: $table.paymentMode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get receiptPath => $composableBuilder(
    column: $table.receiptPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get splitExpenseId => $composableBuilder(
    column: $table.splitExpenseId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isRecurringGenerated => $composableBuilder(
    column: $table.isRecurringGenerated,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ExpensesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExpensesTable> {
  $$ExpensesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get whereSpent => $composableBuilder(
    column: $table.whereSpent,
    builder: (column) => column,
  );

  GeneratedColumn<int> get amountPaise => $composableBuilder(
    column: $table.amountPaise,
    builder: (column) => column,
  );

  GeneratedColumn<String> get paymentMode => $composableBuilder(
    column: $table.paymentMode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<String> get receiptPath => $composableBuilder(
    column: $table.receiptPath,
    builder: (column) => column,
  );

  GeneratedColumn<String> get splitExpenseId => $composableBuilder(
    column: $table.splitExpenseId,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isRecurringGenerated => $composableBuilder(
    column: $table.isRecurringGenerated,
    builder: (column) => column,
  );
}

class $$ExpensesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ExpensesTable,
          Expense,
          $$ExpensesTableFilterComposer,
          $$ExpensesTableOrderingComposer,
          $$ExpensesTableAnnotationComposer,
          $$ExpensesTableCreateCompanionBuilder,
          $$ExpensesTableUpdateCompanionBuilder,
          (Expense, BaseReferences<_$AppDatabase, $ExpensesTable, Expense>),
          Expense,
          PrefetchHooks Function()
        > {
  $$ExpensesTableTableManager(_$AppDatabase db, $ExpensesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExpensesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExpensesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExpensesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<int> categoryId = const Value.absent(),
                Value<String> whereSpent = const Value.absent(),
                Value<int> amountPaise = const Value.absent(),
                Value<String> paymentMode = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<String?> receiptPath = const Value.absent(),
                Value<String?> splitExpenseId = const Value.absent(),
                Value<bool> isRecurringGenerated = const Value.absent(),
              }) => ExpensesCompanion(
                id: id,
                date: date,
                categoryId: categoryId,
                whereSpent: whereSpent,
                amountPaise: amountPaise,
                paymentMode: paymentMode,
                note: note,
                receiptPath: receiptPath,
                splitExpenseId: splitExpenseId,
                isRecurringGenerated: isRecurringGenerated,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime date,
                required int categoryId,
                required String whereSpent,
                required int amountPaise,
                required String paymentMode,
                Value<String?> note = const Value.absent(),
                Value<String?> receiptPath = const Value.absent(),
                Value<String?> splitExpenseId = const Value.absent(),
                Value<bool> isRecurringGenerated = const Value.absent(),
              }) => ExpensesCompanion.insert(
                id: id,
                date: date,
                categoryId: categoryId,
                whereSpent: whereSpent,
                amountPaise: amountPaise,
                paymentMode: paymentMode,
                note: note,
                receiptPath: receiptPath,
                splitExpenseId: splitExpenseId,
                isRecurringGenerated: isRecurringGenerated,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ExpensesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ExpensesTable,
      Expense,
      $$ExpensesTableFilterComposer,
      $$ExpensesTableOrderingComposer,
      $$ExpensesTableAnnotationComposer,
      $$ExpensesTableCreateCompanionBuilder,
      $$ExpensesTableUpdateCompanionBuilder,
      (Expense, BaseReferences<_$AppDatabase, $ExpensesTable, Expense>),
      Expense,
      PrefetchHooks Function()
    >;
typedef $$PaymentModesTableCreateCompanionBuilder =
    PaymentModesCompanion Function({
      Value<int> id,
      required String name,
      Value<bool> isActive,
    });
typedef $$PaymentModesTableUpdateCompanionBuilder =
    PaymentModesCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<bool> isActive,
    });

class $$PaymentModesTableFilterComposer
    extends Composer<_$AppDatabase, $PaymentModesTable> {
  $$PaymentModesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PaymentModesTableOrderingComposer
    extends Composer<_$AppDatabase, $PaymentModesTable> {
  $$PaymentModesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PaymentModesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PaymentModesTable> {
  $$PaymentModesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);
}

class $$PaymentModesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PaymentModesTable,
          PaymentMode,
          $$PaymentModesTableFilterComposer,
          $$PaymentModesTableOrderingComposer,
          $$PaymentModesTableAnnotationComposer,
          $$PaymentModesTableCreateCompanionBuilder,
          $$PaymentModesTableUpdateCompanionBuilder,
          (
            PaymentMode,
            BaseReferences<_$AppDatabase, $PaymentModesTable, PaymentMode>,
          ),
          PaymentMode,
          PrefetchHooks Function()
        > {
  $$PaymentModesTableTableManager(_$AppDatabase db, $PaymentModesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PaymentModesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PaymentModesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PaymentModesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
              }) =>
                  PaymentModesCompanion(id: id, name: name, isActive: isActive),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<bool> isActive = const Value.absent(),
              }) => PaymentModesCompanion.insert(
                id: id,
                name: name,
                isActive: isActive,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PaymentModesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PaymentModesTable,
      PaymentMode,
      $$PaymentModesTableFilterComposer,
      $$PaymentModesTableOrderingComposer,
      $$PaymentModesTableAnnotationComposer,
      $$PaymentModesTableCreateCompanionBuilder,
      $$PaymentModesTableUpdateCompanionBuilder,
      (
        PaymentMode,
        BaseReferences<_$AppDatabase, $PaymentModesTable, PaymentMode>,
      ),
      PaymentMode,
      PrefetchHooks Function()
    >;
typedef $$RecurringExpensesTableCreateCompanionBuilder =
    RecurringExpensesCompanion Function({
      Value<int> id,
      required String title,
      required int categoryId,
      required int amountPaise,
      required int dayOfMonth,
      Value<String> paymentMode,
      Value<bool> isActive,
    });
typedef $$RecurringExpensesTableUpdateCompanionBuilder =
    RecurringExpensesCompanion Function({
      Value<int> id,
      Value<String> title,
      Value<int> categoryId,
      Value<int> amountPaise,
      Value<int> dayOfMonth,
      Value<String> paymentMode,
      Value<bool> isActive,
    });

class $$RecurringExpensesTableFilterComposer
    extends Composer<_$AppDatabase, $RecurringExpensesTable> {
  $$RecurringExpensesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amountPaise => $composableBuilder(
    column: $table.amountPaise,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dayOfMonth => $composableBuilder(
    column: $table.dayOfMonth,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get paymentMode => $composableBuilder(
    column: $table.paymentMode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RecurringExpensesTableOrderingComposer
    extends Composer<_$AppDatabase, $RecurringExpensesTable> {
  $$RecurringExpensesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountPaise => $composableBuilder(
    column: $table.amountPaise,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dayOfMonth => $composableBuilder(
    column: $table.dayOfMonth,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get paymentMode => $composableBuilder(
    column: $table.paymentMode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RecurringExpensesTableAnnotationComposer
    extends Composer<_$AppDatabase, $RecurringExpensesTable> {
  $$RecurringExpensesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<int> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get amountPaise => $composableBuilder(
    column: $table.amountPaise,
    builder: (column) => column,
  );

  GeneratedColumn<int> get dayOfMonth => $composableBuilder(
    column: $table.dayOfMonth,
    builder: (column) => column,
  );

  GeneratedColumn<String> get paymentMode => $composableBuilder(
    column: $table.paymentMode,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);
}

class $$RecurringExpensesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RecurringExpensesTable,
          RecurringExpense,
          $$RecurringExpensesTableFilterComposer,
          $$RecurringExpensesTableOrderingComposer,
          $$RecurringExpensesTableAnnotationComposer,
          $$RecurringExpensesTableCreateCompanionBuilder,
          $$RecurringExpensesTableUpdateCompanionBuilder,
          (
            RecurringExpense,
            BaseReferences<
              _$AppDatabase,
              $RecurringExpensesTable,
              RecurringExpense
            >,
          ),
          RecurringExpense,
          PrefetchHooks Function()
        > {
  $$RecurringExpensesTableTableManager(
    _$AppDatabase db,
    $RecurringExpensesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RecurringExpensesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RecurringExpensesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RecurringExpensesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<int> categoryId = const Value.absent(),
                Value<int> amountPaise = const Value.absent(),
                Value<int> dayOfMonth = const Value.absent(),
                Value<String> paymentMode = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
              }) => RecurringExpensesCompanion(
                id: id,
                title: title,
                categoryId: categoryId,
                amountPaise: amountPaise,
                dayOfMonth: dayOfMonth,
                paymentMode: paymentMode,
                isActive: isActive,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String title,
                required int categoryId,
                required int amountPaise,
                required int dayOfMonth,
                Value<String> paymentMode = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
              }) => RecurringExpensesCompanion.insert(
                id: id,
                title: title,
                categoryId: categoryId,
                amountPaise: amountPaise,
                dayOfMonth: dayOfMonth,
                paymentMode: paymentMode,
                isActive: isActive,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RecurringExpensesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RecurringExpensesTable,
      RecurringExpense,
      $$RecurringExpensesTableFilterComposer,
      $$RecurringExpensesTableOrderingComposer,
      $$RecurringExpensesTableAnnotationComposer,
      $$RecurringExpensesTableCreateCompanionBuilder,
      $$RecurringExpensesTableUpdateCompanionBuilder,
      (
        RecurringExpense,
        BaseReferences<
          _$AppDatabase,
          $RecurringExpensesTable,
          RecurringExpense
        >,
      ),
      RecurringExpense,
      PrefetchHooks Function()
    >;
typedef $$SavingsGoalsTableCreateCompanionBuilder =
    SavingsGoalsCompanion Function({
      Value<int> id,
      required String name,
      required int targetPaise,
      Value<int> savedPaise,
      Value<DateTime?> deadline,
      Value<String> emoji,
    });
typedef $$SavingsGoalsTableUpdateCompanionBuilder =
    SavingsGoalsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<int> targetPaise,
      Value<int> savedPaise,
      Value<DateTime?> deadline,
      Value<String> emoji,
    });

class $$SavingsGoalsTableFilterComposer
    extends Composer<_$AppDatabase, $SavingsGoalsTable> {
  $$SavingsGoalsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get targetPaise => $composableBuilder(
    column: $table.targetPaise,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get savedPaise => $composableBuilder(
    column: $table.savedPaise,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deadline => $composableBuilder(
    column: $table.deadline,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get emoji => $composableBuilder(
    column: $table.emoji,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SavingsGoalsTableOrderingComposer
    extends Composer<_$AppDatabase, $SavingsGoalsTable> {
  $$SavingsGoalsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get targetPaise => $composableBuilder(
    column: $table.targetPaise,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get savedPaise => $composableBuilder(
    column: $table.savedPaise,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deadline => $composableBuilder(
    column: $table.deadline,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get emoji => $composableBuilder(
    column: $table.emoji,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SavingsGoalsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SavingsGoalsTable> {
  $$SavingsGoalsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get targetPaise => $composableBuilder(
    column: $table.targetPaise,
    builder: (column) => column,
  );

  GeneratedColumn<int> get savedPaise => $composableBuilder(
    column: $table.savedPaise,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get deadline =>
      $composableBuilder(column: $table.deadline, builder: (column) => column);

  GeneratedColumn<String> get emoji =>
      $composableBuilder(column: $table.emoji, builder: (column) => column);
}

class $$SavingsGoalsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SavingsGoalsTable,
          SavingsGoal,
          $$SavingsGoalsTableFilterComposer,
          $$SavingsGoalsTableOrderingComposer,
          $$SavingsGoalsTableAnnotationComposer,
          $$SavingsGoalsTableCreateCompanionBuilder,
          $$SavingsGoalsTableUpdateCompanionBuilder,
          (
            SavingsGoal,
            BaseReferences<_$AppDatabase, $SavingsGoalsTable, SavingsGoal>,
          ),
          SavingsGoal,
          PrefetchHooks Function()
        > {
  $$SavingsGoalsTableTableManager(_$AppDatabase db, $SavingsGoalsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SavingsGoalsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SavingsGoalsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SavingsGoalsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> targetPaise = const Value.absent(),
                Value<int> savedPaise = const Value.absent(),
                Value<DateTime?> deadline = const Value.absent(),
                Value<String> emoji = const Value.absent(),
              }) => SavingsGoalsCompanion(
                id: id,
                name: name,
                targetPaise: targetPaise,
                savedPaise: savedPaise,
                deadline: deadline,
                emoji: emoji,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required int targetPaise,
                Value<int> savedPaise = const Value.absent(),
                Value<DateTime?> deadline = const Value.absent(),
                Value<String> emoji = const Value.absent(),
              }) => SavingsGoalsCompanion.insert(
                id: id,
                name: name,
                targetPaise: targetPaise,
                savedPaise: savedPaise,
                deadline: deadline,
                emoji: emoji,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SavingsGoalsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SavingsGoalsTable,
      SavingsGoal,
      $$SavingsGoalsTableFilterComposer,
      $$SavingsGoalsTableOrderingComposer,
      $$SavingsGoalsTableAnnotationComposer,
      $$SavingsGoalsTableCreateCompanionBuilder,
      $$SavingsGoalsTableUpdateCompanionBuilder,
      (
        SavingsGoal,
        BaseReferences<_$AppDatabase, $SavingsGoalsTable, SavingsGoal>,
      ),
      SavingsGoal,
      PrefetchHooks Function()
    >;
typedef $$PersonsTableCreateCompanionBuilder =
    PersonsCompanion Function({
      Value<int> id,
      required String name,
      Value<String?> phone,
      Value<String> avatarColor,
      Value<bool> isArchived,
    });
typedef $$PersonsTableUpdateCompanionBuilder =
    PersonsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String?> phone,
      Value<String> avatarColor,
      Value<bool> isArchived,
    });

class $$PersonsTableFilterComposer
    extends Composer<_$AppDatabase, $PersonsTable> {
  $$PersonsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get avatarColor => $composableBuilder(
    column: $table.avatarColor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PersonsTableOrderingComposer
    extends Composer<_$AppDatabase, $PersonsTable> {
  $$PersonsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get avatarColor => $composableBuilder(
    column: $table.avatarColor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PersonsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PersonsTable> {
  $$PersonsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get avatarColor => $composableBuilder(
    column: $table.avatarColor,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => column,
  );
}

class $$PersonsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PersonsTable,
          Person,
          $$PersonsTableFilterComposer,
          $$PersonsTableOrderingComposer,
          $$PersonsTableAnnotationComposer,
          $$PersonsTableCreateCompanionBuilder,
          $$PersonsTableUpdateCompanionBuilder,
          (Person, BaseReferences<_$AppDatabase, $PersonsTable, Person>),
          Person,
          PrefetchHooks Function()
        > {
  $$PersonsTableTableManager(_$AppDatabase db, $PersonsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PersonsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PersonsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PersonsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String> avatarColor = const Value.absent(),
                Value<bool> isArchived = const Value.absent(),
              }) => PersonsCompanion(
                id: id,
                name: name,
                phone: phone,
                avatarColor: avatarColor,
                isArchived: isArchived,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<String?> phone = const Value.absent(),
                Value<String> avatarColor = const Value.absent(),
                Value<bool> isArchived = const Value.absent(),
              }) => PersonsCompanion.insert(
                id: id,
                name: name,
                phone: phone,
                avatarColor: avatarColor,
                isArchived: isArchived,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PersonsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PersonsTable,
      Person,
      $$PersonsTableFilterComposer,
      $$PersonsTableOrderingComposer,
      $$PersonsTableAnnotationComposer,
      $$PersonsTableCreateCompanionBuilder,
      $$PersonsTableUpdateCompanionBuilder,
      (Person, BaseReferences<_$AppDatabase, $PersonsTable, Person>),
      Person,
      PrefetchHooks Function()
    >;
typedef $$SplitExpensesTableCreateCompanionBuilder =
    SplitExpensesCompanion Function({
      required String id,
      required DateTime date,
      required String title,
      Value<String?> groupName,
      required int totalAmountPaise,
      Value<int?> paidByPersonId,
      required String splitType,
      Value<int?> categoryId,
      Value<String?> note,
      Value<int> rowid,
    });
typedef $$SplitExpensesTableUpdateCompanionBuilder =
    SplitExpensesCompanion Function({
      Value<String> id,
      Value<DateTime> date,
      Value<String> title,
      Value<String?> groupName,
      Value<int> totalAmountPaise,
      Value<int?> paidByPersonId,
      Value<String> splitType,
      Value<int?> categoryId,
      Value<String?> note,
      Value<int> rowid,
    });

class $$SplitExpensesTableFilterComposer
    extends Composer<_$AppDatabase, $SplitExpensesTable> {
  $$SplitExpensesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get groupName => $composableBuilder(
    column: $table.groupName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalAmountPaise => $composableBuilder(
    column: $table.totalAmountPaise,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get paidByPersonId => $composableBuilder(
    column: $table.paidByPersonId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get splitType => $composableBuilder(
    column: $table.splitType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SplitExpensesTableOrderingComposer
    extends Composer<_$AppDatabase, $SplitExpensesTable> {
  $$SplitExpensesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get groupName => $composableBuilder(
    column: $table.groupName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalAmountPaise => $composableBuilder(
    column: $table.totalAmountPaise,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get paidByPersonId => $composableBuilder(
    column: $table.paidByPersonId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get splitType => $composableBuilder(
    column: $table.splitType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SplitExpensesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SplitExpensesTable> {
  $$SplitExpensesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get groupName =>
      $composableBuilder(column: $table.groupName, builder: (column) => column);

  GeneratedColumn<int> get totalAmountPaise => $composableBuilder(
    column: $table.totalAmountPaise,
    builder: (column) => column,
  );

  GeneratedColumn<int> get paidByPersonId => $composableBuilder(
    column: $table.paidByPersonId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get splitType =>
      $composableBuilder(column: $table.splitType, builder: (column) => column);

  GeneratedColumn<int> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);
}

class $$SplitExpensesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SplitExpensesTable,
          SplitExpense,
          $$SplitExpensesTableFilterComposer,
          $$SplitExpensesTableOrderingComposer,
          $$SplitExpensesTableAnnotationComposer,
          $$SplitExpensesTableCreateCompanionBuilder,
          $$SplitExpensesTableUpdateCompanionBuilder,
          (
            SplitExpense,
            BaseReferences<_$AppDatabase, $SplitExpensesTable, SplitExpense>,
          ),
          SplitExpense,
          PrefetchHooks Function()
        > {
  $$SplitExpensesTableTableManager(_$AppDatabase db, $SplitExpensesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SplitExpensesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SplitExpensesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SplitExpensesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> groupName = const Value.absent(),
                Value<int> totalAmountPaise = const Value.absent(),
                Value<int?> paidByPersonId = const Value.absent(),
                Value<String> splitType = const Value.absent(),
                Value<int?> categoryId = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SplitExpensesCompanion(
                id: id,
                date: date,
                title: title,
                groupName: groupName,
                totalAmountPaise: totalAmountPaise,
                paidByPersonId: paidByPersonId,
                splitType: splitType,
                categoryId: categoryId,
                note: note,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required DateTime date,
                required String title,
                Value<String?> groupName = const Value.absent(),
                required int totalAmountPaise,
                Value<int?> paidByPersonId = const Value.absent(),
                required String splitType,
                Value<int?> categoryId = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SplitExpensesCompanion.insert(
                id: id,
                date: date,
                title: title,
                groupName: groupName,
                totalAmountPaise: totalAmountPaise,
                paidByPersonId: paidByPersonId,
                splitType: splitType,
                categoryId: categoryId,
                note: note,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SplitExpensesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SplitExpensesTable,
      SplitExpense,
      $$SplitExpensesTableFilterComposer,
      $$SplitExpensesTableOrderingComposer,
      $$SplitExpensesTableAnnotationComposer,
      $$SplitExpensesTableCreateCompanionBuilder,
      $$SplitExpensesTableUpdateCompanionBuilder,
      (
        SplitExpense,
        BaseReferences<_$AppDatabase, $SplitExpensesTable, SplitExpense>,
      ),
      SplitExpense,
      PrefetchHooks Function()
    >;
typedef $$SplitSharesTableCreateCompanionBuilder =
    SplitSharesCompanion Function({
      Value<int> id,
      required String splitExpenseId,
      Value<int?> personId,
      required int shareAmountPaise,
    });
typedef $$SplitSharesTableUpdateCompanionBuilder =
    SplitSharesCompanion Function({
      Value<int> id,
      Value<String> splitExpenseId,
      Value<int?> personId,
      Value<int> shareAmountPaise,
    });

class $$SplitSharesTableFilterComposer
    extends Composer<_$AppDatabase, $SplitSharesTable> {
  $$SplitSharesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get splitExpenseId => $composableBuilder(
    column: $table.splitExpenseId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get personId => $composableBuilder(
    column: $table.personId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get shareAmountPaise => $composableBuilder(
    column: $table.shareAmountPaise,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SplitSharesTableOrderingComposer
    extends Composer<_$AppDatabase, $SplitSharesTable> {
  $$SplitSharesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get splitExpenseId => $composableBuilder(
    column: $table.splitExpenseId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get personId => $composableBuilder(
    column: $table.personId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get shareAmountPaise => $composableBuilder(
    column: $table.shareAmountPaise,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SplitSharesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SplitSharesTable> {
  $$SplitSharesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get splitExpenseId => $composableBuilder(
    column: $table.splitExpenseId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get personId =>
      $composableBuilder(column: $table.personId, builder: (column) => column);

  GeneratedColumn<int> get shareAmountPaise => $composableBuilder(
    column: $table.shareAmountPaise,
    builder: (column) => column,
  );
}

class $$SplitSharesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SplitSharesTable,
          SplitShare,
          $$SplitSharesTableFilterComposer,
          $$SplitSharesTableOrderingComposer,
          $$SplitSharesTableAnnotationComposer,
          $$SplitSharesTableCreateCompanionBuilder,
          $$SplitSharesTableUpdateCompanionBuilder,
          (
            SplitShare,
            BaseReferences<_$AppDatabase, $SplitSharesTable, SplitShare>,
          ),
          SplitShare,
          PrefetchHooks Function()
        > {
  $$SplitSharesTableTableManager(_$AppDatabase db, $SplitSharesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SplitSharesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SplitSharesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SplitSharesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> splitExpenseId = const Value.absent(),
                Value<int?> personId = const Value.absent(),
                Value<int> shareAmountPaise = const Value.absent(),
              }) => SplitSharesCompanion(
                id: id,
                splitExpenseId: splitExpenseId,
                personId: personId,
                shareAmountPaise: shareAmountPaise,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String splitExpenseId,
                Value<int?> personId = const Value.absent(),
                required int shareAmountPaise,
              }) => SplitSharesCompanion.insert(
                id: id,
                splitExpenseId: splitExpenseId,
                personId: personId,
                shareAmountPaise: shareAmountPaise,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SplitSharesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SplitSharesTable,
      SplitShare,
      $$SplitSharesTableFilterComposer,
      $$SplitSharesTableOrderingComposer,
      $$SplitSharesTableAnnotationComposer,
      $$SplitSharesTableCreateCompanionBuilder,
      $$SplitSharesTableUpdateCompanionBuilder,
      (
        SplitShare,
        BaseReferences<_$AppDatabase, $SplitSharesTable, SplitShare>,
      ),
      SplitShare,
      PrefetchHooks Function()
    >;
typedef $$SettlementsTableCreateCompanionBuilder =
    SettlementsCompanion Function({
      Value<int> id,
      required DateTime date,
      Value<int?> fromPersonId,
      Value<int?> toPersonId,
      required int amountPaise,
      Value<String> mode,
      Value<String?> note,
    });
typedef $$SettlementsTableUpdateCompanionBuilder =
    SettlementsCompanion Function({
      Value<int> id,
      Value<DateTime> date,
      Value<int?> fromPersonId,
      Value<int?> toPersonId,
      Value<int> amountPaise,
      Value<String> mode,
      Value<String?> note,
    });

class $$SettlementsTableFilterComposer
    extends Composer<_$AppDatabase, $SettlementsTable> {
  $$SettlementsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get fromPersonId => $composableBuilder(
    column: $table.fromPersonId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get toPersonId => $composableBuilder(
    column: $table.toPersonId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amountPaise => $composableBuilder(
    column: $table.amountPaise,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mode => $composableBuilder(
    column: $table.mode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SettlementsTableOrderingComposer
    extends Composer<_$AppDatabase, $SettlementsTable> {
  $$SettlementsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get fromPersonId => $composableBuilder(
    column: $table.fromPersonId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get toPersonId => $composableBuilder(
    column: $table.toPersonId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountPaise => $composableBuilder(
    column: $table.amountPaise,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mode => $composableBuilder(
    column: $table.mode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SettlementsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SettlementsTable> {
  $$SettlementsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get fromPersonId => $composableBuilder(
    column: $table.fromPersonId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get toPersonId => $composableBuilder(
    column: $table.toPersonId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get amountPaise => $composableBuilder(
    column: $table.amountPaise,
    builder: (column) => column,
  );

  GeneratedColumn<String> get mode =>
      $composableBuilder(column: $table.mode, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);
}

class $$SettlementsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SettlementsTable,
          Settlement,
          $$SettlementsTableFilterComposer,
          $$SettlementsTableOrderingComposer,
          $$SettlementsTableAnnotationComposer,
          $$SettlementsTableCreateCompanionBuilder,
          $$SettlementsTableUpdateCompanionBuilder,
          (
            Settlement,
            BaseReferences<_$AppDatabase, $SettlementsTable, Settlement>,
          ),
          Settlement,
          PrefetchHooks Function()
        > {
  $$SettlementsTableTableManager(_$AppDatabase db, $SettlementsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SettlementsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SettlementsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SettlementsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<int?> fromPersonId = const Value.absent(),
                Value<int?> toPersonId = const Value.absent(),
                Value<int> amountPaise = const Value.absent(),
                Value<String> mode = const Value.absent(),
                Value<String?> note = const Value.absent(),
              }) => SettlementsCompanion(
                id: id,
                date: date,
                fromPersonId: fromPersonId,
                toPersonId: toPersonId,
                amountPaise: amountPaise,
                mode: mode,
                note: note,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime date,
                Value<int?> fromPersonId = const Value.absent(),
                Value<int?> toPersonId = const Value.absent(),
                required int amountPaise,
                Value<String> mode = const Value.absent(),
                Value<String?> note = const Value.absent(),
              }) => SettlementsCompanion.insert(
                id: id,
                date: date,
                fromPersonId: fromPersonId,
                toPersonId: toPersonId,
                amountPaise: amountPaise,
                mode: mode,
                note: note,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SettlementsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SettlementsTable,
      Settlement,
      $$SettlementsTableFilterComposer,
      $$SettlementsTableOrderingComposer,
      $$SettlementsTableAnnotationComposer,
      $$SettlementsTableCreateCompanionBuilder,
      $$SettlementsTableUpdateCompanionBuilder,
      (
        Settlement,
        BaseReferences<_$AppDatabase, $SettlementsTable, Settlement>,
      ),
      Settlement,
      PrefetchHooks Function()
    >;
typedef $$AppSettingsTableCreateCompanionBuilder =
    AppSettingsCompanion Function({
      Value<int> id,
      Value<String> userName,
      Value<String> currency,
      Value<String> themeMode,
      Value<bool> carryForwardDefault,
      Value<bool> pinEnabled,
      Value<String?> pinCode,
      Value<bool> notificationsEnabled,
      Value<int> reminderHour,
      Value<int> reminderMinute,
    });
typedef $$AppSettingsTableUpdateCompanionBuilder =
    AppSettingsCompanion Function({
      Value<int> id,
      Value<String> userName,
      Value<String> currency,
      Value<String> themeMode,
      Value<bool> carryForwardDefault,
      Value<bool> pinEnabled,
      Value<String?> pinCode,
      Value<bool> notificationsEnabled,
      Value<int> reminderHour,
      Value<int> reminderMinute,
    });

class $$AppSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userName => $composableBuilder(
    column: $table.userName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get themeMode => $composableBuilder(
    column: $table.themeMode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get carryForwardDefault => $composableBuilder(
    column: $table.carryForwardDefault,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get pinEnabled => $composableBuilder(
    column: $table.pinEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pinCode => $composableBuilder(
    column: $table.pinCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get notificationsEnabled => $composableBuilder(
    column: $table.notificationsEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get reminderHour => $composableBuilder(
    column: $table.reminderHour,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get reminderMinute => $composableBuilder(
    column: $table.reminderMinute,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userName => $composableBuilder(
    column: $table.userName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get themeMode => $composableBuilder(
    column: $table.themeMode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get carryForwardDefault => $composableBuilder(
    column: $table.carryForwardDefault,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get pinEnabled => $composableBuilder(
    column: $table.pinEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pinCode => $composableBuilder(
    column: $table.pinCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get notificationsEnabled => $composableBuilder(
    column: $table.notificationsEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get reminderHour => $composableBuilder(
    column: $table.reminderHour,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get reminderMinute => $composableBuilder(
    column: $table.reminderMinute,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userName =>
      $composableBuilder(column: $table.userName, builder: (column) => column);

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<String> get themeMode =>
      $composableBuilder(column: $table.themeMode, builder: (column) => column);

  GeneratedColumn<bool> get carryForwardDefault => $composableBuilder(
    column: $table.carryForwardDefault,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get pinEnabled => $composableBuilder(
    column: $table.pinEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<String> get pinCode =>
      $composableBuilder(column: $table.pinCode, builder: (column) => column);

  GeneratedColumn<bool> get notificationsEnabled => $composableBuilder(
    column: $table.notificationsEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<int> get reminderHour => $composableBuilder(
    column: $table.reminderHour,
    builder: (column) => column,
  );

  GeneratedColumn<int> get reminderMinute => $composableBuilder(
    column: $table.reminderMinute,
    builder: (column) => column,
  );
}

class $$AppSettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppSettingsTable,
          AppSetting,
          $$AppSettingsTableFilterComposer,
          $$AppSettingsTableOrderingComposer,
          $$AppSettingsTableAnnotationComposer,
          $$AppSettingsTableCreateCompanionBuilder,
          $$AppSettingsTableUpdateCompanionBuilder,
          (
            AppSetting,
            BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>,
          ),
          AppSetting,
          PrefetchHooks Function()
        > {
  $$AppSettingsTableTableManager(_$AppDatabase db, $AppSettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> userName = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<String> themeMode = const Value.absent(),
                Value<bool> carryForwardDefault = const Value.absent(),
                Value<bool> pinEnabled = const Value.absent(),
                Value<String?> pinCode = const Value.absent(),
                Value<bool> notificationsEnabled = const Value.absent(),
                Value<int> reminderHour = const Value.absent(),
                Value<int> reminderMinute = const Value.absent(),
              }) => AppSettingsCompanion(
                id: id,
                userName: userName,
                currency: currency,
                themeMode: themeMode,
                carryForwardDefault: carryForwardDefault,
                pinEnabled: pinEnabled,
                pinCode: pinCode,
                notificationsEnabled: notificationsEnabled,
                reminderHour: reminderHour,
                reminderMinute: reminderMinute,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> userName = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<String> themeMode = const Value.absent(),
                Value<bool> carryForwardDefault = const Value.absent(),
                Value<bool> pinEnabled = const Value.absent(),
                Value<String?> pinCode = const Value.absent(),
                Value<bool> notificationsEnabled = const Value.absent(),
                Value<int> reminderHour = const Value.absent(),
                Value<int> reminderMinute = const Value.absent(),
              }) => AppSettingsCompanion.insert(
                id: id,
                userName: userName,
                currency: currency,
                themeMode: themeMode,
                carryForwardDefault: carryForwardDefault,
                pinEnabled: pinEnabled,
                pinCode: pinCode,
                notificationsEnabled: notificationsEnabled,
                reminderHour: reminderHour,
                reminderMinute: reminderMinute,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppSettingsTable,
      AppSetting,
      $$AppSettingsTableFilterComposer,
      $$AppSettingsTableOrderingComposer,
      $$AppSettingsTableAnnotationComposer,
      $$AppSettingsTableCreateCompanionBuilder,
      $$AppSettingsTableUpdateCompanionBuilder,
      (
        AppSetting,
        BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>,
      ),
      AppSetting,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$MonthlyBudgetsTableTableManager get monthlyBudgets =>
      $$MonthlyBudgetsTableTableManager(_db, _db.monthlyBudgets);
  $$CategoriesTableTableManager get categories =>
      $$CategoriesTableTableManager(_db, _db.categories);
  $$ExpensesTableTableManager get expenses =>
      $$ExpensesTableTableManager(_db, _db.expenses);
  $$PaymentModesTableTableManager get paymentModes =>
      $$PaymentModesTableTableManager(_db, _db.paymentModes);
  $$RecurringExpensesTableTableManager get recurringExpenses =>
      $$RecurringExpensesTableTableManager(_db, _db.recurringExpenses);
  $$SavingsGoalsTableTableManager get savingsGoals =>
      $$SavingsGoalsTableTableManager(_db, _db.savingsGoals);
  $$PersonsTableTableManager get persons =>
      $$PersonsTableTableManager(_db, _db.persons);
  $$SplitExpensesTableTableManager get splitExpenses =>
      $$SplitExpensesTableTableManager(_db, _db.splitExpenses);
  $$SplitSharesTableTableManager get splitShares =>
      $$SplitSharesTableTableManager(_db, _db.splitShares);
  $$SettlementsTableTableManager get settlements =>
      $$SettlementsTableTableManager(_db, _db.settlements);
  $$AppSettingsTableTableManager get appSettings =>
      $$AppSettingsTableTableManager(_db, _db.appSettings);
}
