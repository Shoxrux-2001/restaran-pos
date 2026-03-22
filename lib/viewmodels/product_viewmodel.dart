import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/product_model.dart';
import '../services/firebase/firebase_product_service.dart';
import '../services/sync/sync_service.dart';

class ProductViewModel extends ChangeNotifier {
  final FirebaseProductService _fireService;
  final SyncService _sync;
  final _uuid = const Uuid();

  List<ProductModel> _all = [];
  String _searchQuery = '';
  String _selectedCategory = 'all';
  bool _isLoading = false;
  String? _error;

  ProductViewModel({
    required FirebaseProductService fireService,
    required SyncService sync,
  }) : _fireService = fireService,
       _sync = sync;

  List<ProductModel> get allProducts => _all;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get selectedCategory => _selectedCategory;

  List<ProductModel> get filteredProducts {
    var list = _all.where((p) => p.isAvailable).toList();
    if (_selectedCategory != 'all') {
      list = list.where((p) => p.category == _selectedCategory).toList();
    }
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      list = list
          .where(
            (p) =>
                p.name.toLowerCase().contains(q) ||
                p.nameKr.toLowerCase().contains(q),
          )
          .toList();
    }
    return list;
  }

  // Mahsulotlarni yuklash — Firestore + local cache
  Future<void> loadProducts() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _all = await _sync.syncProducts();
    } catch (e) {
      _error = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  // Real-time stream (admin panel uchun)
  void listenProducts() {
    _fireService.watchProducts().listen((products) {
      _all = products;
      notifyListeners();
    });
  }

  void selectCategory(String cat) {
    _selectedCategory = cat;
    notifyListeners();
  }

  void search(String q) {
    _searchQuery = q;
    notifyListeners();
  }

  // Admin: mahsulot qo'shish
  Future<void> addProduct(ProductModel product) async {
    await _fireService.addProduct(product);
    await loadProducts();
  }

  // Admin: mahsulot yangilash
  Future<void> updateProduct(ProductModel product) async {
    await _fireService.updateProduct(product);
    final idx = _all.indexWhere((p) => p.id == product.id);
    if (idx >= 0) {
      _all[idx] = product;
      notifyListeners();
    }
  }

  // Admin: mahsulot o'chirish
  Future<void> deleteProduct(String id) async {
    await _fireService.deleteProduct(id);
    _all.removeWhere((p) => p.id == id);
    notifyListeners();
  }

  // Default mahsulotlar (birinchi ishga tushganda)
  Future<void> seedDefaultProducts() async {
    final hasData = await _fireService.hasProducts();
    if (hasData) return;

    final now = DateTime.now();
    final defaults = [
      ProductModel(
        id: _uuid.v4(),
        name: 'Osh (Palov)',
        nameKr: 'Ош (Палов)',
        price: 35000,
        category: 'main_course',
        createdAt: now,
        updatedAt: now,
        sortOrder: 1,
      ),
      ProductModel(
        id: _uuid.v4(),
        name: 'Shurva',
        nameKr: 'Шурва',
        price: 25000,
        category: 'main_course',
        createdAt: now,
        updatedAt: now,
        sortOrder: 2,
      ),
      ProductModel(
        id: _uuid.v4(),
        name: 'Samsa',
        nameKr: 'Самса',
        price: 8000,
        category: 'appetizer',
        createdAt: now,
        updatedAt: now,
        sortOrder: 3,
      ),
      ProductModel(
        id: _uuid.v4(),
        name: 'Non',
        nameKr: 'Нон',
        price: 5000,
        category: 'appetizer',
        createdAt: now,
        updatedAt: now,
        sortOrder: 4,
      ),
      ProductModel(
        id: _uuid.v4(),
        name: "Dimlama",
        nameKr: 'Димлама',
        price: 40000,
        category: 'main_course',
        createdAt: now,
        updatedAt: now,
        sortOrder: 5,
      ),
      ProductModel(
        id: _uuid.v4(),
        name: "Lag'mon",
        nameKr: 'Лағмон',
        price: 30000,
        category: 'main_course',
        createdAt: now,
        updatedAt: now,
        sortOrder: 6,
      ),
      ProductModel(
        id: _uuid.v4(),
        name: 'Choy',
        nameKr: 'Чой',
        price: 5000,
        category: 'beverage',
        createdAt: now,
        updatedAt: now,
        sortOrder: 7,
      ),
      ProductModel(
        id: _uuid.v4(),
        name: 'Kola',
        nameKr: 'Кола',
        price: 8000,
        category: 'beverage',
        createdAt: now,
        updatedAt: now,
        sortOrder: 8,
      ),
      ProductModel(
        id: _uuid.v4(),
        name: 'Muzqaymoq',
        nameKr: 'Музқаймоқ',
        price: 15000,
        category: 'dessert',
        createdAt: now,
        updatedAt: now,
        sortOrder: 9,
      ),
    ];

    for (final p in defaults) {
      await _fireService.addProduct(p);
    }
    _all = defaults;
    notifyListeners();
  }
}
