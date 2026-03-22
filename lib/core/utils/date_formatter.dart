import 'package:intl/intl.dart';

class DateFormatter {
  DateFormatter._();

  static String formatDate(DateTime date, {String lang = 'uz'}) {
    return DateFormat('dd.MM.yyyy').format(date);
  }

  static String formatTime(DateTime date) {
    return DateFormat('HH:mm').format(date);
  }

  static String formatDateTime(DateTime date) {
    return DateFormat('dd.MM.yyyy HH:mm').format(date);
  }

  static String formatRelative(DateTime date, {String lang = 'uz'}) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final dateOnly = DateTime(date.year, date.month, date.day);

    if (dateOnly == today) {
      return lang == 'kr' ? 'Бугун' : 'Bugun';
    } else if (dateOnly == yesterday) {
      return lang == 'kr' ? 'Кеча' : 'Kecha';
    } else {
      return formatDate(date, lang: lang);
    }
  }

  /// Oy nomi
  static String monthName(int month, {String lang = 'uz'}) {
    const uzMonths = [
      'Yanvar',
      'Fevral',
      'Mart',
      'Aprel',
      'May',
      'Iyun',
      'Iyul',
      'Avgust',
      'Sentabr',
      'Oktabr',
      'Noyabr',
      'Dekabr',
    ];
    const krMonths = [
      'Январь',
      'Февраль',
      'Март',
      'Апрель',
      'Май',
      'Июнь',
      'Июль',
      'Август',
      'Сентябрь',
      'Октябрь',
      'Ноябрь',
      'Декабрь',
    ];
    final months = lang == 'kr' ? krMonths : uzMonths;
    return months[month - 1];
  }
}
