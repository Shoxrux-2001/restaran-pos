class OrderItemModel {
  final String id;
  final String orderId;
  final String productId;
  final String productName;
  final String productNameKr;
  final double price;
  final int quantity;
  final String? note;

  OrderItemModel({
    required this.id,
    required this.orderId,
    required this.productId,
    required this.productName,
    required this.productNameKr,
    required this.price,
    required this.quantity,
    this.note,
  });

  double get total => price * quantity;

  String getName(String lang) => lang == 'kr' ? productNameKr : productName;

  Map<String, dynamic> toMap() => {
    'id': id,
    'order_id': orderId,
    'product_id': productId,
    'product_name': productName,
    'product_name_kr': productNameKr,
    'price': price,
    'quantity': quantity,
    'note': note,
  };

  factory OrderItemModel.fromMap(Map<String, dynamic> map) => OrderItemModel(
    id: map['id'] ?? '',
    orderId: map['order_id'] ?? '',
    productId: map['product_id'] ?? '',
    productName: map['product_name'] ?? '',
    productNameKr: map['product_name_kr'] ?? map['product_name'] ?? '',
    price: (map['price'] ?? 0).toDouble(),
    quantity: map['quantity'] ?? 1,
    note: map['note'],
  );

  OrderItemModel copyWith({int? quantity, String? note}) => OrderItemModel(
    id: id,
    orderId: orderId,
    productId: productId,
    productName: productName,
    productNameKr: productNameKr,
    price: price,
    quantity: quantity ?? this.quantity,
    note: note ?? this.note,
  );
}
