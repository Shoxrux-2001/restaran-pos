import 'package:flutter/material.dart';
import '../models/order_model.dart';
import '../core/constants/app_constants.dart';

class TableViewModel extends ChangeNotifier {
  // Bir stolda BIR NECHTA zakaz bo'lishi mumkin
  final Map<int, List<OrderModel>> _ordersByTable = {};
  final int totalTables = AppConstants.defaultTableCount;

  bool isOccupied(int tableNumber) =>
      _ordersByTable.containsKey(tableNumber) &&
      _ordersByTable[tableNumber]!.isNotEmpty;

  // Birinchi (asosiy) zakazni qaytaradi — 1-rejim uchun
  OrderModel? getOrder(int tableNumber) =>
      _ordersByTable[tableNumber]?.firstOrNull;

  // Stoldagi barcha zakazlar
  List<OrderModel> getOrders(int tableNumber) =>
      List.unmodifiable(_ordersByTable[tableNumber] ?? []);

  // Stoldagi jami summa (barcha zakazlar)
  double getTableTotal(int tableNumber) =>
      (_ordersByTable[tableNumber] ?? []).fold(0.0, (sum, o) => sum + o.total);

  // Stoldagi jami itemlar soni
  int getTableItemCount(int tableNumber) => (_ordersByTable[tableNumber] ?? [])
      .fold(0, (sum, o) => sum + o.itemCount);

  String getTableWaiter(int tableNumber) =>
      _ordersByTable[tableNumber]?.firstOrNull?.waiterName ?? '';

  Duration getTableDuration(int tableNumber) {
    final order = _ordersByTable[tableNumber]?.firstOrNull;
    if (order == null) return Duration.zero;
    return DateTime.now().difference(order.createdAt);
  }

  /// Yangi zakaz qo'shish — avvalgilarni o'CHIRMASDAN qo'shadi
  void occupyTable(OrderModel order) {
    _ordersByTable.putIfAbsent(order.tableNumber, () => []);
    // Agar bu zakaz allaqachon bor bo'lsa update, yo'qsa add
    final idx = _ordersByTable[order.tableNumber]!.indexWhere(
      (o) => o.id == order.id,
    );
    if (idx >= 0) {
      _ordersByTable[order.tableNumber]![idx] = order;
    } else {
      _ordersByTable[order.tableNumber]!.add(order);
    }
    notifyListeners();
  }

  /// Bitta zakazni o'chirish (to'lov bo'lganda)
  void removeOrder(String orderId, int tableNumber) {
    _ordersByTable[tableNumber]?.removeWhere((o) => o.id == orderId);
    if (_ordersByTable[tableNumber]?.isEmpty == true) {
      _ordersByTable.remove(tableNumber);
    }
    notifyListeners();
  }

  /// Stoldagi barcha zakazlarni tozalash
  void freeTable(int tableNumber) {
    _ordersByTable.remove(tableNumber);
    notifyListeners();
  }

  Map<int, List<OrderModel>> get activeByTable =>
      Map.unmodifiable(_ordersByTable);

  List<OrderModel> get allActiveOrders =>
      _ordersByTable.values.expand((list) => list).toList()
        ..sort((a, b) => a.tableNumber.compareTo(b.tableNumber));
}
