class AppStrings {
  AppStrings._();

  static const Map<String, Map<String, String>> _strings = {
    // ==================== AUTH ====================
    'app_name': {'uz': 'Restoran POS', 'kr': 'Ресторан POS'},
    'login': {'uz': 'Kirish', 'kr': 'Кириш'},
    'logout': {'uz': 'Chiqish', 'kr': 'Чиқиш'},
    'username': {'uz': 'Foydalanuvchi nomi', 'kr': 'Фойдаланувчи номи'},
    'password': {'uz': 'Parol', 'kr': 'Парол'},
    'enter_password': {'uz': 'Parolni kiriting', 'kr': 'Паролни киритинг'},
    'wrong_password': {'uz': 'Parol noto\'g\'ri', 'kr': 'Парол нотўғри'},
    'login_error': {'uz': 'Kirish xatosi', 'kr': 'Кириш хатоси'},

    // ==================== ROLES ====================
    'waiter': {'uz': 'Ofitsiant', 'kr': 'Официант'},
    'cashier': {'uz': 'Kassir', 'kr': 'Кассир'},
    'admin': {'uz': 'Admin', 'kr': 'Админ'},

    // ==================== MAIN ====================
    'menu': {'uz': 'Menyu', 'kr': 'Менью'},
    'all': {'uz': 'Barchasi', 'kr': 'Барчаси'},
    'search': {'uz': 'Qidirish...', 'kr': 'Қидириш...'},
    'no_products': {'uz': 'Mahsulot topilmadi', 'kr': 'Маҳсулот топилмади'},

    // ==================== CATEGORIES ====================
    'appetizer': {'uz': 'Salatlar', 'kr': 'Салатлар'},
    'main_course': {'uz': 'Asosiy taomlar', 'kr': 'Асосий таомлар'},
    'dessert': {'uz': 'Desertlar', 'kr': 'Десертлар'},
    'beverage': {'uz': 'Ichimliklar', 'kr': 'Ичимликлар'},

    // ==================== ORDER ====================
    'order': {'uz': 'Zakaz', 'kr': 'Заказ'},
    'new_order': {'uz': 'Yangi zakaz', 'kr': 'Янги заказ'},
    'order_details': {'uz': 'Zakaz tafsiloti', 'kr': 'Заказ тафсилоти'},
    'select_table': {'uz': 'Stol tanlang', 'kr': 'Стол танланг'},
    'table': {'uz': 'Stol', 'kr': 'Стол'},
    'table_number': {'uz': 'Stol raqami', 'kr': 'Стол рақами'},
    'waiter_name': {'uz': 'Ofitsiant', 'kr': 'Официант'},
    'empty_cart': {
      'uz': 'Zakaz bo\'sh.\nMahsulot qo\'shing',
      'kr': 'Заказ бўш.\nМаҳсулот қўшинг',
    },
    'add_to_order': {'uz': 'Zakazga qo\'sh', 'kr': 'Заказга қўш'},
    'confirm_order': {'uz': 'Zakazni tasdiqlash', 'kr': 'Заказни тасдиқлаш'},
    'cancel_order': {'uz': 'Zakazni bekor qilish', 'kr': 'Заказни бекор қилиш'},

    // ==================== PAYMENT ====================
    'payment': {'uz': 'To\'lov', 'kr': 'Тўлов'},
    'process_payment': {
      'uz': 'To\'lovni amalga oshirish',
      'kr': 'Тўловни амалга ошириш',
    },
    'subtotal': {'uz': 'Jami', 'kr': 'Жами'},
    'tax': {'uz': 'Soliq (10%)', 'kr': 'Солиқ (10%)'},
    'total': {'uz': 'To\'liq summa', 'kr': 'Тўлиқ сумма'},
    'cash': {'uz': 'Naqd pul', 'kr': 'Нақд пул'},
    'card': {'uz': 'Karta', 'kr': 'Карта'},
    'payment_success': {
      'uz': 'To\'lov muvaffaqiyatli!',
      'kr': 'Тўлов муваффақиятли!',
    },
    'print_receipt': {'uz': 'Chek chiqarish', 'kr': 'Чек чиқариш'},
    'new_sale': {'uz': 'Yangi savdo', 'kr': 'Янги савдо'},
    'receipt': {'uz': 'Chek', 'kr': 'Чек'},
    'change': {'uz': 'Qaytim', 'kr': 'Қайтим'},
    'amount_given': {'uz': 'Berilgan summa', 'kr': 'Берилган сумма'},

    // ==================== STATUS ====================
    'status': {'uz': 'Holat', 'kr': 'Ҳолат'},
    'status_waiting': {'uz': 'Kutilmoqda', 'kr': 'Кутилмоқда'},
    'status_ready': {'uz': 'Tayyor', 'kr': 'Тайёр'},
    'status_completed': {'uz': 'Bajarildi', 'kr': 'Бажарилди'},
    'status_cancelled': {'uz': 'Bekor qilindi', 'kr': 'Бекор қилинди'},

    // ==================== HISTORY ====================
    'history': {'uz': 'Tarix', 'kr': 'Тарих'},
    'order_history': {'uz': 'Zakaz tarixi', 'kr': 'Заказ тарихи'},
    'items': {'uz': 'ta', 'kr': 'та'},
    'no_history': {'uz': 'Tarix mavjud emas', 'kr': 'Тарих мавжуд эмас'},
    'today': {'uz': 'Bugun', 'kr': 'Бугун'},
    'yesterday': {'uz': 'Kecha', 'kr': 'Кеча'},
    'this_week': {'uz': 'Bu hafta', 'kr': 'Бу ҳафта'},

    // ==================== ADMIN ====================
    'admin_panel': {'uz': 'Admin panel', 'kr': 'Админ панел'},
    'admin_password': {'uz': 'Admin paroli', 'kr': 'Админ пароли'},
    'enter_admin_password': {
      'uz': 'Admin parolini kiriting',
      'kr': 'Админ паролини киритинг',
    },
    'statistics': {'uz': 'Statistika', 'kr': 'Статистика'},
    'total_sales': {'uz': 'Jami savdo', 'kr': 'Жами савдо'},
    'total_orders': {'uz': 'Jami zakazlar', 'kr': 'Жами заказлар'},
    'products_sold': {
      'uz': 'Sotilgan mahsulotlar',
      'kr': 'Сотилган маҳсулотлар',
    },
    'daily_report': {'uz': 'Kunlik hisobot', 'kr': 'Кунлик ҳисобот'},
    'products': {'uz': 'Mahsulotlar', 'kr': 'Маҳсулотлар'},
    'add_product': {'uz': 'Mahsulot qo\'shish', 'kr': 'Маҳсулот қўшиш'},
    'edit_product': {
      'uz': 'Mahsulotni tahrirlash',
      'kr': 'Маҳсулотни таҳрирлаш',
    },
    'delete_product': {
      'uz': 'Mahsulotni o\'chirish',
      'kr': 'Маҳсулотни ўчириш',
    },
    'product_name': {'uz': 'Mahsulot nomi', 'kr': 'Маҳсулот номи'},
    'product_price': {'uz': 'Narx (so\'m)', 'kr': 'Нарх (сўм)'},
    'product_category': {'uz': 'Kategoriya', 'kr': 'Категория'},
    'save': {'uz': 'Saqlash', 'kr': 'Сақлаш'},
    'cancel': {'uz': 'Bekor qilish', 'kr': 'Бекор қилиш'},
    'delete': {'uz': 'O\'chirish', 'kr': 'Ўчириш'},
    'edit': {'uz': 'Tahrirlash', 'kr': 'Таҳрирлаш'},
    'confirm': {'uz': 'Tasdiqlash', 'kr': 'Тасдиқлаш'},
    'yes': {'uz': 'Ha', 'kr': 'Ҳа'},
    'no': {'uz': 'Yo\'q', 'kr': 'Йўқ'},

    // ==================== ERRORS ====================
    'error': {'uz': 'Xato', 'kr': 'Хато'},
    'no_internet': {
      'uz': 'Internet yo\'q. Offline rejimda ishlayapti.',
      'kr': 'Интернет йўқ. Оффлайн режимда ишлаяпти.',
    },
    'sync_success': {
      'uz': 'Ma\'lumotlar sinxronlashtirildi',
      'kr': 'Маълумотлар синхронлаштирилди',
    },
    'loading': {'uz': 'Yuklanmoqda...', 'kr': 'Юкланмоқда...'},
    'retry': {'uz': 'Qayta urinish', 'kr': 'Қайта уриниш'},

    // ==================== CURRENCY ====================
    'currency': {'uz': 'so\'m', 'kr': 'сўм'},
  };

  static String get(String key, String lang) {
    return _strings[key]?[lang] ?? key;
  }
}
