import 'order_item_model.dart';
import '../core/constants/app_constants.dart';

class OrderModel {
  final String id;
  final int tableNumber;
  final String waiterId;
  final String waiterName;
  final List<OrderItemModel> items;
  final String status;
  final String paymentMethod;
  final double subtotal;
  final double tax;
  final double total;
  final String? note;
  final bool isSynced; // Firebase ga yuborilganmi
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? completedAt;

  OrderModel({
    required this.id,
    required this.tableNumber,
    required this.waiterId,
    required this.waiterName,
    required this.items,
    required this.status,
    this.paymentMethod = AppConstants.paymentCash,
    required this.subtotal,
    required this.tax,
    required this.total,
    this.note,
    this.isSynced = false,
    required this.createdAt,
    required this.updatedAt,
    this.completedAt,
  });

  bool get isCompleted => status == AppConstants.statusCompleted;
  bool get isCancelled => status == AppConstants.statusCancelled;
  bool get isWaiting => status == AppConstants.statusWaiting;
  bool get isReady => status == AppConstants.statusReady;

  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);

  Map<String, dynamic> toMap() => {
    'id': id,
    'table_number': tableNumber,
    'waiter_id': waiterId,
    'waiter_name': waiterName,
    'status': status,
    'payment_method': paymentMethod,
    'subtotal': subtotal,
    'tax': tax,
    'total': total,
    'note': note,
    'is_synced': isSynced ? 1 : 0,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
    'completed_at': completedAt?.toIso8601String(),
  };

  Map<String, dynamic> toFirestore() => {
    'id': id,
    'table_number': tableNumber,
    'waiter_id': waiterId,
    'waiter_name': waiterName,
    'items': items.map((i) => i.toMap()).toList(),
    'status': status,
    'payment_method': paymentMethod,
    'subtotal': subtotal,
    'tax': tax,
    'total': total,
    'note': note,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
    'completed_at': completedAt?.toIso8601String(),
  };

  factory OrderModel.fromMap(
    Map<String, dynamic> map, {
    List<OrderItemModel>? items,
  }) => OrderModel(
    id: map['id'] ?? '',
    tableNumber: map['table_number'] ?? 0,
    waiterId: map['waiter_id'] ?? '',
    waiterName: map['waiter_name'] ?? '',
    items: items ?? [],
    status: map['status'] ?? AppConstants.statusWaiting,
    paymentMethod: map['payment_method'] ?? AppConstants.paymentCash,
    subtotal: (map['subtotal'] ?? 0).toDouble(),
    tax: (map['tax'] ?? 0).toDouble(),
    total: (map['total'] ?? 0).toDouble(),
    note: map['note'],
    isSynced: map['is_synced'] == 1 || map['is_synced'] == true,
    createdAt: DateTime.tryParse(map['created_at'] ?? '') ?? DateTime.now(),
    updatedAt: DateTime.tryParse(map['updated_at'] ?? '') ?? DateTime.now(),
    completedAt: map['completed_at'] != null
        ? DateTime.tryParse(map['completed_at'])
        : null,
  );

  OrderModel copyWith({
    String? status,
    String? paymentMethod,
    bool? isSynced,
    DateTime? completedAt,
    List<OrderItemModel>? items,
  }) => OrderModel(
    id: id,
    tableNumber: tableNumber,
    waiterId: waiterId,
    waiterName: waiterName,
    items: items ?? this.items,
    status: status ?? this.status,
    paymentMethod: paymentMethod ?? this.paymentMethod,
    subtotal: subtotal,
    tax: tax,
    total: total,
    note: note,
    isSynced: isSynced ?? this.isSynced,
    createdAt: createdAt,
    updatedAt: DateTime.now(),
    completedAt: completedAt ?? this.completedAt,
  );
}
