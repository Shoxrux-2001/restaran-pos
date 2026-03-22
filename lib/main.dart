import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:restoran_pos/services/database/local_database.dart';

import 'firebase_options.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/connectivity_helper.dart';
import 'core/utils/responsive_helper.dart';

import 'services/firebase/firebase_product_service.dart';
import 'services/firebase/firebase_order_service.dart';
import 'services/firebase/firebase_settings_service.dart';
import 'services/sync/sync_service.dart';

import 'viewmodels/auth_viewmodel.dart';
import 'viewmodels/cart_viewmodel.dart';
import 'viewmodels/order_viewmodel.dart';
import 'viewmodels/product_viewmodel.dart';
import 'viewmodels/table_viewmodel.dart';

import 'views/main/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase ulash
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Landscape + portrait
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
    DeviceOrientation.portraitUp,
  ]);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  // Services
  final localDb = LocalDatabase();
  final fireProducts = FirebaseProductService();
  final fireOrders = FirebaseOrderService();
  final fireSettings = FirebaseSettingsService();
  final sync = SyncService(
    local: localDb,
    fireOrders: fireOrders,
    fireProducts: fireProducts,
  );

  runApp(
    MyApp(
      localDb: localDb,
      fireProducts: fireProducts,
      fireOrders: fireOrders,
      fireSettings: fireSettings,
      sync: sync,
    ),
  );
}

class MyApp extends StatelessWidget {
  final LocalDatabase localDb;
  final FirebaseProductService fireProducts;
  final FirebaseOrderService fireOrders;
  final FirebaseSettingsService fireSettings;
  final SyncService sync;

  const MyApp({
    super.key,
    required this.localDb,
    required this.fireProducts,
    required this.fireOrders,
    required this.fireSettings,
    required this.sync,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(
          create: (_) =>
              ProductViewModel(fireService: fireProducts, sync: sync),
        ),
        ChangeNotifierProvider(create: (_) => CartViewModel()),
        ChangeNotifierProvider(
          create: (_) =>
              OrderViewModel(fireService: fireOrders, local: localDb),
        ),
        ChangeNotifierProvider(create: (_) => TableViewModel()),
        // Services — boshqa widgetlar uchun
        Provider.value(value: fireSettings),
        Provider.value(value: localDb),
      ],
      child: MaterialApp(
        title: 'Restoran POS',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const ResponsiveBuilder(child: AppWrapper()),
      ),
    );
  }
}

class AppWrapper extends StatefulWidget {
  const AppWrapper({super.key});
  @override
  State<AppWrapper> createState() => _AppWrapperState();
}

class _AppWrapperState extends State<AppWrapper> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final productVM = context.read<ProductViewModel>();

      // Til yuklash
      await context.read<AuthViewModel>().loadLanguage();

      // Mahsulotlarni yuklash va kerak bo'lsa default qo'shish
      await productVM.loadProducts();
      await productVM.seedDefaultProducts();

      // Faol zakazlarni yuklash (dastur ishga tushganda)
      await context.read<OrderViewModel>().loadHistory();
    });

    // Internet monitoring
    ConnectivityHelper.onConnectivityChanged.listen((isOnline) {
      if (isOnline && mounted) {
        context.read<OrderViewModel>().syncPendingOrders();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const MainScreen();
  }
}
