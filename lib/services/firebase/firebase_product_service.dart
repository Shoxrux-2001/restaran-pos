import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/product_model.dart';
import '../../core/constants/app_constants.dart';

class FirebaseProductService {
  final _db = FirebaseFirestore.instance;
  CollectionReference get _col => _db.collection(AppConstants.colProducts);

  // Barcha mahsulotlarni yuklash (real-time stream)
  Stream<List<ProductModel>> watchProducts() {
    return _col
        .orderBy('sort_order')
        .snapshots()
        .map(
          (snap) => snap.docs
              .map(
                (d) => ProductModel.fromMap(d.data() as Map<String, dynamic>),
              )
              .toList(),
        );
  }

  // Bir marta yuklash
  Future<List<ProductModel>> getProducts() async {
    final snap = await _col.orderBy('sort_order').get();
    return snap.docs
        .map((d) => ProductModel.fromMap(d.data() as Map<String, dynamic>))
        .toList();
  }

  // Mahsulot qo'shish
  Future<void> addProduct(ProductModel product) async {
    await _col.doc(product.id).set(product.toFirestore());
  }

  // Mahsulot yangilash
  Future<void> updateProduct(ProductModel product) async {
    await _col.doc(product.id).update(product.toFirestore());
  }

  // Mahsulot o'chirish
  Future<void> deleteProduct(String id) async {
    await _col.doc(id).delete();
  }

  // Mavjudligini tekshirish (birinchi ishga tushganda)
  Future<bool> hasProducts() async {
    final snap = await _col.limit(1).get();
    return snap.docs.isNotEmpty;
  }
}
