import 'package:restoran_pos/services/database/local_database.dart';
import '../firebase/firebase_order_service.dart';
import '../firebase/firebase_product_service.dart';
import '../../models/order_model.dart';
import '../../models/order_item_model.dart';
import '../../models/product_model.dart';
import 'package:drift/drift.dart';

class SyncService {
  final LocalDatabase _local;
  final FirebaseOrderService _fireOrders;
  final FirebaseProductService _fireProducts;

  SyncService({
    required LocalDatabase local,
    required FirebaseOrderService fireOrders,
    required FirebaseProductService fireProducts,
  }) : _local = local,
       _fireOrders = fireOrders,
       _fireProducts = fireProducts;

  // Internet kelganida: local unsync zakazlarni Firestore ga yuborish
  Future<void> syncPendingOrders() async {
    try {
      final unsynced = await _local.getUnsyncedOrders();
      for (final row in unsynced) {
        final items = await _local.getItemsForOrder(row.id);
        final itemModels = items
            .map(
              (i) => OrderItemModel(
                id: i.id,
                orderId: i.orderId,
                productId: i.productId,
                productName: i.productName,
                productNameKr: i.productNameKr,
                price: i.price,
                quantity: i.quantity,
                note: i.note,
              ),
            )
            .toList();

        final order = OrderModel(
          id: row.id,
          tableNumber: row.tableNumber,
          waiterId: row.waiterId,
          waiterName: row.waiterName,
          items: itemModels,
          status: row.status,
          paymentMethod: row.paymentMethod,
          subtotal: row.subtotal,
          tax: row.tax,
          total: row.total,
          note: row.note,
          isSynced: false,
          createdAt: DateTime.parse(row.createdAt),
          updatedAt: DateTime.parse(row.updatedAt),
          completedAt: row.completedAt != null
              ? DateTime.tryParse(row.completedAt!)
              : null,
        );

        await _fireOrders.saveOrder(order);
        await _local.markOrderSynced(row.id);
      }
    } catch (e) {
      // Sync xatosi — keyingi urinishda qayta sinab ko'riladi
    }
  }

  // Mahsulotlarni Firestore dan yuklab local ga saqlash
  Future<List<ProductModel>> syncProducts() async {
    try {
      final products = await _fireProducts.getProducts();
      await _local.clearProducts();
      for (final p in products) {
        await _local.upsertProduct(
          ProductsTableCompanion(
            id: Value(p.id),
            name: Value(p.name),
            nameKr: Value(p.nameKr),
            price: Value(p.price),
            category: Value(p.category),
            imageUrl: Value(p.imageUrl),
            isAvailable: Value(p.isAvailable),
            sortOrder: Value(p.sortOrder),
            createdAt: Value(p.createdAt.toIso8601String()),
            updatedAt: Value(p.updatedAt.toIso8601String()),
          ),
        );
      }
      return products;
    } catch (_) {
      // Offline — local dan yuklash
      final rows = await _local.getAllProducts();
      return rows
          .map(
            (r) => ProductModel(
              id: r.id,
              name: r.name,
              nameKr: r.nameKr,
              price: r.price,
              category: r.category,
              imageUrl: r.imageUrl,
              isAvailable: r.isAvailable,
              sortOrder: r.sortOrder,
              createdAt: DateTime.parse(r.createdAt),
              updatedAt: DateTime.parse(r.updatedAt),
            ),
          )
          .toList();
    }
  }
}
