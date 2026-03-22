// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_database.dart';

// ignore_for_file: type=lint
class $ProductsTableTable extends ProductsTable
    with TableInfo<$ProductsTableTable, ProductsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameKrMeta = const VerificationMeta('nameKr');
  @override
  late final GeneratedColumn<String> nameKr = GeneratedColumn<String>(
    'name_kr',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<double> price = GeneratedColumn<double>(
    'price',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _imageUrlMeta = const VerificationMeta(
    'imageUrl',
  );
  @override
  late final GeneratedColumn<String> imageUrl = GeneratedColumn<String>(
    'image_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isAvailableMeta = const VerificationMeta(
    'isAvailable',
  );
  @override
  late final GeneratedColumn<bool> isAvailable = GeneratedColumn<bool>(
    'is_available',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_available" IN (0, 1))',
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
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    nameKr,
    price,
    category,
    imageUrl,
    isAvailable,
    sortOrder,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'products_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProductsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('name_kr')) {
      context.handle(
        _nameKrMeta,
        nameKr.isAcceptableOrUnknown(data['name_kr']!, _nameKrMeta),
      );
    } else if (isInserting) {
      context.missing(_nameKrMeta);
    }
    if (data.containsKey('price')) {
      context.handle(
        _priceMeta,
        price.isAcceptableOrUnknown(data['price']!, _priceMeta),
      );
    } else if (isInserting) {
      context.missing(_priceMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('image_url')) {
      context.handle(
        _imageUrlMeta,
        imageUrl.isAcceptableOrUnknown(data['image_url']!, _imageUrlMeta),
      );
    }
    if (data.containsKey('is_available')) {
      context.handle(
        _isAvailableMeta,
        isAvailable.isAcceptableOrUnknown(
          data['is_available']!,
          _isAvailableMeta,
        ),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProductsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProductsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      nameKr: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_kr'],
      )!,
      price: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}price'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      imageUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_url'],
      ),
      isAvailable: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_available'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ProductsTableTable createAlias(String alias) {
    return $ProductsTableTable(attachedDatabase, alias);
  }
}

