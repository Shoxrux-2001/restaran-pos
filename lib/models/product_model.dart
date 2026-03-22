// ============================================================
// PRODUCT MODEL
// ============================================================
class ProductModel {
  final String id;
  final String name;
  final String nameKr; // Kirill
  final double price;
  final String category;
  final String? imageUrl;
  final bool isAvailable;
  final int sortOrder;
  final DateTime createdAt;
  final DateTime updatedAt;

  ProductModel({
    required this.id,
    required this.name,
    required this.nameKr,
    required this.price,
    required this.category,
    this.imageUrl,
    this.isAvailable = true,
    this.sortOrder = 0,
    required this.createdAt,
    required this.updatedAt,
  });

  String getName(String lang) => lang == 'kr' ? nameKr : name;

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'name_kr': nameKr,
    'price': price,
    'category': category,
    'image_url': imageUrl,
    'is_available': isAvailable ? 1 : 0,
    'sort_order': sortOrder,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
  };

  Map<String, dynamic> toFirestore() => {
    'id': id,
    'name': name,
    'name_kr': nameKr,
    'price': price,
    'category': category,
    'image_url': imageUrl,
    'is_available': isAvailable,
    'sort_order': sortOrder,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
  };

  factory ProductModel.fromMap(Map<String, dynamic> map) => ProductModel(
    id: map['id'] ?? '',
    name: map['name'] ?? '',
    nameKr: map['name_kr'] ?? map['name'] ?? '',
    price: (map['price'] ?? 0).toDouble(),
    category: map['category'] ?? '',
    imageUrl: map['image_url'],
    isAvailable: map['is_available'] == 1 || map['is_available'] == true,
    sortOrder: map['sort_order'] ?? 0,
    createdAt: DateTime.tryParse(map['created_at'] ?? '') ?? DateTime.now(),
    updatedAt: DateTime.tryParse(map['updated_at'] ?? '') ?? DateTime.now(),
  );

  ProductModel copyWith({
    String? name,
    String? nameKr,
    double? price,
    String? category,
    String? imageUrl,
    bool? isAvailable,
    int? sortOrder,
  }) => ProductModel(
    id: id,
    name: name ?? this.name,
    nameKr: nameKr ?? this.nameKr,
    price: price ?? this.price,
    category: category ?? this.category,
    imageUrl: imageUrl ?? this.imageUrl,
    isAvailable: isAvailable ?? this.isAvailable,
    sortOrder: sortOrder ?? this.sortOrder,
    createdAt: createdAt,
    updatedAt: DateTime.now(),
  );
}
