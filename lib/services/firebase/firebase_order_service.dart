import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/order_model.dart';
import '../../models/order_item_model.dart';
import '../../core/constants/app_constants.dart';

class FirebaseOrderService {
  final _db = FirebaseFirestore.instance;
  CollectionReference get _col => _db.collection(AppConstants.colOrders);

  // Zakaz saqlash
  Future<void> saveOrder(OrderModel order) async {
    await _col.doc(order.id).set(order.toFirestore());
  }

  // Zakazni yangilash (status, to'lov)
  Future<void> updateOrder(String id, Map<String, dynamic> data) async {
    await _col.doc(id).update({
      ...data,
      'updated_at': DateTime.now().toIso8601String(),
    });
  }

  // Kunlik zakazlar (sana bo'yicha)
  Future<List<OrderModel>> getOrdersByDate(DateTime date) async {
    final start = DateTime(date.year, date.month, date.day);
    final end = start.add(const Duration(days: 1));

    final snap = await _col
        .where('created_at', isGreaterThanOrEqualTo: start.toIso8601String())
        .where('created_at', isLessThan: end.toIso8601String())
        .orderBy('created_at', descending: true)
        .get();

    return snap.docs.map((d) {
      final data = d.data() as Map<String, dynamic>;
      final itemsList = (data['items'] as List<dynamic>? ?? [])
          .map((i) => OrderItemModel.fromMap(i as Map<String, dynamic>))
          .toList();
      return OrderModel.fromMap(data, items: itemsList);
    }).toList();
  }

  // Sana oralig'i bo'yicha (haftalik, oylik)
  Future<List<OrderModel>> getOrdersByRange(DateTime from, DateTime to) async {
    final snap = await _col
        .where('created_at', isGreaterThanOrEqualTo: from.toIso8601String())
        .where('created_at', isLessThan: to.toIso8601String())
        .where('status', isEqualTo: AppConstants.statusCompleted)
        .orderBy('created_at', descending: true)
        .get();

    return snap.docs.map((d) {
      final data = d.data() as Map<String, dynamic>;
      final itemsList = (data['items'] as List<dynamic>? ?? [])
          .map((i) => OrderItemModel.fromMap(i as Map<String, dynamic>))
          .toList();
      return OrderModel.fromMap(data, items: itemsList);
    }).toList();
  }

  // Faol zakazlar (to'lanmagan)
  Future<List<OrderModel>> getActiveOrders() async {
    final snap = await _col
        .where('status', isEqualTo: AppConstants.statusWaiting)
        .orderBy('created_at', descending: false)
        .get();

    return snap.docs.map((d) {
      final data = d.data() as Map<String, dynamic>;
      final itemsList = (data['items'] as List<dynamic>? ?? [])
          .map((i) => OrderItemModel.fromMap(i as Map<String, dynamic>))
          .toList();
      return OrderModel.fromMap(data, items: itemsList);
    }).toList();
  }

  // Smena yopilganda — kun belgilanadi
  Future<void> closeShift(DateTime date, Map<String, dynamic> summary) async {
    await _db
        .collection('shifts')
        .doc(date.toIso8601String().split('T')[0])
        .set({
          'date': date.toIso8601String().split('T')[0],
          'closed_at': DateTime.now().toIso8601String(),
          'total_revenue': summary['total_revenue'],
          'total_orders': summary['total_orders'],
          'top_products': summary['top_products'],
        });
  }

  // O'tgan smenalar
  Future<List<Map<String, dynamic>>> getShifts({int limit = 30}) async {
    final snap = await _db
        .collection('shifts')
        .orderBy('date', descending: true)
        .limit(limit)
        .get();

    return snap.docs.map((d) => d.data() as Map<String, dynamic>).toList();
  }

  // Smena ma'lumotlari (tafsilot)
  Future<List<OrderModel>> getShiftOrders(String date) async {
    final start = DateTime.parse(date);
    final end = start.add(const Duration(days: 1));

    final snap = await _col
        .where('created_at', isGreaterThanOrEqualTo: start.toIso8601String())
        .where('created_at', isLessThan: end.toIso8601String())
        .orderBy('created_at')
        .get();

    return snap.docs.map((d) {
      final data = d.data() as Map<String, dynamic>;
      final itemsList = (data['items'] as List<dynamic>? ?? [])
          .map((i) => OrderItemModel.fromMap(i as Map<String, dynamic>))
          .toList();
      return OrderModel.fromMap(data, items: itemsList);
    }).toList();
  }
}
