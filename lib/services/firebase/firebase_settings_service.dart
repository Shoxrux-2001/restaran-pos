import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseSettingsService {
  final _db = FirebaseFirestore.instance;
  DocumentReference get _doc => _db.collection('settings').doc('restaurant');

  // Sozlamalarni Firestore ga saqlash
  Future<void> saveSettings({
    required String name,
    required String address,
    required String phone,
    required double taxRate,
  }) async {
    await _doc.set({
      'name': name,
      'address': address,
      'phone': phone,
      'tax_rate': taxRate,
      'updated_at': DateTime.now().toIso8601String(),
    }, SetOptions(merge: true));

    // Local ga ham saqlaymiz (offline uchun)
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('rest_name', name);
    await prefs.setString('rest_address', address);
    await prefs.setString('rest_phone', phone);
    await prefs.setDouble('tax_rate', taxRate);
  }

  // Sozlamalarni yuklash (avval local, keyin remote)
  Future<Map<String, dynamic>> loadSettings() async {
    // Avval SharedPreferences dan yuklaymiz (tezroq)
    final prefs = await SharedPreferences.getInstance();
    final localSettings = {
      'name': prefs.getString('rest_name') ?? 'Restoran POS',
      'address': prefs.getString('rest_address') ?? 'Toshkent sh.',
      'phone': prefs.getString('rest_phone') ?? '+998 90 123 45 67',
      'tax_rate': prefs.getDouble('tax_rate') ?? 10.0,
    };

    // Firestore dan yangilashga urinamiz
    try {
      final snap = await _doc.get().timeout(const Duration(seconds: 3));
      if (snap.exists) {
        final data = snap.data() as Map<String, dynamic>;
        // Firestore dagi yangi sozlamalarni local ga ham saqlaymiz
        await prefs.setString(
          'rest_name',
          data['name'] ?? localSettings['name']!,
        );
        await prefs.setString(
          'rest_address',
          data['address'] ?? localSettings['address']!,
        );
        await prefs.setString(
          'rest_phone',
          data['phone'] ?? localSettings['phone']!,
        );
        await prefs.setDouble(
          'tax_rate',
          (data['tax_rate'] ?? localSettings['tax_rate']!).toDouble(),
        );
        return data;
      }
    } catch (_) {
      // Internet yo'q — local ni ishlatamiz
    }
    return localSettings;
  }
}
