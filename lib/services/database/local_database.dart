import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'local_database.g.dart';

// ─── TABLALAR ─────────────────────────────────────────────────

class ProductsTable extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get nameKr => text().named('name_kr')();
  RealColumn get price => real()();
  TextColumn get category => text()();
  TextColumn get imageUrl => text().nullable().named('image_url')();
  BoolColumn get isAvailable =>
      boolean().named('is_available').withDefault(const Constant(true))();
  IntColumn get sortOrder =>
      integer().named('sort_order').withDefault(const Constant(0))();
  TextColumn get createdAt => text().named('created_at')();
  TextColumn get updatedAt => text().named('updated_at')();

  @override
  Set<Column> get primaryKey => {id};
}

class OrdersTable extends Table {
  TextColumn get id => text()();
  IntColumn get tableNumber => integer().named('table_number')();
  TextColumn get waiterId => text().named('waiter_id')();
  TextColumn get waiterName => text().named('waiter_name')();
  TextColumn get status => text()();
  TextColumn get paymentMethod =>
      text().named('payment_method').withDefault(const Constant('cash'))();
  RealColumn get subtotal => real()();
  RealColumn get tax => real()();
  RealColumn get total => real()();
  TextColumn get note => text().nullable()();
  BoolColumn get isSynced =>
      boolean().named('is_synced').withDefault(const Constant(false))();
  TextColumn get createdAt => text().named('created_at')();
  TextColumn get updatedAt => text().named('updated_at')();
  TextColumn get completedAt => text().nullable().named('completed_at')();

  @override
  Set<Column> get primaryKey => {id};
}

class OrderItemsTable extends Table {
  TextColumn get id => text()();
  TextColumn get orderId => text().named('order_id')();
  TextColumn get productId => text().named('product_id')();
  TextColumn get productName => text().named('product_name')();
  TextColumn get productNameKr => text().named('product_name_kr')();
  RealColumn get price => real()();
  IntColumn get quantity => integer()();
  TextColumn get note => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class ShiftsTable extends Table {
  TextColumn get date => text()(); // 'YYYY-MM-DD'
  TextColumn get closedAt => text().named('closed_at')();
  RealColumn get totalRevenue => real().named('total_revenue')();
  IntColumn get totalOrders => integer().named('total_orders')();
  TextColumn get topProductsJson => text().named('top_products_json')();

  @override
  Set<Column> get primaryKey => {date};
}

// ─── DATABASE ─────────────────────────────────────────────────

@DriftDatabase(
  tables: [ProductsTable, OrdersTable, OrderItemsTable, ShiftsTable],
)
class LocalDatabase extends _$LocalDatabase {
  LocalDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  // ─── Products ─────────────────────────────────────────────

  Future<List<ProductsTableData>> getAllProducts() =>
      select(productsTable).get();

  Future<void> upsertProduct(ProductsTableCompanion product) =>
      into(productsTable).insertOnConflictUpdate(product);

  Future<void> deleteProduct(String id) =>
      (delete(productsTable)..where((t) => t.id.equals(id))).go();

  Future<void> clearProducts() => delete(productsTable).go();

  // ─── Orders ───────────────────────────────────────────────

  Future<String> insertOrder(OrdersTableCompanion order) async {
    await into(ordersTable).insert(order);
    return order.id.value;
  }

  Future<void> updateOrderStatus(
    String id,
    String status, {
    String? paymentMethod,
    String? completedAt,
  }) async {
    await (update(ordersTable)..where((t) => t.id.equals(id))).write(
      OrdersTableCompanion(
        status: Value(status),
        paymentMethod: paymentMethod != null
            ? Value(paymentMethod)
            : const Value.absent(),
        completedAt: completedAt != null
            ? Value(completedAt)
            : const Value.absent(),
        updatedAt: Value(DateTime.now().toIso8601String()),
      ),
    );
  }

  Future<void> markOrderSynced(String id) async {
    await (update(ordersTable)..where((t) => t.id.equals(id))).write(
      const OrdersTableCompanion(isSynced: Value(true)),
    );
  }

  Future<List<OrdersTableData>> getUnsyncedOrders() =>
      (select(ordersTable)..where((t) => t.isSynced.equals(false))).get();

  Future<List<OrdersTableData>> getOrdersByDate(DateTime date) {
    final start = DateTime(date.year, date.month, date.day).toIso8601String();
    final end = DateTime(date.year, date.month, date.day + 1).toIso8601String();
    return (select(ordersTable)
          ..where(
            (t) =>
                t.createdAt.isBiggerOrEqualValue(start) &
                t.createdAt.isSmallerThanValue(end),
          )
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .get();
  }

  Future<List<OrdersTableData>> getOrdersByRange(DateTime from, DateTime to) {
    return (select(ordersTable)
          ..where(
            (t) =>
                t.createdAt.isBiggerOrEqualValue(from.toIso8601String()) &
                t.createdAt.isSmallerThanValue(to.toIso8601String()) &
                t.status.equals('completed'),
          )
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .get();
  }

  // ─── Order Items ──────────────────────────────────────────

  Future<void> insertOrderItems(List<OrderItemsTableCompanion> items) async {
    await batch((b) => b.insertAll(orderItemsTable, items));
  }

  Future<List<OrderItemsTableData>> getItemsForOrder(String orderId) =>
      (select(orderItemsTable)..where((t) => t.orderId.equals(orderId))).get();

  // ─── Shifts ───────────────────────────────────────────────

  Future<void> saveShift(ShiftsTableCompanion shift) =>
      into(shiftsTable).insertOnConflictUpdate(shift);

  Future<List<ShiftsTableData>> getAllShifts() =>
      (select(shiftsTable)..orderBy([(t) => OrderingTerm.desc(t.date)])).get();

  Future<ShiftsTableData?> getShift(String date) => (select(
    shiftsTable,
  )..where((t) => t.date.equals(date))).getSingleOrNull();
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'restoran_pos.db'));
    return NativeDatabase(file);
  });
}
