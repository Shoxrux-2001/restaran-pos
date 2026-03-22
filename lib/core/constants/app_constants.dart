class AppConstants {
  AppConstants._();

  // Tax
  static const double taxRate = 0.10; // 10%

  // Admin default parol (Firebase dan o'zgartiriladi)
  static const String defaultAdminPassword = 'admin123';

  // Til
  static const String defaultLanguage = 'uz'; // 'uz' yoki 'kr'

  // Stollar soni
  static const int defaultTableCount = 20;

  // Firestore collection nomlari
  static const String colProducts = 'products';
  static const String colOrders = 'orders';
  static const String colOrderItems = 'order_items';
  static const String colTables = 'tables';
  static const String colUsers = 'users';
  static const String colSettings = 'settings';
  static const String colCategories = 'categories';

  // SharedPreferences keys
  static const String prefLanguage = 'language';
  static const String prefUserId = 'user_id';
  static const String prefUserRole = 'user_role';
  static const String prefUserName = 'user_name';
  static const String prefAdminPassword = 'admin_password';
  static const String prefRestaurantName = 'restaurant_name';

  // Default kategoriyalar
  static const List<String> defaultCategories = [
    'appetizer',
    'main_course',
    'dessert',
    'beverage',
  ];

  // Order statuses
  static const String statusWaiting = 'waiting';
  static const String statusReady = 'ready';
  static const String statusCompleted = 'completed';
  static const String statusCancelled = 'cancelled';

  // User roles
  static const String roleAdmin = 'admin';
  static const String roleWaiter = 'waiter';
  static const String roleCashier = 'cashier';

  // Payment methods
  static const String paymentCash = 'cash';
  static const String paymentCard = 'card';

  // Animation durations
  static const Duration animFast = Duration(milliseconds: 200);
  static const Duration animNormal = Duration(milliseconds: 300);
  static const Duration animSlow = Duration(milliseconds: 500);

  // Snackbar duration
  static const Duration snackDuration = Duration(seconds: 3);
}