class ProductsTableData extends DataClass
    implements Insertable<ProductsTableData> {
  final String id;
  final String name;
  final String nameKr;
  final double price;
  final String category;
  final String? imageUrl;
  final bool isAvailable;
  final int sortOrder;
  final String createdAt;
  final String updatedAt;
  const ProductsTableData({
    required this.id,
    required this.name,
    required this.nameKr,
    required this.price,
    required this.category,
    this.imageUrl,
    required this.isAvailable,
    required this.sortOrder,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['name_kr'] = Variable<String>(nameKr);
    map['price'] = Variable<double>(price);
    map['category'] = Variable<String>(category);
    if (!nullToAbsent || imageUrl != null) {
      map['image_url'] = Variable<String>(imageUrl);
    }
    map['is_available'] = Variable<bool>(isAvailable);
    map['sort_order'] = Variable<int>(sortOrder);
    map['created_at'] = Variable<String>(createdAt);
    map['updated_at'] = Variable<String>(updatedAt);
    return map;
  }

  ProductsTableCompanion toCompanion(bool nullToAbsent) {
    return ProductsTableCompanion(
      id: Value(id),
      name: Value(name),
      nameKr: Value(nameKr),
      price: Value(price),
      category: Value(category),
      imageUrl: imageUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(imageUrl),
      isAvailable: Value(isAvailable),
      sortOrder: Value(sortOrder),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory ProductsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProductsTableData(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      nameKr: serializer.fromJson<String>(json['nameKr']),
      price: serializer.fromJson<double>(json['price']),
      category: serializer.fromJson<String>(json['category']),
      imageUrl: serializer.fromJson<String?>(json['imageUrl']),
      isAvailable: serializer.fromJson<bool>(json['isAvailable']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
      updatedAt: serializer.fromJson<String>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'nameKr': serializer.toJson<String>(nameKr),
      'price': serializer.toJson<double>(price),
      'category': serializer.toJson<String>(category),
      'imageUrl': serializer.toJson<String?>(imageUrl),
      'isAvailable': serializer.toJson<bool>(isAvailable),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'createdAt': serializer.toJson<String>(createdAt),
      'updatedAt': serializer.toJson<String>(updatedAt),
    };
  }

  ProductsTableData copyWith({
    String? id,
    String? name,
    String? nameKr,
    double? price,
    String? category,
    Value<String?> imageUrl = const Value.absent(),
    bool? isAvailable,
    int? sortOrder,
    String? createdAt,
    String? updatedAt,
  }) => ProductsTableData(
    id: id ?? this.id,
    name: name ?? this.name,
    nameKr: nameKr ?? this.nameKr,
    price: price ?? this.price,
    category: category ?? this.category,
    imageUrl: imageUrl.present ? imageUrl.value : this.imageUrl,
    isAvailable: isAvailable ?? this.isAvailable,
    sortOrder: sortOrder ?? this.sortOrder,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  ProductsTableData copyWithCompanion(ProductsTableCompanion data) {
    return ProductsTableData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      nameKr: data.nameKr.present ? data.nameKr.value : this.nameKr,
      price: data.price.present ? data.price.value : this.price,
      category: data.category.present ? data.category.value : this.category,
      imageUrl: data.imageUrl.present ? data.imageUrl.value : this.imageUrl,
      isAvailable: data.isAvailable.present
          ? data.isAvailable.value
          : this.isAvailable,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProductsTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('nameKr: $nameKr, ')
          ..write('price: $price, ')
          ..write('category: $category, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('isAvailable: $isAvailable, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    nameKr,
    price,
    category,
    imageUrl,
    isAvailable,
    sortOrder,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProductsTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.nameKr == this.nameKr &&
          other.price == this.price &&
          other.category == this.category &&
          other.imageUrl == this.imageUrl &&
          other.isAvailable == this.isAvailable &&
          other.sortOrder == this.sortOrder &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ProductsTableCompanion extends UpdateCompanion<ProductsTableData> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> nameKr;
  final Value<double> price;
  final Value<String> category;
  final Value<String?> imageUrl;
  final Value<bool> isAvailable;
  final Value<int> sortOrder;
  final Value<String> createdAt;
  final Value<String> updatedAt;
  final Value<int> rowid;
  const ProductsTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.nameKr = const Value.absent(),
    this.price = const Value.absent(),
    this.category = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.isAvailable = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProductsTableCompanion.insert({
    required String id,
    required String name,
    required String nameKr,
    required double price,
    required String category,
    this.imageUrl = const Value.absent(),
    this.isAvailable = const Value.absent(),
    this.sortOrder = const Value.absent(),
    required String createdAt,
    required String updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       nameKr = Value(nameKr),
       price = Value(price),
       category = Value(category),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<ProductsTableData> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? nameKr,
    Expression<double>? price,
    Expression<String>? category,
    Expression<String>? imageUrl,
    Expression<bool>? isAvailable,
    Expression<int>? sortOrder,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (nameKr != null) 'name_kr': nameKr,
      if (price != null) 'price': price,
      if (category != null) 'category': category,
      if (imageUrl != null) 'image_url': imageUrl,
      if (isAvailable != null) 'is_available': isAvailable,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProductsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? nameKr,
    Value<double>? price,
    Value<String>? category,
    Value<String?>? imageUrl,
    Value<bool>? isAvailable,
    Value<int>? sortOrder,
    Value<String>? createdAt,
    Value<String>? updatedAt,
    Value<int>? rowid,
  }) {
    return ProductsTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      nameKr: nameKr ?? this.nameKr,
      price: price ?? this.price,
      category: category ?? this.category,
      imageUrl: imageUrl ?? this.imageUrl,
      isAvailable: isAvailable ?? this.isAvailable,
      sortOrder: sortOrder ?? this.sortOrder,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (nameKr.present) {
      map['name_kr'] = Variable<String>(nameKr.value);
    }
    if (price.present) {
      map['price'] = Variable<double>(price.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (imageUrl.present) {
      map['image_url'] = Variable<String>(imageUrl.value);
    }
    if (isAvailable.present) {
      map['is_available'] = Variable<bool>(isAvailable.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductsTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('nameKr: $nameKr, ')
          ..write('price: $price, ')
          ..write('category: $category, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('isAvailable: $isAvailable, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $OrdersTableTable extends OrdersTable
    with TableInfo<$OrdersTableTable, OrdersTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OrdersTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tableNumberMeta = const VerificationMeta(
    'tableNumber',
  );
  @override
  late final GeneratedColumn<int> tableNumber = GeneratedColumn<int>(
    'table_number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _waiterIdMeta = const VerificationMeta(
    'waiterId',
  );
  @override
  late final GeneratedColumn<String> waiterId = GeneratedColumn<String>(
    'waiter_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _waiterNameMeta = const VerificationMeta(
    'waiterName',
  );
  @override
  late final GeneratedColumn<String> waiterName = GeneratedColumn<String>(
    'waiter_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _paymentMethodMeta = const VerificationMeta(
    'paymentMethod',
  );
  @override
  late final GeneratedColumn<String> paymentMethod = GeneratedColumn<String>(
    'payment_method',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('cash'),
  );
  static const VerificationMeta _subtotalMeta = const VerificationMeta(
    'subtotal',
  );
  @override
  late final GeneratedColumn<double> subtotal = GeneratedColumn<double>(
    'subtotal',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _taxMeta = const VerificationMeta('tax');
  @override
  late final GeneratedColumn<double> tax = GeneratedColumn<double>(
    'tax',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalMeta = const VerificationMeta('total');
  @override
  late final GeneratedColumn<double> total = GeneratedColumn<double>(
    'total',
    aliasedName,
    false,
    type: DriftSqlType.double,
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
  static const VerificationMeta _isSyncedMeta = const VerificationMeta(
    'isSynced',
  );
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
    'is_synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<String> completedAt = GeneratedColumn<String>(
    'completed_at',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    tableNumber,
    waiterId,
    waiterName,
    status,
    paymentMethod,
    subtotal,
    tax,
    total,
    note,
    isSynced,
    createdAt,
    updatedAt,
    completedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'orders_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<OrdersTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('table_number')) {
      context.handle(
        _tableNumberMeta,
        tableNumber.isAcceptableOrUnknown(
          data['table_number']!,
          _tableNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_tableNumberMeta);
    }
    if (data.containsKey('waiter_id')) {
      context.handle(
        _waiterIdMeta,
        waiterId.isAcceptableOrUnknown(data['waiter_id']!, _waiterIdMeta),
      );
    } else if (isInserting) {
      context.missing(_waiterIdMeta);
    }
    if (data.containsKey('waiter_name')) {
      context.handle(
        _waiterNameMeta,
        waiterName.isAcceptableOrUnknown(data['waiter_name']!, _waiterNameMeta),
      );
    } else if (isInserting) {
      context.missing(_waiterNameMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('payment_method')) {
      context.handle(
        _paymentMethodMeta,
        paymentMethod.isAcceptableOrUnknown(
          data['payment_method']!,
          _paymentMethodMeta,
        ),
      );
    }
    if (data.containsKey('subtotal')) {
      context.handle(
        _subtotalMeta,
        subtotal.isAcceptableOrUnknown(data['subtotal']!, _subtotalMeta),
      );
    } else if (isInserting) {
      context.missing(_subtotalMeta);
    }
    if (data.containsKey('tax')) {
      context.handle(
        _taxMeta,
        tax.isAcceptableOrUnknown(data['tax']!, _taxMeta),
      );
    } else if (isInserting) {
      context.missing(_taxMeta);
    }
    if (data.containsKey('total')) {
      context.handle(
        _totalMeta,
        total.isAcceptableOrUnknown(data['total']!, _totalMeta),
      );
    } else if (isInserting) {
      context.missing(_totalMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('is_synced')) {
      context.handle(
        _isSyncedMeta,
        isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OrdersTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OrdersTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      tableNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}table_number'],
      )!,
      waiterId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}waiter_id'],
      )!,
      waiterName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}waiter_name'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      paymentMethod: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payment_method'],
      )!,
      subtotal: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}subtotal'],
      )!,
      tax: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}tax'],
      )!,
      total: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      isSynced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_synced'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_at'],
      )!,
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}completed_at'],
      ),
    );
  }

  @override
  $OrdersTableTable createAlias(String alias) {
    return $OrdersTableTable(attachedDatabase, alias);
  }
}

class OrdersTableData extends DataClass implements Insertable<OrdersTableData> {
  final String id;
  final int tableNumber;
  final String waiterId;
  final String waiterName;
  final String status;
  final String paymentMethod;
  final double subtotal;
  final double tax;
  final double total;
  final String? note;
  final bool isSynced;
  final String createdAt;
  final String updatedAt;
  final String? completedAt;
  const OrdersTableData({
    required this.id,
    required this.tableNumber,
    required this.waiterId,
    required this.waiterName,
    required this.status,
    required this.paymentMethod,
    required this.subtotal,
    required this.tax,
    required this.total,
    this.note,
    required this.isSynced,
    required this.createdAt,
    required this.updatedAt,
    this.completedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['table_number'] = Variable<int>(tableNumber);
    map['waiter_id'] = Variable<String>(waiterId);
    map['waiter_name'] = Variable<String>(waiterName);
    map['status'] = Variable<String>(status);
    map['payment_method'] = Variable<String>(paymentMethod);
    map['subtotal'] = Variable<double>(subtotal);
    map['tax'] = Variable<double>(tax);
    map['total'] = Variable<double>(total);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['is_synced'] = Variable<bool>(isSynced);
    map['created_at'] = Variable<String>(createdAt);
    map['updated_at'] = Variable<String>(updatedAt);
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<String>(completedAt);
    }
    return map;
  }

  OrdersTableCompanion toCompanion(bool nullToAbsent) {
    return OrdersTableCompanion(
      id: Value(id),
      tableNumber: Value(tableNumber),
      waiterId: Value(waiterId),
      waiterName: Value(waiterName),
      status: Value(status),
      paymentMethod: Value(paymentMethod),
      subtotal: Value(subtotal),
      tax: Value(tax),
      total: Value(total),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      isSynced: Value(isSynced),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
    );
  }

  factory OrdersTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OrdersTableData(
      id: serializer.fromJson<String>(json['id']),
      tableNumber: serializer.fromJson<int>(json['tableNumber']),
      waiterId: serializer.fromJson<String>(json['waiterId']),
      waiterName: serializer.fromJson<String>(json['waiterName']),
      status: serializer.fromJson<String>(json['status']),
      paymentMethod: serializer.fromJson<String>(json['paymentMethod']),
      subtotal: serializer.fromJson<double>(json['subtotal']),
      tax: serializer.fromJson<double>(json['tax']),
      total: serializer.fromJson<double>(json['total']),
      note: serializer.fromJson<String?>(json['note']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
      updatedAt: serializer.fromJson<String>(json['updatedAt']),
      completedAt: serializer.fromJson<String?>(json['completedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'tableNumber': serializer.toJson<int>(tableNumber),
      'waiterId': serializer.toJson<String>(waiterId),
      'waiterName': serializer.toJson<String>(waiterName),
      'status': serializer.toJson<String>(status),
      'paymentMethod': serializer.toJson<String>(paymentMethod),
      'subtotal': serializer.toJson<double>(subtotal),
      'tax': serializer.toJson<double>(tax),
      'total': serializer.toJson<double>(total),
      'note': serializer.toJson<String?>(note),
      'isSynced': serializer.toJson<bool>(isSynced),
      'createdAt': serializer.toJson<String>(createdAt),
      'updatedAt': serializer.toJson<String>(updatedAt),
      'completedAt': serializer.toJson<String?>(completedAt),
    };
  }

  OrdersTableData copyWith({
    String? id,
    int? tableNumber,
    String? waiterId,
    String? waiterName,
    String? status,
    String? paymentMethod,
    double? subtotal,
    double? tax,
    double? total,
    Value<String?> note = const Value.absent(),
    bool? isSynced,
    String? createdAt,
    String? updatedAt,
    Value<String?> completedAt = const Value.absent(),
  }) => OrdersTableData(
    id: id ?? this.id,
    tableNumber: tableNumber ?? this.tableNumber,
    waiterId: waiterId ?? this.waiterId,
    waiterName: waiterName ?? this.waiterName,
    status: status ?? this.status,
    paymentMethod: paymentMethod ?? this.paymentMethod,
    subtotal: subtotal ?? this.subtotal,
    tax: tax ?? this.tax,
    total: total ?? this.total,
    note: note.present ? note.value : this.note,
    isSynced: isSynced ?? this.isSynced,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    completedAt: completedAt.present ? completedAt.value : this.completedAt,
  );
  OrdersTableData copyWithCompanion(OrdersTableCompanion data) {
    return OrdersTableData(
      id: data.id.present ? data.id.value : this.id,
      tableNumber: data.tableNumber.present
          ? data.tableNumber.value
          : this.tableNumber,
      waiterId: data.waiterId.present ? data.waiterId.value : this.waiterId,
      waiterName: data.waiterName.present
          ? data.waiterName.value
          : this.waiterName,
      status: data.status.present ? data.status.value : this.status,
      paymentMethod: data.paymentMethod.present
          ? data.paymentMethod.value
          : this.paymentMethod,
      subtotal: data.subtotal.present ? data.subtotal.value : this.subtotal,
      tax: data.tax.present ? data.tax.value : this.tax,
      total: data.total.present ? data.total.value : this.total,
      note: data.note.present ? data.note.value : this.note,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OrdersTableData(')
          ..write('id: $id, ')
          ..write('tableNumber: $tableNumber, ')
          ..write('waiterId: $waiterId, ')
          ..write('waiterName: $waiterName, ')
          ..write('status: $status, ')
          ..write('paymentMethod: $paymentMethod, ')
          ..write('subtotal: $subtotal, ')
          ..write('tax: $tax, ')
          ..write('total: $total, ')
          ..write('note: $note, ')
          ..write('isSynced: $isSynced, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('completedAt: $completedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    tableNumber,
    waiterId,
    waiterName,
    status,
    paymentMethod,
    subtotal,
    tax,
    total,
    note,
    isSynced,
    createdAt,
    updatedAt,
    completedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OrdersTableData &&
          other.id == this.id &&
          other.tableNumber == this.tableNumber &&
          other.waiterId == this.waiterId &&
          other.waiterName == this.waiterName &&
          other.status == this.status &&
          other.paymentMethod == this.paymentMethod &&
          other.subtotal == this.subtotal &&
          other.tax == this.tax &&
          other.total == this.total &&
          other.note == this.note &&
          other.isSynced == this.isSynced &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.completedAt == this.completedAt);
}

class OrdersTableCompanion extends UpdateCompanion<OrdersTableData> {
  final Value<String> id;
  final Value<int> tableNumber;
  final Value<String> waiterId;
  final Value<String> waiterName;
  final Value<String> status;
  final Value<String> paymentMethod;
  final Value<double> subtotal;
  final Value<double> tax;
  final Value<double> total;
  final Value<String?> note;
  final Value<bool> isSynced;
  final Value<String> createdAt;
  final Value<String> updatedAt;
  final Value<String?> completedAt;
  final Value<int> rowid;
  const OrdersTableCompanion({
    this.id = const Value.absent(),
    this.tableNumber = const Value.absent(),
    this.waiterId = const Value.absent(),
    this.waiterName = const Value.absent(),
    this.status = const Value.absent(),
    this.paymentMethod = const Value.absent(),
    this.subtotal = const Value.absent(),
    this.tax = const Value.absent(),
    this.total = const Value.absent(),
    this.note = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  OrdersTableCompanion.insert({
    required String id,
    required int tableNumber,
    required String waiterId,
    required String waiterName,
    required String status,
    this.paymentMethod = const Value.absent(),
    required double subtotal,
    required double tax,
    required double total,
    this.note = const Value.absent(),
    this.isSynced = const Value.absent(),
    required String createdAt,
    required String updatedAt,
    this.completedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       tableNumber = Value(tableNumber),
       waiterId = Value(waiterId),
       waiterName = Value(waiterName),
       status = Value(status),
       subtotal = Value(subtotal),
       tax = Value(tax),
       total = Value(total),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<OrdersTableData> custom({
    Expression<String>? id,
    Expression<int>? tableNumber,
    Expression<String>? waiterId,
    Expression<String>? waiterName,
    Expression<String>? status,
    Expression<String>? paymentMethod,
    Expression<double>? subtotal,
    Expression<double>? tax,
    Expression<double>? total,
    Expression<String>? note,
    Expression<bool>? isSynced,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
    Expression<String>? completedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tableNumber != null) 'table_number': tableNumber,
      if (waiterId != null) 'waiter_id': waiterId,
      if (waiterName != null) 'waiter_name': waiterName,
      if (status != null) 'status': status,
      if (paymentMethod != null) 'payment_method': paymentMethod,
      if (subtotal != null) 'subtotal': subtotal,
      if (tax != null) 'tax': tax,
      if (total != null) 'total': total,
      if (note != null) 'note': note,
      if (isSynced != null) 'is_synced': isSynced,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (completedAt != null) 'completed_at': completedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  OrdersTableCompanion copyWith({
    Value<String>? id,
    Value<int>? tableNumber,
    Value<String>? waiterId,
    Value<String>? waiterName,
    Value<String>? status,
    Value<String>? paymentMethod,
    Value<double>? subtotal,
    Value<double>? tax,
    Value<double>? total,
    Value<String?>? note,
    Value<bool>? isSynced,
    Value<String>? createdAt,
    Value<String>? updatedAt,
    Value<String?>? completedAt,
    Value<int>? rowid,
  }) {
    return OrdersTableCompanion(
      id: id ?? this.id,
      tableNumber: tableNumber ?? this.tableNumber,
      waiterId: waiterId ?? this.waiterId,
      waiterName: waiterName ?? this.waiterName,
      status: status ?? this.status,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      subtotal: subtotal ?? this.subtotal,
      tax: tax ?? this.tax,
      total: total ?? this.total,
      note: note ?? this.note,
      isSynced: isSynced ?? this.isSynced,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      completedAt: completedAt ?? this.completedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (tableNumber.present) {
      map['table_number'] = Variable<int>(tableNumber.value);
    }
    if (waiterId.present) {
      map['waiter_id'] = Variable<String>(waiterId.value);
    }
    if (waiterName.present) {
      map['waiter_name'] = Variable<String>(waiterName.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (paymentMethod.present) {
      map['payment_method'] = Variable<String>(paymentMethod.value);
    }
    if (subtotal.present) {
      map['subtotal'] = Variable<double>(subtotal.value);
    }
    if (tax.present) {
      map['tax'] = Variable<double>(tax.value);
    }
    if (total.present) {
      map['total'] = Variable<double>(total.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<String>(completedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OrdersTableCompanion(')
          ..write('id: $id, ')
          ..write('tableNumber: $tableNumber, ')
          ..write('waiterId: $waiterId, ')
          ..write('waiterName: $waiterName, ')
          ..write('status: $status, ')
          ..write('paymentMethod: $paymentMethod, ')
          ..write('subtotal: $subtotal, ')
          ..write('tax: $tax, ')
          ..write('total: $total, ')
          ..write('note: $note, ')
          ..write('isSynced: $isSynced, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $OrderItemsTableTable extends OrderItemsTable
    with TableInfo<$OrderItemsTableTable, OrderItemsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OrderItemsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _orderIdMeta = const VerificationMeta(
    'orderId',
  );
  @override
  late final GeneratedColumn<String> orderId = GeneratedColumn<String>(
    'order_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _productIdMeta = const VerificationMeta(
    'productId',
  );
  @override
  late final GeneratedColumn<String> productId = GeneratedColumn<String>(
    'product_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _productNameMeta = const VerificationMeta(
    'productName',
  );
  @override
  late final GeneratedColumn<String> productName = GeneratedColumn<String>(
    'product_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _productNameKrMeta = const VerificationMeta(
    'productNameKr',
  );
  @override
  late final GeneratedColumn<String> productNameKr = GeneratedColumn<String>(
    'product_name_kr',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<double> price = GeneratedColumn<double>(
    'price',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.int,
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
  @override
  List<GeneratedColumn> get $columns => [
    id,
    orderId,
    productId,
    productName,
    productNameKr,
    price,
    quantity,
    note,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'order_items_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<OrderItemsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('order_id')) {
      context.handle(
        _orderIdMeta,
        orderId.isAcceptableOrUnknown(data['order_id']!, _orderIdMeta),
      );
    } else if (isInserting) {
      context.missing(_orderIdMeta);
    }
    if (data.containsKey('product_id')) {
      context.handle(
        _productIdMeta,
        productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta),
      );
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('product_name')) {
      context.handle(
        _productNameMeta,
        productName.isAcceptableOrUnknown(
          data['product_name']!,
          _productNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_productNameMeta);
    }
    if (data.containsKey('product_name_kr')) {
      context.handle(
        _productNameKrMeta,
        productNameKr.isAcceptableOrUnknown(
          data['product_name_kr']!,
          _productNameKrMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_productNameKrMeta);
    }
    if (data.containsKey('price')) {
      context.handle(
        _priceMeta,
        price.isAcceptableOrUnknown(data['price']!, _priceMeta),
      );
    } else if (isInserting) {
      context.missing(_priceMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    } else if (isInserting) {
      context.missing(_quantityMeta);
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
  OrderItemsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OrderItemsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      orderId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}order_id'],
      )!,
      productId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_id'],
      )!,
      productName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_name'],
      )!,
      productNameKr: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_name_kr'],
      )!,
      price: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}price'],
      )!,
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quantity'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
    );
  }

  @override
  $OrderItemsTableTable createAlias(String alias) {
    return $OrderItemsTableTable(attachedDatabase, alias);
  }
}

class OrderItemsTableData extends DataClass
    implements Insertable<OrderItemsTableData> {
  final String id;
  final String orderId;
  final String productId;
  final String productName;
  final String productNameKr;
  final double price;
  final int quantity;
  final String? note;
  const OrderItemsTableData({
    required this.id,
    required this.orderId,
    required this.productId,
    required this.productName,
    required this.productNameKr,
    required this.price,
    required this.quantity,
    this.note,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['order_id'] = Variable<String>(orderId);
    map['product_id'] = Variable<String>(productId);
    map['product_name'] = Variable<String>(productName);
    map['product_name_kr'] = Variable<String>(productNameKr);
    map['price'] = Variable<double>(price);
    map['quantity'] = Variable<int>(quantity);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    return map;
  }

  OrderItemsTableCompanion toCompanion(bool nullToAbsent) {
    return OrderItemsTableCompanion(
      id: Value(id),
      orderId: Value(orderId),
      productId: Value(productId),
      productName: Value(productName),
      productNameKr: Value(productNameKr),
      price: Value(price),
      quantity: Value(quantity),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
    );
  }

  factory OrderItemsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OrderItemsTableData(
      id: serializer.fromJson<String>(json['id']),
      orderId: serializer.fromJson<String>(json['orderId']),
      productId: serializer.fromJson<String>(json['productId']),
      productName: serializer.fromJson<String>(json['productName']),
      productNameKr: serializer.fromJson<String>(json['productNameKr']),
      price: serializer.fromJson<double>(json['price']),
      quantity: serializer.fromJson<int>(json['quantity']),
      note: serializer.fromJson<String?>(json['note']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'orderId': serializer.toJson<String>(orderId),
      'productId': serializer.toJson<String>(productId),
      'productName': serializer.toJson<String>(productName),
      'productNameKr': serializer.toJson<String>(productNameKr),
      'price': serializer.toJson<double>(price),
      'quantity': serializer.toJson<int>(quantity),
      'note': serializer.toJson<String?>(note),
    };
  }

  OrderItemsTableData copyWith({
    String? id,
    String? orderId,
    String? productId,
    String? productName,
    String? productNameKr,
    double? price,
    int? quantity,
    Value<String?> note = const Value.absent(),
  }) => OrderItemsTableData(
    id: id ?? this.id,
    orderId: orderId ?? this.orderId,
    productId: productId ?? this.productId,
    productName: productName ?? this.productName,
    productNameKr: productNameKr ?? this.productNameKr,
    price: price ?? this.price,
    quantity: quantity ?? this.quantity,
    note: note.present ? note.value : this.note,
  );
  OrderItemsTableData copyWithCompanion(OrderItemsTableCompanion data) {
    return OrderItemsTableData(
      id: data.id.present ? data.id.value : this.id,
      orderId: data.orderId.present ? data.orderId.value : this.orderId,
      productId: data.productId.present ? data.productId.value : this.productId,
      productName: data.productName.present
          ? data.productName.value
          : this.productName,
      productNameKr: data.productNameKr.present
          ? data.productNameKr.value
          : this.productNameKr,
      price: data.price.present ? data.price.value : this.price,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      note: data.note.present ? data.note.value : this.note,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OrderItemsTableData(')
          ..write('id: $id, ')
          ..write('orderId: $orderId, ')
          ..write('productId: $productId, ')
          ..write('productName: $productName, ')
          ..write('productNameKr: $productNameKr, ')
          ..write('price: $price, ')
          ..write('quantity: $quantity, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    orderId,
    productId,
    productName,
    productNameKr,
    price,
    quantity,
    note,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OrderItemsTableData &&
          other.id == this.id &&
          other.orderId == this.orderId &&
          other.productId == this.productId &&
          other.productName == this.productName &&
          other.productNameKr == this.productNameKr &&
          other.price == this.price &&
          other.quantity == this.quantity &&
          other.note == this.note);
}

class OrderItemsTableCompanion extends UpdateCompanion<OrderItemsTableData> {
  final Value<String> id;
  final Value<String> orderId;
  final Value<String> productId;
  final Value<String> productName;
  final Value<String> productNameKr;
  final Value<double> price;
  final Value<int> quantity;
  final Value<String?> note;
  final Value<int> rowid;
  const OrderItemsTableCompanion({
    this.id = const Value.absent(),
    this.orderId = const Value.absent(),
    this.productId = const Value.absent(),
    this.productName = const Value.absent(),
    this.productNameKr = const Value.absent(),
    this.price = const Value.absent(),
    this.quantity = const Value.absent(),
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  OrderItemsTableCompanion.insert({
    required String id,
    required String orderId,
    required String productId,
    required String productName,
    required String productNameKr,
    required double price,
    required int quantity,
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       orderId = Value(orderId),
       productId = Value(productId),
       productName = Value(productName),
       productNameKr = Value(productNameKr),
       price = Value(price),
       quantity = Value(quantity);
  static Insertable<OrderItemsTableData> custom({
    Expression<String>? id,
    Expression<String>? orderId,
    Expression<String>? productId,
    Expression<String>? productName,
    Expression<String>? productNameKr,
    Expression<double>? price,
    Expression<int>? quantity,
    Expression<String>? note,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (orderId != null) 'order_id': orderId,
      if (productId != null) 'product_id': productId,
      if (productName != null) 'product_name': productName,
      if (productNameKr != null) 'product_name_kr': productNameKr,
      if (price != null) 'price': price,
      if (quantity != null) 'quantity': quantity,
      if (note != null) 'note': note,
      if (rowid != null) 'rowid': rowid,
    });
  }

  OrderItemsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? orderId,
    Value<String>? productId,
    Value<String>? productName,
    Value<String>? productNameKr,
    Value<double>? price,
    Value<int>? quantity,
    Value<String?>? note,
    Value<int>? rowid,
  }) {
    return OrderItemsTableCompanion(
      id: id ?? this.id,
      orderId: orderId ?? this.orderId,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      productNameKr: productNameKr ?? this.productNameKr,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
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
    if (orderId.present) {
      map['order_id'] = Variable<String>(orderId.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<String>(productId.value);
    }
    if (productName.present) {
      map['product_name'] = Variable<String>(productName.value);
    }
    if (productNameKr.present) {
      map['product_name_kr'] = Variable<String>(productNameKr.value);
    }
    if (price.present) {
      map['price'] = Variable<double>(price.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
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
    return (StringBuffer('OrderItemsTableCompanion(')
          ..write('id: $id, ')
          ..write('orderId: $orderId, ')
          ..write('productId: $productId, ')
          ..write('productName: $productName, ')
          ..write('productNameKr: $productNameKr, ')
          ..write('price: $price, ')
          ..write('quantity: $quantity, ')
          ..write('note: $note, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ShiftsTableTable extends ShiftsTable
    with TableInfo<$ShiftsTableTable, ShiftsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ShiftsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _closedAtMeta = const VerificationMeta(
    'closedAt',
  );
  @override
  late final GeneratedColumn<String> closedAt = GeneratedColumn<String>(
    'closed_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalRevenueMeta = const VerificationMeta(
    'totalRevenue',
  );
  @override
  late final GeneratedColumn<double> totalRevenue = GeneratedColumn<double>(
    'total_revenue',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalOrdersMeta = const VerificationMeta(
    'totalOrders',
  );
  @override
  late final GeneratedColumn<int> totalOrders = GeneratedColumn<int>(
    'total_orders',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _topProductsJsonMeta = const VerificationMeta(
    'topProductsJson',
  );
  @override
  late final GeneratedColumn<String> topProductsJson = GeneratedColumn<String>(
    'top_products_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    date,
    closedAt,
    totalRevenue,
    totalOrders,
    topProductsJson,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'shifts_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<ShiftsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('closed_at')) {
      context.handle(
        _closedAtMeta,
        closedAt.isAcceptableOrUnknown(data['closed_at']!, _closedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_closedAtMeta);
    }
    if (data.containsKey('total_revenue')) {
      context.handle(
        _totalRevenueMeta,
        totalRevenue.isAcceptableOrUnknown(
          data['total_revenue']!,
          _totalRevenueMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_totalRevenueMeta);
    }
    if (data.containsKey('total_orders')) {
      context.handle(
        _totalOrdersMeta,
        totalOrders.isAcceptableOrUnknown(
          data['total_orders']!,
          _totalOrdersMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_totalOrdersMeta);
    }
    if (data.containsKey('top_products_json')) {
      context.handle(
        _topProductsJsonMeta,
        topProductsJson.isAcceptableOrUnknown(
          data['top_products_json']!,
          _topProductsJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_topProductsJsonMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {date};
  @override
  ShiftsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ShiftsTableData(
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date'],
      )!,
      closedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}closed_at'],
      )!,
      totalRevenue: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total_revenue'],
      )!,
      totalOrders: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_orders'],
      )!,
      topProductsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}top_products_json'],
      )!,
    );
  }

  @override
  $ShiftsTableTable createAlias(String alias) {
    return $ShiftsTableTable(attachedDatabase, alias);
  }
}

class ShiftsTableData extends DataClass implements Insertable<ShiftsTableData> {
  final String date;
  final String closedAt;
  final double totalRevenue;
  final int totalOrders;
  final String topProductsJson;
  const ShiftsTableData({
    required this.date,
    required this.closedAt,
    required this.totalRevenue,
    required this.totalOrders,
    required this.topProductsJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['date'] = Variable<String>(date);
    map['closed_at'] = Variable<String>(closedAt);
    map['total_revenue'] = Variable<double>(totalRevenue);
    map['total_orders'] = Variable<int>(totalOrders);
    map['top_products_json'] = Variable<String>(topProductsJson);
    return map;
  }

  ShiftsTableCompanion toCompanion(bool nullToAbsent) {
    return ShiftsTableCompanion(
      date: Value(date),
      closedAt: Value(closedAt),
      totalRevenue: Value(totalRevenue),
      totalOrders: Value(totalOrders),
      topProductsJson: Value(topProductsJson),
    );
  }

  factory ShiftsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ShiftsTableData(
      date: serializer.fromJson<String>(json['date']),
      closedAt: serializer.fromJson<String>(json['closedAt']),
      totalRevenue: serializer.fromJson<double>(json['totalRevenue']),
      totalOrders: serializer.fromJson<int>(json['totalOrders']),
      topProductsJson: serializer.fromJson<String>(json['topProductsJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'date': serializer.toJson<String>(date),
      'closedAt': serializer.toJson<String>(closedAt),
      'totalRevenue': serializer.toJson<double>(totalRevenue),
      'totalOrders': serializer.toJson<int>(totalOrders),
      'topProductsJson': serializer.toJson<String>(topProductsJson),
    };
  }

  ShiftsTableData copyWith({
    String? date,
    String? closedAt,
    double? totalRevenue,
    int? totalOrders,
    String? topProductsJson,
  }) => ShiftsTableData(
    date: date ?? this.date,
    closedAt: closedAt ?? this.closedAt,
    totalRevenue: totalRevenue ?? this.totalRevenue,
    totalOrders: totalOrders ?? this.totalOrders,
    topProductsJson: topProductsJson ?? this.topProductsJson,
  );
  ShiftsTableData copyWithCompanion(ShiftsTableCompanion data) {
    return ShiftsTableData(
      date: data.date.present ? data.date.value : this.date,
      closedAt: data.closedAt.present ? data.closedAt.value : this.closedAt,
      totalRevenue: data.totalRevenue.present
          ? data.totalRevenue.value
          : this.totalRevenue,
      totalOrders: data.totalOrders.present
          ? data.totalOrders.value
          : this.totalOrders,
      topProductsJson: data.topProductsJson.present
          ? data.topProductsJson.value
          : this.topProductsJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ShiftsTableData(')
          ..write('date: $date, ')
          ..write('closedAt: $closedAt, ')
          ..write('totalRevenue: $totalRevenue, ')
          ..write('totalOrders: $totalOrders, ')
          ..write('topProductsJson: $topProductsJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(date, closedAt, totalRevenue, totalOrders, topProductsJson);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ShiftsTableData &&
          other.date == this.date &&
          other.closedAt == this.closedAt &&
          other.totalRevenue == this.totalRevenue &&
          other.totalOrders == this.totalOrders &&
          other.topProductsJson == this.topProductsJson);
}

class ShiftsTableCompanion extends UpdateCompanion<ShiftsTableData> {
  final Value<String> date;
  final Value<String> closedAt;
  final Value<double> totalRevenue;
  final Value<int> totalOrders;
  final Value<String> topProductsJson;
  final Value<int> rowid;
  const ShiftsTableCompanion({
    this.date = const Value.absent(),
    this.closedAt = const Value.absent(),
    this.totalRevenue = const Value.absent(),
    this.totalOrders = const Value.absent(),
    this.topProductsJson = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ShiftsTableCompanion.insert({
    required String date,
    required String closedAt,
    required double totalRevenue,
    required int totalOrders,
    required String topProductsJson,
    this.rowid = const Value.absent(),
  }) : date = Value(date),
       closedAt = Value(closedAt),
       totalRevenue = Value(totalRevenue),
       totalOrders = Value(totalOrders),
       topProductsJson = Value(topProductsJson);
  static Insertable<ShiftsTableData> custom({
    Expression<String>? date,
    Expression<String>? closedAt,
    Expression<double>? totalRevenue,
    Expression<int>? totalOrders,
    Expression<String>? topProductsJson,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (date != null) 'date': date,
      if (closedAt != null) 'closed_at': closedAt,
      if (totalRevenue != null) 'total_revenue': totalRevenue,
      if (totalOrders != null) 'total_orders': totalOrders,
      if (topProductsJson != null) 'top_products_json': topProductsJson,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ShiftsTableCompanion copyWith({
    Value<String>? date,
    Value<String>? closedAt,
    Value<double>? totalRevenue,
    Value<int>? totalOrders,
    Value<String>? topProductsJson,
    Value<int>? rowid,
  }) {
    return ShiftsTableCompanion(
      date: date ?? this.date,
      closedAt: closedAt ?? this.closedAt,
      totalRevenue: totalRevenue ?? this.totalRevenue,
      totalOrders: totalOrders ?? this.totalOrders,
      topProductsJson: topProductsJson ?? this.topProductsJson,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (closedAt.present) {
      map['closed_at'] = Variable<String>(closedAt.value);
    }
    if (totalRevenue.present) {
      map['total_revenue'] = Variable<double>(totalRevenue.value);
    }
    if (totalOrders.present) {
      map['total_orders'] = Variable<int>(totalOrders.value);
    }
    if (topProductsJson.present) {
      map['top_products_json'] = Variable<String>(topProductsJson.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ShiftsTableCompanion(')
          ..write('date: $date, ')
          ..write('closedAt: $closedAt, ')
          ..write('totalRevenue: $totalRevenue, ')
          ..write('totalOrders: $totalOrders, ')
          ..write('topProductsJson: $topProductsJson, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$LocalDatabase extends GeneratedDatabase {
  _$LocalDatabase(QueryExecutor e) : super(e);
  $LocalDatabaseManager get managers => $LocalDatabaseManager(this);
  late final $ProductsTableTable productsTable = $ProductsTableTable(this);
  late final $OrdersTableTable ordersTable = $OrdersTableTable(this);
  late final $OrderItemsTableTable orderItemsTable = $OrderItemsTableTable(
    this,
  );
  late final $ShiftsTableTable shiftsTable = $ShiftsTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    productsTable,
    ordersTable,
    orderItemsTable,
    shiftsTable,
  ];
}

typedef $$ProductsTableTableCreateCompanionBuilder =
    ProductsTableCompanion Function({
      required String id,
      required String name,
      required String nameKr,
      required double price,
      required String category,
      Value<String?> imageUrl,
      Value<bool> isAvailable,
      Value<int> sortOrder,
      required String createdAt,
      required String updatedAt,
      Value<int> rowid,
    });
typedef $$ProductsTableTableUpdateCompanionBuilder =
    ProductsTableCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> nameKr,
      Value<double> price,
      Value<String> category,
      Value<String?> imageUrl,
      Value<bool> isAvailable,
      Value<int> sortOrder,
      Value<String> createdAt,
      Value<String> updatedAt,
      Value<int> rowid,
    });

class $$ProductsTableTableFilterComposer
    extends Composer<_$LocalDatabase, $ProductsTableTable> {
  $$ProductsTableTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameKr => $composableBuilder(
    column: $table.nameKr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get price => $composableBuilder(
    column: $table.price,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isAvailable => $composableBuilder(
    column: $table.isAvailable,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ProductsTableTableOrderingComposer
    extends Composer<_$LocalDatabase, $ProductsTableTable> {
  $$ProductsTableTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameKr => $composableBuilder(
    column: $table.nameKr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get price => $composableBuilder(
    column: $table.price,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isAvailable => $composableBuilder(
    column: $table.isAvailable,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProductsTableTableAnnotationComposer
    extends Composer<_$LocalDatabase, $ProductsTableTable> {
  $$ProductsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get nameKr =>
      $composableBuilder(column: $table.nameKr, builder: (column) => column);

  GeneratedColumn<double> get price =>
      $composableBuilder(column: $table.price, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get imageUrl =>
      $composableBuilder(column: $table.imageUrl, builder: (column) => column);

  GeneratedColumn<bool> get isAvailable => $composableBuilder(
    column: $table.isAvailable,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$ProductsTableTableTableManager
    extends
        RootTableManager<
          _$LocalDatabase,
          $ProductsTableTable,
          ProductsTableData,
          $$ProductsTableTableFilterComposer,
          $$ProductsTableTableOrderingComposer,
          $$ProductsTableTableAnnotationComposer,
          $$ProductsTableTableCreateCompanionBuilder,
          $$ProductsTableTableUpdateCompanionBuilder,
          (
            ProductsTableData,
            BaseReferences<
              _$LocalDatabase,
              $ProductsTableTable,
              ProductsTableData
            >,
          ),
          ProductsTableData,
          PrefetchHooks Function()
        > {
  $$ProductsTableTableTableManager(
    _$LocalDatabase db,
    $ProductsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProductsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProductsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProductsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> nameKr = const Value.absent(),
                Value<double> price = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String?> imageUrl = const Value.absent(),
                Value<bool> isAvailable = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<String> createdAt = const Value.absent(),
                Value<String> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProductsTableCompanion(
                id: id,
                name: name,
                nameKr: nameKr,
                price: price,
                category: category,
                imageUrl: imageUrl,
                isAvailable: isAvailable,
                sortOrder: sortOrder,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String nameKr,
                required double price,
                required String category,
                Value<String?> imageUrl = const Value.absent(),
                Value<bool> isAvailable = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                required String createdAt,
                required String updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => ProductsTableCompanion.insert(
                id: id,
                name: name,
                nameKr: nameKr,
                price: price,
                category: category,
                imageUrl: imageUrl,
                isAvailable: isAvailable,
                sortOrder: sortOrder,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ProductsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$LocalDatabase,
      $ProductsTableTable,
      ProductsTableData,
      $$ProductsTableTableFilterComposer,
      $$ProductsTableTableOrderingComposer,
      $$ProductsTableTableAnnotationComposer,
      $$ProductsTableTableCreateCompanionBuilder,
      $$ProductsTableTableUpdateCompanionBuilder,
      (
        ProductsTableData,
        BaseReferences<_$LocalDatabase, $ProductsTableTable, ProductsTableData>,
      ),
      ProductsTableData,
      PrefetchHooks Function()
    >;
typedef $$OrdersTableTableCreateCompanionBuilder =
    OrdersTableCompanion Function({
      required String id,
      required int tableNumber,
      required String waiterId,
      required String waiterName,
      required String status,
      Value<String> paymentMethod,
      required double subtotal,
      required double tax,
      required double total,
      Value<String?> note,
      Value<bool> isSynced,
      required String createdAt,
      required String updatedAt,
      Value<String?> completedAt,
      Value<int> rowid,
    });
typedef $$OrdersTableTableUpdateCompanionBuilder =
    OrdersTableCompanion Function({
      Value<String> id,
      Value<int> tableNumber,
      Value<String> waiterId,
      Value<String> waiterName,
      Value<String> status,
      Value<String> paymentMethod,
      Value<double> subtotal,
      Value<double> tax,
      Value<double> total,
      Value<String?> note,
      Value<bool> isSynced,
      Value<String> createdAt,
      Value<String> updatedAt,
      Value<String?> completedAt,
      Value<int> rowid,
    });

class $$OrdersTableTableFilterComposer
    extends Composer<_$LocalDatabase, $OrdersTableTable> {
  $$OrdersTableTableFilterComposer({
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

  ColumnFilters<int> get tableNumber => $composableBuilder(
    column: $table.tableNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get waiterId => $composableBuilder(
    column: $table.waiterId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get waiterName => $composableBuilder(
    column: $table.waiterName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get paymentMethod => $composableBuilder(
    column: $table.paymentMethod,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get subtotal => $composableBuilder(
    column: $table.subtotal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get tax => $composableBuilder(
    column: $table.tax,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get total => $composableBuilder(
    column: $table.total,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$OrdersTableTableOrderingComposer
    extends Composer<_$LocalDatabase, $OrdersTableTable> {
  $$OrdersTableTableOrderingComposer({
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

  ColumnOrderings<int> get tableNumber => $composableBuilder(
    column: $table.tableNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get waiterId => $composableBuilder(
    column: $table.waiterId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get waiterName => $composableBuilder(
    column: $table.waiterName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get paymentMethod => $composableBuilder(
    column: $table.paymentMethod,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get subtotal => $composableBuilder(
    column: $table.subtotal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get tax => $composableBuilder(
    column: $table.tax,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get total => $composableBuilder(
    column: $table.total,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$OrdersTableTableAnnotationComposer
    extends Composer<_$LocalDatabase, $OrdersTableTable> {
  $$OrdersTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get tableNumber => $composableBuilder(
    column: $table.tableNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get waiterId =>
      $composableBuilder(column: $table.waiterId, builder: (column) => column);

  GeneratedColumn<String> get waiterName => $composableBuilder(
    column: $table.waiterName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get paymentMethod => $composableBuilder(
    column: $table.paymentMethod,
    builder: (column) => column,
  );

  GeneratedColumn<double> get subtotal =>
      $composableBuilder(column: $table.subtotal, builder: (column) => column);

  GeneratedColumn<double> get tax =>
      $composableBuilder(column: $table.tax, builder: (column) => column);

  GeneratedColumn<double> get total =>
      $composableBuilder(column: $table.total, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );
}

class $$OrdersTableTableTableManager
    extends
        RootTableManager<
          _$LocalDatabase,
          $OrdersTableTable,
          OrdersTableData,
          $$OrdersTableTableFilterComposer,
          $$OrdersTableTableOrderingComposer,
          $$OrdersTableTableAnnotationComposer,
          $$OrdersTableTableCreateCompanionBuilder,
          $$OrdersTableTableUpdateCompanionBuilder,
          (
            OrdersTableData,
            BaseReferences<_$LocalDatabase, $OrdersTableTable, OrdersTableData>,
          ),
          OrdersTableData,
          PrefetchHooks Function()
        > {
  $$OrdersTableTableTableManager(_$LocalDatabase db, $OrdersTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OrdersTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OrdersTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OrdersTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> tableNumber = const Value.absent(),
                Value<String> waiterId = const Value.absent(),
                Value<String> waiterName = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> paymentMethod = const Value.absent(),
                Value<double> subtotal = const Value.absent(),
                Value<double> tax = const Value.absent(),
                Value<double> total = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<String> createdAt = const Value.absent(),
                Value<String> updatedAt = const Value.absent(),
                Value<String?> completedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OrdersTableCompanion(
                id: id,
                tableNumber: tableNumber,
                waiterId: waiterId,
                waiterName: waiterName,
                status: status,
                paymentMethod: paymentMethod,
                subtotal: subtotal,
                tax: tax,
                total: total,
                note: note,
                isSynced: isSynced,
                createdAt: createdAt,
                updatedAt: updatedAt,
                completedAt: completedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required int tableNumber,
                required String waiterId,
                required String waiterName,
                required String status,
                Value<String> paymentMethod = const Value.absent(),
                required double subtotal,
                required double tax,
                required double total,
                Value<String?> note = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                required String createdAt,
                required String updatedAt,
                Value<String?> completedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OrdersTableCompanion.insert(
                id: id,
                tableNumber: tableNumber,
                waiterId: waiterId,
                waiterName: waiterName,
                status: status,
                paymentMethod: paymentMethod,
                subtotal: subtotal,
                tax: tax,
                total: total,
                note: note,
                isSynced: isSynced,
                createdAt: createdAt,
                updatedAt: updatedAt,
                completedAt: completedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$OrdersTableTableProcessedTableManager =
    ProcessedTableManager<
      _$LocalDatabase,
      $OrdersTableTable,
      OrdersTableData,
      $$OrdersTableTableFilterComposer,
      $$OrdersTableTableOrderingComposer,
      $$OrdersTableTableAnnotationComposer,
      $$OrdersTableTableCreateCompanionBuilder,
      $$OrdersTableTableUpdateCompanionBuilder,
      (
        OrdersTableData,
        BaseReferences<_$LocalDatabase, $OrdersTableTable, OrdersTableData>,
      ),
      OrdersTableData,
      PrefetchHooks Function()
    >;
typedef $$OrderItemsTableTableCreateCompanionBuilder =
    OrderItemsTableCompanion Function({
      required String id,
      required String orderId,
      required String productId,
      required String productName,
      required String productNameKr,
      required double price,
      required int quantity,
      Value<String?> note,
      Value<int> rowid,
    });
typedef $$OrderItemsTableTableUpdateCompanionBuilder =
    OrderItemsTableCompanion Function({
      Value<String> id,
      Value<String> orderId,
      Value<String> productId,
      Value<String> productName,
      Value<String> productNameKr,
      Value<double> price,
      Value<int> quantity,
      Value<String?> note,
      Value<int> rowid,
    });

class $$OrderItemsTableTableFilterComposer
    extends Composer<_$LocalDatabase, $OrderItemsTableTable> {
  $$OrderItemsTableTableFilterComposer({
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

  ColumnFilters<String> get orderId => $composableBuilder(
    column: $table.orderId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get productName => $composableBuilder(
    column: $table.productName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get productNameKr => $composableBuilder(
    column: $table.productNameKr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get price => $composableBuilder(
    column: $table.price,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );
}

class $$OrderItemsTableTableOrderingComposer
    extends Composer<_$LocalDatabase, $OrderItemsTableTable> {
  $$OrderItemsTableTableOrderingComposer({
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

  ColumnOrderings<String> get orderId => $composableBuilder(
    column: $table.orderId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get productName => $composableBuilder(
    column: $table.productName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get productNameKr => $composableBuilder(
    column: $table.productNameKr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get price => $composableBuilder(
    column: $table.price,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$OrderItemsTableTableAnnotationComposer
    extends Composer<_$LocalDatabase, $OrderItemsTableTable> {
  $$OrderItemsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get orderId =>
      $composableBuilder(column: $table.orderId, builder: (column) => column);

  GeneratedColumn<String> get productId =>
      $composableBuilder(column: $table.productId, builder: (column) => column);

  GeneratedColumn<String> get productName => $composableBuilder(
    column: $table.productName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get productNameKr => $composableBuilder(
    column: $table.productNameKr,
    builder: (column) => column,
  );

  GeneratedColumn<double> get price =>
      $composableBuilder(column: $table.price, builder: (column) => column);

  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);
}

class $$OrderItemsTableTableTableManager
    extends
        RootTableManager<
          _$LocalDatabase,
          $OrderItemsTableTable,
          OrderItemsTableData,
          $$OrderItemsTableTableFilterComposer,
          $$OrderItemsTableTableOrderingComposer,
          $$OrderItemsTableTableAnnotationComposer,
          $$OrderItemsTableTableCreateCompanionBuilder,
          $$OrderItemsTableTableUpdateCompanionBuilder,
          (
            OrderItemsTableData,
            BaseReferences<
              _$LocalDatabase,
              $OrderItemsTableTable,
              OrderItemsTableData
            >,
          ),
          OrderItemsTableData,
          PrefetchHooks Function()
        > {
  $$OrderItemsTableTableTableManager(
    _$LocalDatabase db,
    $OrderItemsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OrderItemsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OrderItemsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OrderItemsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> orderId = const Value.absent(),
                Value<String> productId = const Value.absent(),
                Value<String> productName = const Value.absent(),
                Value<String> productNameKr = const Value.absent(),
                Value<double> price = const Value.absent(),
                Value<int> quantity = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OrderItemsTableCompanion(
                id: id,
                orderId: orderId,
                productId: productId,
                productName: productName,
                productNameKr: productNameKr,
                price: price,
                quantity: quantity,
                note: note,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String orderId,
                required String productId,
                required String productName,
                required String productNameKr,
                required double price,
                required int quantity,
                Value<String?> note = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OrderItemsTableCompanion.insert(
                id: id,
                orderId: orderId,
                productId: productId,
                productName: productName,
                productNameKr: productNameKr,
                price: price,
                quantity: quantity,
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

typedef $$OrderItemsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$LocalDatabase,
      $OrderItemsTableTable,
      OrderItemsTableData,
      $$OrderItemsTableTableFilterComposer,
      $$OrderItemsTableTableOrderingComposer,
      $$OrderItemsTableTableAnnotationComposer,
      $$OrderItemsTableTableCreateCompanionBuilder,
      $$OrderItemsTableTableUpdateCompanionBuilder,
      (
        OrderItemsTableData,
        BaseReferences<
          _$LocalDatabase,
          $OrderItemsTableTable,
          OrderItemsTableData
        >,
      ),
      OrderItemsTableData,
      PrefetchHooks Function()
    >;
typedef $$ShiftsTableTableCreateCompanionBuilder =
    ShiftsTableCompanion Function({
      required String date,
      required String closedAt,
      required double totalRevenue,
      required int totalOrders,
      required String topProductsJson,
      Value<int> rowid,
    });
typedef $$ShiftsTableTableUpdateCompanionBuilder =
    ShiftsTableCompanion Function({
      Value<String> date,
      Value<String> closedAt,
      Value<double> totalRevenue,
      Value<int> totalOrders,
      Value<String> topProductsJson,
      Value<int> rowid,
    });

class $$ShiftsTableTableFilterComposer
    extends Composer<_$LocalDatabase, $ShiftsTableTable> {
  $$ShiftsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get closedAt => $composableBuilder(
    column: $table.closedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totalRevenue => $composableBuilder(
    column: $table.totalRevenue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalOrders => $composableBuilder(
    column: $table.totalOrders,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get topProductsJson => $composableBuilder(
    column: $table.topProductsJson,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ShiftsTableTableOrderingComposer
    extends Composer<_$LocalDatabase, $ShiftsTableTable> {
  $$ShiftsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get closedAt => $composableBuilder(
    column: $table.closedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totalRevenue => $composableBuilder(
    column: $table.totalRevenue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalOrders => $composableBuilder(
    column: $table.totalOrders,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get topProductsJson => $composableBuilder(
    column: $table.topProductsJson,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ShiftsTableTableAnnotationComposer
    extends Composer<_$LocalDatabase, $ShiftsTableTable> {
  $$ShiftsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get closedAt =>
      $composableBuilder(column: $table.closedAt, builder: (column) => column);

  GeneratedColumn<double> get totalRevenue => $composableBuilder(
    column: $table.totalRevenue,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalOrders => $composableBuilder(
    column: $table.totalOrders,
    builder: (column) => column,
  );

  GeneratedColumn<String> get topProductsJson => $composableBuilder(
    column: $table.topProductsJson,
    builder: (column) => column,
  );
}

class $$ShiftsTableTableTableManager
    extends
        RootTableManager<
          _$LocalDatabase,
          $ShiftsTableTable,
          ShiftsTableData,
          $$ShiftsTableTableFilterComposer,
          $$ShiftsTableTableOrderingComposer,
          $$ShiftsTableTableAnnotationComposer,
          $$ShiftsTableTableCreateCompanionBuilder,
          $$ShiftsTableTableUpdateCompanionBuilder,
          (
            ShiftsTableData,
            BaseReferences<_$LocalDatabase, $ShiftsTableTable, ShiftsTableData>,
          ),
          ShiftsTableData,
          PrefetchHooks Function()
        > {
  $$ShiftsTableTableTableManager(_$LocalDatabase db, $ShiftsTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ShiftsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ShiftsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ShiftsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> date = const Value.absent(),
                Value<String> closedAt = const Value.absent(),
                Value<double> totalRevenue = const Value.absent(),
                Value<int> totalOrders = const Value.absent(),
                Value<String> topProductsJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ShiftsTableCompanion(
                date: date,
                closedAt: closedAt,
                totalRevenue: totalRevenue,
                totalOrders: totalOrders,
                topProductsJson: topProductsJson,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String date,
                required String closedAt,
                required double totalRevenue,
                required int totalOrders,
                required String topProductsJson,
                Value<int> rowid = const Value.absent(),
              }) => ShiftsTableCompanion.insert(
                date: date,
                closedAt: closedAt,
                totalRevenue: totalRevenue,
                totalOrders: totalOrders,
                topProductsJson: topProductsJson,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ShiftsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$LocalDatabase,
      $ShiftsTableTable,
      ShiftsTableData,
      $$ShiftsTableTableFilterComposer,
      $$ShiftsTableTableOrderingComposer,
      $$ShiftsTableTableAnnotationComposer,
      $$ShiftsTableTableCreateCompanionBuilder,
      $$ShiftsTableTableUpdateCompanionBuilder,
      (
        ShiftsTableData,
        BaseReferences<_$LocalDatabase, $ShiftsTableTable, ShiftsTableData>,
      ),
      ShiftsTableData,
      PrefetchHooks Function()
    >;

class $LocalDatabaseManager {
  final _$LocalDatabase _db;
  $LocalDatabaseManager(this._db);
  $$ProductsTableTableTableManager get productsTable =>
      $$ProductsTableTableTableManager(_db, _db.productsTable);
  $$OrdersTableTableTableManager get ordersTable =>
      $$OrdersTableTableTableManager(_db, _db.ordersTable);
  $$OrderItemsTableTableTableManager get orderItemsTable =>
      $$OrderItemsTableTableTableManager(_db, _db.orderItemsTable);
  $$ShiftsTableTableTableManager get shiftsTable =>
      $$ShiftsTableTableTableManager(_db, _db.shiftsTable);
}
