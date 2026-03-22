class TableModel {
  final int number;
  final String status; // 'free', 'occupied'
  final String? currentOrderId;

  TableModel({required this.number, this.status = 'free', this.currentOrderId});

  bool get isFree => status == 'free';
  bool get isOccupied => status == 'occupied';

  Map<String, dynamic> toMap() => {
    'number': number,
    'status': status,
    'current_order_id': currentOrderId,
  };

  factory TableModel.fromMap(Map<String, dynamic> map) => TableModel(
    number: map['number'] ?? 0,
    status: map['status'] ?? 'free',
    currentOrderId: map['current_order_id'],
  );

  TableModel copyWith({String? status, String? currentOrderId}) => TableModel(
    number: number,
    status: status ?? this.status,
    currentOrderId: currentOrderId ?? this.currentOrderId,
  );
}
