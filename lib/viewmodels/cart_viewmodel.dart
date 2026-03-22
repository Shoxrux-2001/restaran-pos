import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/order_item_model.dart';
import '../models/order_model.dart';
import '../models/product_model.dart';
import '../core/constants/app_constants.dart';

/// To'lov turi
enum PaymentTarget {
  table, // Stolga — stol tanlash kerak
  takeout, // Sayoq (olib ketish) — stol shart emas
}

class CartViewModel extends ChangeNotifier {
  final _uuid = const Uuid();

  int _tableNumber = 0;
  PaymentTarget _paymentTarget = PaymentTarget.table;
  final List<OrderItemModel> _items = [];
  OrderItemModel? _lastRemoved;

  int get tableNumber => _tableNumber;
  PaymentTarget get paymentTarget => _paymentTarget;
  bool get isTakeout => _paymentTarget == PaymentTarget.takeout;
  List<OrderItemModel> get items => List.unmodifiable(_items);
  bool get isEmpty => _items.isEmpty;
  int get itemCount => _items.fold(0, (s, i) => s + i.quantity);

  double get subtotal => _items.fold(0, (s, i) => s + i.total);
  double get tax => subtotal * AppConstants.taxRate;
  double get total => subtotal + tax;

  void setTable(int tableNumber) {
    _tableNumber = tableNumber;
    _paymentTarget = PaymentTarget.table;
    notifyListeners();
  }

  void setTakeout() {
    _tableNumber = 0;
    _paymentTarget = PaymentTarget.takeout;
    notifyListeners();
  }

  void addProduct(ProductModel product) {
    final index = _items.indexWhere((i) => i.productId == product.id);
    if (index >= 0) {
      _items[index] = _items[index].copyWith(
        quantity: _items[index].quantity + 1,
      );
    } else {
      _items.add(
        OrderItemModel(
          id: _uuid.v4(),
          orderId: '',
          productId: product.id,
          productName: product.name,
          productNameKr: product.nameKr,
          price: product.price,
          quantity: 1,
        ),
      );
    }
    notifyListeners();
  }

  void addById(String productId) {
    final index = _items.indexWhere((i) => i.productId == productId);
    if (index < 0) return;
    _items[index] = _items[index].copyWith(
      quantity: _items[index].quantity + 1,
    );
    notifyListeners();
  }

  void removeOne(String productId) {
    final index = _items.indexWhere((i) => i.productId == productId);
    if (index < 0) return;
    if (_items[index].quantity <= 1) {
      _items.removeAt(index);
    } else {
      _items[index] = _items[index].copyWith(
        quantity: _items[index].quantity - 1,
      );
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    final index = _items.indexWhere((i) => i.productId == productId);
    if (index < 0) return;
    _lastRemoved = _items[index];
    _items.removeAt(index);
    notifyListeners();
  }

  void undoRemove() {
    if (_lastRemoved == null) return;
    _items.add(_lastRemoved!);
    _lastRemoved = null;
    notifyListeners();
  }

  bool get canUndo => _lastRemoved != null;

  int getQuantity(String productId) {
    return _items
            .where((i) => i.productId == productId)
            .firstOrNull
            ?.quantity ??
        0;
  }

  /// Mavjud zakazdan cartni yuklash — yangi mahsulotlar bilan MERGE qilish
  void mergeFromOrder(OrderModel order) {
    _tableNumber = order.tableNumber;
    _paymentTarget = PaymentTarget.table;
    for (final item in order.items) {
      final existing = _items.indexWhere((i) => i.productId == item.productId);
      if (existing >= 0) {
        // Allaqachon cartda bor — miqdorini qo'shamiz
        _items[existing] = _items[existing].copyWith(
          quantity: _items[existing].quantity + item.quantity,
        );
      } else {
        // Yangi mahsulot — qo'shamiz
        _items.add(
          OrderItemModel(
            id: item.id,
            orderId: item.orderId,
            productId: item.productId,
            productName: item.productName,
            productNameKr: item.productNameKr,
            price: item.price,
            quantity: item.quantity,
            note: item.note,
          ),
        );
      }
    }
    notifyListeners();
  }

  /// Faqat stol va targetni o'zgartirish (mahsulotlarni saqlab)
  void loadFromOrder(OrderModel order) {
    _items.clear();
    _tableNumber = order.tableNumber;
    _paymentTarget = PaymentTarget.table;
    for (final item in order.items) {
      _items.add(
        OrderItemModel(
          id: item.id,
          orderId: item.orderId,
          productId: item.productId,
          productName: item.productName,
          productNameKr: item.productNameKr,
          price: item.price,
          quantity: item.quantity,
          note: item.note,
        ),
      );
    }
    notifyListeners();
  }

  void clear() {
    _items.clear();
    _tableNumber = 0;
    _paymentTarget = PaymentTarget.table;
    _lastRemoved = null;
    notifyListeners();
  }
}
