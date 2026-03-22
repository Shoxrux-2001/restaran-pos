import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:restoran_pos/services/database/local_database.dart';
import 'package:uuid/uuid.dart';
import 'package:drift/drift.dart';
import '../models/order_model.dart';
import '../models/order_item_model.dart';
import '../core/constants/app_constants.dart';
import '../core/utils/connectivity_helper.dart';
import '../services/firebase/firebase_order_service.dart';

class OrderViewModel extends ChangeNotifier {
  final FirebaseOrderService _fireService;
  final LocalDatabase _local;
  final _uuid = const Uuid();

  List<OrderModel> _activeOrders = [];
  List<OrderModel> _historyOrders = [];
  List<Map<String, dynamic>> _shifts = [];
  bool _isLoading = false;
  String? _error;

  OrderViewModel({
    required FirebaseOrderService fireService,
    required LocalDatabase local,
  }) : _fireService = fireService,
       _local = local;

  List<OrderModel> get activeOrders => _activeOrders;
  List<OrderModel> get historyOrders => _historyOrders;
  List<Map<String, dynamic>> get shifts => _shifts;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Tarix yuklash
  Future<void> loadHistory({DateTime? date}) async {
    _isLoading = true;
    notifyListeners();
    try {
      final d = date ?? DateTime.now();
      final isOnline = await ConnectivityHelper.isConnected();
      if (isOnline) {
        _historyOrders = await _fireService.getOrdersByDate(d);
      } else {
        final rows = await _local.getOrdersByDate(d);
        _historyOrders = await _rowsToModels(rows);
      }
    } catch (e) {
      _error = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  // Sana oralig'i bo'yicha tarix
  Future<List<OrderModel>> getOrdersByRange(DateTime from, DateTime to) async {
    try {
      final isOnline = await ConnectivityHelper.isConnected();
      if (isOnline) {
        return await _fireService.getOrdersByRange(from, to);
      } else {
        final rows = await _local.getOrdersByRange(from, to);
        return _rowsToModels(rows);
      }
    } catch (e) {
      return [];
    }
  }

  // Yangi zakaz yaratish
  Future<OrderModel?> createOrder({
    required int tableNumber,
    required String waiterId,
    required String waiterName,
    required List<OrderItemModel> items,
    required double subtotal,
    required double tax,
    required double total,
    String? note,
  }) async {
    try {
      final orderId = _uuid.v4();
      final now = DateTime.now();

      final orderItems = items
          .map(
            (i) => OrderItemModel(
              id: i.id.isEmpty ? _uuid.v4() : i.id,
              orderId: orderId,
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
        id: orderId,
        tableNumber: tableNumber,
        waiterId: waiterId,
        waiterName: waiterName,
        items: orderItems,
        status: AppConstants.statusWaiting,
        subtotal: subtotal,
        tax: tax,
        total: total,
        note: note,
        isSynced: false,
        createdAt: now,
        updatedAt: now,
      );

      // 1. Avval local ga saqlash
      await _local.insertOrder(
        OrdersTableCompanion(
          id: Value(order.id),
          tableNumber: Value(order.tableNumber),
          waiterId: Value(order.waiterId),
          waiterName: Value(order.waiterName),
          status: Value(order.status),
          paymentMethod: Value(order.paymentMethod),
          subtotal: Value(order.subtotal),
          tax: Value(order.tax),
          total: Value(order.total),
          note: Value(order.note),
          isSynced: const Value(false),
          createdAt: Value(now.toIso8601String()),
          updatedAt: Value(now.toIso8601String()),
        ),
      );

      await _local.insertOrderItems(
        orderItems
            .map(
              (i) => OrderItemsTableCompanion(
                id: Value(i.id),
                orderId: Value(i.orderId),
                productId: Value(i.productId),
                productName: Value(i.productName),
                productNameKr: Value(i.productNameKr),
                price: Value(i.price),
                quantity: Value(i.quantity),
                note: Value(i.note),
              ),
            )
            .toList(),
      );

      // 2. Online bo'lsa Firestore ga ham yuborish
      bool synced = false;
      final isOnline = await ConnectivityHelper.isConnected();
      if (isOnline) {
        await _fireService.saveOrder(order);
        await _local.markOrderSynced(order.id);
        synced = true;
      }

      _activeOrders.insert(0, order.copyWith(isSynced: synced));
      notifyListeners();
      return order;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }

  // To'lov qilish
  Future<bool> completeOrder(String orderId, String paymentMethod) async {
    try {
      final now = DateTime.now();
      await _local.updateOrderStatus(
        orderId,
        AppConstants.statusCompleted,
        paymentMethod: paymentMethod,
        completedAt: now.toIso8601String(),
      );

      final isOnline = await ConnectivityHelper.isConnected();
      if (isOnline) {
        await _fireService.updateOrder(orderId, {
          'status': AppConstants.statusCompleted,
          'payment_method': paymentMethod,
          'completed_at': now.toIso8601String(),
        });
      }

      final idx = _activeOrders.indexWhere((o) => o.id == orderId);
      if (idx >= 0) {
        final updated = _activeOrders[idx].copyWith(
          status: AppConstants.statusCompleted,
          paymentMethod: paymentMethod,
          completedAt: now,
        );
        _historyOrders.insert(0, updated);
        _activeOrders.removeAt(idx);
      }
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Zakazni bekor qilish
  Future<bool> cancelOrder(String orderId) async {
    try {
      await _local.updateOrderStatus(orderId, AppConstants.statusCancelled);
      final isOnline = await ConnectivityHelper.isConnected();
      if (isOnline) {
        await _fireService.updateOrder(orderId, {
          'status': AppConstants.statusCancelled,
        });
      }
      final idx = _activeOrders.indexWhere((o) => o.id == orderId);
      if (idx >= 0) {
        final updated = _activeOrders[idx].copyWith(
          status: AppConstants.statusCancelled,
        );
        _historyOrders.insert(0, updated);
        _activeOrders.removeAt(idx);
      }
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  // Smena yopish
  Future<void> closeShift(DateTime date, Map<String, dynamic> summary) async {
    try {
      // Firestore ga smena saqlash
      final isOnline = await ConnectivityHelper.isConnected();
      if (isOnline) {
        await _fireService.closeShift(date, summary);
      }

      // Local ga ham saqlash
      await _local.saveShift(
        ShiftsTableCompanion(
          date: Value(date.toIso8601String().split('T')[0]),
          closedAt: Value(DateTime.now().toIso8601String()),
          totalRevenue: Value((summary['total_revenue'] as num).toDouble()),
          totalOrders: Value(summary['total_orders'] as int),
          topProductsJson: Value(jsonEncode(summary['top_products'] ?? [])),
        ),
      );

      await loadShifts();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // O'tgan smenalar
  Future<void> loadShifts() async {
    try {
      final isOnline = await ConnectivityHelper.isConnected();
      if (isOnline) {
        _shifts = await _fireService.getShifts();
      } else {
        final rows = await _local.getAllShifts();
        _shifts = rows
            .map(
              (r) => {
                'date': r.date,
                'closed_at': r.closedAt,
                'total_revenue': r.totalRevenue,
                'total_orders': r.totalOrders,
              },
            )
            .toList();
      }
      notifyListeners();
    } catch (_) {}
  }

  // Smena tafsilotlari
  Future<List<OrderModel>> getShiftOrders(String date) async {
    try {
      final isOnline = await ConnectivityHelper.isConnected();
      if (isOnline) {
        return await _fireService.getShiftOrders(date);
      } else {
        final d = DateTime.parse(date);
        final rows = await _local.getOrdersByDate(d);
        return _rowsToModels(rows);
      }
    } catch (_) {
      return [];
    }
  }

  // Offline → Online sync
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
        await _fireService.saveOrder(order);
        await _local.markOrderSynced(row.id);
      }
    } catch (_) {}
  }

  Future<List<OrderModel>> _rowsToModels(List<OrdersTableData> rows) async {
    final result = <OrderModel>[];
    for (final row in rows) {
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
      result.add(
        OrderModel(
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
          isSynced: row.isSynced,
          createdAt: DateTime.parse(row.createdAt),
          updatedAt: DateTime.parse(row.updatedAt),
          completedAt: row.completedAt != null
              ? DateTime.tryParse(row.completedAt!)
              : null,
        ),
      );
    }
    return result;
  }
}
