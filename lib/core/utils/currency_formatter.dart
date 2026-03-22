import 'package:intl/intl.dart';

class CurrencyFormatter {
  CurrencyFormatter._();

  static final _formatter = NumberFormat('#,##0', 'uz_UZ');

  /// 50000 → "50 000 so'm"
  static String format(double amount, {String lang = 'uz'}) {
    final formatted = _formatter.format(amount).replaceAll(',', ' ');
    final currency = lang == 'kr' ? 'сўм' : 'so\'m';
    return '$formatted $currency';
  }

  /// 50000 → "50 000"
  static String formatNumber(double amount) {
    return _formatter.format(amount).replaceAll(',', ' ');
  }

  /// "50000" → 50000.0
  static double parse(String value) {
    final clean = value.replaceAll(' ', '').replaceAll(',', '');
    return double.tryParse(clean) ?? 0;
  }
}
